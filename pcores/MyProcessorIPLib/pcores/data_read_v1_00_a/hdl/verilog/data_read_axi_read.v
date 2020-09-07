module data_read_axi_read
  (
   // AXI-lite slave interface
   input 	 S_AXI_ACLK,
   input 	 S_AXI_ARESETN,
  
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

   // SR.C
   input 	 sr_c,

   // Buffer read
   output [9:0]  buf_addr,
   output [1:0]  buf_sel,
   input [31:0]  buf_data
   );
   
   //
   // State register
   //
   localparam S0 = 2'd0;
   localparam S1 = 2'd1;
   localparam S2 = 2'd2;

   reg [1:0] 	 state_cs, state_ns;

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
	  if(ARVALID)
	    state_ns <= S1;
	S1:
	  state_ns <= S2;
	S2:
	  state_ns <= S0;
      endcase // case (state_cs)
   end // block: STATE_LOGIC

   function [31:0] ReadData(bit [31:0] addr);
      case(addr)
	`AXI_ADDR_CR:
	  return 0;
	`AXI_ADDR_SR:
	  return sr_c;
	default:
	  return buf_data;
      endcase // case (addr)
   endfunction // ReadData
   
   
   always begin : AXI_SIGNALS_LOGIC
      S_AXI_ARREADY <= 1'b0;
      S_AXI_RVALID <= 1'b0;
      S_AXI_RDATA <= 32'd0;
      S_AXI_RRESP <= 2'b00;

      case(state_cs)
	S1:
	  S_AXI_ARREADY <= 1'b1;
	
	S2: begin
	   S_AXI_RVALID <= 1'b1;
	   S_AXI_RDATA <= ReadData(S_AXI_ARADDR);
	end
      endcase // case (state_cs)
   end // block: AXI_SIGNALS_LOGIC


   //
   // Outputs
   //
   
   assign buf_addr = S_AXI_ARADDR[9:0];

   always begin
      case(S_AXI_ARADDR[12:10])
	3'b001:
	  buf_sel <= 2'b00;
	3'b010:
	  buf_sel <= 2'b01;
	3'b011:
	  buf_sel <= 2'b10;
	3'b100:
	  buf_sel <= 2'b11;
      endcase // case (S_AXI_ARADDR[12:10])
   end // always
   
endmodule // data_read_axi_read
