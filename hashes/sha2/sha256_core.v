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
// File name        :   sha256_core.v
// Function         :   SHA256 Hash Algorithm Core 
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          :   v-1.0
// Date				:   2019-1-24
// Email            :   xcrypt@126.com
// ------------------------------------------------------------------------------

module sha256_core(	
	input 			i_clk,      //clock 
	input			i_rst,      //reset high valid
	input			i_start,    //high valid(only one clock)
	input	[511:0]	i_data,		//hash data input
	input	[255:0]	i_vin,		//hash init value input(not change before o_done valid)
	output	[255:0]	o_vout,     //hash value output   
	output			o_done);    //high valid(only one clock) 

	reg 		 r_done;
	reg [6:0]	 r_count;
	reg [31:0]	 r_a,r_b,r_c,r_d,r_e,r_f,r_g,r_h;
	reg [2047:0] r_k;
	reg [511:0]	 r_w;
	reg [2:0]	 r_state;	
		
	parameter IK = {
		32'h428a2f98, 32'h71374491, 32'hb5c0fbcf, 32'he9b5dba5, 32'h3956c25b,
		32'h59f111f1, 32'h923f82a4, 32'hab1c5ed5, 32'hd807aa98, 32'h12835b01,
		32'h243185be, 32'h550c7dc3, 32'h72be5d74, 32'h80deb1fe, 32'h9bdc06a7,
		32'hc19bf174, 32'he49b69c1, 32'hefbe4786, 32'h0fc19dc6, 32'h240ca1cc,
		32'h2de92c6f, 32'h4a7484aa, 32'h5cb0a9dc, 32'h76f988da, 32'h983e5152,
		32'ha831c66d, 32'hb00327c8, 32'hbf597fc7, 32'hc6e00bf3, 32'hd5a79147,
		32'h06ca6351, 32'h14292967, 32'h27b70a85, 32'h2e1b2138, 32'h4d2c6dfc,
		32'h53380d13, 32'h650a7354, 32'h766a0abb, 32'h81c2c92e, 32'h92722c85,
		32'ha2bfe8a1, 32'ha81a664b, 32'hc24b8b70, 32'hc76c51a3, 32'hd192e819,
		32'hd6990624, 32'hf40e3585, 32'h106aa070, 32'h19a4c116, 32'h1e376c08,
		32'h2748774c, 32'h34b0bcb5, 32'h391c0cb3, 32'h4ed8aa4a, 32'h5b9cca4f,
		32'h682e6ff3, 32'h748f82ee, 32'h78a5636f, 32'h84c87814, 32'h8cc70208,
		32'h90befffa, 32'ha4506ceb, 32'hbef9a3f7, 32'hc67178f2
	};	
	
	//W[i] = Gamma1(W[i - 2]) + W[i - 7] + Gamma0(W[i - 15]) + W[i - 16];
	//#define Gamma0(x)       (S(x, 7) ^ S(x, 18) ^ R(x, 3))
	//#define Gamma1(x)       (S(x, 17) ^ S(x, 19) ^ R(x, 10))
	function [31:0]	WG;
		input [31:0] a,b,c,d;
		begin
			WG = ({a[16:0],a[31:17]}^{a[18:0],a[31:19]}^{10'b0,a[31:10]}) + b 
				+ ({c[6:0],c[31:7]}^{c[17:0],c[31:18]}^{3'b0,c[31:3]}) + d;
		end
	endfunction
	
	function [31:0] T0;
		input	[31:0]	a,b,c,d,e,f,g,h,k,w;
		begin
			T0 = h + ({e[5:0],e[31:6]}^{e[10:0],e[31:11]}^{e[24:0],e[31:25]}) 
				+ (g^(e&(f^g))) + k + w;
		end
	endfunction
	
	function [31:0] T1;
		input	[31:0]	a,b,c;
		begin
			T1 = ({a[1:0],a[31:2]}^{a[12:0],a[31:13]}^{a[21:0],a[31:22]})
				+ (((a | b) & c) | (a & b));
		end
	endfunction		
	
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst) begin
			r_done <= 1'b0;
			r_count <= 7'b0;
			r_a <= 32'b0;
			r_b <= 32'b0;
			r_c <= 32'b0;
			r_d <= 32'b0;
			r_e <= 32'b0;
			r_f <= 32'b0;
			r_g <= 32'b0;
			r_h <= 32'b0;			
			r_k <= 2048'b0;	
			r_w <= 512'b0;
			r_state <= 2'd0;
		end else begin
			case(r_state)
				2'd0: begin
					r_done <= 1'b0;
					r_count <= 7'b0;
					if(i_start) begin
						r_a <= i_vin[255:224];
						r_b <= i_vin[223:192];
						r_c <= i_vin[191:160];
						r_d <= i_vin[159:128];
						r_e <= i_vin[127:96];
						r_f <= i_vin[95:64];
						r_g <= i_vin[63:32];
						r_h <= i_vin[31:0];						
						r_k <= IK;
						r_w <= i_data;
						r_state <= 2'd1;
					end
				end
				2'd1: begin
					r_count <= r_count + 7'b1;
					r_a <= T0(r_a,r_b,r_c,r_d,r_e,r_f,r_g,r_h,r_k[2047:2016],r_w[511:480])+T1(r_a,r_b,r_c);
					r_b <= r_a;
					r_c <= r_b;
					r_d <= r_c;
					r_e <= r_d + T0(r_a,r_b,r_c,r_d,r_e,r_f,r_g,r_h,r_k[2047:2016],r_w[511:480]);
					r_f <= r_e;
					r_g <= r_f;
					r_h <= r_g;	
					r_k  <= {r_k[2015:0],32'b0};
					//r_w  <= {r_w[511:480],WG(r_w[32*15-1:32*14],r_w[32*10-1:32*9],r_w[32*2-1:32*1],r_w[31:0])}; 
					r_w  <= {r_w[479:0],WG(r_w[32*2-1:32],r_w[32*7-1:32*6],r_w[32*15-1:32*14],r_w[32*16-1:32*15])}; 
					if(r_count==7'd63) begin
						r_state <= 2'd2;
					end
				end
				2'd2: begin
					r_a <= r_a + i_vin[255:224];
					r_b <= r_b + i_vin[223:192];
					r_c <= r_c + i_vin[191:160];
					r_d <= r_d + i_vin[159:128];
					r_e <= r_e + i_vin[127:96];
					r_f <= r_f + i_vin[95:64];
					r_g <= r_g + i_vin[63:32];
					r_h <= r_h + i_vin[31:0];	
					r_done <= 1'b1;
					r_state <= 2'd0;
				end
				default: begin
					r_done <= 1'b0;
					r_count <= 7'b0;
					r_a <= 32'b0;
					r_b <= 32'b0;
					r_c <= 32'b0;
					r_d <= 32'b0;
					r_e <= 32'b0;
					r_f <= 32'b0;
					r_g <= 32'b0;
					r_h <= 32'b0;			
					r_k <= 256'b0;	
					r_w <= 512'b0;
					r_state <= 2'd0;		
				end
			endcase
		end
	end
	
	assign o_done = r_done;
	assign o_vout = {r_a,r_b,r_c,r_d,r_e,r_f,r_g,r_h};
	
	
endmodule
