//`timescale 1ns/10ps
`timescale 1ps/1ps


module testbench_top;


//Slave AXI clock
`define AXI_clock_200M

`ifdef AXI_clock_250M
	parameter AXI_CLK_PERIOD = 4000;
	parameter AXI_CLOCK_MHZ	= 250;
`else
`ifdef AXI_clock_200M
	parameter AXI_CLK_PERIOD = 5000;
	parameter AXI_CLOCK_MHZ	= 200;

`else
	parameter AXI_CLK_PERIOD = 4000;
	parameter AXI_CLOCK_MHZ	= 250;
`endif
`endif   




//clock define for RAM_Controller AND PSRAM
`define tCLK5000  // Note :psram verilog module "most" define same word

`ifdef tCLK5000 //0.5ns @200M
   parameter   integer INIT_CLOCK_HZ = 200_000000; // controller mode
   parameter RAM_CLK_PERIOD = 5000;                // PLL clock for RAM_Controller AND PSRAM
`else
`ifdef tCLK6000 //0.6ns @166M
   parameter   integer INIT_CLOCK_HZ = 166_000000; // controller mode
   parameter RAM_CLK_PERIOD = 6000;                // PLL clock for RAM_Controller AND PSRAM

`else
`ifdef tCLK7500 //0.75ns @133M
   parameter   integer INIT_CLOCK_HZ = 133_000000; // controller mode
   parameter RAM_CLK_PERIOD = 7500;                // PLL clock for RAM_Controller AND PSRAM
`else
   parameter   integer INIT_CLOCK_HZ = 200_000000; // controller mode
   parameter RAM_CLK_PERIOD = 5000;                // PLL clock for RAM_Controller AND PSRAM
`endif
`endif
`endif
  
   
   parameter   INIT_DRIVE_STRENGTH = 50;
   parameter C_AXI_ID_WIDTH = 4;
   parameter C_AXI_REG_BASEADDR = 0;

 





   //------------------------------------------------------------------------
   // for psram controller
   //------------------------------------------------------------------------
   wire           xl_ck;
   wire           xl_ce;
   wire           xl_dqs;   
   wire  [7:0]    xl_dq;
   

   //------------------------------------------------------------------------
   // for Control Register
   //------------------------------------------------------------------------
   // Master write address channel
   reg [C_AXI_ID_WIDTH-1:0] awid;
   reg [31:0] awaddr;
   reg [7:0]  awlen;
   reg [2:0]  awsize;
   reg [1:0]  awburst; 
   reg        awvalid;
   wire       awready;
   // Master write data channel
   reg [31:0] wdata;
   reg [3:0]  wstrb;
   reg        wvalid;
   wire       wready;
   reg        wlast;
   // Master write response channel
   wire  [C_AXI_ID_WIDTH-1:0]  bid;
   wire [1:0]  bresp;
   wire        bvalid;
   reg        bready;
   // Master read address channel
   reg [C_AXI_ID_WIDTH-1:0]  arid;
   reg [31:0]  araddr;
   reg [7:0]   arlen;
   reg [2:0]   arsize;
   reg [1:0]   arburst; 
   reg         arvalid;
   wire        arready;
   // Master read data channel
   wire [C_AXI_ID_WIDTH-1:0]  rid;
   wire [31:0]  rdata;
   wire [1:0]   rresp;
   wire         rlast;
   wire         rvalid;
   reg          rready;
   
   //------------------------------------------------------------------------
   // for Memory
   //------------------------------------------------------------------------
   // Master write address channel
   reg [C_AXI_ID_WIDTH-1:0]    awid_m;  
   reg [31:0]  awaddr_m; 
   reg [7:0]   awlen_m;
   reg [2:0]   awsize_m;
   reg [1:0]   awburst_m;
   reg         awvalid_m;
   wire        awready_m;
   // Master write data channel
   reg [31:0]  wdata_m;
   reg [3:0]   wstrb_m;
   reg         wvalid_m;
   wire        wready_m;
   reg         wlast_m;



   // Master write response channel
   wire  [C_AXI_ID_WIDTH-1:0]    bid_m;
   wire [1:0]   bresp_m;
   wire         bvalid_m;
   reg         bready_m;
   // Master read address channel
   reg [C_AXI_ID_WIDTH-1:0]     arid_m;
   reg [31:0]   araddr_m;
   reg [7:0]    arlen_m;
   reg [2:0]    arsize_m;
   reg [1:0]    arburst_m;
   reg          arvalid_m;
   wire         arready_m;
   // Master read data channel
   wire [C_AXI_ID_WIDTH-1:0]    rid_m;
   wire [31:0]  rdata_m;
   wire [1:0]   rresp_m;
   wire         rvalid_m;
   wire         rlast_m;
   reg          rready_m;
   // Trinity memory interface
   wire         rpc_reset_n;
   wire         rpc_rwds;
   wire         rpc_int_n;
   wire         rpc_rsto_n;
   wire         rpc_ck; 
   wire         rpc_ck_n;
   wire         rpc_ck2;
   wire         rpc_ck2_n;
   wire         rpc_cs0_n;
   wire         rpc_cs1_n;
   wire         rpc_wp_n;
   wire [7:0]   rpc_dq;

   //wire [1:0]   GPO;
   //wire         IENOn;
   
   pullup (rpc_int_n);
   pullup (rpc_rsto_n);

