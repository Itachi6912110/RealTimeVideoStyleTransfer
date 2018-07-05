module GAUSSIAN(
	ig00,
	ig01,
	ig02,
	ig10,
	ig11,
	ig12,
	ig20,
	ig21,
	ig22,
	oGrey
);
input		[7:0]	ig00;
input		[7:0]	ig01;
input		[7:0]	ig02;
input		[7:0]	ig10;
input		[7:0]	ig11;
input		[7:0]	ig12;
input		[7:0]	ig20;
input		[7:0]	ig21;
input		[7:0]	ig22;
output      [7:0]   oGrey;

wire 		[11:0] 	sum;

assign sum = ig00 + (2*ig01) + ig02 + (2*ig10) + (4*ig11) + (2*ig12) + ig20 + (2*ig21) + ig22;
assign oGrey = sum[11:4];

endmodule 