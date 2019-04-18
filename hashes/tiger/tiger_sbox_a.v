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
// File name        :   tiger_sbox_a.v
// Function         :   Tiger Cryptographic Hash Algorithm SBox-A
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          £º  v-1.0
// Date				:   2019-1-22
// Email            :   xcrypt@126.com
// ------------------------------------------------------------------------------

module tiger_sbox_a(
	input			i_clk,
	input	[7:0]	i_addr,
	output  [63:0]	o_data
	);
	
	localparam 	DLY = 1;
	
	reg [63:0]	r_dout;
	
	always@(posedge i_clk) begin
		case(i_addr)
			8'h00 : r_dout <= #DLY 64'h02aab17cf7e90c5e;
			8'h01 : r_dout <= #DLY 64'hac424b03e243a8ec;
			8'h02 : r_dout <= #DLY 64'h72cd5be30dd5fcd3;
			8'h03 : r_dout <= #DLY 64'h6d019b93f6f97f3a;
			8'h04 : r_dout <= #DLY 64'hcd9978ffd21f9193;
			8'h05 : r_dout <= #DLY 64'h7573a1c9708029e2;
			8'h06 : r_dout <= #DLY 64'hb164326b922a83c3;
			8'h07 : r_dout <= #DLY 64'h46883eee04915870;
			8'h08 : r_dout <= #DLY 64'heaace3057103ece6;
			8'h09 : r_dout <= #DLY 64'hc54169b808a3535c;
			8'h0a : r_dout <= #DLY 64'h4ce754918ddec47c;
			8'h0b : r_dout <= #DLY 64'h0aa2f4dfdc0df40c;
			8'h0c : r_dout <= #DLY 64'h10b76f18a74dbefa;
			8'h0d : r_dout <= #DLY 64'hc6ccb6235ad1ab6a;
			8'h0e : r_dout <= #DLY 64'h13726121572fe2ff;
			8'h0f : r_dout <= #DLY 64'h1a488c6f199d921e;
			8'h10 : r_dout <= #DLY 64'h4bc9f9f4da0007ca;
			8'h11 : r_dout <= #DLY 64'h26f5e6f6e85241c7;
			8'h12 : r_dout <= #DLY 64'h859079dbea5947b6;
			8'h13 : r_dout <= #DLY 64'h4f1885c5c99e8c92;
			8'h14 : r_dout <= #DLY 64'hd78e761ea96f864b;
			8'h15 : r_dout <= #DLY 64'h8e36428c52b5c17d;
			8'h16 : r_dout <= #DLY 64'h69cf6827373063c1;
			8'h17 : r_dout <= #DLY 64'hb607c93d9bb4c56e;
			8'h18 : r_dout <= #DLY 64'h7d820e760e76b5ea;
			8'h19 : r_dout <= #DLY 64'h645c9cc6f07fdc42;
			8'h1a : r_dout <= #DLY 64'hbf38a078243342e0;
			8'h1b : r_dout <= #DLY 64'h5f6b343c9d2e7d04;
			8'h1c : r_dout <= #DLY 64'hf2c28aeb600b0ec6;
			8'h1d : r_dout <= #DLY 64'h6c0ed85f7254bcac;
			8'h1e : r_dout <= #DLY 64'h71592281a4db4fe5;
			8'h1f : r_dout <= #DLY 64'h1967fa69ce0fed9f;
			8'h20 : r_dout <= #DLY 64'hfd5293f8b96545db;
			8'h21 : r_dout <= #DLY 64'hc879e9d7f2a7600b;
			8'h22 : r_dout <= #DLY 64'h860248920193194e;
			8'h23 : r_dout <= #DLY 64'ha4f9533b2d9cc0b3;
			8'h24 : r_dout <= #DLY 64'h9053836c15957613;
			8'h25 : r_dout <= #DLY 64'hdb6dcf8afc357bf1;
			8'h26 : r_dout <= #DLY 64'h18beea7a7a370f57;
			8'h27 : r_dout <= #DLY 64'h037117ca50b99066;
			8'h28 : r_dout <= #DLY 64'h6ab30a9774424a35;
			8'h29 : r_dout <= #DLY 64'hf4e92f02e325249b;
			8'h2a : r_dout <= #DLY 64'h7739db07061ccae1;
			8'h2b : r_dout <= #DLY 64'hd8f3b49ceca42a05;
			8'h2c : r_dout <= #DLY 64'hbd56be3f51382f73;
			8'h2d : r_dout <= #DLY 64'h45faed5843b0bb28;
			8'h2e : r_dout <= #DLY 64'h1c813d5c11bf1f83;
			8'h2f : r_dout <= #DLY 64'h8af0e4b6d75fa169;
			8'h30 : r_dout <= #DLY 64'h33ee18a487ad9999;
			8'h31 : r_dout <= #DLY 64'h3c26e8eab1c94410;
			8'h32 : r_dout <= #DLY 64'hb510102bc0a822f9;
			8'h33 : r_dout <= #DLY 64'h141eef310ce6123b;
			8'h34 : r_dout <= #DLY 64'hfc65b90059ddb154;
			8'h35 : r_dout <= #DLY 64'he0158640c5e0e607;
			8'h36 : r_dout <= #DLY 64'h884e079826c3a3cf;
			8'h37 : r_dout <= #DLY 64'h930d0d9523c535fd;
			8'h38 : r_dout <= #DLY 64'h35638d754e9a2b00;
			8'h39 : r_dout <= #DLY 64'h4085fccf40469dd5;
			8'h3a : r_dout <= #DLY 64'hc4b17ad28be23a4c;
			8'h3b : r_dout <= #DLY 64'hcab2f0fc6a3e6a2e;
			8'h3c : r_dout <= #DLY 64'h2860971a6b943fcd;
			8'h3d : r_dout <= #DLY 64'h3dde6ee212e30446;
			8'h3e : r_dout <= #DLY 64'h6222f32ae01765ae;
			8'h3f : r_dout <= #DLY 64'h5d550bb5478308fe;
			8'h40 : r_dout <= #DLY 64'ha9efa98da0eda22a;
			8'h41 : r_dout <= #DLY 64'hc351a71686c40da7;
			8'h42 : r_dout <= #DLY 64'h1105586d9c867c84;
			8'h43 : r_dout <= #DLY 64'hdcffee85fda22853;
			8'h44 : r_dout <= #DLY 64'hccfbd0262c5eef76;
			8'h45 : r_dout <= #DLY 64'hbaf294cb8990d201;
			8'h46 : r_dout <= #DLY 64'he69464f52afad975;
			8'h47 : r_dout <= #DLY 64'h94b013afdf133e14;
			8'h48 : r_dout <= #DLY 64'h06a7d1a32823c958;
			8'h49 : r_dout <= #DLY 64'h6f95fe5130f61119;
			8'h4a : r_dout <= #DLY 64'hd92ab34e462c06c0;
			8'h4b : r_dout <= #DLY 64'hed7bde33887c71d2;
			8'h4c : r_dout <= #DLY 64'h79746d6e6518393e;
			8'h4d : r_dout <= #DLY 64'h5ba419385d713329;
			8'h4e : r_dout <= #DLY 64'h7c1ba6b948a97564;
			8'h4f : r_dout <= #DLY 64'h31987c197bfdac67;
			8'h50 : r_dout <= #DLY 64'hde6c23c44b053d02;
			8'h51 : r_dout <= #DLY 64'h581c49fed002d64d;
			8'h52 : r_dout <= #DLY 64'hdd474d6338261571;
			8'h53 : r_dout <= #DLY 64'haa4546c3e473d062;
			8'h54 : r_dout <= #DLY 64'h928fce349455f860;
			8'h55 : r_dout <= #DLY 64'h48161bbacaab94d9;
			8'h56 : r_dout <= #DLY 64'h63912430770e6f68;
			8'h57 : r_dout <= #DLY 64'h6ec8a5e602c6641c;
			8'h58 : r_dout <= #DLY 64'h87282515337ddd2b;
			8'h59 : r_dout <= #DLY 64'h2cda6b42034b701b;
			8'h5a : r_dout <= #DLY 64'hb03d37c181cb096d;
			8'h5b : r_dout <= #DLY 64'he108438266c71c6f;
			8'h5c : r_dout <= #DLY 64'h2b3180c7eb51b255;
			8'h5d : r_dout <= #DLY 64'hdf92b82f96c08bbc;
			8'h5e : r_dout <= #DLY 64'h5c68c8c0a632f3ba;
			8'h5f : r_dout <= #DLY 64'h5504cc861c3d0556;
			8'h60 : r_dout <= #DLY 64'habbfa4e55fb26b8f;
			8'h61 : r_dout <= #DLY 64'h41848b0ab3baceb4;
			8'h62 : r_dout <= #DLY 64'hb334a273aa445d32;
			8'h63 : r_dout <= #DLY 64'hbca696f0a85ad881;
			8'h64 : r_dout <= #DLY 64'h24f6ec65b528d56c;
			8'h65 : r_dout <= #DLY 64'h0ce1512e90f4524a;
			8'h66 : r_dout <= #DLY 64'h4e9dd79d5506d35a;
			8'h67 : r_dout <= #DLY 64'h258905fac6ce9779;
			8'h68 : r_dout <= #DLY 64'h2019295b3e109b33;
			8'h69 : r_dout <= #DLY 64'hf8a9478b73a054cc;
			8'h6a : r_dout <= #DLY 64'h2924f2f934417eb0;
			8'h6b : r_dout <= #DLY 64'h3993357d536d1bc4;
			8'h6c : r_dout <= #DLY 64'h38a81ac21db6ff8b;
			8'h6d : r_dout <= #DLY 64'h47c4fbf17d6016bf;
			8'h6e : r_dout <= #DLY 64'h1e0faadd7667e3f5;
			8'h6f : r_dout <= #DLY 64'h7abcff62938beb96;
			8'h70 : r_dout <= #DLY 64'ha78dad948fc179c9;
			8'h71 : r_dout <= #DLY 64'h8f1f98b72911e50d;
			8'h72 : r_dout <= #DLY 64'h61e48eae27121a91;
			8'h73 : r_dout <= #DLY 64'h4d62f7ad31859808;
			8'h74 : r_dout <= #DLY 64'heceba345ef5ceaeb;
			8'h75 : r_dout <= #DLY 64'hf5ceb25ebc9684ce;
			8'h76 : r_dout <= #DLY 64'hf633e20cb7f76221;
			8'h77 : r_dout <= #DLY 64'ha32cdf06ab8293e4;
			8'h78 : r_dout <= #DLY 64'h985a202ca5ee2ca4;
			8'h79 : r_dout <= #DLY 64'hcf0b8447cc8a8fb1;
			8'h7a : r_dout <= #DLY 64'h9f765244979859a3;
			8'h7b : r_dout <= #DLY 64'ha8d516b1a1240017;
			8'h7c : r_dout <= #DLY 64'h0bd7ba3ebb5dc726;
			8'h7d : r_dout <= #DLY 64'he54bca55b86adb39;
			8'h7e : r_dout <= #DLY 64'h1d7a3afd6c478063;
			8'h7f : r_dout <= #DLY 64'h519ec608e7669edd;
			8'h80 : r_dout <= #DLY 64'h0e5715a2d149aa23;
			8'h81 : r_dout <= #DLY 64'h177d4571848ff194;
			8'h82 : r_dout <= #DLY 64'heeb55f3241014c22;
			8'h83 : r_dout <= #DLY 64'h0f5e5ca13a6e2ec2;
			8'h84 : r_dout <= #DLY 64'h8029927b75f5c361;
			8'h85 : r_dout <= #DLY 64'had139fabc3d6e436;
			8'h86 : r_dout <= #DLY 64'h0d5df1a94ccf402f;
			8'h87 : r_dout <= #DLY 64'h3e8bd948bea5dfc8;
			8'h88 : r_dout <= #DLY 64'ha5a0d357bd3ff77e;
			8'h89 : r_dout <= #DLY 64'ha2d12e251f74f645;
			8'h8a : r_dout <= #DLY 64'h66fd9e525e81a082;
			8'h8b : r_dout <= #DLY 64'h2e0c90ce7f687a49;
			8'h8c : r_dout <= #DLY 64'hc2e8bcbeba973bc5;
			8'h8d : r_dout <= #DLY 64'h000001bce509745f;
			8'h8e : r_dout <= #DLY 64'h423777bbe6dab3d6;
			8'h8f : r_dout <= #DLY 64'hd1661c7eaef06eb5;
			8'h90 : r_dout <= #DLY 64'ha1781f354daacfd8;
			8'h91 : r_dout <= #DLY 64'h2d11284a2b16affc;
			8'h92 : r_dout <= #DLY 64'hf1fc4f67fa891d1f;
			8'h93 : r_dout <= #DLY 64'h73ecc25dcb920ada;
			8'h94 : r_dout <= #DLY 64'hae610c22c2a12651;
			8'h95 : r_dout <= #DLY 64'h96e0a810d356b78a;
			8'h96 : r_dout <= #DLY 64'h5a9a381f2fe7870f;
			8'h97 : r_dout <= #DLY 64'hd5ad62ede94e5530;
			8'h98 : r_dout <= #DLY 64'hd225e5e8368d1427;
			8'h99 : r_dout <= #DLY 64'h65977b70c7af4631;
			8'h9a : r_dout <= #DLY 64'h99f889b2de39d74f;
			8'h9b : r_dout <= #DLY 64'h233f30bf54e1d143;
			8'h9c : r_dout <= #DLY 64'h9a9675d3d9a63c97;
			8'h9d : r_dout <= #DLY 64'h5470554ff334f9a8;
			8'h9e : r_dout <= #DLY 64'h166acb744a4f5688;
			8'h9f : r_dout <= #DLY 64'h70c74caab2e4aead;
			8'ha0 : r_dout <= #DLY 64'hf0d091646f294d12;
			8'ha1 : r_dout <= #DLY 64'h57b82a89684031d1;
			8'ha2 : r_dout <= #DLY 64'hefd95a5a61be0b6b;
			8'ha3 : r_dout <= #DLY 64'h2fbd12e969f2f29a;
			8'ha4 : r_dout <= #DLY 64'h9bd37013feff9fe8;
			8'ha5 : r_dout <= #DLY 64'h3f9b0404d6085a06;
			8'ha6 : r_dout <= #DLY 64'h4940c1f3166cfe15;
			8'ha7 : r_dout <= #DLY 64'h09542c4dcdf3defb;
			8'ha8 : r_dout <= #DLY 64'hb4c5218385cd5ce3;
			8'ha9 : r_dout <= #DLY 64'hc935b7dc4462a641;
			8'haa : r_dout <= #DLY 64'h3417f8a68ed3b63f;
			8'hab : r_dout <= #DLY 64'hb80959295b215b40;
			8'hac : r_dout <= #DLY 64'hf99cdaef3b8c8572;
			8'had : r_dout <= #DLY 64'h018c0614f8fcb95d;
			8'hae : r_dout <= #DLY 64'h1b14accd1a3acdf3;
			8'haf : r_dout <= #DLY 64'h84d471f200bb732d;
			8'hb0 : r_dout <= #DLY 64'hc1a3110e95e8da16;
			8'hb1 : r_dout <= #DLY 64'h430a7220bf1a82b8;
			8'hb2 : r_dout <= #DLY 64'hb77e090d39df210e;
			8'hb3 : r_dout <= #DLY 64'h5ef4bd9f3cd05e9d;
			8'hb4 : r_dout <= #DLY 64'h9d4ff6da7e57a444;
			8'hb5 : r_dout <= #DLY 64'hda1d60e183d4a5f8;
			8'hb6 : r_dout <= #DLY 64'hb287c38417998e47;
			8'hb7 : r_dout <= #DLY 64'hfe3edc121bb31886;
			8'hb8 : r_dout <= #DLY 64'hc7fe3ccc980ccbef;
			8'hb9 : r_dout <= #DLY 64'he46fb590189bfd03;
			8'hba : r_dout <= #DLY 64'h3732fd469a4c57dc;
			8'hbb : r_dout <= #DLY 64'h7ef700a07cf1ad65;
			8'hbc : r_dout <= #DLY 64'h59c64468a31d8859;
			8'hbd : r_dout <= #DLY 64'h762fb0b4d45b61f6;
			8'hbe : r_dout <= #DLY 64'h155baed099047718;
			8'hbf : r_dout <= #DLY 64'h68755e4c3d50baa6;
			8'hc0 : r_dout <= #DLY 64'he9214e7f22d8b4df;
			8'hc1 : r_dout <= #DLY 64'h2addbf532eac95f4;
			8'hc2 : r_dout <= #DLY 64'h32ae3909b4bd0109;
			8'hc3 : r_dout <= #DLY 64'h834df537b08e3450;
			8'hc4 : r_dout <= #DLY 64'hfa209da84220728d;
			8'hc5 : r_dout <= #DLY 64'h9e691d9b9efe23f7;
			8'hc6 : r_dout <= #DLY 64'h0446d288c4ae8d7f;
			8'hc7 : r_dout <= #DLY 64'h7b4cc524e169785b;
			8'hc8 : r_dout <= #DLY 64'h21d87f0135ca1385;
			8'hc9 : r_dout <= #DLY 64'hcebb400f137b8aa5;
			8'hca : r_dout <= #DLY 64'h272e2b66580796be;
			8'hcb : r_dout <= #DLY 64'h3612264125c2b0de;
			8'hcc : r_dout <= #DLY 64'h057702bdad1efbb2;
			8'hcd : r_dout <= #DLY 64'hd4babb8eacf84be9;
			8'hce : r_dout <= #DLY 64'h91583139641bc67b;
			8'hcf : r_dout <= #DLY 64'h8bdc2de08036e024;
			8'hd0 : r_dout <= #DLY 64'h603c8156f49f68ed;
			8'hd1 : r_dout <= #DLY 64'hf7d236f7dbef5111;
			8'hd2 : r_dout <= #DLY 64'h9727c4598ad21e80;
			8'hd3 : r_dout <= #DLY 64'ha08a0896670a5fd7;
			8'hd4 : r_dout <= #DLY 64'hcb4a8f4309eba9cb;
			8'hd5 : r_dout <= #DLY 64'h81af564b0f7036a1;
			8'hd6 : r_dout <= #DLY 64'hc0b99aa778199abd;
			8'hd7 : r_dout <= #DLY 64'h959f1ec83fc8e952;
			8'hd8 : r_dout <= #DLY 64'h8c505077794a81b9;
			8'hd9 : r_dout <= #DLY 64'h3acaaf8f056338f0;
			8'hda : r_dout <= #DLY 64'h07b43f50627a6778;
			8'hdb : r_dout <= #DLY 64'h4a44ab49f5eccc77;
			8'hdc : r_dout <= #DLY 64'h3bc3d6e4b679ee98;
			8'hdd : r_dout <= #DLY 64'h9cc0d4d1cf14108c;
			8'hde : r_dout <= #DLY 64'h4406c00b206bc8a0;
			8'hdf : r_dout <= #DLY 64'h82a18854c8d72d89;
			8'he0 : r_dout <= #DLY 64'h67e366b35c3c432c;
			8'he1 : r_dout <= #DLY 64'hb923dd61102b37f2;
			8'he2 : r_dout <= #DLY 64'h56ab2779d884271d;
			8'he3 : r_dout <= #DLY 64'hbe83e1b0ff1525af;
			8'he4 : r_dout <= #DLY 64'hfb7c65d4217e49a9;
			8'he5 : r_dout <= #DLY 64'h6bdbe0e76d48e7d4;
			8'he6 : r_dout <= #DLY 64'h08df828745d9179e;
			8'he7 : r_dout <= #DLY 64'h22ea6a9add53bd34;
			8'he8 : r_dout <= #DLY 64'he36e141c5622200a;
			8'he9 : r_dout <= #DLY 64'h7f805d1b8cb750ee;
			8'hea : r_dout <= #DLY 64'hafe5c7a59f58e837;
			8'heb : r_dout <= #DLY 64'he27f996a4fb1c23c;
			8'hec : r_dout <= #DLY 64'hd3867dfb0775f0d0;
			8'hed : r_dout <= #DLY 64'hd0e673de6e88891a;
			8'hee : r_dout <= #DLY 64'h123aeb9eafb86c25;
			8'hef : r_dout <= #DLY 64'h30f1d5d5c145b895;
			8'hf0 : r_dout <= #DLY 64'hbb434a2dee7269e7;
			8'hf1 : r_dout <= #DLY 64'h78cb67ecf931fa38;
			8'hf2 : r_dout <= #DLY 64'hf33b0372323bbf9c;
			8'hf3 : r_dout <= #DLY 64'h52d66336fb279c74;
			8'hf4 : r_dout <= #DLY 64'h505f33ac0afb4eaa;
			8'hf5 : r_dout <= #DLY 64'he8a5cd99a2cce187;
			8'hf6 : r_dout <= #DLY 64'h534974801e2d30bb;
			8'hf7 : r_dout <= #DLY 64'h8d2d5711d5876d90;
			8'hf8 : r_dout <= #DLY 64'h1f1a412891bc038e;
			8'hf9 : r_dout <= #DLY 64'hd6e2e71d82e56648;
			8'hfa : r_dout <= #DLY 64'h74036c3a497732b7;
			8'hfb : r_dout <= #DLY 64'h89b67ed96361f5ab;
			8'hfc : r_dout <= #DLY 64'hffed95d8f1ea02a2;
			8'hfd : r_dout <= #DLY 64'he72b3bd61464d43d;
			8'hfe : r_dout <= #DLY 64'ha6300f170bdc4820;
			8'hff : r_dout <= #DLY 64'hebc18760ed78a77a;
		endcase
	end
	
	assign o_data = r_dout;

endmodule