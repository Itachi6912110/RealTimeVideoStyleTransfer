// Function: Filter noise by 3*3 input
// Input: iC0 ~ iC8, determine center(iC4) output
// Output: iC4 filter R, G, B
module Noise_Filter(iC0, iC1, iC2, iC3, iC4, iC5, iC6, iC7, iC8, oRed, oGreen, oBlue);
    // input 3*3 pixels, {R, G, B}
    input  [23:0] iC0;
    input  [23:0] iC1;
    input  [23:0] iC2;
    input  [23:0] iC3;
    input  [23:0] iC4;
    input  [23:0] iC5;
    input  [23:0] iC6;
    input  [23:0] iC7;
    input  [23:0] iC8;
    output [7:0] oRed;
    output [7:0] oGreen;
    output [7:0] oBlue;

    wire   [11:0] tmpR;
    wire   [11:0] tmpG;
    wire   [11:0] tmpB;

    // oRed filter
    assign tmpR = (iC0[23:16]+iC1[23:16]+iC2[23:16]+iC3[23:16]+iC4[23:16]+iC5[23:16]+iC6[23:16]+iC7[23:16]+iC8[23:16])/9;
    assign tmpG = (iC0[15:8]+iC1[15:8]+iC2[15:8]+iC3[15:8]+iC4[15:8]+iC5[15:8]+iC6[15:8]+iC7[15:8]+iC8[15:8])/9;
    assign tmpB = (iC0[7:0]+iC1[7:0]+iC2[7:0]+iC3[7:0]+iC4[7:0]+iC5[7:0]+iC6[7:0]+iC7[7:0]+iC8[7:0])/9;

    assign oRed = tmpR[7:0];
    assign oGreen = tmpG[7:0];
    assign oBlue = tmpB[7:0];


endmodule // Gray_Level