module EdgeGray(
	ig00,
	ig01,
	ig02,
	ig10,
	ig11,
	ig12,
	ig20,
	ig21,
	ig22,
	oEdgeGray
);
input		[7:0] ig00;
input		[7:0]	ig01; 
input		[7:0]	ig02; 
input		[7:0]	ig10; 
input		[7:0]	ig11;
input		[7:0]	ig12;
input		[7:0]	ig20;
input		[7:0]	ig21; 
input		[7:0]	ig22; 
output 	[7:0]	oEdgeGray;

wire 		[7:0]	t0,t1,t2,t3,t4,t5,t6,t7;
wire 		[10:0]	otmp;

assign t0 = (ig11>ig00) ? (ig11-ig00) : (ig00-ig11);
assign t1 = (ig11>ig01) ? (ig11-ig01) : (ig01-ig11);
assign t2 = (ig11>ig02) ? (ig11-ig02) : (ig02-ig11);
assign t3 = (ig11>ig10) ? (ig11-ig10) : (ig10-ig11);
assign t4 = (ig11>ig12) ? (ig11-ig12) : (ig12-ig11);
assign t5 = (ig11>ig20) ? (ig11-ig20) : (ig20-ig11);
assign t6 = (ig11>ig21) ? (ig11-ig21) : (ig21-ig11);
assign t7 = (ig11>ig22) ? (ig11-ig22) : (ig22-ig11);


assign otmp = (t0 + t1 + t2 + t3 + t4 + t5 + t6 + t7) >> 1 ;
//assign oEdgeGray = (otmp > 75) ? 255 : (otmp < 25) ? 0 : otmp[7:0];
assign oEdgeGray = (otmp > 90) ? 255 : (otmp < 27) ? 0 : (otmp[7:0]-27)*4;







endmodule 









