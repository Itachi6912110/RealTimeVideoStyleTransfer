module HSI2HSI_temp(
	clk,
	rst,
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
input               clk;
input               rst;
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

reg [8:0] oH_r, oH_w;
reg [7:0] oS_r, oS_w;
reg [7:0] oI_r, oI_w;

wire [8:0] iH2,iH3;

assign oH = oH_r; 
assign oS = oS_r;
assign oI = oI_r;
assign iH2 = (iH>=60)? iH-60 : iH+300;
assign iH3 = (iH>=300)?iH-300 : iH+60; 
always @(*) begin
	oI_w = iI;
	oS_w = iS;
	if({sw1,sw3,sw4}==3'b100) begin
		if(iH2<=180) begin
			oH_w = iH2 - (iH2 >> 2);
		end // if(iH2<=180)
		else begin
			oH_w = iH2 + ((360-iH2) >> 2);
		end // else
	end
	else if({sw1,sw3,sw4}==3'b101) begin
		if(iH2<=180) begin
			oH_w = iH2 - (iH2 >> 1);
		end // if(iH2<=180)
		else begin
			oH_w = iH2 + ((360-iH2) >> 1);
		end // else
	end
	else if({sw1,sw3,sw4}==4'b110) begin
		if(iH2<=180) begin
			oH_w = iH2 + ((180-iH2) >> 2);
		end // if(iH2<=180)
		else begin
			oH_w = iH2 - ((iH2-180) >> 2);
		end // else
	end
	else if({sw1,sw3,sw4}==3'b111) begin
		if(iH2<=180) begin
			oH_w = iH2 + ((180-iH2) >> 1);
		end // if(iH2<=180)
		else begin
			oH_w = iH2 - ((iH2-180) >> 1);
		end // else
	end
	else begin
	//
		if({sw2,sw3,sw4}==3'b100) begin
			if(iH3<=180) begin
				oH_w = iH3 - (iH3 >> 2);
			end // if(iH2<=180)
			else begin
				oH_w = iH3 + ((360-iH3) >> 2);
			end // else
		end
		else if({sw2,sw3,sw4}==3'b101) begin
			if(iH3<=180) begin
				oH_w = iH3 - (iH3 >> 1);
			end // if(iH2<=180)
			else begin
				oH_w = iH3 + ((360-iH3) >> 1);
			end // else
		end
		else if({sw2,sw3,sw4}==3'b110) begin
			if(iH3<=180) begin
				oH_w = iH3 + ((180-iH3) >> 2);
			end // if(iH2<=180)
			else begin
				oH_w = iH3 - ((iH3-180) >> 2);
			end // else
		end
		else if({sw2,sw3,sw4}==3'b111) begin
			if(iH3<=180) begin
				oH_w = iH3 + ((180-iH3) >> 1);
			end // if(iH2<=180)
			else begin
				oH_w = iH3 - ((iH3-180) >> 1);
			end // else
		end
		else begin
			oH_w = iH;
		end
	end 
	
end

always @(posedge clk or negedge rst) begin
	if(~rst) begin
		oH_r <= 0;
		oS_r <= 0;
		oI_r <= 0;
	end 
	else begin
		oS_r <= oS_w;
		oI_r <= oI_w;
		if({sw1,sw2}==2'b10)begin
			if(oH_w>=300)begin
				oH_r <= oH_w - 300;
			end // if(oH_w>=300)
			else begin
				oH_r <= oH_w + 60;
			end // else
		end // if({sw1,sw2}==2'b10)
		else if({sw1,sw2}==2'b01)begin
			if(oH_w<300)begin
				oH_r <= oH_w + 300;
			end // if(oH_w>=300)
			else begin
				oH_r <= oH_w - 60;
			end // else
		end // else if({sw1,sw2}==2'b01)
		else begin
			oH_r <= iH;
		end // else
	end
end


endmodule // HSI