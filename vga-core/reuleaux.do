onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {coordinates + diameter}
add wave -noupdate -radix unsigned /tb_rtl_reuleaux/DUT/centre_x
add wave -noupdate -radix unsigned /tb_rtl_reuleaux/DUT/centre_y
add wave -noupdate -radix unsigned /tb_rtl_reuleaux/DUT/diameter
add wave -noupdate -divider Clock
add wave -noupdate /tb_rtl_reuleaux/DUT/clk
add wave -noupdate -divider State
add wave -noupdate /tb_rtl_reuleaux/DUT/state
add wave -noupdate -divider {Reset, Start, and Done}
add wave -noupdate /tb_rtl_reuleaux/DUT/done
add wave -noupdate /tb_rtl_reuleaux/DUT/rst_n
add wave -noupdate /tb_rtl_reuleaux/DUT/start
add wave -noupdate -divider {VGA Outputs}
add wave -noupdate /tb_rtl_reuleaux/DUT/vga_colour
add wave -noupdate /tb_rtl_reuleaux/DUT/vga_plot
add wave -noupdate -radix unsigned /tb_rtl_reuleaux/DUT/vga_x
add wave -noupdate -radix unsigned /tb_rtl_reuleaux/DUT/vga_y
add wave -noupdate -divider {Sub-module Start + Done}
add wave -noupdate /tb_rtl_reuleaux/DUT/start_C1
add wave -noupdate /tb_rtl_reuleaux/DUT/start_C3
add wave -noupdate /tb_rtl_reuleaux/DUT/done_C1
add wave -noupdate /tb_rtl_reuleaux/DUT/done_C2
add wave -noupdate /tb_rtl_reuleaux/DUT/done_C3
add wave -noupdate -divider {Left Vertex}
add wave -noupdate /tb_rtl_reuleaux/DUT/vertex_left_x
add wave -noupdate /tb_rtl_reuleaux/DUT/vertex_left_y
add wave -noupdate -divider {Right Vertex}
add wave -noupdate /tb_rtl_reuleaux/DUT/vertex_right_x
add wave -noupdate /tb_rtl_reuleaux/DUT/vertex_right_y
add wave -noupdate -divider {Top Vertex}
add wave -noupdate /tb_rtl_reuleaux/DUT/vertex_top_x
add wave -noupdate /tb_rtl_reuleaux/DUT/vertex_top_y
add wave -noupdate -divider Output
add wave -noupdate -radix decimal /tb_rtl_reuleaux/vga_plot
add wave -noupdate -radix unsigned /tb_rtl_reuleaux/vga_x
add wave -noupdate -radix unsigned /tb_rtl_reuleaux/vga_y
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {15 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 225
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
WaveRestoreZoom {988 ps} {1017 ps}
