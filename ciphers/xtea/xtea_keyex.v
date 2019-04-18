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
// File name        :   xtea_keyex.v
// Function         :   XTEA Cryptographic Algorithm Core Caculate Round KEY
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          ：  v-1.0
// Date				:   2019-1-23
// Email            :   xcrypt@126.com
// ------------------------------------------------------------------------------

module xtea_keyex(
	input 				i_clk,
	input 				i_rst,
	input 	[127:0] 	i_key,
	input 				i_key_en,
	output 	[1023:0]	o_exkey_a,
	output	[1023:0]	o_exkey_b,
	output 				o_key_ok
	);
	
	localparam DLY = 1;

	wire 				s_busy;
	wire 	[31:0]		s_sum;
	wire 	[31:0]		s_exka;
	wire 	[31:0]		s_exkb;
	
	reg 	[31:0]		r_sum;
	reg 	[1023:0]	r_exkey_a;
	reg 	[1023:0]	r_exkey_b;
	reg 	[4:0]		r_count;
	reg 				r_key_ok;
		
	function [31:0]	WS;
		input [127:0] D;
		input [1:0]	S;
		begin
			WS = (S==2'd0) ? D[127:96]:
				((S==2'd1) ? D[95:64]:
				((S==2'd2) ? D[63:32]:
				((S==2'd3) ? D[31:0]:32'b0)));
		end
	endfunction	
	
	//assign s_key = {SWAP(i_key[127:96]),SWAP(i_key[95:64]),SWAP(i_key[63:32]),SWAP(i_key[31:0])};
	assign s_sum = i_key_en ? 32'h9E37_79B9:(r_sum + 32'h9E37_79B9);
	
	assign s_exka = i_key_en ? WS(i_key,2'b0):(r_sum + WS(i_key,r_sum[1:0]));
	assign s_exkb = s_sum + WS(i_key,s_sum[12:11]);
	
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst)
			r_sum <= #DLY 32'b0;
		else if(s_busy)
			r_sum <= #DLY s_sum;
	end
	
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst) begin
			r_exkey_a <= #DLY 1024'b0;
		end else if(s_busy)begin
			r_exkey_a <= #DLY {r_exkey_a[991:0],s_exka};
		end
	end

	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst) begin
			r_exkey_b <= #DLY 1024'b0;
		end else if(s_busy)begin
			r_exkey_b <= #DLY {r_exkey_b[991:0],s_exkb};
		end
	end	
	
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst) 
			r_count <= #DLY 5'd0;
		else if(r_count!=6'd0)
			r_count <= #DLY r_count + 5'b1;
		else if(i_key_en)
			r_count <= #DLY 5'b1;
	end

	assign o_exkey_a = r_exkey_a;
	assign o_exkey_b = r_exkey_b;
	
	assign s_busy = ((r_count!=5'd0)||(i_key_en==1'b1)) ? 1'b1 : 1'b0;

	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst)
			r_key_ok <= #DLY 1'b0;
		else if(r_count=='d31)
			r_key_ok <= #DLY 1'b1;
		else if(i_key_en==1'b1)
			r_key_ok <= #DLY 1'b0;
	end
	
	assign o_key_ok = r_key_ok&(~i_key_en);

endmodule