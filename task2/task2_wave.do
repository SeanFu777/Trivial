onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Start, Mask and Done}
add wave -noupdate /tb_rtl_task2/DUT/start
add wave -noupdate /tb_rtl_task2/DUT/mask
add wave -noupdate /tb_rtl_task2/DUT/done
add wave -noupdate -divider Coordinates
add wave -noupdate -radix hexadecimal /tb_rtl_task2/DUT/VGA_Y
add wave -noupdate -radix hexadecimal /tb_rtl_task2/DUT/VGA_X
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {15248 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 220
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {38383 ps} {38414 ps}
