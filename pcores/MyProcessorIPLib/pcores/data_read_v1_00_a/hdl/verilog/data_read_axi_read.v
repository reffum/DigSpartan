module data_read_axi_read
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

   
   
   )
