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
// File name        :   sm3_core.v
// Function         :   SM3 Hash Algorithm Core
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          ：  v-1.1
// Date		    :   2019-4-19
// Email            :   xcrypt@126.com
// ------------------------------------------------------------------------------

`timescale 1ns / 1ps

module sm3_core(
	input 			i_clk,      //clock 
	input			i_rst,      //reset high valid
	input			i_start,    //high valid(only one clock)
	input	[511:0]	i_data,		//hash data input
	input	[255:0]	i_vin,		//hash init value input(not change before o_done valid)
	output	[255:0]	o_vout,     //hash value output   
	output			o_done);    //high valid(only one clock) 

	localparam DLY = 1;
	
	wire	[31:0]	A,B,C,D,E,F,G,H;
	wire	[31:0]	W0,W1,W2,W3,W4,W5,W6,W7,W8,W9,W10,W11,W12,W13,W14,W15;
	wire	[31:0]	W16x,W16,W0j,SS1x,SS1,SS2,TT1,TT2,Tjl;
	reg 	[31:0]	r_A,r_B,r_C,r_D,r_E,r_F,r_G,r_H,r_Tjl;
	reg 	[511:0]	r_W;
	reg 	[6:0]	r_cnt;
	wire 			s_busy;
	
	assign {A,B,C,D,E,F,G,H} = i_start ? i_vin : {r_A,r_B,r_C,r_D,r_E,r_F,r_G,r_H};
	
	assign {W0,W1,W2,W3,W4,W5,W6,W7} = i_start ? i_data[511:256]:r_W[511:256];
	assign {W8,W9,W10,W11,W12,W13,W14,W15} = i_start ? i_data[255:0]:r_W[255:0];
	
	assign W16x = W0^W7^{W13[16:0],W13[31:17]};
	assign W16 = (W16x^{W16x[16:0],W16x[31:17]}^{W16x[8:0],W16x[31:9]})^{W3[24:0],W3[31:25]}^W10;
	assign W0j = W0^W4;
	assign Tjl = i_start ? 32'h79cc4519 : r_Tjl;
	assign SS1x =  {A[19:0],A[31:20]} + E + Tjl;
	assign SS1 = {SS1x[24:0],SS1x[31:25]};  
	assign SS2 = SS1^{A[19:0],A[31:20]};
	assign TT1 = (r_cnt<=7'd15) ? ((A^B^C)+D+SS2+W0j) : (((A&B)|(A&C)|(B&C))+D+SS2+W0j);
	assign TT2 = (r_cnt<=7'd15) ? ((E^F^G)+H+SS1+W0) : (((E&F)|((~E)&G))+H+SS1+W0);
	
	always@(posedge i_clk) begin
		if(i_rst) begin
			r_A <= #DLY 32'd0;
			r_B <= #DLY 32'd0;
			r_C <= #DLY 32'd0;
			r_D <= #DLY 32'd0;
			r_E <= #DLY 32'd0;
			r_F <= #DLY 32'd0;
			r_G <= #DLY 32'd0;
			r_H <= #DLY 32'd0;
		end else if(s_busy) begin
			r_D <= #DLY C;
			r_C <= #DLY {B[22:0],B[31:23]};
			r_B <= #DLY A;
			r_A <= #DLY TT1;
			r_H <= #DLY G;
			r_G <= #DLY {F[12:0],F[31:13]};
			r_F <= #DLY E;
			r_E <= #DLY (TT2^{TT2[22:0],TT2[31:23]}^{TT2[14:0],TT2[31:15]});
		end
	end
	
	always@(posedge i_clk) begin
		if(i_rst) 
			r_W <= #DLY 512'd0;
		else if(s_busy)
			r_W <= #DLY {W1,W2,W3,W4,W5,W6,W7,W8,W9,W10,W11,W12,W13,W14,W15,W16};
	end 
	
	always@(posedge i_clk) begin
		if(i_rst)
			r_cnt <= #DLY 7'd0;
		else if(i_start)
			r_cnt <= #DLY 7'd1;
		else if((r_cnt!=7'd0)&&(r_cnt!=7'd64))  
			r_cnt <= #DLY r_cnt + 7'd1;
		else 
			r_cnt <= #DLY 7'd0;
	end
	
	always@(posedge i_clk) begin
		if(i_rst)
			r_Tjl <= #DLY 32'h0;
		else if(r_cnt==7'd15)
			r_Tjl <= #DLY 32'h9d8a7a87;  //32'h7a879d8a<<16;
		else if(s_busy)
			r_Tjl <= #DLY {Tjl[30:0],Tjl[31]};
	end
	
	assign s_busy = ((r_cnt!=7'd0)||(i_start==1'b1)) ? 1'b1 : 1'b0;
	assign o_done = (r_cnt==7'd64) ? 1'b1:1'b0;
	assign o_vout = (r_cnt==7'd64) ? i_vin^{A,B,C,D,E,F,G,H} : 256'b0;
	
endmodule

	
	
