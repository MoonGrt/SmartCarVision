onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib line_shift_ram_opt

do {wave.do}

view wave
view structure
view signals

do {line_shift_ram.udo}

run -all

quit -force
