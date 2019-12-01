// -------------------------------------------------------------------------------------------------
// File name        :   tb_zuc_core.v
// Function         :   ZUC Cryptographic Algorithm Core Simulate File 
// -------------------------------------------------------------------------------------------------
// Author           :   Xie
// Version          ：  v-1.0
// Date				:   2018-12-25
// Email            :   xcrypt@126.com
// copyright        ：  XCrypt Studio
// -------------------------------------------------------------------------------------------------

`timescale 1ns / 1ps

module tb_zuc_core();
    
    reg         r_clk;
    reg         r_rst;
    reg         r_init;
    reg [127:0] r_key;
    reg [127:0] r_iv;
    reg         r_ready;
    wire        s_valid;
    wire [31:0] s_data;
    
    reg [127:0] KEY0 = 128'b0;
    reg [127:0] IV0 = 128'b0;
    
    reg [127:0] KEY1 = 128'hffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff;
    reg [127:0] IV1 = 128'hffff_ffff_ffff_ffff_ffff_ffff_ffff_ffff;    
    
    reg [127:0] KEY2 = 128'h3d4c_4be9_6a82_fdae_b58f_641d_b17b_455b;
    reg [127:0] IV2 = 128'h8431_9aa8_de69_15ca_1f6b_da6b_fbd8_c766;        
    
    zuc_core u_core(
    .i_clk      (r_clk      ),
    .i_rst      (r_rst      ),
    .i_init     (r_init     ),
    .i_key      (r_key      ),
    .i_iv       (r_iv       ),
    .i_ready    (r_ready    ),
    .o_valid    (s_valid    ),
    .o_data     (s_data     )
    );    
    
    initial begin
        r_clk <= 1'b0;
        forever #5 r_clk = ~r_clk;
    end
    
    initial begin
        r_rst = 1'b1;
        r_init = 1'b0;
        r_key = 128'b0;
        r_iv = 128'b0;     
        r_ready = 1'b0;   
        repeat(10) @(negedge r_clk);
        r_rst = 1'b0;
        ///
        repeat(10) @(negedge r_clk);
        r_key = KEY0;
        r_iv = IV0;
        r_init = 1'b1;
        repeat(2) @(negedge r_clk);
        r_init = 1'b0;
        r_ready = 1'b1;
        wait(s_valid);
        r_ready = 1'b0;
        repeat(2) @(negedge r_clk);
        r_ready = 1'b1;
        //delay
        repeat(1000) @(negedge r_clk);
        ///
        r_key = KEY1;
        r_iv = IV1;
        r_init = 1'b1;
        repeat(2) @(negedge r_clk);
        r_init = 1'b0;
        r_ready = 1'b1;
        //delay
        repeat(1000) @(negedge r_clk);   
        ///
        r_key = KEY2;
        r_iv = IV2;
        r_init = 1'b1;
        repeat(2) @(negedge r_clk);
        r_init = 1'b0;
        r_ready = 1'b1;
        //delay
        repeat(1000) @(negedge r_clk);    	
		$stop;
    end
    
endmodule
