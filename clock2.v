`timescale 1ns / 1ps


module clock2(
    input clk,
    output [3:0] an,
    output [6:0] seg
    );
wire [11:0]time_bus;
display2 DIS
        (
    .clk(clk),
    .an(an),
    .seg(seg),
    .time_bus(time_bus)
        );
counter TIME
        (
    .clk(clk),
    .hour(time_bus[11:8]),
    .tenmin(time_bus[7:4]),
    .min(time_bus[3:0])
        );
endmodule