//   wire ref_clk = 1'b0;
   
   reg clk;
   reg clk_m;
   reg sys_clk;
   
   reg reset;
   reg reset_m;

   reg [255:0] testbench_inst;
   reg [10:0] write_data_cnt;
   reg [10:0] read_data_cnt;
   reg [31:0] MEN_data_rdata; 
   
   // Clock generator
   always #(AXI_CLK_PERIOD/2) clk = ~clk;
   always #(AXI_CLK_PERIOD/2) clk_m = ~clk_m;
   
//   always #(RAM_CLK_PERIOD/2) sys_clk = ~sys_clk;
   always #(RAM_CLK_PERIOD/2) sys_clk = ~sys_clk;


/******************************************************************************/
/*                          AXI's register write                              */
/******************************************************************************/
    task AXI_reg_write
    (
//	  input       [3:0]   AXI_reg_awid, //axi4 no wid
	  input       [31:0]  AXI_reg_awaddr,
	  input       [7:0]   AXI_reg_awlen,
	  input       [2:0]   AXI_reg_awsize,
	  input               AXI_reg_awburst,
	  input       [31:0]  AXI_reg_wdata,
	  input       [3:0]   AXI_reg_wstrb      
    );  
    begin
      testbench_inst = "AXI_reg_write"; 
      
    @(posedge clk)
         
         awid    = 0;  //axi4 no wid
         awaddr  = AXI_reg_awaddr;
         awlen   = AXI_reg_awlen;
         awsize  = AXI_reg_awsize;
         awburst = AXI_reg_awburst;
         awvalid = 1'h1; 
     
         wdata   = AXI_reg_wdata;
         wstrb   = AXI_reg_wstrb;
         wlast   = 1'h1;
         wvalid  = 1'h1; 
         
    
    @(negedge awready)
    
         awvalid = 1'h0;
    
    @(negedge wready) 
         wlast   = 1'd0;
         wvalid  = 1'd0;   
         bready  = 1'd1;      
    @(negedge bvalid)     
         bready  = 1'd0;
    
      testbench_inst = "IDEL";         
    end
    endtask




/******************************************************************************/
/*                          AXI's register read                               */
/******************************************************************************/
reg [31:0] AXI_reg_rdata;

    task AXI_reg_read
    (
//	  input       [3:0]   AXI_reg_arid,
	  input       [31:0]  AXI_reg_araddr,
	  input       [7:0]   AXI_reg_arlen,
	  input       [2:0]   AXI_reg_arsize,
	  input               AXI_reg_arburst,
	  output       [31:0]  AXI_reg_rdata    
    ); 

    begin
      testbench_inst = "AXI_reg_read"; 
      
 @(posedge clk)
//output to AXI---write address channel      
      araddr   = AXI_reg_araddr;
      arburst  = AXI_reg_arburst;      
//      arid     = AXI_reg_arid; 
      arid     = 0;       
      arlen    = AXI_reg_arlen;
      arsize   = AXI_reg_arsize; 
      rready  =1'd1;      
      arvalid  = 1'd1;

 @(negedge arready)
      arvalid  = 1'd0;
 
 @(posedge rvalid)
       AXI_reg_rdata = rdata;
 
 @(negedge rlast)
      rready  = 1'd0; 
 
      testbench_inst = "IDEL";  
    end
    endtask      


      
      
/******************************************************************************/
/*                          MEM's register write (MRW)                        */
/******************************************************************************/
    task MEN_reg_write
    (
//	  input       [3:0]   MEN_reg_awid,
	  input       [31:0]  MEN_reg_awaddr,
	  input       [31:0]  MEN_reg_wdata    
    ); 

    begin
      testbench_inst = "MEN_reg_write"; 
      
 @(posedge clk)     
//      awid_m    = MEN_reg_awid;  
      awid_m    = 0;  //axi4 no wid
      awaddr_m  = MEN_reg_awaddr;      
//when MRW, keep      
      awlen_m   = 0;            
      awsize_m  = 1;            
      awburst_m = 1;
      wstrb_m   = 4'b0011;   
//when MRW, keep  

////when MRW, keep      
//      awlen_m   = 0;            
//      awsize_m  = 1;            
//      awburst_m = 1;
//      wstrb_m   = 4'b0011;  // need 0011  
////when MRW, keep  
       
      awvalid_m = 1'b1; 
      wdata_m   = MEN_reg_wdata;
      wlast_m   = 1'b1;
      wvalid_m  = 1'b1; 

 @(posedge clk)
      awvalid_m = 1'b0;

 @(negedge wready_m)  
      wlast_m   = 1'b0;
      wvalid_m  = 1'b0;   
      bready_m  = 1'b1;
      
 @(negedge bvalid_m) 
      bready_m  = 1'b0;
 
      testbench_inst = "IDEL";  
    end
    endtask  


