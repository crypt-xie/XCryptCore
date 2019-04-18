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
// File name        :   tb_tiger_core.v
// Function         :   Tiger Hash Algorithm Core Simulate File 
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          ：  v-1.0
// Date				:   2019-1-23
// Email            :   xcrypt@126.com
// ------------------------------------------------------------------------------

`timescale 1ns / 1ps

module tb_tiger_core();
    
    reg             r_clk;
    reg             r_rst;
    reg             r_start;
    reg     [511:0] r_data;     
    reg     [191:0] r_vin;
    wire    [191:0] s_vout;
    wire            s_done;
	
	reg [191:0]	INIT = {64'hEFCDAB8967452301,64'h1032547698BADCFE,64'h87E1B2C3B4A596F0};	
						
    //Tiger("abc") =     { "abc",
     // { 0x2a, 0xab, 0x14, 0x84, 0xe8, 0xc1, 0x58, 0xf2,
       // 0xbf, 0xb8, 0xc5, 0xff, 0x41, 0xb5, 0x7a, 0x52,
       // 0x51, 0x29, 0x13, 0x1c, 0x95, 0x7b, 0x5f, 0x93 }
	reg [511:0]	DATA1 = {64'h61626301_00000000,64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,
						 64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,64'h18000000_00000000};
	
	//SHA256("123456789012345678901234567890123456789012345678901234567890123456
	//78901234567890") = 
	   // 0x1c, 0x14, 0x79, 0x55, 0x29, 0xfd, 0x9f, 0x20,
	   // 0x7a, 0x95, 0x8f, 0x84, 0xc5, 0x2f, 0x11, 0xe8,
	   // 0x87, 0xfa, 0x0c, 0xab, 0xdf, 0xd9, 0x1b, 0xfd
	reg [511:0]	DATA2_1 = {80'h3132_3334_3536_3738_3930,80'h3132_3334_3536_3738_3930,
						   80'h3132_3334_3536_3738_3930,80'h3132_3334_3536_3738_3930,
						   80'h3132_3334_3536_3738_3930,80'h3132_3334_3536_3738_3930,
						   80'h3132_3334_3536_3738_3930,32'h3132_3334};
	reg [511:0]	DATA2_2 = {48'h3536_3738_3930,80'h3132_3334_3536_3738_3930,
						   48'h0100_0000_0000,272'h0,64'h8002_0000_0000_0000};		

    //Tiger("") =     { "",
     // { 0x32, 0x93, 0xac, 0x63, 0x0c, 0x13, 0xf0, 0x24,
       // 0x5f, 0x92, 0xbb, 0xb1, 0x76, 0x6e, 0x16, 0x16,
       // 0x7a, 0x4e, 0x58, 0x49, 0x2d, 0xde, 0x73, 0xf3 }
	reg [511:0]	DATA3 = {64'h01000000_00000000,64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,
						 64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000};
						   
    tiger_core uut(
    .i_clk      (r_clk),
    .i_rst      (r_rst),
    .i_start    (r_start),
    .i_data     (r_data),
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
        r_data = 512'b0;
        repeat(50) @(negedge r_clk);
        r_rst = 1'b0;
		
        ////test data 1
        repeat(50) @(negedge r_clk);
        r_start = 1'b1;
        r_vin = INIT; //init
        r_data = DATA1;
        $display("vin=0x%x",r_vin);
        $display("data=0x%x",r_data);
        @(negedge r_clk);
        r_start = 1'b0;
        wait(s_done);
		@(negedge r_clk);
        $display("vout=0x%x",s_vout);
         
        /////test data 2
        repeat(50) @(negedge r_clk); 
        r_start = 1'b1;
        r_vin = INIT; //init
        r_data = DATA2_1;    
        //$display("vin=0x%x",r_vin);
        //$display("data=0x%x",r_data);
        @(negedge r_clk);
        r_start = 1'b0;
        wait(s_done);
		@(negedge r_clk);
		$display("vout=0x%x",s_vout); 
        r_vin = s_vout;
		@(negedge r_clk);
		r_start = 1'b1;
        r_data= DATA2_2;    
        @(negedge r_clk);
        r_start = 1'b0;
        wait(s_done); 
		@(negedge r_clk);		
        $display("vout=0x%x",s_vout);

        ////test data 3
        repeat(50) @(negedge r_clk);
        r_start = 1'b1;
        r_vin = INIT; //init
        r_data = DATA3;
        $display("vin=0x%x",r_vin);
        $display("data=0x%x",r_data);
        @(negedge r_clk);
        r_start = 1'b0;
        wait(s_done);
		@(negedge r_clk);
        $display("vout=0x%x",s_vout);
		
        /////stop
        repeat(50) @(negedge r_clk);         
        $stop;
    end
    
endmodule
