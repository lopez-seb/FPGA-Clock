`timescale 1ns / 1ps

//////////////////////////////////////
//      M U X   F O R   B T N       //
//           I N P U T S            //
////////////////////////////////////// 

module mux_btn(
    input [4:0] button_bus,
    input [1:0]sel,
    output reg [4:0 ]top, alarm_set
    );
    
always @(sel)begin 
    case(sel)
        2'b01 : begin
            alarm_set <= button_bus;
        end
        default : top <= button_bus;
    endcase
end    
endmodule
