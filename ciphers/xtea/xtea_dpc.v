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
// File name        :   xtea_dpc.v
// Function         :   XTEA Cryptographic Algorithm Core Data Encrypt&Decrypt
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          ：  v-1.0
// Date				:   2019-1-23
// Email            :   xcrypt@126.com
// copyright        ：  XCrypt Studio
// ------------------------------------------------------------------------------

module xtea_dpc(
	input			i_clk,
	input			i_rst,
	input 			i_flag,
	input  [1023:0] i_keyex_a,
	input  [1023:0]	i_keyex_b,
    input  [63:0]   i_din,
    input           i_din_en,
    output [63:0]   o_dout,
    output          o_dout_en
);

	localparam DLY = 1;

	reg [2:0]	r_count;	
	reg [127:0]	r_ka,r_kb;
	wire [31:0]	s_y,s_ya,s_yb,s_yc,s_yd;
	wire [31:0]	s_z,s_za,s_zb,s_zc,s_zd;
	reg [31:0]	r_y,r_z;
	wire [1023:0] s_keyex_a,s_keyex_b;
	wire [63:0] s_din;

	function [31:0] LS4;
		input [31:0] D;
		begin
			LS4 = {D[27:0],4'b0};
		end
	endfunction

	function [31:0] RS5;
		input [31:0] D;
		begin
			RS5 = {5'b0,D[31:5]};
		end
	endfunction
	
	function [127:0] SWAP128;
		input [127:0] D;
		begin
			SWAP128 = {D[31:0],D[63:32],D[95:64],D[127:96]};
		end
	endfunction
	
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst) 
			r_count <= #DLY 3'b0;
		else if(i_din_en)
			r_count <= #DLY 3'd1;
		else if(r_count!=3'd0)
			r_count <= #DLY r_count + 3'd1;
	end
	
	always@(*) begin
		if(i_flag) begin  //encrypt
			case(r_count)
				3'd0: r_ka = s_keyex_a[128*8-1:128*7];
				3'd1: r_ka = s_keyex_a[128*7-1:128*6];
				3'd2: r_ka = s_keyex_a[128*6-1:128*5];
				3'd3: r_ka = s_keyex_a[128*5-1:128*4];
				3'd4: r_ka = s_keyex_a[128*4-1:128*3];
				3'd5: r_ka = s_keyex_a[128*3-1:128*2];
				3'd6: r_ka = s_keyex_a[128*2-1:128*1];
				3'd7: r_ka = s_keyex_a[128*1-1:128*0];
			endcase
		end else begin  //decrypt
			case(r_count)
				3'd7: r_ka = SWAP128(s_keyex_a[128*8-1:128*7]);
				3'd6: r_ka = SWAP128(s_keyex_a[128*7-1:128*6]);
				3'd5: r_ka = SWAP128(s_keyex_a[128*6-1:128*5]);
				3'd4: r_ka = SWAP128(s_keyex_a[128*5-1:128*4]);
				3'd3: r_ka = SWAP128(s_keyex_a[128*4-1:128*3]);
				3'd2: r_ka = SWAP128(s_keyex_a[128*3-1:128*2]);
				3'd1: r_ka = SWAP128(s_keyex_a[128*2-1:128*1]);
				3'd0: r_ka = SWAP128(s_keyex_a[128*1-1:128*0]);
			endcase		
		end
	end

	always@(*) begin
		if(i_flag) begin  //encrypt
			case(r_count)
				3'd0: r_kb = s_keyex_b[128*8-1:128*7];
				3'd1: r_kb = s_keyex_b[128*7-1:128*6];
				3'd2: r_kb = s_keyex_b[128*6-1:128*5];
				3'd3: r_kb = s_keyex_b[128*5-1:128*4];
				3'd4: r_kb = s_keyex_b[128*4-1:128*3];
				3'd5: r_kb = s_keyex_b[128*3-1:128*2];
				3'd6: r_kb = s_keyex_b[128*2-1:128*1];
				3'd7: r_kb = s_keyex_b[128*1-1:128*0];
			endcase
		end else begin  //decrypt
			case(r_count)
				3'd7: r_kb = SWAP128(s_keyex_b[128*8-1:128*7]);
				3'd6: r_kb = SWAP128(s_keyex_b[128*7-1:128*6]);
				3'd5: r_kb = SWAP128(s_keyex_b[128*6-1:128*5]);
				3'd4: r_kb = SWAP128(s_keyex_b[128*5-1:128*4]);
				3'd3: r_kb = SWAP128(s_keyex_b[128*4-1:128*3]);
				3'd2: r_kb = SWAP128(s_keyex_b[128*3-1:128*2]); 
				3'd1: r_kb = SWAP128(s_keyex_b[128*2-1:128*1]);
				3'd0: r_kb = SWAP128(s_keyex_b[128*1-1:128*0]);
			endcase		
		end
	end
	
	assign s_din = i_flag ? i_din : {i_din[31:0],i_din[63:32]};
	assign s_keyex_a = i_flag ? i_keyex_a : i_keyex_b;
	assign s_keyex_b = i_flag ? i_keyex_b : i_keyex_a;
	
	assign s_y = (r_count==3'd0) ? s_din[63:32]:r_y;
	assign s_z = (r_count==3'd0) ? s_din[31:0]:r_z ;
	
	assign s_ya = i_flag ? (s_y  + (((LS4(s_z)^RS5(s_z)) + s_z)^r_ka[127:96]))   : (s_y  - (((LS4(s_z)^RS5(s_z)) + s_z)^r_ka[127:96]));
	assign s_za = i_flag ? (s_z  + (((LS4(s_ya)^RS5(s_ya)) + s_ya)^r_kb[127:96])): (s_z  - (((LS4(s_ya)^RS5(s_ya)) + s_ya)^r_kb[127:96]));
	assign s_yb = i_flag ? (s_ya + (((LS4(s_za)^RS5(s_za)) + s_za)^r_ka[95:64])) : (s_ya - (((LS4(s_za)^RS5(s_za)) + s_za)^r_ka[95:64]));
	assign s_zb = i_flag ? (s_za + (((LS4(s_yb)^RS5(s_yb)) + s_yb)^r_kb[95:64])) : (s_za - (((LS4(s_yb)^RS5(s_yb)) + s_yb)^r_kb[95:64])); 
	assign s_yc = i_flag ? (s_yb + (((LS4(s_zb)^RS5(s_zb)) + s_zb)^r_ka[63:32])) : (s_yb - (((LS4(s_zb)^RS5(s_zb)) + s_zb)^r_ka[63:32]));
	assign s_zc = i_flag ? (s_zb + (((LS4(s_yc)^RS5(s_yc)) + s_yc)^r_kb[63:32])) : (s_zb - (((LS4(s_yc)^RS5(s_yc)) + s_yc)^r_kb[63:32])); 	
	assign s_yd = i_flag ? (s_yc + (((LS4(s_zc)^RS5(s_zc)) + s_zc)^r_ka[31:0]))  : (s_yc - (((LS4(s_zc)^RS5(s_zc)) + s_zc)^r_ka[31:0]));
	assign s_zd = i_flag ? (s_zc + (((LS4(s_yd)^RS5(s_yd)) + s_yd)^r_kb[31:0]))  : (s_zc - (((LS4(s_yd)^RS5(s_yd)) + s_yd)^r_kb[31:0]));  	
	
	always@(posedge i_clk) begin
		r_y <= #DLY s_yd;
		r_z <= #DLY s_zd;
	end	
	
	assign o_dout = i_flag ? {s_yd,s_zd} :{s_zd,s_yd};
	assign o_dout_en = (r_count==3'd7) ? 1'b1:1'b0;
	
endmodule
