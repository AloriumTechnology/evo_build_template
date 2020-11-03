#==============================================================================
# Copyright (c) 2020 Alorium Technology.  All right reserved.
#==============================================================================
#
# File Name  : evo_convert_img.tcl
# Author     : Steve Phillips
# Contact    : support@aloriumtech.com
# Description:
#
#  This script will be run after the Qusrtus compile completes. Currently
#  it performs the following actions:
#    1.) Converts SOF to POF and RPD formats
#    2.) Converts the RPD into EVO_IMG fdormat
#
#  The script assumes that it is called from a quartus directory in one of
#  the XBs, so the relative paths all reference up three levels to the
#  library dir and then back down into the approriate XB
#
#==============================================================================

puts "###########################################################################"
puts "# Start evo_convert_img.tcl script"
puts "###########################################################################"

# Determine Windows or Linux
set OS [lindex $tcl_platform(os) 0]

puts "#"
puts "# - Convert SOF to POF & RPD format"

exec quartus_cpf --convert evo.cof
post_message -type info "Convert Programming Files: POF and RPD files created"

puts "# - Convert the RPD file to an EVO_IMG format"

if { $OS == "Windows" } {
    # We have to be in the evo_flashload dir to run it
    cd ../../../evo_bsp/extras/tools/evo_flashload/windows
    if { [file exists "evo_flashload"] } {
        file rename "evo_flashload" "evo_flashload.exe"
    }
    if { [file exists "bossac"] } {
        file rename "bossac" "bossac.exe"
    }
    exec ./evo_flashload.exe --convert \
        -i  ../../../../../evo_build/extras/quartus/reports/evo_m51_cfm1_auto.rpd \
        -o ../../../../../evo_build/extras/quartus/reports/evo_m51.evo_img
    # Return to the evo_build quartus dir
    cd  ../../../../../evo_build/extras/quartus/
} else { # Linux
    cd ../../../evo_bsp/extras/tools/evo_flashload
    exec python3 ./evo_flashload.py --convert \
        -i  ../../../../evo_build/extras/quartus/reports/evo_m51_cfm1_auto.rpd \
        -o ../../../../evo_build/extras/quartus/reports/evo_m51.evo_img
    # Return to the evo_build quartus dir
    cd  ../../../../evo_build/extras/quartus/
}
post_message -type info "Evo Convert Image: EVO_IMG file created"

puts "# End of evo_convert_img.tcl"
puts "#--------------------------------------------------------------------------"
