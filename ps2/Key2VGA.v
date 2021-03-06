module Key2VGA(
    clk,
    rst_n,
    X,
    Y,
    key,
    valid,
    pixel,
    all_ctrl,
    key_valid,
	 ostate,
	 ocount
    );

    input         clk;
    input         rst_n;
    input  [12:0] X; // in X, already w/o X_START
    input  [12:0] Y; // in Y, already w/o Y_START
    input  [7:0]  key;
    input         valid;
    output [7:0]  pixel;
    output [20:0] all_ctrl;
    output reg    key_valid;
	 output [2:0]  ostate;
	 output [2:0]  ocount;

    localparam IDLE     = 0;
    localparam L1       = 1;
    localparam L2       = 2;
    localparam L3       = 3;
    localparam RECORD_1 = 4;
    localparam RECORD_2 = 5;
    localparam RECORD_3 = 6;
    localparam SHIFT    = 7;

    reg    [2:0]  STATE, NEXT_STATE;
    reg    [2:0]  counter_w, counter_r;
    reg    [7:0]  key_r;
    reg    [20:0] all_ctrl_r;
	 wire   [20:0] all_ctrl_w;
    reg    [7:0]  line1 [4:0];
    reg    [7:0]  line2 [4:0];
    reg    [7:0]  line3 [4:0];
    reg   [7:0]  line1_w [4:0];
    reg   [7:0]  line2_w [4:0];
    reg   [7:0]  line3_w [4:0];
    reg    [7:0]  pixel_r;
	 wire   [7:0]  pixel_w;
	 
	 reg           valid_r;
	 reg           slow_valid_r;

    reg    [7:0]  word0, word1, word2, word3, word4;
    reg    [7:0]  word0_w, word1_w, word2_w, word3_w, word4_w;

    reg    [7:0] key2pxl_in;
    wire   [4:0] key2pxl_addrX, key2pxl_addrY;
    wire         okey2pxl;

    integer i;

    Key2pxl key2pxl(.key(key2pxl_in), .i_X(key2pxl_addrX), .i_Y(key2pxl_addrY),.o_one_pixel(okey2pxl));
    CtrlDecision ctrldecide(.clk(clk),.rst_n(rst_n),.word0(word0),.word1(word1),.word2(word2),.word3(word3),.word4(word4),.octrl(all_ctrl_w));

    assign pixel = pixel_r;
    assign all_ctrl = all_ctrl_r;
	 assign ostate = STATE;
	 assign ocount = counter_r;

    assign key2pxl_addrX = ((X >> 5) < 5) ? X[4:0] : 5'd0;
    assign key2pxl_addrY = ((Y >> 5) < 3) ? Y[4:0] : 5'd0;

    assign pixel_w = {8{okey2pxl}};
    

    // STATE transition
    always@(*) begin
        case(STATE)
            IDLE: begin
                if(valid_r == 1 && key == 8'h2C) begin
                    NEXT_STATE = L1;
                end
                else begin
                    NEXT_STATE = IDLE;
                end
            end
            L1: begin
                if(valid_r == 1) begin
                    if(key == 8'h5A) begin
                        NEXT_STATE = L2;
                    end
                    else if(key == 8'h24) begin
                        NEXT_STATE = IDLE;
                    end
                    else begin
                        NEXT_STATE = RECORD_1;
                    end
                end
                else begin
                    NEXT_STATE = L1;
                end
            end
            L2: begin
                if(valid_r == 1) begin
                    if(key == 8'h5A) begin
                        NEXT_STATE = L3;
                    end
                    else if(key == 8'h24) begin
                        NEXT_STATE = IDLE;
                    end
                    else begin
                        NEXT_STATE = RECORD_2;
                    end
                end
                else begin
                    NEXT_STATE = L2;
                end
            end
            L3: begin
                if(valid_r == 1) begin
                    if(key == 8'h5A) begin
                        NEXT_STATE = SHIFT;
                    end
                    else if(key == 8'h24) begin
                        NEXT_STATE = IDLE;
                    end
                    else begin
                        NEXT_STATE = RECORD_3;
                    end
                end
                else begin
                    NEXT_STATE = L3;
                end
            end
            RECORD_1: begin
                NEXT_STATE = L1;
            end
            RECORD_2: begin
                NEXT_STATE = L2;
            end
            RECORD_3: begin
                NEXT_STATE = L3;
            end
            SHIFT: begin
                NEXT_STATE = L3;
            end
            default: begin
                NEXT_STATE = IDLE;
            end
        endcase // STATE
    end

    // Key_valid
    always@(*) begin
        case(STATE)
            IDLE: begin
                key_valid = 0;
            end
            L1: begin
                key_valid = (((X>>5)<5)&&((Y>>5)<3))? 1 : 0;
            end
            L2: begin
                key_valid = (((X>>5)<5)&&((Y>>5)<3))? 1 : 0;
            end
            L3: begin
                key_valid = (((X>>5)<5)&&((Y>>5)<3))? 1 : 0;
            end
            RECORD_1: begin
                key_valid = (((X>>5)<5)&&((Y>>5)<3))? 1 : 0;
            end
            RECORD_2: begin
                key_valid = (((X>>5)<5)&&((Y>>5)<3))? 1 : 0;
            end
            RECORD_3: begin
                key_valid = (((X>>5)<5)&&((Y>>5)<3))? 1 : 0;
            end
            SHIFT: begin
                key_valid = (((X>>5)<5)&&((Y>>5)<3))? 1 : 0;
            end
            default: begin
                key_valid = 0;
            end
        endcase
    end

    // Counter
    always@(*) begin
        //counter_w = counter_r;
        if(STATE == L1 || STATE == L2 || STATE == L3)begin
            if(valid_r == 1) begin
                if(key == 8'h5A) begin
                    counter_w = 0;
                end
                else if(key == 8'h66) begin
                    counter_w = (counter_r!=0) ? (counter_r - 1) : 0;
                end
                else begin
                    counter_w = (counter_r>=5) ? 5 :(counter_r + 1);
                end
            end
            else begin
                counter_w = counter_r;
            end
        end
		  else if(STATE==IDLE) begin
				counter_w = 0;
		  end
        else begin
            counter_w = counter_r;
        end
    end

    // line1, line2, line3
    always@(*) begin
        for(i=0;i<5;i=i+1) begin
            line1_w[i] = line1[i];
            line2_w[i] = line2[i];
            line3_w[i] = line3[i];
        end

        case(STATE)
				IDLE: begin
					for(i=0;i<5;i=i+1) begin
						line1_w[i] = 0;
						line2_w[i] = 0;
						line3_w[i] = 0;
					end
				end
            RECORD_1: begin
					if(key_r==8'h66) begin
						line1_w[counter_r] = 0;
					end
					else begin
                  line1_w[counter_r-1] = key_r;
					end
            end
            RECORD_2: begin
                if(key_r==8'h66) begin
						line2_w[counter_r] = 0;
					end
					else begin
                  line2_w[counter_r-1] = key_r;
					end
            end
            RECORD_3: begin
                if(key_r==8'h66) begin
						line3_w[counter_r] = 0;
					end
					else begin
                  line3_w[counter_r-1] = key_r;
					end
            end
            SHIFT: begin
                for(i=0;i<5;i=i+1) begin
                    line1_w[i] = line2[i];
                    line2_w[i] = line3[i];
                    line3_w[i] = 8'd0;
                end
            end
            default: begin
                for(i=0;i<5;i=i+1) begin
                    line1_w[i] = line1[i];
                    line2_w[i] = line2[i];
                    line3_w[i] = line3[i];
                end
            end
        endcase
    end

    // key2pxl key in
    always@(*) begin
        if((Y>>5)==0) begin
            key2pxl_in = ((X>>5) < 5) ? line1[X>>5] : 0;
        end
        else if((Y>>5)==1) begin
            key2pxl_in = ((X>>5) < 5) ? line2[X>>5] : 0;
        end
        else if((Y>>5)==2) begin
            key2pxl_in = ((X>>5) < 5) ? line3[X>>5] : 0;
        end
        else begin
            key2pxl_in = 0;
        end
    end

    // decision in - word*
    always@(*) begin
        word0_w = word0;
        word1_w = word1;
        word2_w = word2;
        word3_w = word3;
        word4_w = word4;
        case(STATE)
            L1: begin
                if(valid_r==1&&key==8'h5A) begin
                    word0_w = line1[0];  
                    word1_w = line1[1];  
                    word2_w = line1[2];  
                    word3_w = line1[3];  
                    word4_w = line1[4];  
                end
            end
            L2: begin
                if(valid_r==1&&key==8'h5A) begin
                    word0_w = line2[0];  
                    word1_w = line2[1];  
                    word2_w = line2[2];  
                    word3_w = line2[3];  
                    word4_w = line2[4];  
                end
            end
            L3: begin
                if(valid_r==1&&key==8'h5A) begin
                    word0_w = line3[0];  
                    word1_w = line3[1];  
                    word2_w = line3[2];  
                    word3_w = line3[3];  
                    word4_w = line3[4];  
                end
            end
            default: begin
                word0_w = word0;  
                word1_w = word1;  
                word2_w = word2;  
                word3_w = word3;  
                word4_w = word4;  
            end
        endcase
    end

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            for(i=0;i<5;i=i+1) begin
                line1[i] <= 8'd0;
                line2[i] <= 8'd0;
                line3[i] <= 8'd0;
            end
            counter_r <= 0;
            key_r <= 0;
            all_ctrl_r <= 0;
            pixel_r <= 0;
				STATE <= IDLE;
				valid_r <= 0;
				slow_valid_r <= 0;

            word0 <= 0;  
            word1 <= 0;  
            word2 <= 0;  
            word3 <= 0;  
            word4 <= 0;  
        end
        else begin
				STATE <= NEXT_STATE;
            for(i=0;i<5;i=i+1) begin
                line1[i] <= line1_w[i];
                line2[i] <= line2_w[i];
                line3[i] <= line3_w[i];
            end
            counter_r <= counter_w;
            key_r <= key;
            all_ctrl_r <= all_ctrl_w;
            pixel_r <= pixel_w;
				slow_valid_r <= valid;
				valid_r <= ((slow_valid_r && (~valid)))? 1 : 0; 

            word0 <= word0_w;  
            word1 <= word1_w;  
            word2 <= word2_w;  
            word3 <= word3_w;  
            word4 <= word4_w;
        end
    end

endmodule // Key2VGA

module CtrlDecision(
    clk,
    rst_n,
    word0,
    word1,
    word2,
    word3,
    word4,
    octrl
    );
    
	 input         clk;
    input         rst_n;
    input  [7:0]  word0;
    input  [7:0]  word1;
    input  [7:0]  word2;
    input  [7:0]  word3;
    input  [7:0]  word4;
    output [20:0]  octrl;

    reg    [20:0]  ctrl_r, ctrl;
	 reg    [20:0] style1, style2, style1_w, style2_w;

    assign octrl = ctrl_r;
	 
always@(*) begin
    if(word0==8'h33) begin
        ctrl[7:0] = ctrl_r[7:0];
        ctrl[20:12] = ctrl_r[20:12];
        if(word2==8'h55) begin
            case(word3)
                8'h45: ctrl[11:8] = 4'b0000;
                8'h16: ctrl[11:8] = 4'b0011;
                8'h1E: ctrl[11:8] = 4'b1011;
                8'h26: ctrl[11:8] = 4'b0111;
                8'h25: ctrl[11:8] = 4'b1111;
                default: ctrl[11:8] = 4'b1111;
            endcase
        end
        else if(word2==8'h4E) begin
            case(word3)
                8'h45: ctrl[11:8] = 4'b0000;
                8'h16: ctrl[11:8] = 4'b1101;
                8'h1E: ctrl[11:8] = 4'b0101;
                8'h26: ctrl[11:8] = 4'b1001;
                8'h25: ctrl[11:8] = 4'b0001;
                default: ctrl[11:8] = 4'b0001;
            endcase
        end
        else begin
            ctrl[11:8] = ctrl_r[11:8];
        end
    end
    else if(word0==8'h1B) begin
        ctrl[3:0] = ctrl_r[3:0];
        ctrl[20:8] = ctrl_r[20:8];
        if(word2==8'h55) begin
            case(word3)
                8'h45: ctrl[7:4] = 4'b0000;
                8'h16: ctrl[7:4] = 4'b0011;
                8'h1E: ctrl[7:4] = 4'b1011;
                8'h26: ctrl[7:4] = 4'b0111;
                8'h25: ctrl[7:4] = 4'b1111;
                default: ctrl[7:4] = 4'b1111;
            endcase
        end
        else if(word2==8'h4E) begin
            case(word3)
                8'h45: ctrl[7:4] = 4'b0000;
                8'h16: ctrl[7:4] = 4'b1101;
                8'h1E: ctrl[7:4] = 4'b0101;
                8'h26: ctrl[7:4] = 4'b1001;
                8'h25: ctrl[7:4] = 4'b0001;
                default: ctrl[7:4] = 4'b0001;
            endcase
        end
        else begin
            ctrl[7:4] = ctrl_r[7:4];
        end
    end
    else if(word0==8'h43) begin
        ctrl[20:4] = ctrl_r[20:4];
        if(word2==8'h55) begin
            case(word3)
                8'h45: ctrl[3:0] = 4'b0000;
                8'h16: ctrl[3:0] = 4'b0011;
                8'h1E: ctrl[3:0] = 4'b1011;
                8'h26: ctrl[3:0] = 4'b0111;
                8'h25: ctrl[3:0] = 4'b1111;
                default: ctrl[3:0] = 4'b1111;
            endcase
        end
        else if(word2==8'h4E) begin
            case(word3)
                8'h45: ctrl[3:0] = 4'b0000;
                8'h16: ctrl[3:0] = 4'b1101;
                8'h1E: ctrl[3:0] = 4'b0101;
                8'h26: ctrl[3:0] = 4'b1001;
                8'h25: ctrl[3:0] = 4'b0001;
                default: ctrl[3:0] = 4'b0001;
            endcase
        end
        else begin
            ctrl[3:0] = ctrl_r[3:0];
        end
    end
	 else if(word0==8'h2C) begin
        ctrl[11:0] = ctrl_r[11:0];
		  ctrl[16:12] = 5'd0;
        if(word2==8'h55) begin
            case(word3)
                8'h45: ctrl[20:17] = 4'b0000;
                8'h16: ctrl[20:17] = 4'b0011;
                8'h1E: ctrl[20:17] = 4'b1011;
                8'h26: ctrl[20:17] = 4'b0111;
                8'h25: ctrl[20:17] = 4'b1111;
                default: ctrl[20:17] = 4'b1111;
            endcase
        end
        else if(word2==8'h4E) begin
            case(word3)
                8'h45: ctrl[20:17] = 4'b0000;
                8'h16: ctrl[20:17] = 4'b1101;
                8'h1E: ctrl[20:17] = 4'b0101;
                8'h26: ctrl[20:17] = 4'b1001;
                8'h25: ctrl[20:17] = 4'b0001;
                default: ctrl[20:17] = 4'b0001;
            endcase
        end
        else begin
            ctrl[20:17] = ctrl_r[20:17];
        end
    end
    else if(word0==8'h34) begin
        ctrl[16:12] = 5'b00100;
        ctrl[11:0]  = ctrl_r[11:0];
		  ctrl[20:17] = 4'b0;
    end
    else if(word0==8'h31) begin
        ctrl[16:12] = 5'b01000;
        ctrl[11:0]  = ctrl_r[11:0];
		  ctrl[20:17] = 4'd0;
    end
    else if(word0==8'h42) begin
        ctrl[16:12] = 5'b10000;
        ctrl[11:0]  = ctrl_r[11:0];
		  ctrl[20:17] = 4'd0;
    end
    else if(word0==8'h23) begin
        ctrl[16:12] = 5'b00001;
        ctrl[11:0]  = ctrl_r[11:0];
		  ctrl[20:17] = 4'd0;
    end
    else if(word0==8'h4D) begin
        ctrl[16:12] = 5'b00010;
        ctrl[11:0]  = ctrl_r[11:0];
		  ctrl[20:17] = 4'd0;
    end
	 else if(word0==8'h15) begin
			ctrl = 21'd0;
	 end
	 else if(word0==8'h1C) begin
			if(word2==8'h16) begin
				ctrl = style1;
			end
			else if(word2==8'h1E) begin
				ctrl = style2;
			end
			else begin
				ctrl = ctrl_r;
			end
	 end
    else begin
        ctrl = ctrl_r;
    end
end

// Record style
always@(*) begin
	if(word0==8'h2D) begin
		if(word2==8'h16) begin
			style1_w = ctrl_r;
			style2_w = style2;
		end
		else if(word2==8'h1E) begin
			style1_w = style1;
			style2_w = ctrl_r;
		end
	end
	else begin
		style1_w = style1;
		style2_w = style2;
	end
end

    always@(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            ctrl_r <= 0;
				style1 <= 0;
				style2 <= 0;
        end
        else begin
            ctrl_r <= ctrl;
				style1 <= style1_w;
				style2 <= style2_w;
        end
    end

endmodule // CtrlDecision