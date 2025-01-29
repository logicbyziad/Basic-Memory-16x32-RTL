vlib work
vlog memory16x32.v memory16x32_tb.v
vsim -voptargs=+acc work.memory16x32_tb
add wave *
run -all
##quit -sim