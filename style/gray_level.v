// Function: Turn RGB to Gray level
// Input: R, G, B
// Output: R, G, B
module Gray_Level(iRed, iGreen, iBlue, ogray);
    input  [7:0] iRed;
    input  [7:0] iGreen;
    input  [7:0] iBlue;
    output [7:0] ogray;
    wire   [9:0] tmpgray;

    assign tmpgray = ({2'd0, iRed} + {2'd0, iGreen} + {2'd0, iBlue}) / 3;

    assign ogray = tmpgray[7:0];

endmodule // Gray_Level