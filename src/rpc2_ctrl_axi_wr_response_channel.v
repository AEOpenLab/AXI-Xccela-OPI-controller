module rpc2_ctrl_axi_wr_response_channel (
   // Outputs
   AXI_BID, AXI_BRESP, AXI_BVALID, awid_fifo_rd_en, bdat_rd_en, 
   // Inputs
   clk, reset_n, AXI_BREADY, awid_id, awid_fifo_empty, bdat_dout, 
   bdat_empty
   );
   parameter C_AXI_ID_WIDTH   = 'd4;
   
   // Global System Signals
   input clk;
   input reset_n;

   // Write Response Channel Signals
   output [C_AXI_ID_WIDTH-1:0]      AXI_BID;
   output [1:0]                     AXI_BRESP;
   output                           AXI_BVALID;
   input                            AXI_BREADY;

//   input [1:0]                            ip_wr_error;
//   input                          ip_wr_done;

   input [C_AXI_ID_WIDTH-1:0]       awid_id;
   input                            awid_fifo_empty;
   output                           awid_fifo_rd_en;

   // BDAT FIFO
   output                           bdat_rd_en;
   input [1:0]                      bdat_dout;
   input                            bdat_empty;
//   output [1:0]                   bdat_din;
//   output                         bdat_wr_en;
   
   wire                             resp_en;
   wire                             bdat_data_ready;

//   wire                           bdat_wr_en;
//   wire [1:0]                             bdat_din;

   /*AUTOWIRE*/
   // Beginning of automatic wires (for undeclared instantiated-module outputs)
   wire                 bdat_data_valid;        // From axi_wr_response_control of rpc2_ctrl_axi_wr_response_control.v
   // End of automatics
   
   /*AUTOREG*/
   // Beginning of automatic regs (for this module's undeclared outputs)
   reg [C_AXI_ID_WIDTH-1:0]AXI_BID;
   reg [1:0]            AXI_BRESP;
   reg                  AXI_BVALID;
   // End of automatics

   assign bdat_data_ready = ((~AXI_BVALID)|AXI_BREADY);
//   assign bdat_wr_en = ip_wr_done;
//   assign bdat_din = ip_wr_error;
   
   rpc2_ctrl_axi_wr_response_control
     axi_wr_response_control (/*AUTOINST*/
                              // Outputs
                              .awid_fifo_rd_en(awid_fifo_rd_en),
                              .bdat_rd_en(bdat_rd_en),
                              .bdat_data_valid(bdat_data_valid),
                              // Inputs
                              .clk      (clk),
                              .reset_n  (reset_n),
                              .awid_fifo_empty(awid_fifo_empty),
                              .bdat_empty(bdat_empty),
                              .bdat_data_ready(bdat_data_ready));
      
   //------------------------------------------------------
   // AXI
   //------------------------------------------------------
   assign resp_en = bdat_data_ready & bdat_data_valid;

   // AXI_BVALID
   always @(posedge clk or negedge reset_n) begin
      if (~reset_n)
        AXI_BVALID <= 1'b0;
      else if (resp_en)
        AXI_BVALID <= 1'b1;
      else if (AXI_BREADY)
        AXI_BVALID <= 1'b0;
   end

   // AXI_BID
   always @(posedge clk or negedge reset_n) begin
      if (~reset_n)
        AXI_BID <= {C_AXI_ID_WIDTH{1'b0}};
      else if (resp_en)
        AXI_BID <= awid_id;
   end

   // AXI_BRESP
   always @(posedge clk or negedge reset_n) begin
      if (~reset_n)
        AXI_BRESP <= 2'b00;
      else if (resp_en)
        AXI_BRESP <= bdat_dout;
   end
   
endmodule
