// --------------------------------------------------------------------
// Copyright (c) 2010 by Terasic Technologies Inc. 
// --------------------------------------------------------------------
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development 
//   Kits made by Terasic.  Other use of this code, including the selling 
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use 
//   or functionality of this code.
//
// --------------------------------------------------------------------
//           
//                     Terasic Technologies Inc
//                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
//                     HsinChu County, Taiwan
//                     302
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// --------------------------------------------------------------------
//
// Major Functions:	VGA_Controller
//
// --------------------------------------------------------------------
//
// Revision History :
// --------------------------------------------------------------------
//   Ver  :| Author            :| Mod. Date :| Changes Made:
//   V1.0 :| Johnny FAN Peli Li:| 22/07/2010:| Initial Revision
// --------------------------------------------------------------------

module	VGA_Controller(	//	Host Side
						iRed,
						iGreen,
						iBlue,
						oRequest,
						//	VGA Side
						oVGA_R,
						oVGA_G,
						oVGA_B,
						oVGA_H_SYNC,
						oVGA_V_SYNC,
						oVGA_SYNC,
						oVGA_BLANK,

						//	Control Signal
						iCLK,
						iRST_N,
						iZOOM_MODE_SW,
						iSTYLE,
						iH_CTRL,
						iS_CTRL,
						iI_CTRL,
						iT_CTRL,
						iEdge,
						iPic,

						// Keyboard interface
						oHCont,
						oVCont,
						ikeypxl,
						ikey_valid
							);
`include "../VGA_Param.h"

`ifdef VGA_640x480p60
//	Horizontal Parameter	( Pixel )
parameter	H_SYNC_CYC	=	96;
parameter	H_SYNC_BACK	=	48;
parameter	H_SYNC_ACT	=	640;	
parameter	H_SYNC_FRONT=	16;
parameter	H_SYNC_TOTAL=	800;

//	Virtical Parameter		( Line )
parameter	V_SYNC_CYC	=	2;
parameter	V_SYNC_BACK	=	33;
parameter	V_SYNC_ACT	=	480;	
parameter	V_SYNC_FRONT=	10;
parameter	V_SYNC_TOTAL=	525; 

`else
 // SVGA_800x600p60
////	Horizontal Parameter	( Pixel )
parameter	H_SYNC_CYC	=	128;         //Peli
parameter	H_SYNC_BACK	=	88;
parameter	H_SYNC_ACT	=	800;	
parameter	H_SYNC_FRONT=	40;
parameter	H_SYNC_TOTAL=	1056;
//	Virtical Parameter		( Line )
parameter	V_SYNC_CYC	=	4;
parameter	V_SYNC_BACK	=	23;
parameter	V_SYNC_ACT	=	600;	
parameter	V_SYNC_FRONT=	1;
parameter	V_SYNC_TOTAL=	628;

`endif
//	Start Offset
parameter	X_START		=	H_SYNC_CYC+H_SYNC_BACK;
parameter	Y_START		=	V_SYNC_CYC+V_SYNC_BACK;
//	Host Side
input		[9:0]	iRed;
input		[9:0]	iGreen;
input		[9:0]	iBlue;
output	reg			oRequest;
//	VGA Side
output	reg	[9:0]	oVGA_R;
output	reg	[9:0]	oVGA_G;
output	reg	[9:0]	oVGA_B;
output	reg			oVGA_H_SYNC;
output	reg			oVGA_V_SYNC;
output	reg			oVGA_SYNC;
output	reg			oVGA_BLANK;

wire		[7:0]	mVGA_R;
wire		[7:0]	mVGA_G;
wire		[7:0]	mVGA_B;
reg					mVGA_H_SYNC;
reg					mVGA_V_SYNC;
wire				mVGA_SYNC;
wire				mVGA_BLANK;

//	Control Signal
input				iCLK;
input				iRST_N;
input 				iZOOM_MODE_SW;
input       [2:0]   iSTYLE;
input       [3:0]   iH_CTRL;
input       [3:0]   iS_CTRL;
input       [3:0]   iI_CTRL;
input       [3:0]   iT_CTRL;
input               iEdge;
input               iPic;

