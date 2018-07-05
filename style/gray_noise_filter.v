// Function: Filter noise by 3*3 input
// Input: iC0 ~ iC8, determine center(iC4) output
// Output: iC4 filter R, G, B
module Gray_Noise_Filter(iC0_r, iC0_g, iC0_b, iC1_r, iC1_g, iC1_b, iC2_r, iC2_g, iC2_b, iC3, iC4, iC5, iC6, iC7, iC8, oRed, oGreen, oBlue);
    // input 3*3 pixels, {R, G, B}
    input  [7:0] iC0_r;
    input  [7:0] iC0_g;
    input  [7:0] iC0_b;
    input  [7:0] iC1_r;
    input  [7:0] iC1_g;
    input  [7:0] iC1_b;
    input  [7:0] iC2_r;
    input  [7:0] iC2_g;
    input  [7:0] iC2_b;
    input  [7:0] iC3;
    input  [7:0] iC4;
    input  [7:0] iC5;
    input  [7:0] iC6;
    input  [7:0] iC7;
    input  [7:0] iC8;
    output [7:0] oRed;
    output [7:0] oGreen;
    output [7:0] oBlue;

    wire   [11:0] tmpR;
    wire   [11:0] tmpG;
    wire   [11:0] tmpB;

    wire          sel_r;
    wire          sel_g;
    wire          sel_b;

    parameter THR = 200;

    // oRed filter
    assign tmpR = (iC0_r+iC1_r+iC2_r+iC3+iC4+iC5+iC6+iC7+iC8)/9;
    assign tmpG = (iC0_g+iC1_g+iC2_g+iC3+iC4+iC5+iC6+iC7+iC8)/9;
    assign tmpB = (iC0_b+iC1_b+iC2_b+iC3+iC4+iC5+iC6+iC7+iC8)/9;

    assign sel_r = (iC0_r > tmpR) ? ((iC0_r-tmpR>THR)?1:0) : ((tmpR-iC0_r>THR)?1:0);
    assign sel_g = (iC0_g > tmpG) ? ((iC0_g-tmpG>THR)?1:0) : ((tmpG-iC0_g>THR)?1:0);
    assign sel_b = (iC0_b > tmpB) ? ((iC0_b-tmpB>THR)?1:0) : ((tmpB-iC0_b>THR)?1:0);

    assign oRed = sel_r ? tmpR[7:0] : iC0_r;
    assign oGreen = sel_g ? tmpG[7:0] : iC0_g;
    assign oBlue = sel_b ? tmpB[7:0] : iC0_b;


endmodule // Gray_Level