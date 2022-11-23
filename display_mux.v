`timescale 1ns / 1ps



module display_mux(
    input clk,
    input sel,
    input [11:0] time_bus, alarm_bus,
    output reg [11:0] display_bus
    );
    
always @(posedge clk)begin
    if(sel)begin
         display_bus = alarm_bus;    
    end
    else display_bus <= time_bus;
end       
endmodule
