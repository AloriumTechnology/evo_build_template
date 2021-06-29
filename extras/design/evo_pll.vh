//===========================================================================
//  Copyright(c) Alorium Technology Group Inc., 2020
//  ALL RIGHTS RESERVED
//===========================================================================
//
// File name:  : evo_pll.vh
// Author      : Steve Phillips
// Contact     : support@aloriumtech.com
// Description : 
//
// This file is used to define the PLL clock parameters for the CLK2
// and CLK3 ouputs of the PLL, which then can be used in the OpenEvo
// module if clocks other than the standard 60,120,16, or 32 MHz clocks are
// needed.
//
// See the following guide for detailed instructions on configuring the PLL:
//
// https://www.altera.com/content/dam/altera-www/global/en_US/pdfs/literature/ug/ug_altpll.pdf
//
// The directives as listed in the original version of this file from
// GitHub will set CLK2 to a 16MHz clock with a 0 degree phase shift
// and will set CLK3 to a 32MHz clock with a 0 degree phase shift.
//
// The Reference clock for the PLL is 12MHz. To generate a different
// clock, set the MULTIPLY and DIVIDE parameters to generate the clock
// desired, as calculated by this formula:
//
//    Desired Clock Rate = 12MHz * (MULTIPLY/DIVIDE)
//
// To shift the clock from a phase shift of zero to a new phase shift,
// specify a value, in picoseconds, of the desired phase shift in the
// PHASE_SHIFT parameter. To calculate a phase shift in picoseconds
// based on a desired phase shift in degrees, use the following
// formula:
//
//    Let: DCR = Desired Clock Rate
//         DSD = Desired Shift in Degrees
//        
//                    10**12       DSD
//    PHASE_SHIFT =  --------  *  -----
//                      DCR        360
//
// EXAMPLE: Generate a 120MHz clock with a 45% phase shift
// 
//    Desired Clock Rate = 120MHz = 12MHz * 10
//                                = 12MHz * (10/1)
//
//       Therefore: MULTIPLY = 10, DIVIDE   =  1
//
//
//                    10**12       DSD
//    PHASE_SHIFT =  --------  *  -----
//                      DCR        360
//
//                     10**12          45
//                =  -----------  *  -----
//                   120 * 10**6      360
//
//                    10**6   
//                =  ------- * 0.125
//                     120
//
//                = 1042 ps
// 
//===========================================================================

// Here are the default values for the clock outputs 2, 3, and 4. Modify the 
// values below to get your own custom clocks

// Create the clock called "clk_option2"
// The following creates a 16MHz clock with a 0 degree phase shift
localparam EVO_PLL_CLK2_DIVIDE_BY   = 3;
localparam EVO_PLL_CLK2_DUTY_CYCLE  = 50;
localparam EVO_PLL_CLK2_MULTIPLY_BY = 4;
localparam EVO_PLL_CLK2_PHASE_SHIFT = "0";

// Create the clock called "clk_option2"
// The following creates a 32MHz clock with a 0 degree phase shift
localparam EVO_PLL_CLK3_DIVIDE_BY   = 3;
localparam EVO_PLL_CLK3_DUTY_CYCLE  = 50;
localparam EVO_PLL_CLK3_MULTIPLY_BY = 8;
localparam EVO_PLL_CLK3_PHASE_SHIFT = "0";

// Create the clock called "clk_option4"
// The following creates a 12MHz clock with a 0 degree phase shift
localparam EVO_PLL_CLK4_DIVIDE_BY   = 1;
localparam EVO_PLL_CLK4_DUTY_CYCLE  = 50;
localparam EVO_PLL_CLK4_MULTIPLY_BY = 1;
localparam EVO_PLL_CLK4_PHASE_SHIFT = "0";


