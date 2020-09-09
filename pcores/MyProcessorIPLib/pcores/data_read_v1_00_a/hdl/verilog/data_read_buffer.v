//
// Buffer for store LVDS input data
// 

module data_read_buffer
  (
   input 	     wr_clk,

   input [13:0]      wr_addr, 
   input [3:0] 	     wr_data,
   input 	     wr_en,

   input [9:0] 	     rd_addr,
   output reg [31:0] rd_data,
   input [1:0] 	     rd_sel

   );

   // One buffer size in bits
   parameter BUFFER_SIZE = 8192;

   // Buffers
   reg 		 data_buffer[BUFFER_SIZE-1:0][3:0];
   

   always @(posedge wr_clk) begin : BUFFER_WRITE
      integer i;
      
      if(wr_en)
	for(i = 0; i < 4; i=i+1)
	  data_buffer[wr_addr][i] <= wr_data[i];
   end

   always @(rd_addr, rd_sel) begin : BUFFER_READ
      integer i;

      for(i = 0; i < 32; i=i+1)
	rd_data[i] <= data_buffer[{rd_addr[8:2], i}][rd_sel];
   end
      
   
endmodule // data_read_buffer


   