/******************************************************************************/
/*                          MEM's register read (MRR)                         */
/******************************************************************************/
//reg [31:0] MEN_reg_rdata;

    task MEN_reg_read
    (
//	  input       [3:0]    MEN_reg_arid,
	  input       [31:0]   MEN_reg_araddr
//	  output      [31:0]   MEN_reg_rdata    
    );
    
    begin
      testbench_inst = "MEN_reg_read"; 
      
 @(posedge clk)     
//      arid_m    = MEN_reg_arid;
      arid_m    = 0;      
      araddr_m  = MEN_reg_araddr;      
//when MRR, keep       
      arlen_m   = 0;      
      arsize_m  = 1;            
      arburst_m = 1;
//when MRR, keep 

////when MRR, keep       
//      arlen_m   = 0;      
//      arsize_m  = 1;            
//      arburst_m = 1;
////when MRR, keep 

      arvalid_m = 1'b1; 
//      rready_m  = 1'b1;   
      
  @(posedge clk)
      arvalid_m = 1'b0;

 @(posedge rvalid_m)
      rready_m  = 1'b1;
//      MEN_reg_rdata = (rdata_m >> 8);
       
 @(negedge rlast_m)
      rready_m   = 1'b0;     

      testbench_inst = "IDEL"; 
    end
    endtask 




/******************************************************************************/
/*                  MEM's long burst data write (write operation)                        */
/******************************************************************************/
//Supported AXI Transaction   size = 2 (4B = 32bit)  burst = 1 INCR


reg [7:0] data0;
reg [7:0] data1;
reg [7:0] data2;
reg [7:0] data3;

    task MEN_data_write_long_burst
    (

	  input       [31:0]  MEN_data_awaddr,
	  input       [7:0]   MEN_data_awlen,
	  input       [3:0]   MEN_data_awsize,
	  input       [3:0]   MEN_data_wstrb      
    ); 

    begin
      testbench_inst = "MEN_data_write_long_burst";
      
 @(posedge clk)     
      awid_m    = 4'h0;  
      awaddr_m  = MEN_data_awaddr;      
      awlen_m   = MEN_data_awlen;            
      awsize_m  = MEN_data_awsize;            
      awburst_m = 1;
      awvalid_m = 1; 
      

//      wdata_m   = 32'h02030001;  //      {data2, data3, data0, data1}
//      wdata_m   = 32'h00010203;  //      {data0, data1, data2, data3}  
      wdata_m   = 32'h03020100;  //      {data0, data1, data2, data3}      
      wstrb_m   =  { MEN_data_wstrb[3:2],MEN_data_wstrb[1:0]}; 
      
      
      wlast_m   = 1'h0;  
      wvalid_m  = 1'h1; 
      write_data_cnt         = 4'h0;
//      data0     = wdata_m[15:8];
//      data1     = wdata_m[7:0];
//      data2     = wdata_m[31:24];
//      data3     = wdata_m[23:16];      

      data0     = wdata_m[31:24];
      data1     = wdata_m[23:16];
      data2     = wdata_m[15:8];
      data3     = wdata_m[7:0]; 
      
 @(posedge clk)
      awvalid_m = 1'h0;
      

 @(posedge wready_m) 




  while ( write_data_cnt < (awlen_m)  )
  begin 
             if (  (awsize_m == 1) && ( write_data_cnt < (awlen_m)  ) )begin       
                if      (~(write_data_cnt[0]))    begin    
                  @(posedge clk)  
                    data0     = data0;
                    data1     = data1;
                    data2     = data2;
                    data3     = data3; 
//                    wdata_m    = { data2, data3, data0, data1 };
                    wdata_m    = { data0, data1, data2, data3 }; 
                    wstrb_m   = { MEN_data_wstrb[1:0],MEN_data_wstrb[3:2]};      
//                    wdata_m    = { data0,data1,data2,data3};       
                    write_data_cnt = write_data_cnt + 1;
                end
                else if     (write_data_cnt[0])      begin 
                  @(posedge clk)  
                    data0     = data0 +4;
                    data1     = data1 +4;
                    data2     = data2 +4;
                    data3     = data3 +4; 
//                    wdata_m    = { data2, data3, data0, data1 };
                    wdata_m    = { data0, data1, data2, data3 };  
                    wstrb_m   = { MEN_data_wstrb[3:2],MEN_data_wstrb[1:0]};      
//                    wdata_m    = { data0,data1,data2,data3};       
                    write_data_cnt = write_data_cnt + 1;                 
                end
                
        end
                

        else if (  (awsize_m == 2) && ( write_data_cnt < (awlen_m)  ) )begin   
                  @(posedge clk)  
                    data0     = data0 +4;
                    data1     = data1 +4;
                    data2     = data2 +4;
                    data3     = data3 +4; 
//                    wdata_m    = { data2, data3, data0, data1 };
                    wdata_m    = { data0, data1, data2, data3 };             
                    write_data_cnt = write_data_cnt + 1;       
        end

//        end            
  end
   
      wlast_m   = 1'h1;

 @(posedge clk)
      wlast_m   = 1'd0;
      
 @(negedge wready_m)  

      wvalid_m  = 1'd0;   
      bready_m  = 1'd1;
      
 @(negedge bvalid_m) 
      bready_m  = 1'd0;
      write_data_cnt         = 1'h0; 


      testbench_inst = "IDEL";       
    end
    endtask  
