onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Clock and Reset}
add wave -noupdate /tb_rtl_fillscreen/rst_n
add wave -noupdate /tb_rtl_fillscreen/clk
add wave -noupdate -divider {Start and Mask}
add wave -noupdate /tb_rtl_fillscreen/start
add wave -noupdate /tb_rtl_fillscreen/DUT/mask
add wave -noupdate -divider Done
add wave -noupdate /tb_rtl_fillscreen/done
add wave -noupdate -divider {VGA Coordinate}
add wave -noupdate -radix unsigned /tb_rtl_fillscreen/vga_y
add wave -noupdate -radix unsigned /tb_rtl_fillscreen/vga_x
add wave -noupdate /tb_rtl_fillscreen/vga_plot
add wave -noupdate -divider Colour
add wave -noupdate /tb_rtl_fillscreen/vga_colour
add wave -noupdate -divider {Loop Variable}
add wave -noupdate -radix unsigned /tb_rtl_fillscreen/index_x
add wave -noupdate -radix unsigned /tb_rtl_fillscreen/index_y
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {76787 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 218
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
WaveRestoreZoom {0 ps} {23 ps}
