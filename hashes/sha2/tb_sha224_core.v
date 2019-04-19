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
// File name        :   tb_sha224_core.v
// Function         :   SHA256-224 Hash Algorithm Core Simulate File 
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          :   v-1.0
// Date				:   2019-1-24
// Email            :   xcrypt@126.com
// ------------------------------------------------------------------------------

`timescale 1ns / 1ps

module tb_sha224_core();
    
    reg             r_clk;
    reg             r_rst;
    reg             r_start;
    reg     [511:0] r_data;     
    reg     [255:0] r_vin;
    wire    [255:0] s_vout;
    wire            s_done;

	reg [255:0]	INIT = {
				32'hc1059ed8,32'h367cd507,32'h3070dd17,32'hf70e5939,
				32'hffc00b31,32'h68581511,32'h64f98fa7,32'hbefa4fa4};
    //SHA224("abc")=
    //  { 0x23, 0x09, 0x7d, 0x22, 0x34, 0x05, 0xd8,
    //    0x22, 0x86, 0x42, 0xa4, 0x77, 0xbd, 0xa2,
    //    0x55, 0xb3, 0x2a, 0xad, 0xbc, 0xe4, 0xbd,
    //    0xa0, 0xb3, 0xf7, 0xe3, 0x6c, 0x9d, 0xa7 }	
	reg [511:0]	DATA1 = {32'h61626380,416'h0,32'h0,32'h00000018};
	
	//SHA224("12345678901234567890123456789012345678901234567890123456789012345678901234567890") = 
	//     "b5,0a,ec,be,4e,9b,b0,b5,
	//      7b,c5,f3,ae,76,0a,8e,01,
	//      db,24,f2,03,fb,3c,dc,d1,
	//      31,48,04,6e"
	reg [511:0]	DATA2_1 = {80'h3132_3334_3536_3738_3930,80'h3132_3334_3536_3738_3930,
						   80'h3132_3334_3536_3738_3930,80'h3132_3334_3536_3738_3930,
						   80'h3132_3334_3536_3738_3930,80'h3132_3334_3536_3738_3930,
						   80'h3132_3334_3536_3738_3930,32'h3132_3334};
	reg [511:0]	DATA2_2 = {48'h3536_3738_3930,80'h3132_3334_3536_3738_3930,
						   48'h8000_0000_0000,272'h0,64'h0000_0000_0000_0280};		
	
    sha256_core uut(
    .i_clk      (r_clk),
    .i_rst      (r_rst),
    .i_start    (r_start),
    .i_data     (r_data),
    .i_vin      (r_vin),
    .o_vout     (s_vout), //hash value = s_vout[255:32];
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