//////  


/******************************************************************************/
/*                  Narrow Transaction MEM's data write (write operation)                        */
/******************************************************************************/
//when awlen = 0 , burst length = awlen + 1
    task Narrow_MEN_data_write
    (
	  input       [31:0]  MEN_data_awaddr,
	  input       [7:0]   MEN_data_awlen,
	  input       [7:0]   MEN_data_awsize,      
	  input       [1:0]   MEN_data_awburst,
	  input       [31:0]  MEN_data_wdata,
	  input       [3:0]   MEN_data_wstrb      
    ); 

    begin
      testbench_inst = "Narrow_MEN_data_write";
      
 @(posedge clk)  //burst length no.1
      awid_m    = 0; //keep 0 ,AXI4 have no wid  
      awaddr_m  = MEN_data_awaddr;      
      awlen_m   = MEN_data_awlen;            
      awsize_m  = MEN_data_awsize;   //keep 1 when Narrow Transaction , transmit data (2^1 Byte)16 bit on 32 bit bus       
      awburst_m = MEN_data_awburst;   //0=fixed 1=INCR, keep 1 when Narrow Transaction
      awvalid_m = 1; 

      wdata_m   = MEN_data_wdata;
      wstrb_m   = MEN_data_wstrb; 
      wlast_m   = 1'h0;  
      wvalid_m  = 1'h1; 
      
 @(posedge clk)
      awvalid_m = 1'h0;
      

 @(posedge wready_m) 


      
 @(posedge clk)  //burst length no.2 
      wdata_m   = MEN_data_wdata;    
      wstrb_m   = 4'b1100;   
      wstrb_m   = ~MEN_data_wstrb; 

 @(posedge clk) //burst length no.3     
      wdata_m   = 32'h89abcdef;
      wstrb_m   = MEN_data_wstrb;        
      
 @(posedge clk) //burst length no.4     
      wdata_m   = 32'h89abcdef;
      wstrb_m   = ~MEN_data_wstrb;       

/*
*/
      
      wlast_m   = 1'h1;       
 @(posedge clk)
      wlast_m   = 1'd0;
      
 @(negedge wready_m)  

      wvalid_m  = 1'd0;   
      bready_m  = 1'd1;
      
 @(negedge bvalid_m) 
      bready_m  = 1'd0;

      testbench_inst = "IDEL";       
    end
    endtask  
//////  

    


/******************************************************************************/
/*                  MEM's data write (write operation)                        */
/******************************************************************************/
//when awlen = 0 , burst length = awlen + 1
    task MEN_data_write
    (
	  input       [31:0]  MEN_data_awaddr,
	  input       [7:0]   MEN_data_awlen,
	  input       [7:0]   MEN_data_awsize,      
	  input       [1:0]   MEN_data_awburst,
	  input       [31:0]  MEN_data_wdata,
	  input       [3:0]   MEN_data_wstrb      
    ); 

    begin
      testbench_inst = "MEN_data_write";
      
 @(posedge clk)  
      awid_m    = 0; //keep 0 ,AXI4 have no wid   
      awaddr_m  = MEN_data_awaddr;      
      awlen_m   = MEN_data_awlen;            
      awsize_m  = MEN_data_awsize;  //keep 2 when full Transaction, transmit data (2^2 Byte)32 bit on 32 bit bus         
      awburst_m = MEN_data_awburst; //0=fixed 1=INCR,
      awvalid_m = 1; 

      wdata_m   = 32'h01234567;
      wstrb_m   = 4'b1100;  //mask 4567 on data  
      wlast_m   = 1'h0;  
      wvalid_m  = 1'h1; 
      
 @(posedge clk)
      awvalid_m = 1'h0;
      

 @(posedge wready_m) 


      
 @(posedge clk)  //burst length = 2     awlen = 1 
      wdata_m   = 32'h89abcdef;    
      wstrb_m   = 4'b1111;  //no mask 


 @(posedge clk) //burst length = 3     awlen = 2      
      wdata_m   = 32'h01234567;
      wstrb_m   = 4'b1111;  //no mask       
      
 @(posedge clk) //burst length = 4     awlen = 3      
      wdata_m   = 32'h89abcdef;
      wstrb_m   = 4'b1011;  //mask ab on data      

 @(posedge clk)  //burst length = 5     awlen = 4 
      wdata_m   = 32'h89abcdef;    
      wstrb_m   = 4'b1111;  //no mask 


 @(posedge clk) //burst length = 6     awlen = 5      
      wdata_m   = 32'h01234567;
      wstrb_m   = 4'b1111;  //no mask       
      
 @(posedge clk) //burst length = 7     awlen = 6      
      wdata_m   = 32'h89abcdef;
      wstrb_m   = 4'b1011;  //mask ab on data   
      
/*
*/
      
      wlast_m   = 1'h1;       
 @(posedge clk)
      wlast_m   = 1'd0;
      
 @(negedge wready_m)  

      wvalid_m  = 1'd0;   
      bready_m  = 1'd1;
      
 @(negedge bvalid_m) 
      bready_m  = 1'd0;

      testbench_inst = "IDEL";       
    end
    endtask  
//////  

    
    
