module GAU_RGB(
	iR,
	iG,
	iB,
	gray,
	oR,
	oG,
	oB
);
input		[7:0]	iR;
input		[7:0]	iG;
input		[7:0]	iB;
input 		[7:0]	gray;
output reg  [7:0]   oR;
output reg  [7:0]   oG;
output reg  [7:0]   oB;

wire		[9:0]	sum;
wire		[9:0]	diff;
wire		[9:0]	sum_g;
wire		[8:0]	diff_3;

wire      [7:0]   tmpR;
wire      [7:0]   tmpG;
wire      [7:0]   tmpB;

assign sum = iR+iG+iB;
assign sum_g = gray+gray+gray;
assign diff = (sum>sum_g)?(sum-sum_g):(sum_g-sum);
assign diff_3 = diff/3;

//assign tmpR = (sum>sum_g)?(iR - diff_3):(iR + diff_3); 
//assign tmpG = (sum>sum_g)?(iG - diff_3):(iG + diff_3); 
//assign tmpB = (sum>sum_g)?(iB - diff_3):(iB + diff_3); 

assign tmpR = (sum>sum_g)? ((iR>diff_3) ? (iR-diff_3) : 0) : ((iR+diff_3>255) ? 255 : (iR+diff_3)); 
assign tmpG = (sum>sum_g)? ((iG>diff_3) ? (iG-diff_3) : 0) : ((iG+diff_3>255) ? 255 : (iG+diff_3)); 
assign tmpB = (sum>sum_g)? ((iB>diff_3) ? (iB-diff_3) : 0) : ((iB+diff_3>255) ? 255 : (iB+diff_3)); 
/*
assign tmpR = iR;
assign tmpG = iG;
assign tmpB = iB;
*/

always @(*) begin
	if(tmpR>127)begin
		oR = (tmpR > 235) ? 255 : (tmpR+20);
	end // if(tmpR>127)
	else begin
		oR = (tmpR < 20) ? 0 : (tmpR-20);
	end // else
	if(tmpG>127)begin
		oG = (tmpG > 235) ? 255 : (tmpG+20);
	end // if(tmpR>127)
	else begin
		oG = (tmpG < 20) ? 0 : (tmpG-20);
	end // else
	if(tmpB>127)begin
		oB = (tmpB > 235) ? 255 : (tmpB+20);
	end // if(tmpR>127)
	else begin
		oB = (tmpB < 20) ? 0 : (tmpB-20);
	end // else
end


endmodule 