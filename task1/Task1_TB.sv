`timescale 1 ps / 1 ps

module task1_tb();

logic clk;
logic [3:0] KEY;
logic [9:0] SW;

logic [7:0] VGA_B, VGA_G, VGA_R;
logic VGA_HS, VGA_VS, VGA_CLK;
logic [7:0] VGA_X;
logic [6:0] VGA_Y;
logic [2:0] VGA_COLOUR;
logic VGA_PLOT;

 vga_demo DUT   (
                 CLOCK_50,  KEY,  SW,
                 VGA_R,  VGA_G,  VGA_B,
                 VGA_HS,  VGA_VS,  VGA_CLK,
                 VGA_X,  VGA_Y,
                 VGA_COLOUR,  VGA_PLOT
                );

initial forever #5 clk = !clk;



initial begin
    clk = 0; 
    SW[4:0] = 5'd10; 
    SW[9:5] = 5'd6;
    KEY[0]  = 0; 
    #5;
    KEY[0] = 1;

    #1000000;
    $stop;

end
endmodule