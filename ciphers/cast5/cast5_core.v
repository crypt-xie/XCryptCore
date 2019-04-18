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
// File name        :   cast5_core.v
// Function         :   CAST5 Cryptographic Algorithm Core (KeyLen = 16)
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          £º  v-1.0
// Date				:   2019-2-3
// Email            :   xcrypt@126.com
// ------------------------------------------------------------------------------

module cast5_core(
    input           i_clk,
    input           i_rst,
    input           i_flag,    //1-encrypt,0-decrypt
    input  [127:0]  i_key,
    input           i_key_en,  //1-key init start
	output 			o_key_ok,  //1-key init done
    input  [63:0]   i_din,
    input           i_din_en,
    output [63:0]   o_dout,
    output          o_dout_en
    );
 
	wire  [32*32-1:0]   s_exkey;
	wire 				s_sbox_use_ke;
	wire  [31:0]		s_sbox_din_ke;
	wire  [127:0]		s_sbox_dout;
	wire  [31:0]		s_sbox_din_dp;
	wire  [31:0]		s_sbox_din;
 
	//key expand
	cast5_keyex u_keyex(
	.i_clk		(i_clk			),
	.i_rst		(i_rst			),
	.i_key		(i_key			),
	.i_key_en	(i_key_en		),
	.o_exkey	(s_exkey		),
	.o_key_ok	(o_key_ok		),
	.o_sbox_use (s_sbox_use_ke	),
	.o_sbox_din	(s_sbox_din_ke	),
	.i_sbox_dout(s_sbox_dout	)
	);

	// data encrypt or decrypt
	cast5_dpc u_dpc(
	.i_clk		(i_clk			),
	.i_rst		(i_rst			),	
	.i_flag		(i_flag			),
	.i_keyex	(s_exkey		),
    .i_din		(i_din			),
    .i_din_en	(i_din_en		),
    .o_dout		(o_dout			),
    .o_dout_en	(o_dout_en		),
	.o_sbox_din	(s_sbox_din_dp	),
	.i_sbox_dout(s_sbox_dout	)
	);	
	
	assign s_sbox_din = s_sbox_use_ke ? s_sbox_din_ke : s_sbox_din_dp;
	
	cast5_sbox15 u_sbox15(
	.i_clk		(i_clk			),
	.i_sel		(~s_sbox_use_ke	), //1:SBox-1 0:SBox-5
    .i_addr		(s_sbox_din[31:24]),
    .o_data		(s_sbox_dout[127:96])
    );	
	
	cast5_sbox26 u_sbox26(
	.i_clk		(i_clk			),
	.i_sel		(~s_sbox_use_ke	), //1:SBox-2 0:SBox-6
    .i_addr		(s_sbox_din[23:16]),
    .o_data		(s_sbox_dout[95:64])
    );	

	cast5_sbox37 u_sbox37(
	.i_clk		(i_clk			),
	.i_sel		(~s_sbox_use_ke	), //1:SBox-3 0:SBox-7
    .i_addr		(s_sbox_din[15:8]),
    .o_data		(s_sbox_dout[63:32])
    );	

	cast5_sbox48 u_sbox48(
	.i_clk		(i_clk			),
	.i_sel		(~s_sbox_use_ke	), //1:SBox-4 0:SBox-8
    .i_addr		(s_sbox_din[7:0]),
    .o_data		(s_sbox_dout[31:0])
    );		
	
	
endmodule
