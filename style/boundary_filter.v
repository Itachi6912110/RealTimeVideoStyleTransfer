// Function: Filter Gradient 1 and output boundary
// Input: R_G1, G_G1, B_G1, R, G, B
// Output: R, G, B
module Boundary_Filter(i_clk, i_rst_n, iRed_G1, iGreen_G1, iBlue_G1, oRed, oGreen, oBlue);
    input        i_clk;
    input        i_rst_n;
    input  [7:0] iRed_G1;
    input  [7:0] iGreen_G1;
    input  [7:0] iBlue_G1;
    output [7:0] oRed;
    output [7:0] oGreen;
    output [7:0] oBlue;

    wire   [9:0] tmpRed_G1;
    wire   [9:0] tmpGreen_G1;
    wire   [9:0] tmpBlue_G1;
    wire   [9:0] tmpGrad;

    parameter THRESHOLD = 8; // ?

    assign tmpRed_G1 =   ({2'd0, iRed_G1} + {2'd0, iGreen_G1} + {2'd0, iBlue_G1}) / 3;
    assign tmpGreen_G1 = ({2'd0, iRed_G1} + {2'd0, iGreen_G1} + {2'd0, iBlue_G1}) / 3;
    assign tmpBlue_G1 =  ({2'd0, iRed_G1} + {2'd0, iGreen_G1} + {2'd0, iBlue_G1}) / 3;

    assign tmpGrad = {tmpRed_G1[7:0] + tmpGreen_G1[7:0] + tmpBlue_G1[7:0]} / 3;

    assign oRed   = (tmpGrad[7:0] > THRESHOLD) ? 0 : tmpGrad[7:0];
    assign oGreen = (tmpGrad[7:0] > THRESHOLD) ? 0 : tmpGrad[7:0];
    assign oBlue  = (tmpGrad[7:0] > THRESHOLD) ? 0 : tmpGrad[7:0];

endmodule // Gray_Level