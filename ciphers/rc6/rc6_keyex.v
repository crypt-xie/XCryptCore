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
// File name        :   rc6_keyex.v
// Function         :   RC6 Cryptographic Algorithm Core Cacate Round KEY(KeyLen = 16)
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          ：  v-1.0
// Date				:   2019-2-1
// Email            :   xcrypt@126.com
// ------------------------------------------------------------------------------

module rc6_keyex(
	input 				i_clk,
	input 				i_rst,
	input 	[127:0]	 	i_key,		//key
	input 				i_key_en,	//key init flag
	output 	[32*44-1:0]	o_exkey,  	//round key
	output 				o_key_ok  	//key init ok
	);
	
	localparam DLY = 1;
	localparam [32*44-1:0] STAB = {
		32'hb7e15163, 32'h5618cb1c, 32'hf45044d5, 32'h9287be8e,
		32'h30bf3847, 32'hcef6b200, 32'h6d2e2bb9, 32'h0b65a572,
		32'ha99d1f2b, 32'h47d498e4, 32'he60c129d, 32'h84438c56,
		32'h227b060f, 32'hc0b27fc8, 32'h5ee9f981, 32'hfd21733a,
		32'h9b58ecf3, 32'h399066ac, 32'hd7c7e065, 32'h75ff5a1e,
		32'h1436d3d7, 32'hb26e4d90, 32'h50a5c749, 32'heedd4102,
		32'h8d14babb, 32'h2b4c3474, 32'hc983ae2d, 32'h67bb27e6,
		32'h05f2a19f, 32'ha42a1b58, 32'h42619511, 32'he0990eca,
		32'h7ed08883, 32'h1d08023c, 32'hbb3f7bf5, 32'h5976f5ae,
		32'hf7ae6f67, 32'h95e5e920, 32'h341d62d9, 32'hd254dc92,
		32'h708c564b, 32'h0ec3d004, 32'hacfb49bd, 32'h4b32c376};
	
	wire 	[127:0]		s_ikey;
	wire 	[31:0]		s_sk;
	wire 	[31:0]		s_lk;
	wire 	[31:0]		s_a,s_ax;
	wire 	[31:0]		s_b,s_bx;
	reg  	[127:0]		r_key;
	reg		[32*44-1:0]	r_exkey;
	reg 	[7:0]		r_count;
	reg 				r_key_ok;
	wire 				s_busy;
	wire 	[31:0]		s_tmp;
	
	function [31:0] SWAP;
		input [31:0] D;
		begin
			SWAP = {D[7:0],D[15:8],D[23:16],D[31:24]};
		end
	endfunction
	
	assign s_ikey = {SWAP(i_key[127:96]),SWAP(i_key[95:64]),SWAP(i_key[63:32]),SWAP(i_key[31:0])};
	
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst)
			r_key <= #DLY 128'b0;
		else if(i_key_en)
			r_key <= #DLY {s_ikey[95:0],s_bx};
		else if(s_busy)
			r_key <= #DLY {r_key[95:0],s_bx};
	end	
	
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst) 
			r_exkey <= #DLY 1408'b0;
		else if(i_key_en)
			r_exkey <= #DLY {STAB[32*43-1:0],s_ax};
		else if(s_busy)begin
			r_exkey <= #DLY {r_exkey[32*43-1:0],s_ax};
		end
	end	

	assign s_a = i_key_en ? 32'b0 : r_exkey[31:0];
	assign s_b = i_key_en ? 32'b0 : r_key[31:0];
	assign s_lk = i_key_en ? s_ikey[127:96] : r_key[127:96];
	assign s_sk = i_key_en ? STAB[32*44-1:32*43]: r_exkey[32*44-1:32*43];
	assign s_tmp = s_ax+s_b;

	rc6_rol u_rol1(.round(5'd3),.din((s_sk + s_a + s_b)),.dout(s_ax)); //S
	rc6_rol u_rol2(.round(s_tmp[4:0]),.din((s_lk + s_ax + s_b)),.dout(s_bx)); //L
	
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst)
			r_count <= #DLY 8'd0;
		else if(i_key_en)
			r_count <= #DLY 8'd1;
		else if(r_count==8'd131)
			r_count <= #DLY 7'd0;
		else if(r_count!=8'd0)
			r_count <= #DLY r_count + 8'd1;
	end

	assign o_exkey = r_exkey;

	assign s_busy = ((r_count!=8'd0)||(i_key_en==1'b1)) ? 1'b1 : 1'b0;
	
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst)
			r_key_ok <= #DLY 1'b0;
		else if(r_count==8'd131)
			r_key_ok <= #DLY 1'b1;
		else if(i_key_en==1'b1)
			r_key_ok <= #DLY 1'b0;
	end
	
	assign o_key_ok = r_key_ok&(~i_key_en);
	
endmodule

