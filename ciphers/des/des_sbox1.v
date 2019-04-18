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
// File name        :   des_sbox1.v
// Function         :   DES Cryptographic Algorithm Core SBox
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          ：  v-1.0
// Date				:   2019-1-25
// Email            :   xcrypt@126.com
// ------------------------------------------------------------------------------

`timescale 1ns / 1ps

module des_sbox1(
    input   [5:0]   din,
    output  [3:0]   dout
    );
	
    reg [3:0] r_dout;
    assign dout = r_dout;
	//
    always@(din) begin
        case({din[5],din[0],din[4:1]})
			//line 0
            6'h00 : r_dout = 4'd14;
            6'h01 : r_dout = 4'd04;
            6'h02 : r_dout = 4'd13;
            6'h03 : r_dout = 4'd01;
            6'h04 : r_dout = 4'd02;
            6'h05 : r_dout = 4'd15;
            6'h06 : r_dout = 4'd11;
            6'h07 : r_dout = 4'd08;
            6'h08 : r_dout = 4'd03;
            6'h09 : r_dout = 4'd10;
            6'h0a : r_dout = 4'd06;
            6'h0b : r_dout = 4'd12;
            6'h0c : r_dout = 4'd05;
            6'h0d : r_dout = 4'd09;
            6'h0e : r_dout = 4'd00;
            6'h0f : r_dout = 4'd07;
			//line 1
            6'h10 : r_dout = 4'd00;
            6'h11 : r_dout = 4'd15;
            6'h12 : r_dout = 4'd07;
            6'h13 : r_dout = 4'd04;
            6'h14 : r_dout = 4'd14;
            6'h15 : r_dout = 4'd02;
            6'h16 : r_dout = 4'd13;
            6'h17 : r_dout = 4'd01;
            6'h18 : r_dout = 4'd10;
            6'h19 : r_dout = 4'd06;
            6'h1a : r_dout = 4'd12;
            6'h1b : r_dout = 4'd11;
            6'h1c : r_dout = 4'd09;
            6'h1d : r_dout = 4'd05;
            6'h1e : r_dout = 4'd03;
            6'h1f : r_dout = 4'd08;		
			//line 2
            6'h20 : r_dout = 4'd04;
            6'h21 : r_dout = 4'd01;
            6'h22 : r_dout = 4'd14;
            6'h23 : r_dout = 4'd08;
            6'h24 : r_dout = 4'd13;
            6'h25 : r_dout = 4'd06;
            6'h26 : r_dout = 4'd02;
            6'h27 : r_dout = 4'd11;
            6'h28 : r_dout = 4'd15;
            6'h29 : r_dout = 4'd12;
            6'h2a : r_dout = 4'd09;
            6'h2b : r_dout = 4'd07;
            6'h2c : r_dout = 4'd03;
            6'h2d : r_dout = 4'd10;
            6'h2e : r_dout = 4'd05;
            6'h2f : r_dout = 4'd00;	
			//line 3
            6'h30 : r_dout = 4'd15;
            6'h31 : r_dout = 4'd12;
            6'h32 : r_dout = 4'd08;
            6'h33 : r_dout = 4'd02;
            6'h34 : r_dout = 4'd04;
            6'h35 : r_dout = 4'd09;
            6'h36 : r_dout = 4'd01;
            6'h37 : r_dout = 4'd07;
            6'h38 : r_dout = 4'd05;
            6'h39 : r_dout = 4'd11;
            6'h3a : r_dout = 4'd03;
            6'h3b : r_dout = 4'd14;
            6'h3c : r_dout = 4'd10;
            6'h3d : r_dout = 4'd00;
            6'h3e : r_dout = 4'd06;
            6'h3f : r_dout = 4'd13;		
        endcase
    end

endmodule
