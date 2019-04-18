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
// File name        :   tiger_key_sch.v
// Function         :   Tiger Hash Algorithm Key Schedule
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          £º  v-1.0
// Date				:   2019-1-23
// Email            :   xcrypt@126.com
// ------------------------------------------------------------------------------

module tiger_key_sch(
	input 			i_clk,
	input	[511:0]	i_key,
	output	[511:0]	o_key
	);
	
	localparam DLY = 1;
	
	wire [63:0]	s_x  [7:0];
	wire [63:0]	s_xa [7:0];
	wire [63:0]	s_xb [7:0];
	
	reg  [63:0]	r_xa [7:0];
	
	function [63:0]	LS19;
		input [63:0] D;
		begin
			LS19 = {D[44:0],19'b0};
		end
	endfunction;
	
	function [63:0]	RS23;
		input [63:0] D;
		begin
			RS23 = {23'b0,D[63:23]};
		end
	endfunction;	
		
	assign s_x[0] = i_key[64*8-1:64*7];
	assign s_x[1] = i_key[64*7-1:64*6];
	assign s_x[2] = i_key[64*6-1:64*5];
	assign s_x[3] = i_key[64*5-1:64*4];
	assign s_x[4] = i_key[64*4-1:64*3];
	assign s_x[5] = i_key[64*3-1:64*2];
	assign s_x[6] = i_key[64*2-1:64*1];
	assign s_x[7] = i_key[64*1-1:64*0];
		
	assign s_xa[0] = s_x[0] - (s_x[7] ^ 64'ha5a5a5a5_a5a5a5a5);
	assign s_xa[1] = s_x[1] ^ s_xa[0];
	assign s_xa[2] = s_x[2] + s_xa[1];
	assign s_xa[3] = s_x[3] - (s_xa[2] ^ LS19(~s_xa[1]));
	assign s_xa[4] = s_x[4] ^ s_xa[3];
	assign s_xa[5] = s_x[5] + s_xa[4];
	assign s_xa[6] = s_x[6] - (s_xa[5] ^ RS23(~s_xa[4]));
	assign s_xa[7] = s_x[7] ^ s_xa[6];
	
	always@(posedge i_clk) begin
		r_xa[0] <= #DLY s_xa[0];
		r_xa[1] <= #DLY s_xa[1];
		r_xa[2] <= #DLY s_xa[2];
		r_xa[3] <= #DLY s_xa[3];
		r_xa[4] <= #DLY s_xa[4];
		r_xa[5] <= #DLY s_xa[5];
		r_xa[6] <= #DLY s_xa[6];
		r_xa[7] <= #DLY s_xa[7];
	end
	
	assign s_xb[0] = r_xa[0] + r_xa[7];
	assign s_xb[1] = r_xa[1] - (s_xb[0] ^ LS19(~r_xa[7]));
	assign s_xb[2] = r_xa[2] ^ s_xb[1];
	assign s_xb[3] = r_xa[3] + s_xb[2];
	assign s_xb[4] = r_xa[4] - (s_xb[3] ^ RS23(~s_xb[2]));
	assign s_xb[5] = r_xa[5] ^ s_xb[4];
	assign s_xb[6] = r_xa[6] + s_xb[5];
	assign s_xb[7] = r_xa[7] - (s_xb[6] ^ 64'h01234567_89abcdef);
				
	assign o_key[64*8-1:64*7] = s_xb[0];
	assign o_key[64*7-1:64*6] = s_xb[1];
	assign o_key[64*6-1:64*5] = s_xb[2];
	assign o_key[64*5-1:64*4] = s_xb[3];
	assign o_key[64*4-1:64*3] = s_xb[4];
	assign o_key[64*3-1:64*2] = s_xb[5];
	assign o_key[64*2-1:64*1] = s_xb[6];
	assign o_key[64*1-1:64*0] = s_xb[7];	
	
	
endmodule