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
// File name        :   tiger_sbox_d.v
// Function         :   Tiger Hash Algorithm SBox-D
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          £º  v-1.0
// Date				:   2019-1-22
// Email            :   xcrypt@126.com
// ------------------------------------------------------------------------------

module tiger_sbox_d(
	input			i_clk,
	input	[7:0]	i_addr,
	output  [63:0]	o_data
	);
	
	localparam 	DLY = 1;
	
	reg [63:0]	r_dout;
	
	always@(posedge i_clk) begin
		case(i_addr)
			8'h00 : r_dout <= #DLY 64'h5b0e608526323c55;
			8'h01 : r_dout <= #DLY 64'h1a46c1a9fa1b59f5;
			8'h02 : r_dout <= #DLY 64'ha9e245a17c4c8ffa;
			8'h03 : r_dout <= #DLY 64'h65ca5159db2955d7;
			8'h04 : r_dout <= #DLY 64'h05db0a76ce35afc2;
			8'h05 : r_dout <= #DLY 64'h81eac77ea9113d45;
			8'h06 : r_dout <= #DLY 64'h528ef88ab6ac0a0d;
			8'h07 : r_dout <= #DLY 64'ha09ea253597be3ff;
			8'h08 : r_dout <= #DLY 64'h430ddfb3ac48cd56;
			8'h09 : r_dout <= #DLY 64'hc4b3a67af45ce46f;
			8'h0a : r_dout <= #DLY 64'h4ececfd8fbe2d05e;
			8'h0b : r_dout <= #DLY 64'h3ef56f10b39935f0;
			8'h0c : r_dout <= #DLY 64'h0b22d6829cd619c6;
			8'h0d : r_dout <= #DLY 64'h17fd460a74df2069;
			8'h0e : r_dout <= #DLY 64'h6cf8cc8e8510ed40;
			8'h0f : r_dout <= #DLY 64'hd6c824bf3a6ecaa7;
			8'h10 : r_dout <= #DLY 64'h61243d581a817049;
			8'h11 : r_dout <= #DLY 64'h048bacb6bbc163a2;
			8'h12 : r_dout <= #DLY 64'hd9a38ac27d44cc32;
			8'h13 : r_dout <= #DLY 64'h7fddff5baaf410ab;
			8'h14 : r_dout <= #DLY 64'had6d495aa804824b;
			8'h15 : r_dout <= #DLY 64'he1a6a74f2d8c9f94;
			8'h16 : r_dout <= #DLY 64'hd4f7851235dee8e3;
			8'h17 : r_dout <= #DLY 64'hfd4b7f886540d893;
			8'h18 : r_dout <= #DLY 64'h247c20042aa4bfda;
			8'h19 : r_dout <= #DLY 64'h096ea1c517d1327c;
			8'h1a : r_dout <= #DLY 64'hd56966b4361a6685;
			8'h1b : r_dout <= #DLY 64'h277da5c31221057d;
			8'h1c : r_dout <= #DLY 64'h94d59893a43acff7;
			8'h1d : r_dout <= #DLY 64'h64f0c51ccdc02281;
			8'h1e : r_dout <= #DLY 64'h3d33bcc4ff6189db;
			8'h1f : r_dout <= #DLY 64'he005cb184ce66af1;
			8'h20 : r_dout <= #DLY 64'hff5ccd1d1db99bea;
			8'h21 : r_dout <= #DLY 64'hb0b854a7fe42980f;
			8'h22 : r_dout <= #DLY 64'h7bd46a6a718d4b9f;
			8'h23 : r_dout <= #DLY 64'hd10fa8cc22a5fd8c;
			8'h24 : r_dout <= #DLY 64'hd31484952be4bd31;
			8'h25 : r_dout <= #DLY 64'hc7fa975fcb243847;
			8'h26 : r_dout <= #DLY 64'h4886ed1e5846c407;
			8'h27 : r_dout <= #DLY 64'h28cddb791eb70b04;
			8'h28 : r_dout <= #DLY 64'hc2b00be2f573417f;
			8'h29 : r_dout <= #DLY 64'h5c9590452180f877;
			8'h2a : r_dout <= #DLY 64'h7a6bddfff370eb00;
			8'h2b : r_dout <= #DLY 64'hce509e38d6d9d6a4;
			8'h2c : r_dout <= #DLY 64'hebeb0f00647fa702;
			8'h2d : r_dout <= #DLY 64'h1dcc06cf76606f06;
			8'h2e : r_dout <= #DLY 64'he4d9f28ba286ff0a;
			8'h2f : r_dout <= #DLY 64'hd85a305dc918c262;
			8'h30 : r_dout <= #DLY 64'h475b1d8732225f54;
			8'h31 : r_dout <= #DLY 64'h2d4fb51668ccb5fe;
			8'h32 : r_dout <= #DLY 64'ha679b9d9d72bba20;
			8'h33 : r_dout <= #DLY 64'h53841c0d912d43a5;
			8'h34 : r_dout <= #DLY 64'h3b7eaa48bf12a4e8;
			8'h35 : r_dout <= #DLY 64'h781e0e47f22f1ddf;
			8'h36 : r_dout <= #DLY 64'heff20ce60ab50973;
			8'h37 : r_dout <= #DLY 64'h20d261d19dffb742;
			8'h38 : r_dout <= #DLY 64'h16a12b03062a2e39;
			8'h39 : r_dout <= #DLY 64'h1960eb2239650495;
			8'h3a : r_dout <= #DLY 64'h251c16fed50eb8b8;
			8'h3b : r_dout <= #DLY 64'h9ac0c330f826016e;
			8'h3c : r_dout <= #DLY 64'hed152665953e7671;
			8'h3d : r_dout <= #DLY 64'h02d63194a6369570;
			8'h3e : r_dout <= #DLY 64'h5074f08394b1c987;
			8'h3f : r_dout <= #DLY 64'h70ba598c90b25ce1;
			8'h40 : r_dout <= #DLY 64'h794a15810b9742f6;
			8'h41 : r_dout <= #DLY 64'h0d5925e9fcaf8c6c;
			8'h42 : r_dout <= #DLY 64'h3067716cd868744e;
			8'h43 : r_dout <= #DLY 64'h910ab077e8d7731b;
			8'h44 : r_dout <= #DLY 64'h6a61bbdb5ac42f61;
			8'h45 : r_dout <= #DLY 64'h93513efbf0851567;
			8'h46 : r_dout <= #DLY 64'hf494724b9e83e9d5;
			8'h47 : r_dout <= #DLY 64'he887e1985c09648d;
			8'h48 : r_dout <= #DLY 64'h34b1d3c675370cfd;
			8'h49 : r_dout <= #DLY 64'hdc35e433bc0d255d;
			8'h4a : r_dout <= #DLY 64'hd0aab84234131be0;
			8'h4b : r_dout <= #DLY 64'h08042a50b48b7eaf;
			8'h4c : r_dout <= #DLY 64'h9997c4ee44a3ab35;
			8'h4d : r_dout <= #DLY 64'h829a7b49201799d0;
			8'h4e : r_dout <= #DLY 64'h263b8307b7c54441;
			8'h4f : r_dout <= #DLY 64'h752f95f4fd6a6ca6;
			8'h50 : r_dout <= #DLY 64'h927217402c08c6e5;
			8'h51 : r_dout <= #DLY 64'h2a8ab754a795d9ee;
			8'h52 : r_dout <= #DLY 64'ha442f7552f72943d;
			8'h53 : r_dout <= #DLY 64'h2c31334e19781208;
			8'h54 : r_dout <= #DLY 64'h4fa98d7ceaee6291;
			8'h55 : r_dout <= #DLY 64'h55c3862f665db309;
			8'h56 : r_dout <= #DLY 64'hbd0610175d53b1f3;
			8'h57 : r_dout <= #DLY 64'h46fe6cb840413f27;
			8'h58 : r_dout <= #DLY 64'h3fe03792df0cfa59;
			8'h59 : r_dout <= #DLY 64'hcfe700372eb85e8f;
			8'h5a : r_dout <= #DLY 64'ha7be29e7adbce118;
			8'h5b : r_dout <= #DLY 64'he544ee5cde8431dd;
			8'h5c : r_dout <= #DLY 64'h8a781b1b41f1873e;
			8'h5d : r_dout <= #DLY 64'ha5c94c78a0d2f0e7;
			8'h5e : r_dout <= #DLY 64'h39412e2877b60728;
			8'h5f : r_dout <= #DLY 64'ha1265ef3afc9a62c;
			8'h60 : r_dout <= #DLY 64'hbcc2770c6a2506c5;
			8'h61 : r_dout <= #DLY 64'h3ab66dd5dce1ce12;
			8'h62 : r_dout <= #DLY 64'he65499d04a675b37;
			8'h63 : r_dout <= #DLY 64'h7d8f523481bfd216;
			8'h64 : r_dout <= #DLY 64'h0f6f64fcec15f389;
			8'h65 : r_dout <= #DLY 64'h74efbe618b5b13c8;
			8'h66 : r_dout <= #DLY 64'hacdc82b714273e1d;
			8'h67 : r_dout <= #DLY 64'hdd40bfe003199d17;
			8'h68 : r_dout <= #DLY 64'h37e99257e7e061f8;
			8'h69 : r_dout <= #DLY 64'hfa52626904775aaa;
			8'h6a : r_dout <= #DLY 64'h8bbbf63a463d56f9;
			8'h6b : r_dout <= #DLY 64'hf0013f1543a26e64;
			8'h6c : r_dout <= #DLY 64'ha8307e9f879ec898;
			8'h6d : r_dout <= #DLY 64'hcc4c27a4150177cc;
			8'h6e : r_dout <= #DLY 64'h1b432f2cca1d3348;
			8'h6f : r_dout <= #DLY 64'hde1d1f8f9f6fa013;
			8'h70 : r_dout <= #DLY 64'h606602a047a7ddd6;
			8'h71 : r_dout <= #DLY 64'hd237ab64cc1cb2c7;
			8'h72 : r_dout <= #DLY 64'h9b938e7225fcd1d3;
			8'h73 : r_dout <= #DLY 64'hec4e03708e0ff476;
			8'h74 : r_dout <= #DLY 64'hfeb2fbda3d03c12d;
			8'h75 : r_dout <= #DLY 64'hae0bced2ee43889a;
			8'h76 : r_dout <= #DLY 64'h22cb8923ebfb4f43;
			8'h77 : r_dout <= #DLY 64'h69360d013cf7396d;
			8'h78 : r_dout <= #DLY 64'h855e3602d2d4e022;
			8'h79 : r_dout <= #DLY 64'h073805bad01f784c;
			8'h7a : r_dout <= #DLY 64'h33e17a133852f546;
			8'h7b : r_dout <= #DLY 64'hdf4874058ac7b638;
			8'h7c : r_dout <= #DLY 64'hba92b29c678aa14a;
			8'h7d : r_dout <= #DLY 64'h0ce89fc76cfaadcd;
			8'h7e : r_dout <= #DLY 64'h5f9d4e0908339e34;
			8'h7f : r_dout <= #DLY 64'hf1afe9291f5923b9;
			8'h80 : r_dout <= #DLY 64'h6e3480f60f4a265f;
			8'h81 : r_dout <= #DLY 64'heebf3a2ab29b841c;
			8'h82 : r_dout <= #DLY 64'he21938a88f91b4ad;
			8'h83 : r_dout <= #DLY 64'h57dfeff845c6d3c3;
			8'h84 : r_dout <= #DLY 64'h2f006b0bf62caaf2;
			8'h85 : r_dout <= #DLY 64'h62f479ef6f75ee78;
			8'h86 : r_dout <= #DLY 64'h11a55ad41c8916a9;
			8'h87 : r_dout <= #DLY 64'hf229d29084fed453;
			8'h88 : r_dout <= #DLY 64'h42f1c27b16b000e6;
			8'h89 : r_dout <= #DLY 64'h2b1f76749823c074;
			8'h8a : r_dout <= #DLY 64'h4b76eca3c2745360;
			8'h8b : r_dout <= #DLY 64'h8c98f463b91691bd;
			8'h8c : r_dout <= #DLY 64'h14bcc93cf1ade66a;
			8'h8d : r_dout <= #DLY 64'h8885213e6d458397;
			8'h8e : r_dout <= #DLY 64'h8e177df0274d4711;
			8'h8f : r_dout <= #DLY 64'hb49b73b5503f2951;
			8'h90 : r_dout <= #DLY 64'h10168168c3f96b6b;
			8'h91 : r_dout <= #DLY 64'h0e3d963b63cab0ae;
			8'h92 : r_dout <= #DLY 64'h8dfc4b5655a1db14;
			8'h93 : r_dout <= #DLY 64'hf789f1356e14de5c;
			8'h94 : r_dout <= #DLY 64'h683e68af4e51dac1;
			8'h95 : r_dout <= #DLY 64'hc9a84f9d8d4b0fd9;
			8'h96 : r_dout <= #DLY 64'h3691e03f52a0f9d1;
			8'h97 : r_dout <= #DLY 64'h5ed86e46e1878e80;
			8'h98 : r_dout <= #DLY 64'h3c711a0e99d07150;
			8'h99 : r_dout <= #DLY 64'h5a0865b20c4e9310;
			8'h9a : r_dout <= #DLY 64'h56fbfc1fe4f0682e;
			8'h9b : r_dout <= #DLY 64'hea8d5de3105edf9b;
			8'h9c : r_dout <= #DLY 64'h71abfdb12379187a;
			8'h9d : r_dout <= #DLY 64'h2eb99de1bee77b9c;
			8'h9e : r_dout <= #DLY 64'h21ecc0ea33cf4523;
			8'h9f : r_dout <= #DLY 64'h59a4d7521805c7a1;
			8'ha0 : r_dout <= #DLY 64'h3896f5eb56ae7c72;
			8'ha1 : r_dout <= #DLY 64'haa638f3db18f75dc;
			8'ha2 : r_dout <= #DLY 64'h9f39358dabe9808e;
			8'ha3 : r_dout <= #DLY 64'hb7defa91c00b72ac;
			8'ha4 : r_dout <= #DLY 64'h6b5541fd62492d92;
			8'ha5 : r_dout <= #DLY 64'h6dc6dee8f92e4d5b;
			8'ha6 : r_dout <= #DLY 64'h353f57abc4beea7e;
			8'ha7 : r_dout <= #DLY 64'h735769d6da5690ce;
			8'ha8 : r_dout <= #DLY 64'h0a234aa642391484;
			8'ha9 : r_dout <= #DLY 64'hf6f9508028f80d9d;
			8'haa : r_dout <= #DLY 64'hb8e319a27ab3f215;
			8'hab : r_dout <= #DLY 64'h31ad9c1151341a4d;
			8'hac : r_dout <= #DLY 64'h773c22a57bef5805;
			8'had : r_dout <= #DLY 64'h45c7561a07968633;
			8'hae : r_dout <= #DLY 64'hf913da9e249dbe36;
			8'haf : r_dout <= #DLY 64'hda652d9b78a64c68;
			8'hb0 : r_dout <= #DLY 64'h4c27a97f3bc334ef;
			8'hb1 : r_dout <= #DLY 64'h76621220e66b17f4;
			8'hb2 : r_dout <= #DLY 64'h967743899acd7d0b;
			8'hb3 : r_dout <= #DLY 64'hf3ee5bcae0ed6782;
			8'hb4 : r_dout <= #DLY 64'h409f753600c879fc;
			8'hb5 : r_dout <= #DLY 64'h06d09a39b5926db6;
			8'hb6 : r_dout <= #DLY 64'h6f83aeb0317ac588;
			8'hb7 : r_dout <= #DLY 64'h01e6ca4a86381f21;
			8'hb8 : r_dout <= #DLY 64'h66ff3462d19f3025;
			8'hb9 : r_dout <= #DLY 64'h72207c24ddfd3bfb;
			8'hba : r_dout <= #DLY 64'h4af6b6d3e2ece2eb;
			8'hbb : r_dout <= #DLY 64'h9c994dbec7ea08de;
			8'hbc : r_dout <= #DLY 64'h49ace597b09a8bc4;
			8'hbd : r_dout <= #DLY 64'hb38c4766cf0797ba;
			8'hbe : r_dout <= #DLY 64'h131b9373c57c2a75;
			8'hbf : r_dout <= #DLY 64'hb1822cce61931e58;
			8'hc0 : r_dout <= #DLY 64'h9d7555b909ba1c0c;
			8'hc1 : r_dout <= #DLY 64'h127fafdd937d11d2;
			8'hc2 : r_dout <= #DLY 64'h29da3badc66d92e4;
			8'hc3 : r_dout <= #DLY 64'ha2c1d57154c2ecbc;
			8'hc4 : r_dout <= #DLY 64'h58c5134d82f6fe24;
			8'hc5 : r_dout <= #DLY 64'h1c3ae3515b62274f;
			8'hc6 : r_dout <= #DLY 64'he907c82e01cb8126;
			8'hc7 : r_dout <= #DLY 64'hf8ed091913e37fcb;
			8'hc8 : r_dout <= #DLY 64'h3249d8f9c80046c9;
			8'hc9 : r_dout <= #DLY 64'h80cf9bede388fb63;
			8'hca : r_dout <= #DLY 64'h1881539a116cf19e;
			8'hcb : r_dout <= #DLY 64'h5103f3f76bd52457;
			8'hcc : r_dout <= #DLY 64'h15b7e6f5ae47f7a8;
			8'hcd : r_dout <= #DLY 64'hdbd7c6ded47e9ccf;
			8'hce : r_dout <= #DLY 64'h44e55c410228bb1a;
			8'hcf : r_dout <= #DLY 64'hb647d4255edb4e99;
			8'hd0 : r_dout <= #DLY 64'h5d11882bb8aafc30;
			8'hd1 : r_dout <= #DLY 64'hf5098bbb29d3212a;
			8'hd2 : r_dout <= #DLY 64'h8fb5ea14e90296b3;
			8'hd3 : r_dout <= #DLY 64'h677b942157dd025a;
			8'hd4 : r_dout <= #DLY 64'hfb58e7c0a390acb5;
			8'hd5 : r_dout <= #DLY 64'h89d3674c83bd4a01;
			8'hd6 : r_dout <= #DLY 64'h9e2da4df4bf3b93b;
			8'hd7 : r_dout <= #DLY 64'hfcc41e328cab4829;
			8'hd8 : r_dout <= #DLY 64'h03f38c96ba582c52;
			8'hd9 : r_dout <= #DLY 64'hcad1bdbd7fd85db2;
			8'hda : r_dout <= #DLY 64'hbbb442c16082ae83;
			8'hdb : r_dout <= #DLY 64'hb95fe86ba5da9ab0;
			8'hdc : r_dout <= #DLY 64'hb22e04673771a93f;
			8'hdd : r_dout <= #DLY 64'h845358c9493152d8;
			8'hde : r_dout <= #DLY 64'hbe2a488697b4541e;
			8'hdf : r_dout <= #DLY 64'h95a2dc2dd38e6966;
			8'he0 : r_dout <= #DLY 64'hc02c11ac923c852b;
			8'he1 : r_dout <= #DLY 64'h2388b1990df2a87b;
			8'he2 : r_dout <= #DLY 64'h7c8008fa1b4f37be;
			8'he3 : r_dout <= #DLY 64'h1f70d0c84d54e503;
			8'he4 : r_dout <= #DLY 64'h5490adec7ece57d4;
			8'he5 : r_dout <= #DLY 64'h002b3c27d9063a3a;
			8'he6 : r_dout <= #DLY 64'h7eaea3848030a2bf;
			8'he7 : r_dout <= #DLY 64'hc602326ded2003c0;
			8'he8 : r_dout <= #DLY 64'h83a7287d69a94086;
			8'he9 : r_dout <= #DLY 64'hc57a5fcb30f57a8a;
			8'hea : r_dout <= #DLY 64'hb56844e479ebe779;
			8'heb : r_dout <= #DLY 64'ha373b40f05dcbce9;
			8'hec : r_dout <= #DLY 64'hd71a786e88570ee2;
			8'hed : r_dout <= #DLY 64'h879cbacdbde8f6a0;
			8'hee : r_dout <= #DLY 64'h976ad1bcc164a32f;
			8'hef : r_dout <= #DLY 64'hab21e25e9666d78b;
			8'hf0 : r_dout <= #DLY 64'h901063aae5e5c33c;
			8'hf1 : r_dout <= #DLY 64'h9818b34448698d90;
			8'hf2 : r_dout <= #DLY 64'he36487ae3e1e8abb;
			8'hf3 : r_dout <= #DLY 64'hafbdf931893bdcb4;
			8'hf4 : r_dout <= #DLY 64'h6345a0dc5fbbd519;
			8'hf5 : r_dout <= #DLY 64'h8628fe269b9465ca;
			8'hf6 : r_dout <= #DLY 64'h1e5d01603f9c51ec;
			8'hf7 : r_dout <= #DLY 64'h4de44006a15049b7;
			8'hf8 : r_dout <= #DLY 64'hbf6c70e5f776cbb1;
			8'hf9 : r_dout <= #DLY 64'h411218f2ef552bed;
			8'hfa : r_dout <= #DLY 64'hcb0c0708705a36a3;
			8'hfb : r_dout <= #DLY 64'he74d14754f986044;
			8'hfc : r_dout <= #DLY 64'hcd56d9430ea8280e;
			8'hfd : r_dout <= #DLY 64'hc12591d7535f5065;
			8'hfe : r_dout <= #DLY 64'hc83223f1720aef96;
			8'hff : r_dout <= #DLY 64'hc3a0396f7363a51f;
		endcase
	end
	
	assign o_data = r_dout;

endmodule