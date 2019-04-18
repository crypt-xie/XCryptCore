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
// File name        :   tiger_sbox_c.v
// Function         :   Tiger Hash Algorithm SBox-C
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          £º  v-1.0
// Date				:   2019-1-22
// Email            :   xcrypt@126.com
// ------------------------------------------------------------------------------

module tiger_sbox_c(
	input			i_clk,
	input	[7:0]	i_addr,
	output  [63:0]	o_data
	);
	
	localparam 	DLY = 1;
	
	reg [63:0]	r_dout;
	
	always@(posedge i_clk) begin
		case(i_addr)
			8'h00 : r_dout <= #DLY 64'hf49fcc2ff1daf39b;
			8'h01 : r_dout <= #DLY 64'h487fd5c66ff29281;
			8'h02 : r_dout <= #DLY 64'he8a30667fcdca83f;
			8'h03 : r_dout <= #DLY 64'h2c9b4be3d2fcce63;
			8'h04 : r_dout <= #DLY 64'hda3ff74b93fbbbc2;
			8'h05 : r_dout <= #DLY 64'h2fa165d2fe70ba66;
			8'h06 : r_dout <= #DLY 64'ha103e279970e93d4;
			8'h07 : r_dout <= #DLY 64'hbecdec77b0e45e71;
			8'h08 : r_dout <= #DLY 64'hcfb41e723985e497;
			8'h09 : r_dout <= #DLY 64'hb70aaa025ef75017;
			8'h0a : r_dout <= #DLY 64'hd42309f03840b8e0;
			8'h0b : r_dout <= #DLY 64'h8efc1ad035898579;
			8'h0c : r_dout <= #DLY 64'h96c6920be2b2abc5;
			8'h0d : r_dout <= #DLY 64'h66af4163375a9172;
			8'h0e : r_dout <= #DLY 64'h2174abdcca7127fb;
			8'h0f : r_dout <= #DLY 64'hb33ccea64a72ff41;
			8'h10 : r_dout <= #DLY 64'hf04a4933083066a5;
			8'h11 : r_dout <= #DLY 64'h8d970acdd7289af5;
			8'h12 : r_dout <= #DLY 64'h8f96e8e031c8c25e;
			8'h13 : r_dout <= #DLY 64'hf3fec02276875d47;
			8'h14 : r_dout <= #DLY 64'hec7bf310056190dd;
			8'h15 : r_dout <= #DLY 64'hf5adb0aebb0f1491;
			8'h16 : r_dout <= #DLY 64'h9b50f8850fd58892;
			8'h17 : r_dout <= #DLY 64'h4975488358b74de8;
			8'h18 : r_dout <= #DLY 64'ha3354ff691531c61;
			8'h19 : r_dout <= #DLY 64'h0702bbe481d2c6ee;
			8'h1a : r_dout <= #DLY 64'h89fb24057deded98;
			8'h1b : r_dout <= #DLY 64'hac3075138596e902;
			8'h1c : r_dout <= #DLY 64'h1d2d3580172772ed;
			8'h1d : r_dout <= #DLY 64'heb738fc28e6bc30d;
			8'h1e : r_dout <= #DLY 64'h5854ef8f63044326;
			8'h1f : r_dout <= #DLY 64'h9e5c52325add3bbe;
			8'h20 : r_dout <= #DLY 64'h90aa53cf325c4623;
			8'h21 : r_dout <= #DLY 64'hc1d24d51349dd067;
			8'h22 : r_dout <= #DLY 64'h2051cfeea69ea624;
			8'h23 : r_dout <= #DLY 64'h13220f0a862e7e4f;
			8'h24 : r_dout <= #DLY 64'hce39399404e04864;
			8'h25 : r_dout <= #DLY 64'hd9c42ca47086fcb7;
			8'h26 : r_dout <= #DLY 64'h685ad2238a03e7cc;
			8'h27 : r_dout <= #DLY 64'h066484b2ab2ff1db;
			8'h28 : r_dout <= #DLY 64'hfe9d5d70efbf79ec;
			8'h29 : r_dout <= #DLY 64'h5b13b9dd9c481854;
			8'h2a : r_dout <= #DLY 64'h15f0d475ed1509ad;
			8'h2b : r_dout <= #DLY 64'h0bebcd060ec79851;
			8'h2c : r_dout <= #DLY 64'hd58c6791183ab7f8;
			8'h2d : r_dout <= #DLY 64'hd1187c5052f3eee4;
			8'h2e : r_dout <= #DLY 64'hc95d1192e54e82ff;
			8'h2f : r_dout <= #DLY 64'h86eea14cb9ac6ca2;
			8'h30 : r_dout <= #DLY 64'h3485beb153677d5d;
			8'h31 : r_dout <= #DLY 64'hdd191d781f8c492a;
			8'h32 : r_dout <= #DLY 64'hf60866baa784ebf9;
			8'h33 : r_dout <= #DLY 64'h518f643ba2d08c74;
			8'h34 : r_dout <= #DLY 64'h8852e956e1087c22;
			8'h35 : r_dout <= #DLY 64'ha768cb8dc410ae8d;
			8'h36 : r_dout <= #DLY 64'h38047726bfec8e1a;
			8'h37 : r_dout <= #DLY 64'ha67738b4cd3b45aa;
			8'h38 : r_dout <= #DLY 64'had16691cec0dde19;
			8'h39 : r_dout <= #DLY 64'hc6d4319380462e07;
			8'h3a : r_dout <= #DLY 64'hc5a5876d0ba61938;
			8'h3b : r_dout <= #DLY 64'h16b9fa1fa58fd840;
			8'h3c : r_dout <= #DLY 64'h188ab1173ca74f18;
			8'h3d : r_dout <= #DLY 64'habda2f98c99c021f;
			8'h3e : r_dout <= #DLY 64'h3e0580ab134ae816;
			8'h3f : r_dout <= #DLY 64'h5f3b05b773645abb;
			8'h40 : r_dout <= #DLY 64'h2501a2be5575f2f6;
			8'h41 : r_dout <= #DLY 64'h1b2f74004e7e8ba9;
			8'h42 : r_dout <= #DLY 64'h1cd7580371e8d953;
			8'h43 : r_dout <= #DLY 64'h7f6ed89562764e30;
			8'h44 : r_dout <= #DLY 64'hb15926ff596f003d;
			8'h45 : r_dout <= #DLY 64'h9f65293da8c5d6b9;
			8'h46 : r_dout <= #DLY 64'h6ecef04dd690f84c;
			8'h47 : r_dout <= #DLY 64'h4782275fff33af88;
			8'h48 : r_dout <= #DLY 64'he41433083f820801;
			8'h49 : r_dout <= #DLY 64'hfd0dfe409a1af9b5;
			8'h4a : r_dout <= #DLY 64'h4325a3342cdb396b;
			8'h4b : r_dout <= #DLY 64'h8ae77e62b301b252;
			8'h4c : r_dout <= #DLY 64'hc36f9e9f6655615a;
			8'h4d : r_dout <= #DLY 64'h85455a2d92d32c09;
			8'h4e : r_dout <= #DLY 64'hf2c7dea949477485;
			8'h4f : r_dout <= #DLY 64'h63cfb4c133a39eba;
			8'h50 : r_dout <= #DLY 64'h83b040cc6ebc5462;
			8'h51 : r_dout <= #DLY 64'h3b9454c8fdb326b0;
			8'h52 : r_dout <= #DLY 64'h56f56a9e87ffd78c;
			8'h53 : r_dout <= #DLY 64'h2dc2940d99f42bc6;
			8'h54 : r_dout <= #DLY 64'h98f7df096b096e2d;
			8'h55 : r_dout <= #DLY 64'h19a6e01e3ad852bf;
			8'h56 : r_dout <= #DLY 64'h42a99ccbdbd4b40b;
			8'h57 : r_dout <= #DLY 64'ha59998af45e9c559;
			8'h58 : r_dout <= #DLY 64'h366295e807d93186;
			8'h59 : r_dout <= #DLY 64'h6b48181bfaa1f773;
			8'h5a : r_dout <= #DLY 64'h1fec57e2157a0a1d;
			8'h5b : r_dout <= #DLY 64'h4667446af6201ad5;
			8'h5c : r_dout <= #DLY 64'he615ebcacfb0f075;
			8'h5d : r_dout <= #DLY 64'hb8f31f4f68290778;
			8'h5e : r_dout <= #DLY 64'h22713ed6ce22d11e;
			8'h5f : r_dout <= #DLY 64'h3057c1a72ec3c93b;
			8'h60 : r_dout <= #DLY 64'hcb46acc37c3f1f2f;
			8'h61 : r_dout <= #DLY 64'hdbb893fd02aaf50e;
			8'h62 : r_dout <= #DLY 64'h331fd92e600b9fcf;
			8'h63 : r_dout <= #DLY 64'ha498f96148ea3ad6;
			8'h64 : r_dout <= #DLY 64'ha8d8426e8b6a83ea;
			8'h65 : r_dout <= #DLY 64'ha089b274b7735cdc;
			8'h66 : r_dout <= #DLY 64'h87f6b3731e524a11;
			8'h67 : r_dout <= #DLY 64'h118808e5cbc96749;
			8'h68 : r_dout <= #DLY 64'h9906e4c7b19bd394;
			8'h69 : r_dout <= #DLY 64'hafed7f7e9b24a20c;
			8'h6a : r_dout <= #DLY 64'h6509eadeeb3644a7;
			8'h6b : r_dout <= #DLY 64'h6c1ef1d3e8ef0ede;
			8'h6c : r_dout <= #DLY 64'hb9c97d43e9798fb4;
			8'h6d : r_dout <= #DLY 64'ha2f2d784740c28a3;
			8'h6e : r_dout <= #DLY 64'h7b8496476197566f;
			8'h6f : r_dout <= #DLY 64'h7a5be3e6b65f069d;
			8'h70 : r_dout <= #DLY 64'hf96330ed78be6f10;
			8'h71 : r_dout <= #DLY 64'heee60de77a076a15;
			8'h72 : r_dout <= #DLY 64'h2b4bee4aa08b9bd0;
			8'h73 : r_dout <= #DLY 64'h6a56a63ec7b8894e;
			8'h74 : r_dout <= #DLY 64'h02121359ba34fef4;
			8'h75 : r_dout <= #DLY 64'h4cbf99f8283703fc;
			8'h76 : r_dout <= #DLY 64'h398071350caf30c8;
			8'h77 : r_dout <= #DLY 64'hd0a77a89f017687a;
			8'h78 : r_dout <= #DLY 64'hf1c1a9eb9e423569;
			8'h79 : r_dout <= #DLY 64'h8c7976282dee8199;
			8'h7a : r_dout <= #DLY 64'h5d1737a5dd1f7abd;
			8'h7b : r_dout <= #DLY 64'h4f53433c09a9fa80;
			8'h7c : r_dout <= #DLY 64'hfa8b0c53df7ca1d9;
			8'h7d : r_dout <= #DLY 64'h3fd9dcbc886ccb77;
			8'h7e : r_dout <= #DLY 64'hc040917ca91b4720;
			8'h7f : r_dout <= #DLY 64'h7dd00142f9d1dcdf;
			8'h80 : r_dout <= #DLY 64'h8476fc1d4f387b58;
			8'h81 : r_dout <= #DLY 64'h23f8e7c5f3316503;
			8'h82 : r_dout <= #DLY 64'h032a2244e7e37339;
			8'h83 : r_dout <= #DLY 64'h5c87a5d750f5a74b;
			8'h84 : r_dout <= #DLY 64'h082b4cc43698992e;
			8'h85 : r_dout <= #DLY 64'hdf917becb858f63c;
			8'h86 : r_dout <= #DLY 64'h3270b8fc5bf86dda;
			8'h87 : r_dout <= #DLY 64'h10ae72bb29b5dd76;
			8'h88 : r_dout <= #DLY 64'h576ac94e7700362b;
			8'h89 : r_dout <= #DLY 64'h1ad112dac61efb8f;
			8'h8a : r_dout <= #DLY 64'h691bc30ec5faa427;
			8'h8b : r_dout <= #DLY 64'hff246311cc327143;
			8'h8c : r_dout <= #DLY 64'h3142368e30e53206;
			8'h8d : r_dout <= #DLY 64'h71380e31e02ca396;
			8'h8e : r_dout <= #DLY 64'h958d5c960aad76f1;
			8'h8f : r_dout <= #DLY 64'hf8d6f430c16da536;
			8'h90 : r_dout <= #DLY 64'hc8ffd13f1be7e1d2;
			8'h91 : r_dout <= #DLY 64'h7578ae66004ddbe1;
			8'h92 : r_dout <= #DLY 64'h05833f01067be646;
			8'h93 : r_dout <= #DLY 64'hbb34b5ad3bfe586d;
			8'h94 : r_dout <= #DLY 64'h095f34c9a12b97f0;
			8'h95 : r_dout <= #DLY 64'h247ab64525d60ca8;
			8'h96 : r_dout <= #DLY 64'hdcdbc6f3017477d1;
			8'h97 : r_dout <= #DLY 64'h4a2e14d4decad24d;
			8'h98 : r_dout <= #DLY 64'hbdb5e6d9be0a1eeb;
			8'h99 : r_dout <= #DLY 64'h2a7e70f7794301ab;
			8'h9a : r_dout <= #DLY 64'hdef42d8a270540fd;
			8'h9b : r_dout <= #DLY 64'h01078ec0a34c22c1;
			8'h9c : r_dout <= #DLY 64'he5de511af4c16387;
			8'h9d : r_dout <= #DLY 64'h7ebb3a52bd9a330a;
			8'h9e : r_dout <= #DLY 64'h77697857aa7d6435;
			8'h9f : r_dout <= #DLY 64'h004e831603ae4c32;
			8'ha0 : r_dout <= #DLY 64'he7a21020ad78e312;
			8'ha1 : r_dout <= #DLY 64'h9d41a70c6ab420f2;
			8'ha2 : r_dout <= #DLY 64'h28e06c18ea1141e6;
			8'ha3 : r_dout <= #DLY 64'hd2b28cbd984f6b28;
			8'ha4 : r_dout <= #DLY 64'h26b75f6c446e9d83;
			8'ha5 : r_dout <= #DLY 64'hba47568c4d418d7f;
			8'ha6 : r_dout <= #DLY 64'hd80badbfe6183d8e;
			8'ha7 : r_dout <= #DLY 64'h0e206d7f5f166044;
			8'ha8 : r_dout <= #DLY 64'he258a43911cbca3e;
			8'ha9 : r_dout <= #DLY 64'h723a1746b21dc0bc;
			8'haa : r_dout <= #DLY 64'hc7caa854f5d7cdd3;
			8'hab : r_dout <= #DLY 64'h7cac32883d261d9c;
			8'hac : r_dout <= #DLY 64'h7690c26423ba942c;
			8'had : r_dout <= #DLY 64'h17e55524478042b8;
			8'hae : r_dout <= #DLY 64'he0be477656a2389f;
			8'haf : r_dout <= #DLY 64'h4d289b5e67ab2da0;
			8'hb0 : r_dout <= #DLY 64'h44862b9c8fbbfd31;
			8'hb1 : r_dout <= #DLY 64'hb47cc8049d141365;
			8'hb2 : r_dout <= #DLY 64'h822c1b362b91c793;
			8'hb3 : r_dout <= #DLY 64'h4eb14655fb13dfd8;
			8'hb4 : r_dout <= #DLY 64'h1ecbba0714e2a97b;
			8'hb5 : r_dout <= #DLY 64'h6143459d5cde5f14;
			8'hb6 : r_dout <= #DLY 64'h53a8fbf1d5f0ac89;
			8'hb7 : r_dout <= #DLY 64'h97ea04d81c5e5b00;
			8'hb8 : r_dout <= #DLY 64'h622181a8d4fdb3f3;
			8'hb9 : r_dout <= #DLY 64'he9bcd341572a1208;
			8'hba : r_dout <= #DLY 64'h1411258643cce58a;
			8'hbb : r_dout <= #DLY 64'h9144c5fea4c6e0a4;
			8'hbc : r_dout <= #DLY 64'h0d33d06565cf620f;
			8'hbd : r_dout <= #DLY 64'h54a48d489f219ca1;
			8'hbe : r_dout <= #DLY 64'hc43e5eac6d63c821;
			8'hbf : r_dout <= #DLY 64'ha9728b3a72770daf;
			8'hc0 : r_dout <= #DLY 64'hd7934e7b20df87ef;
			8'hc1 : r_dout <= #DLY 64'he35503b61a3e86e5;
			8'hc2 : r_dout <= #DLY 64'hcae321fbc819d504;
			8'hc3 : r_dout <= #DLY 64'h129a50b3ac60bfa6;
			8'hc4 : r_dout <= #DLY 64'hcd5e68ea7e9fb6c3;
			8'hc5 : r_dout <= #DLY 64'hb01c90199483b1c7;
			8'hc6 : r_dout <= #DLY 64'h3de93cd5c295376c;
			8'hc7 : r_dout <= #DLY 64'haed52edf2ab9ad13;
			8'hc8 : r_dout <= #DLY 64'h2e60f512c0a07884;
			8'hc9 : r_dout <= #DLY 64'hbc3d86a3e36210c9;
			8'hca : r_dout <= #DLY 64'h35269d9b163951ce;
			8'hcb : r_dout <= #DLY 64'h0c7d6e2ad0cdb5fa;
			8'hcc : r_dout <= #DLY 64'h59e86297d87f5733;
			8'hcd : r_dout <= #DLY 64'h298ef221898db0e7;
			8'hce : r_dout <= #DLY 64'h55000029d1a5aa7e;
			8'hcf : r_dout <= #DLY 64'h8bc08ae1b5061b45;
			8'hd0 : r_dout <= #DLY 64'hc2c31c2b6c92703a;
			8'hd1 : r_dout <= #DLY 64'h94cc596baf25ef42;
			8'hd2 : r_dout <= #DLY 64'h0a1d73db22540456;
			8'hd3 : r_dout <= #DLY 64'h04b6a0f9d9c4179a;
			8'hd4 : r_dout <= #DLY 64'heffdafa2ae3d3c60;
			8'hd5 : r_dout <= #DLY 64'hf7c8075bb49496c4;
			8'hd6 : r_dout <= #DLY 64'h9cc5c7141d1cd4e3;
			8'hd7 : r_dout <= #DLY 64'h78bd1638218e5534;
			8'hd8 : r_dout <= #DLY 64'hb2f11568f850246a;
			8'hd9 : r_dout <= #DLY 64'hedfabcfa9502bc29;
			8'hda : r_dout <= #DLY 64'h796ce5f2da23051b;
			8'hdb : r_dout <= #DLY 64'haae128b0dc93537c;
			8'hdc : r_dout <= #DLY 64'h3a493da0ee4b29ae;
			8'hdd : r_dout <= #DLY 64'hb5df6b2c416895d7;
			8'hde : r_dout <= #DLY 64'hfcabbd25122d7f37;
			8'hdf : r_dout <= #DLY 64'h70810b58105dc4b1;
			8'he0 : r_dout <= #DLY 64'he10fdd37f7882a90;
			8'he1 : r_dout <= #DLY 64'h524dcab5518a3f5c;
			8'he2 : r_dout <= #DLY 64'h3c9e85878451255b;
			8'he3 : r_dout <= #DLY 64'h4029828119bd34e2;
			8'he4 : r_dout <= #DLY 64'h74a05b6f5d3ceccb;
			8'he5 : r_dout <= #DLY 64'hb610021542e13eca;
			8'he6 : r_dout <= #DLY 64'h0ff979d12f59e2ac;
			8'he7 : r_dout <= #DLY 64'h6037da27e4f9cc50;
			8'he8 : r_dout <= #DLY 64'h5e92975a0df1847d;
			8'he9 : r_dout <= #DLY 64'hd66de190d3e623fe;
			8'hea : r_dout <= #DLY 64'h5032d6b87b568048;
			8'heb : r_dout <= #DLY 64'h9a36b7ce8235216e;
			8'hec : r_dout <= #DLY 64'h80272a7a24f64b4a;
			8'hed : r_dout <= #DLY 64'h93efed8b8c6916f7;
			8'hee : r_dout <= #DLY 64'h37ddbff44cce1555;
			8'hef : r_dout <= #DLY 64'h4b95db5d4b99bd25;
			8'hf0 : r_dout <= #DLY 64'h92d3fda169812fc0;
			8'hf1 : r_dout <= #DLY 64'hfb1a4a9a90660bb6;
			8'hf2 : r_dout <= #DLY 64'h730c196946a4b9b2;
			8'hf3 : r_dout <= #DLY 64'h81e289aa7f49da68;
			8'hf4 : r_dout <= #DLY 64'h64669a0f83b1a05f;
			8'hf5 : r_dout <= #DLY 64'h27b3ff7d9644f48b;
			8'hf6 : r_dout <= #DLY 64'hcc6b615c8db675b3;
			8'hf7 : r_dout <= #DLY 64'h674f20b9bcebbe95;
			8'hf8 : r_dout <= #DLY 64'h6f31238275655982;
			8'hf9 : r_dout <= #DLY 64'h5ae488713e45cf05;
			8'hfa : r_dout <= #DLY 64'hbf619f9954c21157;
			8'hfb : r_dout <= #DLY 64'heabac46040a8eae9;
			8'hfc : r_dout <= #DLY 64'h454c6fe9f2c0c1cd;
			8'hfd : r_dout <= #DLY 64'h419cf6496412691c;
			8'hfe : r_dout <= #DLY 64'hd3dc3bef265b0f70;
			8'hff : r_dout <= #DLY 64'h6d0e60f5c3578a9e;
		endcase
	end
	
	assign o_data = r_dout;

endmodule