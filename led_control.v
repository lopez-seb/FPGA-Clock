`timescale 1ns / 1ps



module led_control(
    input clk, en,
    input[11:0] time_in, alarm_in,
    output reg [4:0] led
    );
//reg [3:0]flash_count; 
//reg [16:0] time_count;   
always @(posedge clk)begin
    if(time_in==alarm_in && en)begin
        led <= 5'b11111;
    end    
    else led <= 0;
end
endmodule
