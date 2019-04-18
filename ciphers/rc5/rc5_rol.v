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
// File name        :   rc5_rol.v
// Function         :   RC5 Cryptographic Algorithm Core ROL
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          ：  v-1.0
// Date				:   2019-2-1
// Email            :   xcrypt@126.com
// ------------------------------------------------------------------------------

`timescale 1ns / 1ps

module rc5_rol(
    input   [4:0]	round,
	input 	[31:0]  din,
    output  [31:0]  dout
    );
    reg [31:0] r_dout;
    assign dout = r_dout;
    always@(round or din) begin
        case(round)
			5'h00 : r_dout = din;
			5'h01 : r_dout = {din[30:0],din[31]	  };
			5'h02 : r_dout = {din[29:0],din[31:30]};
			5'h03 : r_dout = {din[28:0],din[31:29]};
			5'h04 : r_dout = {din[27:0],din[31:28]};
			5'h05 : r_dout = {din[26:0],din[31:27]};
			5'h06 : r_dout = {din[25:0],din[31:26]};
			5'h07 : r_dout = {din[24:0],din[31:25]};
			5'h08 : r_dout = {din[23:0],din[31:24]};
			5'h09 : r_dout = {din[22:0],din[31:23]};
			5'h0a : r_dout = {din[21:0],din[31:22]};
			5'h0b : r_dout = {din[20:0],din[31:21]};
			5'h0c : r_dout = {din[19:0],din[31:20]};
			5'h0d : r_dout = {din[18:0],din[31:19]};
			5'h0e : r_dout = {din[17:0],din[31:18]};
			5'h0f : r_dout = {din[16:0],din[31:17]};
			5'h10 : r_dout = {din[15:0],din[31:16]};
			5'h11 : r_dout = {din[14:0],din[31:15]};
			5'h12 : r_dout = {din[13:0],din[31:14]};
			5'h13 : r_dout = {din[12:0],din[31:13]};
			5'h14 : r_dout = {din[11:0],din[31:12]};
			5'h15 : r_dout = {din[10:0],din[31:11]};
			5'h16 : r_dout = {din[ 9:0],din[31:10]};
			5'h17 : r_dout = {din[ 8:0],din[31: 9]};
			5'h18 : r_dout = {din[ 7:0],din[31: 8]};
			5'h19 : r_dout = {din[ 6:0],din[31: 7]};
			5'h1a : r_dout = {din[ 5:0],din[31: 6]};
			5'h1b : r_dout = {din[ 4:0],din[31: 5]};
			5'h1c : r_dout = {din[ 3:0],din[31: 4]};
			5'h1d : r_dout = {din[ 2:0],din[31: 3]};
			5'h1e : r_dout = {din[ 1:0],din[31: 2]};
			5'h1f : r_dout = {din[0]   ,din[31: 1]};
        endcase
    end

endmodule
