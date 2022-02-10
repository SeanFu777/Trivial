/*==========================================================================
This is a simple post-syns testbench for the module circle. This module is 
modified based on the rtl testbench where internal signals have been ignored.
It will draw a circle at
(157, 117) with a radius of 3. Then, we will wait till it finishes again then 
dessert start.
===========================================================================*/
`timescale 1 ps / 1 ps
module tb_syn_circle();


logic clk, rst_n, start, done, vga_plot, err;
logic [2:0] colour, vga_colour;
logic [7:0] vga_x;
logic [6:0] vga_y;
logic [7:0] centre_x;
logic [6:0] centre_y;
logic [7:0] radius;


circle DUT     (    
                   clk,   rst_n, colour,
                   centre_x, centre_y, radius,
                   start, done,
                   vga_x, vga_y,
                   vga_colour,  vga_plot
                );

initial forever #1 clk = ! clk;

initial begin
clk = 1; rst_n = 0; err =0;
start = 0;   radius = 3;
centre_x = 157; centre_y = 117; #2; //set up
rst_n = 1; #2;
start = 1; #4;

assert(vga_x == centre_x  && vga_y == centre_y + radius && vga_plot == 0 )
$display("Check: Octant 2   Passed at %d",$time);
else begin $display("Check: Octant 2 Failed at %d",$time); end #2;

assert(vga_x == centre_x  && vga_y == centre_y + radius && vga_plot == 0)
$display("Check: Octant 3   Passed at %d",$time);
else begin $display("Check: Octant 3 Failed at %d",$time); end #2;

assert(vga_x == centre_x -radius && vga_y == centre_y  && vga_plot == 1)
$display("Check: Octant 4   Passed at %d",$time);
else begin $display("Check: Octant 4 Failed at %d",$time); end #2;

assert(vga_x == centre_x -radius && vga_y == centre_y  && vga_plot == 1)
$display("Check: Octant 5   Passed at %d",$time);
else begin $display("Check: Octant 5 Failed at %d",$time); end #2;

assert(vga_x == centre_x  && vga_y == centre_y-radius  && vga_plot == 1)
$display("Check: Octant 6   Passed at %d",$time);
else begin $display("Check: Octant 6 Failed at %d",$time); end #2;

assert(vga_x == centre_x  && vga_y == centre_y-radius  && vga_plot == 1)
$display("Check: Octant 7   Passed at %d",$time);
else begin $display("Check: Octant 7  Failed at %d",$time); end #2;

assert(vga_x == centre_x + radius && vga_y == centre_y && vga_plot == 0)
$display("Check: Octant 1/8 Passed at %d",$time);
else begin $display("Check: Octant 1/8 Failed at %d",$time); end #2;

assert(vga_x == centre_x + radius && vga_y == centre_y + 1 && vga_plot == 0)
$display("Check: Octant 1   Passed at %d",$time);
else begin $display("Check: Octant 1   Failed at %d",$time); end 

#34;
assert(done == 1)
$display("Check: Halting_1  Passed at %d",$time);
else begin $display("Check: Halting_1 Failed at %d",$time); end 
start = 0; #2;

assert(done == 0)
$display("Check: Halting_2  Passed at %d",$time);
else begin $display("Check: Halting_2 Failed at %d",$time); end 
$stop;

end

endmodule: tb_syn_circle
