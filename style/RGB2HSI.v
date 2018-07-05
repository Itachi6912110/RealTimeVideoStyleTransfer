module RGB2HSI(
	iR,
	iG,
	iB,
	Hue,
	Saturation,
	Intensity
);
input		[7:0]	iR;
input		[7:0]	iG;
input		[7:0]	iB;
output  reg    [8:0]   Hue;
output      [7:0]   Saturation;
output      [7:0]   Intensity;

reg [7:0] min;
wire [9:0] sum;

assign sum = iR + iG + iB;
assign Saturation = (sum==0) ? 0 : (255 - ((765*min)/sum));
assign Intensity = sum/3;


always @(*) begin 
	if (iR <= iG && iR <= iB) begin 
		min = iR;
	end 
	else if (iG < iR && iG <= iB) begin
		min = iG;
	end
	else begin
		min = iB;
	end 

	if (iR==iG && iR==iB) begin
		Hue = 0;
	end 
	else if (min==iB) begin
		Hue = 120*(iG-iB)/(iR+iG-iB-iB);
	end 
	else if (min==iR) begin 
		Hue = 120*(iB-iR)/(iB+iG-iR-iR)+120;
	end 
	else begin
		Hue = 120*(iR-iG)/(iB+iR-iG-iG)+240;
	end 
end 

			  

endmodule // HSI