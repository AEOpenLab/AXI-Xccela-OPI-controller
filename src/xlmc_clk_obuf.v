

`define       FPGA

//`default_nettype none
`timescale 1ps / 1ps


module xlmc_clk_obuf #
(
    parameter integer DRIVE_STRENGTH = 8,
    parameter         SLEW_RATE      = "SLOW"
)
(
    input   wire    cen,
    input   wire    clk,
    output  wire    xl_ck_p
);

    wire    clk_wire;

//FPGA template
//FPGA template
 `ifdef FPGA 
    assign clk_wire = (cen)? clk : 0;
    OBUF #
    (
        .DRIVE  ( DRIVE_STRENGTH ),     // Specify the output drive strength
        .SLEW   ( SLEW_RATE      )      // Specify the output slew rate
    )
    OBUF_ck_p
    (
        .I  ( clk_wire ),     // Buffer input
        .O  ( xl_ck_p    )      // Buffer output (connect directly to top-level port)
    );
 `else
 
    assign clk_wire = (cen)? clk : 0;
    assign xl_ck_p = clk_wire;    
    
`endif 
 
/*----------------------------------------------------------------------------------------------------------------------------*/
 // ODDR template
 
 /*   
    ODDR #
    (
        .DDR_CLK_EDGE ( "SAME_EDGE" ),  // "OPPOSITE_EDGE" or "SAME_EDGE"
        .INIT         ( 1'b0        ),  // Initial value of Q: 1'b0 or 1'b1
        .SRTYPE       ( "ASYNC"     )   // Set/Reset type: "SYNC" or "ASYNC"
    )
    ODDR_ck_n
    (
        .Q  ( oddr_clk_n ),     // 1-bit DDR output
        .C  ( ~clk       ),     // 1-bit clock input
        .CE ( 1'b1       ),     // 1-bit clock enable input
        .D1 ( ~cen       ),     // 1-bit data input (positive edge)
        .D2 ( 1'b1       ),     // 1-bit data input (negative edge)
        .R  ( 1'b0       ),     // 1-bit reset
        .S  ( 1'b0       )      // 1-bit set
    );
    
    
    OBUF #
    (
        .DRIVE  ( DRIVE_STRENGTH ),     // Specify the output drive strength
        .SLEW   ( SLEW_RATE      )      // Specify the output slew rate
    )
    OBUF_ck_n
    (
        .I  ( oddr_clk_n ),     // Buffer input
        .O  ( xl_ck_n    )      // Buffer output (connect directly to top-level port)
    );
*/
endmodule

/*----------------------------------------------------------------------------------------------------------------------------*/

