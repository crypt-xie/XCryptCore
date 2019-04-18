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
// File name        :   tb_sha3_384.v
// Function         :   SHA3 Hash Algorithm Core Simulate File 
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          ：  v-1.0
// Date				:   2019-1-22
// Email            :   xcrypt@126.com
// ------------------------------------------------------------------------------

`timescale 1ns / 1ps

module tb_sha3_384();
    
    reg             	r_clk;
    reg             	r_rst;
    reg             	r_start;    
    reg     [64*25-1:0] r_vin;
    wire    [64*25-1:0] s_vout;
    wire            	s_done;
	
	//SHA3_384("") = {
		// 0x0c, 0x63, 0xa7, 0x5b, 0x84, 0x5e, 0x4f, 0x7d,
		// 0x01, 0x10, 0x7d, 0x85, 0x2e, 0x4c, 0x24, 0x85,
		// 0xc5, 0x1a, 0x50, 0xaa, 0xaa, 0x94, 0xfc, 0x61,
		// 0x99, 0x5e, 0x71, 0xbb, 0xee, 0x98, 0x3a, 0x2a,
		// 0xc3, 0x71, 0x38, 0x31, 0x26, 0x4a, 0xdb, 0x47,
		// 0xfb, 0x6b, 0xd1, 0xe0, 0x58, 0xd5, 0xf0, 0x04
	reg [64*25-1:0] DATA1 = {
		64'h06000000_00000000,64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,
		64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,
		64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,
		64'h00000000_00000080,64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,
		64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,
		64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,
		64'h00000000_00000000
	};
	
	//SHA3_384(200*0xa3) = 
		// 0x18, 0x81, 0xde, 0x2c, 0xa7, 0xe4, 0x1e, 0xf9,
		// 0x5d, 0xc4, 0x73, 0x2b, 0x8f, 0x5f, 0x00, 0x2b,
		// 0x18, 0x9c, 0xc1, 0xe4, 0x2b, 0x74, 0x16, 0x8e,
		// 0xd1, 0x73, 0x26, 0x49, 0xce, 0x1d, 0xbc, 0xdd,
		// 0x76, 0x19, 0x7a, 0x31, 0xfd, 0x55, 0xee, 0x98,
		// 0x9f, 0x2d, 0x70, 0x50, 0xdd, 0x47, 0x3e, 0x8f
	reg [64*25-1:0] DATA2_1 = {
		64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,
		64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,
		64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,
		64'ha3a3a3a3_a3a3a3a3,64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,
		64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,
		64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,
		64'h00000000_00000000
		};
	reg [64*25-1:0] DATA2_2 = {
		64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,
		64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,
		64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,64'ha3a3a3a3_a3a3a3a3,
		64'h06000000_00000080,64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,
		64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,
		64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,64'h00000000_00000000,
		64'h00000000_00000000
		};	

	function [63:0] SWAP;
        input [63:0] DIN;
        begin
            SWAP = {DIN[7:0],DIN[15:8],DIN[23:16],DIN[31:24],DIN[39:32],DIN[47:40],DIN[55:48],DIN[63:56]};
        end
    endfunction	
		
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
        $display("vin=0x%x",SWAP(r_vin[64*25-1:64*24]));
		$display("vin=0x%x",SWAP(r_vin[64*24-1:64*23]));
		$display("vin=0x%x",SWAP(r_vin[64*23-1:64*22]));
		$display("vin=0x%x",SWAP(r_vin[64*22-1:64*21]));
		$display("vin=0x%x",SWAP(r_vin[64*21-1:64*20]));
		$display("vin=0x%x",SWAP(r_vin[64*20-1:64*19]));
		$display("vin=0x%x",SWAP(r_vin[64*19-1:64*18]));
		$display("vin=0x%x",SWAP(r_vin[64*18-1:64*17]));
		$display("vin=0x%x",SWAP(r_vin[64*17-1:64*16]));
		$display("vin=0x%x",SWAP(r_vin[64*16-1:64*15]));
		$display("vin=0x%x",SWAP(r_vin[64*15-1:64*14]));
		$display("vin=0x%x",SWAP(r_vin[64*14-1:64*13]));
		$display("vin=0x%x",SWAP(r_vin[64*13-1:64*12]));
		$display("vin=0x%x",SWAP(r_vin[64*12-1:64*11]));
		$display("vin=0x%x",SWAP(r_vin[64*11-1:64*10]));
		$display("vin=0x%x",SWAP(r_vin[64*10-1:64* 9]));
		$display("vin=0x%x",SWAP(r_vin[64* 9-1:64* 8]));
		$display("vin=0x%x",SWAP(r_vin[64* 8-1:64* 7]));
		$display("vin=0x%x",SWAP(r_vin[64* 7-1:64* 6]));
		$display("vin=0x%x",SWAP(r_vin[64* 6-1:64* 5]));
		$display("vin=0x%x",SWAP(r_vin[64* 5-1:64* 4]));
		$display("vin=0x%x",SWAP(r_vin[64* 4-1:64* 3]));
		$display("vin=0x%x",SWAP(r_vin[64* 3-1:64* 2]));
		$display("vin=0x%x",SWAP(r_vin[64* 2-1:64* 1]));
		$display("vin=0x%x",SWAP(r_vin[64* 1-1:64* 0]));	
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
