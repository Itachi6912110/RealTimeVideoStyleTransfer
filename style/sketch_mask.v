// Function: Filter Gradient 1 and output sketch gray
// Input: R_G1, G_G1, B_G1, R, G, B
// Output: R, G, B
module Sketch_Mask(i_clk, i_rst_n, iRed, iGreen, iBlue, iRed_G1, iGreen_G1, iBlue_G1, oRed, oGreen, oBlue);
    input        i_clk;
    input        i_rst_n;
    input  [7:0] iRed;
    input  [7:0] iGreen;
    input  [7:0] iBlue;
    input  [7:0] iRed_G1;
    input  [7:0] iGreen_G1;
    input  [7:0] iBlue_G1;
    output [7:0] oRed;
    output [7:0] oGreen;
    output [7:0] oBlue;

    wire   [9:0] tmpgray;
    wire   [9:0] tmpGrad;

    parameter THRESHOLD = 50;

    assign tmpgray = ({2'd0, iRed} + {2'd0, iGreen} + {2'd0, iBlue}) / 3;
    assign tmpGrad = ({2'd0, iRed_G1} + {2'd0, iGreen_G1} + {2'd0, iBlue_G1}) / 3;

    assign oRed   = (tmpGrad[7:0] > THRESHOLD) ? 0 : (((tmpgray<<1) > 255) ? 255 : tmpgray<<1);
    assign oGreen = (tmpGrad[7:0] > THRESHOLD) ? 0 : (((tmpgray<<1) > 255) ? 255 : tmpgray<<1);
    assign oBlue  = (tmpGrad[7:0] > THRESHOLD) ? 0 : (((tmpgray<<1) > 255) ? 255 : tmpgray<<1);

endmodule // Gray_Level