//===========================================================================
//  Copyright(c) Alorium Technology Inc., 2020
//  ALL RIGHTS RESERVED
//===========================================================================
//
// File name:  : evo_xb_info.v
// Author      : Steve Phillips
// Contact     : support@aloriumtech.com
// Description :
//
//   Based on the evo_i2c_reg module, this module provides a seperate info
// reg that the OpenEvo user can customize to provide information about 
// thier custom XB logic.
//
//   A single CSR is defined, the EVO_XB_INFO reg. It uses indirect 
// addressing for read operations. To use the CSR, the following steps are 
// taken:
//  
//     1. The user write an address to the EVO_XB_INFO reg. This sets the 
//        value in the info_f register
//     2. The user reads the EVO_XB_INFO reg. The value in the info_f reg
//        is used to select the info value to be returned.
//
//   The value at indirect address 0 is required to be the EVO_XB_INFO_NUM_VAL, 
// which indicates the number of _additional_ info CSRs defined.
//
//   The values at indirect addresses 1,2,and 3 are suggested to be a four 
// character string that indicates Vendor, Model, and XB type. These are not 
// required but are suggested.
//
//===========================================================================


module evo_xb_info
  #(
    parameter EVO_XB_INFO_NUM_ADDR = 32'h0,  // Address of XB_INFO_NUM value
    parameter EVO_XB_INFO_NUM_VAL  = 32'h6,  // Number of additional XB_INFO regs
    parameter EVO_XB_INFO_VENDOR_ADDR = 32'h1, // Address and Value for Vendor name
    parameter EVO_XB_INFO_VENDOR_VAL  = "ALO ",
    parameter EVO_XB_INFO_MODEL_ADDR = 32'h2,  // Address and Value for product Model 
    parameter EVO_XB_INFO_MODEL_VAL  = "EVO ",
    parameter EVO_XB_INFO_TYPE_ADDR = 32'h3,   // Address and Value for XB Type
    parameter EVO_XB_INFO_TYPE_VAL  = "SERV",
    // Example of defining a Decimal value
    parameter EVO_XB_INFO_EXAMPLE_DECIMAL_ADDR = 32'h4,          // Address of EXAMPLE_DECIMAL
    parameter EVO_XB_INFO_EXAMPLE_DECIMAL_VAL  = 32'd4294967295, // Largest possible integer value
    // Example of defining a Hex value
    parameter EVO_XB_INFO_EXAMPLE_HEX_ADDR = 32'h5,              // Address of EXAMPLE_HEX
    parameter EVO_XB_INFO_EXAMPLE_HEX_VAL  = 32'hC0FFEE01,       // Hex Integer Value
    // Example of defining a Char value. NOTE: Maximum size is 4 chars
    parameter EVO_XB_INFO_EXAMPLE_CHAR_ADDR = 32'h6,             // Address of EXAMPLE_CHAR
    parameter EVO_XB_INFO_EXAMPLE_CHAR_VAL  = "TEST"             // Four characters: "TEST"
    )
   (input                         clk,
    input                         rstn,
    // Interface to evo_i2c_ctrl (Avalon MM Slave)
    input logic [CSR_AWIDTH-1:0]  avs_csr_address,
    input logic                   avs_csr_read, 
    output logic                  avs_csr_readdatavalid,
    output logic                  avs_csr_waitrequest,
    input logic                   avs_csr_write,
    input logic [CSR_DWIDTH-1:0]  avs_csr_writedata,
    output logic [CSR_DWIDTH-1:0] avs_csr_readdata
    );
   
   logic                          info_sel;
   logic [CSR_DWIDTH-1:0]         info_f;
   logic [CSR_DWIDTH-1:0]         info_val;
   
   always_comb info_sel  = (avs_csr_address[CSR_AWIDTH-1:0] == EVO_XB_INFO_ADDR);

   always_ff @(posedge clk or negedge rstn) begin
      info_f <=  (!rstn)                     ? EVO_INFO_RST_VAL        : // reset  
                 (info_sel && avs_csr_write) ? avs_csr_writedata[31:0] : // load
                                               info_f;                   // hold
   end 

   // The info_val selection logic picks a value to be returned based
   // on the value written to the info_f reg. This part of the module
   // should be modified by the OpenEvo user to insert values into the
   // addresses they have defined. The address field is 32 bits so the
   // number of addr/values that can be defined is very large. Please
   // note that values are also 32 bits, so they can only contain 4
   // characters.
   always_comb begin
      unique case (info_f)
        EVO_XB_INFO_NUM_ADDR             : info_val = EVO_XB_INFO_NUM_VAL;
        EVO_XB_INFO_VENDOR_ADDR          : info_val = EVO_XB_INFO_VENDOR_VAL;
        EVO_XB_INFO_MODEL_ADDR           : info_val = EVO_XB_INFO_MODEL_VAL;
        EVO_XB_INFO_TYPE_ADDR            : info_val = EVO_XB_INFO_TYPE_VAL;
        EVO_XB_INFO_EXAMPLE_DECIMAL_ADDR : info_val = EVO_XB_INFO_EXAMPLE_DECIMAL_VAL ;
        EVO_XB_INFO_EXAMPLE_HEX_ADDR     : info_val = EVO_XB_INFO_EXAMPLE_HEX_VAL ;
        EVO_XB_INFO_EXAMPLE_CHAR_ADDR    : info_val = EVO_XB_INFO_EXAMPLE_CHAR_VAL ;
        default : info_val = 0;
      endcase // unique case (info_f)
   end // always_comb
   
   // Assert bus outputs
   always_ff @(posedge clk) begin
      avs_csr_readdatavalid <= info_sel;
      avs_csr_readdata      <= ({CSR_DWIDTH{info_sel}} & info_val);
   end
   
   always_comb avs_csr_waitrequest = 1'b0;
   
  
endmodule // evo_xb_info


