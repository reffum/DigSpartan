
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
    output 	  P12_SEL1,
    output 	  P12_SEL3
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

   // State
   localparam S0 = 0;
   localparam S1 = 1;

   reg 		  state_ns, state_cs;

   //
   // Registers
   //

   // Bit counter
   integer 	  bit_counter_cs, bit_counter_ns;

   //
   // Nets
   //

   // CR.START in AXI and data clock domain
   wire 	  cr_start, cr_start_lvds;
   
   // Write enable signale. Enable write in buffers. Data domain.
   wire 	  write_en;

   // Reset in data domain. Low level active.
   wire 	  lvds_resetn;


   //
   // Modules
   //

   data_read_axi_read data_read_axi_read_inst
     (
      .S_AXI_ACLK(S_AXI_ACLK),
      .S_AXI_ARESETN(S_AXI_ARESETN),
      .S_AXI_ARADDR(S_AXI_ARADDR),
      .S_AXI_ARVALID(S_AXI_ARVALID),
      .S_AXI_ARREADY(S_AXI_ARREADY),
      .S_AXI_RDATA(S_AXI_RDATA),
      .S_AXI_RRESP(S_AXI_RRESP),
      .S_AXI_RVALID(S_AXI_RVALID),
      .S_AXI_RREADY(S_AXI_RREADY)
      );

   data_write_axi_write data_write_axi_write_inst
     (
      .S_AXI_ACLK(S_AXI_ACLK),
      .S_AXI_ARESETN(S_AXI_ARESETN),
      .S_AXI_AWADDR(S_AXI_AWADDR),
      .S_AXI_AWVALID(S_AXI_AWVALID),
      .S_AXI_AWREADY(S_AXI_AWREADY),
      .S_AXI_WDATA(S_AXI_WDATA),
      .S_AXI_WSTRB(S_AXI_WSTRB),
      .S_AXI_WVALID(S_AXI_WVALID),
      .S_AXI_WREADY(S_AXI_WREADY),
      .S_AXI_BRESP(S_AXI_BRESP),
      .S_AXI_BVALID(S_AXI_BVALID),
      .S_AXI_BREADY(S_AXI_BREADY),

      .cr_start(cr_start)
      );
   
   data_read_buffer data_read_buffer_inst
     (
      .wr_clk(LVDS_CLK),
      
      .wr_addr(bit_counter_cs),
      .wr_data(LVDS_IN),
      .wr_en(write_en),

      .rd_addr(9'd0),
      .rd_data(),
      .rd_sel(2'd0)
      );
   

   always @(posedge LVDS_CLK, negedge lvds_resetn) begin : STATE_REGISTER
     if(~lvds_resetn)
       state_cs <= S0;
     else
       state_cs <= state_ns;
   end

   always begin : STATE_LOGIC
      state_ns <= state_cs;

      case(state_cs)
	S0:
	  if(cr_start_lvds)
	    state_ns <= S1;
	S1:
	  if(bit_counter_cs == BUFFER_SIZE-1)
	    state_ns <= S0;
      endcase // case (state_cs)
   end // block: STATE_LOGIC

   always @(posedge LVDS_CLK, negedge lvds_resetn) begin : DATA_REGISTERS
      if(~lvds_resetn)
	bit_counter_cs <= 0;
      else
	bit_counter_cs <= bit_counter_ns;
   end

   always begin : DATA_LOGIC
      bit_counter_ns <= bit_counter_cs;

      case(state_cs)
	S0:
	  bit_counter_ns <= 0;
	S1:
	  bit_counter_ns <= bit_counter_cs + 1;
      endcase // case (state_cs)
   end

   always begin : CONTROL_SIGNALS
      case(state_cs)
	S0: begin
	   write_en <= 1'b0;
	   sr_c <= 1'b1;
	end

	S1: begin
	   write_en <= 1'b1;
	   sr_c <= 1'b0;
	end
      endcase // case (state_cs)
   end // block: CONTROL_SIGNALS

   //
   // Outputs
   //
   always @(state_cs) begin : OUTPUTS
      case(state_cs)
	S0: begin
	   P12_SEL1 <= 1'b0;
	   P12_SEL3 <= 1'b0;
	end

	S1: begin
	   P12_SEL1 <= 1'b1;
	   P12_SEL3 <= 1'b1;
	end
      endcase
   end

endmodule
