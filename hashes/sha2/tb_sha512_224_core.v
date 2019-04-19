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
// File name        :   tb_sha512_224_core.v
// Function         :   SHA512-224 Hash Algorithm Core Simulate File 
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          :   v-1.0
// Date				:   2019-1-24
// Email            :   xcrypt@126.com
// ------------------------------------------------------------------------------

`timescale 1ns / 1ps

module tb_sha512_224_core();
    
    reg             r_clk;
    reg             r_rst;
    reg             r_start;
    reg     [1023:0] r_data;     
    reg     [511:0] r_vin;
    wire    [511:0] s_vout;
    wire            s_done;

	reg [511:0]	INIT = {
		64'h8C3D37C819544DA2,64'h73E1996689DCD4D6,
		64'h1DFAB7AE32FF9C82,64'h679DD514582F9FCF,
		64'h0F6D2B697BD44DA8,64'h77E36F7304C48942,
		64'h3F9D85A86A1D36C8,64'h1112E6AD91D692A1};
						
    //  sha512_224("abc")
	//{ 0x46, 0x34, 0x27, 0x0F, 0x70, 0x7B, 0x6A, 0x54,
    //    0xDA, 0xAE, 0x75, 0x30, 0x46, 0x08, 0x42, 0xE2,
    //    0x0E, 0x37, 0xED, 0x26, 0x5C, 0xEE, 0xE9, 0xA4,
    //    0x3E, 0x89, 0x24, 0xAA }
	reg [1023:0]	DATA1 = {32'h61626380,960'h0,32'h00000018};
	
	//  sha512_224 ("12345678901234567890123456789012345678901234567890123456789012345678901234567890
	//			 12345678901234567890123456789012345678901234567890123456789012345678901234567890") = 
	//   1a7dd4c3,e52b0587,92188abf,37076bc5,1685a3bf,a5558dad,19227274
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
    .o_vout     (s_vout), //hash value = s_vout[511:288]
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
