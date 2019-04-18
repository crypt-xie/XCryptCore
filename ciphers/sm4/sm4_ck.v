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
// File name        :   sm4_sbox.v
// Function         :   SM4 Cryptographic Algorithm Core CK
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          £º  v-1.0
// Date				:   2019-2-1
// Email            :   xcrypt@126.com
// ------------------------------------------------------------------------------

`timescale 1ns / 1ps

module sm4_ck(
    input   [4:0]	round,
    output  [31:0]  dout
    );
    reg [31:0] r_dout;
    assign dout = r_dout;
    always@(round) begin
        case(round)
            8'h1f : r_dout = 32'h646b7279;
            8'h1e : r_dout = 32'h484f565d;
            8'h1d : r_dout = 32'h2c333a41;
            8'h1c : r_dout = 32'h10171e25;
            8'h1b : r_dout = 32'hf4fb0209;
            8'h1a : r_dout = 32'hd8dfe6ed;
            8'h19 : r_dout = 32'hbcc3cad1;
            8'h18 : r_dout = 32'ha0a7aeb5;
            8'h17 : r_dout = 32'h848b9299;
            8'h16 : r_dout = 32'h686f767d;
            8'h15 : r_dout = 32'h4c535a61;
            8'h14 : r_dout = 32'h30373e45;
            8'h13 : r_dout = 32'h141b2229;
            8'h12 : r_dout = 32'hf8ff060d;
            8'h11 : r_dout = 32'hdce3eaf1;
            8'h10 : r_dout = 32'hc0c7ced5;
            8'h0f : r_dout = 32'ha4abb2b9;
            8'h0e : r_dout = 32'h888f969d;
            8'h0d : r_dout = 32'h6c737a81;
            8'h0c : r_dout = 32'h50575e65;
            8'h0b : r_dout = 32'h343b4249;
            8'h0a : r_dout = 32'h181f262d;
            8'h09 : r_dout = 32'hfc030a11;
            8'h08 : r_dout = 32'he0e7eef5;
            8'h07 : r_dout = 32'hc4cbd2d9;
            8'h06 : r_dout = 32'ha8afb6bd;
            8'h05 : r_dout = 32'h8c939aa1;
            8'h04 : r_dout = 32'h70777e85;
            8'h03 : r_dout = 32'h545b6269;
            8'h02 : r_dout = 32'h383f464d;
            8'h01 : r_dout = 32'h1c232a31;
            8'h00 : r_dout = 32'h00070e15;
        endcase
    end

endmodule
