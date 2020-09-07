`include "data_read_common.hv"

module data_read_axi_write
  (
   // AXI-lite slave interface
   input 	 S_AXI_ACLK,
   input 	 S_AXI_ARESETN,
  
   input [31:0]  S_AXI_AWADDR,
   input 	 S_AXI_AWVALID,
   output 	 S_AXI_AWREADY,
  
   input [31:0]  S_AXI_WDATA,
   input [3:0] 	 S_AXI_WSTRB,
   input 	 S_AXI_WVALID,
   output 	 S_AXI_WREADY,

   output [1:0]  S_AXI_BRESP,
   output 	 S_AXI_BVALID,
   input 	 S_AXI_BREADY,

   input [31:0]  S_AXI_ARADDR,
   input 	 S_AXI_ARVALID,
   output 	 S_AXI_ARREADY,
  
   output [31:0] S_AXI_RDATA,
   output [1:0]  S_AXI_RRESP,
   output 	 S_AXI_RVALID,
   input 	 S_AXI_RREADY,

   //
   // Control signals
   //

   // CR.START
   output 	 cr_start
  
   );

   //
   // State register
   //
   localparam S0 = 2'h0;
   localparam S1 = 2'h1;
   localparam S2 = 2'h2;

   reg [1:0] 	 state_cs, state_ns;


   //
   // Data registers
   //

   // CR.START
   reg 		 cr_start_cs, cr_start_ns;
   
   
   function WriteReg(bit [31:0] addr, bit [31:0] data);
      case(addr)
	`AXI_ADDR_CR:
	  cr_start_ns <= 1'b1;
      endcase // case (addr)
   endfunction   
   
   always @(posedge S_AXI_ACLK, negedge S_AXI_ARESETN) begin : STATE_REGISTER
      if(!S_AXI_ARESETN)
	state_cs <= S0;
      else
	state_cs <= state_ns;
   end

   always begin : STATE_LOGIC
      state_ns <= state_cs;

      case(state_cs)
	S0:
	  if(S_AXI_AWVALID && S_AXI_WVALID)
	    state_ns <= S1;
	S1:
	  state_ns <= S2;
	S2:
	  if(BREADY)
	    state_ns <= S0;
      endcase // case (state_cs)
   end // block: STATE_LOGIC

   always @(posedge S_AXI_ACLK, negedge S_AXI_ARESETN) begin : DATA_REGISTERS
      cr_start_ns <= 1'b0;

      case(state_cs)
	S1:
	  WriteReg(S_AXI_AWADDR, S_AXI_WDATA);
      endcase // case (state_cs)
   end

   //
   // Outputs
   //

   assign cr_start = cr_start_cs;
   
endmodule // data_read_axi_read
