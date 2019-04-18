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
// File name        :   tiger_round.v
// Function         :   Tiger Hash Algorithm One Round of the Hash function 
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          £º  v-1.0
// Date				:   2019-1-23
// Email            :   xcrypt@126.com
// ------------------------------------------------------------------------------

module tiger_round(
	input			i_clk,
	input	[63:0]	i_ain,
	input	[63:0]	i_bin,
	input	[63:0]	i_cin,	
	input	[63:0]	i_xin,
	input 	[3:0]	i_mul,
	output  [63:0]	o_aout,
	output  [63:0]	o_bout,
	output  [63:0]	o_cout	
	);
	
	localparam DLY = 1;
	
	wire [63:0]	s_a,s_b,s_c;
	reg  [63:0]	r_c;
	reg	 [63:0]	r_ain,r_bin;
	reg  [3:0]	r_mul;
	wire [7:0]	s_sin [7:0];
	wire [63:0] s_sout [7:0];
	
	always@(posedge i_clk) begin
		r_ain <= #DLY i_ain;
		r_bin <= #DLY i_bin;
		r_mul <= #DLY i_mul;
	end	
	
	always@(posedge i_clk) begin
		r_c <= #DLY s_c;
	end
		
	assign s_c = i_cin ^ i_xin; 
	
	assign s_sin[0] = s_c[7:0];
	assign s_sin[1] = s_c[15:8];
	assign s_sin[2] = s_c[23:16];
	assign s_sin[3] = s_c[31:24];
	assign s_sin[4] = s_c[39:32];
	assign s_sin[5] = s_c[47:40];
	assign s_sin[6] = s_c[55:48];
	assign s_sin[7] = s_c[63:56];
	
	assign s_a = r_ain - (s_sout[0]^s_sout[2]^s_sout[4]^s_sout[6]);
	assign s_b = r_bin + (s_sout[1]^s_sout[3]^s_sout[5]^s_sout[7]);
		
	assign o_aout = s_a;
	assign o_bout = (r_mul==4'd5) ? ({s_b[61:0],2'b0} + s_b):
				   ((r_mul==4'd7) ? ({s_b[60:0],3'b0} - s_b):
				   ((r_mul==4'd9) ? ({s_b[60:0],3'b0} + s_b): 64'b0));
	assign o_cout = r_c;	
	
	//t1
	tiger_sbox_a u_sbox_0(
	.i_clk	(i_clk		),
	.i_addr	(s_sin[0]	),
	.o_data	(s_sout[0]	)
	);	
	//t2
	tiger_sbox_b u_sbox_1(
	.i_clk	(i_clk		),
	.i_addr	(s_sin[2]	),
	.o_data	(s_sout[2]	)
	);	
	//t3
	tiger_sbox_c u_sbox_2(
	.i_clk	(i_clk		),
	.i_addr	(s_sin[4]	),
	.o_data	(s_sout[4]	)
	);		
	//t4
	tiger_sbox_d u_sbox_3(
	.i_clk	(i_clk		),
	.i_addr	(s_sin[6]	),
	.o_data	(s_sout[6]	)
	);		
	
	//t4
	tiger_sbox_d u_sbox_4(
	.i_clk	(i_clk		),
	.i_addr	(s_sin[1]	),
	.o_data	(s_sout[1]	)
	);	
	//t3
	tiger_sbox_c u_sbox_5(
	.i_clk	(i_clk		),
	.i_addr	(s_sin[3]	),
	.o_data	(s_sout[3]	)
	);	
	//t2
	tiger_sbox_b u_sbox_6(
	.i_clk	(i_clk		),
	.i_addr	(s_sin[5]	),
	.o_data	(s_sout[5]	)
	);		
	//t1
	tiger_sbox_a u_sbox_7(
	.i_clk	(i_clk		),
	.i_addr	(s_sin[7]	),
	.o_data	(s_sout[7]	)
	);		
	
	
endmodule
