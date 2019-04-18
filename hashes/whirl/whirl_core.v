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
// File name        :   whirl_core.v
// Function         :   Whirlpool Hash Algorithm Core
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          ：  v-1.0
// Date				:   2019-1-22
// Email            :   xcrypt@126.com
// ------------------------------------------------------------------------------

module whirl_core(
	input 			i_clk,      //clock 
	input			i_rst,      //reset high valid
	input			i_start,    //high valid(only one clock)
	input   [511:0] i_data,		//hash data input
	input	[511:0]	i_vin,		//hash init value input(not change before o_done valid)
	output	[511:0]	o_vout,     //hash value output   
	output			o_done);    //high valid(only one clock) 

	localparam DLY = 1;
	localparam [64*10-1:0] CONT = {
		64'h1823c6e887b8014f,64'h36a6d2f5796f9152,64'h60bc9b8ea30c7b35,64'h1de0d7c22e4bfe57,
		64'h157737e59ff04ada,64'h58c9290ab1a06b85,64'hbd5d10f4cb3e0567,64'he427418ba77d95d8,
		64'hfbee7c66dd17479e,64'hca2dbf07ad5a8333};			
	
	reg  [1023:0]	r_K;
	reg  [1023:0]	r_T;
	wire [511:0]	s_wsdat;
	reg  [511:0]	r_wsdat;
	reg  [7:0]		r_count;
	reg 			r_done;
	reg  [2:0]		r_state;
	reg  [2:0]		r_state_next;
	wire  [63:0]	s_wsval;
	reg  [127:0]	r_cont;
	wire [63:0]		s_wsin [7:0];
	wire [63:0]		s_wsout [7:0];
	wire [511:0]	s_vin;
	wire [511:0]	s_din;
	
	wire [63:0]		K0	[7:0];
	wire [63:0]		K1	[7:0];
	wire [63:0]		T0	[7:0];
	wire [63:0]		T1	[7:0];	
	
	reg  [2:0]		r_state_1;
	reg  [7:0]		r_count_1;
	
    function [63:0] SWAP;
        input [63:0] DIN;
        begin
            //SWAP = {DIN[7:0],DIN[15:8],DIN[23:16],DIN[31:24],DIN[39:32],DIN[47:40],DIN[55:48],DIN[63:56]};
			SWAP = DIN;
        end
    endfunction	

	function [63:0]	GBc;
		input [63:0] D;
		input [2:0]  S;
		begin
			GBc=(S==3'd0) ? D[63:0]:
			   ((S==3'd1) ? { 8'b0,D[63: 8]}:
			   ((S==3'd2) ? {16'b0,D[63:16]}:
			   ((S==3'd3) ? {24'b0,D[63:24]}:
			   ((S==3'd4) ? {32'b0,D[63:32]}:
			   ((S==3'd5) ? {40'b0,D[63:40]}:
			   ((S==3'd6) ? {48'b0,D[63:48]}:
							{56'b0,D[63:56]}))))));
		end
	endfunction
	
	function [63:0]	ROR64c;
		input [63:0] D;
		input [5:0]  S;
		begin
			ROR64c =(S==6'd00) ? D[63:0]:
				   ((S==6'd08) ? {D[ 7:0],D[63: 8]}:
				   ((S==6'd16) ? {D[15:0],D[63:16]}:
				   ((S==6'd24) ? {D[23:0],D[63:24]}:
				   ((S==6'd32) ? {D[31:0],D[63:32]}:
				   ((S==6'd40) ? {D[39:0],D[63:40]}:
				   ((S==6'd48) ? {D[47:0],D[63:48]}:
				   ((S==6'd56) ? {D[55:0],D[63:56]}:64'b0)))))));	
		end
	endfunction
	
	//K[0][0..8]
	assign s_vin[64*8-1:64*7] = SWAP(i_vin[64*8-1:64*7]);  //K[0][0]
	assign s_vin[64*7-1:64*6] = SWAP(i_vin[64*7-1:64*6]);  //K[0][1]
	assign s_vin[64*6-1:64*5] = SWAP(i_vin[64*6-1:64*5]);  //K[0][2]
	assign s_vin[64*5-1:64*4] = SWAP(i_vin[64*5-1:64*4]);  //K[0][3]
	assign s_vin[64*4-1:64*3] = SWAP(i_vin[64*4-1:64*3]);  //K[0][4]
	assign s_vin[64*3-1:64*2] = SWAP(i_vin[64*3-1:64*2]);  //K[0][5]
	assign s_vin[64*2-1:64*1] = SWAP(i_vin[64*2-1:64*1]);  //K[0][6]	
	assign s_vin[64*1-1:64*0] = SWAP(i_vin[64*1-1:64*0]);  //K[0][7]	
	//
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
		else if((r_state==3'd5)||(r_state==1'b0))
			r_count <= #DLY 8'b0;
		else
			r_count <= #DLY r_count + 8'd1;
	end		
	
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst) 
			r_done <= #DLY 1'd0;
		else if(r_state==3'd5)
			r_done <= #DLY 1'd1;
		else 
			r_done <= #DLY 1'b0;		
	end	
	
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst) 
			r_state <= #DLY 3'd0;
		else 
			r_state <= #DLY r_state_next;
	end
 
	always@(i_rst or r_count or i_start or r_state) begin
		if(i_rst) begin
			r_state_next = 3'd0;
		end else begin
			case(r_state)
				3'd0: begin
					if(i_start) 
						r_state_next = 3'd1;
				end
				3'd1: begin // K[1][y] = theta_pi_gamma(K[0], y);
					if(r_count[4:0] == 5'd7) 
						r_state_next = 3'd2;				
				end
				3'd2: begin // T[1][y] = theta_pi_gamma(T[0], y) ^ K[1][y];
					if(r_count[4:0] == 5'd15) 
						r_state_next = 3'd3;						
				end
				3'd3: begin // K[0][y] = theta_pi_gamma(K[1], y);
					if(r_count[4:0] == 5'd23) 
						r_state_next = 3'd4;				
				end
				3'd4: begin // T[0][y] = theta_pi_gamma(T[1], y) ^ K[0][y];
					if(r_count[4:0] == 5'd31) begin
						if(r_count[7:5]=='d4)					
							r_state_next = 3'd5;
						else	
							r_state_next = 3'd1;
					end
				end	
				3'd5: begin
					r_state_next = 3'd0;
				end
				default: begin
					r_state_next = 3'd0;
				end
			endcase
		end
	end		
	
	always@(*) begin
		case(r_count[7:5])
			3'd0: r_cont = CONT[64*10-1:64*8];
			3'd1: r_cont = CONT[64* 8-1:64*6];
			3'd2: r_cont = CONT[64* 6-1:64*4];
			3'd3: r_cont = CONT[64* 4-1:64*2];
			3'd4: r_cont = CONT[64* 2-1:64*0];
			default: r_cont = 128'b0;
		endcase
	end
	
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst) begin
			r_state_1 <= 3'd0;
			r_count_1 <= 8'b0;
		end else begin
			r_state_1 <= r_state;
			r_count_1 <= r_count;
		end
	end
	
	//K[0]
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst) begin
			r_K[511:0] <= #DLY 512'b0;
		end else begin
			if(i_start) 
				r_K[511:0] <= #DLY s_vin;
			else if(r_state_1==3'd3) begin
				case(r_count_1[2:0])
					3'd0: r_K[64*8-1:64*7] <= #DLY s_wsval^r_cont[63:0];
					3'd1: r_K[64*7-1:64*6] <= #DLY s_wsval;	
					3'd2: r_K[64*6-1:64*5] <= #DLY s_wsval;
					3'd3: r_K[64*5-1:64*4] <= #DLY s_wsval;	
					3'd4: r_K[64*4-1:64*3] <= #DLY s_wsval;
					3'd5: r_K[64*3-1:64*2] <= #DLY s_wsval;	
					3'd6: r_K[64*2-1:64*1] <= #DLY s_wsval;
					3'd7: r_K[64*1-1:64*0] <= #DLY s_wsval;						
				endcase
			end
		end		
	end
	
	//K[1]
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst) begin
			r_K[1023:512] <= #DLY 512'b0;
		end else begin
			if(i_start) 
				r_K[1023:512] <= #DLY 512'b0;
			else if(r_state_1==3'd1) begin
				case(r_count_1[2:0])
					3'd0: r_K[64*16-1:64*15] <= #DLY s_wsval^r_cont[127:64];
					3'd1: r_K[64*15-1:64*14] <= #DLY s_wsval;	
					3'd2: r_K[64*14-1:64*13] <= #DLY s_wsval;
					3'd3: r_K[64*13-1:64*12] <= #DLY s_wsval;	
					3'd4: r_K[64*12-1:64*11] <= #DLY s_wsval;
					3'd5: r_K[64*11-1:64*10] <= #DLY s_wsval;	
					3'd6: r_K[64*10-1:64* 9] <= #DLY s_wsval;
					3'd7: r_K[64* 9-1:64* 8] <= #DLY s_wsval;						
				endcase
			end
		end		
	end	

	//T[0]
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst) begin
			r_T[511:0] <= #DLY 512'b0;
		end else begin
			if(i_start) 
				r_T[511:0] <= #DLY s_vin^s_din;
			else if(r_state_1==3'd4) begin
				case(r_count_1[2:0])
					3'd0: r_T[64*8-1:64*7] <= #DLY s_wsval^r_K[64*8-1:64*7];
					3'd1: r_T[64*7-1:64*6] <= #DLY s_wsval^r_K[64*7-1:64*6];	
					3'd2: r_T[64*6-1:64*5] <= #DLY s_wsval^r_K[64*6-1:64*5];
					3'd3: r_T[64*5-1:64*4] <= #DLY s_wsval^r_K[64*5-1:64*4];	
					3'd4: r_T[64*4-1:64*3] <= #DLY s_wsval^r_K[64*4-1:64*3];
					3'd5: r_T[64*3-1:64*2] <= #DLY s_wsval^r_K[64*3-1:64*2];	
					3'd6: r_T[64*2-1:64*1] <= #DLY s_wsval^r_K[64*2-1:64*1];
					3'd7: r_T[64*1-1:64*0] <= #DLY s_wsval^r_K[64*1-1:64*0];						
				endcase
			end
		end		
	end
	
	//T[1]
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst) begin
			r_T[1023:512] <= #DLY 512'b0;
		end else begin
			if(i_start) 
				r_T[1023:512] <= #DLY 512'b0;
			else if(r_state_1==3'd2) begin
				case(r_count_1[2:0])
					3'd0: r_T[64*16-1:64*15] <= #DLY s_wsval^r_K[64*16-1:64*15];
					3'd1: r_T[64*15-1:64*14] <= #DLY s_wsval^r_K[64*15-1:64*14];	
					3'd2: r_T[64*14-1:64*13] <= #DLY s_wsval^r_K[64*14-1:64*13];
					3'd3: r_T[64*13-1:64*12] <= #DLY s_wsval^r_K[64*13-1:64*12];	
					3'd4: r_T[64*12-1:64*11] <= #DLY s_wsval^r_K[64*12-1:64*11];
					3'd5: r_T[64*11-1:64*10] <= #DLY s_wsval^r_K[64*11-1:64*10];	
					3'd6: r_T[64*10-1:64* 9] <= #DLY s_wsval^r_K[64*10-1:64* 9];
					3'd7: r_T[64* 9-1:64* 8] <= #DLY s_wsval^r_K[64* 9-1:64* 8];						
				endcase
			end
		end		
	end	
	
	assign s_wsdat = (r_count[4:0]==5'd00) ? r_K[511:0]:
					((r_count[4:0]==5'd08) ? r_T[511:0]:
	                ((r_count[4:0]==5'd16) ? r_K[1023:512]:
					((r_count[4:0]==5'd24) ? r_T[1023:512]:512'b0)));
	
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst) begin
			r_wsdat <= 512'b0;
		end else begin	
			if(r_count[2:0]==3'b0) 
				r_wsdat <= {s_wsdat[447:0],s_wsdat[511:448]};
			else
				r_wsdat <= {r_wsdat[447:0],r_wsdat[511:448]};
		end
	end
	
	assign s_wsin[0] = (r_count[2:0]==3'b0) ? GBc(s_wsdat[64*8-1:64*7],7) : GBc(r_wsdat[64*8-1:64*7],7);   //0
	assign s_wsin[1] = (r_count[2:0]==3'b0) ? GBc(s_wsdat[64*1-1:64*0],6) : GBc(r_wsdat[64*1-1:64*0],6);   //7
	assign s_wsin[2] = (r_count[2:0]==3'b0) ? GBc(s_wsdat[64*2-1:64*1],5) : GBc(r_wsdat[64*2-1:64*1],5);   //6
	assign s_wsin[3] = (r_count[2:0]==3'b0) ? GBc(s_wsdat[64*3-1:64*2],4) : GBc(r_wsdat[64*3-1:64*2],4);   //5
	assign s_wsin[4] = (r_count[2:0]==3'b0) ? GBc(s_wsdat[64*4-1:64*3],3) : GBc(r_wsdat[64*4-1:64*3],3);   //4
	assign s_wsin[5] = (r_count[2:0]==3'b0) ? GBc(s_wsdat[64*5-1:64*4],2) : GBc(r_wsdat[64*5-1:64*4],2);   //3
	assign s_wsin[6] = (r_count[2:0]==3'b0) ? GBc(s_wsdat[64*6-1:64*5],1) : GBc(r_wsdat[64*6-1:64*5],1);   //2
	assign s_wsin[7] = (r_count[2:0]==3'b0) ? GBc(s_wsdat[64*7-1:64*6],0) : GBc(r_wsdat[64*7-1:64*6],0);   //1
	
	whirl_sbox u_whirl_sbox0(
	.i_clk	(i_clk		),
	.i_addr	(s_wsin[0]	),
	.o_data	(s_wsout[0]	)
	);

	whirl_sbox u_whirl_sbox1(
	.i_clk	(i_clk		),
	.i_addr	(s_wsin[1]	),
	.o_data	(s_wsout[1]	)
	);
	
	whirl_sbox u_whirl_sbox2(
	.i_clk	(i_clk		),
	.i_addr	(s_wsin[2]	),
	.o_data	(s_wsout[2]	)
	);

	whirl_sbox u_whirl_sbox3(
	.i_clk	(i_clk		),
	.i_addr	(s_wsin[3]	),
	.o_data	(s_wsout[3]	)
	);	

	whirl_sbox u_whirl_sbox4(
	.i_clk	(i_clk		),
	.i_addr	(s_wsin[4]	),
	.o_data	(s_wsout[4]	)
	);

	whirl_sbox u_whirl_sbox5(
	.i_clk	(i_clk		),
	.i_addr	(s_wsin[5]	),
	.o_data	(s_wsout[5]	)
	);
	
	whirl_sbox u_whirl_sbox6(
	.i_clk	(i_clk		),
	.i_addr	(s_wsin[6]	),
	.o_data	(s_wsout[6]	)
	);

	whirl_sbox u_whirl_sbox7(
	.i_clk	(i_clk		),
	.i_addr	(s_wsin[7]	),
	.o_data	(s_wsout[7]	)
	);	

	assign s_wsval = s_wsout[0]^ROR64c(s_wsout[1],8)^ROR64c(s_wsout[2],16)^ROR64c(s_wsout[3],24)^ROR64c(s_wsout[4],32)
					^ROR64c(s_wsout[5],40)^ROR64c(s_wsout[6],48)^ROR64c(s_wsout[7],56);
	
	assign o_done = r_done;
	
	assign o_vout[64*8-1:64*7] = SWAP(s_vin[64*8-1:64*7]^r_T[64*8-1:64*7]^s_din[64*8-1:64*7]);
	assign o_vout[64*7-1:64*6] = SWAP(s_vin[64*7-1:64*6]^r_T[64*7-1:64*6]^s_din[64*7-1:64*6]);
	assign o_vout[64*6-1:64*5] = SWAP(s_vin[64*6-1:64*5]^r_T[64*6-1:64*5]^s_din[64*6-1:64*5]);
	assign o_vout[64*5-1:64*4] = SWAP(s_vin[64*5-1:64*4]^r_T[64*5-1:64*4]^s_din[64*5-1:64*4]);
	assign o_vout[64*4-1:64*3] = SWAP(s_vin[64*4-1:64*3]^r_T[64*4-1:64*3]^s_din[64*4-1:64*3]);
	assign o_vout[64*3-1:64*2] = SWAP(s_vin[64*3-1:64*2]^r_T[64*3-1:64*2]^s_din[64*3-1:64*2]);
	assign o_vout[64*2-1:64*1] = SWAP(s_vin[64*2-1:64*1]^r_T[64*2-1:64*1]^s_din[64*2-1:64*1]);	
	assign o_vout[64*1-1:64*0] = SWAP(s_vin[64*1-1:64*0]^r_T[64*1-1:64*0]^s_din[64*1-1:64*0]);	
	
	
	assign K0[0] = r_K[64*8-1:64*7];
	assign K0[1] = r_K[64*7-1:64*6];
	assign K0[2] = r_K[64*6-1:64*5];
	assign K0[3] = r_K[64*5-1:64*4];
	assign K0[4] = r_K[64*4-1:64*3];
	assign K0[5] = r_K[64*3-1:64*2];
	assign K0[6] = r_K[64*2-1:64*1];
	assign K0[7] = r_K[64*1-1:64*0];
	
	assign K1[0] = r_K[64*16-1:64*15];
	assign K1[1] = r_K[64*15-1:64*14];
	assign K1[2] = r_K[64*14-1:64*13];
	assign K1[3] = r_K[64*13-1:64*12];
	assign K1[4] = r_K[64*12-1:64*11];
	assign K1[5] = r_K[64*11-1:64*10];
	assign K1[6] = r_K[64*10-1:64* 9];
	assign K1[7] = r_K[64* 9-1:64* 8];	
	
	assign T0[0] = r_T[64*8-1:64*7];
	assign T0[1] = r_T[64*7-1:64*6];
	assign T0[2] = r_T[64*6-1:64*5];
	assign T0[3] = r_T[64*5-1:64*4];
	assign T0[4] = r_T[64*4-1:64*3];
	assign T0[5] = r_T[64*3-1:64*2];
	assign T0[6] = r_T[64*2-1:64*1];
	assign T0[7] = r_T[64*1-1:64*0];	
	
	assign T1[0] = r_T[64*16-1:64*15];
	assign T1[1] = r_T[64*15-1:64*14];
	assign T1[2] = r_T[64*14-1:64*13];
	assign T1[3] = r_T[64*13-1:64*12];
	assign T1[4] = r_T[64*12-1:64*11];
	assign T1[5] = r_T[64*11-1:64*10];
	assign T1[6] = r_T[64*10-1:64* 9];
	assign T1[7] = r_T[64* 9-1:64* 8];	

	
endmodule