// Keyboard interface
output      [12:0]  oHCont;
output      [12:0]  oVCont;
input       [7:0]   ikeypxl;
input               ikey_valid;

//	Internal Registers and Wires
reg		[12:0]		H_Cont;
reg		[12:0]		V_Cont;

wire	[12:0]		v_mask;

reg     [7:0]       oVGA_R_w;
reg     [7:0]       oVGA_G_w;
reg     [7:0]       oVGA_B_w;

// RGB2HSI
wire		[8:0]	rgb2hsi_H_w;
wire		[7:0]	rgb2hsi_S_w;
wire		[7:0]	rgb2hsi_I_w;
reg 		[8:0]	rgb2hsi_H_r;
reg 		[7:0]	rgb2hsi_S_r;
reg 		[7:0]	rgb2hsi_I_r;

// HSI2HSI
wire        [8:0]   h2h_H_w;
wire        [7:0]   h2h_S_w;
wire        [7:0]   h2h_I_w;
reg         [8:0]   h2h_H_r;
reg         [7:0]   h2h_S_r;
reg         [7:0]   h2h_I_r;

// HSI2RGB
wire        [7:0]   hsi2rgb_R_w;
wire        [7:0]   hsi2rgb_G_w;
wire        [7:0]   hsi2rgb_B_w;
reg         [7:0]   hsi2rgb_R_r;
reg         [7:0]   hsi2rgb_G_r;
reg         [7:0]   hsi2rgb_B_r;

// raw style out Pipeline
reg         [23:0] pipe0;
reg         [23:0] pipe1;
reg         [23:0] pipe2;
reg         [23:0] pipe3;
wire        [23:0] pipe4_w;
reg         [23:0] pipe4;
reg         [23:0] pipe5;
reg         [23:0] pipe6;

// Keyboard in
reg         [8:0]  Keyin_0;
reg         [8:0]  Keyin_1;
reg         [8:0]  Keyin_2;
reg         [8:0]  Keyin_3;
reg         [8:0]  Keyin_4;
reg         [8:0]  Keyin_5;
reg         [8:0]  Keyin_6;

// 2nd Channel feat. pipeline
wire        [7:0] feat_0_w;
reg         [7:0] feat_0;
reg         [7:0] feat_1;
reg         [7:0] feat_2;
reg         [7:0] feat_3;
reg         [7:0] feat_4;
reg         [7:0] feat_5;

reg         [7:0] feat1_0;
reg         [7:0] feat1_1;
reg         [7:0] feat1_2;
reg         [7:0] feat1_3;

// pic style 1 channel
wire        [7:0] gaus_0_w;
reg         [7:0] gaus_0;
reg         [7:0] gaus_1;
reg         [7:0] gaus_2;
reg         [23:0] gaus_3;
reg         [23:0] gaus_4;
reg         [23:0] gaus_5;

// output mux ctrl pipeline
reg                OutCtrl_p0_w;
reg                OutCtrl_p0;
reg                OutCtrl_p1;
reg                OutCtrl_p2;
reg                OutCtrl_p3;

reg         [5:0]  PostCtrl_p0;
reg         [5:0]  PostCtrl_p1;
reg         [5:0]  PostCtrl_p2;
reg         [5:0]  PostCtrl_p3;
reg         [5:0]  PostCtrl_p4;
reg         [5:0]  PostCtrl_p5;

// HSI Control pipeline
reg         [11:0]  HSICtrl0;
reg         [11:0]  HSICtrl1;

assign v_mask = 13'd0 ;//iZOOM_MODE_SW ? 13'd0 : 13'd26;

// Data Buf
wire    [9:0]       mVGA_Gray;
reg     [7:0]       prev_gray [799:0];
reg     [7:0]       prev2_gray [799:0];
reg     [7:0]       tmp_gray[799:0];
// Prev node
reg     [7:0]       prev_G;
// Prev2 node
reg     [7:0]       prev2_G;

