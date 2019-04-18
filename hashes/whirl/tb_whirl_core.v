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
// File name        :   tb_whirl_core.v
// Function         :   Whirlpool Hash Algorithm Core Simulate File 
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          ：  v-1.0
// Date				:   2019-1-22
// Email            :   xcrypt@126.com
// ------------------------------------------------------------------------------

`timescale 1ns / 1ps

module tb_whirl_core();  
    reg             	r_clk;
    reg             	r_rst;
    reg             	r_start;    
    reg     [64*8-1:0]  r_vin;
    wire    [64*8-1:0]  s_vout;
	reg 	[64*8-1:0]  r_data;
    wire            	s_done;
			
	//whirlpool("") = {
  // { 0x19, 0xFA, 0x61, 0xD7, 0x55, 0x22, 0xA4, 0x66, 0x9B, 0x44, 0xE3, 0x9C, 0x1D, 0x2E, 0x17, 0x26,
    // 0xC5, 0x30, 0x23, 0x21, 0x30, 0xD4, 0x07, 0xF8, 0x9A, 0xFE, 0xE0, 0x96, 0x49, 0x97, 0xF7, 0xA7,
    // 0x3E, 0x83, 0xBE, 0x69, 0x8B, 0x28, 0x8F, 0xEB, 0xCF, 0x88, 0xE3, 0xE0, 0x3C, 0x4F, 0x07, 0x57,
    // 0xEA, 0x89, 0x64, 0xE5, 0x9B, 0x63, 0xD9, 0x37, 0x08, 0xB1, 0x38, 0xCC, 0x42, 0xA6, 0x6E, 0xB3 }				   
	reg [32*16-1:0] DATA1 = {
		64'h80000000_00000000,64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,
		64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000}; //0bit

	//whirlpool("abc") = {	
	// 0x4e, 0x24, 0x48, 0xa4, 0xc6, 0xf4, 0x86, 0xbb, 0x16, 0xb6, 0x56, 0x2c, 0x73, 0xb4, 0x02, 0x0b, 
	// 0xf3, 0x04, 0x3e, 0x3a, 0x73, 0x1b, 0xce, 0x72, 0x1a, 0xe1, 0xb3, 0x03, 0xd9, 0x7e, 0x6d, 0x4c, 
	// 0x71, 0x81, 0xee, 0xbd, 0xb6, 0xc5, 0x7e, 0x27, 0x7d, 0x0e, 0x34, 0x95, 0x71, 0x14, 0xcb, 0xd6, 
	// 0xc7, 0x97, 0xfc, 0x9d, 0x95, 0xd8, 0xb5, 0x82, 0xd2, 0x25, 0x29, 0x20, 0x76, 0xd4, 0xee, 0xf5,					   
	reg [32*16-1:0] DATA2 = {
		64'h61626380_00000000,64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,
		64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000018}; //24bit

	//blake2b_256(200*0xa3) = 
	// 0xdf, 0x48, 0x57, 0x67, 0xdc, 0x98, 0x11, 0xaf, 0x52, 0x1e, 0xf4, 0x6a, 0x2f, 0xad, 0xf3, 0x06,
	// 0x97, 0xd7, 0xb9, 0x1b, 0xf8, 0x2d, 0xe0, 0xda, 0x66, 0xa3, 0x31, 0xa5, 0xb9, 0x38, 0x96, 0x73,
	// 0x43, 0x21, 0xbe, 0x9d, 0xb2, 0x6d, 0x24, 0x57, 0xf0, 0x67, 0x65, 0x19, 0xb8, 0xb3, 0xb7, 0x0e,
    // 0x0b, 0xa5, 0xdb, 0x4c, 0x51, 0xef, 0xf8, 0x27, 0x81, 0x0e, 0x55, 0xa2, 0x9f, 0x27, 0x26, 0x68,	   
	reg [32*16-1:0] DATA3_1 = {
		64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,
		64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3};
	//		
	reg [32*16-1:0] DATA3_2 = {
		64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,
		64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3};
	//		
	reg [32*16-1:0] DATA3_3 = {
		64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,
		64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3};
	//		
	reg [64*16-1:0] DATA3_4 = {
		64'ha3a3a3a3_a3a3a3a3,64'h80000000_00000000,64'h00000000_00000000,64'h00000000_00000000,
		64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000640}; //1600bit
	  
	  
    whirl_core uut(
    .i_clk      (r_clk		),
    .i_rst      (r_rst		),
    .i_start    (r_start	),
	.i_data		(r_data		),
    .i_vin      (r_vin		),
    .o_vout     (s_vout		),
    .o_done     (s_done		));    
    
    initial begin
        r_clk = 0;
        forever #5 r_clk = ~r_clk;
    end
    
    initial begin
        r_rst = 1'b1;
        r_start = 1'b0;
        r_vin = 512'b0;
		r_data = 512'b0;
        repeat(50) @(negedge r_clk);
        r_rst = 1'b0;
		
        ////test data 1
        repeat(50) @(negedge r_clk);
        r_start = 1'b1;
        r_vin = 512'b0; //init
		r_data = DATA1;
        $display("vin=0x%x",r_vin);
		$display("data=0x%x",r_data);
        @(negedge r_clk);
        r_start = 1'b0;
        wait(s_done);
        $display("vout=0x%x",s_vout);
 
        ////test data 2
        repeat(50) @(negedge r_clk);
        r_start = 1'b1;
        r_vin = 512'b0; //init
		r_data = DATA2;
        $display("vin=0x%x",r_vin);
		$display("data=0x%x",r_data);
        @(negedge r_clk);
        r_start = 1'b0;
        wait(s_done);
        $display("vout=0x%x",s_vout);
 
        ////test data 3
        repeat(50) @(negedge r_clk);
        r_start = 1'b1;
        r_vin = 512'b0; //init
		r_data = DATA3_1;
        $display("vin=0x%x",r_vin);
		$display("data=0x%x",r_data);
        @(negedge r_clk);
        r_start = 1'b0;
        wait(s_done);
        $display("vout=0x%x",s_vout);
        @(negedge r_clk);
        r_start = 1'b1;
        r_vin = s_vout; //init
		r_data = DATA3_2;
        $display("vin=0x%x",r_vin);
		$display("data=0x%x",r_data);
        @(negedge r_clk);
        r_start = 1'b0;
        wait(s_done);
        $display("vout=0x%x",s_vout);			//hash value is high 256 bits 
        @(negedge r_clk);
        r_start = 1'b1;
        r_vin = s_vout; //init
		r_data = DATA3_3;
        $display("vin=0x%x",r_vin);
		$display("data=0x%x",r_data);
        @(negedge r_clk);
        r_start = 1'b0;
        wait(s_done);
        $display("vout=0x%x",s_vout);			//hash value is high 256 bits 
        @(negedge r_clk);
        r_start = 1'b1;
        r_vin = s_vout; //init
		r_data = DATA3_4;
        $display("vin=0x%x",r_vin);
		$display("data=0x%x",r_data);
        @(negedge r_clk);
        r_start = 1'b0;
        wait(s_done);
        $display("vout=0x%x",s_vout);			//hash value is high 256 bits 		
        /////stop
        repeat(50) @(negedge r_clk);         
        $stop;
    end
    
endmodule