/******************************************************************************/
/*                    MEM's long burst data read (read operation)                        */
/******************************************************************************/

                                    

    task MEN_data_read_long_burst
    (
//	  input       [3:0]    MEN_arid_m,
	  input       [31:0]   MEN_data_araddr,
	  input       [7:0]    MEN_data_arlen,
	  input       [3:0]    MEN_data_arsize    
    );
    
    begin
      testbench_inst = "MEN_data_read_long_burst"; 

      
 @(posedge clk)     
//      arid_m    = MEN_arid_m; 
      arid_m    = 0; 
      araddr_m  = MEN_data_araddr ;      
      arlen_m   = MEN_data_arlen;        
      arsize_m  = MEN_data_arsize;            
      arburst_m = 1'h1;
      arvalid_m = 1; 
//      rready_m  = 1;   
      read_data_cnt = 0;
      MEN_data_rdata = 0;
      
  @(posedge clk)
      arvalid_m = 1'h0;

 @(posedge rvalid_m)
      rready_m  = 1; 


 
 

 
 @(negedge rlast_m)
      rready_m   = 1'd0;     
      MEN_data_rdata = 0;

      

      testbench_inst = "IDEL"; 
    end
    endtask     
 

/******************************************************************************/
/*                    MEM's data read (read operation)                        */
/******************************************************************************/

                                   



    task MEN_data_read
    (
//	  input       [3:0]    MEN_arid_m,
	  input       [31:0]   MEN_data_araddr,
	  input       [7:0]    MEN_data_arlen,
	  input       [3:0]    MEN_data_arsize   
    );
    
    begin
      testbench_inst = "MEN_data_read_long_burst"; 

      
 @(posedge clk)     
//      arid_m    = MEN_arid_m; 
      arid_m    = 0;
      araddr_m  = MEN_data_araddr; 
      arlen_m   = MEN_data_arlen;        
      arsize_m  = MEN_data_arsize;            
      arburst_m = 1'h1;
      arvalid_m = 1; 
//      rready_m  = 1;   
       MEN_data_rdata = 0;

       
  @(posedge clk)
      arvalid_m = 1'h0;

 @(posedge rvalid_m)
      rready_m  = 1; 
      MEN_data_rdata = rdata_m;
      
       
 @(negedge rlast_m)
      rready_m   = 1'd0;     
      MEN_data_rdata = 0;

      

      testbench_inst = "IDEL"; 
    end
    endtask 





    task global_reset
     (
    
     );
    begin    
      testbench_inst = "global_reset"; 

//global reset =  AXI_reg_write  address 0x20 bit[2] = 0 , bit[3] = 1  
//MEN_reg_write  need AXI_reg_write address 0x20 bit[5] = 1 : Configuration register space.
#(AXI_CLK_PERIOD*10)  //                                                              bit[3] = 1  global_reset                                                              
AXI_reg_write (       32'h20,          8'h0,             3'h2,              2'b01,         32'h87fc003b,            4'hf );

#(AXI_CLK_PERIOD*10) 
MEN_reg_write (     32'h0000,           32'h00);


#(AXI_CLK_PERIOD*10)  //                                                              bit[3] = 0  no global_reset 
AXI_reg_write (       32'h20,          8'h0,             3'h2,              2'b01,         32'h87fc0013,            4'hf );

      testbench_inst = "IDEL"; 
    end
    endtask 



//power up INIT =  global reset + tRST 2us  +MRW0 +MRW4
    task power_up_INIT_MR0_MR4
     (
    
     );
    begin    
      testbench_inst = "power_up_INIT"; 


//power up INIT  =  AXI_reg_write  address 0x20 bit[2] = 1 , bit[3] = 0
//MEN_reg_write  need AXI_reg_write address 0x20 bit[5] = 1 : Configuration register space.

#(AXI_CLK_PERIOD*10)  //                                                              bit[2] = 1  power_up_INIT
AXI_reg_write (       32'h20,          8'h0,             3'h2,              2'b01,         32'h87fc0037,            4'hf );

#(AXI_CLK_PERIOD*10) 
MEN_reg_write (     32'h0000,           32'h00);
#2_500_000 // wait 2.5 us  global reset + tRST 2us  +MRW0 +MRW4

#(AXI_CLK_PERIOD*10)  //                                                              bit[2] = 0  no power_up_INIT
AXI_reg_write (       32'h20,          8'h0,             3'h2,              2'b01,         32'h87fc0013,            4'hf );

 
      testbench_inst = "IDEL"; 
    end
    endtask 
    
    
   



/******************************************************************************/
/*                          initial_AXI_signal                                */
/******************************************************************************/
    task AXI_signal_initial
     (
    
     );
    begin
    
      testbench_inst = "initial"; 
      
///////write address channel       
      awid    = 4'd0;      //output to AXI  
      awaddr  = 32'd0;
      awlen   = 8'd0;
      awsize  = 3'd0;
      awburst = 2'd0;
      awvalid = 1'd0;   
   // awready;             //input from AXI
    
///////write data channel        
      wdata   = 32'd0;     //output to AXI 
      wstrb   = 4'd0;
      wlast   = 1'd0;
      wvalid  = 1'd0;     
   // wready;              //input from AXI

