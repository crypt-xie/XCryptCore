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
// File name        :   tb_sha384_core.v
// Function         :   SHA512-384 Hash Algorithm Core Simulate File 
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          :   v-1.0
// Date				:   2019-1-24
// Email            :   xcrypt@126.com
// ------------------------------------------------------------------------------

`timescale 1ns / 1ps

module tb_sha384_core();
    
    reg             r_clk;
    reg             r_rst;
    reg             r_start;
    reg     [1023:0] r_data;     
    reg     [511:0] r_vin;
    wire    [511:0] s_vout;
    wire            s_done;

	reg [511:0]	INIT = {64'hcbbb9d5dc1059ed8,64'h629a292a367cd507,
						64'h9159015a3070dd17,64'h152fecd8f70e5939,
						64'h67332667ffc00b31,64'h8eb44a8768581511,
						64'hdb0c2e0d64f98fa7,64'h47b5481dbefa4fa4};						
    //  SHA384("abc")
    //  { 0xcb, 0x00, 0x75, 0x3f, 0x45, 0xa3, 0x5e, 0x8b,
    //    0xb5, 0xa0, 0x3d, 0x69, 0x9a, 0xc6, 0x50, 0x07,
    //    0x27, 0x2c, 0x32, 0xab, 0x0e, 0xde, 0xd1, 0x63,
    //    0x1a, 0x8b, 0x60, 0x5a, 0x43, 0xff, 0x5b, 0xed,
    //    0x80, 0x86, 0x07, 0x2b, 0xa1, 0xe7, 0xcc, 0x23,
    //    0x58, 0xba, 0xec, 0xa1, 0x34, 0xc8, 0x25, 0xa7 }	
	reg [1023:0]	DATA1 = {32'h61626380,960'h0,32'h00000018};
	//  SHA384 ("12345678901234567890123456789012345678901234567890123456789012345678901234567890
	//			 12345678901234567890123456789012345678901234567890123456789012345678901234567890") = 
	//   8d,eb,7d,cc,ae,68,ef,ba,
	//   fe,c8,2d,5a,3d,9d,85,1a,
	//   ef,45,8b,c2,7f,fc,c0,fc,
	//   c8,cc,0e,43,b7,62,0e,b1,
	//   48,65,b0,d6,75,db,bf,92,
	//   30,54,85,28,b4,7f,fe,7b,
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
    .o_vout     (s_vout), //hash value = s_vout[511:128]
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
