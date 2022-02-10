/*======================================================================
Module Task 2:
We connnect and instatntiate two sub-modules inside task 2 which are 
fillscreen and vga_adapter. A simple FSm is added to control when
the fillscreen module is active.
======================================================================*/
module task2(input logic CLOCK_50, input logic [3:0] KEY,
             input logic [9:0] SW, output logic [9:0] LEDR,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [7:0] VGA_R, output logic [7:0] VGA_G, output logic [7:0] VGA_B,
             output logic VGA_HS, output logic VGA_VS, output logic VGA_CLK,
             output logic [7:0] VGA_X, output logic [6:0] VGA_Y,
             output logic [2:0] VGA_COLOUR, output logic VGA_PLOT);

logic  [2:0] colour;
logic start, done, mask;
logic VGA_BLANK, VGA_SYNC;

 fillscreen t2  ( 
                  .clk(CLOCK_50), 
                  .rst_n(KEY[3]), 
                  .colour(colour),
                  .start(start), 
                  .done(done),
                  .vga_x(VGA_X), 
                  .vga_y(VGA_Y),
                  .vga_colour(VGA_COLOUR),
                  .vga_plot(VGA_PLOT)
                );

vga_adapter#(.RESOLUTION("160x120")) vga_u0
                                            (.resetn(KEY[3]), .clock(CLOCK_50), .colour(VGA_COLOUR),
                                            .x(VGA_X), .y(VGA_Y), .plot(VGA_PLOT),
                                            .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B),
                                            .*);

always_ff @( posedge CLOCK_50 ) begin
    if(!KEY[3]) {start,mask} = 2'b00; //reset state; everything should be off 
    else if( {start, done, mask} == 3'b0 ) {start,mask}=2'b11; //if everything is off, that means we just assert rest; thus we should start to fill the screen
         else if({start,done}==2'b11) {start,mask} = 2'b00; //if done is high, that means all pixles have been plotted, so we shoulkd de-assert start
              else if({start,mask} == 2'b01) start =0; // if start is 0 while mask is 1 that means we have finished the task
                   else if({start,mask} == 2'b11) start =1 ;//if done is not high while mask is high that means we are still plotting
                         else start =0;// just in case; default statement
end
endmodule: task2
