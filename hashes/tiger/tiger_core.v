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
// File name        :   tiger_core.v
// Function         :   Tiger Hash Algorithm Core
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          £º  v-1.0
// Date				:   2019-1-23
// Email            :   xcrypt@126.com
// ------------------------------------------------------------------------------

module tiger_core(
	input 			i_clk,      //clock 
	input			i_rst,      //reset high valid
	input			i_start,    //high valid(only one clock)
	input   [511:0] i_data,		//hash data input
	input	[191:0]	i_vin,		//hash init value input(not change before o_done valid)
	output	[191:0]	o_vout,     //hash value output   
	output			o_done);    //high valid(only one clock) 

	localparam DLY = 1;
	
	wire 	[511:0]	s_din;
	reg 	[7:0]	r_count;
	reg 			r_done;
	reg 	[1:0]	r_state;
	reg 	[1:0]	r_state_next;
	
	wire 	[63:0]	s_ain;
	wire 	[63:0]	s_bin;
	wire 	[63:0]	s_cin;
	wire 	[3:0]	s_mul;
	wire 	[63:0]	s_aout;
	wire 	[63:0]	s_bout;
	wire 	[63:0]	s_cout;	
	
	reg 	[511:0]	r_x;
	reg 	[63:0]	r_xin;
	
	reg 	[511:0]	r_key_in;
	wire 	[511:0]	s_key_out;
	
    function [63:0] SWAP;
        input [63:0] DIN;
        begin
            SWAP = {DIN[7:0],DIN[15:8],DIN[23:16],DIN[31:24],DIN[39:32],DIN[47:40],DIN[55:48],DIN[63:56]};
        end
    endfunction		
	
	assign s_din[64*8-1:64*7] = SWAP(i_data[64*8-1:64*7]);  //T[0][0]
	assign s_din[64*7-1:64*6] = SWAP(i_data[64*7-1:64*6]);  //T[0][1]
	assign s_din[64*6-1:64*5] = SWAP(i_data[64*6-1:64*5]);  //T[0][2]
	assign s_din[64*5-1:64*4] = SWAP(i_data[64*5-1:64*4]);  //T[0][3]
	assign s_din[64*4-1:64*3] = SWAP(i_data[64*4-1:64*3]);  //T[0][4]
	assign s_din[64*3-1:64*2] = SWAP(i_data[64*3-1:64*2]);  //T[0][5]
	assign s_din[64*2-1:64*1] = SWAP(i_data[64*2-1:64*1]);  //T[0][6]	
	assign s_din[64*1-1:64*0] = SWAP(i_data[64*1-1:64*0]);  //T[0][7]	

	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst) 
			r_count <= #DLY 8'b0;
		else if((r_state==2'b0)||(r_done==1'b1))
			r_count <= #DLY 8'b0;
		else
			r_count <= #DLY r_count + 8'd1;
	end		
	
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst) 
			r_done <= #DLY 1'd0;
		else if(r_count[4:0] == 5'd23)
			r_done <= #DLY 1'd1;
		else 
			r_done <= #DLY 1'b0;		
	end	
	
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst) 
			r_state <= #DLY 2'd0;
		else 
			r_state <= #DLY r_state_next;
	end
 
	always@(i_rst or r_count or i_start or r_state) begin
		if(i_rst) begin
			r_state_next = 2'd0;
		end else begin
			case(r_state)
				2'd0: begin
					if(i_start) 
						r_state_next = 2'd1;
				end
				2'd1: begin
					if(r_count[4:0] == 5'd23) 
						r_state_next = 2'd0;				
				end
				default: begin
					r_state_next = 2'd0;
				end
			endcase
		end
	end		

	assign s_ain = (r_count=='b0) ? SWAP(i_vin[191:128]) : s_bout;
	assign s_bin = (r_count=='b0) ? SWAP(i_vin[127: 64]) : s_cout;
	assign s_cin = (r_count=='b0) ? SWAP(i_vin[63 :  0]) : s_aout;

	assign s_mul = (r_count<='d7) ? 4'd5 :
				  ((r_count<='d15)? 4'd7 :
				  ((r_count<='d23)? 4'd9 : 4'd0));
	
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst) 
			r_x <= #DLY 512'b0;
		else if(i_start)
			r_x <= #DLY s_din;
		else if((r_count=='d7)||(r_count=='d15))
			r_x <= #DLY s_key_out;
	end
		
	always@(r_count or r_x) begin
		case(r_count[2:0])
			3'd0 : r_xin = r_x[64*8-1:64*7];
			3'd1 : r_xin = r_x[64*7-1:64*6];
			3'd2 : r_xin = r_x[64*6-1:64*5];
			3'd3 : r_xin = r_x[64*5-1:64*4];
			3'd4 : r_xin = r_x[64*4-1:64*3];
			3'd5 : r_xin = r_x[64*3-1:64*2];
			3'd6 : r_xin = r_x[64*2-1:64*1];
			3'd7 : r_xin = r_x[64*1-1:64*0];
		endcase	
	end	
	
	always@(posedge i_clk) begin
		if(i_rst)
			r_key_in <= 512'b0;
		else if(r_count=='d0)
			r_key_in <= s_din;
		else if(r_count=='d8)
			r_key_in <= s_key_out;
	end

	//one round hash
	tiger_round u_round(
	.i_clk	 (i_clk		),
	.i_ain	 (s_ain		),
	.i_bin	 (s_bin		),
	.i_cin	 (s_cin		),		
	.i_xin	 (r_xin		),
	.i_mul	 (s_mul		),
	.o_aout	 (s_aout	),
	.o_bout	 (s_bout	),
	.o_cout	 (s_cout	)	
	);

	//key mixing schedule
	tiger_key_sch u_key_sch(
	.i_clk	(i_clk		),
	.i_key	(r_key_in	),
	.o_key	(s_key_out	)
	);
	
	assign o_done = r_done;

	assign o_vout[191:128] = SWAP(s_bout ^ SWAP(i_vin[191:128]));
	assign o_vout[127:64] = SWAP(s_cout - SWAP(i_vin[127:64]));
	assign o_vout[63:0] = SWAP(s_aout + SWAP(i_vin[63:0]));
	
endmodule
