/*==========================================================================
This is a simple post -syns testbench for the module circle. It is modified
based on the rtl tb where all internal signals are removed. It will draw a reuleaux
triangle at (40, 80) with a radius of 3. We will check several imprtant signals
to make sure the state transition is w0rking properly. Check the termianls
during tuntime for more details
===========================================================================*/
`timescale 1 ps / 1 ps
module tb_syn_reuleaux();
logic clk, rst_n, start, done, vga_plot, err;
logic [2:0] colour, vga_colour;
logic [7:0] vga_x;
logic [6:0] vga_y;
logic [7:0] centre_x;
logic [6:0] centre_y;
logic [7:0] diameter;

reuleaux  DUT   ( 
                  clk,  rst_n,   colour,
                  centre_x,   centre_y,   diameter,
                  start,  done,
                  vga_x,   vga_y,
                  vga_colour,  vga_plot
                );

initial forever #1 clk = ! clk;

initial begin
    
    clk = 1; rst_n = 0; err =0;
    start = 0; diameter = 3;
    centre_x = 40; centre_y = 80; #2; //set up
    rst_n = 1; #2;
    start = 1; #1;
    
    assert( vga_x == 38 && vga_y == 81 && vga_plot==0 )
    $display("Check: OCT5+6_1 Passed at %d ps", $time);
    else begin $display("Check: OCT5+6_1 Failed at %d ps", $time); err =1; end

    #10;
    assert( vga_x == 40 && vga_y == 78 && vga_plot==1 &&  DUT.start_C2==1)
    $display("Check: OCT5+6_2 Passed at %d ps", $time);
    else begin $display("Check: OCT5+6_2 Failed at %d ps", $time); err =1; end

    #10;
    assert( vga_x == 39 && vga_y == 78 && vga_plot==0 )
    $display("Check: OCT7+8_1 Passed at %d ps", $time);
    else begin $display("Check: OCT7+8_1 Failed at %d ps", $time); err =1; end #1;

    #15;
    assert( vga_x == 42 && vga_y == 80 && vga_plot==1 )
    $display("Check: OCT7+8_2 Passed at %d ps", $time);
    else begin $display("Check: OCT7+8_2 Failed at %d ps", $time); err =1; end #6;

    assert(vga_x == 40 && vga_y == 81 && vga_plot==1 )
    $display("Check: OCT2+3_1 Passed at %d ps", $time);
    else begin $display("Check: OCT2+3_1 Failed at %d ps", $time); err =1; end 
    
    #25;
    assert( vga_plot!==1 && done ==1)
    $display("Check: Halting  Passed at %d ps", $time);
    else begin $display("Check: Halting   Failed at %d ps", $time); err =1; end 
    #30;
    $stop;
end

endmodule: tb_syn_reuleaux
