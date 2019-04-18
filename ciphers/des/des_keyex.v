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
// File name        :   des_keyex.v
// Function         :   DES Cryptographic Algorithm Core Caculate Round KEY 
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          ：  v-1.0
// Date				:   2019-1-25
// Email            :   xcrypt@126.com
// ------------------------------------------------------------------------------

module des_keyex(
	input 				i_clk,
	input 				i_rst,
	input 	[63:0]	 	i_key,		//key
	input 				i_key_en,	//key init flag
	output 	[48*16-1:0]	o_exkey,  	//round key
	output 				o_key_ok  	//key init ok
	);
	
	localparam DLY = 1;
	
	wire 	[55:0]	s_key;
	wire 	[55:0]	s_lskey;
	reg  	[55:0]	r_key;
	reg		[767:0]	r_exkey;
	reg 	[3:0]	r_count;
	reg 			r_key_ok;
	wire 			s_busy;
	wire 	[47:0]	s_exk;
	
	//parity bit drop
	function [55:0]	PBD;
		input [63:0] D;
		begin		
			PBD[55] = D[64-57];
			PBD[54] = D[64-49];
			PBD[53] = D[64-41];
			PBD[52] = D[64-33];
			PBD[51] = D[64-25];
			PBD[50] = D[64-17];
			PBD[49] = D[64- 9];
			PBD[48] = D[64- 1];
			PBD[47] = D[64-58];
			PBD[46] = D[64-50];
			PBD[45] = D[64-42];
			PBD[44] = D[64-34];
			PBD[43] = D[64-26];
			PBD[42] = D[64-18];
			PBD[41] = D[64-10];
			PBD[40] = D[64- 2];
			PBD[39] = D[64-59];
			PBD[38] = D[64-51];
			PBD[37] = D[64-43];
			PBD[36] = D[64-35];
			PBD[35] = D[64-27];
			PBD[34] = D[64-19];
			PBD[33] = D[64-11];
			PBD[32] = D[64- 3];
			PBD[31] = D[64-60];
			PBD[30] = D[64-52];
			PBD[29] = D[64-44];
			PBD[28] = D[64-36];
			PBD[27] = D[64-63];
			PBD[26] = D[64-55];
			PBD[25] = D[64-47];
			PBD[24] = D[64-39];
			PBD[23] = D[64-31];
			PBD[22] = D[64-23];
			PBD[21] = D[64-15];
			PBD[20] = D[64- 7];
			PBD[19] = D[64-62];
			PBD[18] = D[64-54];
			PBD[17] = D[64-46];
			PBD[16] = D[64-38];
			PBD[15] = D[64-30];
			PBD[14] = D[64-22];
			PBD[13] = D[64-14];
			PBD[12] = D[64- 6];
			PBD[11] = D[64-61];
			PBD[10] = D[64-53];
			PBD[ 9] = D[64-45];
			PBD[ 8] = D[64-37];		
			PBD[ 7] = D[64-29];
			PBD[ 6] = D[64-21];
			PBD[ 5] = D[64-13];
			PBD[ 4] = D[64- 5];
			PBD[ 3] = D[64-28];
			PBD[ 2] = D[64-20];
			PBD[ 1] = D[64-12];
			PBD[ 0] = D[64- 4];					
		end
	endfunction
	
	//round left shift
	function [27:0] ROL;
		input [27:0] D;
		input [1:0] S;
		begin
			ROL = (S==2'd1) ? {D[26:0],D[27]} : {D[25:0],D[27:26]};
		end
	endfunction;
	
	//CHN: compress permutation
	function [47:0] CEX;
		input [55:0] D;
		begin
			CEX[47] = D[56-14];
			CEX[46] = D[56-17];
			CEX[45] = D[56-11];
			CEX[44] = D[56-24];
			CEX[43] = D[56- 1];
			CEX[42] = D[56- 5];
			CEX[41] = D[56- 3];
			CEX[40] = D[56-28];
			CEX[39] = D[56-15];
			CEX[38] = D[56- 6];
			CEX[37] = D[56-21];
			CEX[36] = D[56-10];
			CEX[35] = D[56-23];
			CEX[34] = D[56-19];
			CEX[33] = D[56-12];
			CEX[32] = D[56- 4];
			CEX[31] = D[56-26];
			CEX[30] = D[56- 8];
			CEX[29] = D[56-16];
			CEX[28] = D[56- 7];
			CEX[27] = D[56-27];
			CEX[26] = D[56-20];
			CEX[25] = D[56-13];
			CEX[24] = D[56- 2];
			CEX[23] = D[56-41];
			CEX[22] = D[56-52];
			CEX[21] = D[56-31];
			CEX[20] = D[56-37];
			CEX[19] = D[56-47];
			CEX[18] = D[56-55];
			CEX[17] = D[56-30];
			CEX[16] = D[56-40];
			CEX[15] = D[56-51];
			CEX[14] = D[56-45];
			CEX[13] = D[56-33];
			CEX[12] = D[56-48];
			CEX[11] = D[56-44];
			CEX[10] = D[56-49];
			CEX[ 9] = D[56-39];
			CEX[ 8] = D[56-56];		
			CEX[ 7] = D[56-34];
			CEX[ 6] = D[56-53];
			CEX[ 5] = D[56-46];
			CEX[ 4] = D[56-42];
			CEX[ 3] = D[56-50];
			CEX[ 2] = D[56-36];
			CEX[ 1] = D[56-29];
			CEX[ 0] = D[56-32];		
		end
	endfunction	
	
	assign s_key = i_key_en ? PBD(i_key) : r_key;
	//left shift 1|2 bits
	assign s_lskey = ((r_count==4'd0)||(r_count==4'd1)||(r_count==4'd8)||(r_count==4'd15)) ? {ROL(s_key[55:28],1),ROL(s_key[27:0],1)} : {ROL(s_key[55:28],2),ROL(s_key[27:0],2)};
	assign s_exk = CEX(s_lskey);
	
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst)
			r_key <= #DLY 56'b0;
		else if(s_busy)
			r_key <= #DLY s_lskey;
	end	
	
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst) begin
			r_exkey <= #DLY 768'b0;
		end else if(s_busy)begin
			r_exkey <= #DLY {r_exkey[48*15-1:0],s_exk};
		end
	end	
	
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst)
			r_count <= #DLY 4'd0;
		else if(i_key_en)
			r_count <= #DLY 4'd1;
		else if(r_count!=4'd0)
			r_count <= #DLY r_count + 4'd1;
	end

	assign o_exkey = r_exkey;

	assign s_busy = ((r_count!=5'd0)||(i_key_en==1'b1)) ? 1'b1 : 1'b0;
	
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst)
			r_key_ok <= #DLY 1'b0;
		else if(r_count==4'd15)
			r_key_ok <= #DLY 1'b1;
		else if(i_key_en==1'b1)
			r_key_ok <= #DLY 1'b0;
	end
	
	assign o_key_ok = r_key_ok&(~i_key_en);
	
endmodule
