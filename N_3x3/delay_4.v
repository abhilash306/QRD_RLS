`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/09/2024 01:02:06 AM
// Design Name: 
// Module Name: delay_4
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


module delay_4  #(parameter P=21,DATA_LENGTH=8)(
    input clk,
    input [DATA_LENGTH-1:0] din,
    output [DATA_LENGTH-1:0] delayed_signal
    );
    
    reg [DATA_LENGTH-1:0] Q [0:P];
    
    genvar i;
    generate for (i=0 ; i < P ; i = i + 1)
    begin
        
        always @(posedge clk)
        begin
            Q[0] <= din;
            Q[i+1] <= Q[i];
        end 
    end
    endgenerate
    
    assign delayed_signal = Q[P];
    
endmodule
