/*======================================================================
MODULE FILLSCREEN:
A SIMPLE CIRCUIT THAT FILLS THE REDUCED-VGA SCREEN. EACH COLUMN HAS A 
DIFFERENT COULOUR (REPEATING EVERY EIGHT COLUMNS).
======================================================================*/
module fillscreen(input logic clk, input logic rst_n, input logic [2:0] colour,
                  input logic start, output logic done,
                  output logic [7:0] vga_x, output logic [6:0] vga_y,
                  output logic [2:0] vga_colour, output logic vga_plot);

logic mask;
logic [7:0] new_x; assign new_x = vga_x + 1; //combinational logic used to compute the next x-coordinate
/*======================================================================
Signal - mask:
To ensure there is a dedicated state right after "start" is pressed, 
and before the module starts to fill in the pixels
======================================================================*/
always_ff @(posedge clk) begin 
     if(!rst_n) {mask, done, vga_x, vga_y, vga_colour, vga_plot} = {1'b0, 1'b0, 8'b0, 7'b0, 3'b0, 1'b0}; //Reset State
     else 
          if({start, mask} == {2'b10} && !done)  {mask, done, vga_x, vga_y, vga_colour, vga_plot} = {1'b1, 1'b0, 8'b0, 7'b0, 3'b0, 1'b1};// Start State
          else if({start, done} == 2'b01) done = 0;
               else if({start,mask} == 2'b11 && !done) //Start Filling in the Pixels
                         if(vga_x >= 8'd159 && vga_y >=7'd119){done, vga_plot, mask} = {1'b1, 1'b0, 1'b0}; // Finished State
                         else if(vga_y >= 7'd119 && vga_x!==8'd159 ) {vga_y, vga_x, vga_colour} = {7'b0, new_x, new_x[2:0]}; //Increment X-coordinate if x is not the last coloumn
                              else if(vga_x!==8'd159) {vga_y, vga_colour} = {(vga_y+7'b1), vga_x[2:0] }; //Increment Y-coordinate if x is not the last coloumn
                                   else if (vga_y < 7'd119){vga_y, vga_colour} = {(vga_y+7'b1), vga_x[2:0] };//Increment Y-coordinate if x is the last coloumn
     end
endmodule

