`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Xie(xiejianjiang@126.com)
// 
// Create Date: 2019/01/05 06:16:40
// Design Name: 
// Module Name: tb_sm3_core
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: SHA1 Cryptographic Hash Algorithm Simulate File 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_sha256_core();
    
    reg             r_clk;
    reg             r_rst;
    reg             r_start;
    reg     [511:0] r_data;     
    reg     [255:0] r_vin;
    wire    [255:0] s_vout;
    wire            s_done;
    //SHA1("abc") =     { "abc",
    //  "0xba, 0x78, 0x16, 0xbf, 0x8f, 0x01, 0xcf, 0xea,
    //   0x41, 0x41, 0x40, 0xde, 0x5d, 0xae, 0x22, 0x23,
    //   0xb0, 0x03, 0x61, 0xa3, 0x96, 0x17, 0x7a, 0x9c,
    //   0xb4, 0x10, 0xff, 0x61, 0xf2, 0x00, 0x15, 0xad "
	reg [255:0]	INIT = {32'h6A09E667,32'hBB67AE85,32'h3C6EF372,32'hA54FF53A,
						32'h510E527F,32'h9B05688C,32'h1F83D9AB,32'h5BE0CD19};
	reg [511:0]	DATA1 = {32'h61626380,416'h0,32'h0,32'h00000018};
	//SHA256("123456789012345678901234567890123456789012345678901234567890123456
	//78901234567890") = 
	//	"f3,71,bc,4a,31,1f,2b,00,
	//	 9e,ef,95,2d,d8,3c,a8,0e,
	//	 2b,60,02,6c,8e,93,55,92,
	//	 d0,f9,c3,08,45,3c,81,3e"
	reg [511:0]	DATA2_1 = {80'h3132_3334_3536_3738_3930,80'h3132_3334_3536_3738_3930,
						   80'h3132_3334_3536_3738_3930,80'h3132_3334_3536_3738_3930,
						   80'h3132_3334_3536_3738_3930,80'h3132_3334_3536_3738_3930,
						   80'h3132_3334_3536_3738_3930,32'h3132_3334};
	reg [511:0]	DATA2_2 = {48'h3536_3738_3930,80'h3132_3334_3536_3738_3930,
						   48'h8000_0000_0000,272'h0,64'h0000_0000_0000_0280};		
	
    sha256_core uut(
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
    
    initial begin
        r_rst = 1'b1;
        r_start = 1'b0;
        r_vin = 256'b0;
        r_data = 512'b0;
        repeat(50) @(posedge r_clk);
        r_rst = 1'b0;
		
        ////test data 1
        repeat(50) @(posedge r_clk);
        r_start = 1'b1;
        r_vin = INIT; //init
        r_data = DATA1;
        $display("vin=0x%x",r_vin);
        $display("data=0x%x",r_data);
        @(posedge r_clk);
        r_start = 1'b0;
        wait(s_done);
        $display("vout=0x%x",s_vout);
         
        /////test data 2
        repeat(50) @(posedge r_clk); 
        r_start = 1'b1;
        r_vin = INIT; //init
        r_data = DATA2_1;    
        //$display("vin=0x%x",r_vin);
        //$display("data=0x%x",r_data);
        @(posedge r_clk);
        r_start = 1'b0;
        wait(s_done);
		$display("vout=0x%x",s_vout); 
        r_vin = s_vout;
		@(posedge r_clk);
		r_start = 1'b1;
        r_data= DATA2_2;    
        @(posedge r_clk);
        r_start = 1'b0;
        wait(s_done);               
        $display("vout=0x%x",s_vout);
		
        /////stop
        repeat(50) @(posedge r_clk);         
        $stop;
    end
    
endmodule
