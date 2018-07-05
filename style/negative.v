module Negative(
	iR,
	iG,
	iB,
	oR,
	oG,
	oB
);
input		[7:0]	iR;
input		[7:0]	iG;
input		[7:0]	iB;
output      [7:0]   oR;
output      [7:0]   oG;
output      [7:0]   oB;

assign oR = ((iR ^ 8'b1111_1111)); 
assign oG = ((iG ^ 8'b1111_1111)); 
assign oB = ((iB ^ 8'b1111_1111)); 

endmodule // HSI