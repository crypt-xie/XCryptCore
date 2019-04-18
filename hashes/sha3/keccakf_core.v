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
// File name        :   keccakf_core.v
// Function         :   SHA3 Hash Algorithm Core
// ------------------------------------------------------------------------------
// Author           :   Xie
// Version          ：  v-1.0
// Date				:   2019-1-22
// Email            :   xcrypt@126.com
// ------------------------------------------------------------------------------

module keccakf_core(
	input				i_clk,
	input				i_rst,
	input				i_start,
	input	[1599:0] 	i_vin,
	output 	[1599:0] 	o_vout,
	output				o_done
);
	
	localparam DLY = 1;
	
	//64*24
	parameter RNDC = {
		64'h0000000000000001, 64'h0000000000008082,64'h800000000000808a, 64'h8000000080008000,
		64'h000000000000808b, 64'h0000000080000001,64'h8000000080008081, 64'h8000000000008009,
		64'h000000000000008a, 64'h0000000000000088,64'h0000000080008009, 64'h000000008000000a,
		64'h000000008000808b, 64'h800000000000008b,64'h8000000000008089, 64'h8000000000008003,
		64'h8000000000008002, 64'h8000000000000080,64'h000000000000800a, 64'h800000008000000a,
		64'h8000000080008081, 64'h8000000000008080,64'h0000000080000001, 64'h8000000080008008};
		
	wire [64*25-1:0]	s_vin;		
		
	reg  [4:0]			r_count;
	reg  [64*24-1:0]	r_rndc;
	reg 				r_done;
	reg 				r_state;
	reg  [64*25-1:0]	r_vin;		
	
	wire [64*5-1:0]		s_bc;
	wire [64*25-1:0]	s_ts;
	wire [64*25-1:0]	s_rs; 
	wire [64*25-1:0]	s_cs; 
	
	wire [63:0]	s_ts_x [24:0];
	wire [63:0] s_rs_x [24:0];
	wire [63:0]	s_cs_x [24:0];
	
	function [63:0] SWAP;
        input [63:0] DIN;
        begin
            SWAP = {DIN[7:0],DIN[15:8],DIN[23:16],DIN[31:24],DIN[39:32],DIN[47:40],DIN[55:48],DIN[63:56]};
        end
    endfunction
	
	function [63:0]	ROL1;
		input [63:0] data;
		begin
			ROL1 = {data[62:0],data[63]};
		end
	endfunction
	
	//keccakf_rotc[24] = {1, 3, 6, 10, 15, 21, 28, 36, 45, 55, 2, 14, 27, 41, 56, 8, 25, 43, 62, 18, 39, 61, 20, 44};
	function [63:0] ROL64;
		input [63:0] d;
		input [5:0]  s;
		begin	
			ROL64 =  (s== 1)?{d[62:0],d[63]}:      //1
					((s== 3)?{d[60:0],d[63:61]}:   //3
					((s== 6)?{d[57:0],d[63:58]}:   //6 
					((s==10)?{d[53:0],d[63:54]}:   //10 
					((s==15)?{d[48:0],d[63:49]}:   //15
					((s==21)?{d[42:0],d[63:43]}:   //21
					((s==28)?{d[35:0],d[63:36]}:   //28
					((s==36)?{d[27:0],d[63:28]}:   //36 
					((s==45)?{d[18:0],d[63:19]}:   //45 
					((s==55)?{d[ 8:0],d[63: 9]}:   //55 
					((s== 2)?{d[61:0],d[63:62]}:   //2 
					((s==14)?{d[49:0],d[63:50]}:   //14 
					((s==27)?{d[36:0],d[63:37]}:   //27
					((s==41)?{d[22:0],d[63:23]}:   //41
					((s==56)?{d[ 7:0],d[63: 8]}:   //56 
					((s== 8)?{d[55:0],d[63:56]}:   //8 
					((s==25)?{d[38:0],d[63:39]}:   //25 
					((s==43)?{d[20:0],d[63:21]}:   //43
					((s==62)?{d[ 1:0],d[63: 2]}:   //62 
					((s==18)?{d[45:0],d[63:46]}:   //18 	
					((s==39)?{d[24:0],d[63:25]}:   //39 
					((s==61)?{d[ 2:0],d[63: 3]}:   //61
					((s==20)?{d[43:0],d[63:44]}:   //20 
					((s==44)?{d[19:0],d[63:20]}:64'b0)))))))))))))))))))))));   //44 						
		end
	endfunction
	
	assign s_vin[64*25-1:64*24] = SWAP(i_vin[64*25-1:64*24]);
	assign s_vin[64*24-1:64*23] = SWAP(i_vin[64*24-1:64*23]);
	assign s_vin[64*23-1:64*22] = SWAP(i_vin[64*23-1:64*22]);
	assign s_vin[64*22-1:64*21] = SWAP(i_vin[64*22-1:64*21]);
	assign s_vin[64*21-1:64*20] = SWAP(i_vin[64*21-1:64*20]);
	assign s_vin[64*20-1:64*19] = SWAP(i_vin[64*20-1:64*19]);
	assign s_vin[64*19-1:64*18] = SWAP(i_vin[64*19-1:64*18]);
	assign s_vin[64*18-1:64*17] = SWAP(i_vin[64*18-1:64*17]);
	assign s_vin[64*17-1:64*16] = SWAP(i_vin[64*17-1:64*16]);
	assign s_vin[64*16-1:64*15] = SWAP(i_vin[64*16-1:64*15]);
	assign s_vin[64*15-1:64*14] = SWAP(i_vin[64*15-1:64*14]);
	assign s_vin[64*14-1:64*13] = SWAP(i_vin[64*14-1:64*13]);
	assign s_vin[64*13-1:64*12] = SWAP(i_vin[64*13-1:64*12]);
	assign s_vin[64*12-1:64*11] = SWAP(i_vin[64*12-1:64*11]);
	assign s_vin[64*11-1:64*10] = SWAP(i_vin[64*11-1:64*10]);
	assign s_vin[64*10-1:64* 9] = SWAP(i_vin[64*10-1:64* 9]);
	assign s_vin[64* 9-1:64* 8] = SWAP(i_vin[64* 9-1:64* 8]);	
	assign s_vin[64* 8-1:64* 7] = SWAP(i_vin[64* 8-1:64* 7]);
	assign s_vin[64* 7-1:64* 6] = SWAP(i_vin[64* 7-1:64* 6]);	
	assign s_vin[64* 6-1:64* 5] = SWAP(i_vin[64* 6-1:64* 5]);
	assign s_vin[64* 5-1:64* 4] = SWAP(i_vin[64* 5-1:64* 4]);	
	assign s_vin[64* 4-1:64* 3] = SWAP(i_vin[64* 4-1:64* 3]);
	assign s_vin[64* 3-1:64* 2] = SWAP(i_vin[64* 3-1:64* 2]);	
	assign s_vin[64* 2-1:64* 1] = SWAP(i_vin[64* 2-1:64* 1]);
	assign s_vin[64* 1-1:64* 0] = SWAP(i_vin[64* 1-1:64* 0]);		
	
	//---Theta---
	//bc[i] = s[i] ^ s[i + 5] ^ s[i + 10] ^ s[i + 15] ^ s[i + 20];(i=0~4)
	assign s_bc[64*5-1:64*4] = r_vin[64*25-1:64*24]^r_vin[64*20-1:64*19]^r_vin[64*15-1:64*14]^r_vin[64*10-1:64*9]^r_vin[64*5-1:64*4];
	assign s_bc[64*4-1:64*3] = r_vin[64*24-1:64*23]^r_vin[64*19-1:64*18]^r_vin[64*14-1:64*13]^r_vin[64* 9-1:64*8]^r_vin[64*4-1:64*3];
	assign s_bc[64*3-1:64*2] = r_vin[64*23-1:64*22]^r_vin[64*18-1:64*17]^r_vin[64*13-1:64*12]^r_vin[64* 8-1:64*7]^r_vin[64*3-1:64*2];
	assign s_bc[64*2-1:64*1] = r_vin[64*22-1:64*21]^r_vin[64*17-1:64*16]^r_vin[64*12-1:64*11]^r_vin[64* 7-1:64*6]^r_vin[64*2-1:64*1];
	assign s_bc[64*1-1:64*0] = r_vin[64*21-1:64*20]^r_vin[64*16-1:64*15]^r_vin[64*11-1:64*10]^r_vin[64* 6-1:64*5]^r_vin[64*1-1:64*0];
	//i=0  s[j + i] ^= bc[(i + 4) % 5] ^ ROL64(bc[(i + 1) % 5], 1);
	assign s_ts[64*25-1:64*24] = r_vin[64*25-1:64*24]^s_bc[64*1-1:0]^ROL1(s_bc[64*4-1:64*3]);
	assign s_ts[64*20-1:64*19] = r_vin[64*20-1:64*19]^s_bc[64*1-1:0]^ROL1(s_bc[64*4-1:64*3]);
	assign s_ts[64*15-1:64*14] = r_vin[64*15-1:64*14]^s_bc[64*1-1:0]^ROL1(s_bc[64*4-1:64*3]);
	assign s_ts[64*10-1:64* 9] = r_vin[64*10-1:64* 9]^s_bc[64*1-1:0]^ROL1(s_bc[64*4-1:64*3]);
	assign s_ts[64* 5-1:64* 4] = r_vin[64* 5-1:64* 4]^s_bc[64*1-1:0]^ROL1(s_bc[64*4-1:64*3]);
	//i=1
	assign s_ts[64*24-1:64*23] = r_vin[64*24-1:64*23]^s_bc[64*5-1:64*4]^ROL1(s_bc[64*3-1:64*2]);
	assign s_ts[64*19-1:64*18] = r_vin[64*19-1:64*18]^s_bc[64*5-1:64*4]^ROL1(s_bc[64*3-1:64*2]);
	assign s_ts[64*14-1:64*13] = r_vin[64*14-1:64*13]^s_bc[64*5-1:64*4]^ROL1(s_bc[64*3-1:64*2]);
	assign s_ts[64* 9-1:64* 8] = r_vin[64* 9-1:64* 8]^s_bc[64*5-1:64*4]^ROL1(s_bc[64*3-1:64*2]);
	assign s_ts[64* 4-1:64* 3] = r_vin[64* 4-1:64* 3]^s_bc[64*5-1:64*4]^ROL1(s_bc[64*3-1:64*2]);
	//i=2                                                                               
	assign s_ts[64*23-1:64*22] = r_vin[64*23-1:64*22]^s_bc[64*4-1:64*3]^ROL1(s_bc[64*2-1:64*1]);
	assign s_ts[64*18-1:64*17] = r_vin[64*18-1:64*17]^s_bc[64*4-1:64*3]^ROL1(s_bc[64*2-1:64*1]);
	assign s_ts[64*13-1:64*12] = r_vin[64*13-1:64*12]^s_bc[64*4-1:64*3]^ROL1(s_bc[64*2-1:64*1]);
	assign s_ts[64* 8-1:64* 7] = r_vin[64* 8-1:64* 7]^s_bc[64*4-1:64*3]^ROL1(s_bc[64*2-1:64*1]);
	assign s_ts[64* 3-1:64* 2] = r_vin[64* 3-1:64* 2]^s_bc[64*4-1:64*3]^ROL1(s_bc[64*2-1:64*1]);
	//i=3                                                                               
	assign s_ts[64*22-1:64*21] = r_vin[64*22-1:64*21]^s_bc[64*3-1:64*2]^ROL1(s_bc[64*1-1:0]);
	assign s_ts[64*17-1:64*16] = r_vin[64*17-1:64*16]^s_bc[64*3-1:64*2]^ROL1(s_bc[64*1-1:0]);
	assign s_ts[64*12-1:64*11] = r_vin[64*12-1:64*11]^s_bc[64*3-1:64*2]^ROL1(s_bc[64*1-1:0]);
	assign s_ts[64* 7-1:64* 6] = r_vin[64* 7-1:64* 6]^s_bc[64*3-1:64*2]^ROL1(s_bc[64*1-1:0]);
	assign s_ts[64* 2-1:64* 1] = r_vin[64* 2-1:64* 1]^s_bc[64*3-1:64*2]^ROL1(s_bc[64*1-1:0]);
	//i=4                                                                               
	assign s_ts[64*21-1:64*20] = r_vin[64*21-1:64*20]^s_bc[64*2-1:64*1]^ROL1(s_bc[64*5-1:64*4]);
	assign s_ts[64*16-1:64*15] = r_vin[64*16-1:64*15]^s_bc[64*2-1:64*1]^ROL1(s_bc[64*5-1:64*4]);
	assign s_ts[64*11-1:64*10] = r_vin[64*11-1:64*10]^s_bc[64*2-1:64*1]^ROL1(s_bc[64*5-1:64*4]);
	assign s_ts[64* 6-1:64* 5] = r_vin[64* 6-1:64* 5]^s_bc[64*2-1:64*1]^ROL1(s_bc[64*5-1:64*4]);
	assign s_ts[64* 1-1:64* 0] = r_vin[64* 1-1:64* 0]^s_bc[64*2-1:64*1]^ROL1(s_bc[64*5-1:64*4]);
	
	//---Rho Pi---
	assign s_rs[64*25-1:64*24] = s_ts[64*25-1:64*24];
	assign s_rs[64*15-1:64*14] = ROL64(s_ts[64*24-1:64*23],1 );    
	assign s_rs[64*18-1:64*17] = ROL64(s_ts[64*15-1:64*14],3 );    
	assign s_rs[64*14-1:64*13] = ROL64(s_ts[64*18-1:64*17],6 );    
	assign s_rs[64* 8-1:64* 7] = ROL64(s_ts[64*14-1:64*13],10);    
	assign s_rs[64* 7-1:64* 6] = ROL64(s_ts[64* 8-1:64* 7],15);    
	assign s_rs[64*22-1:64*21] = ROL64(s_ts[64* 7-1:64* 6],21);    
	assign s_rs[64*20-1:64*19] = ROL64(s_ts[64*22-1:64*21],28);    
	assign s_rs[64* 9-1:64* 8] = ROL64(s_ts[64*20-1:64*19],36);    
	assign s_rs[64*17-1:64*16] = ROL64(s_ts[64* 9-1:64* 8],45);    
	assign s_rs[64* 4-1:64* 3] = ROL64(s_ts[64*17-1:64*16],55);    
	assign s_rs[64* 1-1:64* 0] = ROL64(s_ts[64* 4-1:64* 3],2 );    
	assign s_rs[64*21-1:64*20] = ROL64(s_ts[64* 1-1:64* 0],14);    
	assign s_rs[64*10-1:64* 9] = ROL64(s_ts[64*21-1:64*20],27);    
	assign s_rs[64* 2-1:64* 1] = ROL64(s_ts[64*10-1:64* 9],41);    
	assign s_rs[64* 6-1:64* 5] = ROL64(s_ts[64* 2-1:64* 1],56);    
	assign s_rs[64*12-1:64*11] = ROL64(s_ts[64* 6-1:64* 5],8 );    
	assign s_rs[64*13-1:64*12] = ROL64(s_ts[64*12-1:64*11],25);    
	assign s_rs[64*23-1:64*22] = ROL64(s_ts[64*13-1:64*12],43);    
	assign s_rs[64* 5-1:64* 4] = ROL64(s_ts[64*23-1:64*22],62);    
	assign s_rs[64*11-1:64*10] = ROL64(s_ts[64* 5-1:64* 4],18);    
	assign s_rs[64* 3-1:64* 2] = ROL64(s_ts[64*11-1:64*10],39);    
	assign s_rs[64*16-1:64*15] = ROL64(s_ts[64* 3-1:64* 2],61);    
	assign s_rs[64*19-1:64*18] = ROL64(s_ts[64*16-1:64*15],20);    
	assign s_rs[64*24-1:64*23] = ROL64(s_ts[64*19-1:64*18],44);   

	//----- Chi ----
	assign s_cs[64*25-1:64*24] = s_rs[64*25-1:64*24]^((~s_rs[64*24-1:64*23])&s_rs[64*23-1:64*22]); //j=0,i=0:cs[0] = s[0]^((~s[1])&s[2]);
	assign s_cs[64*24-1:64*23] = s_rs[64*24-1:64*23]^((~s_rs[64*23-1:64*22])&s_rs[64*22-1:64*21]); //j=0,i=1:cs[1] = s[1]^((~s[2])&s[3]);
	assign s_cs[64*23-1:64*22] = s_rs[64*23-1:64*22]^((~s_rs[64*22-1:64*21])&s_rs[64*21-1:64*20]); //j=0,i=2:cs[2] = s[2]^((~s[3])&s[4]);
	assign s_cs[64*22-1:64*21] = s_rs[64*22-1:64*21]^((~s_rs[64*21-1:64*20])&s_rs[64*25-1:64*24]); //j=0,i=3:cs[3] = s[3]^((~s[4])&s[0]);
	assign s_cs[64*21-1:64*20] = s_rs[64*21-1:64*20]^((~s_rs[64*25-1:64*24])&s_rs[64*24-1:64*23]); //j=0,i=4:cs[4] = s[4]^((~s[0])&s[1]);
	//--                                                                                           
	assign s_cs[64*20-1:64*19] = s_rs[64*20-1:64*19]^((~s_rs[64*19-1:64*18])&s_rs[64*18-1:64*17]); //j=5,i=0:cs[5] = s[5]^((~s[6])&s[7]);
	assign s_cs[64*19-1:64*18] = s_rs[64*19-1:64*18]^((~s_rs[64*18-1:64*17])&s_rs[64*17-1:64*16]); //j=5,i=1:cs[6] = s[6]^((~s[7])&s[8]);
	assign s_cs[64*18-1:64*17] = s_rs[64*18-1:64*17]^((~s_rs[64*17-1:64*16])&s_rs[64*16-1:64*15]); //j=5,i=2:cs[7] = s[7]^((~s[8])&s[9]);
	assign s_cs[64*17-1:64*16] = s_rs[64*17-1:64*16]^((~s_rs[64*16-1:64*15])&s_rs[64*20-1:64*19]); //j=5,i=3:cs[8] = s[8]^((~s[9])&s[5]);
	assign s_cs[64*16-1:64*15] = s_rs[64*16-1:64*15]^((~s_rs[64*20-1:64*19])&s_rs[64*19-1:64*18]); //j=5,i=4:cs[9] = s[9]^((~s[5])&s[6]);	
    //--                                                                                
	assign s_cs[64*15-1:64*14] = s_rs[64*15-1:64*14]^((~s_rs[64*14-1:64*13])&s_rs[64*13-1:64*12]); //j=10,i=0:cs[10] = s[10]^((~s[11])&s[12]);
	assign s_cs[64*14-1:64*13] = s_rs[64*14-1:64*13]^((~s_rs[64*13-1:64*12])&s_rs[64*12-1:64*11]); //j=10,i=1:cs[11] = s[11]^((~s[12])&s[13]);
	assign s_cs[64*13-1:64*12] = s_rs[64*13-1:64*12]^((~s_rs[64*12-1:64*11])&s_rs[64*11-1:64*10]); //j=10,i=2:cs[12] = s[12]^((~s[13])&s[14]);
	assign s_cs[64*12-1:64*11] = s_rs[64*12-1:64*11]^((~s_rs[64*11-1:64*10])&s_rs[64*15-1:64*14]); //j=10,i=3:cs[13] = s[13]^((~s[14])&s[11]);
	assign s_cs[64*11-1:64*10] = s_rs[64*11-1:64*10]^((~s_rs[64*15-1:64*14])&s_rs[64*14-1:64*13]); //j=10,i=4:cs[14] = s[14]^((~s[15])&s[12]);	
	//--                                                                                   
	assign s_cs[64*10-1:64* 9] = s_rs[64*10-1:64* 9]^((~s_rs[64* 9-1:64* 8])&s_rs[64* 8-1:64* 7]); //j=15,i=0:cs[15] = s[15]^((~s[16])&s[17]);
	assign s_cs[64* 9-1:64* 8] = s_rs[64* 9-1:64* 8]^((~s_rs[64* 8-1:64* 7])&s_rs[64* 7-1:64* 6]); //j=15,i=1:cs[16] = s[16]^((~s[17])&s[18]);
	assign s_cs[64* 8-1:64* 7] = s_rs[64* 8-1:64* 7]^((~s_rs[64* 7-1:64* 6])&s_rs[64* 6-1:64* 5]); //j=15,i=2:cs[17] = s[17]^((~s[18])&s[19]);
	assign s_cs[64* 7-1:64* 6] = s_rs[64* 7-1:64* 6]^((~s_rs[64* 6-1:64* 5])&s_rs[64*10-1:64* 9]); //j=15,i=3:cs[18] = s[18]^((~s[19])&s[15]);
	assign s_cs[64* 6-1:64* 5] = s_rs[64* 6-1:64* 5]^((~s_rs[64*10-1:64* 9])&s_rs[64* 9-1:64* 8]); //j=15,i=4:cs[19] = s[19]^((~s[15])&s[16]);	
			//--                                                                                   
	assign s_cs[64* 5-1:64* 4] = s_rs[64* 5-1:64* 4]^((~s_rs[64* 4-1:64* 3])&s_rs[64* 3-1:64* 2]); //j=20,i=0:cs[20] = s[20]^((~s[21])&s[22]);
	assign s_cs[64* 4-1:64* 3] = s_rs[64* 4-1:64* 3]^((~s_rs[64* 3-1:64* 2])&s_rs[64* 2-1:64* 1]); //j=20,i=1:cs[21] = s[21]^((~s[22])&s[23]);
	assign s_cs[64* 3-1:64* 2] = s_rs[64* 3-1:64* 2]^((~s_rs[64* 2-1:64* 1])&s_rs[64* 1-1:64* 0]); //j=20,i=2:cs[22] = s[22]^((~s[23])&s[24]);
	assign s_cs[64* 2-1:64* 1] = s_rs[64* 2-1:64* 1]^((~s_rs[64* 1-1:64* 0])&s_rs[64* 5-1:64* 4]); //j=20,i=3:cs[23] = s[23]^((~s[24])&s[20]);
	assign s_cs[64* 1-1:64* 0] = s_rs[64* 1-1:64* 0]^((~s_rs[64* 5-1:64* 4])&s_rs[64* 4-1:64* 3]); //j=20,i=4:cs[24] = s[24]^((~s[20])&s[21]);	
	
	always@(posedge i_clk or posedge i_rst) begin
		if(i_rst) begin
			r_vin <= #DLY 1600'b0;
			r_count<= #DLY 5'd0;
			r_rndc <= #DLY 1536'b0;
			r_done <= #DLY 1'b0;
			r_state <= #DLY 1'b0;
		end else begin
			case(r_state)
				1'b0: begin
					r_count<= #DLY 5'd0;
					r_done <= #DLY 1'b0;
					if(i_start) begin
						r_vin <= #DLY s_vin; //input
						r_rndc <= #DLY RNDC;
						r_state <= #DLY 1'b1;	
					end
				end
				1'b1: begin
					r_count <= #DLY r_count + 1'b1;
					r_vin[64*24-1:0]<= #DLY s_cs[64*24-1:0];
					r_vin[64*25-1:64*24] <= #DLY s_cs[64*25-1:64*24]^r_rndc[64*24-1:64*23];
					r_rndc <= #DLY {r_rndc[64*23-1:0],64'b0};
					if(r_count==5'd23) begin
						r_done <= #DLY 1'b1;
						r_state <= #DLY 1'b0;
					end
				end
			endcase
		end
	end

	assign o_vout[64*25-1:64*24] = SWAP(r_vin[64*25-1:64*24]);
	assign o_vout[64*24-1:64*23] = SWAP(r_vin[64*24-1:64*23]);
	assign o_vout[64*23-1:64*22] = SWAP(r_vin[64*23-1:64*22]);
	assign o_vout[64*22-1:64*21] = SWAP(r_vin[64*22-1:64*21]);
	assign o_vout[64*21-1:64*20] = SWAP(r_vin[64*21-1:64*20]);
	assign o_vout[64*20-1:64*19] = SWAP(r_vin[64*20-1:64*19]);
	assign o_vout[64*19-1:64*18] = SWAP(r_vin[64*19-1:64*18]);
	assign o_vout[64*18-1:64*17] = SWAP(r_vin[64*18-1:64*17]);
	assign o_vout[64*17-1:64*16] = SWAP(r_vin[64*17-1:64*16]);
	assign o_vout[64*16-1:64*15] = SWAP(r_vin[64*16-1:64*15]);
	assign o_vout[64*15-1:64*14] = SWAP(r_vin[64*15-1:64*14]);
	assign o_vout[64*14-1:64*13] = SWAP(r_vin[64*14-1:64*13]);
	assign o_vout[64*13-1:64*12] = SWAP(r_vin[64*13-1:64*12]);
	assign o_vout[64*12-1:64*11] = SWAP(r_vin[64*12-1:64*11]);
	assign o_vout[64*11-1:64*10] = SWAP(r_vin[64*11-1:64*10]);
	assign o_vout[64*10-1:64* 9] = SWAP(r_vin[64*10-1:64* 9]);
	assign o_vout[64* 9-1:64* 8] = SWAP(r_vin[64* 9-1:64* 8]);	
	assign o_vout[64* 8-1:64* 7] = SWAP(r_vin[64* 8-1:64* 7]);
	assign o_vout[64* 7-1:64* 6] = SWAP(r_vin[64* 7-1:64* 6]);	
	assign o_vout[64* 6-1:64* 5] = SWAP(r_vin[64* 6-1:64* 5]);
	assign o_vout[64* 5-1:64* 4] = SWAP(r_vin[64* 5-1:64* 4]);	
	assign o_vout[64* 4-1:64* 3] = SWAP(r_vin[64* 4-1:64* 3]);
	assign o_vout[64* 3-1:64* 2] = SWAP(r_vin[64* 3-1:64* 2]);	
	assign o_vout[64* 2-1:64* 1] = SWAP(r_vin[64* 2-1:64* 1]);
	assign o_vout[64* 1-1:64* 0] = SWAP(r_vin[64* 1-1:64* 0]);			
	
	
	assign o_done = r_done;
	
	assign s_ts_x[ 0] = s_ts[64*25-1:64*24];
	assign s_ts_x[ 1] = s_ts[64*24-1:64*23];
	assign s_ts_x[ 2] = s_ts[64*23-1:64*22];
	assign s_ts_x[ 3] = s_ts[64*22-1:64*21];
	assign s_ts_x[ 4] = s_ts[64*21-1:64*20];
	assign s_ts_x[ 5] = s_ts[64*20-1:64*19];
	assign s_ts_x[ 6] = s_ts[64*19-1:64*18];
	assign s_ts_x[ 7] = s_ts[64*18-1:64*17];
	assign s_ts_x[ 8] = s_ts[64*17-1:64*16];
	assign s_ts_x[ 9] = s_ts[64*16-1:64*15];
	assign s_ts_x[10] = s_ts[64*15-1:64*14];
	assign s_ts_x[11] = s_ts[64*14-1:64*13];
	assign s_ts_x[12] = s_ts[64*13-1:64*12];
	assign s_ts_x[13] = s_ts[64*12-1:64*11];
	assign s_ts_x[14] = s_ts[64*11-1:64*10];
	assign s_ts_x[15] = s_ts[64*10-1:64* 9];
	assign s_ts_x[16] = s_ts[64* 9-1:64* 8];
	assign s_ts_x[17] = s_ts[64* 8-1:64* 7];
	assign s_ts_x[18] = s_ts[64* 7-1:64* 6];
	assign s_ts_x[19] = s_ts[64* 6-1:64* 5];
	assign s_ts_x[20] = s_ts[64* 5-1:64* 4];
	assign s_ts_x[21] = s_ts[64* 4-1:64* 3];
	assign s_ts_x[22] = s_ts[64* 3-1:64* 2];
	assign s_ts_x[23] = s_ts[64* 2-1:64* 1];
	assign s_ts_x[24] = s_ts[64* 1-1:64* 0];
	
	assign s_rs_x[ 0] = s_rs[64*25-1:64*24];
	assign s_rs_x[ 1] = s_rs[64*24-1:64*23];
	assign s_rs_x[ 2] = s_rs[64*23-1:64*22];
	assign s_rs_x[ 3] = s_rs[64*22-1:64*21];
	assign s_rs_x[ 4] = s_rs[64*21-1:64*20];
	assign s_rs_x[ 5] = s_rs[64*20-1:64*19];
	assign s_rs_x[ 6] = s_rs[64*19-1:64*18];
	assign s_rs_x[ 7] = s_rs[64*18-1:64*17];
	assign s_rs_x[ 8] = s_rs[64*17-1:64*16];
	assign s_rs_x[ 9] = s_rs[64*16-1:64*15];
	assign s_rs_x[10] = s_rs[64*15-1:64*14];
	assign s_rs_x[11] = s_rs[64*14-1:64*13];
	assign s_rs_x[12] = s_rs[64*13-1:64*12];
	assign s_rs_x[13] = s_rs[64*12-1:64*11];
	assign s_rs_x[14] = s_rs[64*11-1:64*10];
	assign s_rs_x[15] = s_rs[64*10-1:64* 9];
	assign s_rs_x[16] = s_rs[64* 9-1:64* 8];
	assign s_rs_x[17] = s_rs[64* 8-1:64* 7];
	assign s_rs_x[18] = s_rs[64* 7-1:64* 6];
	assign s_rs_x[19] = s_rs[64* 6-1:64* 5];
	assign s_rs_x[20] = s_rs[64* 5-1:64* 4];
	assign s_rs_x[21] = s_rs[64* 4-1:64* 3];
	assign s_rs_x[22] = s_rs[64* 3-1:64* 2];
	assign s_rs_x[23] = s_rs[64* 2-1:64* 1];
	assign s_rs_x[24] = s_rs[64* 1-1:64* 0];	

	assign s_cs_x[ 0] = s_cs[64*25-1:64*24];
	assign s_cs_x[ 1] = s_cs[64*24-1:64*23];
	assign s_cs_x[ 2] = s_cs[64*23-1:64*22];
	assign s_cs_x[ 3] = s_cs[64*22-1:64*21];
	assign s_cs_x[ 4] = s_cs[64*21-1:64*20];
	assign s_cs_x[ 5] = s_cs[64*20-1:64*19];
	assign s_cs_x[ 6] = s_cs[64*19-1:64*18];
	assign s_cs_x[ 7] = s_cs[64*18-1:64*17];
	assign s_cs_x[ 8] = s_cs[64*17-1:64*16];
	assign s_cs_x[ 9] = s_cs[64*16-1:64*15];
	assign s_cs_x[10] = s_cs[64*15-1:64*14];
	assign s_cs_x[11] = s_cs[64*14-1:64*13];
	assign s_cs_x[12] = s_cs[64*13-1:64*12];
	assign s_cs_x[13] = s_cs[64*12-1:64*11];
	assign s_cs_x[14] = s_cs[64*11-1:64*10];
	assign s_cs_x[15] = s_cs[64*10-1:64* 9];
	assign s_cs_x[16] = s_cs[64* 9-1:64* 8];
	assign s_cs_x[17] = s_cs[64* 8-1:64* 7];
	assign s_cs_x[18] = s_cs[64* 7-1:64* 6];
	assign s_cs_x[19] = s_cs[64* 6-1:64* 5];
	assign s_cs_x[20] = s_cs[64* 5-1:64* 4];
	assign s_cs_x[21] = s_cs[64* 4-1:64* 3];
	assign s_cs_x[22] = s_cs[64* 3-1:64* 2];
	assign s_cs_x[23] = s_cs[64* 2-1:64* 1];
	assign s_cs_x[24] = s_cs[64* 1-1:64* 0];	


	
endmodule

