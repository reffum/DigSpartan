`timescale 1ns / 1ps


module top(
    input clk,
    input rst,
    output uart_tx,
    input uart_rx,
    output [7:0] led,
    
    input [3:0] lvds_in_p,
    input [3:0] lvds_in_n,
    
    output [3:0] lvds_out_p,
    output [3:0] lvds_out_n,
    
    input lvds_clk_p,
    input lvds_clk_n
    );
    
    assign led = 8'hFF;
        
endmodule
