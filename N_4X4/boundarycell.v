`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/21/2024 12:44:54 PM
// Design Name: 
// Module Name: trial
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

module boundarycell #(parameter DATA_LENGTH=8)(
    input wire clk,
    input wire rst, // Uncommented reset input
    input wire [(DATA_LENGTH)-1:0] xcurrent,
    input wire start_input,
    output reg [DATA_LENGTH-1:0] cos,
    output reg [DATA_LENGTH-1:0] sine,
    output reg next,
    output  cos_ready_wire,
    output  sine_ready_wire,
    output reg output_valid
);
  reg [2*DATA_LENGTH-1:0] sum_sq;
  reg sqrt_valid;
  reg start;
  wire [DATA_LENGTH-1:0] sqrt_output;
  wire sqrt_output_valid;
  wire [2*DATA_LENGTH-1:0] cosine_wire;
  wire [2*DATA_LENGTH-1:0]  sine_wire;
  //wire output_valid_wire;
  reg [DATA_LENGTH-1:0] xprevious;

  // Instantiate the CORDIC IP core for square root calculation
cordic_0 square_root (
 // .aclk(clk),                                      
  .s_axis_cartesian_tvalid(sqrt_valid),               // input wire sqrt_valid
  .s_axis_cartesian_tdata(sum_sq[((2*(DATA_LENGTH))-2):(DATA_LENGTH-1)]),              // input wire [7 : 0] sum_sq[15:8]
  .m_axis_dout_tvalid(sqrt_output_valid),             // output wire sqrt_output_valid
  .m_axis_dout_tdata(sqrt_output)                     // output wire [7 : 0] sqrt_output
);
div_gen_0 Division1 (
  .aclk(clk),                                      // input wire aclk
                                                           
  .s_axis_divisor_tvalid(sqrt_output_valid),    // input wire s_axis_divisor_tvalid
  .s_axis_divisor_tdata(sqrt_output),      // input wire [7 : 0] s_axis_divisor_tdata
  .s_axis_dividend_tvalid(output_valid),  // input wire s_axis_dividend_tvalid
  .s_axis_dividend_tdata(xcurrent),    // input wire [7 : 0] s_axis_dividend_tdata
  .m_axis_dout_tvalid(cos_ready_wire),          // output wire m_axis_dout_tvalid
  .m_axis_dout_tdata(sine_wire)            // output wire [10 : 0] m_axis_dout_tdata
);
 
 div_gen_0 Division2(
  .aclk(clk),                                      // input wire aclk
                                                 
  .s_axis_divisor_tvalid(sqrt_output_valid),    // input wire s_axis_divisor_tvalid
  .s_axis_divisor_tdata(sqrt_output),      // input wire [7 : 0] s_axis_divisor_tdata
  .s_axis_dividend_tvalid(output_valid),  // input wire s_axis_dividend_tvalid
  .s_axis_dividend_tdata(xprevious),    // input wire [7 : 0] s_axis_dividend_tdata
  .m_axis_dout_tvalid(sine_ready_wire),          // output wire m_axis_dout_tvalid
  .m_axis_dout_tdata(cosine_wire)            // output wire [10 : 0] m_axis_dout_tdata
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        xprevious <= 0;
        start <= 0;
        sqrt_valid <= 0;
        sum_sq <= 0;
        next <= 0;
        output_valid <= 0;
    end else begin
        if (start_input) begin
            if (xcurrent == 0) begin
                xprevious <= 0;
                start <= 1;
                next <= 0;
            end else begin
                if (start) begin
                    sum_sq <= ((xcurrent * xcurrent) + (xprevious * xprevious));
                    sqrt_valid <= 1;
                    start <= 0;
                end else if (sqrt_output_valid) begin
                     cos <= cosine_wire[DATA_LENGTH-1:0];
                     sine <= sine_wire[DATA_LENGTH-1:0];
                     xprevious <= sqrt_output;  // Update xprevious with x_prime
                     output_valid <= 1;
                     start <= 1;
                     next <= 1;
                end
            end
        end else begin
            start <= 0;
            sqrt_valid <= 0;
            next <= 0;
            output_valid <= 0;
        end
    end
end


endmodule
