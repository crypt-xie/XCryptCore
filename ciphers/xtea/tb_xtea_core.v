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
// File name        :   tb_xtea_core.v
// Function         :   XTEA Cryptographic Algorithm Core Simulate File 
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          :   v-1.0
// Date				:   2019-1-24
// Email            :   xcrypt@126.com
// ------------------------------------------------------------------------------

`timescale 1ns / 1ps

module tb_xtea_core();
    
    reg             r_clk;
    reg             r_rst;
    reg             r_flag;
	reg 			r_key_en;
    reg     [127:0] r_key; 
	reg 			r_din_en;
    reg     [63:0]  r_din;
	reg 	[31:0]	r_err;
	reg 	[2:0]	r_count;
	reg				r_test;
	wire 			s_dout_en;
    wire    [63:0]  s_dout;
    wire            s_key_ok;
	reg 	[1:0]	r_state;
	
	localparam DLY = 1;
	
	 // { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
	   // 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },
	 // { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 },
	 // { 0xde, 0xe9, 0xd4, 0xd8, 0xf7, 0x13, 0x1e, 0xd9 }
	reg [127:0] KEY1 = {32'b0,32'b0,32'b0,32'b0};
	reg [63:0]	PT1  = {32'b0,32'b0};
	reg [63:0]	CT1  = {8'hde, 8'he9, 8'hd4, 8'hd8, 8'hf7, 8'h13, 8'h1e, 8'hd9};
         // { 0x78, 0x69, 0x5a, 0x4b, 0x3c, 0x2d, 0x1e, 0x0f,
           // 0xf0, 0xe1, 0xd2, 0xc3, 0xb4, 0xa5, 0x96, 0x87 },
         // { 0xf0, 0xe1, 0xd2, 0xc3, 0xb4, 0xa5, 0x96, 0x87 },
         // { 0x70, 0x4b, 0x31, 0x34, 0x47, 0x44, 0xdf, 0xab }	
	reg [127:0] KEY2 = {8'h78, 8'h69, 8'h5a, 8'h4b, 8'h3c, 8'h2d, 8'h1e, 8'h0f, 8'hf0, 8'he1, 8'hd2, 8'hc3, 8'hb4, 8'ha5, 8'h96, 8'h87};
	reg [63:0]	PT2  = {8'hf0, 8'he1, 8'hd2, 8'hc3, 8'hb4, 8'ha5, 8'h96, 8'h87};
	reg [63:0]	CT2  = {8'h70, 8'h4b, 8'h31, 8'h34, 8'h47, 8'h44, 8'hdf, 8'hab};		 
		 
						   
	xtea_core uut(
    .i_clk		(r_clk		),
    .i_rst		(r_rst		),
    .i_flag		(r_flag		),  //1-encrypt,0-decrypt
    .i_key		(r_key		),
    .i_key_en	(r_key_en	),
    .i_din		(r_din		),
    .i_din_en	(r_din_en	),
    .o_dout		(s_dout		),
    .o_dout_en	(s_dout_en	),
    .o_key_ok	(s_key_ok	)
    );  
    
    initial begin
        r_clk = 0;
        forever #5 r_clk = ~r_clk;
    end
	
	always@(posedge r_clk or posedge r_rst) begin
		if(r_rst) begin
			r_count <= #DLY 3'd0;
			r_flag <= #DLY 1'b0;
			r_din_en <= #DLY 1'b0;
			r_din <= #DLY 'b0;
			r_key_en <= #DLY 1'b0;
			r_key <= #DLY 'b0;
			r_err <= #DLY 'b0;
			r_state <= #DLY 2'b0;
		end else begin
			case(r_state)
				2'd0: begin
					if(r_test) begin
						r_key_en <= #DLY 1'b1;
						r_key <= #DLY KEY2;
						r_state <= #DLY 2'd1;
					end 
				end
				2'd1: begin
					r_key_en <= #DLY 1'b0;
					if(s_key_ok) begin
						r_din_en <= #DLY 1'b1;
						r_flag <= #DLY 1'b1;
						r_din <= #DLY PT2;
						r_state <= #DLY 2'd2;
					end
				end
				2'd2: begin
					r_din_en <= #DLY 1'b0;
					if(s_dout_en) begin
						if(s_dout!=CT2)
							r_err <= #DLY r_err + 1'b1;
						r_din_en <= #DLY 1'b1;
						r_din <= #DLY CT2;
						r_flag <= #DLY 1'b0;
						r_state <= #DLY 2'd3;
					end
				end
				2'd3: begin
					r_din_en <= #DLY 1'b0;
					if(s_dout_en) begin
						if(s_dout!=PT2)
							r_err <= #DLY r_err + 1'b1;
						r_count <= #DLY r_count + 1'b1;
						if(r_count == 'd7)
							r_state <= #DLY 2'd0;
						else 
							r_state <= #DLY 2'd1;
					end				
				end
			endcase
		end
	
	end
	
	initial begin
		r_rst = 1'b1;
		r_test = 1'b0;
		repeat(50) @(negedge r_clk);
		r_rst = 1'b0;
		repeat(10) @(negedge r_clk);
		r_test = 1'b1;
		repeat(5000) @(negedge r_clk);
	end
	
   
endmodule