// Style Transfer In
reg     [23:0]      iC0; 
reg     [23:0]      iC1; 
reg     [23:0]      iC2; 
reg     [23:0]      iC3; 
reg     [23:0]      iC4; 
reg     [23:0]      iC5; 
reg     [23:0]      iC6; 
reg     [23:0]      iC7;
reg     [23:0]      iC8;

// Sharpen I/O
wire    [23:0]      i_sharpen;
wire    [23:0]      o_sharpen;

// gray level output
wire    [7:0]      o_gray;
reg     [7:0]      gray_r;

// negative output
wire    [23:0]      o_neg;
reg     [23:0]      neg_r;

// RGB temp output
wire    [23:0]      o_temp;
reg     [23:0]      temp_r;
// RGB temp control pipeline
reg     [3:0]       temp_0;
reg     [3:0]       temp_1;
reg     [3:0]       temp_2;
reg     [3:0]       temp_3;
reg     [3:0]       temp_4;

// Gaus RGB output
wire    [7:0]       gaus_r;
wire    [7:0]       gaus_g;
wire    [7:0]       gaus_b;

// Color quant output
wire    [7:0]       quant_r;
wire    [7:0]       quant_g;
wire    [7:0]       quant_b;
// Edge Str output
wire    [7:0]       pic_edge_r;
wire    [7:0]       pic_edge_g;
wire    [7:0]       pic_edge_b;

// Final VGA output
wire    [7:0]       final_out_R;
wire    [7:0]       final_out_G;
wire    [7:0]       final_out_B;

// Noise Filter Out
//wire    [7:0]       denoise_R;
//wire    [7:0]       denoise_G;
//wire    [7:0]       denoise_B;

integer  i;

////////////////////////////////////////////////////////
assign	mVGA_BLANK	=	mVGA_H_SYNC & mVGA_V_SYNC;
assign	mVGA_SYNC	=	1'b0;
assign  oHCont      = (H_Cont>=X_START) ? H_Cont-X_START : 0;
assign  oVCont      = (V_Cont>=Y_START+v_mask) ? V_Cont-Y_START-v_mask : 0;

// Info for Style Transfer : mVGA_R, mVGA_G, mVGA_B, mVGA_H, mVGA_S, mVGA_I
// Style Function Modules

wire [7:0] feat_0_w1;
wire [7:0] feat_0_w2;
wire [8:0] feat_0_temp;
EdgeGray  edge_gray(.ig00(iC0), .ig01(iC1), .ig02(iC2), .ig10(iC3), .ig11(iC4), 
        .ig12(iC5), .ig20(iC6), .ig21(iC7), .ig22(iC8), .oEdgeGray(feat_0_w1));
SobelEdgeGray sobel_edge_gray(.ig00(iC0), .ig01(iC1), .ig02(iC2), .ig10(iC3), .ig11(iC4), 
        .ig12(iC5), .ig20(iC6), .ig21(iC7), .ig22(iC8), .oEdgeGray(feat_0_w2));
assign feat_0_temp = (feat_0_w1 + feat_0_w2);
assign feat_0_w = (feat_0_temp > 255) ? 255 : (feat_0_temp[7:0]); 

		 	
GAUSSIAN gaus(.ig00(iC0),.ig01(iC1),.ig02(iC2),.ig10(iC3),.ig11(iC4),.ig12(iC5),
	.ig20(iC6),.ig21(iC7),.ig22(iC8),.oGrey(gaus_0_w));

RGB2HSI rgb2hsi(pipe0[7:0], pipe0[15:8], pipe0[23:16], rgb2hsi_H_w, rgb2hsi_S_w, rgb2hsi_I_w);

HSI2HSI_ALL hsh(rgb2hsi_H_r, rgb2hsi_S_r, rgb2hsi_I_r, HSICtrl1[0], HSICtrl1[1], HSICtrl1[2], 
	HSICtrl1[3], HSICtrl1[4], HSICtrl1[5], HSICtrl1[6], HSICtrl1[7], HSICtrl1[8], HSICtrl1[9], 
	HSICtrl1[10], HSICtrl1[11], h2h_H_w, h2h_S_w, h2h_I_w);

