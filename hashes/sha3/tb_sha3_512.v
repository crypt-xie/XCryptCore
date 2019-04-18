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
// File name        :   tb_sha3_512.v
// Function         :   SHA3 Hash Algorithm Core Simulate File 
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          ：  v-1.0
// Date				:   2019-1-22
// Email            :   xcrypt@126.com
// ------------------------------------------------------------------------------

`timescale 1ns / 1ps

module tb_sha3_512();
    
    reg             	r_clk;
    reg             	r_rst;
    reg             	r_start;    
    reg     [64*25-1:0] r_vin;
    wire    [64*25-1:0] s_vout;
    wire            	s_done;
	
	//SHA3_512("") = {
		// a6,9f,73,cc,a2,3a,9a,c5,c8,b5,67,dc,18,5a,75,6e,
		// 97,c9,82,16,4f,e2,58,59,e0,d1,dc,c1,47,5c,80,a6,
		// 15,b2,12,3a,f1,f5,f9,4c,11,e3,e9,40,2c,3a,c5,58,
		// f5,00,19,9d,95,b6,d3,e3,01,75,85,86,28,1d,cd,26,
	reg [64*25-1:0] DATA1 = {
		64'h06000000_00000000,64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,
		64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,
		64'h00000000_00000080,64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,
		64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,
		64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,
		64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,
		64'h00000000_00000000
	};
	
	//SHA3_512(200*0xa3) = 
      // 0xe7, 0x6d, 0xfa, 0xd2, 0x20, 0x84, 0xa8, 0xb1,
      // 0x46, 0x7f, 0xcf, 0x2f, 0xfa, 0x58, 0x36, 0x1b,
      // 0xec, 0x76, 0x28, 0xed, 0xf5, 0xf3, 0xfd, 0xc0,
      // 0xe4, 0x80, 0x5d, 0xc4, 0x8c, 0xae, 0xec, 0xa8,
      // 0x1b, 0x7c, 0x13, 0xc3, 0x0a, 0xdf, 0x52, 0xa3,
      // 0x65, 0x95, 0x84, 0x73, 0x9a, 0x2d, 0xf4, 0x6b,
      // 0xe5, 0x89, 0xc5, 0x1c, 0xa1, 0xa4, 0xa8, 0x41,
      // 0x6d, 0xf6, 0x54, 0x5a, 0x1c, 0xe8, 0xba, 0x00
	reg [64*25-1:0] DATA2_1 = {
		64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,
		64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,
		64'ha3a3a3a3_a3a3a3a3,64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,
		64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,
		64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,
		64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,
		64'h00000000_00000000
		};
	reg [64*25-1:0] DATA2_2 = {
		64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,
		64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,
		64'ha3a3a3a3_a3a3a3a3,64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,
		64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,
		64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,
		64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,
		64'h00000000_00000000
		};		
	reg [64*25-1:0] DATA2_3 = {
		64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,
		64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,64'h06000000_00000000,
		64'h00000000_00000080,64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,
		64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,
		64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,
		64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,
		64'h00000000_00000000
		};	
		
    keccakf_core uut(
    .i_clk      (r_clk),
    .i_rst      (r_rst),
    .i_start    (r_start),
    .i_vin      (r_vin),
    .o_vout     (s_vout),
    .o_done     (s_done));    
    
    initial begin
        r_clk = 0;
        forever #5 r_clk = ~r_clk;
    end
    
    initial begin
        r_rst = 1'b1;
        r_start = 1'b0;
        r_vin = 256'b0;
        repeat(50) @(negedge r_clk);
        r_rst = 1'b0;
		
        ////test data 1
        repeat(50) @(negedge r_clk);
        r_start = 1'b1;
        r_vin = DATA1; //init
        $display("vin=0x%x",r_vin);
        @(negedge r_clk);
        r_start = 1'b0;
        wait(s_done);
        $display("vout=0x%x",s_vout);
         
        /////test data 2
        repeat(50) @(negedge r_clk); 
        r_start = 1'b1;
        r_vin = DATA2_1; //init  
        $display("vin=0x%x",r_vin);
        @(negedge r_clk);
        r_start = 1'b0;
        wait(s_done);
		$display("vout=0x%x",s_vout); 
        r_vin = DATA2_2^s_vout;
		@(negedge r_clk);
		r_start = 1'b1;   
        @(negedge r_clk);
        r_start = 1'b0;
        wait(s_done);               
        $display("vout=0x%x",s_vout);
        r_vin = DATA2_3^s_vout;
		@(negedge r_clk);
		r_start = 1'b1;   
        @(negedge r_clk);
        r_start = 1'b0;
        wait(s_done);               
        $display("vout=0x%x",s_vout);		
        /////stop
        repeat(50) @(negedge r_clk);         
        $stop;
    end
    
endmodule
