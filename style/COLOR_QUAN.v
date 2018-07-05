module COLOR_QUAN(
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

reg 		[7:0] 	tmpR, tmpG, tmpB;
localparam Q1 = 32;
localparam Q2 = 64;
localparam Q3 = 96;
localparam Q4 = 128;
localparam Q5 = 160;
localparam Q6 = 192;
localparam Q7 = 224;

always @(*) begin
	
		if(iR < Q1)begin
			tmpR = Q1;
		end // if(iR < Q1)
		else if(iR>=Q1 && iR<Q2)begin
			tmpR = Q2;
		end // else if(iR>=Q1 && iR<Q2)
		else if(iR>=Q2 && iR<Q3)begin
			tmpR = Q3;
		end // else if(iR>=Q2 && iR<Q3)
		else if(iR>=Q3 && iR<Q4)begin
			tmpR = Q4;
		end // else if(iR>=Q3 && iR<Q4)
		else if(iR>=Q4 && iR<Q5)begin
			tmpR = Q5;
		end // else if(iR>=Q4 && iR<Q5)
		else if(iR>=Q5 && iR<Q6)begin
			tmpR = Q6;
		end // else if(iR>=Q5 && iR<Q6)
		else if(iR>=Q6 && iR<Q7)begin
			tmpR = Q7;
		end // else if(iR>=Q6 && iR<Q7)
		else begin
			tmpR = 255;
		end // else

		if(iG < Q1)begin
			tmpG = Q1;
		end // if(iG < Q1)
		else if(iG>=Q1 && iG<Q2)begin
			tmpG = Q2;
		end // else if(iG>=Q1 && iG<Q2)
		else if(iG>=Q2 && iG<Q3)begin
			tmpG = Q3;
		end // else if(iG>=Q2 && iG<Q3)
		else if(iG>=Q3 && iG<Q4)begin
			tmpG = Q4;
		end // else if(iG>=Q3 && iG<Q4)
		else if(iG>=Q4 && iG<Q5)begin
			tmpG = Q5;
		end // else if(iG>=Q4 && iG<Q5)
		else if(iG>=Q5 && iG<Q6)begin
			tmpG = Q6;
		end // else if(iG>=Q5 && iG<Q6)
		else if(iG>=Q6 && iG<Q7)begin
			tmpG = Q7;
		end // else if(iG>=Q6 && iG<Q7)
		else begin
			tmpG = 255;
		end // else

		if(iB < Q1)begin
			tmpB = Q1;
		end // if(iB < Q1)
		else if(iB>=Q1 && iB<Q2)begin
			tmpB = Q2;
		end // else if(iB>=Q1 && iB<Q2)
		else if(iB>=Q2 && iB<Q3)begin
			tmpB = Q3;
		end // else if(iB>=Q2 && iB<Q3)
		else if(iB>=Q3 && iB<Q4)begin
			tmpB = Q4;
		end // else if(iB>=Q3 && iB<Q4)
		else if(iB>=Q4 && iB<Q5)begin
			tmpB = Q5;
		end // else if(iB>=Q4 && iB<Q5)
		else if(iB>=Q5 && iB<Q6)begin
			tmpB = Q6;
		end // else if(iB>=Q5 && iB<Q6)
		else if(iB>=Q6 && iB<Q7)begin
			tmpB = Q7;
		end // else if(iB>=Q6 && iB<Q7)
		else begin
			tmpB = 255;
		end // else

end

assign oR = tmpR; 
assign oG = tmpG;
assign oB = tmpB;

endmodule 