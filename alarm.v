`timescale 1ns / 1ps
                                    
//////////////////////////////////////
//          A L A R M               //
//              SET?        SEPARATE MODULE FOR FLASHING leds?
//         M O D U L E              //
//////////////////////////////////////

module alarm#(
    parameter sys_freq = 100000000
    )(
    input clk, rst, center, up, down, left, right,
    input swh, swtm, swm,
    output reg dp,
//    output reg [3:0] hour_d , t_min_d, min_d,
    output reg [3:0] hour, t_min, min,
    output reg [2:0] state
    );
    
                    
//////////////////////////////////////
//          STATE MACHINE           //
//////////////////////////////////////
////reg [1:0] state;
//localparam HR = 3'b000;  localparam TenMin = 3'b001;
//localparam Min = 3'b010; localparam IDLE = 3'b011;
////localparam EXIT = 3'b100;

always @(posedge clk)begin
    if (rst)begin
        hour <= 0;
        t_min <= 0;
        min <= 0;
//        state <= IDLE;
    end
    else begin
                if(swh)begin            // hour 
                    if(up) begin
                        if(hour==11)begin
                            hour <= 0;
                        end
                        else
                        hour <= hour +1;
                    end
                    else if(down ) begin
                        if(hour==0) hour <= 11;
                        else hour <= hour -1;
                    end
                    else if(right )begin
//                        state <= TenMin;
                    end
//                    else if(left ) state <= IDLE;
                end
            
            if(swtm)begin
                    if(up )begin
                        if(t_min==5)t_min <= 0;
                        else t_min <= t_min +1;
                    end
                    else if(down )begin
                        if(t_min==0)t_min <= 5;
                        else t_min <= t_min -1; 
                    end
//                    else if (right ) state <= Min;
//                    else if (left ) state <= HR;
             end
            
            if(swm)begin
                    if(up )begin
                        if(min==9)min <= 0;
                        else min <= min +1;
                    end
                    else if (down )begin
                        if(min==0) min <= 9;
                        else min <= min -1;
                    end
//                    else if (right ) state <= IDLE;
//                    else if (left ) state <= TenMin;
            end
    end
end
endmodule
