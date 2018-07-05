module StyleController(
    rawR,
    rawG,
    rawB,
    prev1,
    prev2,
    prev3,
    prev4,
    prev5,
    prev6,
    prev7,
    prev8,
    Ctrl,
    oR,
    oG,
    oB
);

    input   [7:0]  rawR;
    input   [7:0]  rawG;
    input   [7:0]  rawB;
    input   [7:0]  prev1;
    input   [7:0]  prev2;
    input   [7:0]  prev3;
    input   [7:0]  prev4;
    input   [7:0]  prev5;
    input   [7:0]  prev6;
    input   [7:0]  prev7;
    input   [7:0]  prev8;
    input   [2:0]  Ctrl;
    output  reg [7:0]  oR;
    output  reg [7:0]  oG;
    output  reg [7:0]  oB;

    wire    [7:0]  s1_r, s1_g, s1_b;
    wire    [7:0]  s2_r, s2_g, s2_b, s2_o;
    wire    [7:0]  s3_r, s3_g, s3_b;

    wire    [7:0]  now_gray;

    assign now_gray = (rawR+rawG+rawB)/3;
    assign s2_r = s2_o;
    assign s2_g = s2_o;
    assign s2_b = s2_o;

    Gray_Level s1(.iRed(rawR), .iGreen(rawG), .iBlue(rawB), .oRed(s1_r), .oGreen(s1_g), .oBlue(s1_b));
    EdgeGray   s2(.ig00(now_gray), .ig01(prev1), .ig02(prev2), .ig10(prev3), .ig11(prev4), 
        .ig12(prev5), .ig20(prev6), .ig21(prev7), .ig22(prev8), .oEdgeGray(s2_o) );
	 //SobelEdgeGray   s2(.ig00(now_gray), .ig01(prev1), .ig02(prev2), .ig10(prev3), .ig11(prev4), 
      //  .ig12(prev5), .ig20(prev6), .ig21(prev7), .ig22(prev8), .oEdgeGray(s2_o) );
    
    Negative   s3(.iR(rawR), .iG(rawG), .iB(rawB), .oR(s3_r), .oG(s3_g), .oB(s3_b));

    always@(*) begin
        case(Ctrl)
            0: begin
                oR = rawR;
                oG = rawG;
                oB = rawB;
            end
            1: begin
                oR = s1_r;
                oG = s1_g;
                oB = s1_b;
            end
            2: begin
                oR = s2_r;
                oG = s2_g;
                oB = s2_b;
            end
            3: begin
                oR = s3_r;
                oG = s3_g;
                oB = s3_b;
            end
            default: begin
                oR = rawR;
                oG = rawG;
                oB = rawB;
            end
        endcase // Ctrl
    end

endmodule