vsim work.cpu
add wave -position end sim:/cpu/*
force -freeze sim:/cpu/clk 0 0, 1 {50 ps} -r 100
force -freeze sim:/cpu/rst 1 0
run
force -freeze sim:/cpu/rst 0 0
run
run
run -all