///////write response channel
      bready  = 1'd0;      //output to AXI
    // bid;                //input from AXI
    // bresp;
    // bvalid;
    
///////Master read address channel
      araddr   = 32'd0;    //output to AXI
      arburst  = 2'd0;      
      arid     = 4'd0;  
      arlen    = 8'd0;
      arsize   = 3'd0;      
      arvalid  = 1'd0;
    // arready;            //input from AXI
    
///////Master read data channel
      rready  =1'd0;       //output to AXI
    // rid;                //input from AXI
    // rdata;
    // rresp;
    // rvalid;
    // rlast; 


/******************************************************************************/
/*                          AXI to memory signal                              */
/******************************************************************************/
///////write address channel           
      awid_m    = 4'd0;    //output to AXI
      awaddr_m  = 32'd0;
      awlen_m   = 8'd0;
      awsize_m  = 3'd0;
      awburst_m = 2'd0;
      awvalid_m = 1'd0;   
   // awready_m;           //input from AXI
    
///////write data channel       
      wdata_m   = 32'd0;   //output to AXI 
      wstrb_m   = 4'd0;
      wlast_m   = 1'd0;
      wvalid_m  = 1'd0;     
   // wready;             //input from AXI

///////write response channel
      bready_m  = 1'd0;   //output to AXI
    // bid;               //input from AXI
    // bresp;
    // bvalid;
    
///////Master read address channel
      araddr_m   = 32'd0; //output to AXI
      arburst_m  = 2'd0;      
      arid_m     = 4'd0;  
      arlen_m    = 8'd0;
      arsize_m   = 3'd0;      
      arvalid_m  = 1'd0;
    // arready_m;         //input from AXI
    
///////Master read data channel
      rready_m  =1'd0;    //output to AXI
    // rid_m;             //input from AXI
    // rdata_m;
    // rresp_m;
    // rvalid_m;
    // rlast_m;        

      testbench_inst = "initial_done"; 
    end
    endtask 



    

    
   initial begin
   
      clk       = 1'b0;
      clk_m     = 1'b0;
      sys_clk   = 1'b0;     
      reset      = 1'b0;
      reset_m   = 1'b0;


AXI_signal_initial;


#10
      reset      = 1'b1;
      reset_m   = 1'b1;
      clk       = 1'b1;
      clk_m     = 1'b1;
      sys_clk   = 1'b1;
      
      
//      testbench_inst = "PSRAM_tPU_150us";    #200_000_000 //wait time need > 150us (PSRAM time spec tPU)  need use xccela_opi_ctl.v "state <= st_por_delay;"
///////  when test can avoid 150us , can mask xccela_opi_ctl.v "state <= st_por_delay;" change to  state <= st_init_mr0;

    
        
/******************************************************************************/
/*                          AXI register setting                              */
/******************************************************************************/    
#(AXI_CLK_PERIOD*20)    
//AXI_reg_write    
////////////////////#(AXI_CLK_PERIOD*10)     
//               AXI_reg_awaddr, AXI_reg_awlen,   AXI_reg_awsize,   AXI_reg_awburst,  AXI_reg_wdata,   AXI_reg_wstrb
AXI_reg_write (          32'h10,          8'h0,             3'h2,              2'b01,          32'h0,          4'hf );

//AXI_reg_read
////////////////////#(AXI_CLK_PERIOD*10) 
//               AXI_reg_araddr, AXI_reg_arlen,   AXI_reg_arsize,   AXI_reg_arburst,  AXI_reg_rdata
AXI_reg_read (          32'h10,           8'h0,             3'h2,             2'b01,  AXI_reg_rdata );




//AXI_reg_write
////////////////////#(AXI_CLK_PERIOD*10)     
//               AXI_reg_awaddr, AXI_reg_awlen,   AXI_reg_awsize,   AXI_reg_awburst,  AXI_reg_wdata,   AXI_reg_wstrb
AXI_reg_write (          32'h20,          8'h0,             3'h2,               2'b01,         32'h33,          4'hf );
     
//AXI_reg_read
////////////////////#(AXI_CLK_PERIOD*10) 
//                AXI_reg_araddr, AXI_reg_arlen,   AXI_reg_arsize,   AXI_reg_arburst,  AXI_reg_rdata
AXI_reg_read (            32'h20,          8'h0,             3'h2,                2'b01,  AXI_reg_rdata );






/******************************************************************************/
/*                 MEM register setting   (MRR/MRW)                           */
/******************************************************************************/
#(AXI_CLK_PERIOD*20) 


//66MHz  
//  MR0 = 0x0001;  //psram read latency
//  MR4 = 0x0000;  //psram write latency

  
////109MHz  
//  MR0 = 0x0005;  //psram read latency
//  MR4 = 0x0080;  //psram write latency

////133MHz  
//  MR0 = 0x0009;  //psram read latency
//  MR4 = 0x0040;  //psram write latency


////166MHz  
//  MR0 = 0x000d;  //psram read latency
//  MR4 = 0x00c0;  //psram write latency


//200MHz  
//  MR0 = 0x0011;  //psram read latency
//  MR4 = 0x0020;  //psram write latency
 
  
/******************************************************************************/
/*                      MR0 setting   (MRR/MRW)                               */
/******************************************************************************/ 



