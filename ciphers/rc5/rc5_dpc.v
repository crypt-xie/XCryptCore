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
// File name        :   rc5_dpc.v
// Function         :   RC5 Cryptographic Algorithm Core Data Encrypt&Decrypt
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          ：  v-1.0
// Date				:   2019-2-1
// Email            :   xcrypt@126.com
// ------------------------------------------------------------------------------

module rc5_dpc(
	input				i_clk,
	input				i_rst,
	input 				i_flag,
	input  [32*26-1:0] 	i_keyex,
    input  [63:0]   	i_din,
    input           	i_din_en,
    output [63:0]   	o_dout,
    output          	o_dout_en
);

	localparam DLY = 1;
	
	reg  [3:0]	r_count;	
	wire [31:0]	s_a,s_ax,s_ay,s_ay_e,s_ay_d;
	wire [31:0]	s_b,s_bx,s_by,s_by_e,s_by_d;
	wire [63:0] s_din;
	reg  [63:0] r_din;
	reg  [32*22-1:0] r_keyex;
	wire [63:0]	s_pkey;
	wire [63:0]	s_ikey;
	wire [63:0]	s_rkey;
	wire [63:0]	s_pdin;
	wire [4:0]	s_rr_x,s_rr_y;
	wire [31:0]	s_rdin_x,s_rdin_y;
	wire [31:0] s_rdout_x,s_rdout_y;

	function [31:0] SWAP;
		input [31:0] D;
		begin
			SWAP = {D[7:0],D[15:8],D[23:16],D[31:24]};
		end
	endfunction
	
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst) 
			r_count <= #DLY 4'b0;
		else if(i_din_en)
			r_count <= #DLY 4'd1;
		else if(r_count==4'd11) 
			r_count <= #DLY 4'b0;
		else if(r_count!=4'd0)
			r_count <= #DLY r_count + 4'd1;
	end
	
	always@(posedge i_clk  or posedge i_rst) begin
		if(i_rst)
			r_keyex <= #DLY 'b0;
		else if(i_din_en) begin
			if(i_flag)
				r_keyex <= #DLY i_keyex[32*22-1:0];
			else 
				r_keyex <= #DLY i_keyex[32*24-1:32*2];
		end else if(r_count!=5'd0)begin
			if(i_flag)
				r_keyex <= #DLY {r_keyex[32*20-1:0],64'b0};
			else	
				r_keyex <= #DLY {64'b0,r_keyex[32*22-1:64]};
		end
	end 

	assign s_pkey = i_keyex[32*26-1:32*24];   
	assign s_ikey = i_flag ? i_keyex[32*24-1:32*22] : i_keyex[32*2-1:0];
	assign s_rkey = i_flag ? r_keyex[32*22-1:32*20] : r_keyex[32*2-1:0];
	
	assign s_pdin = i_flag ? {(SWAP(i_din[63:32])+s_pkey[63:32]),(SWAP(i_din[31:0])+s_pkey[31:0])} : {SWAP(i_din[63:32]),SWAP(i_din[31:0])};
	assign s_din = i_din_en ? s_pdin : r_din;	
	
	assign s_a = s_din[63:32];
	assign s_b = s_din[31:0];
   // A = ROL(A ^ B, B) + K[0]; //encrypt
   // B = ROL(B ^ A, A) + K[1];	
   // B = ROR(B - K[1], A) ^ A; //decrypt
   // A = ROR(A - K[0], B) ^ B;
	assign s_rr_x = i_flag ? s_b[4:0] : (32-s_a[4:0]);
	assign s_rr_y = i_flag ? s_ay[4:0] : (32-s_by[4:0]);
	assign s_rdin_x = i_flag ? s_a^s_b : (i_din_en ? (s_b-s_ikey[31:0]):(s_b-s_rkey[31:0]));
	assign s_rdin_y = i_flag ? s_ay^s_b : (i_din_en ? (s_a-s_ikey[63:32]):(s_a-s_rkey[63:32]));
	
	rc5_rol u_rol1(.round(s_rr_x),.din(s_rdin_x),.dout(s_rdout_x));
	rc5_rol u_rol2(.round(s_rr_y),.din(s_rdin_y),.dout(s_rdout_y));
	
	assign s_ax = i_flag ? s_rdout_x : s_rdout_y^s_by;
	assign s_bx = i_flag ? s_rdout_y : s_rdout_x^s_a;
	
	assign s_ay_e =  i_din_en ? (s_ax + s_ikey[63:32]):(s_ax + s_rkey[63:32]);
	assign s_by_e =  i_din_en ? (s_bx + s_ikey[31:0]):(s_bx + s_rkey[31:0]);

	assign s_by_d =  s_bx;
	assign s_ay_d =  s_ax;
	
	assign s_ay =  i_flag ? s_ay_e : s_ay_d;
	assign s_by =  i_flag ? s_by_e : s_by_d;
	
	always@(posedge i_clk  or posedge i_rst) begin
		if(i_rst)
			r_din <= #DLY 64'b0;
		else
			r_din <= #DLY {s_ay,s_by};
	end	
		
	assign o_dout = i_flag ? {SWAP(s_ay),SWAP(s_by)} : {SWAP(s_ay-s_pkey[63:32]),SWAP(s_by-s_pkey[31:0])};
	assign o_dout_en = (r_count==4'd11) ? 1'b1:1'b0;
	
endmodule
