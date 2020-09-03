
`timescale 1 ns / 1 ps

module data_read
   (
    // AXI-lite slave interface
    input 	  S_AXI_ACLK,
    input 	  S_AXI_ARESETN,
    
    input [31:0]  S_AXI_AWADDR,
    input 	  S_AXI_AWVALID,
    output 	  S_AXI_AWREADY,
    
    input [31:0]  S_AXI_WDATA,
    input [3:0]   S_AXI_WSTRB,
    input 	  S_AXI_WVALID,
    output 	  S_AXI_WREADY,

    output [1:0]  S_AXI_BRESP,
    output 	  S_AXI_BVALID,
    input 	  S_AXI_BREADY,

    input [31:0]  S_AXI_ARADDR,
    input 	  S_AXI_ARVALID,
    output 	  S_AXI_ARREADY,
    
    output [31:0] S_AXI_RDATA,
    output [1:0]  S_AXI_RRESP,
    output 	  S_AXI_RVALID,
    input 	  S_AXI_RREADY,

    input [3:0]   LVDS_IN,
    input 	  LVDS_CLK,
    output 	  LED0
    );

   parameter C_S_AXI_DATA_WIDTH = 32;
   parameter C_S_AXI_ADDR_WIDTH = 32;
   parameter C_S_AXI_MIN_SIZE = 32'h1FF;
   parameter C_USE_WSTRB = 0;
   parameter C_DPHASE_TIMEOUT = 8;
   parameter C_BASEADDR = 32'hFFFF_FFFF;
   parameter C_HIGHADDR = 32'h0000_0000;
   parameter C_FAMILY = "virtex6";
   parameter C_NUM_REG = 1;
   parameter C_NUM_MEM = 1;
   parameter C_SLV_AWIDTH = 32;
   parameter C_SLV_DWIDTH = 32;
   
   assign LED0 = 1'b1;

   assign S_AXI_AWREADY = 1'b0;
   assign S_AXI_WREADY = 1'b0;
   assign S_AXI_BRESP = 2'b00;
   assign S_AXI_BVALID = 1'b0;
   assign S_AXI_ARREADY = 1'b0;
   assign S_AXI_RDATA = 32'd0;
   assign S_AXI_RRESP = 2'h0;
   assign S_AXI_RVALID = 1'b0;
   

endmodule
