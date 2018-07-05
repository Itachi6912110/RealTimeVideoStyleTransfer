module HSI2HSI_ALL(
	iH,
	iS,
	iI,
	sw_H,
	sw_H1,
	sw_H2,
	sw_H3,
	sw_S,
	sw_S1,
	sw_S2,
	sw_S3,
	sw_I,
	sw_I1,
	sw_I2,
	sw_I3,
	oH,
	oS,
	oI
);
input		[8:0]	iH;
input		[7:0]	iS;
input		[7:0]	iI;
input               sw_H;
input               sw_H1;
input               sw_H2;
input               sw_H3;
input               sw_S;
input               sw_S1;
input               sw_S2;
input               sw_S3;
input               sw_I;
input               sw_I1;
input               sw_I2;
input               sw_I3;
output      [8:0]   oH;
output      [7:0]   oS;
output      [7:0]   oI;

reg [9:0] oH_w;
reg [8:0] oS_w;
reg [8:0] oI_w;

localparam H_LEVEL1 = 10;
localparam H_LEVEL2 = 20;
localparam H_LEVEL3 = 30;
localparam H_LEVEL4 = 40;

assign oH = (oH_w > 360) ? 360 : oH_w[8:0]; 
assign oS = (oS_w > 255) ? 255 : oS_w[7:0];
assign oI = (oI_w > 255) ? 255 : oI_w[7:0];


