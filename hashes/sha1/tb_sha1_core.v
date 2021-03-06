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
// File name        :   tb_sha1_core.v
// Function         :   SHA1 Hash Algorithm Core Simulate File 
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          :   v-1.0
// Date				:   2019-1-24
// Email            :   xcrypt@126.com
// ------------------------------------------------------------------------------

`timescale 1ns / 1ps

module tb_sha1_core();
    
    reg             r_clk;
    reg             r_rst;
    reg             r_start;
    reg     [511:0] r_data;     
    reg     [159:0] r_vin;
    wire    [159:0] s_vout;
    wire            s_done;
    //SHA1("abc") = "A9 99 3E 36 47 06 81 6A BA 3E 25 71 78 50 C2 6C 9C D0 D8 9D" 
	reg [159:0]	INIT = {32'h67452301,32'hEFCDAB89,32'h98BADCFE,32'h10325476,32'hC3D2E1F0};
	reg [511:0]	DATA1 = {32'h61626380,416'h0,32'h0,32'h00000018};
	//MD4 ("123456789012345678901234567890123456789012345678901234567890123456
	//78901234567890") = "50,ab,f5,70,6a,15,09,90,a0,8b,2c,5e,a4,0f,a0,e5,85,55,47,32“
	reg [511:0]	DATA2_1 = {80'h3132_3334_3536_3738_3930,80'h3132_3334_3536_3738_3930,
						   80'h3132_3334_3536_3738_3930,80'h3132_3334_3536_3738_3930,
						   80'h3132_3334_3536_3738_3930,80'h3132_3334_3536_3738_3930,
						   80'h3132_3334_3536_3738_3930,32'h3132_3334};
	reg [511:0]	DATA2_2 = {48'h3536_3738_3930,80'h3132_3334_3536_3738_3930,
						   48'h8000_0000_0000,272'h0,64'h0000_0000_0000_0280};		
	
    sha1_core uut(
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
        repeat(50) @(posedge r_clk);
        r_rst = 1'b0;
        ////test data 1
        repeat(50) @(posedge r_clk);
        r_start = 1'b1;
        r_vin = INIT; //init
        r_data = DATA1;
        $display("vin=0x%x",r_vin);
        $display("data=0x%x",r_data);
        @(posedge r_clk);
        r_start = 1'b0;
        wait(s_done);
        $display("vout=0x%x",s_vout);
         
        /////test data 2
        repeat(50) @(posedge r_clk); 
        r_start = 1'b1;
        r_vin = INIT; //init
        r_data = DATA2_1;    
        //$display("vin=0x%x",r_vin);
        //$display("data=0x%x",r_data);
        @(posedge r_clk);
        r_start = 1'b0;
        wait(s_done);
		$display("vout=0x%x",s_vout); 
        r_vin = s_vout;
		@(posedge r_clk);
		r_start = 1'b1;
        r_data= DATA2_2;    
        @(posedge r_clk);
        r_start = 1'b0;
        wait(s_done);               
        $display("vout=0x%x",s_vout);
        /////stop
        repeat(50) @(posedge r_clk);         
        $stop;
    end
    
endmodule
