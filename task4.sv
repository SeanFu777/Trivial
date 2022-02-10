
module task4(input logic CLOCK_50, input logic [3:0] KEY,
             input logic [9:0] SW, output logic [9:0] LEDR,
             output logic [6:0] HEX0, output logic [6:0] HEX1, output logic [6:0] HEX2,
             output logic [6:0] HEX3, output logic [6:0] HEX4, output logic [6:0] HEX5,
             output logic [7:0] VGA_R, output logic [7:0] VGA_G, output logic [7:0] VGA_B,
             output logic VGA_HS, output logic VGA_VS, output logic VGA_CLK,
             output logic [7:0] VGA_X, output logic [6:0] VGA_Y,
             output logic [2:0] VGA_COLOUR, output logic VGA_PLOT);

`define fillScreen  3'b000
`define DrawCircle  3'b001
`define Stop        3'b010

logic [2:0] colour, state;
logic start_fillScreen, start_circle, done_circle, done_fillScreen;
logic VGA_BLANK, VGA_SYNC;
logic [7:0] centre_x, radius;
logic [6:0] centre_y;

logic [7:0] diameter;
assign diameter = radius;

logic  [7:0] VGA_X_circle,VGA_X_fillScreen;
logic  [6:0] VGA_Y_circle,VGA_Y_fillScreen;
logic  [2:0] VGA_COLOUR_circle, VGA_COLOUR_fillScreen;
logic VGA_PLOT_circle, VGA_PLOT_fillScreen;

 reuleaux    triangle (.clk(CLOCK_50), 
                       .rst_n(KEY[3]),
                       .colour(colour),
                       .centre_x(centre_x), 
                       .centre_y(centre_y), 
                       .diameter(radius),
                       .start(start_circle), 
                       .done(done_circle),
                       .vga_x(VGA_X_circle), 
                       .vga_y(VGA_Y_circle),
                       .vga_colour(VGA_COLOUR_circle), 
                       .vga_plot(VGA_PLOT_circle)
                       );

 fillscreen t3b  ( 
                  .clk(CLOCK_50), 
                  .rst_n(KEY[3]), 
                  .colour(colour),
                  .start(start_fillScreen), 
                  .done(done_fillScreen),
                  .vga_x(VGA_X_fillScreen), 
                  .vga_y(VGA_Y_fillScreen),
                  .vga_colour(VGA_COLOUR_fillScreen),
                  .vga_plot(VGA_PLOT_fillScreen)
                );

vga_adapter#(.RESOLUTION("160x120")) vga_u0
                                            (.resetn(KEY[3]), .clock(CLOCK_50), .colour(VGA_COLOUR),
                                            .x(VGA_X), .y(VGA_Y), .plot(VGA_PLOT),
                                            .VGA_R(VGA_R), .VGA_G(VGA_G), .VGA_B(VGA_B),
                                            .*);

always_ff @( posedge CLOCK_50 ) begin
    if(!KEY[3]) {start_fillScreen, start_circle, radius, centre_x, centre_y, state} ={1'b0, 1'b0, 8'd40, 8'd80, 7'd60, 3'b0};
    else case(state)
         `fillScreen: {state, start_fillScreen ,start_circle} = (!done_fillScreen) ? {`fillScreen, 1'b1, 1'b0}:{`DrawCircle, 1'b0, 1'b1};
         `DrawCircle: {state, start_fillScreen ,start_circle} = (!done_circle)     ? {`DrawCircle, 1'b0, 1'b1}:{`Stop, 1'b0, 1'b0};
         `Stop      : {state, start_fillScreen ,start_circle} = {`Stop, 1'b0, 1'b0};
    endcase
end

always_comb begin 
    case(state)
    `fillScreen: {VGA_X,VGA_Y,VGA_COLOUR,VGA_PLOT} = {VGA_X_fillScreen, VGA_Y_fillScreen, VGA_COLOUR_fillScreen, VGA_PLOT_fillScreen};
    `DrawCircle: {VGA_X,VGA_Y,VGA_COLOUR,VGA_PLOT} = {VGA_X_circle    , VGA_Y_circle,     3'b010               , VGA_PLOT_circle};
    default: {VGA_X,VGA_Y,VGA_COLOUR,VGA_PLOT}     = 20'bz;
    endcase
end
endmodule



module fillscreen(input logic clk, input logic rst_n, input logic [2:0] colour,
                  input logic start, output logic done,
                  output logic [7:0] vga_x, output logic [6:0] vga_y,
                  output logic [2:0] vga_colour, output logic vga_plot);

logic mask;
logic [7:0] new_x;
assign new_x = vga_x + 1; 
always_ff @(posedge clk) begin 
     if(!rst_n) {mask, done, vga_x, vga_y, vga_colour, vga_plot} = {1'b0, 1'b0, 8'b0, 7'b0, 3'b0, 1'b0}; //Reset State
     else 
          if({start, mask} == {2'b10} && !done)  {mask, done, vga_x, vga_y, vga_colour, vga_plot} = {1'b1, 1'b0, 8'b0, 7'b0, 3'b0, 1'b1};// Start State
          else if({start, done} == 2'b01) done = 0;
               else if({start,mask} == 2'b11 && !done) //Start Filling in the Pixels
                         if(vga_x >= 8'd159 && vga_y >=7'd119){done, vga_plot, mask} = {1'b1, 1'b0, 1'b0}; // Finished State
                         else if(vga_y >= 7'd119 && vga_x!==8'd159 ) {vga_y, vga_x, vga_colour} = {7'b0, new_x, 3'b000}; //Increment X-coordinate if x is not the last coloumn
                              else if(vga_x!==8'd159) {vga_y, vga_colour} = {(vga_y+7'b1),  3'b000 }; //Increment Y-coordinate if x is not the last coloumn
                                   else if (vga_y < 7'd119){vga_y, vga_colour} = {(vga_y+7'b1),  3'b000 };//Increment Y-coordinate if x is the last coloumn
     end
endmodule
