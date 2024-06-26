`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/23/2024 01:02:26 PM
// Design Name: 
// Module Name: internalcell
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


module internalcell #(parameter DATA_LENGTH=8)(
    input clk,           // Clock signal
    input rst,
//    input [(DATA_LENGTH/2)-1:0]lambda_sqrt,
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

    // Temporary variables for intermediate calculations
    


    // Update x, xout, c_out, and s_out on the rising edge of the clock
    always @(posedge clk) begin
     if (rst) begin
      x_previous <= 0;
      end
      else if (ready_in) begin
           
            xout <= ((c_in * xin) - ((s_in) * (x_previous[2*DATA_LENGTH-1:DATA_LENGTH])));
            x_previous <= ((s_in * xin) + ((c_in) * (x_previous[2*DATA_LENGTH-1:DATA_LENGTH])));
            c_out <= c_in;
            s_out <= s_in;
            ready_out <= 1;
        end
        else begin
            // Define behavior for when ready_in is low, if necessary
            ready_out <= 0;
        end
        
    end
endmodule
