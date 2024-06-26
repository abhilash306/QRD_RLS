`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/16/2024 05:51:54 PM
// Design Name: 
// Module Name: supermodule
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module supermodule #(parameter DATA_LENGTH=8)(
    input clk,
    input rst,
    input [DATA_LENGTH-1:0] input_to_BC1,
    input [DATA_LENGTH-1:0] input_to_IC1,
    input [DATA_LENGTH-1:0] input_to_IC2,
    input [DATA_LENGTH-1:0] input_to_IC3,
    input [DATA_LENGTH-1:0] input_signal_sk,
    input ready_in_sig,
    output [DATA_LENGTH-1:0] error,
    output [DATA_LENGTH-1:0] wxout1,
    output [DATA_LENGTH-1:0] wxout2,
    output [DATA_LENGTH-1:0] wxout3,
    output [DATA_LENGTH-1:0] wxout4
    );

     reg [DATA_LENGTH-1:0] temp1;
     reg [DATA_LENGTH-1:0] temp11;
     reg [DATA_LENGTH-1:0] temp22;
     reg [DATA_LENGTH-1:0] temp111;
     reg [DATA_LENGTH-1:0] temp222;
     reg [DATA_LENGTH-1:0] temp333;
     reg [DATA_LENGTH-1:0] input_BC1;
     reg [DATA_LENGTH-1:0] input_IC1;
     reg [DATA_LENGTH-1:0] input_IC2;
     reg [DATA_LENGTH-1:0] input_IC3;
     reg [DATA_LENGTH-1:0]  input_sig_sk;
    always@(posedge clk) begin
        if(rst)
        begin
             input_BC1<=0;
             input_IC1<=0;
             input_IC2<=0;
             input_IC3<=0;
             input_sig_sk<=0;
             temp1<=0;
             temp11<=0;
             temp22<=0;
             temp111<=0;
             temp222<=0;
             temp333<=0;
        end
        else
        begin
            input_BC1 <= input_to_BC1;
            temp1<=input_to_IC1;
            input_IC1<= temp1;
            temp11<=input_to_IC2;
            temp22<=temp11;
            input_IC2<= temp22;
            temp111<=input_to_IC3;
            temp222<=temp111;
            temp333<=temp222;
            input_IC3<= temp333;
            input_sig_sk<=input_signal_sk;
        end
    end
            
 mainmodule mod1(
        .clk(clk),
        .rst(rst),
        .input_to_BC1(input_BC1),
        .input_to_IC1(input_IC1),
        .input_to_IC2(input_IC2),
        .input_to_IC3(input_IC3),
        .input_signal_sk(input_sig_sk),
        .ready_in_sig(ready_in_sig),
        .error(error),
        .wxout1(wxout1),
        .wxout2(wxout2),
        .wxout3(wxout3),
        .wxout4(wxout4)
    );
         
   
    
endmodule
