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
// File name        :   cast5_dpc.v
// Function         :   CAST5 Cryptographic Algorithm Core Data Encrypt&Decrypt 
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          ：  v-1.0
// Date				:   2019-2-3
// Email            :   xcrypt@126.com
// ------------------------------------------------------------------------------

module cast5_dpc(
	input				i_clk,
	input				i_rst,
	input 				i_flag,
	input  [32*32-1:0] 	i_keyex,
    input  [63:0]   	i_din,
    input           	i_din_en,
    output [63:0]   	o_dout,
    output          	o_dout_en,
	output [31:0]		o_sbox_din,
	input  [127:0]		i_sbox_dout
);

	localparam DLY = 1;
	
	reg  [3:0]		r_count;	
	wire [63:0] 	s_din;
	reg  [63:0] 	r_din;	
	wire [63:0]		s_ikey;
	wire [63:0]		s_rkey;
	wire [4:0]		s_rr_x;
	wire [31:0]		s_rdin_x;
	wire [31:0] 	s_rdout_x;
	reg  [32*15-1:0] r_keyex_h;
	reg  [32*15-1:0] r_keyex_l;
	wire [1:0]		s_op_a,s_op_b;
	reg  [5:0]		r_op;
	wire [31:0]		s_l,s_r;
	wire 			s_busy;
	reg 			r_dout_en;
	
	function [31:0] FIA;
		input [31:0] D;
		input [31:0] K;
		input [1:0]  S;
		begin
			FIA = (S==2'd1) ? (K + D) :
				 ((S==2'd2) ? (K ^ D) :
				 ((S==2'd3) ? (K - D) : 32'b0));
		end
	endfunction
	
	function [31:0] FIB;
		input [127:0] D;
		input [1:0] S;
		begin
			FIB = (S==2'd1) ? (((D[127:96]^D[95:64])-D[63:32])+D[31:0]) :
				 ((S==2'd2) ? (((D[127:96]-D[95:64])+D[63:32])^D[31:0]) :
				 ((S==2'd3) ? (((D[127:96]+D[95:64])^D[63:32])-D[31:0]) : 32'b0)); 
		end
	endfunction	
	
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst)
			r_op <= #DLY  6'b0;
		else if(i_din_en) 
			r_op <= #DLY (i_flag ? 6'b101101:6'b111001);
		else if(s_busy) 
			r_op <= #DLY {r_op[3:0],r_op[5:4]};
	end
	
	assign s_op_a = i_din_en ? 2'b01 : r_op[5:4];
	assign s_op_b = r_op[1:0];
	
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst) 
			r_count <= #DLY 4'b0;
		else if(i_din_en)
			r_count <= #DLY 4'd1;
		else if(r_count!=4'd0)
			r_count <= #DLY r_count + 4'd1;
	end
	
	always@(posedge i_clk  or posedge i_rst) begin
		if(i_rst)
			r_keyex_h <= #DLY 'b0;
		else if(i_din_en) begin
			if(i_flag)
				r_keyex_h <= #DLY i_keyex[32*31-1:32*16];
			else 
				r_keyex_h <= #DLY i_keyex[32*32-1:32*17];
		end else if(r_count!=5'd0)begin
			if(i_flag)
				r_keyex_h <= #DLY {r_keyex_h[32*14-1:0],32'b0};
			else	
				r_keyex_h <= #DLY {32'b0,r_keyex_h[32*15-1:32]};
		end
	end 

	always@(posedge i_clk  or posedge i_rst) begin
		if(i_rst)
			r_keyex_l <= #DLY 'b0;
		else if(i_din_en) begin
			if(i_flag)
				r_keyex_l <= #DLY i_keyex[32*15-1:0];
			else 
				r_keyex_l <= #DLY i_keyex[32*16-1:32];
		end else if(r_count!=5'd0)begin
			if(i_flag)
				r_keyex_l <= #DLY {r_keyex_l[32*14-1:0],32'b0};
			else	
				r_keyex_l <= #DLY {32'b0,r_keyex_l[32*15-1:32]};
		end
	end 
	
	assign s_ikey = i_flag ? {i_keyex[32*32-1:32*31],i_keyex[32*16-1:32*15]} : {i_keyex[32*17-1:32*16],i_keyex[32*1-1:0]};
	assign s_rkey = i_flag ? {r_keyex_h[32*15-1:32*14],r_keyex_l[32*15-1:32*14]} : {r_keyex_h[32*1-1:0],r_keyex_l[32*1-1:0]};
						
	assign s_din = i_din_en ? i_din : {r_din[31:0],r_din[63:32]^FIB(i_sbox_dout,s_op_b)};	
	
	assign s_l = s_din[63:32];
	assign s_r = s_din[31:0];
	
	assign s_rr_x = i_din_en ? s_ikey[4:0] : s_rkey[4:0];
	assign s_rdin_x = i_din_en ? FIA(s_r,s_ikey[63:32],s_op_a) :FIA(s_r,s_rkey[63:32],s_op_a);
	   
	cast5_rol u_rol(.round(s_rr_x),.din(s_rdin_x),.dout(s_rdout_x));
	
	assign o_sbox_din = s_rdout_x;
	assign s_busy = (i_din_en|(r_count!='d0)) ? 1'b1 : 1'b0;
	
	always@(posedge i_clk  or posedge i_rst) begin
		if(i_rst)
			r_din <= #DLY 64'b0;
		else if(i_din_en)
			r_din <= #DLY i_din;
		else
			r_din <= #DLY {r_din[31:0],r_din[63:32]^FIB(i_sbox_dout,s_op_b)};
	end	
		
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst) 
			r_dout_en <= #DLY 1'b0;
		else if(r_count ==4'd15)
			r_dout_en <= #DLY 1'b1;
		else	
			r_dout_en <= #DLY 1'b0;
	end
	
	assign o_dout_en = r_dout_en;
	assign o_dout = {r_din[63:32]^FIB(i_sbox_dout,s_op_b),r_din[31:0]};
		
endmodule
