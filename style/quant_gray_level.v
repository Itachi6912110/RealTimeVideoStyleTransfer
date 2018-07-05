// Function: Turn RGB to 16-Quant Gray level
// Input: R, G, B
// Output: R, G, B
module Quant_16_Gray_Level(i_clk, i_rst_n, iRed, iGreen, iBlue, oRed, oGreen, oBlue);
    input        i_clk;
    input        i_rst_n;
    input  [7:0] iRed;
    input  [7:0] iGreen;
    input  [7:0] iBlue;
    output [7:0] oRed;
    output [7:0] oGreen;
    output [7:0] oBlue;

    wire   [9:0] tmpRed;
    wire   [9:0] tmpGreen;
    wire   [9:0] tmpBlue;

    assign tmpRed = ({2'd0, iRed[7:2], 2'd0} + {2'd0, iGreen[7:2], 2'd0} + {2'd0, iBlue[7:2], 2'd0}) / 3;
    assign tmpGreen = ({2'd0, iRed[7:2], 2'd0} + {2'd0, iGreen[7:2], 2'd0} + {2'd0, iBlue[7:2], 2'd0}) / 3;
    assign tmpBlue = ({2'd0, iRed[7:2], 2'd0} + {2'd0, iGreen[7:2], 2'd0} + {2'd0, iBlue[7:2], 2'd0}) / 3;

    assign oRed = tmpRed[7:0];
    assign oGreen = tmpGreen[7:0];
    assign oBlue = tmpBlue[7:0];

endmodule // Gray_Level