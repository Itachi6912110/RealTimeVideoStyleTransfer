module RGB2RGB_TEMP(
	iR,
	iG,
	iB,
	sw_T,
	sw_T1,
	sw_T2,
	sw_T3,
	oR,
	oG,
	oB
);
input		[7:0]	iR;
input		[7:0]	iG;
input		[7:0]	iB;
input 				sw_T;
input 				sw_T1;
input 				sw_T2;
input 				sw_T3;
output      [7:0]   oR;
output      [7:0]   oG;
output      [7:0]   oB;

reg 		[7:0] 	tmpR, tmpG, tmpB;
localparam TEMP1 = 8'd3;
localparam TEMP2 = 8'd6;
localparam TEMP3 = 8'd9;
localparam TEMP4 = 8'd12;


always @(*) begin
	if(sw_T) begin
		case({sw_T1,sw_T2,sw_T3})
			3'b000:begin
				tmpB = (iB<(8'd255-(TEMP4<<1))) ? (iB + (TEMP4<<1)) : 8'd255;
				tmpG = (iG>TEMP4) ? (iG - TEMP4) : 8'd0;
				tmpR = (iR>TEMP4) ? (iR - TEMP4) : 8'd0;
			end // 3'b000: 
			3'b001:begin
				tmpB = (iB<(8'd255-(TEMP3<<1))) ? (iB + (TEMP3<<1)) : 8'd255;
				tmpG = (iG>TEMP3) ? (iG - TEMP3) : 8'd0;
				tmpR = (iR>TEMP3) ? (iR - TEMP3) : 8'd0;
			end // 3'b001:
			3'b010:begin
				tmpB = (iB<(8'd255-(TEMP2<<1))) ? (iB + (TEMP2<<1)) : 8'd255;
				tmpG = (iG>TEMP2) ? (iG - TEMP2) : 8'd0;
				tmpR = (iR>TEMP2) ? (iR - TEMP2) : 8'd0;
			end // 3'b010:
			3'b011:begin
				tmpB = (iB<(8'd255-(TEMP1<<1))) ? (iB + (TEMP1<<1)) : 8'd255;
				tmpG = (iG>TEMP1) ? (iG - TEMP1) : 8'd0;
				tmpR = (iR>TEMP1) ? (iR - TEMP1) : 8'd0;
			end // 3'b011:
			3'b100:begin
				tmpB = (iB>(TEMP1<<1)) ? (iB - (TEMP1<<1)) : 8'd0;
				tmpG = (iG<(255-TEMP1)) ? (iG + TEMP1) : 8'd255;
				tmpR = (iR<(255-TEMP1)) ? (iR + TEMP1) : 8'd255;
			end // 3'b100:
			3'b101:begin
				tmpB = (iB>(TEMP2<<1)) ? (iB - (TEMP2<<1)) : 8'd0;
				tmpG = (iG<(8'd255-TEMP2)) ? (iG + TEMP2) : 8'd255;
				tmpR = (iR<(8'd255-TEMP2)) ? (iR + TEMP2) : 8'd255;
			end // 3'b101:
			3'b110:begin
				tmpB = (iB>(TEMP3<<1)) ? (iB - (TEMP3<<1)) : 8'd0;
				tmpG = (iG<(8'd255-TEMP3)) ? (iG + TEMP3) : 8'd255;
				tmpR = (iR<(8'd255-TEMP3)) ? (iR + TEMP3) : 8'd255;
			end // 3'b110:
			3'b111:begin
				tmpB = (iB>(TEMP4<<1)) ? (iB - (TEMP4<<1)) : 8'd0;
				tmpG = (iG<(8'd255-TEMP4)) ? (iG + TEMP4) : 8'd255;
				tmpR = (iR<(8'd255-TEMP4)) ? (iR + TEMP4) : 8'd255;
			end // 3'b111:
		endcase // {sw_T1,sw_T2,sw_T3}
	end // if(sw_T)
	else begin
		tmpR = iR;
		tmpG = iG;
		tmpB = iB;
	end // else

end

assign oR = tmpR; 
assign oG = tmpG;
assign oB = tmpB;

endmodule 