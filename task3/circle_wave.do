onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Start, Reset and Done}
add wave -noupdate /tb_rtl_circle/start
add wave -noupdate /tb_rtl_circle/DUT/mask
add wave -noupdate /tb_rtl_circle/rst_n
add wave -noupdate /tb_rtl_circle/done
add wave -noupdate -divider Clock
add wave -noupdate /tb_rtl_circle/clk
add wave -noupdate -divider Circle
add wave -noupdate -radix decimal /tb_rtl_circle/radius
add wave -noupdate -radix unsigned /tb_rtl_circle/centre_y
add wave -noupdate -radix unsigned /tb_rtl_circle/centre_x
add wave -noupdate -divider Coordinats
add wave -noupdate -radix unsigned /tb_rtl_circle/vga_y
add wave -noupdate -radix unsigned /tb_rtl_circle/vga_x
add wave -noupdate /tb_rtl_circle/vga_plot
add wave -noupdate -divider State
add wave -noupdate /tb_rtl_circle/DUT/present_state
add wave -noupdate -divider Offsets
add wave -noupdate -radix decimal /tb_rtl_circle/DUT/crit
add wave -noupdate -radix decimal /tb_rtl_circle/DUT/offset_x
add wave -noupdate -radix decimal /tb_rtl_circle/DUT/offset_y
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {69 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 184
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
WaveRestoreZoom {58 ps} {75 ps}
