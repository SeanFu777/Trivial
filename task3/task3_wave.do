onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Clock and Reset}
add wave -noupdate /tb_rtl_task3/DUT/CLOCK_50
add wave -noupdate {/tb_rtl_task3/DUT/KEY[3]}
add wave -noupdate -divider {Circle Dimensions}
add wave -noupdate -radix unsigned /tb_rtl_task3/DUT/radius
add wave -noupdate -radix unsigned /tb_rtl_task3/DUT/centre_y
add wave -noupdate -radix unsigned /tb_rtl_task3/DUT/centre_x
add wave -noupdate /tb_rtl_task3/DUT/state
add wave -noupdate /tb_rtl_task3/DUT/state
add wave -noupdate -divider {Fill Screen}
add wave -noupdate -radix unsigned /tb_rtl_task3/DUT/VGA_Y_fillScreen
add wave -noupdate -radix unsigned /tb_rtl_task3/DUT/VGA_X_fillScreen
add wave -noupdate -radix unsigned /tb_rtl_task3/DUT/VGA_PLOT_fillScreen
add wave -noupdate -radix unsigned /tb_rtl_task3/DUT/VGA_COLOUR_fillScreen
add wave -noupdate -divider {Draw Circle}
add wave -noupdate -radix unsigned /tb_rtl_task3/DUT/VGA_Y_circle
add wave -noupdate -radix unsigned /tb_rtl_task3/DUT/VGA_X_circle
add wave -noupdate -radix unsigned /tb_rtl_task3/DUT/VGA_PLOT_circle
add wave -noupdate -radix unsigned /tb_rtl_task3/DUT/VGA_COLOUR_circle
add wave -noupdate /tb_rtl_task3/DUT/t3a/present_state
add wave -noupdate -divider {Start Signals}
add wave -noupdate /tb_rtl_task3/DUT/start_fillScreen
add wave -noupdate /tb_rtl_task3/DUT/start_circle
add wave -noupdate -divider {Done Signals}
add wave -noupdate /tb_rtl_task3/DUT/done_fillScreen
add wave -noupdate /tb_rtl_task3/DUT/done_circle
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {4 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {38 ps}
