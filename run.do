vlib work
#vlog top.sv +acc
vlog +define+BIGENDIAN top.sv
vsim top
#run -all
