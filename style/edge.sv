module Edge(
	iR00, iG00, iB00,
	iR01, iG01, iB01,
	iR02, iG02, iB02,
	iR10, iG10, iB10,
	iR11, iG11, iB11,
	iR12, iG12, iB12,
	iR20, iG20, iB20,
	iR21, iG21, iB21,
	iR22, iG22, iB22,
	oEdgeGray
);
input		[7:0] 	iR00;
input		[7:0]	iG00;
input		[7:0]	iB00;
input		[7:0]	iR01; 
input		[7:0]	iG01; 
input		[7:0]	iB01;
input		[7:0]	iR02; 
input		[7:0]	iG02; 
input		[7:0]	iB02;
input		[7:0]	iR10; 
input		[7:0]	iG10; 
input		[7:0]	iB10;
input		[7:0]	iR11; 
input		[7:0]	iG11; 
input		[7:0]	iB11;
input		[7:0]	iR12; 
input		[7:0]	iG12; 
input		[7:0]	iB12;
input		[7:0]	iR20; 
input		[7:0]	iG20; 
input		[7:0]	iB20;
input		[7:0]	iR21; 
input		[7:0]	iG21; 
input		[7:0]	iB21;
input		[7:0]	iR22; 
input		[7:0]	iG22; 
input		[7:0]	iB22;
output 		[7:0]	oEdgeGray;

wire 		[10:0]	t1;
wire		[10:0]	t2;
wire 		[10:0]	t3;
wire		[10:0]	t4;
wire 		[10:0]	Tx;
wire		[10:0]	Ty;
wire 		[10:0]	otmp;

assign t1 =  ( iR02 + iG02 + iB02 + 2 * (iR12 + iG12 + iB12) + iR22 + iG22 + iB22 ) / 3 ;
assign t2 =  ( iR00 + iG00 + iB00 + 2 * (iR10 + iG10 + iB10) + iR20 + iG20 + iB20 ) / 3 ;
assign Tx =  (t1 >= t2) ? t1 - t2 : t2 - t1;
assign t3 =  ( iR20 + iG20 + iB20 + 2 * (iR21 + iG21 + iB21) + iR22 + iG22 + iB22 ) / 3 ;
assign t4 =  ( iR00 + iG00 + iB00 + 2 * (iR01 + iG01 + iB01) + iR02 + iG02 + iB02 ) / 3 ;
assign Ty =  (t3 >= t4) ? t3 - t4 : t4 - t3;
assign otmp = ( Tx + Ty ) >> 1;
assign oEdgeGray =  ( otmp > 255 ) ? 255 : otmp[7:0];

endmodule 









