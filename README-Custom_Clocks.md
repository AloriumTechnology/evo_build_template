OpenEvo Custom Clocks
======================================================================

The OpenEvo custom clock support is similar to the OpenXLR8 custom
clock support, but there are some differences.

The basic concept is the same:
- The PLL IP block has been modified so that we can pass in parameters
  to define the ?extra? clock taps. The PLL has five clock taps and
  three are customizable.
- The extra clocks are set to default values:
  - PLL_CLK2 = 16MHz
  - PLL_CLK3 = 32MHz
  - PLL_CLK4 = 12MHz 
- The user can set custom values for each of these ?extra?
  clocks. Each has four values that specify the clock being generated:
  - Multiply
  - Divide
  - Duty Cycle
  - Phase Shift

For the OpenXLR8 these values were set in the extras/rtl/pll16.vh
file.

For the OpenEvo these values are set in the
extras/quartus/openevo.qsf. In the
evo_build_template/extras/quartus/openevo.qsf file the following lines
will be found:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
#---------------------------------------------------------------------
# Change the values below to create alterative, custom clocks from the
#  PLL, which are then available for use in the evo_xb.sv module.

# PLL_CLK2: Default setting create a 16MHz clock
set_parameter -name  EVO_PLL_CLK2_DIVIDE_BY    3
set_parameter -name  EVO_PLL_CLK2_DUTY_CYCLE   50
set_parameter -name  EVO_PLL_CLK2_MULTIPLY_BY  4
set_parameter -name  EVO_PLL_CLK2_PHASE_SHIFT  "0"

# PLL_CLK3: Default setting create a 32MHz clock
set_parameter -name  EVO_PLL_CLK3_DIVIDE_BY    3
set_parameter -name  EVO_PLL_CLK3_DUTY_CYCLE   50
set_parameter -name  EVO_PLL_CLK3_MULTIPLY_BY  8
set_parameter -name  EVO_PLL_CLK3_PHASE_SHIFT  "0"

# PLL_CLK4: Default setting create a 12MHz clock
set_parameter -name  EVO_PLL_CLK4_DIVIDE_BY    1
set_parameter -name  EVO_PLL_CLK4_DUTY_CYCLE   50
set_parameter -name  EVO_PLL_CLK4_MULTIPLY_BY  1
set_parameter -name  EVO_PLL_CLK4_PHASE_SHIFT  "0"
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If these lines are not in your openevo.qsf, then they should be
added. The values for each of the clocks can be modified to change the
frequency, duty cycle and phase.

One way to determine good values for the clocks is to load your design
into quartus and do the following:
- Load your OpenEvo design into quartus 
- In the Hierarchy browser, navigate into the design:
  evo_top->evo_core->evo_clkrst
- In the evo_clkrst, double-click on the alt_pll:alt_pll_inst
- This will open the MegaWizard for the ALTPLL
- Click on tab 3: Output Clocks
- Click on ?Enter output clock parameters?
- Here you can try different values for Multiply and Divide and see
  what the MegaWizard will do.

For instance, change the frequency specified for the Requested
Settings and you will see what settings the MegaWizard will use to
generate that. Since we opened the wizard from inside our design, it
already knows the input clock frequency (12MHz) and will take that
into account.

Make sure you Cancel out of the wizard to avoid making any
unintended changes to the IP

Adapting older XBs
======================================================================

Part of the change involved a couple of minor changes to the port list
of the evo_xb.sv module. The following changes were made:

| Original Port | New Port |
|:-------------:|:--------:|
| clk_16        | pll_clk2 |
| clk_32        | pll_clk3 |
| -             | pll_clk4 |
| en16mhz       | en20mhz  |


The pll_clk2 and pll_clk3 still default to 16 and 32 MHz. The pll_clk4
didn?t exist in the original version and is a new signal.

The en16mhz has been replaced by the en20mhz. It now has a pulse at a
20MHz rate, rather than the 16MHz rate. This signal is used in the I2C
module and is provided in the evo_xb just because it already
existed. We don't think any XBs actually use it so it shouldn?t effect
any of them.

The user has two options:
- Modify your evo_xb.sv to include these port changes. Should be a
  simple change
- Add the following line to your openevo.qsf and then the old signal
  names will be used
  - set_global_assignment -name VERILOG_MACRO "EVO_CLK_ORIGINAL=1"

