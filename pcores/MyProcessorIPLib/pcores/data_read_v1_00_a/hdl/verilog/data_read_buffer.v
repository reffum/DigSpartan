//
// Buffer for store LVDS input data
// 

module data_read_buffer
  (
   input 	 wr_clk,

   input [11:0]  wr_addr, 
   input 	 wr_data[3:0],
   input 	 wr_en,

   input [8:0] 	 rd_addr,
   output [31:0] rd_data,
   input [1:0] 	 rd_sel,

   );

   // One buffer size in bits
   localparam BUFFER_SIZE = 8192;

   // Buffers
   reg [BUFFER_SIZE-1:0] data_buffer[3:0];

   always @(posedge wr_clk) begin
      int i;
      
      if(wr_en)
	for(i = 0; i < 4; i++)
	  data_buffer[wr_addr][i] <= wr_data[i];
   end

   always
     rd_data <= data_buffer[rd_addr*8 + 7 : rd_addr*8][rd_sel];
      
      
   
endmodule // data_read_buffer


   