HSI2RGB hsi2rgb(h2h_H_r, h2h_S_r, h2h_I_r, hsi2rgb_R_w, hsi2rgb_G_w, hsi2rgb_B_w);
GAU_RGB gaus_rgb( .iR(pipe2[7:0]), .iG(pipe2[15:8]), .iB(pipe2[23:16]), .gray(gaus_2), .oR(gaus_r), .oG(gaus_g), .oB(gaus_b));

Blend   sharpener( .iR(i_sharpen[7:0]),.iG(i_sharpen[15:8]),.iB(i_sharpen[23:16]),.iGray(feat1_3),
	.oR(o_sharpen[7:0]),.oG(o_sharpen[15:8]),.oB(o_sharpen[23:16]));
COLOR_QUAN color_quant(.iR(gaus_3[7:0]),.iG(gaus_3[15:8]),.iB(gaus_3[23:16]),.oR(quant_r),.oG(quant_g),.oB(quant_b));

Gray_Level gray_level(.iRed(pipe4[7:0]), .iGreen(pipe4[15:8]), .iBlue(pipe4[23:16]), .ogray(o_gray));
Negative   negative(.iR(pipe4[7:0]),.iG(pipe4[15:8]),.iB(pipe4[23:16]),
	.oR(o_neg[7:0]),.oG(o_neg[15:8]),.oB(o_neg[23:16]));
RGB2RGB_TEMP rgb_temp(.iR(pipe4[7:0]),.iG(pipe4[15:8]),.iB(pipe4[23:16]),.sw_T(temp_4[0]),.sw_T1(temp_4[1]),
				.sw_T2(temp_4[2]),.sw_T3(temp_4[3]),.oR(o_temp[7:0]),.oG(o_temp[15:8]),.oB(o_temp[23:16]));
EDGE_STR  edge_str(.iR(gaus_4[7:0]),.iG(gaus_4[15:8]),.iB(gaus_4[23:16]),.edg(feat_4),.oR(pic_edge_r),.oG(pic_edge_g),.oB(pic_edge_b));

//Gray_Noise_Filter gray_noise_filter(
//	oVGA_R_w, oVGA_G_w, oVGA_B_w, prev_R, prev_G, prev_B, prev2_R, prev2_G, prev2_B, 
//	iC3, iC4, iC5, iC6, iC7, iC8, denoise_R, denoise_G, denoise_B);
//Noise_Filter noise_filter(iC0, iC1, iC2, iC3, iC4, iC5, iC6, iC7, iC8, denoise_R, denoise_G, denoise_B);

assign	mVGA_R	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
						V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
						?	iRed[9:2]	:	0;
assign	mVGA_G	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
						V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
						?	iGreen[9:2]	:	0;
