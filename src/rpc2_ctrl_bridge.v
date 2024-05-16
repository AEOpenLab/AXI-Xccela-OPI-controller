module rpc2_ctrl_bridge (

   // Outputs
   rpc2_rd_ready, rpc2_wr_ready,  rpc2_wr_done, 
   tx_data_ready, 
    rx_data_valid, rx_data_last, 
   rx_error, rx_stall, rx_data_addr,
   bd_instruction_req, bd_command, bd_address, bd_wdata, bd_wdata_mask, bd_data_len,
   dqinfifo_dout,


   // Inputs
   bd_wdata_ready, bd_instruction_ready, bd_rdata_valid, bd_rdata,
   clk, reset_n, rpc2_rw_valid, rpc2_rw_n,    
   rpc2_done_request, rpc2_len, rpc2_address, 
   rpc2_type, rpc2_error,  rpc2_gb_rst, rpc2_mem_init,
   rpc2_target, tx_data, tx_mask, tx_data_valid, 
   rx_data_ready 
   );
   parameter RX_ADDR_WIDTH = 1;
   parameter MEM_LEN       = 'd9;
   
   input                 clk;
   input                 reset_n;
   output  [15:0]        dqinfifo_dout;           //Bridge read data to rpc  
   // psram ctr   
   output                bd_instruction_req;      //Bridge to controller instruction require                   
   output [7:0]          bd_command;              //Bridge to controller command 
   output [31:0]         bd_address;              //Bridge to controller address 
   output [15:0]         bd_wdata;                //Bridge to controller write data 
   output [1:0]          bd_wdata_mask;           //Bridge to controller write data mask 
   output [MEM_LEN-1:0]  bd_data_len;             //Bridge to controller write/read data length 

   input                 bd_wdata_ready;          //Bridge to controller write ready
   input                 bd_instruction_ready;    //Bridge to controller ready to receive instruction 
   input                 bd_rdata_valid;          //Bridge to controller read valid 
   input  [15:0]         bd_rdata;                //Bridge to controller read data 
   
   // TRANSACTION
   input              rpc2_rw_valid;              //write/read valid 
   input              rpc2_rw_n;                  //write/read status 
   input              rpc2_done_request;          //done request    
   input [MEM_LEN-1:0] rpc2_len;                  //data length   
   input [30:0]       rpc2_address;               //address   
   input              rpc2_type;                  //memory operation type
   input [1:0]        rpc2_error;                 //address  
   input              rpc2_gb_rst;                //memory global reset
   input              rpc2_mem_init;              //memory initialize   
   input              rpc2_target;                //memory rpc2_target
   output             rpc2_rd_ready;              //memory read ready
   output             rpc2_wr_ready;              //memory write ready
   output             rpc2_wr_done;               //memory write done     
   // TX                                         
   input [15:0]       tx_data;                    //tx data
   input [1:0]        tx_mask;                    //tx data mask
   input              tx_data_valid;              //tx data valid
   output             tx_data_ready;              //tx data ready
   // RX                                         
   input              rx_data_ready;              //rx data ready
   output             rx_data_valid;              //rx data valid
   output             rx_data_last;               //rx last data
   output [1:0]       rx_error;                   //rx error
   output             rx_stall;                   //rx stall
   output [RX_ADDR_WIDTH-1:0] rx_data_addr;       //rx data address
                                                 
                                                 
                                                 
   wire                       rx_start;           //rx start   
   reg    [30:0]              rx_address;         //rx address 
   wire   [RX_ADDR_WIDTH-1:0] rx_data_addr;       //rx data address  
   reg                        rx_data_valid;      //rx data valid
   reg                        rx_stall;           //rx stall  
   reg    [15:0]     rd_dout;                     //read data out
   reg                rx_timeout;                 //rx timeout
   reg [1:0]          rx_error;                   //rx error
   reg                rw_ready;                   //read/write ready
   reg [MEM_LEN-1:0]  rxtx_data_counter;          //rx tx data counter  
   // wr                                         
   wire               wr_start;                   //write start
   reg                wr_end;                     //write end
   reg                wr_trans;                   //write transmit
   wire               pre_wr_end;                 //before write end 
   wire               tx_data_ready;              //tx data ready
   // rd                                         
   wire               rd_start;                   //read start
   wire               rd_end;                     //read end
   reg                rd_trans;                   //read transmit
   reg [1:0]          req_error;                  //request error   
   reg [30:0]         address;                    //address    
   wire               timeout;                    //timeout
   reg [9:0]          timeout_counter;            //rx timeout counter
   reg                done_request;               //done request            
   wire [7:0]         core_command;               //command



 


   //--------------------------------
   // command DECODE
   //--------------------------------    
   assign core_command = {~rpc2_rw_n, rpc2_target, ~rpc2_type, 3'b000, rpc2_gb_rst, rpc2_mem_init};

   assign bd_command = (core_command == 8'hc1) ? 8'h00 :  //INIT
                       (core_command == 8'hc2) ? 8'h80 :  //global reset 
                       (core_command == 8'hc0) ? 8'h01 :  //MRW
                       (core_command == 8'h40) ? 8'h02 :  //MRR 
                       (core_command == 8'h80) ? 8'h04 :  //array write
                       (core_command == 8'h00) ? 8'h08 :  //array read 
                                                 8'h00 ;
                   
   //--------------------------------  
   // address
   //--------------------------------     
   assign bd_address = {1'b0,rpc2_address};
   //--------------------------------  
   // Length
   //--------------------------------     
   assign bd_data_len = rpc2_len;   
   assign rpc2_rd_ready = rw_ready &   rpc2_rw_n ; 
   assign rpc2_wr_ready = rw_ready & (~rpc2_rw_n);
   assign bd_wdata = tx_data;
   assign rpc2_wr_done = wr_end & done_request;





   always @(posedge clk or negedge reset_n) begin
      if (~reset_n) begin
         address <= 31'h00000000;
         req_error <= 2'b00;        
         done_request <= 1'b0;

      end

      else if (rd_start | wr_start ) begin

         address <= rpc2_address[30:0];
         req_error <= rpc2_error[1:0];       
         done_request <= rpc2_done_request;
      end

   end

   //--------------------------------
   // RXTX
   //--------------------------------   

   // rxtx_data_counter
   always @(posedge clk or negedge reset_n) begin
      if (~reset_n)
        rxtx_data_counter <= {MEM_LEN{1'b0}};
      else if (wr_start | rd_start ) 
        rxtx_data_counter <= {MEM_LEN{1'b0}};        
      else if (  (tx_data_valid & tx_data_ready) | (rx_data_valid & rx_data_ready)  )   
        rxtx_data_counter <= rxtx_data_counter + 1'b1;
   end



   assign tx_data_ready = bd_wdata_ready;

 
   
     //--------------------------------
   // TRANSACTIONS
   //--------------------------------
   // rw_ready
   always @(posedge clk or negedge reset_n) begin
      if (~reset_n)
        rw_ready <= 1'b0;
      else
        rw_ready <= ~(rd_start || wr_start || rx_timeout || bd_instruction_ready);     
   end

   assign bd_instruction_req = rpc2_rw_valid;
   
   
   


   assign dqinfifo_dout = rd_dout;
   assign rx_data_last = ~bd_rdata_valid & rx_data_valid;



   
   // rx_data_valid
   always @(posedge clk or negedge reset_n) begin
      if (~reset_n)                begin
        rx_data_valid <= 1'b0;
        rd_dout <= 16'd0;    end
        
      else if (bd_rdata_valid)     begin
        rx_data_valid <= 1'b1;
        rd_dout <= bd_rdata; end
        
      else if (rx_data_ready & ~bd_rdata_valid)      begin
        rx_data_valid <= 1'b0;
        rd_dout <= 16'd0;    end
   end





   assign wr_start = rpc2_rw_valid & rw_ready & (~rpc2_rw_n);

   assign pre_wr_end = wr_trans & (rxtx_data_counter==(rpc2_len)  ) & tx_data_valid & tx_data_ready;

   // write end
   always @(posedge clk or negedge reset_n) begin
      if (~reset_n)
        wr_end <= 1'b0;
      else
        wr_end <= pre_wr_end;
   end

 
   
// write  
   always @(posedge clk or negedge reset_n) begin
      if (~reset_n)
        wr_trans <= 1'b0;
      else if (wr_start)
        wr_trans <= 1'b1;
      else if (wr_end)
        wr_trans <= 1'b0;
   end
   
 

assign bd_wdata_mask = tx_mask;

   



 
   
   //rd_start
   //rd_end  
   assign rd_start = rpc2_rw_valid & rw_ready & rpc2_rw_n;

   assign rd_end = rd_trans & (rxtx_data_counter == rpc2_len);
   // rd_trans =1 =>  read operation
   always @(posedge clk or negedge reset_n) begin
      if (~reset_n)
        rd_trans <= 1'b0;
      else if (rd_start)
        rd_trans <= 1'b1;
      else if (rd_end)
        rd_trans <= 1'b0;
   end
   

   // rx start   
   assign rx_start = rd_trans & rx_data_valid & (~|rxtx_data_counter);

    

   // rx read address
   always @(posedge clk or negedge reset_n) begin
      if (~reset_n)
        rx_address <= 31'h00000000;
//      else if (rx_start)
      else if (rd_start)

        rx_address <= address[30:0];
//      else if (rx_en)
      else if (rx_data_valid)      
        rx_address <= rx_address + 1'b1;
   end


   // rx data address =>  use the representation of 0 and 1 to put 16 bits in 32bit bus [15:0] or [31:16]
   assign rx_data_addr = rx_address[RX_ADDR_WIDTH-1:0]? 1'b1 : 1'b0;





   // error flag for RX
   always @(posedge clk or negedge reset_n) begin
      if (~reset_n)
        rx_error <= 2'b00;
      else if (rx_start)
        rx_error <= req_error;
   end


   // rx timeout
   always @(posedge clk or negedge reset_n) begin
      if (~reset_n)
        rx_timeout <= 1'b0;
      else if (rd_end)
        rx_timeout <= 1'b0;
//      else if (rx_en & timeout)
      else if (rx_data_valid & timeout)      
        rx_timeout <= 1'b1;
   end
   
   
   // RX is stalled
   always @(posedge clk or negedge reset_n) begin
      if (~reset_n)
        rx_stall <= 1'b0;
//      else if (rx_en)
      else if (rx_data_valid)      
        rx_stall <= rx_timeout;
   end
   

   
   //--------------------------------
   // Timeout
   //--------------------------------
     assign timeout = (  (timeout_counter[9:0]) > (rpc2_len+ 4'd20) )? 1'b1: 1'b0; //  20 clk buffer,    axi rresp
  
   // timeout counter
   always @(posedge clk or negedge reset_n) begin
      if (~reset_n)
        timeout_counter <= 10'd0;                       
//      else if (rx_start | dqinfifo_rd_en)
      else if (rx_start)
     
        timeout_counter <= 10'd0;
//      else if (rx_en & (~(&timeout_counter)))
      else if (rx_data_valid & (~(&timeout_counter)))      
        timeout_counter <= timeout_counter + 1'b1;
   end


endmodule 