always @(*) begin
	if(sw_H)begin
		if({sw_H1,sw_H2,sw_H3} == 3'b000)begin
			if(iH > 60 && iH <=240)begin
				oH_w = (iH>(240-H_LEVEL4)) ? 240 : (iH + H_LEVEL4);
			end // if(iH > 60 && iH <=240)
			else begin
				oH_w = (iH < H_LEVEL4) ? (iH+360-H_LEVEL4) : (iH<(240+H_LEVEL4) && iH > 60) ? 240 : (iH - H_LEVEL4); 
			end // else
		end // if({sw_H1,sw_H2} == 2'b00)
		else if({sw_H1,sw_H2,sw_H3} == 3'b001)begin
			if(iH > 60 && iH <=240)begin
				oH_w = (iH>(240-H_LEVEL3)) ? 240 : (iH + H_LEVEL3);
			end // if(iH > 60 && iH <=240)
			else begin
				oH_w = (iH < H_LEVEL3) ? (iH+360-H_LEVEL3) : (iH<(240+H_LEVEL3) && iH > 60) ? 240 : (iH - H_LEVEL3); 
			end // else
		end // if({sw_H1,sw_H2} == 2'b01)
		else if({sw_H1,sw_H2,sw_H3} == 3'b010)begin
			if(iH > 60 && iH <=240)begin
				oH_w = (iH>(240-H_LEVEL2)) ? 240 : (iH + H_LEVEL2);
			end // if(iH > 60 && iH <=240)
			else begin
				oH_w = (iH < H_LEVEL2) ? (iH+360-H_LEVEL2) : (iH<(240+H_LEVEL2) && iH > 60) ? 240 : (iH - H_LEVEL2); 
			end // else
		end 
		else if({sw_H1,sw_H2,sw_H3} == 3'b011)begin
			if(iH > 60 && iH <=240)begin
				oH_w = (iH>(240-H_LEVEL1)) ? 240 : (iH + H_LEVEL1);
			end // if(iH > 60 && iH <=240)
			else begin
				oH_w = (iH < H_LEVEL1) ? (iH+360-H_LEVEL1) : (iH<(240+H_LEVEL1) && iH > 60) ? 240 : (iH - H_LEVEL1); 
			end // else
		end 

		else if({sw_H1,sw_H2,sw_H3} == 3'b100)begin
			if(iH > 60 && iH <=240)begin
				oH_w = (iH<(60+H_LEVEL1))? 60 : (iH - H_LEVEL1) ;
			end // if(iH > 60 && iH <=240)
			else begin
				oH_w = (iH>(360-H_LEVEL1)) ? (iH + H_LEVEL1 - 360) : (iH>(60-H_LEVEL1) && iH < 240) ? 60 : iH + H_LEVEL1; 
			end // else
		end 
		else if({sw_H1,sw_H2,sw_H3} == 3'b101)begin
			if(iH > 60 && iH <=240)begin
				oH_w = (iH<(60+H_LEVEL2))? 60 : (iH - H_LEVEL2) ;
			end // if(iH > 60 && iH <=240)
			else begin
				oH_w = (iH>(360-H_LEVEL2)) ? (iH + H_LEVEL2 - 360) : (iH>(60-H_LEVEL2) && iH < 240) ? 60 : iH + H_LEVEL2; 
			end // else
		end 
		else if({sw_H1,sw_H2,sw_H3} == 3'b110)begin
			if(iH > 60 && iH <=240)begin
				oH_w = (iH<(60+H_LEVEL3))? 60 : (iH - H_LEVEL3) ;
			end // if(iH > 60 && iH <=240)
			else begin
				oH_w = (iH>(360-H_LEVEL3)) ? (iH + H_LEVEL3 - 360) : (iH>(60-H_LEVEL3) && iH < 240) ? 60 : iH + H_LEVEL3; 
			end // else
		end 
		else begin
			if(iH > 60 && iH <=240)begin
				oH_w = (iH<(60+H_LEVEL4))? 60 : (iH - H_LEVEL4) ;
			end // if(iH > 60 && iH <=240)
			else begin
				oH_w = (iH>(360-H_LEVEL4)) ? (iH + H_LEVEL4 - 360) : (iH>(60-H_LEVEL4) && iH < 240) ? 60 : iH + H_LEVEL4; 
			end // else
		end // else

	end // if(sw_H)
	else begin
		oH_w = iH;
	end // else


	if(sw_S) begin
		if({sw_S1,sw_S2,sw_S3}==3'b000)begin
			oS_w = (iS<128) ? (iS >> 1) : (iS + (iS >> 1) - 128);
		end 
		else if({sw_S1,sw_S2,sw_S3}==3'b001)begin
			oS_w = (iS<128) ? (iS - (iS>>2) - (iS>>3)) : (iS + (iS >> 2) + (iS >> 3) - 96);
		end // else if({sw_S1,sw_S2,sw_S3}==3'b001)
		else if({sw_S1,sw_S2,sw_S3}==3'b010)begin
			oS_w = (iS<128) ? (iS - (iS >> 2)) : (iS + (iS >> 2) - 64);
		end
		else if({sw_S1,sw_S2,sw_S3}==3'b011)begin
			oS_w = (iS<128) ? (iS - (iS >> 3)) : (iS + (iS >> 3) - 32);
		end // else if({sw_S1,sw_S2,sw_S3}==3'b011)
		else if({sw_S1,sw_S2,sw_S3}==3'b100)begin
			oS_w = (iS>32 && iS<=128)?(iS + (iS >> 3) - 4) : (iS>128 && iS<224) ? (iS - (iS >> 3) + 28) : iS;
		end // else if({sw_S1,sw_S2,sw_S3}==3'b100)
		else if({sw_S1,sw_S2,sw_S3}==3'b101)begin
			oS_w = (iS>32 && iS<=128)?(iS + (iS >> 2) - 8) : (iS>128 && iS<224) ? (iS - (iS >> 2) + 56) : iS;
		end // else if({sw_S1,sw_S2}==2'b10)
		else if({sw_S1,sw_S2,sw_S3}==3'b110)begin
			oS_w = (iS>32 && iS<=128)?(iS + (iS >> 2) + (iS >> 3) - 12) : (iS>128 && iS<224) ? (iS - (iS >> 2) - (iS >> 3) + 84) : iS;
		end // else if({sw_S1,sw_S2,sw_S3}==3'b110)
		else begin
			oS_w = (iS>32 && iS<=128)?(iS + (iS >> 1) - 16) : (iS>128 && iS<224) ? (iS - (iS >> 1) + 112) : iS;
		end // else
	end // if(sw_S)
	else begin
		oS_w = iS;
	end // else

	if(sw_I) begin
		if({sw_I1,sw_I2,sw_I3}==3'b000)begin
			oI_w = (iI<64)?(iI+(iI>>1)):(iI>=64 && iI < 192)?((iI>>1)+64):(iI+(iI>>1)-128);
		end
		else if({sw_I1,sw_I2,sw_I3}==3'b001)begin
			oI_w = (iI<64)?(iI+(iI>>2)+(iI>>3)):(iI>=64 && iI < 192)?(iI-(iI>>2)-(iI>>3)+48):(iI+(iI>>2)+(iI>>3)-96);
		end
		else if({sw_I1,sw_I2,sw_I3}==3'b010)begin
			oI_w = (iI<64)?(iI+(iI>>2)):(iI>=64 && iI < 192)?(iI-(iI>>2)+32):(iI+(iI>>2)-64);
		end 
		else if({sw_I1,sw_I2,sw_I3}==3'b011)begin
			oI_w = (iI<64)?(iI+(iI>>3)):(iI>=64 && iI < 192)?(iI-(iI>>3)+16):(iI+(iI>>3)-32);
		end
		else if({sw_I1,sw_I2,sw_I3}==3'b100)begin
			oI_w = (iI<64)?(iI-(iI>>3)):(iI>=64 && iI < 192)?(iI+(iI>>3)-16):(iI-(iI>>3)+32);
		end
		else if({sw_I1,sw_I2,sw_I3}==3'b101)begin
			oI_w = (iI<64)?(iI-(iI>>2)):(iI>=64 && iI < 192)?(iI+(iI>>2)-32):(iI-(iI>>2)+64);
		end 
		else if({sw_I1,sw_I2,sw_I3}==3'b110)begin
			oI_w = (iI<64)?(iI-(iI>>2)-(iI>>3)):(iI>=64 && iI < 192)?(iI+(iI>>2)+(iI>>3)-48):(iI-(iI>>2)-(iI>>3)+96);
		end
		else begin
			oI_w = (iI<64)?((iI>>1)):(iI>=64 && iI < 192)?(iI+(iI>>1)-64):((iI>>1)+128);
		end // else
	end // if(sw_I)
	else begin
		oI_w = iI;
	end // else



end


endmodule // HSI