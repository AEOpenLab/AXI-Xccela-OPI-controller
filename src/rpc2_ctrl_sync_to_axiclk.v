module rpc2_ctrl_sync_to_axiclk (
   // Outputs
   reg_rd_trans_alloc, reg_wr_trans_alloc,
   // Inputs
   AXIm_ACLK, AXIm_ARESETN, tar_reg_rta, tar_reg_wta
   );
   input             AXIm_ACLK;
   input             AXIm_ARESETN;

   input  [1:0]      tar_reg_rta;
   input  [1:0]      tar_reg_wta;

   output [1:0]      reg_rd_trans_alloc;
   output [1:0]      reg_wr_trans_alloc;

   reg [1:0]         reg_rd_trans_alloc;
   reg [1:0]         reg_rd_trans_alloc_ff1;
   reg [1:0]         reg_wr_trans_alloc;
   reg [1:0]         reg_wr_trans_alloc_ff1;
   
   always @(posedge AXIm_ACLK or negedge AXIm_ARESETN) begin
      if (~AXIm_ARESETN) begin
         reg_rd_trans_alloc     <= 2'b00;
         reg_rd_trans_alloc_ff1 <= 2'b00;
         reg_wr_trans_alloc     <= 2'b00;
         reg_wr_trans_alloc_ff1 <= 2'b00;
      end
      else begin
         reg_rd_trans_alloc     <= reg_rd_trans_alloc_ff1;
         reg_rd_trans_alloc_ff1 <= tar_reg_rta;
         reg_wr_trans_alloc     <= reg_wr_trans_alloc_ff1;
         reg_wr_trans_alloc_ff1 <= tar_reg_wta;
      end
   end
endmodule
