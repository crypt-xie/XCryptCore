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
// File name        :   sm4_keyex.v
// Function         :   SM4 Cryptographic Algorithm Core Caculate Round KEY [round-32]
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          £º  v-1.0
// Date				:   2019-2-1
// Email            :   xcrypt@126.com
// ------------------------------------------------------------------------------

module sm4_keyex(
	input 				i_clk,
	input 				i_rst,
	input  [127:0]	 	i_key,		//key
	input 				i_key_en,	//key init flag
	output [128*8-1:0]	o_exkey,  	//round key
	output 				o_key_ok,  	//key init ok
	output				o_sbox_use,
	output [31:0]		o_sbox_din,
	input  [31:0]		i_sbox_dout
	);
	
	localparam DLY = 1;		
	localparam [127:0] FK = {32'hb27022dc,32'h677d9197,32'h56aa3350,32'ha3b1bac6};
        
    reg     [4:0]       r_count;
    reg     [1023:0]    r_exkey;
	reg 	[127:0]		r_key;	
	reg 				r_key_ok;
	wire 	[127:0]		s_key;
	wire 	[31:0]		s_rk_next;
	wire 	[31:0]		s_ck;
    wire                s_busy;	
	
	function [31:0] Lr;
		input [31:0] D;
		begin
			Lr= D^{D[18:0],D[31:19]}^{D[8:0],D[31:9]};
		end
	endfunction;
		
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst) begin
			r_exkey <= #DLY 1024'b0;
		end else if(s_busy)begin
			r_exkey <= #DLY {r_exkey[32*31-1:0],s_rk_next};
		end
	end	
	
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst)
			r_count <= #DLY 5'd0;
		else if(i_key_en)
			r_count <= #DLY 5'd1;
		else if(r_count!=4'd0)
			r_count <= #DLY r_count + 5'd1;
	end	
	
	assign s_busy = ((r_count!=5'd0)||(i_key_en==1'b1)) ? 1'b1 : 1'b0;	
	
	assign s_key = i_key_en ? i_key^FK : r_key;
	assign s_rk_next = s_key[31:0]^Lr(i_sbox_dout);
	
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst)
			r_key <= #DLY 128'b0;
		else if(s_busy)
			r_key <= #DLY {s_rk_next,s_key[127:32]};
	end		

	//Round CK
	sm4_ck u_ck(.round	(r_count),.dout	(s_ck));

	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst)
			r_key_ok <= #DLY 1'b0;
		else if(i_key_en)
			r_key_ok <= #DLY 1'b0;
		else if(r_count==5'd31)
			r_key_ok <= #DLY 1'b1;

	end

	assign o_key_ok = r_key_ok&(~i_key_en);
	assign o_exkey = r_exkey;
	
	assign o_sbox_din = s_key[127:96]^s_key[95:64]^s_key[63:32]^s_ck;	
	assign o_sbox_use = s_busy;	
	
endmodule
