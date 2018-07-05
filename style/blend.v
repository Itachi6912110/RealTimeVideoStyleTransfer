module Blend(
	iR,
	iG,
	iB,
	iGray,
	oR,
	oG,
	oB
);
input		[7:0]	iR;
input		[7:0]	iG;
input		[7:0]	iB;
input  		[7:0]	iGray;
output reg  [7:0]   oR;
output reg  [7:0]   oG;
output reg  [7:0]   oB;

wire [9:0] sum;
assign sum = iR + iG + iB;
always @(*) begin
	if(sum < 384)begin
		oR = (iGray==255) ? (iR >> 1) : iR; 
		oG = (iGray==255) ? (iG >> 1) : iG;
		oB = (iGray==255) ? (iB >> 1) : iB; 
	end // if(sum < 384)
	else begin
		oR = (iGray==255) ? (iR + ((255-iR) >> 1)) : iR; 
		oG = (iGray==255) ? (iG + ((255-iG) >> 1)) : iG;
		oB = (iGray==255) ? (iB + ((255-iB) >> 1)) : iB;
	end // else
end

endmodule // HSI