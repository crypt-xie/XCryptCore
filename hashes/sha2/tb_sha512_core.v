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
// File name        :   tb_sha512_core.v
// Function         :   SHA512 Hash Algorithm Core Simulate File 
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          :   v-1.0
// Date				:   2019-1-24
// Email            :   xcrypt@126.com
// ------------------------------------------------------------------------------

`timescale 1ns / 1ps

module tb_sha512_core();
    
    reg             r_clk;
    reg             r_rst;
    reg             r_start;
    reg     [1023:0] r_data;     
    reg     [511:0] r_vin;
    wire    [511:0] s_vout;
    wire            s_done;

	reg [511:0]	INIT = {64'h6a09e667f3bcc908,64'hbb67ae8584caa73b,
						64'h3c6ef372fe94f82b,64'ha54ff53a5f1d36f1,
						64'h510e527fade682d1,64'h9b05688c2b3e6c1f,
						64'h1f83d9abfb41bd6b,64'h5be0cd19137e2179};			
    //  SHA512("abc")
    //  {0xdd, 0xaf, 0x35, 0xa1, 0x93, 0x61, 0x7a, 0xba,
    //   0xcc, 0x41, 0x73, 0x49, 0xae, 0x20, 0x41, 0x31,
    //   0x12, 0xe6, 0xfa, 0x4e, 0x89, 0xa9, 0x7e, 0xa2,
    //   0x0a, 0x9e, 0xee, 0xe6, 0x4b, 0x55, 0xd3, 0x9a,
    //   0x21, 0x92, 0x99, 0x2a, 0x27, 0x4f, 0xc1, 0xa8,
    //   0x36, 0xba, 0x3c, 0x23, 0xa3, 0xfe, 0xeb, 0xbd,
    //   0x45, 0x4d, 0x44, 0x23, 0x64, 0x3c, 0xe8, 0x0e,
    //   0x2a, 0x9a, 0xc9, 0x4f, 0xa5, 0x4c, 0xa4, 0x9f }						
	reg [1023:0]	DATA1 = {32'h61626380,960'h0,32'h00000018};
	//  SHA512 ("12345678901234567890123456789012345678901234567890123456789012345678901234567890
	//			 12345678901234567890123456789012345678901234567890123456789012345678901234567890") = 
	//			 "72,bf,79,45,67,40,d5,5c,
	//			  96,ad,93,01,a3,53,d6,f8,
	//            21,91,0a,e3,b2,e9,b2,f4,
	//            02,20,63,0d,4f,c6,1c,2c,
	//            2d,8c,e3,fa,42,a2,fb,74,
	//            4b,39,d5,9f,08,ba,5f,36,
	//            78,97,2b,20,a1,c7,ae,50,
	//            61,d4,91,9f,1b,1b,02,34"
	reg [1023:0]	DATA2_1 = {
					64'h3132333435363738,64'h3930313233343536,
					64'h3738393031323334,64'h3536373839303132,
					64'h3334353637383930,64'h3132333435363738,
					64'h3930313233343536,64'h3738393031323334,
					64'h3536373839303132,64'h3334353637383930,
					64'h3132333435363738,64'h3930313233343536,
					64'h3738393031323334,64'h3536373839303132,
					64'h3334353637383930,64'h3132333435363738};


	reg [1023:0]	DATA2_2 = {
					64'h3930313233343536,64'h3738393031323334,
					64'h3536373839303132,64'h3334353637383930,
					64'h8000000000000000,64'h0000000000000000,
					64'h0000000000000000,64'h0000000000000000,
					64'h0000000000000000,64'h0000000000000000,
					64'h0000000000000000,64'h0000000000000000,
					64'h0000000000000000,64'h0000000000000000,
					64'h0000000000000000,64'h0000000000000500};	
	
    sha512_core uut(
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
