module rpc2_ctrl_sync_to_regclk (
   // Outputs
   mem_rd_active, mem_wr_active, mem_wr_rsto_status, 
   mem_wr_slv_status, mem_wr_dec_status, mem_rd_stall_status, 
   mem_rd_rsto_status, mem_rd_slv_status, mem_rd_dec_status, 
   // Inputs
   AXIr_ACLK, AXIr_ARESETN, rd_active, wr_active, wr_rsto_status, 
   wr_slv_status, wr_dec_status, rd_stall_status, rd_rsto_status, 
   rd_slv_status, rd_dec_status
   );
   input AXIr_ACLK;
   input AXIr_ARESETN;

   input rd_active;
   input wr_active;
   input wr_rsto_status;
   input wr_slv_status;
   input wr_dec_status;
   input rd_stall_status;
   input rd_rsto_status;
   input rd_slv_status;
   input rd_dec_status;
   
   output mem_rd_active;
   output mem_wr_active;
   output mem_wr_rsto_status;
   output mem_wr_slv_status;
   output mem_wr_dec_status;
   output mem_rd_stall_status;
   output mem_rd_rsto_status;
   output mem_rd_slv_status;
   output mem_rd_dec_status;
   
   reg    mem_rd_active_ff1;
   reg    mem_wr_active_ff1;
   reg    mem_wr_rsto_status_ff1;
   reg    mem_wr_slv_status_ff1;
   reg    mem_wr_dec_status_ff1;
   reg    mem_rd_stall_status_ff1;
   reg    mem_rd_rsto_status_ff1;
   reg    mem_rd_slv_status_ff1;
   reg    mem_rd_dec_status_ff1;
   
   /*AUTOREG*/
   // Beginning of automatic regs (for this module's undeclared outputs)
   reg                  mem_rd_active;
   reg                  mem_rd_dec_status;
   reg                  mem_rd_rsto_status;
   reg                  mem_rd_slv_status;
   reg                  mem_rd_stall_status;
   reg                  mem_wr_active;
   reg                  mem_wr_dec_status;
   reg                  mem_wr_rsto_status;
   reg                  mem_wr_slv_status;
   // End of automatics

   always @(posedge AXIr_ACLK or negedge AXIr_ARESETN) begin
      if (~AXIr_ARESETN) begin
         mem_rd_active_ff1 <= 1'b0;
         mem_rd_active     <= 1'b0;
         mem_wr_active_ff1 <= 1'b0;
         mem_wr_active     <= 1'b0;
         mem_wr_rsto_status     <= 1'b0;
         mem_wr_rsto_status_ff1 <= 1'b0;
         mem_wr_slv_status      <= 1'b0;
         mem_wr_slv_status_ff1  <= 1'b0;
         mem_wr_dec_status      <= 1'b0;
         mem_wr_dec_status_ff1  <= 1'b0;
         mem_rd_stall_status    <= 1'b0;
         mem_rd_stall_status_ff1<= 1'b0;
         mem_rd_rsto_status     <= 1'b0;
         mem_rd_rsto_status_ff1 <= 1'b0;
         mem_rd_slv_status      <= 1'b0;
         mem_rd_slv_status_ff1  <= 1'b0;
         mem_rd_dec_status      <= 1'b0;
         mem_rd_dec_status_ff1  <= 1'b0;
      end
      else begin
         mem_rd_active_ff1 <= rd_active;
         mem_rd_active     <= mem_rd_active_ff1;
         mem_wr_active_ff1 <= wr_active;
         mem_wr_active     <= mem_wr_active_ff1;
         mem_wr_rsto_status_ff1 <= wr_rsto_status;
         mem_wr_rsto_status     <= mem_wr_rsto_status_ff1;
         mem_wr_slv_status_ff1  <= wr_slv_status;
         mem_wr_slv_status      <= mem_wr_slv_status_ff1;
         mem_wr_dec_status_ff1  <= wr_dec_status;
         mem_wr_dec_status      <= mem_wr_dec_status_ff1;
         mem_rd_stall_status_ff1<= rd_stall_status;
         mem_rd_stall_status    <= mem_rd_stall_status_ff1;
         mem_rd_rsto_status_ff1 <= rd_rsto_status;
         mem_rd_rsto_status     <= mem_rd_rsto_status_ff1;
         mem_rd_slv_status_ff1  <= rd_slv_status;
         mem_rd_slv_status      <= mem_rd_slv_status_ff1;
         mem_rd_dec_status_ff1  <= rd_dec_status;
         mem_rd_dec_status      <= mem_rd_dec_status_ff1;
      end
   end
         
endmodule
   
