`timescale 1ns / 1ps
                                    //
//////////////////////////////////////
//          C O U N T E R           //
//               FOR                //
//            T I M E               //
//////////////////////////////////////                                    


module counter#(
    parameter sys_freq =100000000
    )(
    input clk, rst,
    output reg [3:0] hour, tenmin, min
    );
///////////////////////////////////////
reg [26:0]count;
localparam sec = sys_freq;
//////////////////////////////////////////////////////////
always @(posedge clk)begin
    if(rst)begin
        hour <= 0;
        tenmin <= 0;
        min <= 0;
    end
    else begin
        if(count==sec)begin                 //one second = one min
            if(min==9 && count==sec)begin               //if min = 9
                if(tenmin==5 && min==9 && count==sec)begin          //if minutes = 59
                    if(hour == 11 && tenmin==5 && min==9 && count==sec)begin         // hour change from 12 to 1
                        hour <= 0;
                        tenmin <= 0;
                        min <= 0;
                        count <= 0;
                    end
                    else begin                                                                  // hour change generic
                        tenmin <= 0;
                        min <=0;
                        hour <= hour +1;
                        count <= 0;
                    end
                end
                else begin
                    min <= 0;
                    tenmin <= tenmin +1;
                    count <= 0;
                end
            end
            else begin
                min <= min +1;
                count <= 0;
            end
        end
        else begin 
            count <= count +1;
        end
    end
/////////////////////////////////////////////////////////////////////////////////    
//    case(hour)
//        default : hour <= 0;
//    endcase
//    case(tenmin)
//        default : tenmin <= 0;
//    endcase
//    case(min)
//        default : min <= 0;
//    endcase
end        
endmodule
