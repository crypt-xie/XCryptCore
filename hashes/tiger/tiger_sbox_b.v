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
// File name        :   tiger_sbox_b.v
// Function         :   Tiger Hash Algorithm SBox-B
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          £º  v-1.0
// Date				:   2019-1-22
// Email            :   xcrypt@126.com
// ------------------------------------------------------------------------------

module tiger_sbox_b(
	input			i_clk,
	input	[7:0]	i_addr,
	output  [63:0]	o_data
	);
	
	localparam 	DLY = 1;
	
	reg [63:0]	r_dout;
	
	always@(posedge i_clk) begin
		case(i_addr)
			8'h00 : r_dout <= #DLY 64'he6a6be5a05a12138;
			8'h01 : r_dout <= #DLY 64'hb5a122a5b4f87c98;
			8'h02 : r_dout <= #DLY 64'h563c6089140b6990;
			8'h03 : r_dout <= #DLY 64'h4c46cb2e391f5dd5;
			8'h04 : r_dout <= #DLY 64'hd932addbc9b79434;
			8'h05 : r_dout <= #DLY 64'h08ea70e42015aff5;
			8'h06 : r_dout <= #DLY 64'hd765a6673e478cf1;
			8'h07 : r_dout <= #DLY 64'hc4fb757eab278d99;
			8'h08 : r_dout <= #DLY 64'hdf11c6862d6e0692;
			8'h09 : r_dout <= #DLY 64'hddeb84f10d7f3b16;
			8'h0a : r_dout <= #DLY 64'h6f2ef604a665ea04;
			8'h0b : r_dout <= #DLY 64'h4a8e0f0ff0e0dfb3;
			8'h0c : r_dout <= #DLY 64'ha5edeef83dbcba51;
			8'h0d : r_dout <= #DLY 64'hfc4f0a2a0ea4371e;
			8'h0e : r_dout <= #DLY 64'he83e1da85cb38429;
			8'h0f : r_dout <= #DLY 64'hdc8ff882ba1b1ce2;
			8'h10 : r_dout <= #DLY 64'hcd45505e8353e80d;
			8'h11 : r_dout <= #DLY 64'h18d19a00d4db0717;
			8'h12 : r_dout <= #DLY 64'h34a0cfeda5f38101;
			8'h13 : r_dout <= #DLY 64'h0be77e518887caf2;
			8'h14 : r_dout <= #DLY 64'h1e341438b3c45136;
			8'h15 : r_dout <= #DLY 64'he05797f49089ccf9;
			8'h16 : r_dout <= #DLY 64'hffd23f9df2591d14;
			8'h17 : r_dout <= #DLY 64'h543dda228595c5cd;
			8'h18 : r_dout <= #DLY 64'h661f81fd99052a33;
			8'h19 : r_dout <= #DLY 64'h8736e641db0f7b76;
			8'h1a : r_dout <= #DLY 64'h15227725418e5307;
			8'h1b : r_dout <= #DLY 64'he25f7f46162eb2fa;
			8'h1c : r_dout <= #DLY 64'h48a8b2126c13d9fe;
			8'h1d : r_dout <= #DLY 64'hafdc541792e76eea;
			8'h1e : r_dout <= #DLY 64'h03d912bfc6d1898f;
			8'h1f : r_dout <= #DLY 64'h31b1aafa1b83f51b;
			8'h20 : r_dout <= #DLY 64'hf1ac2796e42ab7d9;
			8'h21 : r_dout <= #DLY 64'h40a3a7d7fcd2ebac;
			8'h22 : r_dout <= #DLY 64'h1056136d0afbbcc5;
			8'h23 : r_dout <= #DLY 64'h7889e1dd9a6d0c85;
			8'h24 : r_dout <= #DLY 64'hd33525782a7974aa;
			8'h25 : r_dout <= #DLY 64'ha7e25d09078ac09b;
			8'h26 : r_dout <= #DLY 64'hbd4138b3eac6edd0;
			8'h27 : r_dout <= #DLY 64'h920abfbe71eb9e70;
			8'h28 : r_dout <= #DLY 64'ha2a5d0f54fc2625c;
			8'h29 : r_dout <= #DLY 64'hc054e36b0b1290a3;
			8'h2a : r_dout <= #DLY 64'hf6dd59ff62fe932b;
			8'h2b : r_dout <= #DLY 64'h3537354511a8ac7d;
			8'h2c : r_dout <= #DLY 64'hca845e9172fadcd4;
			8'h2d : r_dout <= #DLY 64'h84f82b60329d20dc;
			8'h2e : r_dout <= #DLY 64'h79c62ce1cd672f18;
			8'h2f : r_dout <= #DLY 64'h8b09a2add124642c;
			8'h30 : r_dout <= #DLY 64'hd0c1e96a19d9e726;
			8'h31 : r_dout <= #DLY 64'h5a786a9b4ba9500c;
			8'h32 : r_dout <= #DLY 64'h0e020336634c43f3;
			8'h33 : r_dout <= #DLY 64'hc17b474aeb66d822;
			8'h34 : r_dout <= #DLY 64'h6a731ae3ec9baac2;
			8'h35 : r_dout <= #DLY 64'h8226667ae0840258;
			8'h36 : r_dout <= #DLY 64'h67d4567691caeca5;
			8'h37 : r_dout <= #DLY 64'h1d94155c4875adb5;
			8'h38 : r_dout <= #DLY 64'h6d00fd985b813fdf;
			8'h39 : r_dout <= #DLY 64'h51286efcb774cd06;
			8'h3a : r_dout <= #DLY 64'h5e8834471fa744af;
			8'h3b : r_dout <= #DLY 64'hf72ca0aee761ae2e;
			8'h3c : r_dout <= #DLY 64'hbe40e4cdaee8e09a;
			8'h3d : r_dout <= #DLY 64'he9970bbb5118f665;
			8'h3e : r_dout <= #DLY 64'h726e4beb33df1964;
			8'h3f : r_dout <= #DLY 64'h703b000729199762;
			8'h40 : r_dout <= #DLY 64'h4631d816f5ef30a7;
			8'h41 : r_dout <= #DLY 64'hb880b5b51504a6be;
			8'h42 : r_dout <= #DLY 64'h641793c37ed84b6c;
			8'h43 : r_dout <= #DLY 64'h7b21ed77f6e97d96;
			8'h44 : r_dout <= #DLY 64'h776306312ef96b73;
			8'h45 : r_dout <= #DLY 64'hae528948e86ff3f4;
			8'h46 : r_dout <= #DLY 64'h53dbd7f286a3f8f8;
			8'h47 : r_dout <= #DLY 64'h16cadce74cfc1063;
			8'h48 : r_dout <= #DLY 64'h005c19bdfa52c6dd;
			8'h49 : r_dout <= #DLY 64'h68868f5d64d46ad3;
			8'h4a : r_dout <= #DLY 64'h3a9d512ccf1e186a;
			8'h4b : r_dout <= #DLY 64'h367e62c2385660ae;
			8'h4c : r_dout <= #DLY 64'he359e7ea77dcb1d7;
			8'h4d : r_dout <= #DLY 64'h526c0773749abe6e;
			8'h4e : r_dout <= #DLY 64'h735ae5f9d09f734b;
			8'h4f : r_dout <= #DLY 64'h493fc7cc8a558ba8;
			8'h50 : r_dout <= #DLY 64'hb0b9c1533041ab45;
			8'h51 : r_dout <= #DLY 64'h321958ba470a59bd;
			8'h52 : r_dout <= #DLY 64'h852db00b5f46c393;
			8'h53 : r_dout <= #DLY 64'h91209b2bd336b0e5;
			8'h54 : r_dout <= #DLY 64'h6e604f7d659ef19f;
			8'h55 : r_dout <= #DLY 64'hb99a8ae2782ccb24;
			8'h56 : r_dout <= #DLY 64'hccf52ab6c814c4c7;
			8'h57 : r_dout <= #DLY 64'h4727d9afbe11727b;
			8'h58 : r_dout <= #DLY 64'h7e950d0c0121b34d;
			8'h59 : r_dout <= #DLY 64'h756f435670ad471f;
			8'h5a : r_dout <= #DLY 64'hf5add442615a6849;
			8'h5b : r_dout <= #DLY 64'h4e87e09980b9957a;
			8'h5c : r_dout <= #DLY 64'h2acfa1df50aee355;
			8'h5d : r_dout <= #DLY 64'hd898263afd2fd556;
			8'h5e : r_dout <= #DLY 64'hc8f4924dd80c8fd6;
			8'h5f : r_dout <= #DLY 64'hcf99ca3d754a173a;
			8'h60 : r_dout <= #DLY 64'hfe477bacaf91bf3c;
			8'h61 : r_dout <= #DLY 64'hed5371f6d690c12d;
			8'h62 : r_dout <= #DLY 64'h831a5c285e687094;
			8'h63 : r_dout <= #DLY 64'hc5d3c90a3708a0a4;
			8'h64 : r_dout <= #DLY 64'h0f7f903717d06580;
			8'h65 : r_dout <= #DLY 64'h19f9bb13b8fdf27f;
			8'h66 : r_dout <= #DLY 64'hb1bd6f1b4d502843;
			8'h67 : r_dout <= #DLY 64'h1c761ba38fff4012;
			8'h68 : r_dout <= #DLY 64'h0d1530c4e2e21f3b;
			8'h69 : r_dout <= #DLY 64'h8943ce69a7372c8a;
			8'h6a : r_dout <= #DLY 64'he5184e11feb5ce66;
			8'h6b : r_dout <= #DLY 64'h618bdb80bd736621;
			8'h6c : r_dout <= #DLY 64'h7d29bad68b574d0b;
			8'h6d : r_dout <= #DLY 64'h81bb613e25e6fe5b;
			8'h6e : r_dout <= #DLY 64'h071c9c10bc07913f;
			8'h6f : r_dout <= #DLY 64'hc7beeb7909ac2d97;
			8'h70 : r_dout <= #DLY 64'hc3e58d353bc5d757;
			8'h71 : r_dout <= #DLY 64'heb017892f38f61e8;
			8'h72 : r_dout <= #DLY 64'hd4effb9c9b1cc21a;
			8'h73 : r_dout <= #DLY 64'h99727d26f494f7ab;
			8'h74 : r_dout <= #DLY 64'ha3e063a2956b3e03;
			8'h75 : r_dout <= #DLY 64'h9d4a8b9a4aa09c30;
			8'h76 : r_dout <= #DLY 64'h3f6ab7d500090fb4;
			8'h77 : r_dout <= #DLY 64'h9cc0f2a057268ac0;
			8'h78 : r_dout <= #DLY 64'h3dee9d2dedbf42d1;
			8'h79 : r_dout <= #DLY 64'h330f49c87960a972;
			8'h7a : r_dout <= #DLY 64'hc6b2720287421b41;
			8'h7b : r_dout <= #DLY 64'h0ac59ec07c00369c;
			8'h7c : r_dout <= #DLY 64'hef4eac49cb353425;
			8'h7d : r_dout <= #DLY 64'hf450244eef0129d8;
			8'h7e : r_dout <= #DLY 64'h8acc46e5caf4deb6;
			8'h7f : r_dout <= #DLY 64'h2ffeab63989263f7;
			8'h80 : r_dout <= #DLY 64'h8f7cb9fe5d7a4578;
			8'h81 : r_dout <= #DLY 64'h5bd8f7644e634635;
			8'h82 : r_dout <= #DLY 64'h427a7315bf2dc900;
			8'h83 : r_dout <= #DLY 64'h17d0c4aa2125261c;
			8'h84 : r_dout <= #DLY 64'h3992486c93518e50;
			8'h85 : r_dout <= #DLY 64'hb4cbfee0a2d7d4c3;
			8'h86 : r_dout <= #DLY 64'h7c75d6202c5ddd8d;
			8'h87 : r_dout <= #DLY 64'hdbc295d8e35b6c61;
			8'h88 : r_dout <= #DLY 64'h60b369d302032b19;
			8'h89 : r_dout <= #DLY 64'hce42685fdce44132;
			8'h8a : r_dout <= #DLY 64'h06f3ddb9ddf65610;
			8'h8b : r_dout <= #DLY 64'h8ea4d21db5e148f0;
			8'h8c : r_dout <= #DLY 64'h20b0fce62fcd496f;
			8'h8d : r_dout <= #DLY 64'h2c1b912358b0ee31;
			8'h8e : r_dout <= #DLY 64'hb28317b818f5a308;
			8'h8f : r_dout <= #DLY 64'ha89c1e189ca6d2cf;
			8'h90 : r_dout <= #DLY 64'h0c6b18576aaadbc8;
			8'h91 : r_dout <= #DLY 64'hb65deaa91299fae3;
			8'h92 : r_dout <= #DLY 64'hfb2b794b7f1027e7;
			8'h93 : r_dout <= #DLY 64'h04e4317f443b5beb;
			8'h94 : r_dout <= #DLY 64'h4b852d325939d0a6;
			8'h95 : r_dout <= #DLY 64'hd5ae6beefb207ffc;
			8'h96 : r_dout <= #DLY 64'h309682b281c7d374;
			8'h97 : r_dout <= #DLY 64'hbae309a194c3b475;
			8'h98 : r_dout <= #DLY 64'h8cc3f97b13b49f05;
			8'h99 : r_dout <= #DLY 64'h98a9422ff8293967;
			8'h9a : r_dout <= #DLY 64'h244b16b01076ff7c;
			8'h9b : r_dout <= #DLY 64'hf8bf571c663d67ee;
			8'h9c : r_dout <= #DLY 64'h1f0d6758eee30da1;
			8'h9d : r_dout <= #DLY 64'hc9b611d97adeb9b7;
			8'h9e : r_dout <= #DLY 64'hb7afd5887b6c57a2;
			8'h9f : r_dout <= #DLY 64'h6290ae846b984fe1;
			8'ha0 : r_dout <= #DLY 64'h94df4cdeacc1a5fd;
			8'ha1 : r_dout <= #DLY 64'h058a5bd1c5483aff;
			8'ha2 : r_dout <= #DLY 64'h63166cc142ba3c37;
			8'ha3 : r_dout <= #DLY 64'h8db8526eb2f76f40;
			8'ha4 : r_dout <= #DLY 64'he10880036f0d6d4e;
			8'ha5 : r_dout <= #DLY 64'h9e0523c9971d311d;
			8'ha6 : r_dout <= #DLY 64'h45ec2824cc7cd691;
			8'ha7 : r_dout <= #DLY 64'h575b8359e62382c9;
			8'ha8 : r_dout <= #DLY 64'hfa9e400dc4889995;
			8'ha9 : r_dout <= #DLY 64'hd1823ecb45721568;
			8'haa : r_dout <= #DLY 64'hdafd983b8206082f;
			8'hab : r_dout <= #DLY 64'haa7d29082386a8cb;
			8'hac : r_dout <= #DLY 64'h269fcd4403b87588;
			8'had : r_dout <= #DLY 64'h1b91f5f728bdd1e0;
			8'hae : r_dout <= #DLY 64'he4669f39040201f6;
			8'haf : r_dout <= #DLY 64'h7a1d7c218cf04ade;
			8'hb0 : r_dout <= #DLY 64'h65623c29d79ce5ce;
			8'hb1 : r_dout <= #DLY 64'h2368449096c00bb1;
			8'hb2 : r_dout <= #DLY 64'hab9bf1879da503ba;
			8'hb3 : r_dout <= #DLY 64'hbc23ecb1a458058e;
			8'hb4 : r_dout <= #DLY 64'h9a58df01bb401ecc;
			8'hb5 : r_dout <= #DLY 64'ha070e868a85f143d;
			8'hb6 : r_dout <= #DLY 64'h4ff188307df2239e;
			8'hb7 : r_dout <= #DLY 64'h14d565b41a641183;
			8'hb8 : r_dout <= #DLY 64'hee13337452701602;
			8'hb9 : r_dout <= #DLY 64'h950e3dcf3f285e09;
			8'hba : r_dout <= #DLY 64'h59930254b9c80953;
			8'hbb : r_dout <= #DLY 64'h3bf299408930da6d;
			8'hbc : r_dout <= #DLY 64'ha955943f53691387;
			8'hbd : r_dout <= #DLY 64'ha15edecaa9cb8784;
			8'hbe : r_dout <= #DLY 64'h29142127352be9a0;
			8'hbf : r_dout <= #DLY 64'h76f0371fff4e7afb;
			8'hc0 : r_dout <= #DLY 64'h0239f450274f2228;
			8'hc1 : r_dout <= #DLY 64'hbb073af01d5e868b;
			8'hc2 : r_dout <= #DLY 64'hbfc80571c10e96c1;
			8'hc3 : r_dout <= #DLY 64'hd267088568222e23;
			8'hc4 : r_dout <= #DLY 64'h9671a3d48e80b5b0;
			8'hc5 : r_dout <= #DLY 64'h55b5d38ae193bb81;
			8'hc6 : r_dout <= #DLY 64'h693ae2d0a18b04b8;
			8'hc7 : r_dout <= #DLY 64'h5c48b4ecadd5335f;
			8'hc8 : r_dout <= #DLY 64'hfd743b194916a1ca;
			8'hc9 : r_dout <= #DLY 64'h2577018134be98c4;
			8'hca : r_dout <= #DLY 64'he77987e83c54a4ad;
			8'hcb : r_dout <= #DLY 64'h28e11014da33e1b9;
			8'hcc : r_dout <= #DLY 64'h270cc59e226aa213;
			8'hcd : r_dout <= #DLY 64'h71495f756d1a5f60;
			8'hce : r_dout <= #DLY 64'h9be853fb60afef77;
			8'hcf : r_dout <= #DLY 64'hadc786a7f7443dbf;
			8'hd0 : r_dout <= #DLY 64'h0904456173b29a82;
			8'hd1 : r_dout <= #DLY 64'h58bc7a66c232bd5e;
			8'hd2 : r_dout <= #DLY 64'hf306558c673ac8b2;
			8'hd3 : r_dout <= #DLY 64'h41f639c6b6c9772a;
			8'hd4 : r_dout <= #DLY 64'h216defe99fda35da;
			8'hd5 : r_dout <= #DLY 64'h11640cc71c7be615;
			8'hd6 : r_dout <= #DLY 64'h93c43694565c5527;
			8'hd7 : r_dout <= #DLY 64'hea038e6246777839;
			8'hd8 : r_dout <= #DLY 64'hf9abf3ce5a3e2469;
			8'hd9 : r_dout <= #DLY 64'h741e768d0fd312d2;
			8'hda : r_dout <= #DLY 64'h0144b883ced652c6;
			8'hdb : r_dout <= #DLY 64'hc20b5a5ba33f8552;
			8'hdc : r_dout <= #DLY 64'h1ae69633c3435a9d;
			8'hdd : r_dout <= #DLY 64'h97a28ca4088cfdec;
			8'hde : r_dout <= #DLY 64'h8824a43c1e96f420;
			8'hdf : r_dout <= #DLY 64'h37612fa66eeea746;
			8'he0 : r_dout <= #DLY 64'h6b4cb165f9cf0e5a;
			8'he1 : r_dout <= #DLY 64'h43aa1c06a0abfb4a;
			8'he2 : r_dout <= #DLY 64'h7f4dc26ff162796b;
			8'he3 : r_dout <= #DLY 64'h6cbacc8e54ed9b0f;
			8'he4 : r_dout <= #DLY 64'ha6b7ffefd2bb253e;
			8'he5 : r_dout <= #DLY 64'h2e25bc95b0a29d4f;
			8'he6 : r_dout <= #DLY 64'h86d6a58bdef1388c;
			8'he7 : r_dout <= #DLY 64'hded74ac576b6f054;
			8'he8 : r_dout <= #DLY 64'h8030bdbc2b45805d;
			8'he9 : r_dout <= #DLY 64'h3c81af70e94d9289;
			8'hea : r_dout <= #DLY 64'h3eff6dda9e3100db;
			8'heb : r_dout <= #DLY 64'hb38dc39fdfcc8847;
			8'hec : r_dout <= #DLY 64'h123885528d17b87e;
			8'hed : r_dout <= #DLY 64'hf2da0ed240b1b642;
			8'hee : r_dout <= #DLY 64'h44cefadcd54bf9a9;
			8'hef : r_dout <= #DLY 64'h1312200e433c7ee6;
			8'hf0 : r_dout <= #DLY 64'h9ffcc84f3a78c748;
			8'hf1 : r_dout <= #DLY 64'hf0cd1f72248576bb;
			8'hf2 : r_dout <= #DLY 64'hec6974053638cfe4;
			8'hf3 : r_dout <= #DLY 64'h2ba7b67c0cec4e4c;
			8'hf4 : r_dout <= #DLY 64'hac2f4df3e5ce32ed;
			8'hf5 : r_dout <= #DLY 64'hcb33d14326ea4c11;
			8'hf6 : r_dout <= #DLY 64'ha4e9044cc77e58bc;
			8'hf7 : r_dout <= #DLY 64'h5f513293d934fcef;
			8'hf8 : r_dout <= #DLY 64'h5dc9645506e55444;
			8'hf9 : r_dout <= #DLY 64'h50de418f317de40a;
			8'hfa : r_dout <= #DLY 64'h388cb31a69dde259;
			8'hfb : r_dout <= #DLY 64'h2db4a83455820a86;
			8'hfc : r_dout <= #DLY 64'h9010a91e84711ae9;
			8'hfd : r_dout <= #DLY 64'h4df7f0b7b1498371;
			8'hfe : r_dout <= #DLY 64'hd62a2eabc0977179;
			8'hff : r_dout <= #DLY 64'h22fac097aa8d5c0e;
		endcase
	end
	
	assign o_data = r_dout;

endmodule