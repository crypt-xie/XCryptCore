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
// File name        :   des_core.v
// Function         :   DES Cryptographic Algorithm Core 
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          ��  v-1.0
// Date				:   2019-1-25
// Email            :   xcrypt@126.com
// copyright        ��  XCrypt Studio
// ------------------------------------------------------------------------------

module des_core(
    input           i_clk,
    input           i_rst,
    input           i_flag,    //1-encrypt,0-decrypt
    input  [63:0]   i_key,
    input           i_key_en,  //1-key init start
	output 			o_key_ok,  //1-key init done
    input  [63:0]   i_din,
    input           i_din_en,
    output [63:0]   o_dout,
    output          o_dout_en
    );
 
	wire  [48*16-1:0] s_exkey;
 
	//key expand
	des_keyex u_keyex(
	.i_clk		(i_clk		),
	.i_rst		(i_rst		),
	.i_key		(i_key		),
	.i_key_en	(i_key_en	),
	.o_exkey	(s_exkey	),
	.o_key_ok	(o_key_ok	)	
	);

	//data encrypt or decrypt
	des_dpc u_dpc(
	.i_clk		(i_clk		),
	.i_rst		(i_rst		),	
	.i_flag		(i_flag		),
	.i_keyex	(s_exkey	),
    .i_din		(i_din		),
    .i_din_en	(i_din_en	),
    .o_dout		(o_dout		),
    .o_dout_en	(o_dout_en	)
	);	
	
endmodule
