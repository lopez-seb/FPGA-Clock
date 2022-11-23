`timescale 1ns / 1ps
                                    //
//////////////////////////////////////
//          D I S P L A Y           // 
//      C O N T R O L L E R         //
//////////////////////////////////////                                    

module display#(
    parameter sys_freq = 100000000,
    parameter display_time = 5
    )(
    input clk, rst,                     // do you still need a rst?
    input dp_in,
    input [11:0] time_bus,
    output reg [3:0] an,
    output reg [6:0] seg,
    output reg dp
    );
//////////////////////////////////////
//     MACROS FOR TIME INPUT        //  
//////////////////////////////////////
//reg [11:0] time_bus;                    // remove this after test
wire [3:0]hour, tenmin, min;
assign hour = time_bus[11:8];
assign tenmin = time_bus[7:4];
assign min = time_bus[3:0];
//////////////////////////////////////
reg [19:0] count;                           // counts sys clock cycles up to 5 millisecond
reg [3:0] read;                             // holds the input value for muxing output to cathode array
localparam MS = display_time*100000;        // macro value for 5 millisecond from sys clock                    
//////////////////////////////////
//        STATE MACHINE         //
//////////////////////////////////    
localparam TH = 2'b00;  localparam HR = 2'b01;
localparam TM = 2'b10;  localparam MN = 2'b11;
reg [1:0]state;
//////////////////////////////////
//      MACROS FOR ANODE OUT    //
//////////////////////////////////
localparam a3 = 4'b0111;    localparam a2 = 4'b1011;
localparam a1 = 4'b1101;    localparam a0 = 4'b1110;
//////////////////////////////////
always @(posedge clk)begin
    if(rst)begin
        count <= 0;
        read <= 0;
//        an <= 4'b1111;
//        time_bus <= 0;
        state <= TH;
    end
    else 
    begin
        case(state)
            TH : begin
                if(count==MS)begin
                    state <= HR;                        // 
                    count <= 0;
                end
                else begin
                    if (hour==0 || hour > 9)begin
                        read <= 1;
                        an <= a3;
                        count <= count +1;
                    end     
                    else begin
                        read <= 10;
                        an <= a3;
                        count <= count +1;
                    end
                 end
            end
            HR : begin
                if(count==MS)begin
                    state <= TM;                        // chnage
                    count <= 0;
                end
                else begin
                    if(hour==0)begin
                        read <= 2;
                        an <= a2;
                        count <= count +1;
                    end
                    else if(hour > 9)begin
                        read <= (hour-10);
                        an <= a2;
                        count <= count +1;
                    end
                    else begin
                        count <= count +1;
                        an <= a2;
                        read <= hour;                    // change
                    end
                end          
            end
            TM : begin
                if(count==MS)begin
                    state <= MN;                        // 
                    count <= 0;
                 end
                 else begin
                    count <= count +1;
                    an <= a1;
                    read <= tenmin;                    // change
                 end
            end
            MN : begin
                if(count==MS)begin
                    state <= TH;                        // 
                    count <= 0;
                 end
                 else begin
                    if(dp_in)dp <= 1;       // decimal place on?
                    else dp <= 0; 
                    count <= count +1;
                    an <= a0;
                    read <= min;                    // change
                 end
            end
            
        endcase
    end
end    
/////////////////////////////////////////////////////////////////////
always @(*)begin
    case(read)
            0 : seg <= 7'b1000000;
            1 : seg <= 7'b1111001;
            2 : seg <= 7'b0100100;
            3 : seg <= 7'b0110000;
            4 : seg <= 7'b0011001;
            5 : seg <= 7'b0010010;
            6 : seg <= 7'b0000010;
            7 : seg <= 7'b1111000;
            8 : seg <= 7'b0000000;
            9 : seg <= 7'b0011000;
            10: seg <= 7'b1111111;               // NULL
//            default : seg <= 7'b1000000;
        endcase
end
endmodule
