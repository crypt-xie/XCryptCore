// -------------------------------------------------------------------------------------------------
// File name        :   zuc_core.v
// Function         :   ZUC Cryptographic Algorithm Core 
// -------------------------------------------------------------------------------------------------
// Author           :   Xie
// Version          ：  v-1.0
// Date				:   2018-12-25
// Email            :   xcrypt@126.com
// copyright        ：  XCrypt Studio
// -------------------------------------------------------------------------------------------------

module zuc_core(
	input				i_clk,
	input				i_rst,
	input				i_init,
	input	[127:0]		i_key,
    input   [127:0] 	i_iv,
    input               i_ready,
    output              o_valid,
    output  [31:0]      o_data
    );
	
	parameter DK0  = 15'h44D7;
	parameter DK1  = 15'h26BC;
	parameter DK2  = 15'h626B;
	parameter DK3  = 15'h135E;
	parameter DK4  = 15'h5789;
	parameter DK5  = 15'h35E2;
	parameter DK6  = 15'h7135;
	parameter DK7  = 15'h09AF;
	parameter DK8  = 15'h4D78;
	parameter DK9  = 15'h2F13;
	parameter DK10 = 15'h6BC4;
	parameter DK11 = 15'h1AF1;
	parameter DK12 = 15'h5E26;
	parameter DK13 = 15'h3C4D;
	parameter DK14 = 15'h789A;
	parameter DK15 = 15'h47AC;
	
	wire 	[31*16-1:0] s_lfsr_in;
	reg 	[31*16-1:0]	r_lfsr;	
	
	reg 	[31:0]	r_r1;
	reg 	[31:0]	r_r2;	
	
	wire	[31:0]	s_x0;
	wire 	[31:0]	s_x1;
	wire 	[31:0]	s_x2;
	wire 	[31:0]	s_x3;
	
	wire 	[31:0]	s_w;
	wire 	[31:0]	s_w1;
	wire 	[31:0]	s_w2;
	wire 	[31:0]	s_u;
	wire 	[31:0]	s_v;
	wire 	[31:0]	s_r1;
	wire 	[31:0]	s_r2;
	wire	[30:0]	s_lfv1;
	wire 	[30:0]	s_lfv2;
	wire 	[30:0]	s_lfv3;
	wire 	[30:0]	s_lfv4;
	wire 	[30:0]	s_lfv5;
	wire 	[30:0]	s_lfv6;
	
    reg     [4:0]   r_count;
    reg     [1:0]   r_state;
    
	wire    [30:0]  LFSR15;
    wire    [30:0]  LFSR14;
    wire    [30:0]  LFSR13;
    wire    [30:0]  LFSR11;
    wire    [30:0]  LFSR10;
    wire    [30:0]  LFSR9 ;
    wire    [30:0]  LFSR7 ;
    wire    [30:0]  LFSR5 ;
    wire    [30:0]  LFSR4 ;
    wire    [30:0]  LFSR2 ;
    wire    [30:0]  LFSR0 ;
    
    reg             r_valid;
    reg     [31:0]  r_data;
	
	//key input
	assign s_lfsr_in[31*16-1:31*15] = {i_key[7:0]    ,DK15, i_iv[7:0]    };
	assign s_lfsr_in[31*15-1:31*14] = {i_key[15:8]   ,DK14, i_iv[15:8]   };
	assign s_lfsr_in[31*14-1:31*13] = {i_key[23:16]  ,DK13, i_iv[23:16]  };
	assign s_lfsr_in[31*13-1:31*12] = {i_key[31:24]  ,DK12, i_iv[31:24]  };
	assign s_lfsr_in[31*12-1:31*11] = {i_key[39:32]  ,DK11, i_iv[39:32]  };
	assign s_lfsr_in[31*11-1:31*10] = {i_key[47:40]  ,DK10, i_iv[47:40]  };
	assign s_lfsr_in[31*10-1:31*9]  = {i_key[55:48]  ,DK9,  i_iv[55:48]  };
	assign s_lfsr_in[31*9-1 :31*8]  = {i_key[63:56]  ,DK8,  i_iv[63:56]  };
	assign s_lfsr_in[31*8-1 :31*7]  = {i_key[71:64]  ,DK7,  i_iv[71:64]  };
	assign s_lfsr_in[31*7-1 :31*6]  = {i_key[79:72]  ,DK6,  i_iv[79:72]  };
	assign s_lfsr_in[31*6-1 :31*5]  = {i_key[87:80]  ,DK5,  i_iv[87:80]  };
	assign s_lfsr_in[31*5-1 :31*4]  = {i_key[95:88]  ,DK4,  i_iv[95:88]  };
	assign s_lfsr_in[31*4-1 :31*3]  = {i_key[103:96] ,DK3,  i_iv[103:96] };
	assign s_lfsr_in[31*3-1 :31*2]  = {i_key[111:104],DK2,  i_iv[111:104]};
	assign s_lfsr_in[31*2-1 :31*1]  = {i_key[119:112],DK1,  i_iv[119:112]};
	assign s_lfsr_in[30:0]          = {i_key[127:120],DK0,  i_iv[127:120]};

	
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst) begin
			r_count <= 5'b0;
			r_lfsr  <= 496'b0;
			r_state <= 2'b0;
			r_r1    <= 32'b0;
			r_r2    <= 32'b0;
			r_valid <= 1'b0;
			r_data <= 32'b0;
		end else begin
			case(r_state) 
				2'b0: begin
					if(i_init) begin
						r_lfsr <= s_lfsr_in;
						r_r1 <= 32'h0;
						r_r2 <= 32'h0;
						r_state <= 2'b1;
					end else if(i_ready) begin
					    r_valid <= 1'b1;
					    r_data <= s_x3^s_w; 
					    r_r1 <= s_r1;
					    r_r2 <= s_r2;
					    if(s_lfv5==32'b0) r_lfsr <= {31'h7fff_ffff,r_lfsr[495:31]};
					    else r_lfsr <= {s_lfv5,r_lfsr[495:31]}; 
					end
				end
				2'b1: begin
					r_count <= r_count + 1'b1;
					if(r_count=='d31)
						r_state <= 2'd0;
					r_r1 <= s_r1;
					r_r2 <= s_r2;
					r_lfsr <= {s_lfv6,r_lfsr[495:31]};
				end
			endcase
		end 
	
	end
	
	assign LFSR15 = r_lfsr[31*15+30:31*15];
	assign LFSR14 = r_lfsr[31*14+30:31*14];
	assign LFSR13 = r_lfsr[31*13+30:31*13];
	assign LFSR11 = r_lfsr[31*11+30:31*11];
	assign LFSR10 = r_lfsr[31*10+30:31*10];
	assign LFSR9  = r_lfsr[31*9+30:31*9];
	assign LFSR7  = r_lfsr[31*7+30:31*7];
	assign LFSR5  = r_lfsr[31*5+30:31*5];
	assign LFSR4  = r_lfsr[31*4+30:31*4];
	assign LFSR2  = r_lfsr[31*2+30:31*2];
	assign LFSR0  = r_lfsr[30:0];
	
	//BitResconstruction
	assign s_x0 = {LFSR15[30:15],LFSR14[15:0]};
	assign s_x1 = {LFSR11[15:0],LFSR9[30:15]};
	assign s_x2 = {LFSR7[15:0],LFSR5[30:15]};
	assign s_x3 = {LFSR2[15:0],LFSR0[30:15]};
	
	//F(x1,x2,x3)
	assign s_w  = (s_x0^r_r1)+r_r2;
	assign s_w1 = r_r1+s_x1;
	assign s_w2 = r_r2^s_x2;
	assign s_u =  L1({s_w1[15:0],s_w2[31:16]});
	assign s_v =  L2({s_w2[15:0],s_w1[31:16]});	
	zuc_s0 s_1(.din(s_u[31:24]),.dout(s_r1[31:24]));
	zuc_s1 s_2(.din(s_u[23:16]),.dout(s_r1[23:16]));
	zuc_s0 s_3(.din(s_u[15:8]),.dout(s_r1[15:8]));
	zuc_s1 s_4(.din(s_u[7:0]),.dout(s_r1[7:0]));
	zuc_s0 s_5(.din(s_v[31:24]),.dout(s_r2[31:24]));
	zuc_s1 s_6(.din(s_v[23:16]),.dout(s_r2[23:16]));
	zuc_s0 s_7(.din(s_v[15:8]),.dout(s_r2[15:8]));
	zuc_s1 s_8(.din(s_v[7:0]),.dout(s_r2[7:0]));
	
	//LFSRWithInitializationMode(W>>1)
	assign s_lfv1 = ADD31(LFSR0,ROT31(LFSR0,8));
	assign s_lfv2 = ADD31(s_lfv1,ROT31(LFSR4,20));
	assign s_lfv3 = ADD31(s_lfv2,ROT31(LFSR10,21));
	assign s_lfv4 = ADD31(s_lfv3,ROT31(LFSR13,17));
	assign s_lfv5 = ADD31(s_lfv4,ROT31(LFSR15,15));
	assign s_lfv6 = ADD31(s_lfv5,s_w[31:1]);
	
    assign o_valid = r_valid;
	assign o_data = r_data; 
	
	function [30:0]	ADD31;
		input [30:0] a;
		input [30:0] b;
		reg [31:0] tmp;
		begin
			tmp = a + b;
			ADD31 = tmp[30:0] + tmp[31]; 
		end
	endfunction
		
	function [30:0]	ROT31;
		input [30:0] a;
		input [4:0] k;
		begin
		    ROT31 = (k==8) ? {a[22:0],a[30:23]}:
                   ((k==20)? {a[10:0],a[30:11]}:
                   ((k==21)? {a[9:0] ,a[30:10]}:
                   ((k==17)? {a[13:0],a[30:14] }:
                   ((k==15)? {a[15:0],a[30:16] }:31'b0))));
		end	
	endfunction
	
	function [31:0] ROT32;
		input [31:0] a;
		input [4:0] k;
		begin
		    ROT32 = (k==8) ? {a[23:0],a[31:24]}:
		           ((k==14)? {a[17:0],a[31:18]}:
		           ((k==22)? {a[9:0] ,a[31:10]}:
		           ((k==30)? {a[1:0] ,a[31:2] }:
		           ((k==2 )? {a[29:0],a[31:30]}:
		           ((k==10)? {a[21:0],a[31:22]}:
		           ((k==18)? {a[13:0],a[31:14]}:
		           ((k==24)? {a[7:0] ,a[31:8] }:32'b0)))))));
		end	
	endfunction	
	
	function [31:0]	L1;
		input [31:0] X;
		begin
			L1 = X^ROT32(X,2)^ROT32(X,10)^ROT32(X,18)^ROT32(X,24);
		end
	endfunction
	
	function [31:0] L2;
		input [31:0] X;
		begin
			L2 = X^ROT32(X,8)^ROT32(X,14)^ROT32(X,22)^ROT32(X,30);
		end
	endfunction
	
	
endmodule	
	