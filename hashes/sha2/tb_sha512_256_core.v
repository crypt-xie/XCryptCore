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
// File name        :   tb_sha512_256_core.v
// Function         :   SHA512-256 Hash Algorithm Core Simulate File 
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          :   v-1.0
// Date				:   2019-1-24
// Email            :   xcrypt@126.com
// ------------------------------------------------------------------------------

`timescale 1ns / 1ps

module tb_sha512_256_core();
    
    reg             r_clk;
    reg             r_rst;
    reg             r_start;
    reg     [1023:0] r_data;     
    reg     [511:0] r_vin;
    wire    [511:0] s_vout;
    wire            s_done;

	reg [511:0]	INIT = {
	64'h22312194FC2BF72C,64'h9F555FA3C84C64C2,
    64'h2393B86B6F53B151,64'h963877195940EABD,
    64'h96283EE2A88EFFE3,64'hBE5E1E2553863992,
    64'h2B0199FC2C85B8AA,64'h0EB72DDC81C52CA2};				
	
    //  sha512_256("abc")
    //  { 0x53, 0x04, 0x8E, 0x26, 0x81, 0x94, 0x1E, 0xF9,
    //    0x9B, 0x2E, 0x29, 0xB7, 0x6B, 0x4C, 0x7D, 0xAB,
    //    0xE4, 0xC2, 0xD0, 0xC6, 0x34, 0xFC, 0x6D, 0x46,
    //    0xE0, 0xE2, 0xF1, 0x31, 0x07, 0xE7, 0xAF, 0x23 }

	reg [1023:0]	DATA1 = {32'h61626380,960'h0,32'h00000018};
	
	//  sha512_256 ("12345678901234567890123456789012345678901234567890123456789012345678901234567890
	//			 12345678901234567890123456789012345678901234567890123456789012345678901234567890") = 
	//   62308929,65ac0a68,744d2a16,db636f5f,f108bf54,eb253b27,a3e9c521,85a09a5c
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
    .o_vout     (s_vout), //hash value = s_vout[511:256]
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
