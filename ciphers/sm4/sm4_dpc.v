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
// File name        :   sm4_dpc.v
// Function         :   SM4 Cryptographic Algorithm Core Data Encrypt&Decrypt
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          £º  v-1.0
// Date				:   2019-2-1
// Email            :   xcrypt@126.com
// ------------------------------------------------------------------------------

module sm4_dpc(
	input				i_clk,
	input				i_rst,
	input 				i_flag,  //1-encrpt,0-decrypt
	input  [1023:0] 	i_keyex,
    input  [127:0]   	i_din,
    input           	i_din_en,
    output [127:0]   	o_dout,
    output          	o_dout_en,
	output [31:0]		o_sbox_din,
	input  [31:0]		i_sbox_dout
);

	localparam DLY = 1;
	
	reg  [4:0]	 r_count;	
	reg  [127:0] r_din;
    reg [1023:0] r_keyex;
	wire [127:0] s_din;
	wire [31:0]  s_ikey;
	wire [31:0]  s_rkey;
	
	
	function [127:0] SWAP;
		input [127:0] D;
		begin
			SWAP = {D[31:0],D[63:32],D[95:64],D[127:96]};
		end
	endfunction
	
	function [31:0] L;
		input [31:0] D;
		begin
			L= D^{D[29:0],D[31:30]}^{D[21:0],D[31:22]}^{D[13:0],D[31:14]}^{D[7:0],D[31:8]};
		end
	endfunction
	
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst) 
			r_count <= #DLY 5'b0;
		else if(i_din_en)
			r_count <= #DLY 5'd1;
		else if(r_count!=5'd0)
			r_count <= #DLY r_count + 5'd1;
	end
	
	always@(posedge i_clk  or posedge i_rst) begin
		if(i_rst)
			r_keyex <= #DLY 1024'b0;
		else if(i_din_en) begin
			if(i_flag)
				r_keyex <= #DLY {i_keyex[32*31-1:0],32'b0};
			else 
				r_keyex <= #DLY {32'b0,i_keyex[32*32-1:32]};
		end else if(r_count!=5'd0)begin
			if(i_flag)
				r_keyex <= #DLY {r_keyex[32*31-1:0],32'b0};
			else	
				r_keyex <= #DLY {32'b0,r_keyex[32*32-1:32]};
		end
	end 
	 	
	assign s_ikey = i_flag ? i_keyex[32*32-1:32*31] : i_keyex[31:0];
	assign s_rkey = i_flag ? r_keyex[32*32-1:32*31] : r_keyex[31:0];
	
	assign s_din = i_din_en ? i_din : r_din;	
	assign o_sbox_din = i_din_en ? (s_ikey^s_din[127:96]^s_din[95:64]^s_din[63:32]):(s_rkey^s_din[127:96]^s_din[95:64]^s_din[63:32]);

	always@(posedge i_clk  or posedge i_rst) begin
		if(i_rst)
			r_din <= #DLY 128'b0;
		else
			r_din <= #DLY {L(i_sbox_dout)^s_din[31:0],s_din[127:32]};
	end	
	
	assign o_dout = SWAP({L(i_sbox_dout)^s_din[31:0],s_din[127:32]});	
	assign o_dout_en = (r_count==5'd31) ? 1'b1:1'b0;
	
endmodule
