module rpc2_ctrl_mem_reset_block (
   // Outputs
   reset_n, powered_up, 
   // Inputs
   clk, rsto_n, areset_n
   );
   input clk;
   input rsto_n;
   input areset_n;

   output reset_n;
   output powered_up;
   
   wire   reset_n;
   reg    reset_ff1;
   reg    reset_ff2;
   reg    rston_ff1;
   reg    rston_ff2;
   
   assign reset_n = reset_ff2;
   assign powered_up = rston_ff2;
   
   // Sync
   always @(posedge clk or negedge areset_n) begin
      if (~areset_n) begin
         reset_ff1 <= 1'b0;
         reset_ff2 <= 1'b0;
      end
      else begin
         reset_ff1 <= 1'b1;
         reset_ff2 <= reset_ff1;
      end
   end

   // Sync rst_o
   always @(posedge clk or negedge rsto_n) begin
      if (~rsto_n) begin
         rston_ff1 <= 1'b0;
         rston_ff2 <= 1'b0;
      end
      else begin
         rston_ff1 <= 1'b1;
         rston_ff2 <= rston_ff1;
      end
   end
endmodule

   
