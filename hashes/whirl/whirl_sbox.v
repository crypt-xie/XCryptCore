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
// File name        :   whirl_sbox.v
// Function         :   Whirlpool Hash Algorithm SBox 
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          ：  v-1.0
// Date				:   2019-1-22
// Email            :   xcrypt@126.com
// ------------------------------------------------------------------------------

module whirl_sbox(
	input			i_clk,
	input	[7:0]	i_addr,
	output  [63:0]	o_data
	);
	
	localparam 	DLY = 1;
	
	reg [63:0]	r_dout;
	
	always@(posedge i_clk) begin
		case(i_addr)
			8'h00 : r_dout <= #DLY 64'h18186018c07830d8;
			8'h01 : r_dout <= #DLY 64'h23238c2305af4626;
			8'h02 : r_dout <= #DLY 64'hc6c63fc67ef991b8;
			8'h03 : r_dout <= #DLY 64'he8e887e8136fcdfb;
			8'h04 : r_dout <= #DLY 64'h878726874ca113cb;
			8'h05 : r_dout <= #DLY 64'hb8b8dab8a9626d11;
			8'h06 : r_dout <= #DLY 64'h0101040108050209;
			8'h07 : r_dout <= #DLY 64'h4f4f214f426e9e0d;
			8'h08 : r_dout <= #DLY 64'h3636d836adee6c9b;
			8'h09 : r_dout <= #DLY 64'ha6a6a2a6590451ff;
			8'h0a : r_dout <= #DLY 64'hd2d26fd2debdb90c;
			8'h0b : r_dout <= #DLY 64'hf5f5f3f5fb06f70e;
			8'h0c : r_dout <= #DLY 64'h7979f979ef80f296;
			8'h0d : r_dout <= #DLY 64'h6f6fa16f5fcede30;
			8'h0e : r_dout <= #DLY 64'h91917e91fcef3f6d;
			8'h0f : r_dout <= #DLY 64'h52525552aa07a4f8;
			8'h10 : r_dout <= #DLY 64'h60609d6027fdc047;
			8'h11 : r_dout <= #DLY 64'hbcbccabc89766535;
			8'h12 : r_dout <= #DLY 64'h9b9b569baccd2b37;
			8'h13 : r_dout <= #DLY 64'h8e8e028e048c018a;
			8'h14 : r_dout <= #DLY 64'ha3a3b6a371155bd2;
			8'h15 : r_dout <= #DLY 64'h0c0c300c603c186c;
			8'h16 : r_dout <= #DLY 64'h7b7bf17bff8af684;
			8'h17 : r_dout <= #DLY 64'h3535d435b5e16a80;
			8'h18 : r_dout <= #DLY 64'h1d1d741de8693af5;
			8'h19 : r_dout <= #DLY 64'he0e0a7e05347ddb3;
			8'h1a : r_dout <= #DLY 64'hd7d77bd7f6acb321;
			8'h1b : r_dout <= #DLY 64'hc2c22fc25eed999c;
			8'h1c : r_dout <= #DLY 64'h2e2eb82e6d965c43;
			8'h1d : r_dout <= #DLY 64'h4b4b314b627a9629;
			8'h1e : r_dout <= #DLY 64'hfefedffea321e15d;
			8'h1f : r_dout <= #DLY 64'h575741578216aed5;
			8'h20 : r_dout <= #DLY 64'h15155415a8412abd;
			8'h21 : r_dout <= #DLY 64'h7777c1779fb6eee8;
			8'h22 : r_dout <= #DLY 64'h3737dc37a5eb6e92;
			8'h23 : r_dout <= #DLY 64'he5e5b3e57b56d79e;
			8'h24 : r_dout <= #DLY 64'h9f9f469f8cd92313;
			8'h25 : r_dout <= #DLY 64'hf0f0e7f0d317fd23;
			8'h26 : r_dout <= #DLY 64'h4a4a354a6a7f9420;
			8'h27 : r_dout <= #DLY 64'hdada4fda9e95a944;
			8'h28 : r_dout <= #DLY 64'h58587d58fa25b0a2;
			8'h29 : r_dout <= #DLY 64'hc9c903c906ca8fcf;
			8'h2a : r_dout <= #DLY 64'h2929a429558d527c;
			8'h2b : r_dout <= #DLY 64'h0a0a280a5022145a;
			8'h2c : r_dout <= #DLY 64'hb1b1feb1e14f7f50;
			8'h2d : r_dout <= #DLY 64'ha0a0baa0691a5dc9;
			8'h2e : r_dout <= #DLY 64'h6b6bb16b7fdad614;
			8'h2f : r_dout <= #DLY 64'h85852e855cab17d9;
			8'h30 : r_dout <= #DLY 64'hbdbdcebd8173673c;
			8'h31 : r_dout <= #DLY 64'h5d5d695dd234ba8f;
			8'h32 : r_dout <= #DLY 64'h1010401080502090;
			8'h33 : r_dout <= #DLY 64'hf4f4f7f4f303f507;
			8'h34 : r_dout <= #DLY 64'hcbcb0bcb16c08bdd;
			8'h35 : r_dout <= #DLY 64'h3e3ef83eedc67cd3;
			8'h36 : r_dout <= #DLY 64'h0505140528110a2d;
			8'h37 : r_dout <= #DLY 64'h676781671fe6ce78;
			8'h38 : r_dout <= #DLY 64'he4e4b7e47353d597;
			8'h39 : r_dout <= #DLY 64'h27279c2725bb4e02;
			8'h3a : r_dout <= #DLY 64'h4141194132588273;
			8'h3b : r_dout <= #DLY 64'h8b8b168b2c9d0ba7;
			8'h3c : r_dout <= #DLY 64'ha7a7a6a7510153f6;
			8'h3d : r_dout <= #DLY 64'h7d7de97dcf94fab2;
			8'h3e : r_dout <= #DLY 64'h95956e95dcfb3749;
			8'h3f : r_dout <= #DLY 64'hd8d847d88e9fad56;
			8'h40 : r_dout <= #DLY 64'hfbfbcbfb8b30eb70;
			8'h41 : r_dout <= #DLY 64'heeee9fee2371c1cd;
			8'h42 : r_dout <= #DLY 64'h7c7ced7cc791f8bb;
			8'h43 : r_dout <= #DLY 64'h6666856617e3cc71;
			8'h44 : r_dout <= #DLY 64'hdddd53dda68ea77b;
			8'h45 : r_dout <= #DLY 64'h17175c17b84b2eaf;
			8'h46 : r_dout <= #DLY 64'h4747014702468e45;
			8'h47 : r_dout <= #DLY 64'h9e9e429e84dc211a;
			8'h48 : r_dout <= #DLY 64'hcaca0fca1ec589d4;
			8'h49 : r_dout <= #DLY 64'h2d2db42d75995a58;
			8'h4a : r_dout <= #DLY 64'hbfbfc6bf9179632e;
			8'h4b : r_dout <= #DLY 64'h07071c07381b0e3f;
			8'h4c : r_dout <= #DLY 64'hadad8ead012347ac;
			8'h4d : r_dout <= #DLY 64'h5a5a755aea2fb4b0;
			8'h4e : r_dout <= #DLY 64'h838336836cb51bef;
			8'h4f : r_dout <= #DLY 64'h3333cc3385ff66b6;
			8'h50 : r_dout <= #DLY 64'h636391633ff2c65c;
			8'h51 : r_dout <= #DLY 64'h02020802100a0412;
			8'h52 : r_dout <= #DLY 64'haaaa92aa39384993;
			8'h53 : r_dout <= #DLY 64'h7171d971afa8e2de;
			8'h54 : r_dout <= #DLY 64'hc8c807c80ecf8dc6;
			8'h55 : r_dout <= #DLY 64'h19196419c87d32d1;
			8'h56 : r_dout <= #DLY 64'h494939497270923b;
			8'h57 : r_dout <= #DLY 64'hd9d943d9869aaf5f;
			8'h58 : r_dout <= #DLY 64'hf2f2eff2c31df931;
			8'h59 : r_dout <= #DLY 64'he3e3abe34b48dba8;
			8'h5a : r_dout <= #DLY 64'h5b5b715be22ab6b9;
			8'h5b : r_dout <= #DLY 64'h88881a8834920dbc;
			8'h5c : r_dout <= #DLY 64'h9a9a529aa4c8293e;
			8'h5d : r_dout <= #DLY 64'h262698262dbe4c0b;
			8'h5e : r_dout <= #DLY 64'h3232c8328dfa64bf;
			8'h5f : r_dout <= #DLY 64'hb0b0fab0e94a7d59;
			8'h60 : r_dout <= #DLY 64'he9e983e91b6acff2;
			8'h61 : r_dout <= #DLY 64'h0f0f3c0f78331e77;
			8'h62 : r_dout <= #DLY 64'hd5d573d5e6a6b733;
			8'h63 : r_dout <= #DLY 64'h80803a8074ba1df4;
			8'h64 : r_dout <= #DLY 64'hbebec2be997c6127;
			8'h65 : r_dout <= #DLY 64'hcdcd13cd26de87eb;
			8'h66 : r_dout <= #DLY 64'h3434d034bde46889;
			8'h67 : r_dout <= #DLY 64'h48483d487a759032;
			8'h68 : r_dout <= #DLY 64'hffffdbffab24e354;
			8'h69 : r_dout <= #DLY 64'h7a7af57af78ff48d;
			8'h6a : r_dout <= #DLY 64'h90907a90f4ea3d64;
			8'h6b : r_dout <= #DLY 64'h5f5f615fc23ebe9d;
			8'h6c : r_dout <= #DLY 64'h202080201da0403d;
			8'h6d : r_dout <= #DLY 64'h6868bd6867d5d00f;
			8'h6e : r_dout <= #DLY 64'h1a1a681ad07234ca;
			8'h6f : r_dout <= #DLY 64'haeae82ae192c41b7;
			8'h70 : r_dout <= #DLY 64'hb4b4eab4c95e757d;
			8'h71 : r_dout <= #DLY 64'h54544d549a19a8ce;
			8'h72 : r_dout <= #DLY 64'h93937693ece53b7f;
			8'h73 : r_dout <= #DLY 64'h222288220daa442f;
			8'h74 : r_dout <= #DLY 64'h64648d6407e9c863;
			8'h75 : r_dout <= #DLY 64'hf1f1e3f1db12ff2a;
			8'h76 : r_dout <= #DLY 64'h7373d173bfa2e6cc;
			8'h77 : r_dout <= #DLY 64'h12124812905a2482;
			8'h78 : r_dout <= #DLY 64'h40401d403a5d807a;
			8'h79 : r_dout <= #DLY 64'h0808200840281048;
			8'h7a : r_dout <= #DLY 64'hc3c32bc356e89b95;
			8'h7b : r_dout <= #DLY 64'hecec97ec337bc5df;
			8'h7c : r_dout <= #DLY 64'hdbdb4bdb9690ab4d;
			8'h7d : r_dout <= #DLY 64'ha1a1bea1611f5fc0;
			8'h7e : r_dout <= #DLY 64'h8d8d0e8d1c830791;
			8'h7f : r_dout <= #DLY 64'h3d3df43df5c97ac8;
			8'h80 : r_dout <= #DLY 64'h97976697ccf1335b;
			8'h81 : r_dout <= #DLY 64'h0000000000000000;
			8'h82 : r_dout <= #DLY 64'hcfcf1bcf36d483f9;
			8'h83 : r_dout <= #DLY 64'h2b2bac2b4587566e;
			8'h84 : r_dout <= #DLY 64'h7676c57697b3ece1;
			8'h85 : r_dout <= #DLY 64'h8282328264b019e6;
			8'h86 : r_dout <= #DLY 64'hd6d67fd6fea9b128;
			8'h87 : r_dout <= #DLY 64'h1b1b6c1bd87736c3;
			8'h88 : r_dout <= #DLY 64'hb5b5eeb5c15b7774;
			8'h89 : r_dout <= #DLY 64'hafaf86af112943be;
			8'h8a : r_dout <= #DLY 64'h6a6ab56a77dfd41d;
			8'h8b : r_dout <= #DLY 64'h50505d50ba0da0ea;
			8'h8c : r_dout <= #DLY 64'h45450945124c8a57;
			8'h8d : r_dout <= #DLY 64'hf3f3ebf3cb18fb38;
			8'h8e : r_dout <= #DLY 64'h3030c0309df060ad;
			8'h8f : r_dout <= #DLY 64'hefef9bef2b74c3c4;
			8'h90 : r_dout <= #DLY 64'h3f3ffc3fe5c37eda;
			8'h91 : r_dout <= #DLY 64'h55554955921caac7;
			8'h92 : r_dout <= #DLY 64'ha2a2b2a2791059db;
			8'h93 : r_dout <= #DLY 64'heaea8fea0365c9e9;
			8'h94 : r_dout <= #DLY 64'h656589650fecca6a;
			8'h95 : r_dout <= #DLY 64'hbabad2bab9686903;
			8'h96 : r_dout <= #DLY 64'h2f2fbc2f65935e4a;
			8'h97 : r_dout <= #DLY 64'hc0c027c04ee79d8e;
			8'h98 : r_dout <= #DLY 64'hdede5fdebe81a160;
			8'h99 : r_dout <= #DLY 64'h1c1c701ce06c38fc;
			8'h9a : r_dout <= #DLY 64'hfdfdd3fdbb2ee746;
			8'h9b : r_dout <= #DLY 64'h4d4d294d52649a1f;
			8'h9c : r_dout <= #DLY 64'h92927292e4e03976;
			8'h9d : r_dout <= #DLY 64'h7575c9758fbceafa;
			8'h9e : r_dout <= #DLY 64'h06061806301e0c36;
			8'h9f : r_dout <= #DLY 64'h8a8a128a249809ae;
			8'ha0 : r_dout <= #DLY 64'hb2b2f2b2f940794b;
			8'ha1 : r_dout <= #DLY 64'he6e6bfe66359d185;
			8'ha2 : r_dout <= #DLY 64'h0e0e380e70361c7e;
			8'ha3 : r_dout <= #DLY 64'h1f1f7c1ff8633ee7;
			8'ha4 : r_dout <= #DLY 64'h6262956237f7c455;
			8'ha5 : r_dout <= #DLY 64'hd4d477d4eea3b53a;
			8'ha6 : r_dout <= #DLY 64'ha8a89aa829324d81;
			8'ha7 : r_dout <= #DLY 64'h96966296c4f43152;
			8'ha8 : r_dout <= #DLY 64'hf9f9c3f99b3aef62;
			8'ha9 : r_dout <= #DLY 64'hc5c533c566f697a3;
			8'haa : r_dout <= #DLY 64'h2525942535b14a10;
			8'hab : r_dout <= #DLY 64'h59597959f220b2ab;
			8'hac : r_dout <= #DLY 64'h84842a8454ae15d0;
			8'had : r_dout <= #DLY 64'h7272d572b7a7e4c5;
			8'hae : r_dout <= #DLY 64'h3939e439d5dd72ec;
			8'haf : r_dout <= #DLY 64'h4c4c2d4c5a619816;
			8'hb0 : r_dout <= #DLY 64'h5e5e655eca3bbc94;
			8'hb1 : r_dout <= #DLY 64'h7878fd78e785f09f;
			8'hb2 : r_dout <= #DLY 64'h3838e038ddd870e5;
			8'hb3 : r_dout <= #DLY 64'h8c8c0a8c14860598;
			8'hb4 : r_dout <= #DLY 64'hd1d163d1c6b2bf17;
			8'hb5 : r_dout <= #DLY 64'ha5a5aea5410b57e4;
			8'hb6 : r_dout <= #DLY 64'he2e2afe2434dd9a1;
			8'hb7 : r_dout <= #DLY 64'h616199612ff8c24e;
			8'hb8 : r_dout <= #DLY 64'hb3b3f6b3f1457b42;
			8'hb9 : r_dout <= #DLY 64'h2121842115a54234;
			8'hba : r_dout <= #DLY 64'h9c9c4a9c94d62508;
			8'hbb : r_dout <= #DLY 64'h1e1e781ef0663cee;
			8'hbc : r_dout <= #DLY 64'h4343114322528661;
			8'hbd : r_dout <= #DLY 64'hc7c73bc776fc93b1;
			8'hbe : r_dout <= #DLY 64'hfcfcd7fcb32be54f;
			8'hbf : r_dout <= #DLY 64'h0404100420140824;
			8'hc0 : r_dout <= #DLY 64'h51515951b208a2e3;
			8'hc1 : r_dout <= #DLY 64'h99995e99bcc72f25;
			8'hc2 : r_dout <= #DLY 64'h6d6da96d4fc4da22;
			8'hc3 : r_dout <= #DLY 64'h0d0d340d68391a65;
			8'hc4 : r_dout <= #DLY 64'hfafacffa8335e979;
			8'hc5 : r_dout <= #DLY 64'hdfdf5bdfb684a369;
			8'hc6 : r_dout <= #DLY 64'h7e7ee57ed79bfca9;
			8'hc7 : r_dout <= #DLY 64'h242490243db44819;
			8'hc8 : r_dout <= #DLY 64'h3b3bec3bc5d776fe;
			8'hc9 : r_dout <= #DLY 64'habab96ab313d4b9a;
			8'hca : r_dout <= #DLY 64'hcece1fce3ed181f0;
			8'hcb : r_dout <= #DLY 64'h1111441188552299;
			8'hcc : r_dout <= #DLY 64'h8f8f068f0c890383;
			8'hcd : r_dout <= #DLY 64'h4e4e254e4a6b9c04;
			8'hce : r_dout <= #DLY 64'hb7b7e6b7d1517366;
			8'hcf : r_dout <= #DLY 64'hebeb8beb0b60cbe0;
			8'hd0 : r_dout <= #DLY 64'h3c3cf03cfdcc78c1;
			8'hd1 : r_dout <= #DLY 64'h81813e817cbf1ffd;
			8'hd2 : r_dout <= #DLY 64'h94946a94d4fe3540;
			8'hd3 : r_dout <= #DLY 64'hf7f7fbf7eb0cf31c;
			8'hd4 : r_dout <= #DLY 64'hb9b9deb9a1676f18;
			8'hd5 : r_dout <= #DLY 64'h13134c13985f268b;
			8'hd6 : r_dout <= #DLY 64'h2c2cb02c7d9c5851;
			8'hd7 : r_dout <= #DLY 64'hd3d36bd3d6b8bb05;
			8'hd8 : r_dout <= #DLY 64'he7e7bbe76b5cd38c;
			8'hd9 : r_dout <= #DLY 64'h6e6ea56e57cbdc39;
			8'hda : r_dout <= #DLY 64'hc4c437c46ef395aa;
			8'hdb : r_dout <= #DLY 64'h03030c03180f061b;
			8'hdc : r_dout <= #DLY 64'h565645568a13acdc;
			8'hdd : r_dout <= #DLY 64'h44440d441a49885e;
			8'hde : r_dout <= #DLY 64'h7f7fe17fdf9efea0;
			8'hdf : r_dout <= #DLY 64'ha9a99ea921374f88;
			8'he0 : r_dout <= #DLY 64'h2a2aa82a4d825467;
			8'he1 : r_dout <= #DLY 64'hbbbbd6bbb16d6b0a;
			8'he2 : r_dout <= #DLY 64'hc1c123c146e29f87;
			8'he3 : r_dout <= #DLY 64'h53535153a202a6f1;
			8'he4 : r_dout <= #DLY 64'hdcdc57dcae8ba572;
			8'he5 : r_dout <= #DLY 64'h0b0b2c0b58271653;
			8'he6 : r_dout <= #DLY 64'h9d9d4e9d9cd32701;
			8'he7 : r_dout <= #DLY 64'h6c6cad6c47c1d82b;
			8'he8 : r_dout <= #DLY 64'h3131c43195f562a4;
			8'he9 : r_dout <= #DLY 64'h7474cd7487b9e8f3;
			8'hea : r_dout <= #DLY 64'hf6f6fff6e309f115;
			8'heb : r_dout <= #DLY 64'h464605460a438c4c;
			8'hec : r_dout <= #DLY 64'hacac8aac092645a5;
			8'hed : r_dout <= #DLY 64'h89891e893c970fb5;
			8'hee : r_dout <= #DLY 64'h14145014a04428b4;
			8'hef : r_dout <= #DLY 64'he1e1a3e15b42dfba;
			8'hf0 : r_dout <= #DLY 64'h16165816b04e2ca6;
			8'hf1 : r_dout <= #DLY 64'h3a3ae83acdd274f7;
			8'hf2 : r_dout <= #DLY 64'h6969b9696fd0d206;
			8'hf3 : r_dout <= #DLY 64'h09092409482d1241;
			8'hf4 : r_dout <= #DLY 64'h7070dd70a7ade0d7;
			8'hf5 : r_dout <= #DLY 64'hb6b6e2b6d954716f;
			8'hf6 : r_dout <= #DLY 64'hd0d067d0ceb7bd1e;
			8'hf7 : r_dout <= #DLY 64'heded93ed3b7ec7d6;
			8'hf8 : r_dout <= #DLY 64'hcccc17cc2edb85e2;
			8'hf9 : r_dout <= #DLY 64'h424215422a578468;
			8'hfa : r_dout <= #DLY 64'h98985a98b4c22d2c;
			8'hfb : r_dout <= #DLY 64'ha4a4aaa4490e55ed;
			8'hfc : r_dout <= #DLY 64'h2828a0285d885075;
			8'hfd : r_dout <= #DLY 64'h5c5c6d5cda31b886;
			8'hfe : r_dout <= #DLY 64'hf8f8c7f8933fed6b;
			8'hff : r_dout <= #DLY 64'h8686228644a411c2;
		endcase
	end
	
	assign o_data = r_dout;

endmodule