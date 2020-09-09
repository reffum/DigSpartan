//
// data_read module testbench
//

`timescale 1 ns / 100 ps

module tb;
   //
   // Parameters
   //
   localparam LVDS_CLK_PERIOD = 40ns;
   localparam AXI_ACLK_PERIOD = 20ns;
   

   
   // UUT port nets
   
   // AXI-lite slave interface
   logic 	  S_AXI_ACLK = 1'b0;
   logic 	  S_AXI_ARESETN = 1'b0;
   
   logic [31:0]   S_AXI_AWADDR = 0;
   logic 	  S_AXI_AWVALID = 1'b0;
   logic 	  S_AXI_AWREADY;
   
   logic [31:0]   S_AXI_WDATA = 0;
   logic [3:0] 	  S_AXI_WSTRB = 4'd0;
   logic 	  S_AXI_WVALID = 1'b0;
   logic 	  S_AXI_WREADY;

   logic [1:0] 	  S_AXI_BRESP;
   logic 	  S_AXI_BVALID;
   logic 	  S_AXI_BREADY = 1'b0;

   logic [31:0]   S_AXI_ARADDR = 0;
   logic 	  S_AXI_ARVALID = 1'b0;
   logic 	  S_AXI_ARREADY;
   
   logic [31:0]   S_AXI_RDATA;
   logic [1:0] 	  S_AXI_RRESP;
   logic 	  S_AXI_RVALID;
   logic 	  S_AXI_RREADY = 1'b0;

   logic [3:0] 	  LVDS_IN = 4'd0;
   logic 	  LVDS_CLK = 1'b0;
   logic 	  P12_SEL1;
   logic 	  P12_SEL3;

   data_read UUT
     (
      .*
      );

   initial begin : AXI_CLK_GEN
      S_AXI_ACLK = 1'b0;
      forever #(AXI_CLK_PERIOD/2) S_AXI_ACLK = ~S_AXI_ACLK;
   end

   initial begin : LVDS_CLK_GEN
      LVDS_CLK = 1'b0;
      forever #(LVDS_CLK_PERIOD/2) LVDS_CLK = ~LVDS_CLK;
   end

   initial begin : TEST

      // Reset on AXI BUS
      S_AXI_ARESETN = 1'b0;
      repeat(20) @(posedge S_AXI_ACLK);
      S_AXI_ARESETN = 1'b1;

      #10us;
      $finish;
      
   end


   default clocking cb @(posedge S_AXI_ACLK);
      default input #1step output negedge;
      
      output S_AXI_AWADDR;
      output S_AXI_AWVALID;
      input  S_AXI_AWREADY;
      output S_AXI_WDATA;
      output S_AXI_WSTRB;
      output S_AXI_WVALID;
      input  S_AXI_WREADY;
      input  S_AXI_BRESP;
      input  S_AXI_BVALID;
      output S_AXI_BREADY;
      output S_AXI_ARADDR;
      output S_AXI_ARVALID;
      input  S_AXI_ARREADY;
      input  S_AXI_RDATA;
      input  S_AXI_RRESP;
      input  S_AXI_RVALID;
      output S_AXI_RREADY;
   endclocking // cb
   
   task WriteReg(input [32:0] address, input [32:0] data);
      cb.S_AXI_AWADDR <= address;
      cb.S_AXI_AWVALID <= 1'b1;
      cb.S_AXI_WDATA <= data;
      cb.S_AXI_WVALID <= 1'b1;
      @(cb.S_AXI_AWREADY && cb.S_AXI_WREADY);
      @(cb.S_AXI_BVALID);
      assert(cb.S_AXI_BRESP == 2'b00) else $stop;
      cb.S_AXI_AWVALID <= 1'b0;
      cb.S_AXI_WVALID <= 1'b0;
      ##1;
   endtask // WriteReg

   task ReadReg(input [31:0] address, output [31:0] data);
      cb.S_AXI_ARADDR <= address;
      cb.S_AXI_ARVALID <= 1'b1;
      @(cb.S_AXI_ARREADY);
      @(cb.S_AXI_RVALID);
      assert(cb.S_AXI_RRESP == 2'b00) else $stop;
      data = cb.S_AXI_RDATA;
      cb.S_AXI_ARVALID <= 1'b0;
   endtask // ReadReg
   
endmodule // tb