//MEN_reg_write - MR0 setting
////////////////////#(AXI_CLK_PERIOD*20)   
//               MEN_reg_awaddr,
MEN_reg_write (     32'h0000,

//        MEN_reg_wdata 
`ifdef tCLK5000 //0.5ns @200M
               32'h11
`else
`ifdef tCLK6000 //0.6ns @166M
               32'h0d
`else
`ifdef tCLK7500 //0.75ns @133M
               32'h09
`else
               32'h11
`endif
`endif
`endif
             );

//MEN_reg_read - MR0 setting
////////////////////#(AXI_CLK_PERIOD*20)
//              MEN_reg_araddr
MEN_reg_read  (       32'h0000);
 


/******************************************************************************/
/*                      MR4 setting   (MRR/MRW)                               */
/******************************************************************************/ 


//MEN_reg_write - MR4 setting
////////////////////#(AXI_CLK_PERIOD*20)   
//               MEN_reg_awaddr,   
MEN_reg_write (  32'h0004,
//        MEN_reg_wdata
`ifdef tCLK5000 //0.5ns @200M
               32'h20
`else
`ifdef tCLK6000 //0.6ns @166M
               32'hc0
`else
`ifdef tCLK7500 //0.75ns @133M
               32'h40
`else
               32'h20
`endif
`endif
`endif
             );


