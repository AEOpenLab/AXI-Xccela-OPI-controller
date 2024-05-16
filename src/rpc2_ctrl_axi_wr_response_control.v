module rpc2_ctrl_axi_wr_response_control (
   // Outputs
   awid_fifo_rd_en, bdat_rd_en, bdat_data_valid, 
   // Inputs
   clk, reset_n, awid_fifo_empty, bdat_empty, bdat_data_ready
   );
   // Global System Signals
   input clk;
   input reset_n;

   // IP
//   input [1:0]                            ip_wr_error;
//   input                          ip_wr_done;

   // AWID FIFO
   input                            awid_fifo_empty;
   output                           awid_fifo_rd_en;

   // BDAT FIFO
   output                           bdat_rd_en;
//   output                         bdat_wr_en;
//   output [1:0]                   bdat_din;
   input                            bdat_empty;

   input                            bdat_data_ready;
   output                           bdat_data_valid;
   
   wire                             clk;
   wire                             reset_n;
   wire                             bdat_rd_en;
//   wire [1:0]                             bdat_din;
   wire                             bdat_empty;
   reg                              bdat_data_valid;
   
   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   // End of automatics
   
   /*AUTOREG*/
   // Beginning of automatic regs (for this module's undeclared outputs)
   // End of automatics
   assign bdat_rd_en = (~awid_fifo_empty) & (~bdat_empty) & ((~bdat_data_valid)|bdat_data_ready);
   
   assign awid_fifo_rd_en = bdat_rd_en;
   
   // data valid from BDAT and AWID FIFO
   always @(posedge clk or negedge reset_n) begin
      if (~reset_n)
        bdat_data_valid <= 1'b0;
      else if (bdat_rd_en)
        bdat_data_valid <= 1'b1;
      else if (bdat_data_ready)
        bdat_data_valid <= 1'b0;
   end

endmodule

