/*  
Copyright 2019 XCrypt Studio                
																	 
Licensed under the Apache License, Version 2.0 (the "License");         
you may not use this file except in compliance with the License.        
You may obtain a copy of the License at                                 
																	 
 http://www.apache.org/licenses/LICENSE-2.0                          
																	 
Unless required by applicable law or agreed to in writing, software    
distributed under the License is distributed on an "AS IS" BASIS,       
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and     
limitations under the License.                                          
*/  

// ------------------------------------------------------------------------------
// File name        :   rc6_dpc.v
// Function         :   RC6 Cryptographic Algorithm Core Data Encrypt&Decrypt
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          ：  v-1.0
// Date				:   2019-2-1
// Email            :   xcrypt@126.com
// ------------------------------------------------------------------------------

module rc6_dpc(
	input				i_clk,
	input				i_rst,
	input 				i_flag,
	input  [32*44-1:0] 	i_keyex,
    input  [127:0]   	i_din,
    input           	i_din_en,
    output [127:0]   	o_dout,
    output          	o_dout_en
);

	localparam DLY = 1;
	
	reg  [4:0]		r_count;	
	wire [31:0]		s_a,s_ax,s_ay,s_ay_e,s_ay_d;
	wire [31:0]		s_b;
	wire [31:0]		s_c,s_cx,s_cy,s_cy_e,s_cy_d;
	wire [31:0]		s_d;	
	wire [127:0] 	s_din;
	reg  [127:0] 	r_din;
	reg  [32*38-1:0] r_keyex;
	wire [63:0]		s_fkey;
	wire [63:0]		s_lkey;
	wire [63:0]		s_ikey;
	wire [63:0]		s_rkey;
	wire [127:0]	s_pdin;
	wire [4:0]		s_rr_x,s_rr_y;
	wire [31:0]		s_rdin_x,s_rdin_y;
	wire [31:0] 	s_rdout_x,s_rdout_y;
	wire [31:0]		s_t,s_u;

	function [31:0] SWAP;
		input [31:0] D;
		begin
			SWAP = {D[7:0],D[15:8],D[23:16],D[31:24]};
		end
	endfunction
	
	function [31:0]	ROL5;
		input [31:0] D;
		begin
			ROL5 = {D[26:0],D[31:27]};
		end
	endfunction 
	
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst) 
			r_count <= #DLY 5'b0;
		else if(i_din_en)
			r_count <= #DLY 5'd1;
		else if(r_count==5'd19) 
			r_count <= #DLY 5'b0;
		else if(r_count!=5'd0)
			r_count <= #DLY r_count + 5'd1;
	end
	
	always@(posedge i_clk  or posedge i_rst) begin
		if(i_rst)
			r_keyex <= #DLY 'b0;
		else if(i_din_en) begin
			if(i_flag)
				r_keyex <= #DLY i_keyex[32*40-1:32*2];
			else 
				r_keyex <= #DLY i_keyex[32*42-1:32*4];
		end else if(r_count!=5'd0)begin
			if(i_flag)
				r_keyex <= #DLY {r_keyex[32*36-1:0],64'b0};
			else	
				r_keyex <= #DLY {64'b0,r_keyex[32*38-1:64]};
		end
	end 

	assign s_fkey = i_flag ? i_keyex[32*44-1:32*42]:i_keyex[32*2-1:0];  //first
	assign s_lkey = i_flag ? i_keyex[32*2-1:0]:i_keyex[32*44-1:32*42];  //last
	assign s_ikey = i_flag ? i_keyex[32*42-1:32*40] : i_keyex[32*4-1:32*2];
	assign s_rkey = i_flag ? r_keyex[32*38-1:32*36] : r_keyex[32*2-1:0];
	
	assign s_pdin = i_flag ? {SWAP(i_din[127:96]),(SWAP(i_din[95:64])+s_fkey[63:32]),SWAP(i_din[63:32]),(SWAP(i_din[31:0])+s_fkey[31:0])} 
						: {SWAP(i_din[127:96])-s_fkey[63:32],SWAP(i_din[95:64]),SWAP(i_din[63:32])-s_fkey[31:0],SWAP(i_din[31:0])};
						
	assign s_din = i_din_en ? s_pdin : r_din;	
	
	assign s_a = i_flag ? s_din[127:96] : s_din[31:0];
	assign s_b = i_flag ? s_din[95:64] : s_din[127:96];
	assign s_c = i_flag ? s_din[63:32] : s_din[95:64];
	assign s_d = i_flag ? s_din[31:0] : s_din[63:32];	
	
	//---ENCRYPT---
	   // for (r = 0; r < 20; r += 4) {
       // RND(a,b,c,d);
       // RND(b,c,d,a);
       // RND(c,d,a,b);
       // RND(d,a,b,c);
   // }
       // t = (b * (b + b + 1)); t = ROLc(t, 5); \ encrypt
       // u = (d * (d + d + 1)); u = ROLc(u, 5); \
       // a = ROL(a^t,u) + K[0];                \
       // c = ROL(c^u,t) + K[1]; K += 2;
	//---DECRYPT---
       // for (r = 0; r < 20; r += 4) {
       // 	RND(d,a,b,c);
       // 	RND(c,d,a,b);
       // 	RND(b,c,d,a);
       // 	RND(a,b,c,d);
	   // }
       // t = (b * (b + b + 1)); t = ROLc(t, 5); \ decrypt
       // u = (d * (d + d + 1)); u = ROLc(u, 5); \
       // c = ROR(c - K[1], t) ^ u; \
       // a = ROR(a - K[0], u) ^ t; K -= 2;
	   
	assign s_t = ROL5(s_b*(s_b + s_b + 1));
	assign s_u = ROL5(s_d*(s_d + s_d + 1));
	assign s_rr_x = i_flag ? s_u[4:0] : (32-s_t[4:0]); 
	assign s_rr_y = i_flag ? s_t[4:0] : (32-s_u[4:0]);
	assign s_rdin_x = i_flag ? s_a^s_t : (i_din_en ? (s_c-s_ikey[31:0]):(s_c-s_rkey[31:0]));
	assign s_rdin_y = i_flag ? s_c^s_u : (i_din_en ? (s_a-s_ikey[63:32]):(s_a-s_rkey[63:32]));
	
	rc6_rol u_rol1(.round(s_rr_x),.din(s_rdin_x),.dout(s_rdout_x));
	rc6_rol u_rol2(.round(s_rr_y),.din(s_rdin_y),.dout(s_rdout_y));
	
	assign s_ax = i_flag ? s_rdout_x : s_rdout_y^s_t;
	assign s_cx = i_flag ? s_rdout_y : s_rdout_x^s_u;
	
	assign s_ay_e =  i_din_en ? (s_ax + s_ikey[63:32]):(s_ax + s_rkey[63:32]);
	assign s_cy_e =  i_din_en ? (s_cx + s_ikey[31:0]):(s_cx + s_rkey[31:0]);

	assign s_cy_d =  s_cx;
	assign s_ay_d =  s_ax;
	
	assign s_ay =  i_flag ? s_ay_e : s_ay_d;
	assign s_cy =  i_flag ? s_cy_e : s_cy_d;
	
	always@(posedge i_clk  or posedge i_rst) begin
		if(i_rst)
			r_din <= #DLY 64'b0;
		else if(i_flag)
			r_din <= #DLY {s_b,s_cy,s_d,s_ay};
		else 
			r_din <= #DLY {s_ay,s_b,s_cy,s_d};
	end	
		
	assign o_dout = i_flag ? {SWAP(s_b+s_lkey[63:32]),SWAP(s_cy),SWAP(s_d+s_lkey[31:0]),SWAP(s_ay)} 
						: {SWAP(s_ay),SWAP(s_b-s_lkey[63:32]),SWAP(s_cy),SWAP(s_d-s_lkey[31:0])};
						
	assign o_dout_en = (r_count==5'd19) ? 1'b1:1'b0;
	
endmodule
