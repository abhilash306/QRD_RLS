`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/05/2024 04:14:05 PM
// Design Name: 
// Module Name: inverseinternalcell
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


module inverseinternalcell #(parameter DATA_LENGTH=8)(
    input clk,           // Clock signal
    input rst,
    input ready_in,
    input [DATA_LENGTH-1:0] c_in,   // Cosine value input (from left cell)
    input [DATA_LENGTH-1:0] s_in,   // Sine value input (from left cell)
    input [DATA_LENGTH-1:0] xin,    // xin ainput (from upper cell)
    output reg [DATA_LENGTH-1:0] c_out, // Cosine value output (to right cell)
    output reg [DATA_LENGTH-1:0] s_out, // Sine value output (to right cell)
    output reg [2*DATA_LENGTH-1:0] xout,  // xout output (to lower cell)
    output reg ready_out
);

    reg [2*DATA_LENGTH-1:0] x_previous; // Initialize x to zero or a suitable initial value
    always @(posedge clk) begin
     if (rst) begin
      x_previous <=16'hffff ;
      end
      else if (ready_in) begin
        if(c_in > 0 && s_in >0) begin
            xout <= ((c_in * xin) - ((s_in) * (x_previous[2*DATA_LENGTH-1:DATA_LENGTH])));
            x_previous <= ((s_in * xin) + ((c_in) * (x_previous[2*DATA_LENGTH-1:DATA_LENGTH])));
            c_out <= c_in;
            s_out <= s_in;
            ready_out <= 1;
         end
        end
        else begin
            ready_out <= 0;
        end
        
    end
endmodule
