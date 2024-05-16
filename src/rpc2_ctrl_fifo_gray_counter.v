module rpc2_ctrl_fifo_gray_counter (
   // Outputs
   cnt, gray_cnt, next_gray_cnt, 
   // Inputs
   clk, rst_n, en
   );
   parameter WIDTH = 'd9;

   input clk;
   input rst_n;
//   input clr;
   input en;

   output [WIDTH-2:0] cnt;
   output [WIDTH-1:0] gray_cnt;
   output [WIDTH-1:0] next_gray_cnt;
   
   wire [WIDTH-1:0] next_cnt;
   wire [WIDTH-2:0] rshift_next_cnt;
   wire [WIDTH-1:0] next_gray_cnt;
   /*AUTOREG*/
   // Beginning of automatic regs (for this module's undeclared outputs)
   reg [WIDTH-1:0]      gray_cnt;
   // End of automatics
   reg [WIDTH-1:0] bin_cnt;

   assign cnt = bin_cnt[WIDTH-2:0];
   assign next_cnt = bin_cnt + en;
   assign rshift_next_cnt = (next_cnt>>1);
   assign next_gray_cnt = next_cnt ^ {1'b0, rshift_next_cnt};
         
   always @(posedge clk or negedge rst_n) begin
      if (~rst_n) begin
         bin_cnt <= {WIDTH{1'b0}};
         gray_cnt <= {WIDTH{1'b0}};
      end
//      else if (clr) begin
//       bin_cnt <= {WIDTH{1'b0}};
//       gray_cnt <= {WIDTH{1'b0}};
//      end
      else begin
         bin_cnt <= next_cnt[WIDTH-1:0];
         gray_cnt <= next_gray_cnt[WIDTH-1:0];
      end
   end
endmodule
