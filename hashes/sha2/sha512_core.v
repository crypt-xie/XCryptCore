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
// File name        :   sha512_core.v
// Function         :   SHA512 Hash Algorithm Core 
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          :   v-1.0
// Date				:   2019-1-24
// Email            :   xcrypt@126.com
// ------------------------------------------------------------------------------

module sha512_core(	
	input 			 i_clk,      //clock 
	input			 i_rst,      //reset high valid
	input			 i_start,    //high valid(only one clock)
	input	[1023:0] i_data,		//hash data input
	input	[511:0]	 i_vin,		//hash init value input(not change before o_done valid)
	output	[511:0]	 o_vout,     //hash value output   
	output			 o_done);    //high valid(only one clock) 

	reg 		 r_done;
	reg [6:0]	 r_count;
	reg [63:0]	 r_a,r_b,r_c,r_d,r_e,r_f,r_g,r_h;
	reg [5119:0] r_k;
	reg [1023:0] r_w;
	reg [2:0]	 r_state;	
		
	parameter IK = {
		64'h428a2f98d728ae22, 64'h7137449123ef65cd,
		64'hb5c0fbcfec4d3b2f, 64'he9b5dba58189dbbc,
		64'h3956c25bf348b538, 64'h59f111f1b605d019,
		64'h923f82a4af194f9b, 64'hab1c5ed5da6d8118,
		64'hd807aa98a3030242, 64'h12835b0145706fbe,
		64'h243185be4ee4b28c, 64'h550c7dc3d5ffb4e2,
		64'h72be5d74f27b896f, 64'h80deb1fe3b1696b1,
		64'h9bdc06a725c71235, 64'hc19bf174cf692694,
		64'he49b69c19ef14ad2, 64'hefbe4786384f25e3,
		64'h0fc19dc68b8cd5b5, 64'h240ca1cc77ac9c65,
		64'h2de92c6f592b0275, 64'h4a7484aa6ea6e483,
		64'h5cb0a9dcbd41fbd4, 64'h76f988da831153b5,
		64'h983e5152ee66dfab, 64'ha831c66d2db43210,
		64'hb00327c898fb213f, 64'hbf597fc7beef0ee4,
		64'hc6e00bf33da88fc2, 64'hd5a79147930aa725,
		64'h06ca6351e003826f, 64'h142929670a0e6e70,
		64'h27b70a8546d22ffc, 64'h2e1b21385c26c926,
		64'h4d2c6dfc5ac42aed, 64'h53380d139d95b3df,
		64'h650a73548baf63de, 64'h766a0abb3c77b2a8,
		64'h81c2c92e47edaee6, 64'h92722c851482353b,
		64'ha2bfe8a14cf10364, 64'ha81a664bbc423001,
		64'hc24b8b70d0f89791, 64'hc76c51a30654be30,
		64'hd192e819d6ef5218, 64'hd69906245565a910,
		64'hf40e35855771202a, 64'h106aa07032bbd1b8,
		64'h19a4c116b8d2d0c8, 64'h1e376c085141ab53,
		64'h2748774cdf8eeb99, 64'h34b0bcb5e19b48a8,
		64'h391c0cb3c5c95a63, 64'h4ed8aa4ae3418acb,
		64'h5b9cca4f7763e373, 64'h682e6ff3d6b2b8a3,
		64'h748f82ee5defb2fc, 64'h78a5636f43172f60,
		64'h84c87814a1f0ab72, 64'h8cc702081a6439ec,
		64'h90befffa23631e28, 64'ha4506cebde82bde9,
		64'hbef9a3f7b2c67915, 64'hc67178f2e372532b,
		64'hca273eceea26619c, 64'hd186b8c721c0c207,
		64'heada7dd6cde0eb1e, 64'hf57d4f7fee6ed178,
		64'h06f067aa72176fba, 64'h0a637dc5a2c898a6,
		64'h113f9804bef90dae, 64'h1b710b35131c471b,
		64'h28db77f523047d84, 64'h32caab7b40c72493,
		64'h3c9ebe0a15c9bebc, 64'h431d67c49c100d4c,
		64'h4cc5d4becb3e42b6, 64'h597f299cfc657e2a,
		64'h5fcb6fab3ad6faec, 64'h6c44198c4a475817
	};	
	
	//W[i] = Gamma1(W[i - 2]) + W[i - 7] + Gamma0(W[i - 15]) + W[i - 16];
	//#define Gamma0(x)       (S(x, 1) ^ S(x, 8) ^ R(x, 7))
	//#define Gamma1(x)       (S(x, 19) ^ S(x, 61) ^ R(x, 6))
	function [63:0]	WG;
		input [63:0] a,b,c,d;
		begin
			WG = ({a[18:0],a[63:19]}^{a[60:0],a[63:61]}^{10'b0,a[63:6]}) + b 
				+ ({c[0],c[63:1]}^{c[7:0],c[63:8]}^{3'b0,c[63:7]}) + d;
		end
	endfunction
	//t0 = S[7] + Sigma1(S[4]) + Ch(S[4], S[5], S[6]) + K[i] + W[i];
	
	//#define Sigma1(x)       (S(x, 14) ^ S(x, 18) ^ S(x, 41))
	function [63:0] T0;
		input	[63:0]	a,b,c,d,e,f,g,h,k,w;
		begin
			T0 = h + ({e[13:0],e[63:14]}^{e[17:0],e[63:18]}^{e[40:0],e[63:41]}) 
				+ (g^(e&(f^g))) + k + w;
		end
	endfunction
	
	//t1 = Sigma0(S[0]) + Maj(S[0], S[1], S[2]);
	//#define Sigma0(x)       (S(x, 28) ^ S(x, 34) ^ S(x, 39))
	function [63:0] T1;
		input	[63:0]	a,b,c;
		begin
			T1 = ({a[27:0],a[63:28]}^{a[33:0],a[63:34]}^{a[38:0],a[63:39]})
				+ (((a | b) & c) | (a & b));
		end
	endfunction		
	
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst) begin
			r_done <= 1'b0;
			r_count <= 7'b0;
			r_a <= 64'b0;
			r_b <= 64'b0;
			r_c <= 64'b0;
			r_d <= 64'b0;
			r_e <= 64'b0;
			r_f <= 64'b0;
			r_g <= 64'b0;
			r_h <= 64'b0;			
			r_k <= 5120'b0;	
			r_w <= 1024'b0;
			r_state <= 2'd0;
		end else begin
			case(r_state)
				2'd0: begin
					r_done <= 1'b0;
					r_count <= 7'b0;
					if(i_start) begin
						r_a <= i_vin[511:448];
						r_b <= i_vin[447:384];
						r_c <= i_vin[383:320];
						r_d <= i_vin[319:256];
						r_e <= i_vin[255:192];
						r_f <= i_vin[191:128];
						r_g <= i_vin[127:64];
						r_h <= i_vin[63:0];						
						r_k <= IK;
						r_w <= i_data;
						r_state <= 2'd1;
					end
				end
				2'd1: begin
					r_count <= r_count + 7'b1;
					r_a <= T0(r_a,r_b,r_c,r_d,r_e,r_f,r_g,r_h,r_k[5119:5056],r_w[1023:960])+T1(r_a,r_b,r_c);
					r_b <= r_a;
					r_c <= r_b;
					r_d <= r_c;
					r_e <= r_d + T0(r_a,r_b,r_c,r_d,r_e,r_f,r_g,r_h,r_k[5119:5056],r_w[1023:960]);
					r_f <= r_e;
					r_g <= r_f;
					r_h <= r_g;	
					r_k  <= {r_k[5055:0],64'b0};
					r_w  <= {r_w[959:0],WG(r_w[64*2-1:64],r_w[64*7-1:64*6],r_w[64*15-1:64*14],r_w[64*16-1:64*15])}; 
					if(r_count==7'd79) begin
						r_state <= 2'd2;
					end
				end
				2'd2: begin
					r_a <= r_a + i_vin[511:448];
					r_b <= r_b + i_vin[447:384];
					r_c <= r_c + i_vin[383:320];
					r_d <= r_d + i_vin[319:256];
					r_e <= r_e + i_vin[255:192];
					r_f <= r_f + i_vin[191:128];
					r_g <= r_g + i_vin[127:64];
					r_h <= r_h + i_vin[63:0];		
					r_done <= 1'b1;
					r_state <= 2'd0;
				end
				default: begin
					r_done <= 1'b0;
					r_count <= 7'b0;
					r_a <= 64'b0;
					r_b <= 64'b0;
					r_c <= 64'b0;
					r_d <= 64'b0;
					r_e <= 64'b0;
					r_f <= 64'b0;
					r_g <= 64'b0;
					r_h <= 64'b0;			
					r_k <= 5120'b0;	
					r_w <= 1024'b0;
					r_state <= 2'd0;		
				end
			endcase
		end
	end
	
	assign o_done = r_done;
	assign o_vout = {r_a,r_b,r_c,r_d,r_e,r_f,r_g,r_h};
	
	
endmodule
