`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/01/07 23:35:26
// Design Name: 
// Module Name: sim
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


module sim();
    reg clk;
    wire [7:0]result;
    reg rst;
    wire sch_error;
    wire tc_error;
    reg tick_en;

    design_1_wrapper design_1_wrapper(
        .clk(clk),
        .result(result),
        .rst(rst),
        .sch_error(sch_error),
        .tc_error(tc_error),
        .tick_en(tick_en)
    );

    always begin
        clk <= ~clk;
        #10;
    end

    initial begin
        clk <= 0;
        rst <= 1;
        tick_en <= 0;
        #200;
        rst <= 0;
        tick_en <= 1;
    end
   
endmodule
