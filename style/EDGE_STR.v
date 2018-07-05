module EDGE_STR(
	iR,
	iG,
	iB,
	edg,
	oR,
	oG,
	oB
);
input		[7:0]	iR;
input		[7:0]	iG;
input		[7:0]	iB;
input		[7:0]	edg;
output      [7:0]   oR;
output      [7:0]   oG;
output      [7:0]   oB;

assign oR = (edg==255)? ((iR<128) ? (iR >> 2) : (255 - ((255-iR) >> 2))) : iR; 
assign oG = (edg==255)? ((iG<128) ? (iG >> 2) : (255 - ((255-iG) >> 2))) : iG; 
assign oB = (edg==255)? ((iB<128) ? (iB >> 2) : (255 - ((255-iB) >> 2))) : iB; 
endmodule 