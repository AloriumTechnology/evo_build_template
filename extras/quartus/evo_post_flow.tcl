#==============================================================================
# Copyright (c) 2020 Alorium Technology.  All right reserved.
#==============================================================================
#
# File Name  : evo_post_flow.tcl
# Author     : Steve Phillips
# Contact    : support@aloriumtech.com
# Description:
#
# This script is specified in evo_common.qsf as the script to run
# after the Quartus compile has completed. It specified with the
# following command:
#
#    set_global_assignment -name POST_FLOW_SCRIPT_FILE quartus_sh:evo_post_flow.tcl
#
# In order for the above command to work, the script specified must be
# in the same directory as the Project file, so it must live in the XB
# library. The openevo_update.tcl script will create/update this file
# when run.
#
# This file simply sources the real scripts from the evo_bsp library.
#
# -------------------------------------------------------------------------- #

# Convert the SOF into POF, RDP and EVO_IMG formats
source ../../../evo_bsp/extras/tools/evo_convert_img.tcl
