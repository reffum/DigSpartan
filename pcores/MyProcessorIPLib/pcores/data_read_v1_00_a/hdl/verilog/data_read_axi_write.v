`include "data_read_common.hv"

module data_read_axi_write
  (
   // AXI-lite slave interface
   input 	    S_AXI_ACLK,
   input 	    S_AXI_ARESETN,
  
   input [31:0]     S_AXI_AWADDR,
   input 	    S_AXI_AWVALID,
   output reg 	    S_AXI_AWREADY,
  
   input [31:0]     S_AXI_WDATA,
   input [3:0] 	    S_AXI_WSTRB,
   input 	    S_AXI_WVALID,
   output reg 	    S_AXI_WREADY,

   output reg [1:0] S_AXI_BRESP,
   output reg	    S_AXI_BVALID,
   input 	    S_AXI_BREADY,

   //
   // Control signals
   //

   // CR.START
   output 	    cr_start
  
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
   
   
   task WriteReg(input [31:0] addr, input [31:0] data);
      case(addr)
	`AXI_ADDR_CR:
	  cr_start_ns <= 1'b1;
      endcase // case (addr)
   endtask
   
   always @(posedge S_AXI_ACLK, negedge S_AXI_ARESETN) begin : STATE_REGISTER
      if(!S_AXI_ARESETN)
	state_cs <= S0;
      else
	state_cs <= state_ns;
   end

   always @(state_cs, S_AXI_AWVALID, S_AXI_WVALID, S_AXI_BREADY) begin : STATE_LOGIC
      state_ns <= state_cs;

      case(state_cs)
	S0:
	  if(S_AXI_AWVALID && S_AXI_WVALID)
	    state_ns <= S1;
	S1:
	  state_ns <= S2;
	S2:
	  if(S_AXI_BREADY)
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

   always @(state_cs) begin : CONTROL_AXI_LOGIC
      S_AXI_AWREADY <= 1'b0;
      S_AXI_WREADY <= 1'b0;
      S_AXI_BRESP <= 2'b00;
      S_AXI_BVALID <= 1'b0;

      case(state_cs)
	S1: begin
	   S_AXI_AWREADY <= 1'b1;
	   S_AXI_WREADY <= 1'b1;
	end

	S2: begin
	   S_AXI_BRESP <= 2'b00;
	   S_AXI_BVALID <= 1'b1;
	end
      endcase // case (state_cs)
   end // block: CONTROL_AXI_LOGIC
   
   //
   // Outputs
   //

   assign cr_start = cr_start_cs;
   
endmodule // data_read_axi_read
