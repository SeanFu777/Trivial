onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Left Vertix}
add wave -noupdate -radix unsigned /tb_rtl_task4/DUT/triangle/vertex_left_x
add wave -noupdate -radix unsigned /tb_rtl_task4/DUT/triangle/vertex_left_y
add wave -noupdate -divider {Right Vertix}
add wave -noupdate -radix unsigned /tb_rtl_task4/DUT/triangle/vertex_right_x
add wave -noupdate -radix unsigned -childformat {{{/tb_rtl_task4/DUT/triangle/vertex_right_y[6]} -radix unsigned} {{/tb_rtl_task4/DUT/triangle/vertex_right_y[5]} -radix unsigned} {{/tb_rtl_task4/DUT/triangle/vertex_right_y[4]} -radix unsigned} {{/tb_rtl_task4/DUT/triangle/vertex_right_y[3]} -radix unsigned} {{/tb_rtl_task4/DUT/triangle/vertex_right_y[2]} -radix unsigned} {{/tb_rtl_task4/DUT/triangle/vertex_right_y[1]} -radix unsigned} {{/tb_rtl_task4/DUT/triangle/vertex_right_y[0]} -radix unsigned}} -subitemconfig {{/tb_rtl_task4/DUT/triangle/vertex_right_y[6]} {-height 15 -radix unsigned} {/tb_rtl_task4/DUT/triangle/vertex_right_y[5]} {-height 15 -radix unsigned} {/tb_rtl_task4/DUT/triangle/vertex_right_y[4]} {-height 15 -radix unsigned} {/tb_rtl_task4/DUT/triangle/vertex_right_y[3]} {-height 15 -radix unsigned} {/tb_rtl_task4/DUT/triangle/vertex_right_y[2]} {-height 15 -radix unsigned} {/tb_rtl_task4/DUT/triangle/vertex_right_y[1]} {-height 15 -radix unsigned} {/tb_rtl_task4/DUT/triangle/vertex_right_y[0]} {-height 15 -radix unsigned}} /tb_rtl_task4/DUT/triangle/vertex_right_y
add wave -noupdate -divider {Top Vertix}
add wave -noupdate -radix unsigned /tb_rtl_task4/DUT/triangle/vertex_top_x
add wave -noupdate -radix unsigned /tb_rtl_task4/DUT/triangle/vertex_top_y
add wave -noupdate -divider {Triangle Center}
add wave -noupdate -radix unsigned /tb_rtl_task4/DUT/triangle/centre_x
add wave -noupdate -radix unsigned /tb_rtl_task4/DUT/triangle/centre_y
add wave -noupdate -divider {Octant 3 Left_Bottom}
add wave -noupdate -radix decimal /tb_rtl_task4/DUT/triangle/OCT23/Octant_3_Y
add wave -noupdate -radix decimal /tb_rtl_task4/DUT/triangle/OCT23/Octant_3_X
add wave -noupdate -divider {OCT2 Right Bottom}
add wave -noupdate /tb_rtl_task4/DUT/triangle/OCT23/Octant_2_Y
add wave -noupdate /tb_rtl_task4/DUT/triangle/OCT23/Octant_2_X
add wave -noupdate -divider {OCT 2 and 3}
add wave -noupdate /tb_rtl_task4/DUT/triangle/OCT23/offset_y
add wave -noupdate /tb_rtl_task4/DUT/triangle/OCT23/offset_x
add wave -noupdate /tb_rtl_task4/DUT/triangle/OCT23/centre_y
add wave -noupdate /tb_rtl_task4/DUT/triangle/OCT23/centre_x
add wave -noupdate -divider {Octant 5 Left_Bottom}
add wave -noupdate -radix decimal /tb_rtl_task4/DUT/triangle/OCT56/Octant_5_Y
add wave -noupdate -radix decimal /tb_rtl_task4/DUT/triangle/OCT56/Octant_5_X
add wave -noupdate -divider {OCT 2 and 3}
add wave -noupdate -radix unsigned /tb_rtl_task4/DUT/triangle/vga_x_C1
add wave -noupdate -radix unsigned /tb_rtl_task4/DUT/triangle/vga_y_C1
add wave -noupdate /tb_rtl_task4/DUT/triangle/vga_plot_C1
add wave -noupdate -divider {OCT 5 and 6}
add wave -noupdate -radix unsigned /tb_rtl_task4/DUT/triangle/vga_y_C2
add wave -noupdate -radix unsigned /tb_rtl_task4/DUT/triangle/vga_x_C2
add wave -noupdate /tb_rtl_task4/DUT/triangle/vga_plot_C2
add wave -noupdate -divider {Fixed Point}
add wave -noupdate /tb_rtl_task4/DUT/triangle/sqrt3DIV6
add wave -noupdate /tb_rtl_task4/DUT/triangle/sqrt3DIV3
add wave -noupdate -divider Dimensions
add wave -noupdate /tb_rtl_task4/DUT/triangle/diameter
add wave -noupdate /tb_rtl_task4/DUT/triangle/centre_y
add wave -noupdate /tb_rtl_task4/DUT/triangle/centre_x
add wave -noupdate /tb_rtl_task4/DUT/triangle/temp_diameter_sqrtDIV6
add wave -noupdate /tb_rtl_task4/DUT/triangle/temp_diameter_sqrtDIV3
add wave -noupdate /tb_rtl_task4/DUT/state
add wave -noupdate /tb_rtl_task4/DUT/start_fillScreen
add wave -noupdate /tb_rtl_task4/DUT/start_circle
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {13 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 155
configure wave -valuecolwidth 130
configure wave -justifyvalue left
configure wave -signalnamewidth 1
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
WaveRestoreZoom {0 ps} {102 ps}
