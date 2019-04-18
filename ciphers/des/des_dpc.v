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
// File name        :   des_dpc.v
// Function         :   DES Cryptographic Algorithm Core Data Encrypt&Decrypt
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          ：  v-1.0
// Date				:   2019-1-25
// Email            :   xcrypt@126.com
// ------------------------------------------------------------------------------

module des_dpc(
	input			i_clk,
	input			i_rst,
	input 			i_flag,
	input  [767:0] i_keyex,
    input  [63:0]   i_din,
    input           i_din_en,
    output [63:0]   o_dout,
    output          o_dout_en
);

	localparam DLY = 1;
	
	reg  [3:0]	r_count;	
	reg  [47:0]	r_ka;
	wire [31:0]	s_y;
	wire [31:0]	s_z;
	wire [47:0] s_za;
	wire [31:0] s_zb,s_zc;
	reg  [31:0]	r_y,r_z;
	wire [63:0] s_din;
	
	//initial permutation
	function [63:0]	IEX;
		input [63:0] D;
		begin	
			IEX[63] = D[64-58];
			IEX[62] = D[64-50];
			IEX[61] = D[64-42];
			IEX[60] = D[64-34];
			IEX[59] = D[64-26];
			IEX[58] = D[64-18];
			IEX[57] = D[64-10];
			IEX[56] = D[64- 2];		
			IEX[55] = D[64-60];
			IEX[54] = D[64-52];
			IEX[53] = D[64-44];
			IEX[52] = D[64-36];
			IEX[51] = D[64-28];
			IEX[50] = D[64-20];
			IEX[49] = D[64-12];
			IEX[48] = D[64- 4];
			IEX[47] = D[64-62];
			IEX[46] = D[64-54];
			IEX[45] = D[64-46];
			IEX[44] = D[64-38];
			IEX[43] = D[64-30];
			IEX[42] = D[64-22];
			IEX[41] = D[64-14];
			IEX[40] = D[64- 6];
			IEX[39] = D[64-64];
			IEX[38] = D[64-56];
			IEX[37] = D[64-48];
			IEX[36] = D[64-40];
			IEX[35] = D[64-32];
			IEX[34] = D[64-24];
			IEX[33] = D[64-16];
			IEX[32] = D[64- 8];
			IEX[31] = D[64-57];
			IEX[30] = D[64-49];
			IEX[29] = D[64-41];
			IEX[28] = D[64-33];
			IEX[27] = D[64-25];
			IEX[26] = D[64-17];
			IEX[25] = D[64- 9];
			IEX[24] = D[64- 1];
			IEX[23] = D[64-59];
			IEX[22] = D[64-51];
			IEX[21] = D[64-43];
			IEX[20] = D[64-35];
			IEX[19] = D[64-27];
			IEX[18] = D[64-19];
			IEX[17] = D[64-11];
			IEX[16] = D[64- 3];
			IEX[15] = D[64-61];
			IEX[14] = D[64-53];
			IEX[13] = D[64-45];
			IEX[12] = D[64-37];
			IEX[11] = D[64-29];
			IEX[10] = D[64-21];
			IEX[ 9] = D[64-13];
			IEX[ 8] = D[64- 5];		
			IEX[ 7] = D[64-63];
			IEX[ 6] = D[64-55];
			IEX[ 5] = D[64-47];
			IEX[ 4] = D[64-39];
			IEX[ 3] = D[64-31];
			IEX[ 2] = D[64-23];
			IEX[ 1] = D[64-15];
			IEX[ 0] = D[64- 7];					
		end
	endfunction
	
	//last permutation
	function [63:0]	LEX;
		input [63:0] D;
		begin	
			LEX[63] = D[64-40];
			LEX[62] = D[64- 8];
			LEX[61] = D[64-48];
			LEX[60] = D[64-16];
			LEX[59] = D[64-56];
			LEX[58] = D[64-24];
			LEX[57] = D[64-64];
			LEX[56] = D[64-32];		
			LEX[55] = D[64-39];
			LEX[54] = D[64- 7];
			LEX[53] = D[64-47];
			LEX[52] = D[64-15];
			LEX[51] = D[64-55];
			LEX[50] = D[64-23];
			LEX[49] = D[64-63];
			LEX[48] = D[64-31];
			LEX[47] = D[64-38];
			LEX[46] = D[64- 6];
			LEX[45] = D[64-46];
			LEX[44] = D[64-14];
			LEX[43] = D[64-54];
			LEX[42] = D[64-22];
			LEX[41] = D[64-62];
			LEX[40] = D[64-30];
			LEX[39] = D[64-37];
			LEX[38] = D[64- 5];
			LEX[37] = D[64-45];
			LEX[36] = D[64-13];
			LEX[35] = D[64-53];
			LEX[34] = D[64-21];
			LEX[33] = D[64-61];
			LEX[32] = D[64-29];
			LEX[31] = D[64-36];
			LEX[30] = D[64- 4];
			LEX[29] = D[64-44];
			LEX[28] = D[64-12];
			LEX[27] = D[64-52];
			LEX[26] = D[64-20];
			LEX[25] = D[64-60];
			LEX[24] = D[64-28];
			LEX[23] = D[64-35];
			LEX[22] = D[64- 3];
			LEX[21] = D[64-43];
			LEX[20] = D[64-11];
			LEX[19] = D[64-51];
			LEX[18] = D[64-19];
			LEX[17] = D[64-59];
			LEX[16] = D[64-27];
			LEX[15] = D[64-34];
			LEX[14] = D[64- 2];
			LEX[13] = D[64-42];
			LEX[12] = D[64-10];
			LEX[11] = D[64-50];
			LEX[10] = D[64-18];
			LEX[ 9] = D[64-58];
			LEX[ 8] = D[64-26];		
			LEX[ 7] = D[64-33];
			LEX[ 6] = D[64- 1];
			LEX[ 5] = D[64-41];
			LEX[ 4] = D[64- 9];
			LEX[ 3] = D[64-49];
			LEX[ 2] = D[64-17];
			LEX[ 1] = D[64-57];
			LEX[ 0] = D[64-25];					
		end
	endfunction

	function [47:0] KEX;
		input [31:0] D;
		begin
			//part8
			KEX[6*7+5] = D[0];
			KEX[6*7+4:6*7+1] = D[4*7+3:4*7];
			KEX[6*7+0] = D[4*7-1];
			//part7
			KEX[6*6+5] = D[4*6+4];
			KEX[6*6+4:6*6+1] = D[4*6+3:4*6];
			KEX[6*6+0] = D[4*6-1];	
			//part6
			KEX[6*5+5] = D[4*5+4];
			KEX[6*5+4:6*5+1] = D[4*5+3:4*5];
			KEX[6*5+0] = D[4*5-1];	
			//part5
			KEX[6*4+5] = D[4*4+4];
			KEX[6*4+4:6*4+1] = D[4*4+3:4*4];
			KEX[6*4+0] = D[4*4-1];	
			//part4
			KEX[6*3+5] = D[4*3+4];
			KEX[6*3+4:6*3+1] = D[4*3+3:4*3];
			KEX[6*3+0] = D[4*3-1];	
			//part3
			KEX[6*2+5] = D[4*2+4];
			KEX[6*2+4:6*2+1] = D[4*2+3:4*2];
			KEX[6*2+0] = D[4*2-1];	
			//part2
			KEX[6*1+5] = D[4*1+4];
			KEX[6*1+4:6*1+1] = D[4*1+3:4*1];
			KEX[6*1+0] = D[4*1-1];	
			//part1
			KEX[6*0+5] = D[4*0+4];
			KEX[6*0+4:6*0+1] = D[4*0+3:4*0];
			KEX[6*0+0] = D[31];				
		end
	endfunction
	
	function [31:0]	DEX;
		input [31:0] D;
		begin
			DEX[31] = D[32-16];
			DEX[30] = D[32- 7];
			DEX[29] = D[32-20];
			DEX[28] = D[32-21];
			DEX[27] = D[32-29];
			DEX[26] = D[32-12];
			DEX[25] = D[32-28];
			DEX[24] = D[32-17];
			DEX[23] = D[32- 1];
			DEX[22] = D[32-15];
			DEX[21] = D[32-23];
			DEX[20] = D[32-26];
			DEX[19] = D[32- 5];
			DEX[18] = D[32-18];
			DEX[17] = D[32-31];
			DEX[16] = D[32-10];
			DEX[15] = D[32- 2];
			DEX[14] = D[32- 8];
			DEX[13] = D[32-24];
			DEX[12] = D[32-14];
			DEX[11] = D[32-32];
			DEX[10] = D[32-27];
			DEX[ 9] = D[32- 3];
			DEX[ 8] = D[32- 9];		
			DEX[ 7] = D[32-19];
			DEX[ 6] = D[32-13];
			DEX[ 5] = D[32-30];
			DEX[ 4] = D[32- 6];
			DEX[ 3] = D[32-22];
			DEX[ 2] = D[32-11];
			DEX[ 1] = D[32- 4];
			DEX[ 0] = D[32-25];				
		end
	endfunction
	
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst) 
			r_count <= #DLY 3'b0;
		else if(i_din_en)
			r_count <= #DLY 3'd1;
		else if(r_count!=4'd0)
			r_count <= #DLY r_count + 4'd1;
	end
	
	always@(*) begin
		if(i_flag) begin  //encrypt
			case(r_count)
				4'd00: r_ka = i_keyex[48*16-1:48*15];
				4'd01: r_ka = i_keyex[48*15-1:48*14];
				4'd02: r_ka = i_keyex[48*14-1:48*13];
				4'd03: r_ka = i_keyex[48*13-1:48*12];
				4'd04: r_ka = i_keyex[48*12-1:48*11];
				4'd05: r_ka = i_keyex[48*11-1:48*10];
				4'd06: r_ka = i_keyex[48*10-1:48* 9];
				4'd07: r_ka = i_keyex[48* 9-1:48* 8];
				4'd08: r_ka = i_keyex[48* 8-1:48* 7];
				4'd09: r_ka = i_keyex[48* 7-1:48* 6];
				4'd10: r_ka = i_keyex[48* 6-1:48* 5];
				4'd11: r_ka = i_keyex[48* 5-1:48* 4];
				4'd12: r_ka = i_keyex[48* 4-1:48* 3];
				4'd13: r_ka = i_keyex[48* 3-1:48* 2];
				4'd14: r_ka = i_keyex[48* 2-1:48* 1];
				4'd15: r_ka = i_keyex[48* 1-1:48* 0];				
			endcase
		end else begin  //decrypt
			case(r_count)
				4'd15: r_ka = i_keyex[48*16-1:48*15];
				4'd14: r_ka = i_keyex[48*15-1:48*14];
				4'd13: r_ka = i_keyex[48*14-1:48*13];
				4'd12: r_ka = i_keyex[48*13-1:48*12];
				4'd11: r_ka = i_keyex[48*12-1:48*11];
				4'd10: r_ka = i_keyex[48*11-1:48*10];
				4'd09: r_ka = i_keyex[48*10-1:48* 9];
				4'd08: r_ka = i_keyex[48* 9-1:48* 8];
				4'd07: r_ka = i_keyex[48* 8-1:48* 7];
				4'd06: r_ka = i_keyex[48* 7-1:48* 6];
				4'd05: r_ka = i_keyex[48* 6-1:48* 5];
				4'd04: r_ka = i_keyex[48* 5-1:48* 4];
				4'd03: r_ka = i_keyex[48* 4-1:48* 3];
				4'd02: r_ka = i_keyex[48* 3-1:48* 2];
				4'd01: r_ka = i_keyex[48* 2-1:48* 1];
				4'd00: r_ka = i_keyex[48* 1-1:48* 0];		
			endcase		
		end
	end
	
	assign s_din = IEX(i_din);
	
	assign s_y = (r_count==3'd0) ? s_din[63:32]:r_y;  //left
	assign s_z = (r_count==3'd0) ? s_din[31:0]:r_z ;  //right
	
	assign s_za = KEX(s_z)^r_ka;
	
	des_sbox1 u_sbox1(.din(s_za[6*8-1:6*7]),.dout(s_zb[4*8-1:4*7]));
	des_sbox2 u_sbox2(.din(s_za[6*7-1:6*6]),.dout(s_zb[4*7-1:4*6]));
	des_sbox3 u_sbox3(.din(s_za[6*6-1:6*5]),.dout(s_zb[4*6-1:4*5]));
	des_sbox4 u_sbox4(.din(s_za[6*5-1:6*4]),.dout(s_zb[4*5-1:4*4]));
	des_sbox5 u_sbox5(.din(s_za[6*4-1:6*3]),.dout(s_zb[4*4-1:4*3]));
	des_sbox6 u_sbox6(.din(s_za[6*3-1:6*2]),.dout(s_zb[4*3-1:4*2]));
	des_sbox7 u_sbox7(.din(s_za[6*2-1:6*1]),.dout(s_zb[4*2-1:4*1]));
	des_sbox8 u_sbox8(.din(s_za[6*1-1:6*0]),.dout(s_zb[4*1-1:4*0]));
	
	assign s_zc = DEX(s_zb)^s_y;
	
	always@(posedge i_clk) begin
		r_y <= #DLY s_z;
		r_z <= #DLY s_zc;
	end	
	
	assign o_dout = LEX({s_zc,s_z});
	
	assign o_dout_en = (r_count==4'd15) ? 1'b1:1'b0;
	
endmodule
