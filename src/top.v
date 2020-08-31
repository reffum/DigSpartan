`timescale 1ns / 1ps


module top(
    input clk,
    input rst,
    output uart_tx,
    input uart_rx,
    output [7:0] led,
    input [1:0] button,
    
    input [3:0] lvds_in_p,
    input [3:0] lvds_in_n,
    
    output [3:0] lvds_out_p,
    output [3:0] lvds_out_n,
    
    input lvds_clk_p,
    input lvds_clk_n
    );
    
    wire lvds_clk;
    wire [3:0] lvds_in;
    
    assign led = 8'hFF;
    
    IBUFGDS 
    #(
       .DIFF_TERM("TRUE"),
       .IOSTANDARD("LVDS_33")  
    ) 
    IBUFGDS_LVDS_CLK
    (
       .O(lvds_clk),
       .I(lvds_clk_p),
       .IB(lvds_clk_p)
    );
    
    // LVDS input and output
    genvar i;
    generate
        for(i = 0; i < 4; i = i + 1) begin        
            IBUFDS 
            #(
               .DIFF_TERM("TRUE"),
               .IOSTANDARD("LVDS_33")
            ) 
            IBUFDS_LVDS_IN 
            (
               .O(O),
               .I(lvds_in_p[i]),
               .IB(lvds_in_n[i])
            );
            
            OBUFDS #(
               .IOSTANDARD("LVDS_33")
            ) OBUFDS_inst (
               .O(lvds_out_p[i]),
               .OB(lvds_out_n[i]),
               .I(lvds_in[i]) 
            );            
                             
        end
    endgenerate                   
endmodule


    					
    					
