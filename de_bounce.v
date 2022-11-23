`timescale 1ns / 1ps



module de_bounce(
    input clk,
    input up, down, left, right, center,
    output reg [4:0]btn_out
    );
reg [4:0]reg1, reg2;
reg en;
reg [25:0] count;
reg flg;
localparam ms = 50000000;
///////////////////////////////////////////////
wire [4:0]btn_in;
assign btn_in = {up, down, left, right, center};
///////////////////////////////////////////////
always @(posedge clk)begin
    if(flg!=0)begin
        if(count==0)begin
            flg <= 0;
        end
        else begin 
            count <= count -1;
            btn_out <= 0;
        end            
    end
    else if(btn_in!=0 && flg==0)begin
        count <= ms;
        flg <= 1;
        btn_out <= btn_in;
    end
end
endmodule
