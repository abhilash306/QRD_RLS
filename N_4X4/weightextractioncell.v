`timescale 1ns / 1ps
module weightextractioncell  #(parameter DATA_LENGTH=8)(
    input  clk,
    input  rst,
    input  [(DATA_LENGTH)-1:0] ai_in,
    input  [(DATA_LENGTH)-1:0] bi_in,
    input  start_input1,
    input  start_input2,
    output  [DATA_LENGTH-1:0] wk_out,
    output reg [DATA_LENGTH-1:0] ak_out
);
//reg [DATA_LENGTH-1:0] wk_prev;
reg [DATA_LENGTH-1:0]weight;
always@(posedge clk) begin
 if(rst) begin
  weight <= 0;
 end
 else if(start_input1 && start_input2) begin
    // multi<=((ai_in)*(bi_in));
     weight<= (weight) - ((ai_in[(DATA_LENGTH/2)-1:0])*(bi_in[(DATA_LENGTH/2)-1:0]));
   //  wk_prev <= wk_out;
     ak_out <= ai_in;
 end
end
assign wk_out = weight;
endmodule