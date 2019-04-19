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
// File name        :   sha1_core.v
// Function         :   SHA1 Hash Algorithm Core 
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          :   v-1.0
// Date				:   2019-1-24
// Email            :   xcrypt@126.com
// ------------------------------------------------------------------------------

module sha1_core(	
	input 			i_clk,      //clock 
	input			i_rst,      //reset high valid
	input			i_start,    //high valid(only one clock)
	input	[511:0]	i_data,		//hash data input
	input	[159:0]	i_vin,		//hash init value input(not change before o_done valid)
	output	[159:0]	o_vout,     //hash value output   
	output			o_done);    //high valid(only one clock) 

	localparam K0 = 32'h5A827999;
	localparam K1 = 32'h6ED9EBA1;
	localparam K2 = 32'h8F1BBCDC;
	localparam K3 = 32'hCA62C1D6;
	
	reg 		r_done;
	reg [6:0]	r_count;
	reg [31:0]	r_a,r_b,r_c,r_d,r_e;
	reg [511:0]	r_w;
	reg [2:0]	r_state;
	
	function [31:0]	FF0;
		input	[31:0]	A,B,C,D,E,W,K;
		begin
			FF0 = {A[26:0],A[31:27]} + ((B&C)|((~B)&D)) + E + W + K;
		end
	endfunction

	function [31:0]	FF1;
		input	[31:0]	A,B,C,D,E,W,K;
		begin
			FF1 = {A[26:0],A[31:27]} + (B^C^D) + E + W + K;
		end
	endfunction

	function [31:0]	FF2;
		input	[31:0]	A,B,C,D,E,W,K;
		begin
			FF2 = {A[26:0],A[31:27]} + ((B&C)|(B&D)|(C&D)) + E + W + K;
		end
	endfunction
	
	//SHA1CircularShift(1,W)
	function [31:0] ROL0;
		input [31:0] W;
		begin
			ROL0 = {W[30:0],W[31]};
		end
	endfunction

	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst) begin
			r_done <= 1'b0;
			r_count <= 7'b0;
			r_a <= 32'b0;
			r_b <= 32'b0;
			r_c <= 32'b0;
			r_d <= 32'b0;
			r_e <= 32'b0;
			r_w <= 512'b0;
			r_state <= 3'd0;
		end else begin
			case(r_state)
				3'd0: begin
					r_done <= 1'b0;
					r_count <= 7'b0;
					if(i_start) begin
						r_a <= i_vin[159:128];
						r_b <= i_vin[127:96];
						r_c <= i_vin[95:64];
						r_d <= i_vin[63:32];
						r_e <= i_vin[31:0];	
						r_w <= i_data;
						r_state <= 3'd1;
					end
				end
				3'd1: begin
					r_count <= r_count + 7'b1;
					r_a <= FF0(r_a,r_b,r_c,r_d,r_e,r_w[511:480],K0);
					r_b <= r_a;
					r_c <= {r_b[1:0],r_b[31:2]};
					r_d <= r_c;
					r_e <= r_d;
					r_w <= {r_w[479:0],ROL0(r_w[32*3-1:32*2]^r_w[32*8-1:32*7]^r_w[32*14-1:32*13]^r_w[32*16-1:32*15])};
					if(r_count==7'd19) begin
						r_state <= 3'd2;
					end
				end
				3'd2: begin
					r_count <= r_count + 7'b1;
					r_a <= FF1(r_a,r_b,r_c,r_d,r_e,r_w[511:480],K1);
					r_b <= r_a;
					r_c <= {r_b[1:0],r_b[31:2]};
					r_d <= r_c;
					r_e <= r_d;
					r_w <= {r_w[479:0],ROL0(r_w[32*3-1:32*2]^r_w[32*8-1:32*7]^r_w[32*14-1:32*13]^r_w[32*16-1:32*15])};
					if(r_count==7'd39) begin
						r_state <= 3'd3;
					end				
				end
				3'd3: begin
					r_count <= r_count + 7'b1;
					r_a <= FF2(r_a,r_b,r_c,r_d,r_e,r_w[511:480],K2);
					r_b <= r_a;
					r_c <= {r_b[1:0],r_b[31:2]};
					r_d <= r_c;
					r_e <= r_d;
					r_w <= {r_w[479:0],ROL0(r_w[32*3-1:32*2]^r_w[32*8-1:32*7]^r_w[32*14-1:32*13]^r_w[32*16-1:32*15])};
					if(r_count==7'd59) begin
						r_state <= 3'd4;
					end				
				end			
				3'd4: begin
					r_count <= r_count + 7'b1;
					r_a <= FF1(r_a,r_b,r_c,r_d,r_e,r_w[511:480],K3);
					r_b <= r_a;
					r_c <= {r_b[1:0],r_b[31:2]};
					r_d <= r_c;
					r_e <= r_d;
					r_w <= {r_w[479:0],ROL0(r_w[32*3-1:32*2]^r_w[32*8-1:32*7]^r_w[32*14-1:32*13]^r_w[32*16-1:32*15])};
					if(r_count==7'd79) begin
						r_state <= 3'd5;
					end				
				end
				3'd5: begin
					r_a <= r_a + i_vin[159:128];
					r_b <= r_b + i_vin[127:96];
					r_c <= r_c + i_vin[95:64];
					r_d <= r_d + i_vin[63:32];
					r_e <= r_e + i_vin[31:0];	
					r_done <= 1'b1;
					r_state <= 3'd0;
				end
				default: begin
					r_done <= 1'b0;
					r_count <= 7'b0;
					r_a <= 32'b0;
					r_b <= 32'b0;
					r_c <= 32'b0;
					r_d <= 32'b0;
					r_e <= 32'b0;
					r_w <= 512'b0;
					r_state <= 3'd0;			
				end
			endcase
		end
	end
	
	assign o_vout = {r_a,r_b,r_c,r_d,r_e};
	assign o_done = r_done;

endmodule
