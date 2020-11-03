#==============================================================================
# Copyright (c) 2020 Alorium Technology.  All right reserved.
#==============================================================================
#
# File Name  : evo_flashload.tcl
# Author     : Steve Phillips
# Contact    : support@aloriumtech.com
# Description:
#
#   This TCL script is meant to be used from the TCL console in the
#   Quartus gui to enable the evo_flashload program to be cross
#   platform. To run it in the gui, open the TCL Console by going to
#   View->Utility Windows->TCL Console. Then enter the following in
#   the TCL Console:
#
#      source evo_flashload.tcl
#
#   Or, to run it from a command line, use the following command:
#
#      On Windows or Linux:
#         quartus_sh -t evo_flashload.tcl
#
#      On macOS or Linux:
#         tclsh evo_flashload.tcl
#
#   The above command lines assume that the programs are in your
#   $PATH. For macOS and Linux this is usually the case, but for
#   Windows you may have to search to find it. For instance, it may be
#   located at a path like this:
#
#      C:\intelFPGA_lite\17.1\quartus\bin64\quartus_sh.exe
#
#   Note that evo_flashload is a Python3 program which is compiled for
#   Windows and macOS, but on Linux is run as a script. So, for Linux
#   you will need Python 3 installed and the pyserial package. The
#   pyserial package can be installed with the following command:
#
#      python3 -m pip install pyserial
#
#   You may need to use sudo for that command
#
#==============================================================================

puts "###########################################################################"
puts "# Start evo_flashload.tcl script"
puts "###########################################################################"

# Determine Windows or Linux
set OS [lindex $tcl_platform(os) 0]

if { $OS == "Windows" } {           # Windows
    puts "   Load evo_m51.evo_img to Evo FPGA"
    if { [file exists "|../../../evo_bsp/extras/tools/evo_flashload/windows/evo_flashload"] } {
        file rename "|../../../evo_bsp/extras/tools/evo_flashload/windows/evo_flashload" "|../../../evo_bsp/extras/tools/evo_flashload/windows/evo_flashload.exe"
    }
    if { [file exists "|../../../evo_bsp/extras/tools/evo_flashload/windows/bossac"] } {
        file rename "|../../../evo_bsp/extras/tools/evo_flashload/windows/bossac" "|../../../evo_bsp/extras/tools/evo_flashload/windows/bossac.exe"
    }
    set fload [open "|../../../evo_bsp/extras/tools/evo_flashload/windows/evo_flashload.exe -i reports/evo_m51.evo_img "  r]
    while { ![eof $fload]} {
        gets $fload fload_line
        puts $fload_line
    }
    close $fload
    flush stdout
    flush stdout
} elseif { $OS == "Darwin" } {        # macOS
    exec ../../../evo_bsp/extras/tools/evo_flashload/macosx/evo_flashload  \
        -i reports/evo_m51.evo_img
} else {                              # Linux
    exec ../../../evo_bsp/extras/tools/evo_flashload/evo_flashload.py  \
        -i reports/evo_m51.evo_img
}

puts "# End of evo_flashload.tcl"
puts "#--------------------------------------------------------------------------"
