vlib work
vlog -f sourcefile.txt
vsim -voptargs=+accs work.UART_TX_tb
add wave *
add wave -position insertpoint  \
sim:/UART_TX_tb/DUT/m0/current_state
add wave -position insertpoint  \
sim:/UART_TX_tb/DUT/m2/data 
run -all