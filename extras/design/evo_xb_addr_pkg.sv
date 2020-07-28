//=================================================================
//  Copyright(c) Alorium Technology Group Inc., 2020
//  ALL RIGHTS RESERVED
//=================================================================
//
// File name:  : evo_build/extras/design/evo_xb_addr_pkg.sv
// Author      : Steve Phillips
// Contact     : support@aloriumtech.com
// Description : 
//
// This package file is used to define addresses for the OpenEvo 
// XB impementations. Each OpenEvo implementation has a unique 
// version of this file.
//
// IMPORTANT: To avoid possible conflicts with the BSP address space, 
//
//            == USE ADDRESSES GREATER THAN 12'h800 ==
//
//

`ifndef _EVO_XB_ADDR_PKG_DONE 
  `define _EVO_XB_ADDR_PKG_DONE // set flag that pkg already included 

package evo_xb_addr_pkg; 
   // Here is where you add your parameter defintions for the addresses 
   // needed to access the CSR regs in the OpenEvo implementation.
   //
   //            == USE ADDRESSES GREATER THAN 12'h800 ==
   //
   // For example:
   // parameter EVO_SERVO_CTL_ADDR = 12'h8AA;

endpackage 

   // import into $UNIT 
   import evo_xb_addr_pkg::*; 

`endif 
   
