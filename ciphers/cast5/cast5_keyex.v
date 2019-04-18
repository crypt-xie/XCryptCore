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
// File name        :   cast5_keyex.v
// Function         :   CAST5 Cryptographic Algorithm Core Cacate Round KEY (KeyLen = 16)
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          ：  v-1.0
// Date				:   2019-2-3
// Email            :   xcrypt@126.com
// ------------------------------------------------------------------------------

module cast5_keyex(
	input 				i_clk,
	input 				i_rst,
	input 	[127:0]	 	i_key,		//key
	input 				i_key_en,	//key init flag
	output 	[32*32-1:0]	o_exkey,  	//round key
	output 				o_key_ok,  	//key init ok
	output 				o_sbox_use,
	output 	[31:0]		o_sbox_din,
	input	[127:0]		i_sbox_dout
	);
	
	localparam DLY = 1;
	
	wire 	[127:0]		s_x,s_xa;
	wire 	[127:0]		s_z,s_za;
	wire 				s_busy;
	wire 	[31:0]		s_gb_dout;
	wire 	[5:0]		s_count_m20;
	wire 				s_m2;
	reg 	[5:0]		r_count_m20;
	reg 	[15:0]		r_gb_idx;
	reg 	[127:0]		r_gb_din;
	reg		[32*32-1:0]	r_exkey;
	reg 	[7:0]		r_count;
	reg 				r_key_ok;
	reg 	[127:0]		r_temp;
	reg 	[127:0]		r_x;
	reg 	[127:0]		r_z;
	//wire 	[31:0]		s_key  [31:0];

	assign s_x = i_key_en ? i_key :
				 ((s_count_m20=='d12) ? {s_xa[127:96],r_x[95:0]}:
				 ((s_count_m20=='d13) ? {r_x[127:96],s_xa[95:64],r_x[63:0]}:
				 ((s_count_m20=='d14) ? {r_x[127:64],s_xa[63:32],r_x[31:0]}:
				 ((s_count_m20=='d15) ? {r_x[127:32],s_xa[31:0]}:r_x))));
	
	assign s_z = (s_count_m20=='d2) ? {s_za[127:96],r_z[95:0]}:
				((s_count_m20=='d3) ? {r_z[127:96],s_za[95:64],r_z[63:0]}:
				((s_count_m20=='d4) ? {r_z[127:64],s_za[63:32],r_z[31:0]}:
				((s_count_m20=='d5) ? {r_z[127:32],s_za[31:0]}:r_z)));
				
	assign s_m2 = (((r_count>='d20)&&(r_count<='d39))||((r_count>='d60)&&(r_count<='d79))) ? 1'b1 : 1'b0;			
	
	always@(s_count_m20) begin
		case(s_count_m20)
			5'd00: r_gb_idx = {4'h9,4'hb,4'h8,4'ha};
			5'd01: r_gb_idx = {4'hd,4'hf,4'hc,4'he};
			5'd02: r_gb_idx = {4'h0,4'h2,4'h1,4'h3};
			5'd03: r_gb_idx = {4'h7,4'h6,4'h5,4'h4};
			5'd04: r_gb_idx = {4'ha,4'h9,4'hb,4'h8};
			5'd05: r_gb_idx = (~s_m2) ? {4'h2,4'h6,4'h9,4'hc} : {4'h9,4'hc,4'h2,4'h6};
			5'd06: r_gb_idx = (~s_m2) ? {4'h8,4'h9,4'h7,4'h6} : {4'h3,4'h2,4'hc,4'hd};
			5'd07: r_gb_idx = (~s_m2) ? {4'ha,4'hb,4'h5,4'h4} : {4'h1,4'h0,4'he,4'hf};
			5'd08: r_gb_idx = (~s_m2) ? {4'hc,4'hd,4'h3,4'h2} : {4'h7,4'h6,4'h8,4'h9};
			5'd09: r_gb_idx = (~s_m2) ? {4'he,4'hf,4'h1,4'h0} : {4'h5,4'h4,4'ha,4'hb};
			//---
			5'd10: r_gb_idx = {4'h1,4'h3,4'h0,4'h2};
			5'd11: r_gb_idx = {4'h5,4'h7,4'h4,4'h6};
			5'd12: r_gb_idx = {4'h0,4'h2,4'h1,4'h3};
			5'd13: r_gb_idx = {4'h7,4'h6,4'h5,4'h4};
			5'd14: r_gb_idx = {4'ha,4'h9,4'hb,4'h8};
			5'd15: r_gb_idx = (~s_m2) ? {4'h8,4'hd,4'h3,4'h7} : {4'h3,4'h7,4'h8,4'hd};
			5'd16: r_gb_idx = (~s_m2) ? {4'h3,4'h2,4'hc,4'hd} : {4'h8,4'h9,4'h7,4'h6};
			5'd17: r_gb_idx = (~s_m2) ? {4'h1,4'h0,4'he,4'hf} : {4'ha,4'hb,4'h5,4'h4};
			5'd18: r_gb_idx = (~s_m2) ? {4'h7,4'h6,4'h8,4'h9} : {4'hc,4'hd,4'h3,4'h2};
			5'd19: r_gb_idx = (~s_m2) ? {4'h5,4'h4,4'ha,4'hb} : {4'he,4'hf,4'h1,4'h0};		
			default: r_gb_idx = 16'b0;
		endcase 
	end
	
	always@(s_count_m20 or s_x or s_z) begin
		case(s_count_m20)
			5'd00: r_gb_din = s_x;
			5'd01: r_gb_din = s_x;
			5'd02: r_gb_din = s_z;
			5'd03: r_gb_din = s_z;
			5'd04: r_gb_din = s_z;
			5'd05: r_gb_din = s_z;
			5'd06: r_gb_din = s_z;
			5'd07: r_gb_din = s_z;
			5'd08: r_gb_din = s_z;
			5'd09: r_gb_din = s_z;
			//---
			5'd10: r_gb_din = s_z;
			5'd11: r_gb_din = s_z;
			5'd12: r_gb_din = s_x;
			5'd13: r_gb_din = s_x;
			5'd14: r_gb_din = s_x;
			5'd15: r_gb_din = s_x;
			5'd16: r_gb_din = s_x;
			5'd17: r_gb_din = s_x;
			5'd18: r_gb_din = s_x;
			5'd19: r_gb_din = s_x;			
			default: r_gb_din = 128'b0;
		endcase 
	end
	// to s5
	cast5_gb u_gb1(
	.i_s	(r_gb_idx[15:12]	),  //i
    .i_din	(r_gb_din[127:0]	),  //x
    .o_dout	(s_gb_dout[31:24]	)
	);
	// to s6
	cast5_gb u_gb2(
	.i_s	(r_gb_idx[11:8]		),  //i
    .i_din	(r_gb_din[127:0]	),  //x
    .o_dout	(s_gb_dout[23:16]	)
	);	
	// to s7
	cast5_gb u_gb3(
	.i_s	(r_gb_idx[7:4]		),  //i
    .i_din	(r_gb_din[127:0]	),  //x
    .o_dout	(s_gb_dout[15:8]	)
	);
	// to s8
	cast5_gb u_gb4(
	.i_s	(r_gb_idx[3:0]		),  //i
    .i_din	(r_gb_din[127:0]	),  //x
    .o_dout	(s_gb_dout[7:0]		)
	);

	assign o_sbox_din = s_gb_dout;
	assign o_sbox_use = s_busy;

	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst) begin 
			r_temp <= #DLY 128'b0;
		end else begin
			case(s_count_m20)
				5'd01: r_temp <= #DLY i_sbox_dout;
				5'd06: r_temp <= #DLY i_sbox_dout;
				5'd11: r_temp <= #DLY i_sbox_dout;
				5'd16: r_temp <= #DLY i_sbox_dout;
				default: r_temp <= #DLY r_temp;
			endcase
		end
	end
	
	assign s_za[127:96] = s_x[127:96]^i_sbox_dout[127:96]^i_sbox_dout[95:64]^i_sbox_dout[63:32]^i_sbox_dout[31:0]^r_temp[ 63:32];
	assign s_za[ 95:64] = s_x[ 63:32]^i_sbox_dout[127:96]^i_sbox_dout[95:64]^i_sbox_dout[63:32]^i_sbox_dout[31:0]^r_temp[ 31: 0];	
	assign s_za[ 63:32] = s_x[ 31: 0]^i_sbox_dout[127:96]^i_sbox_dout[95:64]^i_sbox_dout[63:32]^i_sbox_dout[31:0]^r_temp[127:96];	
	assign s_za[ 31: 0] = s_x[ 95:64]^i_sbox_dout[127:96]^i_sbox_dout[95:64]^i_sbox_dout[63:32]^i_sbox_dout[31:0]^r_temp[ 95:64];
 
	assign s_xa[127:96] = s_z[ 63:32]^i_sbox_dout[127:96]^i_sbox_dout[95:64]^i_sbox_dout[63:32]^i_sbox_dout[31:0]^r_temp[ 63:32];
	assign s_xa[ 95:64] = s_z[127:96]^i_sbox_dout[127:96]^i_sbox_dout[95:64]^i_sbox_dout[63:32]^i_sbox_dout[31:0]^r_temp[ 31: 0];
	assign s_xa[ 63:32] = s_z[ 95:64]^i_sbox_dout[127:96]^i_sbox_dout[95:64]^i_sbox_dout[63:32]^i_sbox_dout[31:0]^r_temp[127:96];
	assign s_xa[ 31: 0] = s_z[ 31: 0]^i_sbox_dout[127:96]^i_sbox_dout[95:64]^i_sbox_dout[63:32]^i_sbox_dout[31:0]^r_temp[ 95:64];	 
 
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst) begin 
			r_z <= #DLY 128'b0;
		end else if(i_key_en) begin
			r_z <= #DLY 128'b0;
		end else begin
			case(r_count_m20)
				5'd01: r_z[127:96] <= #DLY s_za[127:96];
				5'd02: r_z[ 95:64] <= #DLY s_za[95:64];
				5'd03: r_z[ 63:32] <= #DLY s_za[63:32];
				5'd04: r_z[ 31: 0] <= #DLY s_za[32:0];	
				default: r_z <= #DLY r_z;
			endcase
		end
	end 
	
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst) begin 
			r_x <= #DLY 128'b0;
		end else if(i_key_en) begin
			r_x <= #DLY i_key;
		end else begin
			case(r_count_m20)
				5'd11: r_x[127:96] <= #DLY s_xa[127:96];
				5'd12: r_x[ 95:64] <= #DLY s_xa[95:64];
				5'd13: r_x[ 63:32] <= #DLY s_xa[63:32];
				5'd14: r_x[ 31: 0] <= #DLY s_xa[31:0];	
				default: r_x <= #DLY r_x;
			endcase
		end
	end 	
	
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst) 
			r_exkey <= #DLY 1408'b0;
		else if((r_count_m20>='d6 && r_count_m20 <='d9) || (r_count_m20>='d16 && r_count_m20 <='d19)) begin
			r_exkey[32*32-1:32] <= #DLY r_exkey[32*31-1:0];
			case(r_count_m20)
				5'd06: r_exkey[31:0] <= #DLY i_sbox_dout[127:96]^i_sbox_dout[95:64]^i_sbox_dout[63:32]^i_sbox_dout[31:0]^r_temp[127:96];
				5'd07: r_exkey[31:0] <= #DLY i_sbox_dout[127:96]^i_sbox_dout[95:64]^i_sbox_dout[63:32]^i_sbox_dout[31:0]^r_temp[95:64];
				5'd08: r_exkey[31:0] <= #DLY i_sbox_dout[127:96]^i_sbox_dout[95:64]^i_sbox_dout[63:32]^i_sbox_dout[31:0]^r_temp[63:32];
				5'd09: r_exkey[31:0] <= #DLY i_sbox_dout[127:96]^i_sbox_dout[95:64]^i_sbox_dout[63:32]^i_sbox_dout[31:0]^r_temp[31:0];
				5'd16: r_exkey[31:0] <= #DLY i_sbox_dout[127:96]^i_sbox_dout[95:64]^i_sbox_dout[63:32]^i_sbox_dout[31:0]^r_temp[127:96];
				5'd17: r_exkey[31:0] <= #DLY i_sbox_dout[127:96]^i_sbox_dout[95:64]^i_sbox_dout[63:32]^i_sbox_dout[31:0]^r_temp[95:64];
				5'd18: r_exkey[31:0] <= #DLY i_sbox_dout[127:96]^i_sbox_dout[95:64]^i_sbox_dout[63:32]^i_sbox_dout[31:0]^r_temp[63:32];
				5'd19: r_exkey[31:0] <= #DLY i_sbox_dout[127:96]^i_sbox_dout[95:64]^i_sbox_dout[63:32]^i_sbox_dout[31:0]^r_temp[31:0];
			endcase
		end
	end	
	
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst)
			r_count <= #DLY 8'd0;
		else if(i_key_en)
			r_count <= #DLY 8'd1;
		else if(r_count==8'd80)
			r_count <= #DLY 7'd0;
		else if(r_count!=8'd0)
			r_count <= #DLY r_count + 8'd1;
	end

	assign s_count_m20 = (r_count<'d20) ? r_count :
						((r_count<'d40) ? (r_count -'d20):
						((r_count<'d60) ? (r_count -'d40):r_count -'d60));
						
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst)
			r_count_m20 <= #DLY 5'b0;
		else 
			r_count_m20 <= #DLY s_count_m20;
	end 
	
	assign o_exkey = r_exkey;

	assign s_busy = ((r_count!=8'd0)||(i_key_en==1'b1)) ? 1'b1 : 1'b0;
	
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst)
			r_key_ok <= #DLY 1'b0;
		else if(r_count==8'd80)
			r_key_ok <= #DLY 1'b1;
		else if(i_key_en==1'b1)
			r_key_ok <= #DLY 1'b0;
	end
	
	assign o_key_ok = r_key_ok&(~i_key_en);

	// genvar i;
	// generate
		// for(i=0;i<32;i=i+1) begin
			// assign s_key[i] = r_exkey[32*(32-i)-1:32*(31-i)];
		// end
	// endgenerate
	
endmodule

