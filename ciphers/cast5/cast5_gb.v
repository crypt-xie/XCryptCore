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
// File name        :   cast5_gb.v
// Function         :   CAST5 Cryptographic Algorithm Core GB
//				    :   #define GB(x, i) (((x[(15-i)>>2])>>(unsigned)(8*((15-i)&3)))&255)
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          ：  v-1.0
// Date				:   2019-2-3
// Email            :   xcrypt@126.com
// ------------------------------------------------------------------------------

`timescale 1ns / 1ps

module cast5_gb(
	input 	[3:0]	i_s,    //i
    input   [127:0] i_din,  //x
    output  [7:0]   o_dout
    );

	wire [31:0] s_dw;
		
	function [31:0] WS;
		input [127:0] D;
		input [3:0]	  S;
		reg   [3:0]   Sx;
		begin
			Sx = 15 - S;
			WS = (Sx[3:2] == 2'b00) ? D[31: 0] :
				((Sx[3:2] == 2'b01) ? D[63:32] :
				((Sx[3:2] == 2'b10) ? D[95:64] :
				((Sx[3:2] == 2'b11) ? D[127:96]: 32'b0)));
		end
	endfunction
	
	function [31:0] SR;
		input [31:0] D;
		input [3:0]  S;
		reg   [3:0]  Sx;
		begin
			Sx = 15 - S;	
			SR = (Sx[1:0] == 2'b00) ? D[7: 0] :
				((Sx[1:0] == 2'b01) ? D[15:8] :
				((Sx[1:0] == 2'b10) ? D[23:16]:
				((Sx[1:0] == 2'b11) ? D[31:24]: 8'b0)));
		end
	endfunction;
	
	assign s_dw = WS(i_din,i_s);
	assign o_dout = SR(s_dw,i_s);
	
endmodule
