//===========================================================================
//  Copyright(c) Alorium Technology Group Inc., 2020
//  ALL RIGHTS RESERVED
//===========================================================================
//
// File name:  : evo_xb.sv
// Author      : Steve Phillips
// Contact     : support@aloriumtech.com
// Description : 
// 
// The evo_xb module is a wrapper module to allow IP blocks and XB blocks 
// to be instantiated and integrated into the Evo FPGA design
//
//===========================================================================

module evo_xb
   (// Basic clock and reset
    input                             clk,
    input                             reset_n,
    // Other clocks and reset
    input                             pwr_on_nrst,
    input                             pll_locked,
    input                             clk_bsp,
    input                             clk_60,
    input                             clk_120,
    input                             clk_16,
    input                             clk_32,
    input                             en16mhz,
    input                             en1mhz,
    input                             en128khz,
    // PMUX connections
    output logic [PORT_D_DWIDTH-1:0]  port_d_pmux_dir_o,
    output logic [PORT_D_DWIDTH-1:0]  port_d_pmux_out_o,
    output logic [PORT_D_DWIDTH-1:0]  port_d_pmux_en_o,
    input logic [PORT_D_DWIDTH-1:0]   port_d_pmux_in_i,
    
    output logic [PORT_E_DWIDTH-1:0]  port_e_pmux_dir_o,
    output logic [PORT_E_DWIDTH-1:0]  port_e_pmux_out_o,
    output logic [PORT_E_DWIDTH-1:0]  port_e_pmux_en_o,
    input logic [PORT_E_DWIDTH-1:0]   port_e_pmux_in_i,
    
    output logic [PORT_F_DWIDTH-1:0]  port_f_pmux_dir_o,
    output logic [PORT_F_DWIDTH-1:0]  port_f_pmux_out_o,
    output logic [PORT_F_DWIDTH-1:0]  port_f_pmux_en_o,
    input logic [PORT_F_DWIDTH-1:0]   port_f_pmux_in_i,
    
    output logic [PORT_G_DWIDTH-1:0]  port_g_pmux_dir_o,
    output logic [PORT_G_DWIDTH-1:0]  port_g_pmux_out_o,
    output logic [PORT_G_DWIDTH-1:0]  port_g_pmux_en_o,
    input logic [PORT_G_DWIDTH-1:0]   port_g_pmux_in_i,
    
    output logic [PORT_Z_DWIDTH-1:0]  port_z_pmux_dir_o,
    output logic [PORT_Z_DWIDTH-1:0]  port_z_pmux_out_o,
    output logic [PORT_Z_DWIDTH-1:0]  port_z_pmux_en_o,
    input logic [PORT_Z_DWIDTH-1:0]   port_z_pmux_in_i,

    // Interface to evo_i2c_ctrl (Avalon MM Slave)
    input logic [CSR_AWIDTH-1:0]      avs_csr_address,
    input logic                       avs_csr_read, 
    output logic                      avs_csr_waitresponse,
    output logic                      avs_csr_readdatavalid,
    output logic                      avs_csr_waitrequest,
    input logic                       avs_csr_write,
    input logic [CSR_DWIDTH-1:0]      avs_csr_writedata,
    output logic [CSR_DWIDTH-1:0]     avs_csr_readdata
    );       


   // CSR slave output from the evo_xb_info module
   logic                              avs_info_csr_readdatavalid;
   logic                              avs_info_csr_waitrequest;
   logic [CSR_DWIDTH-1:0]             avs_info_csr_readdata;
   
   // OR together the slave outputs of any CSR slaves
   always_comb avs_csr_readdatavalid = avs_info_csr_readdatavalid;
   always_comb avs_csr_waitrequest   = avs_info_csr_waitrequest;
   always_comb avs_csr_readdata      = avs_info_csr_readdata;

   // Example ORing of slave outputs for two XBs
   /*
   always_comb avs_csr_readdatavalid = avs_info_csr_readdatavalid |
                                       avs_custom_csr_readdatavalid;
   always_comb avs_csr_waitrequest   = avs_info_csr_waitrequest |
                                       avs_custom_csr_waitrequest;
   always_comb avs_csr_readdata      = avs_info_csr_readdata |
                                       avs_custom_csr_readdata;
    */
   
   // Tie off waitresponse. Not used.
   always_comb avs_csr_waitresponse  = 1'h0;

   
   //----------------------------------------------------------------------
   // Instance Name:  evo_xb_info_inst
   // Module Type:    evo_xb_info
   //
   //----------------------------------------------------------------------
   evo_xb_info
   evo_xb_info_inst
     (
      .clk                            (clk),
      .rstn                           (reset_n),
      // CSR bus (Avalon MM Slave)
      .avs_csr_address                (avs_csr_address),
      .avs_csr_read                   (avs_csr_read),
      .avs_csr_readdatavalid          (avs_info_csr_readdatavalid),
      .avs_csr_waitrequest            (avs_info_csr_waitrequest),
      .avs_csr_write                  (avs_csr_write),
      .avs_csr_writedata              (avs_csr_writedata),
      .avs_csr_readdata               (avs_info_csr_readdata)
      );

   
   //----------------------------------------------------------------------
   // Instance Name:  evo_xb_pmux_inst
   // Module Type:    evo_xb_pmux
   //
   //----------------------------------------------------------------------

   // How many PMUX inputs per port. If multiple XBs will be able
   // to control any one pin then these values should be adjusted
   // accordanly
   localparam PORT_D_PMUX_WIDTH = 1;
   localparam PORT_E_PMUX_WIDTH = 1;
   localparam PORT_F_PMUX_WIDTH = 1;
   localparam PORT_G_PMUX_WIDTH = 1;
   localparam PORT_Z_PMUX_WIDTH = 1;
   
   // Create input busses for port pmux inputs, setting width to be a
   // multiple of the PRT_DWIDTH for that port. The multiple is the
   // max number of XBs that want to contol a single pin in that port
   logic [(PORT_D_DWIDTH*PORT_D_PMUX_WIDTH)-1:0] port_d_pmux_dir_i,
                                                 port_d_pmux_out_i,
                                                 port_d_pmux_en_i;
   logic [(PORT_E_DWIDTH*PORT_E_PMUX_WIDTH)-1:0] port_e_pmux_dir_i,
                                                 port_e_pmux_out_i,
                                                 port_e_pmux_en_i;
   logic [(PORT_F_DWIDTH*PORT_F_PMUX_WIDTH)-1:0] port_f_pmux_dir_i,
                                                 port_f_pmux_out_i,
                                                 port_f_pmux_en_i;
   logic [(PORT_G_DWIDTH*PORT_G_PMUX_WIDTH)-1:0] port_g_pmux_dir_i,
                                                 port_g_pmux_out_i,
                                                 port_g_pmux_en_i;
   logic [(PORT_Z_DWIDTH*PORT_Z_PMUX_WIDTH)-1:0] port_z_pmux_dir_i,
                                                 port_z_pmux_out_i,
                                                 port_z_pmux_en_i;

   // Assign PMUX connections from XB modules to the desired ports and
   // pins. Width of these busses will always be in multiple of the
   // Port width.
   always_comb begin
      port_d_pmux_dir_i = 'h0;
      port_d_pmux_out_i = 'h0;
      port_d_pmux_en_i  = 'h0;
      port_e_pmux_dir_i = 'h0;
      port_e_pmux_out_i = 'h0;
      port_e_pmux_en_i  = 'h0;
      port_f_pmux_dir_i = 'h0;
      port_f_pmux_out_i = 'h0;
      port_f_pmux_en_i  = 'h0;
      port_g_pmux_dir_i = 'h0;
      port_g_pmux_out_i = 'h0;
      port_g_pmux_en_i  = 'h0;
      port_z_pmux_dir_i = 'h0;
      port_z_pmux_out_i = 'h0;
      port_z_pmux_en_i  = 'h0;
   end

   evo_xb_pmux
     #(
       .D_MUX_WIDTH (PORT_D_PMUX_WIDTH),
       .E_MUX_WIDTH (PORT_E_PMUX_WIDTH),
       .F_MUX_WIDTH (PORT_F_PMUX_WIDTH),
       .G_MUX_WIDTH (PORT_G_PMUX_WIDTH),
       .Z_MUX_WIDTH (PORT_Z_PMUX_WIDTH)
       )
   evo_xb_pmux_inst
     (// PMUX connections from XB/IP blocks
      .port_d_dir_i (port_d_pmux_dir_i),
      .port_d_out_i (port_d_pmux_out_i),
      .port_d_en_i  (port_d_pmux_en_i),
      .port_e_dir_i (port_e_pmux_dir_i),
      .port_e_out_i (port_e_pmux_out_i),
      .port_e_en_i  (port_e_pmux_en_i),
      .port_f_dir_i (port_f_pmux_dir_i),
      .port_f_out_i (port_f_pmux_out_i),
      .port_f_en_i  (port_f_pmux_en_i),
      .port_g_dir_i (port_g_pmux_dir_i),
      .port_g_out_i (port_g_pmux_out_i),
      .port_g_en_i  (port_g_pmux_en_i),
      .port_z_dir_i (port_z_pmux_dir_i),
      .port_z_out_i (port_z_pmux_out_i),
      .port_z_en_i  (port_z_pmux_en_i),
      // PMUX connections to ports
      .port_d_dir_o (port_d_pmux_dir_o),
      .port_d_out_o (port_d_pmux_out_o),
      .port_d_en_o  (port_d_pmux_en_o),
      .port_e_dir_o (port_e_pmux_dir_o),
      .port_e_out_o (port_e_pmux_out_o),
      .port_e_en_o  (port_e_pmux_en_o),
      .port_f_dir_o (port_f_pmux_dir_o),
      .port_f_out_o (port_f_pmux_out_o),
      .port_f_en_o  (port_f_pmux_en_o),
      .port_g_dir_o (port_g_pmux_dir_o),
      .port_g_out_o (port_g_pmux_out_o),
      .port_g_en_o  (port_g_pmux_en_o),
      .port_z_dir_o (port_z_pmux_dir_o),
      .port_z_out_o (port_z_pmux_out_o),
      .port_z_en_o  (port_z_pmux_en_o)
      );
   
   //======================================================================
   //
   // INSTANTIATE YOUR CUSTOM MODULES HERE
   //
   //======================================================================
   
   //----------------------------------------------------------------------
   // Instance Name:  evo_xb_custom_inst
   // Module Type:    evo_xb_custom
   //
   //   Example instantiation
   //----------------------------------------------------------------------
/*
   evo_xb_custom
     #(.CUSTOM_PARAMETER_1 (custom_value_1),
       .CUSTOM_PARAMETER_2 (custom_value_2)
       )
   evo_xb_info_inst
     (
      .clk                            (clk),
      .rstn                           (reset_n),
      // Insert custom I/O here
      .custom_input_1                 (custom_signal_i1),
      .custom_input_2                 (custom_signal_i2),
      .custom_output_1                (custom_signal_o1),
      .custom_output_2                (custom_signal_o2),
      
      // CSR bus (Avalon MM Slave)
      .avs_csr_address                (avs_csr_address),
      .avs_csr_read                   (avs_csr_read),
      .avs_csr_readdatavalid          (avs_custom_csr_readdatavalid),
      .avs_csr_waitrequest            (avs_custom_csr_waitrequest),
      .avs_csr_write                  (avs_csr_write),
      .avs_csr_writedata              (avs_csr_writedata),
      .avs_csr_readdata               (avs_custom_csr_readdata)
      );
*/

   
endmodule // evo_xb
