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
// File name        :   tb_sm3_core.v
// Function         :   SM3 Hash Algorithm Simulate File 
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          ：  v-1.0
// Date				:   2019-1-22
// Email            :   xcrypt@126.com
// ------------------------------------------------------------------------------

`timescale 1ns / 1ps

module tb_sm3_core();
    
    reg             r_clk;
    reg             r_rst;
    reg             r_start;
    reg     [511:0] r_data;     
    reg     [255:0] r_vin;
    wire    [255:0] s_vout;
    wire            s_done;
	reg 			r_test;
	reg 	[1:0]	r_state;
	reg 	[15:0]	r_err;
	
	localparam DLY = 1;
	
	reg [255:0] IV = 256'h7380166f_4914b2b9_172442d7_da8a0600_a96f30bc_163138aa_e38dee4d_b0fb0e4e;
	////
	reg [511:0] DAT1 = {256'h61626380_00000000_00000000_00000000_00000000_00000000_00000000_00000000,
						256'h00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000018};
	reg [255:0]	DOUT1 = {256'h66c7f0f4_62eeedd9_d1f2d46b_dc10e4e2_4167c487_5cf2f7a2_297da02b_8f4ba8e0};
	////
	reg [511:0] DAT2_1 = {256'h61626364_61626364_61626364_61626364_61626364_61626364_61626364_61626364,   
						256'h61626364_61626364_61626364_61626364_61626364_61626364_61626364_61626364};
	reg [511:0] DAT2_2 = {256'h80000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000,   
						256'h00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000200}; 
	reg [255:0]	DOUT2 = {256'hdebe9ff9_2275b8a1_38604889_c18e5a4d_6fdb70e5_387e5765_293dcba3_9c0c5732};
							   
    sm3_core uut(
    .i_clk      (r_clk),
    .i_rst      (r_rst),
    .i_start    (r_start),
    .i_data     (r_data),
    .i_vin      (r_vin),
    .o_vout     (s_vout),
    .o_done     (s_done));    
    
    initial begin
        r_clk = 0;
        forever #5 r_clk = ~r_clk;
    end
    
	always@(posedge r_clk or posedge r_rst) begin
		if(r_rst) begin
			r_start <= #DLY 1'b0;
			r_vin <= #DLY 'b0;
			r_data <= #DLY 1'b0;
			r_err <= #DLY 'b0;
			r_state <= #DLY 2'b0;
		end else begin
			case(r_state)
				2'd0: begin
					if(r_test) begin
						r_start <= #DLY 1'b1;
						r_vin <= #DLY IV;
						r_data <= #DLY DAT1; //test dat-1
						r_state <= #DLY 2'd1;
					end 
				end
				2'd1: begin
					r_start <= #DLY 1'b0;
					if(s_done) begin  
						if(s_vout!= DOUT1) begin
							r_err <= #DLY r_err + 1'b1;
						end else begin
							r_start <= #DLY 1'b1;
							r_vin <= #DLY IV;
							r_data <= #DLY DAT2_1; //test dat2-1
							r_state <= #DLY 2'd2;
						end 
					end
				end
				2'd2: begin
					r_start <= #DLY 1'b0;
					if(s_done) begin 
						r_start <= #DLY 1'b1;
						r_vin <= #DLY s_vout;
						r_data <= #DLY DAT2_2;  //test dat2-2
						r_state <= #DLY 2'd2;
					end
				end
				2'd3: begin
					r_start <= #DLY 1'b0;
					if(s_done) begin 
						if(s_vout!= DOUT2) begin
							r_err <= #DLY r_err + 1'b1;
						end else begin
							r_state <= #DLY 2'd0;
						end 	
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
	
/*     initial begin
        r_rst = 1'b1;
        r_start = 1'b0;
        r_vin = 256'b0;
        r_data = 512'b0;
        repeat(50) @(posedge r_clk);
        r_rst = 1'b0;
        ////test data 1
        repeat(50) @(posedge r_clk);
        r_start = 1'b1;
        r_vin = 256'h7380166f_4914b2b9_172442d7_da8a0600_a96f30bc_163138aa_e38dee4d_b0fb0e4e; //init
        r_data[511:256] = 256'h61626380_00000000_00000000_00000000_00000000_00000000_00000000_00000000;
        r_data[255:0]= 256'h00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000018;
        $display("vin=0x%x",r_vin);
        $display("data=0x%x",r_data);
        @(posedge r_clk);
        r_start = 1'b0;
        wait(s_done);
        $display("vout=0x%x",s_vout);
         
        /////test data 2
        repeat(50) @(posedge r_clk); 
        r_start = 1'b1;
        r_vin = 256'h7380166f_4914b2b9_172442d7_da8a0600_a96f30bc_163138aa_e38dee4d_b0fb0e4e; //init
        r_data[511:256] = 256'h61626364_61626364_61626364_61626364_61626364_61626364_61626364_61626364;    
        r_data[255:0] = 256'h61626364_61626364_61626364_61626364_61626364_61626364_61626364_61626364; 
        //$display("vin=0x%x",r_vin);
        //$display("data=0x%x",r_data);
        @(posedge r_clk);
        r_start = 1'b0;
        wait(s_done);
		$display("vout=0x%x",s_vout); 
        r_vin = s_vout;
		@(posedge r_clk);
		r_start = 1'b1;
        r_data[511:256] = 256'h80000000_00000000_00000000_00000000_00000000_00000000_00000000_00000000;    
        r_data[255:0] = 256'h00000000_00000000_00000000_00000000_00000000_00000000_00000000_00000200;  
        @(posedge r_clk);
        r_start = 1'b0;
        wait(s_done);               
        $display("vout=0x%x",s_vout);
        /////stop
        repeat(50) @(posedge r_clk);         
        $stop;
    end */
    
    
    
    
endmodule
