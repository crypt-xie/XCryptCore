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
// File name        :   xtea_core.v
// Function         :   XTEA Cryptographic Algorithm Core 
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          £º  v-1.0
// Date				:   2019-1-24
// Email            :   xcrypt@126.com
// ------------------------------------------------------------------------------

module xtea_core(
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
 
	wire  [1023:0] s_exkey_a;
	wire  [1023:0] s_exkey_b;
 
	//key expand
	xtea_keyex u_keyex(
	.i_clk		(i_clk		),
	.i_rst		(i_rst		),
	.i_key		(i_key		),
	.i_key_en	(i_key_en	),
	.o_exkey_a	(s_exkey_a	),
	.o_exkey_b	(s_exkey_b	),
	.o_key_ok	(o_key_ok	)	
	);

	//
	xtea_dpc u_dpc(
	.i_clk		(i_clk		),
	.i_rst		(i_rst		),	
	.i_flag		(i_flag		),
	.i_keyex_a	(s_exkey_a	),
	.i_keyex_b	(s_exkey_b	),
    .i_din		(i_din		),
    .i_din_en	(i_din_en	),
    .o_dout		(o_dout		),
    .o_dout_en	(o_dout_en	)
	);	
	
endmodule
