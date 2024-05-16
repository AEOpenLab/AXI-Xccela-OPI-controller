module rpc2_ctrl_dpram_generator #(
    parameter FIFO_ADDR_BITS = 32'd3,
    parameter FIFO_DATA_WIDTH = 32'd16,
    parameter DPRAM_MACRO = 1'd0,      // 0=not used, 1=used macro
    parameter DPRAM_MACRO_SIZE = 4'd0, // 0=AW, 1=AR, 2=AWID, 3=ARID, 4=WID, 5=WDAT, 6=RDAT, 7=BDAT, 8=RX, 9=ADR
    parameter DPRAM_MACRO_TYPE = 1'd0  // 0=type-A(STD), 1=type-B(LowLeak)
)(
    // Outputs
    b_odata, 
    // Inputs
    clka, clkb, ceia_n, cejb_n, ia, jb, i_idata
);
    localparam  STD_CELL      = 1'd0;
    localparam  LOW_LEAK_CELL = 1'd1;
    localparam  AW_FIFO       = 4'd0;
    localparam  AR_FIFO       = 4'd1;
    localparam  AWID_FIFO     = 4'd2;
    localparam  ARID_FIFO     = 4'd3;
    localparam  WID_FIFO      = 4'd4;
    localparam  WDAT_FIFO     = 4'd5;
    localparam  RDAT_FIFO     = 4'd6;
    localparam  BDAT_FIFO     = 4'd7;
    localparam  RX_FIFO       = 4'd8;
    localparam  ADR_FIFO      = 4'd9;
    localparam  AWR_FIFO      = 4'd10;

    localparam  BUS_LOW       = {FIFO_DATA_WIDTH{1'b0}};
    localparam  SIG_LOW       = 1'b0;
    localparam  SIG_HIGH      = 1'b1;

    output  wire    [FIFO_DATA_WIDTH-1:0] b_odata;  // b port output data

    input   wire    clka;                           // a port clock
    input   wire    clkb;                           // b port clock
    input   wire    ceia_n;                         // a port chip enable signal
    input   wire    cejb_n;                         // b port chip enable signal
    input   wire    [FIFO_ADDR_BITS-1:0] ia;        // a port address
    input   wire    [FIFO_ADDR_BITS-1:0] jb;        // b port address
    input   wire    [FIFO_DATA_WIDTH-1:0] i_idata;  // a port input data

    generate
    if(DPRAM_MACRO == 0) begin
        if((DPRAM_MACRO_SIZE == WDAT_FIFO) || (DPRAM_MACRO_SIZE == RDAT_FIFO) || (DPRAM_MACRO_SIZE == RX_FIFO)) begin
            reg     [(FIFO_DATA_WIDTH/2)-1:0] mem_h[0:(1<<FIFO_ADDR_BITS)-1];
            reg     [(FIFO_DATA_WIDTH/2)-1:0] mem_l[0:(1<<FIFO_ADDR_BITS)-1];
            reg     [FIFO_DATA_WIDTH-1:0] int_b_odata; // b port output data

            assign b_odata = int_b_odata;

            always @(posedge clka) begin
                if (!ceia_n) begin
                    mem_h[ia] <= i_idata[FIFO_DATA_WIDTH-1:FIFO_DATA_WIDTH/2];
                    mem_l[ia] <= i_idata[(FIFO_DATA_WIDTH/2)-1:0];
                end // if !ceia_n
            end

            always @(posedge clkb) begin
                if (!cejb_n) begin
                    int_b_odata[FIFO_DATA_WIDTH-1:FIFO_DATA_WIDTH/2] <= mem_h[jb];
                    int_b_odata[(FIFO_DATA_WIDTH/2)-1:0]             <= mem_l[jb];
                end // if !cejb_n
            end
        end
        else begin
            reg     [FIFO_DATA_WIDTH-1:0] mem[0:(1<<FIFO_ADDR_BITS)-1];
//            reg     [FIFO_DATA_WIDTH-1:0] int_a_odata; // a port output data
            reg     [FIFO_DATA_WIDTH-1:0] int_b_odata; // b port output data

//            assign a_odata = int_a_odata;
            assign b_odata = int_b_odata;

            always @(posedge clka) begin
                if (!ceia_n) begin
//                    if(wei_n)   int_a_odata <= mem[ia];
//                    else        mem[ia] <= (~dmi & i_idata) | (dmi & mem[ia]);
                    mem[ia] <= i_idata;
                end // if !ceia_n
            end

            always @(posedge clkb) begin
                if (!cejb_n) begin
//                    if(wej_n)   int_b_odata <= mem[jb];
//                    else        mem[jb] <= (~dmj & j_idata) | (dmj & mem[jb]);
                    int_b_odata <= mem[jb];
                end // if !cejb_n
            end
        end
    end // if DPRAM_MACRO == 0
    else if(DPRAM_MACRO == 1) begin
        case(DPRAM_MACRO_TYPE)
        STD_CELL: begin
            case(DPRAM_MACRO_SIZE)
            AW_FIFO: begin
            /***************************************************************************/
            /* Please describe the instance (type-A) of AW_FIFO (44bit x 16word) here. */
            /***************************************************************************/
                end
            AR_FIFO: begin
            /***************************************************************************/
            /* Please describe the instance (type-A) of AR_FIFO (44bit x 16word) here. */
            /***************************************************************************/
                end
            AWID_FIFO: begin
            /********************************************************************************/
            /* Please describe the instance (type-A) of AWID_FIFO (ID width x 16word) here. */
            /********************************************************************************/
                end
            ARID_FIFO: begin
            /****************************************************************************************/
            /* Please describe the instance (type-A) of ARID_FIFO ((14bit+ID width) x 16word) here. */
            /****************************************************************************************/
                end
            WID_FIFO: begin
            /*******************************************************************************/
            /* Please describe the instance (type-A) of WID_FIFO (ID width x 16word) here. */
            /*******************************************************************************/
                end
            WDAT_FIFO: begin
            /******************************************************************************/
            /* Please describe the instance (type-A) of WDAT_FIFO (40bit x 128word) here. */
            /******************************************************************************/
                end
            RDAT_FIFO: begin
            /******************************************************************************/
            /* Please describe the instance (type-A) of RDAT_FIFO (40bit x 128word) here. */
            /******************************************************************************/
                end
            BDAT_FIFO: begin
            /****************************************************************************/
            /* Please describe the instance (type-A) of BDAT_FIFO (2bit x 16word) here. */
            /****************************************************************************/
                end
            RX_FIFO: begin
            /****************************************************************************/
            /* Please describe the instance (type-A) of RX_FIFO (20bit x 256word) here. */
            /****************************************************************************/
                end
            ADR_FIFO: begin
            /****************************************************************************/
            /* Please describe the instance (type-A) of RX_FIFO (46bit x 16word) here. */
            /****************************************************************************/
                end
            AWR_FIFO: begin
            /****************************************************************************/
            /* Please describe the instance (type-A) of AWR_FIFO (45bit x 16word) here. */
            /****************************************************************************/
                end
            default: ;
            endcase // case DPRAM_MACRO_SIZE
        end
        LOW_LEAK_CELL: begin
            case(DPRAM_MACRO_SIZE)
            AW_FIFO: begin
            /***************************************************************************/
            /* Please describe the instance (type-B) of AW_FIFO (44bit x 16word) here. */
            /***************************************************************************/
                end
            AR_FIFO: begin
            /***************************************************************************/
            /* Please describe the instance (type-B) of AR_FIFO (44bit x 16word) here. */
            /***************************************************************************/
                end
            AWID_FIFO: begin
            /********************************************************************************/
            /* Please describe the instance (type-B) of AWID_FIFO (ID width x 16word) here. */
            /********************************************************************************/
                end
            ARID_FIFO: begin
            /****************************************************************************************/
            /* Please describe the instance (type-B) of ARID_FIFO ((14bit+ID width) x 16word) here. */
            /****************************************************************************************/
                end
            WID_FIFO: begin
            /*******************************************************************************/
            /* Please describe the instance (type-B) of WID_FIFO (ID width x 16word) here. */
            /*******************************************************************************/
                end
            WDAT_FIFO: begin
            /******************************************************************************/
            /* Please describe the instance (type-B) of WDAT_FIFO (40bit x 128word) here. */
            /******************************************************************************/
                end
            RDAT_FIFO: begin
            /******************************************************************************/
            /* Please describe the instance (type-B) of RDAT_FIFO (40bit x 128word) here. */
            /******************************************************************************/
                end
            BDAT_FIFO: begin
            /****************************************************************************/
            /* Please describe the instance (type-B) of BDAT_FIFO (2bit x 16word) here. */
            /****************************************************************************/
                end
            RX_FIFO: begin
            /****************************************************************************/
            /* Please describe the instance (type-B) of RX_FIFO (20bit x 256word) here. */
            /****************************************************************************/
                end
            ADR_FIFO: begin
            /****************************************************************************/
            /* Please describe the instance (type-B) of RX_FIFO (46bit x 16word) here. */
            /****************************************************************************/
                end
            AWR_FIFO: begin
            /****************************************************************************/
            /* Please describe the instance (type-B) of AWR_FIFO (45bit x 16word) here. */
            /****************************************************************************/
                end
            default: ;
            endcase // case DPRAM_MACRO_SIZE
        end
        default: ;
        endcase // case DPRAM_MACRO_TYPE
    end // else if DPRAM_MACRO == 1
    endgenerate
endmodule 
