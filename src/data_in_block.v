`define FPGA
// data_in_block has a fifo for dq latch
module data_in_block 
  #(
   parameter MEM_LEN       = 'd9
   )
   
   
   (
   // Outputs
   dqinfifo_empty, dqinfifo_dout,dqinfifo_rd_en, rdata_count,
   // Inputs
   clk, rst_ce,reset_n, rdata_valid, data_len,read_state, dqs_clk, dq_in,rfifo_finish
   );

   input clk;
   input reset_n;
   input rst_ce;    
   input dqs_clk;
   input [7:0] dq_in;
//   input [8:0] data_len;
   input [MEM_LEN:0] data_len;   
   input read_state;
   input rdata_valid;
   output dqinfifo_rd_en;  
   output rfifo_finish; 
   output dqinfifo_empty;
   output    [15:0] dqinfifo_dout;
   output    [MEM_LEN:0] rdata_count; 
       reg         dqinfifo_wr_en;
   
   
   reg [7:0] dq_in_reg;
   wire [15:0] dqinfifo_din;
//---------------------------------------------------------//

 
 
    reg   [MEM_LEN:0] count;  
 assign rdata_count = count;
 
    // fifo write enable , use dqs_clk as enable gate
always @(posedge dqs_clk or posedge rst_ce)
begin 
    if(rst_ce || !read_state)
      begin dqinfifo_wr_en <= 0;count <= 0; end 
      else
        begin 
            if (count == (data_len + 3'b11))
                begin 
                    dqinfifo_wr_en <= 0;
                end                    
                else
                  begin
                    count <= count + 1'b1;            
                    dqinfifo_wr_en <= 1;
                  end                 
        end
end
//---------------------------------------------------------//
reg rdata_valid_r1,rdata_valid_r2;
always @(posedge clk)  //asyn -> syn
begin 
    rdata_valid_r1<= rdata_valid;
    rdata_valid_r2<= rdata_valid_r1;    
end    

    reg   [MEM_LEN:0] rd_en_cnt; 
    
always @(posedge clk or negedge reset_n) begin
    if (!reset_n)
        rd_en_cnt <= 0;
    else 
        begin
           if (rdata_valid_r2)
                rd_en_cnt <= rd_en_cnt + 1'b1; 
               else rd_en_cnt <= 0;             
        end 
end

reg rfifo_finish;
always @(posedge clk or negedge reset_n) begin
    if (!reset_n)
        rfifo_finish <= 0;
    else 
        begin
             if (rd_en_cnt > data_len)
                rfifo_finish <= 1'b1; 
                else rfifo_finish <= 0;             
        end 
end


assign dqinfifo_rd_en = ((0< rd_en_cnt)&& (rd_en_cnt < data_len+2))? 1:0;
//---------------------------------------------------------//
   assign dqinfifo_din = {dq_in_reg[7:0], dq_in[7:0]};
   
   // DQ high data
   always @(posedge dqs_clk or negedge reset_n) begin
      if (~reset_n)
        dq_in_reg <= 8'h00;
      else
        dq_in_reg <= dq_in[7:0];
   end
 wire dqinfifo_wclk = (dqinfifo_wr_en)? ~dqs_clk:clk;   // use ~dqs clk as DQ latch clk
//----------------------------------------------------------// 
//----------------------------------------------------------//
 `ifdef FPGA

   fifo_generator_1
     dqinfifo (
               // Outputs
           
               .dout           (dqinfifo_dout),   
               .empty          (dqinfifo_empty),
               .wr_rst_busy(),
               .rd_rst_busy(),
               .full(),
                              
               // Inputs
               .srst                 (!reset_n),
               .rd_clk                     (clk),
               .rd_en          (dqinfifo_rd_en),
               .wr_clk         (dqinfifo_wclk),              
               .wr_en          (dqinfifo_wr_en),
               .din            (dqinfifo_din));   

`else
   rpc2_ctrl_dqinfifo
     dqinfifo (
               // Outputs
               .dqinfifo_dout           (dqinfifo_dout),   
               .dqinfifo_empty          (dqinfifo_empty),
               // Inputs
               .reset_n                 (reset_n),
               .clk                     (clk),
               .dqinfifo_rd_en          (dqinfifo_rd_en),
               .rds_clk                 (~dqs_clk),              
               .dqinfifo_wr_en          (dqinfifo_wr_en),
               .dqinfifo_din            (dqinfifo_din[15:0]));   
`endif
endmodule 