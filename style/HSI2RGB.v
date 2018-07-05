module HSI2RGB(
	iH,
	iS,
	iI,
	Red,
	Green,
	Blue
);
input		[8:0]	iH;
input		[7:0]	iS;
input		[7:0]	iI;
output      [7:0]   Red;
output      [7:0]   Green;
output      [7:0]   Blue;

wire [7:0] min;
wire [7:0] temp1;
wire [7:0] temp2;
wire [15:0] IS;
wire [15:0] IS2;
wire [24:0] HSI;
wire [8:0] red2,green2,blue2;
assign IS  = iI*iS;
assign IS2 = (IS*3)/255;
assign HSI = (IS*iH)/10200;
assign min = iI - (IS/255);	
assign red2   = (iH<120) ? (min+IS2-HSI) 	: (iH>=120&&iH<240) ? min 						: (min + HSI - 2*IS2);
assign green2 = (iH<120) ? (min+HSI) 		: (iH>=120&&iH<240) ? (min + 2*IS2 - HSI) : min;
assign blue2  = (iH<120) ? min 				: (iH>=120&&iH<240) ? (min + HSI - IS2) 	: (min + 3*IS2 - HSI);
assign Red = (red2>255)?255:red2;
assign Green = (green2>255)?255:green2;
assign Blue = (blue2>255)?255:blue2;

endmodule // HSI