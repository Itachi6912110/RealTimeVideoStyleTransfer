module HSI2HSI(
	iH,
	iS,
	iI,
	sw1,
	sw2,
	sw3,
	sw4,
	oH,
	oS,
	oI
);
input		[8:0]	iH;
input		[7:0]	iS;
input		[7:0]	iI;
input               sw1;
input               sw2;
input               sw3;
input               sw4;
output      [8:0]   oH;
output      [7:0]   oS;
output      [7:0]   oI;

reg [8:0] oH_w;
reg [8:0] oS_w;
reg [8:0] oI_w;

assign oH = oH_w; 
assign oS = (oS_w>255)?255:oS_w[7:0];
assign oI = (oI_w>255)?255:oI_w[7:0];

always @(*) begin
	oH_w = iH;
	if({sw1,sw3,sw4}==3'b100) begin
		oS_w = (iS >> 1);
	end
	else if({sw1,sw3,sw4}==3'b101) begin
		oS_w = (iS <128) ? (iS >> 1) : (iS + (iS >> 1) - 128);
	end
	else if({sw1,sw3,sw4}==3'b110) begin
		oS_w = (iS<=235) ? iS + 20 : 255;
	end
	else if({sw1,sw3,sw4}==3'b111) begin
		oS_w = (iS<100) ? (iS+(iS>>2)+25) : (iS>=100 && iS < 200) ? ((iS>>1)+100) : iS;
	end
	else begin
		oS_w = iS;
	end
	//
	if({sw2,sw3,sw4}==3'b100) begin
		oI_w = (iI<64)?(iI+(iI>>2)):(iI>=64 && iI<200)?(iI-(iI>>2)+32):(iI+(iI>>2)-68);
	end
	else if({sw2,sw3,sw4}==3'b101) begin
		oI_w = 3*(iI >> 2);
	end
	else if({sw2,sw3,sw4}==3'b110) begin
		oI_w = iI + (iI>>2);
	end
	else if({sw2,sw3,sw4}==3'b111) begin
		oI_w = (iI<64)?(iI-(iI>>2)):(iI>=64 && iI<200)?(iI+(iI>>2)-32):(iI-(iI>>2)+68);
	end
	else begin
		oI_w = iI;
	end
	
end


endmodule // HSI