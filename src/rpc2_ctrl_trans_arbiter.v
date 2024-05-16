module rpc2_ctrl_trans_arbiter (
   // Outputs
   ready0, ready1, arb_valid, arb_selector,
   // Inputs
   clk, rst_n, valid0, valid1, valid0_weight, valid1_weight,
   arb_ready
   );
   input         clk;
   input         rst_n;
   input         valid0;
   input         valid1;
   input [1:0]   valid0_weight;
   input [1:0]   valid1_weight;
   output        ready0;
   output        ready1;
   
   output        arb_valid;
   output        arb_selector;
   input         arb_ready;

   reg           mux_sel;
   reg [1:0]     v0_counter;
   reg [1:0]     v1_counter;
   
   wire          arb_selector;
   wire          arb_valid;
   wire [1:0]    ready_bit;
   wire          mux_in0;
   wire          mux_in1;
   /*AUTOWIRE*/
   
   assign arb_valid = valid0 | valid1;
   assign ready_bit = 1'b1 << arb_selector;
   assign {ready1, ready0} = ready_bit & {arb_ready, arb_ready};
   assign arb_selector = (mux_sel) ? mux_in1: mux_in0;

   assign mux_in0 = ~valid0;  // xx0 priority is higher than xx1 priority => select 0
   assign mux_in1 = valid1;   // xx1 priority is higher than xx0 priority => select 1
   
   always @(posedge clk or negedge rst_n) begin
      if (~rst_n)
        mux_sel <= 1'b0;
      else if (arb_valid & arb_ready) begin
         if ((valid0_weight == v0_counter) && (arb_selector == 1'b0))
           mux_sel <= 1'b1;
         else if ((valid1_weight == v1_counter) && (arb_selector == 1'b1))
           mux_sel <= 1'b0;
      end
   end

   // Count of transactions
   always @(posedge clk or negedge rst_n) begin
      if (~rst_n) begin
         v0_counter <= 2'b00;
         v1_counter <= 2'b00;
      end
      else if (arb_valid & arb_ready) begin
         if (arb_selector == 1'b0) begin
            v1_counter <= 2'b00;
            if (v0_counter >= valid0_weight)
              v0_counter <= 2'b00;
            else
              v0_counter <= v0_counter + 1'b1;
         end
         else begin
            v0_counter <= 2'b00;
            if (v1_counter >= valid1_weight)
              v1_counter <= 2'b00;
            else
              v1_counter <= v1_counter + 1'b1;
         end
      end
      else begin
         v0_counter <= v0_counter;
         v1_counter <= v1_counter;
      end
   end
   
endmodule