assign	mVGA_B	=	(	H_Cont>=X_START 	&& H_Cont<X_START+H_SYNC_ACT &&
						V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
						?	iBlue[9:2]	:	0;

assign  mVGA_Gray = ({2'd0, iRed[9:2]} +{2'd0, iGreen[9:2]}+{2'd0, iBlue[9:2]})/3;

assign final_out_R = (Keyin_6[8]==1) ? Keyin_6[7:0] : pipe6[7:0];
assign final_out_G = (Keyin_6[8]==1) ? Keyin_6[7:0] : pipe6[15:8];
assign final_out_B = (Keyin_6[8]==1) ? Keyin_6[7:0] : pipe6[23:16];

// Data Path Pipeline
always@(posedge iCLK or negedge iRST_N) begin
	if(!iRST_N) begin
		pipe0 <= 0;
		feat_0 <= 0;
		gaus_0 <= 0;
		feat1_0<=0;
		Keyin_0 <= 0;

		rgb2hsi_H_r <= 0;
		rgb2hsi_S_r <= 0;
		rgb2hsi_I_r <= 0;
		pipe1 <= 0;
		feat_1 <= 0;
		gaus_1 <= 0;
		Keyin_1 <= 0;
		feat1_1 <= 0;

		h2h_H_r <= 0;
		h2h_S_r <= 0;
		h2h_I_r <= 0;
		pipe2 <= 0;
		feat_2 <= 0;
		gaus_2 <= 0;
		Keyin_2 <= 0;
		feat1_2 <= 0;

		hsi2rgb_R_r <= 0;
		hsi2rgb_G_r <= 0;
		hsi2rgb_B_r <= 0;
		pipe3 <= 0;
		feat_3 <= 0;
		gaus_3 <= 0;
		Keyin_3 <= 0;
		feat1_3 <= 0;

		pipe4 <= 0;
		feat_4 <= 0;
		gaus_4 <= 0;
		Keyin_4 <= 0;

		pipe5 <= 0;
		gray_r <= 0;
		neg_r <= 0;
		temp_r <= 0;
		feat_5 <= 0;
		gaus_5 <= 0;
		Keyin_5 <= 0;

		pipe6 <= 0;
		Keyin_6 <= 0;
	end
	else begin
		pipe0 <= {mVGA_B, mVGA_G, mVGA_R};
		feat_0 <= feat_0_w;
		gaus_0 <= gaus_0_w;
		feat1_0 <= feat_0_w1;
		Keyin_0 <= {ikey_valid, ikeypxl};

		rgb2hsi_H_r <= rgb2hsi_H_w;
		rgb2hsi_S_r <= rgb2hsi_S_w;
		rgb2hsi_I_r <= rgb2hsi_I_w;
		pipe1 <= pipe0;
		feat_1 <= feat_0;
		gaus_1 <= gaus_0;
		Keyin_1 <= Keyin_0;
		feat1_1 <= feat1_0;

		h2h_H_r <= h2h_H_w;
		h2h_S_r <= h2h_S_w;
		h2h_I_r <= h2h_I_w;
		pipe2 <= pipe1;
		feat_2 <= feat_1;
		gaus_2 <= gaus_1;
		Keyin_2 <= Keyin_1;
		feat1_2 <= feat1_1;

		hsi2rgb_R_r <= hsi2rgb_R_w;
		hsi2rgb_G_r <= hsi2rgb_G_w;
		hsi2rgb_B_r <= hsi2rgb_B_w;
		pipe3 <= pipe2;
		feat_3 <= feat_2;
		gaus_3 <= {gaus_b, gaus_g, gaus_r};
		Keyin_3 <= Keyin_2;
		feat1_3 <= feat1_2;

		pipe4 <= pipe4_w;
		feat_4 <= feat_3;
		gaus_4 <= {quant_b, quant_g, quant_r};
		Keyin_4 <= Keyin_3;

		pipe5 <= pipe4;
		gray_r <= o_gray;
		neg_r <= o_neg;
		temp_r <= o_temp;
		feat_5 <= 8'd255^feat_4;
		gaus_5 <= {pic_edge_b, pic_edge_g, pic_edge_r};
		Keyin_5 <= Keyin_4;

		pipe6 <= {oVGA_B_w ,oVGA_G_w ,oVGA_R_w};
		Keyin_6 <= Keyin_5;
	end
end

// Output MUX ctrl pipeline
always@(posedge  iCLK or negedge iRST_N) begin
	if(!iRST_N) begin
		OutCtrl_p0  <= 0;
		OutCtrl_p1  <= 0;
		OutCtrl_p2  <= 0;
		OutCtrl_p3  <= 0;

		HSICtrl0    <= 0;
		HSICtrl1    <= 0;

		PostCtrl_p0 <= 0;
		PostCtrl_p1 <= 0;
		PostCtrl_p2 <= 0;
		PostCtrl_p3 <= 0;
		PostCtrl_p4 <= 0;
		PostCtrl_p5 <= 0;
		
		temp_0 <= 0;
		temp_1 <= 0;
		temp_2 <= 0;
		temp_3 <= 0;
		temp_4 <= 0;
	end
	else begin
		OutCtrl_p0  <= (iH_CTRL[0]|iS_CTRL[0]|iI_CTRL[0]);
		OutCtrl_p1  <= OutCtrl_p0;
		OutCtrl_p2  <= OutCtrl_p1;
		OutCtrl_p3  <= OutCtrl_p2;

		HSICtrl0    <= {iI_CTRL, iS_CTRL, iH_CTRL};
		HSICtrl1    <= HSICtrl0;

		PostCtrl_p0 <= {iT_CTRL[0], iPic, iEdge, iSTYLE};
		PostCtrl_p1 <= PostCtrl_p0;
		PostCtrl_p2 <= PostCtrl_p1;
		PostCtrl_p3 <= PostCtrl_p2;
		PostCtrl_p4 <= PostCtrl_p3;
		PostCtrl_p5 <= PostCtrl_p4;
		
		temp_0 <= iT_CTRL;
		temp_1 <= temp_0;
		temp_2 <= temp_1;
		temp_3 <= temp_2;
		temp_4 <= temp_3;
	end
end

// sharpen decision
assign i_sharpen = (OutCtrl_p3==1) ? {hsi2rgb_B_r, hsi2rgb_G_r ,hsi2rgb_R_r} : pipe3;
assign pipe4_w   = (PostCtrl_p3[2]==1) ? o_sharpen : i_sharpen;

// Output wire decision, oVGA_*_w
always@(*) begin
	case({PostCtrl_p5[5:3], PostCtrl_p5[1:0]})
		5'b00000: begin
			oVGA_R_w = pipe5[7:0];
			oVGA_G_w = pipe5[15:8];
			oVGA_B_w = pipe5[23:16];
		end
		5'b00001: begin
			oVGA_R_w = gray_r;
			oVGA_G_w = gray_r;
			oVGA_B_w = gray_r;
		end
		5'b00010: begin
			oVGA_R_w = neg_r[7:0];
			oVGA_G_w = neg_r[15:8];
			oVGA_B_w = neg_r[23:16];
		end
		5'b00100: begin
			oVGA_R_w = feat_5;
			oVGA_G_w = feat_5;
			oVGA_B_w = feat_5;
		end
		5'b01000: begin
			oVGA_R_w = gaus_5[7:0];
			oVGA_G_w = gaus_5[15:8];
			oVGA_B_w = gaus_5[23:16];
		end
		5'b10000: begin
			oVGA_R_w = temp_r[7:0];
			oVGA_G_w = temp_r[15:8];
			oVGA_B_w = temp_r[23:16];
		end
		default: begin
			oVGA_R_w = pipe5[7:0];
			oVGA_G_w = pipe5[15:8];
			oVGA_B_w = pipe5[23:16];
		end
	endcase
end

// buffer for current x-axis gray value
always@(posedge iCLK or negedge iRST_N) begin
	if(!iRST_N) begin
		for(i=0;i<800;i=i+1) begin
			tmp_gray[i] <= 0;
		end
	end
	else begin
		if(H_Cont>=X_START && H_Cont<X_START+H_SYNC_ACT) begin
			tmp_gray[H_Cont-X_START] <= mVGA_Gray[7:0];
		end
	end
end

// update y-axis prev gray cell
always@(posedge iCLK or negedge iRST_N) begin
	if(!iRST_N) begin
		for(i=0;i<800;i=i+1) begin
			prev_gray[i] <= 0;
			prev2_gray[i] <= 0;
		end
	end
	else begin
		if(H_Cont>=X_START+H_SYNC_ACT) begin
			for(i=0;i<800;i=i+1) begin
				prev_gray[i] <= tmp_gray[i];
				prev2_gray[i] <= prev_gray[i];
			end
		end
	end
end

// Input for Style Control
always@(*) begin
	if(H_Cont>=X_START+2 && H_Cont<X_START+H_SYNC_ACT) begin
		iC0 = mVGA_Gray[7:0]; 
		iC1 = prev_G; 
		iC2 = prev2_G; 
		iC3 = prev_gray[H_Cont-X_START]; 
		iC4 = prev_gray[H_Cont-X_START-1];
		iC5 = prev_gray[H_Cont-X_START-2]; 
		iC6 = prev2_gray[H_Cont-X_START]; 
		iC7 = prev2_gray[H_Cont-X_START-1];
		iC8 = prev2_gray[H_Cont-X_START-2];
	end
	else begin
		iC0 = 0;
		iC1 = 0;
		iC2 = 0;
		iC4 = 0;
		iC5 = 0;
		iC6 = 0;
		iC7 = 0;
		iC8 = 0;
	end
end

// prev and prev2 gray cell
always@(posedge iCLK or negedge iRST_N) begin
	if(!iRST_N) begin
		prev_G <= 0;
		prev2_G <= 0;
	end
	else begin
		prev_G <= (mVGA_R+mVGA_G+mVGA_B)/3;
		prev2_G <= prev_G;
	end
	
end

// VGA output logic
always@(posedge iCLK or negedge iRST_N)
	begin
		if (!iRST_N)
			begin
				oVGA_R <= 0;
				oVGA_G <= 0;
                oVGA_B <= 0;
				oVGA_BLANK <= 0;
				oVGA_SYNC <= 0;
				oVGA_H_SYNC <= 0;
				oVGA_V_SYNC <= 0; 
			end
		else
			begin
            oVGA_R <= (	H_Cont>=X_START+7 	&& H_Cont<X_START+H_SYNC_ACT &&
						V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
						?	{final_out_R, 2'd0}	:	0;
				oVGA_G <= (	H_Cont>=X_START+7 	&& H_Cont<X_START+H_SYNC_ACT &&
						V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
						?	{final_out_G, 2'd0}	:	0;
            oVGA_B <= (	H_Cont>=X_START+7 	&& H_Cont<X_START+H_SYNC_ACT &&
						V_Cont>=Y_START+v_mask 	&& V_Cont<Y_START+V_SYNC_ACT )
						?	{final_out_B, 2'd0}	:	0;
				oVGA_BLANK <= mVGA_BLANK;
				oVGA_SYNC <= mVGA_SYNC;
				oVGA_H_SYNC <= mVGA_H_SYNC;
				oVGA_V_SYNC <= mVGA_V_SYNC;		
			end               
	end



//	Pixel LUT Address Generator
always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
	oRequest	<=	0;
	else
	begin
		if(	H_Cont>=X_START-2 && H_Cont<X_START+H_SYNC_ACT-2 &&
			V_Cont>=Y_START && V_Cont<Y_START+V_SYNC_ACT )
		oRequest	<=	1;
		else
		oRequest	<=	0;
	end
end

//	H_Sync Generator, Ref. 40 MHz Clock
always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		H_Cont		<=	0;
		mVGA_H_SYNC	<=	0;
	end
	else
	begin
		//	H_Sync Counter
		if( H_Cont < H_SYNC_TOTAL )
		H_Cont	<=	H_Cont+1;
		else
		H_Cont	<=	0;
		//	H_Sync Generator
		if( H_Cont < H_SYNC_CYC )
		mVGA_H_SYNC	<=	0;
		else
		mVGA_H_SYNC	<=	1;
	end
end

//	V_Sync Generator, Ref. H_Sync
always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
	begin
		V_Cont		<=	0;
		mVGA_V_SYNC	<=	0;
	end
	else
	begin
		//	When H_Sync Re-start
		if(H_Cont==0)
		begin
			//	V_Sync Counter
			if( V_Cont < V_SYNC_TOTAL )
			V_Cont	<=	V_Cont+1;
			else
			V_Cont	<=	0;
			//	V_Sync Generator
			if(	V_Cont < V_SYNC_CYC )
			mVGA_V_SYNC	<=	0;
			else
			mVGA_V_SYNC	<=	1;
		end
	end
end

endmodule