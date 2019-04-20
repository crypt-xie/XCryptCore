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
                                                                 
// ----------------------------------------------------------------------
// File name        :   aes256_core.v
// Function         :   AES-256 Cryptographic Algorithm Core 
// ----------------------------------------------------------------------
// Author           :   Xie
// Version          £º  v-1.0
// Date				:   2019-4-20
// Email            :   xcrypt@126.com
// ----------------------------------------------------------------------

`timescale 1ns / 1ps

module aes256_core(
    input           i_clk,
    input           i_rst,
    input           i_flag,    //1-encrypt,0-decrypt
    input  [255:0]  i_key,
    input           i_key_en,  //1-key init start
	output 			o_key_ok,  //1-key init done
    input  [127:0]  i_din,
    input           i_din_en,
    output [127:0]  o_dout,
    output          o_dout_en
    );
 
	wire  [128*15-1:0] 	s_exkey;  //60 words
	//KeyExpand
	wire        		s_sbox_use_ke;
	wire  [63:0]		s_sbox_din_ke;
	wire  [63:0]		s_sbox_dout_ke;
	//DataProcess
	wire  [127:0]		s_sbox_din_dp;
	wire  [127:0]		s_sbox_dout_dp;
	//SubByte S-Box
	wire  [127:0]	   	s_sbox_din;
	wire  [127:0]	   	s_sbox_dout;
	wire  [127:0]		s_sbox_dout_p;
	wire  [127:0]		s_sbox_dout_n;
	//
	genvar i;	
 
	//key expand
	aes256_keyex u_keyex(
	.i_clk		(i_clk			),
	.i_rst		(i_rst			),
	.i_key		(i_key			),
	.i_key_en	(i_key_en		),
	.o_exkey	(s_exkey		),
	.o_key_ok	(o_key_ok		),
	.o_sbox_use (s_sbox_use_ke	),
	.o_sbox_din	(s_sbox_din_ke 	),
	.i_sbox_dout(s_sbox_dout_ke	)
	);

	//data encrypt or decrypt
	aes256_dpc u_dpc(
	.i_clk		(i_clk			),
	.i_rst		(i_rst			),	
	.i_flag		(i_flag			),
	.i_keyex	(s_exkey		),
    .i_din		(i_din			),
    .i_din_en	(i_din_en		),
    .o_dout		(o_dout			),
    .o_dout_en	(o_dout_en		),
	.o_sbox_din	(s_sbox_din_dp 	),
	.i_sbox_dout(s_sbox_dout_dp	)	
	);	
	
	assign s_sbox_din = s_sbox_use_ke ? {64'b0,s_sbox_din_ke} : s_sbox_din_dp;
	assign s_sbox_dout_ke = s_sbox_dout_p[63:0];
	assign s_sbox_dout_dp = i_flag ? s_sbox_dout_p:s_sbox_dout_n;
	
	generate 
		for(i=0;i<16;i=i+1) begin: INST_SBOX_P
			aes_sbox_p u_sbox_p(
			.din	(s_sbox_din[8*i+7:8*i]	 ),
			.dout	(s_sbox_dout_p[8*i+7:8*i])
			);
		end
		
		for(i=0;i<16;i=i+1) begin: INST_SBOX_N
			aes_sbox_n u_sbox_n(
			.din	(s_sbox_din[8*i+7:8*i]	 ),
			.dout	(s_sbox_dout_n[8*i+7:8*i])
			);
		end		
	endgenerate
	
	
endmodule
