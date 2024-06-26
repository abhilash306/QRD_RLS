
`timescale 1ns / 1ps

module mainmodule #(parameter DATA_LENGTH=8,r=4)(
     input clk,
     input rst,
     input [DATA_LENGTH-1:0] input_to_BC1,
     input [DATA_LENGTH-1:0] input_to_IC1,
     input [DATA_LENGTH-1:0] input_to_IC2,
     input [DATA_LENGTH-1:0] input_to_IC3,
     input [DATA_LENGTH-1:0] input_signal_sk,
     input ready_in_sig,
     output [DATA_LENGTH-1:0] error,
     output [DATA_LENGTH-1:0]wxout1,
     output [DATA_LENGTH-1:0]wxout2,
     output [DATA_LENGTH-1:0]wxout3,
     output [DATA_LENGTH-1:0]wxout4

);

                wire ready_out_sig[6*r-1:0];
                wire next_sig[r-1:0];
                wire cos_valid_sig[r-1:0];
                wire sine_valid_sig[r-1:0];
                wire [DATA_LENGTH-1:0]cos1[2*r-1:0];
                wire [DATA_LENGTH-1:0]sin1[2*r-1:0];
                wire [DATA_LENGTH-1:0]cos2[2*r-1:0];
                wire [DATA_LENGTH-1:0]sin2[2*r-1:0];
                wire [DATA_LENGTH-1:0]cos3[2*r-1:0];
                wire [DATA_LENGTH-1:0]sin3[2*r-1:0];
                wire [DATA_LENGTH-1:0]cos4[2*r-1:0];
                wire [DATA_LENGTH-1:0]sin4[2*r-1:0];
                wire [((2*DATA_LENGTH)-1):0]dataout[r+1:0];
                wire [((2*DATA_LENGTH)-1):0]u_out[r-1:0];
                wire [((2*DATA_LENGTH)-1):0]y_out[r-1:0];
                wire [((2*DATA_LENGTH)-1):0]r1_out[r-1:0];
                wire [((2*DATA_LENGTH)-1):0]r2_out[r-2:0];
                wire [((2*DATA_LENGTH)-1):0]r3_out[r-3:0];
                wire [((2*DATA_LENGTH)-1):0]r4_out;
                wire [DATA_LENGTH-1:0]delayed_data[r+1:0];
                wire [DATA_LENGTH-1:0]delayed_udata[r:0];
                wire [DATA_LENGTH-1:0] y_1;
                wire [DATA_LENGTH-1:0] input_to_IIC;
             //   wire [DATA_LENGTH-1:0]delayed_rdata[3*r-1:0];
               // wire [DATA_LENGTH-1:0]delayed_ydata[r-1:0];
                wire ready_out_end_sig[r-1:0];
                wire [((DATA_LENGTH)-1):0]ax_out[r-1:0];
                reg [4*DATA_LENGTH-1:0] err;
                assign y_1 = 8'h80;
                assign input_to_IIC = 8'h80;
    // First row: 1 boundary cell, 3 internal cells
    boundarycell BC11(
    .clk(clk),
    .rst(rst),
    .xcurrent(input_to_BC1),
    .start_input(ready_in_sig),
    .cos(cos1[0]),
    .sine(sin1[0]),
    .next(next_sig[0]),
    .cos_ready_wire(cos_valid_sig[0]),
    .sine_ready_wire(sine_valid_sig[0]),
    .output_valid(ready_out_sig[0])
    );
    delay delay12(
        .clk(clk),
        .din(input_to_IC1),
        .delayed_signal(delayed_data[0])
    );
    
    internalcell IC12(
    .clk(clk),
    .rst(rst), 
    .ready_in(sine_valid_sig[0]),
    .c_in(cos1[0]),
    .s_in(sin1[0]),
    .xin(delayed_data[0]),
    .c_out(cos1[1]),
    .s_out(sin1[1]),
    .xout(dataout[0]),
    .ready_out(ready_out_sig[1])
    );
    
       delay_3 delay13(
        .clk(clk),
        .din(input_to_IC2),
        .delayed_signal(delayed_data[1])
    );
    
    internalcell IC13(
    .clk(clk),
    .rst(rst),
    .ready_in(ready_out_sig[1]),
    .c_in(cos1[1]),
    .s_in(sin1[1]),
    .xin(delayed_data[1]),
    .c_out(cos1[2]),
    .s_out(sin1[2]),
    .xout(dataout[1]),
    .ready_out(ready_out_sig[2])
    );
    
           delay_5 delay14(
        .clk(clk),
        .din(input_to_IC3),
        .delayed_signal(delayed_data[2])
    );
        internalcell IC14(
    .clk(clk),
    .rst(rst),
    .ready_in(ready_out_sig[2]),
    .c_in(cos1[2]),
    .s_in(sin1[2]),
    .xin(delayed_data[2]),
    .c_out(cos1[3]),
    .s_out(sin1[3]),
    .xout(dataout[2]),
    .ready_out(ready_out_sig[3])
    );
    
    delay_4 delay_u14(
        .clk(clk),
        .din(input_signal_sk),
        .delayed_signal(delayed_udata[0])
    );
    
    internalcell u15(
    .clk(clk),
    .rst(rst),
    .ready_in(ready_out_sig[3]),
    .c_in(cos1[3]),
    .s_in(sin1[3]),
    .xin(delayed_udata[0]),
    .c_out(cos1[4]),
    .s_out(sin1[4]),
    .xout(u_out[0]),
    .ready_out(ready_out_sig[4])
    );
    

    internalcell y16(
    .clk(clk),
    .rst(rst),
    .ready_in(ready_out_sig[4]),
    .c_in(cos1[4]),
    .s_in(sin1[4]),
    .xin(y_1),
    .c_out(cos1[5]),
    .s_out(sin1[5]),
    .xout(y_out[0]),
    .ready_out(ready_out_sig[5])
    );
    

        inverseinternalcell r17(
    .clk(clk),
    .rst(rst),
    .ready_in(ready_out_sig[5]),
    .c_in(cos1[5]),
    .s_in(sin1[5]),
    .xin(input_to_IIC),
    .c_out(cos1[6]),
    .s_out(sin1[6]),
    .xout(r1_out[0]),
    .ready_out(ready_out_end_sig[0])
    );
       

                                    
//    Second row: 1 boundary cell, 2 internal cell
    boundarycell BC22(
    .clk(clk),
    .rst(rst),
    .xcurrent((dataout[0][2*DATA_LENGTH-1:DATA_LENGTH])),
    .start_input(ready_out_sig[1]),
    .cos(cos2[0]),
    .sine(sin2[0]),
    .next(next_sig[1]),
    .cos_ready_wire(cos_valid_sig[1]),
    .sine_ready_wire(sine_valid_sig[1]),
    .output_valid(ready_out_sig[6])
    );
    
        delay_19 d23(
        .clk(clk),
        .din((dataout[1][2*DATA_LENGTH-1:DATA_LENGTH])),
        .delayed_signal(delayed_data[3])
    );
       
    internalcell IC23(
    .clk(clk),
    .rst(rst),
    .ready_in(sine_valid_sig[1]),
    .c_in(cos2[0]),
    .s_in(sin2[0]),
    .xin(delayed_data[3]),
    .c_out(cos2[1]),
    .s_out(sin2[1]),
    .xout(dataout[3]),
    .ready_out(ready_out_sig[7])
    );
    
    
   delay_19 d24(
        .clk(clk),
        .din((dataout[2][2*DATA_LENGTH-1:DATA_LENGTH])),
        .delayed_signal(delayed_data[4])
    );
       
    internalcell IC24(
    .clk(clk),
    .rst(rst),
    .ready_in(ready_out_sig[7]),
    .c_in(cos2[1]),
    .s_in(sin2[1]),
    .xin(delayed_data[4]),
    .c_out(cos2[2]),
    .s_out(sin2[2]),
    .xout(dataout[4]),
    .ready_out(ready_out_sig[8])
    );
    
    
       delay d_u25(
        .clk(clk),
        .din(u_out[0][2*DATA_LENGTH-1:DATA_LENGTH]),
        .delayed_signal(delayed_udata[1])
    );
    
    internalcell u25(
    .clk(clk),
    .rst(rst),
    .ready_in(ready_out_sig[8]),
    .c_in(cos2[2]),
    .s_in(sin2[2]),
    .xin(delayed_udata[1]),
    .c_out(cos2[3]),
    .s_out(sin2[3]),
    .xout(u_out[1]),
    .ready_out(ready_out_sig[9])
    );
    

     internalcell y26(
    .clk(clk),
    .rst(rst),
    .ready_in(ready_out_sig[9]),
    .c_in(cos2[3]),
    .s_in(sin2[3]),
    .xin(y_out[0][((2*DATA_LENGTH)-1):DATA_LENGTH]),
    .c_out(cos2[4]),
    .s_out(sin2[4]),
    .xout(y_out[1]),
    .ready_out(ready_out_sig[10])
    );
    

        inverseinternalcell r27(
    .clk(clk),
    .rst(rst),
    .ready_in(ready_out_sig[10]),
    .c_in(cos2[4]),
    .s_in(sin2[4]),
    .xin(r1_out[0][((2*DATA_LENGTH)-1):DATA_LENGTH]),
    .c_out(cos2[5]),
    .s_out(sin2[5]),
    .xout(r1_out[1]),
    .ready_out(ready_out_sig[11])
    );
    
    
    inverseinternalcell r28(
    .clk(clk),
    .rst(rst),
    .ready_in(ready_out_sig[11]),
    .c_in(cos2[5]),
    .s_in(sin2[5]),
    .xin(input_to_IIC),
    .c_out(cos2[6]),
    .s_out(sin2[6]),
    .xout(r2_out[0]),
    .ready_out(ready_out_end_sig[1])
    );
    



    // Third row: 1 boundary cell 1 internal cell
    boundarycell BC33(
    .clk(clk),
    .rst(rst),
    .xcurrent((dataout[3][2*DATA_LENGTH-1:DATA_LENGTH])),
    .start_input(ready_out_sig[7]),
    .cos(cos3[0]),
    .sine(sin3[0]),
    .next(next_sig[2]),
    .cos_ready_wire(cos_valid_sig[2]),
    .sine_ready_wire(sine_valid_sig[2]),
    .output_valid(ready_out_sig[12])
    );
    
    
       delay_19 d34(
        .clk(clk),
        .din((dataout[4][2*DATA_LENGTH-1:DATA_LENGTH])),
        .delayed_signal(delayed_data[5])
    );
       
    internalcell IC34(
    .clk(clk),
    .rst(rst),
    .ready_in(sine_valid_sig[2]),
    .c_in(cos3[0]),
    .s_in(sin3[0]),
    .xin(delayed_data[5]),
    .c_out(cos3[1]),
    .s_out(sin3[1]),
    .xout(dataout[5]),
    .ready_out(ready_out_sig[13])
    );
    
    
    
    delay  d_u35(
        .clk(clk),
        .din(u_out[1][2*DATA_LENGTH-1:DATA_LENGTH]),
        .delayed_signal(delayed_udata[2])
    );
        
    internalcell u35(
    .clk(clk),
    .rst(rst),
    .ready_in(ready_out_sig[13]),
    .c_in(cos3[1]),
    .s_in(sin3[1]),
    .xin(delayed_udata[2]),
    .c_out(cos3[2]),
    .s_out(sin3[2]),
    .xout(u_out[2]),
    .ready_out(ready_out_sig[14])
    );
    
    internalcell y36(
    .clk(clk),
    .rst(rst),
    .ready_in(ready_out_sig[14]),
    .c_in(cos3[2]),
    .s_in(sin3[2]),
    .xin(y_out[1][2*DATA_LENGTH-1:DATA_LENGTH]),
    .c_out(cos3[3]),
    .s_out(sin3[3]),
    .xout(y_out[2]),
    .ready_out(ready_out_sig[15])
    );

    inverseinternalcell r37(
    .clk(clk),
    .rst(rst),
    .ready_in(ready_out_sig[15]),
    .c_in(cos3[3]),
    .s_in(sin3[3]),
    .xin(r1_out[1][((2*DATA_LENGTH)-1):DATA_LENGTH]),
    .c_out(cos3[4]),
    .s_out(sin3[4]),
    .xout(r1_out[2]),
    .ready_out(ready_out_sig[16])
    );

    
    inverseinternalcell r38(
    .clk(clk),
    .rst(rst),
    .ready_in(ready_out_sig[16]),
    .c_in(cos3[4]),
    .s_in(sin3[4]),
    .xin(r2_out[0][((2*DATA_LENGTH)-1):DATA_LENGTH]),
    .c_out(cos3[5]),
    .s_out(sin3[5]),
    .xout(r2_out[1]),
    .ready_out(ready_out_sig[17])
    );

    
        inverseinternalcell r39(
    .clk(clk),
    .rst(rst),
    .ready_in(ready_out_sig[17]),
    .c_in(cos3[5]),
    .s_in(sin3[5]),
    .xin(input_to_IIC),
    .c_out(cos3[6]),
    .s_out(sin3[6]),
    .xout(r3_out[0]),
    .ready_out(ready_out_end_sig[2])
    );
    
    
    // Fourth row: 1 boundary cell 1 internal cell
    boundarycell BC44(
    .clk(clk),
    .rst(rst),
    .xcurrent((dataout[5][2*DATA_LENGTH-1:DATA_LENGTH])),
    .start_input(ready_out_sig[13]),
    .cos(cos4[0]),
    .sine(sin4[0]),
    .next(next_sig[3]),
    .cos_ready_wire(cos_valid_sig[3]),
    .sine_ready_wire(sine_valid_sig[3]),
    .output_valid(ready_out_sig[18])
    );
    
    

    
    
    
    delay_19  d_u45(
        .clk(clk),
        .din(u_out[2][2*DATA_LENGTH-1:DATA_LENGTH]),
        .delayed_signal(delayed_udata[3])
    );
        
    internalcell u45(
    .clk(clk),
    .rst(rst),
    .ready_in(sine_valid_sig[3]),
    .c_in(cos4[0]),
    .s_in(sin4[0]),
    .xin(delayed_udata[3]),
    .c_out(cos4[1]),
    .s_out(sin4[1]),
    .xout(u_out[3]),
    .ready_out(ready_out_sig[19])
    );
    
    internalcell y46(
    .clk(clk),
    .rst(rst),
    .ready_in(ready_out_sig[19]),
    .c_in(cos4[1]),
    .s_in(sin4[1]),
    .xin(y_out[2][2*DATA_LENGTH-1:DATA_LENGTH]),
    .c_out(cos4[2]),
    .s_out(sin4[2]),
    .xout(y_out[3]),
    .ready_out(ready_out_sig[20])
    );

    inverseinternalcell r47(
    .clk(clk),
    .rst(rst),
    .ready_in(ready_out_sig[20]),
    .c_in(cos4[2]),
    .s_in(sin4[2]),
    .xin(r1_out[2][((2*DATA_LENGTH)-1):DATA_LENGTH]),
    .c_out(cos4[3]),
    .s_out(sin4[3]),
    .xout(r1_out[3]),
    .ready_out(ready_out_sig[21])
    );

    
    inverseinternalcell r48(
    .clk(clk),
    .rst(rst),
    .ready_in(ready_out_sig[21]),
    .c_in(cos4[3]),
    .s_in(sin4[3]),
    .xin(r2_out[1][((2*DATA_LENGTH)-1):DATA_LENGTH]),
    .c_out(cos4[4]),
    .s_out(sin4[4]),
    .xout(r2_out[2]),
    .ready_out(ready_out_sig[22])
    );

    
        inverseinternalcell r49(
    .clk(clk),
    .rst(rst),
    .ready_in(ready_out_sig[22]),
    .c_in(cos4[4]),
    .s_in(sin4[4]),
    .xin(r3_out[0][((2*DATA_LENGTH)-1):DATA_LENGTH]),
    .c_out(cos4[5]),
    .s_out(sin4[5]),
    .xout(r3_out[1]),
    .ready_out(ready_out_sig[23])
    );

    
        inverseinternalcell r50(
    .clk(clk),
    .rst(rst),
    .ready_in(ready_out_sig[23]),
    .c_in(cos4[5]),
    .s_in(sin4[5]),
    .xin(input_to_IIC),
    .c_out(cos4[6]),
    .s_out(sin4[6]),
    .xout(r4_out),
    .ready_out(ready_out_end_sig[3])
    );


weightextractioncell w57(
    .clk(clk),
    .rst(rst), 
    .ai_in(u_out[3][((2*DATA_LENGTH)-1):DATA_LENGTH]),
    .bi_in(r1_out[3][((2*DATA_LENGTH)-1):DATA_LENGTH]),
    .start_input1(ready_out_sig[19]),
    .start_input2(ready_out_sig[21]),
    .wk_out(wxout1),
    .ak_out(ax_out[0])
);
weightextractioncell w58(
    .clk(clk),
    .rst(rst), 
    .ai_in(ax_out[0]),
    .bi_in(r2_out[2][((2*DATA_LENGTH)-1):DATA_LENGTH]),
    .start_input1(ready_out_sig[22]),
    .start_input2(ready_out_sig[19]),
    .wk_out(wxout2),
    .ak_out(ax_out[1])
);
weightextractioncell w59(
    .clk(clk),
    .rst(rst), 
    .ai_in(ax_out[1]),
    .bi_in(r3_out[1][((2*DATA_LENGTH)-1):DATA_LENGTH]),
    .start_input1(ready_out_sig[23]),
    .start_input2(ready_out_sig[19]),
    .wk_out(wxout3),
    .ak_out(ax_out[2])
);

weightextractioncell w60(
    .clk(clk),
    .rst(rst), 
    .ai_in(ax_out[2]),
    .bi_in(r4_out[((2*DATA_LENGTH)-1):DATA_LENGTH]),
    .start_input1(ready_out_end_sig[3]),
    .start_input2(ready_out_sig[19]),
    .wk_out(wxout4),
    .ak_out(ax_out[3])
);


always@(posedge clk) begin
 if(rst)begin
 err<=0;
 end else if(ready_out_sig[20]) begin
 err <= u_out[3]*y_out[3];
 end
 end
 
 assign error = err[((4*DATA_LENGTH)-1):(3*DATA_LENGTH)];
 
endmodule
