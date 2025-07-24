`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/23/2025 09:30:57 PM
// Design Name: 
// Module Name: conv
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Assumptions: The module instantiates line buffers and multiplexers (designed in the previous tutorial).
// Outputs from the multiplexers are available as inputs to this module.
//Data is read from the line buffer, with three pixels read at a time from each line buffer.
//Each line buffer provides 24 bits of data. Three line buffers provide the necessary pixel data.
//////////////////////////////////////////////////////////////////////////////////


module conv(
input           i_clk,
input [71:0]    i_pixel_data, // 72 bits representing 9 pixels (9*8 = 72)
input           i_pixel_data_valid, 
output [7:0]    o_convoled_data, // output pixel after convultion (blurred Value)
output          o_convoled_data_valid,

    );
    
integer i; 
    reg [7:0] kernel [8:0]; // 3x3 kernel 
    reg [15:0] multData[8:0]; // result of pixel * kernel value
    reg [15:0] sumDataInt;
    reg [15:0] sumData;
    reg multDataValid;
    reg sumDataValid;
    reg convolved_data_valid;
    
    initial
    begin
        for(i=0;i<9;i=i+1)
        begin
            kernel[i] = 1;
        end
    end    
        
    always @(posedge i_clk)
    begin
        for(i=0;i<9;i=i+1)
        begin
            multData[i] <= kernel[i]*i_pixel_data[i*8+:8];
        end
        multDataValid <= i_pixel_data_valid;
    end
// above it multiplies each of the 9 inputs pixel by current kernel value
always @(*)
    begin
        sumDataInt = 0;
        for(i=0;i<9;i=i+1)
        begin
            sumDataInt = sumDataInt + multData[i];
        end
    end
    // Above it adds all 9 multiplied values 
    always @(posedge i_clk)
    begin
        sumData <= sumDataInt;
        sumDataValid <= multDataValid;
    end
   //above the result of the sum synchronizes with pipeline     
    always @(posedge i_clk)
    begin
        o_convolved_data <= sumData/9;
        o_convolved_data_valid <= sumDataValid;
    end
    // Sum / 9 
    // Output is valid is sumDataValid is high    
    endmodule