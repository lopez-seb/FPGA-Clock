`timescale 1ns / 1ps
//////////////////////////////////////
//            C L O C K             //
//        T O P   M O D U L E       //
//////////////////////////////////////

module clock#(
    parameter   sys_freq = 100000000
    )(
        input clk, btnC, btnU, btnD, btnL, btnR,
        input [15:0] sw,
        output [3:0] an,
        output [6:0] seg,
        output [15:0] led,
        output dp
    );
//reg rst, alarm_en;
reg [1:0]state; 
//wire dp_a;
//wire [2:0]alarm_state;
//////////////////////////////////////
//          B T N   B U S           //
//////////////////////////////////////   
//wire [4:0] button_bus;
//assign button_bus = {btnU, btnD, btnL, btnR, btnC};
//wire [4:0] t_btn, a_btn;
//wire up, down, left, right, center;
///////////////////////////////////////////////// RE-NAMING BUTTONS
//assign up = t_btn[4]; assign down = t_btn[3];
//assign left = t_btn[2]; assign right = t_btn[1];
//assign center = t_btn[0];
//////////////////////////////////////
wire [11:0] time_bus, display_bus, alarm_bus;
wire [4:0] btn_bus;
//////////////////////////////////////
//          M A C R O S             //
//////////////////////////////////////    
localparam min = sys_freq;
//////////////////////////////////////
//         DE BOUNCE TIMER          //
//////////////////////////////////////
//localparam MS = 100000;
//localparam timer = (100*MS);
//reg [16:0]bounce_timer;
//reg bounce_flg; 
//////////////////////////////////////
//  S T A T E   M A C H I N E       //
//////////////////////////////////////    
localparam IDLE = 2'b00; localparam SET =  2'b01;
localparam ON = 2'b10; localparam RST = 2'b11;
//////////////////////////////////////
//      S U B    M O D U L E S      //
//////////////////////////////////////
de_bounce
    DBM (
        .clk(clk),
        .up(btnU),
        .down(btnD),
        .left(btnL),
        .right(btnR),
        .center(btnC),
        .btn_out(btn_bus)
        );
display_mux
        DMX (
        .clk(clk),
        .sel(sw[15]),
        .time_bus(time_bus),
        .alarm_bus(alarm_bus),
        .display_bus(display_bus)
            );            
display DIS (
        .clk(clk),
//        .rst(rst),                 //
        .dp_in(sw[14]),               // fixed 0 for testing connection time <-> display
        .time_bus(display_bus),
        .an(an),
        .seg(seg),
        .dp(dp || sw[0])
            );
counter TIME(
        .clk(clk),
//        .rst(rst),                 //
        .hour(time_bus[11:8]),
        .tenmin(time_bus[7:4]),
        .min(time_bus[3:0])
            );
alarm ALARM_SET
            (
        .clk(clk),
        .rst(),
        .center(btn_bus[0]),
        .up(btn_bus[4]),
        .down(btn_bus[3]),
        .left(btn_bus[2]),
        .right(btn_bus[1]),
        .swh(sw[12]),
        .swtm(sw[11]),
        .swm(sw[10]),
        .hour(alarm_bus[11:8]),
        .t_min(alarm_bus[7:4]),
        .min(alarm_bus[3:0]),
        .dp(dp)
            );  
led_control ALARM
            (
            .clk(clk),
            .en(sw[0]),
            .time_in(time_bus),
            .alarm_in(alarm_bus),
            .led(led[4:0])
            );                                  

endmodule