//MEN_reg_read - MR4 setting
////////////////////#(AXI_CLK_PERIOD*20)
//              MEN_reg_araddr
MEN_reg_read  (       32'h0004);



/******************************************************************************/
/*                          AXI register setting                              */
/******************************************************************************/
#(AXI_CLK_PERIOD*20)  


//AXI_reg_write
////////////////////#(AXI_CLK_PERIOD*10)     
//               AXI_reg_awaddr, AXI_reg_awlen,   AXI_reg_awsize,   AXI_reg_awburst,        AXI_reg_wdata,   AXI_reg_wstrb
AXI_reg_write (          32'h20,          8'h0,             3'h2,              2'b01,         32'h87fc0013,            4'hf );
//AXI_reg_write (       4'h1,            32'h20,          8'h0,             3'h2,              2'b01,         32'h87fd0012,            4'hf );

     
//AXI_reg_read
////////////////////#(AXI_CLK_PERIOD*10) 
//               AXI_reg_araddr, AXI_reg_arlen,   AXI_reg_arsize,   AXI_reg_arburst,  AXI_reg_rdata
AXI_reg_read (           32'h20,          8'h0,             3'h2,              2'b01,  AXI_reg_rdata );






#(AXI_CLK_PERIOD*20) 
//global_reset;


#(AXI_CLK_PERIOD*20) 
//power_up_INIT_MR0_MR4;







/******************************************************************************/
/*                              MEM write/read data  AXI long_burst           */
/******************************************************************************/

#(AXI_CLK_PERIOD*20) 

  
//                            MEN_data_awaddr, MEN_data_awlen,  MEN_data_awsize,  MEN_data_wstrb  
MEN_data_write_long_burst (          32'h0000,           8'd255,           4'd2,           4'b1111); 
//when awsize = 4'd1 (16bit),wstrb must 4'b0011
//when awsize = 4'd2 ,wstrb must 4'b1111


//MEN_data_read_long_burst
//                            MEN_data_araddr, MEN_data_arlen,   MEN_data_arsize  
//MEN_data_read_long_burst  (        32'h0000,           8'd2,           4'd2);


//                          MEN_data_araddr, MEN_data_arlen,   MEN_data_arsize  
MEN_data_read_long_burst  (        32'h0000,           8'd255,           4'd2);


/*
*/






/******************************************************************************************************/
/*                              MEM write/read data  AXI Narrow transmit                              */
/******************************************************************************************************/

/// ****************************full write + Narrow read or full read****************************

/*  
#(AXI_CLK_PERIOD*20) 
//MEN_data_write
//               MEN_data_awaddr, MEN_data_awlen,   MEN_data_awsize,   MEN_data_awburst,  MEN_data_wdata,   MEN_data_wstrb
MEN_data_write (        32'h0000,           8'h3,              4'd2,              2'b01,    32'h12345678,          4'b1111 );

//               MEN_data_araddr, MEN_data_arlen,   MEN_data_arsize
MEN_data_read  (        32'h0002,           8'h3,              4'd1); //arsize= 2 = full
*/

/* 
//               MEN_data_araddr, MEN_data_arlen,   MEN_data_arsize
MEN_data_read  (        32'h0000,           8'h3,              4'd1); //arsize= 1 = Narrow
                                                                                
                                                                               
MEN_data_read  (        32'h0000,           8'h3,              4'd2); //arsize= 2 = full


*/
/// ****************************Narrow write + Narrow read or full read****************************

/*
#(AXI_CLK_PERIOD*20) 
//                       MEN_data_awaddr, MEN_data_awlen,   MEN_data_awsize,   MEN_data_awburst,  MEN_data_wdata,   MEN_data_wstrb
Narrow_MEN_data_write (         32'h0008,           8'h3,              4'd1,              2'b01,    32'h01234567,          4'b0011 ); 

//               MEN_data_araddr, MEN_data_arlen,   MEN_data_arsize
MEN_data_read  (        32'h0008,           8'h3,              4'd1); //arsize= 1 = Narrow

//               MEN_data_araddr, MEN_data_arlen,   MEN_data_arsize
MEN_data_read  (        32'h0008,           8'h3,              4'd2); //arsize= 2 = full

*/





 
   end // 


   
   //------------------------------------------------------------------------
   // Add an instance of the AXI 4 SLAVE
   //------------------------------------------------------------------------
   rpc2_ctrl_controller
     #(.C_AXI_MEM_ID_WIDTH(C_AXI_ID_WIDTH),
       .C_AXI_REG_ID_WIDTH(C_AXI_ID_WIDTH),
       .C_AXI_MEM_DATA_INTERLEAVING(0),
       .C_AXI_REG_BASEADDR(C_AXI_REG_BASEADDR),
       .C_AXI_REG_HIGHADDR(C_AXI_REG_BASEADDR+32'h0000004F),
       
       .INIT_CLOCK_HZ(INIT_CLOCK_HZ),
       .INIT_DRIVE_STRENGTH(INIT_DRIVE_STRENGTH)       
       )
     rpc2_ctrl_controller (
                           .AXIr_ACLK(clk),
                           .AXIr_ARESETN(reset),
                           //
                           .AXIr_AWID(awid),
                           .AXIr_AWADDR(awaddr),
                           .AXIr_AWLEN(awlen),
                           .AXIr_AWSIZE(awsize),
                           .AXIr_AWBURST(awburst),
                           .AXIr_AWVALID(awvalid),
                           .AXIr_AWREADY(awready),
                           //
                           .AXIr_WDATA(wdata),
                           .AXIr_WLAST(wlast),
                           .AXIr_WVALID(wvalid),
                           .AXIr_WREADY(wready),
                           .AXIr_WSTRB(wstrb),
                           //
                           .AXIr_BID(bid),
                           .AXIr_BRESP(bresp),
                           .AXIr_BVALID(bvalid),
                           .AXIr_BREADY(bready),
                           //
                           .AXIr_ARID(arid),
                           .AXIr_ARADDR(araddr),
                           .AXIr_ARLEN(arlen),
                           .AXIr_ARSIZE(arsize),
                           .AXIr_ARBURST(arburst),
                           .AXIr_ARVALID(arvalid),
                           .AXIr_ARREADY(arready),
                           //
                           .AXIr_RID(rid),
                           .AXIr_RDATA(rdata),
                           .AXIr_RRESP(rresp),
                           .AXIr_RLAST(rlast),
                           .AXIr_RVALID(rvalid),
                           .AXIr_RREADY(rready),
                           //
                           .AXIm_ACLK(clk_m),
                           .AXIm_ARESETN(reset_m),
                           //
                           .AXIm_AWID(awid_m),
                           .AXIm_AWADDR(awaddr_m),
                           .AXIm_AWLEN(awlen_m),
                           .AXIm_AWSIZE(awsize_m),
                           .AXIm_AWBURST(awburst_m),
                           .AXIm_AWVALID(awvalid_m),
                           .AXIm_AWREADY(awready_m),
                           //
                           .AXIm_WDATA(wdata_m),
                           .AXIm_WLAST(wlast_m),
                           .AXIm_WVALID(wvalid_m),
                           .AXIm_WREADY(wready_m),
                           .AXIm_WSTRB(wstrb_m),
                           .AXIm_WID({C_AXI_ID_WIDTH{1'b0}}),
                           //
                           .AXIm_BID(bid_m),
                           .AXIm_BRESP(bresp_m),
                           .AXIm_BVALID(bvalid_m),
                           .AXIm_BREADY(bready_m),
                           //
                           .AXIm_ARID(arid_m),
                           .AXIm_ARADDR(araddr_m),
                           .AXIm_ARLEN(arlen_m),
                           .AXIm_ARSIZE(arsize_m),
                           .AXIm_ARBURST(arburst_m),
                           .AXIm_ARVALID(arvalid_m),
                           .AXIm_ARREADY(arready_m),
                           //
                           .AXIm_RID(rid_m),
                           .AXIm_RDATA(rdata_m),
                           .AXIm_RRESP(rresp_m),
                           .AXIm_RLAST(rlast_m),
                           .AXIm_RVALID(rvalid_m),
                           .AXIm_RREADY(rready_m),

                           .sys_clk     (sys_clk),
//                           .ref_clk     (ref_clk),
                           //.GPO         (GPO[1:0]),
                           //.IENOn       (IENOn),

   // psram io pad                            
                           .xl_ck          (xl_ck),
                           .xl_ce          (xl_ce),
                           .xl_dqs         (xl_dqs),
                           .xl_dq          (xl_dq) 
                                                                                                          
                           );



   psram_model
    psram_model_0  
                         (
                          // bidirectional                          
		                  .xDQ			(xl_dq),		 
		                  .xDQSDM			(xl_dqs),			
                          // Inouts
		                  .xCEn			(xl_ce),			
		                  .xCLK			(xl_ck),			 
		                  .xRESETn		(reset_m)                          
                          );


   
endmodule


