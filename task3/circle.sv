/*======================================================================================
This is a circuit that can plot a circle on the reduced vga screen if its center 
coordinates meet the follwing requirements: 0 <= x <= 255, and 0 <= y <= 128 with a radius
of r, where r<=255. 

pseudo code:
drawCircle(centre_x, centre_y, radius):
    offset_y = 0
    offset_x = radius
    crit = 1 - radius
    while offset_y ≤ offset_x:
        setPixel(centre_x + offset_x, centre_y + offset_y)   -- octant 1
        setPixel(centre_x + offset_y, centre_y + offset_x)   -- octant 2
        setPixel(centre_x - offset_x, centre_y + offset_y)   -- octant 4
        setPixel(centre_x - offset_y, centre_y + offset_x)   -- octant 3
        setPixel(centre_x - offset_x, centre_y - offset_y)   -- octant 5
        setPixel(centre_x - offset_y, centre_y - offset_x)   -- octant 6
        setPixel(centre_x + offset_x, centre_y - offset_y)   -- octant 8
        setPixel(centre_x + offset_y, centre_y - offset_x)   -- octant 7
        offset_y = offset_y + 1
        if crit ≤ 0:
            crit = crit + 2 * offset_y + 1
        else:
            offset_x = offset_x - 1
            crit = crit + 2 * (offset_y - offset_x) + 1

========================================================================================*/


module circle(input logic clk, input logic rst_n, input logic [2:0] colour,
              input logic [7:0] centre_x, input logic [6:0] centre_y, input logic [7:0] radius,
              input logic start, output logic done,
              output logic [7:0] vga_x, output logic [6:0] vga_y,
              output logic [2:0] vga_colour, output logic vga_plot);

logic signed [31:0] offset_x; 
logic signed [31:0] offset_y;
logic signed [31:0] crit, crit_1, crit_2;
logic [3:0] present_state;
logic mask, check_1st_cycle;

`define Octant_1    4'b0000
`define Octant_2    4'b0001
`define Octant_3    4'b0010
`define Octant_4    4'b0011
`define Octant_5    4'b0100
`define Octant_6    4'b0101
`define Octant_7    4'b0110
`define Octant_8    4'b0111
`define Halt        4'b1001

assign crit_1 = crit+2*(offset_y)+1;
assign crit_2 = crit+2*(offset_y - offset_x) + 1;
// Combinational Logic is used here to compute the coordinates of the next pixel to be plotted
// All of them are signed to prevent underflow/overflow when we have a large radius

logic signed [31:0] Octant_1_X, Octant_1_Y;
assign Octant_1_X = centre_x + offset_x;
assign Octant_1_Y = centre_y + offset_y;

logic signed [31:0] Octant_2_X, Octant_2_Y;
assign Octant_2_X = centre_x + offset_y;
assign Octant_2_Y = centre_y + offset_x;

logic signed [31:0] Octant_3_X, Octant_3_Y;
assign Octant_3_X = centre_x - offset_y;
assign Octant_3_Y = centre_y + offset_x;

logic signed [31:0] Octant_4_X, Octant_4_Y;
assign Octant_4_X = centre_x - offset_x;
assign Octant_4_Y = centre_y + offset_y;

logic signed [31:0] Octant_5_X, Octant_5_Y;
assign Octant_5_X = centre_x - offset_x;
assign Octant_5_Y = centre_y - offset_y;

logic signed [31:0] Octant_6_X, Octant_6_Y;
assign Octant_6_X = centre_x - offset_y;
assign Octant_6_Y = centre_y - offset_x;

logic signed [31:0] Octant_7_X, Octant_7_Y;
assign Octant_7_X = centre_x + offset_y;
assign Octant_7_Y = centre_y - offset_x;

logic signed [31:0] Octant_8_X, Octant_8_Y;
assign Octant_8_X = centre_x + offset_x;
assign Octant_8_Y = centre_y - offset_y;

//always block is used for the FSM including the state transition part and signal assignement part

always_ff @( posedge clk ) begin
     if(!rst_n)  begin 
          {done, vga_x, vga_y, vga_colour, vga_plot, mask, present_state} = {1'b0, 8'b0, 7'b0, 3'b0, 1'b0, 1'b0, 4'b0};
          offset_x       = radius          ; offset_y = 0;
     end// This is the reset state
     else if ({start, mask} == 2'b10) begin
               done           = 0;
               vga_x          = Octant_1_X [7:0]; vga_y    = Octant_1_Y [6:0];
               vga_colour     = 0               ; vga_plot = 0;
               offset_x       = radius          ; offset_y = 0;
               mask           = 1               ; crit     = 32'b1-radius;
               present_state  = 0               ;
               check_1st_cycle= 0               ;
          end
          //{done, vga_x, vga_y, vga_colour, vga_plot, offset_x, offset_y, mask, present_state, crit, check_1st_cycle} = {1'b0, 8'b0, 7'b0, 3'b0, 1'b0, {24'b0,radius}, 32'b0, 1'b1, 4'b0, 32'b1-radius, 1'b0}; //This is the initialization state
          else if ({start, mask} == 2'b11) //state transition
                    case(present_state)
                         `Octant_1   :     present_state =  (offset_x >= offset_y) ? `Octant_2 : `Halt;//whenever we finish a loop, we check whether we shoud exit
                         `Octant_2   :     present_state = `Octant_3;// same tansition as the pseudo code
                         `Octant_3   :     present_state = `Octant_4;//^
                         `Octant_4   :     present_state = `Octant_5;//^
                         `Octant_5   :     present_state = `Octant_6;//^
                         `Octant_6   :     present_state = `Octant_7;//^
                         `Octant_7   :     present_state = `Octant_8;//^
                         `Octant_8   :     present_state = `Octant_1;//^
                         `Halt       :     present_state = `Halt; //halting
                         default     :     present_state = `Halt;
                    endcase

     case(present_state)
     //in state Octant 1 we will compute the new value for `crit` based on the new value we found in state Octant 8 if its not the first cycle
     //the conditional assignement will determine whether to draw the pixelbased on if the location is outside the reduced vga screen
     //in state Octant 8 we will compute the new values of offsets
     //we will staty in halt unless the user re-assert start after we have plotted the circle (and the user dessert the start)
     `Octant_1   :  if(crit<=0 && check_1st_cycle) {vga_x, vga_y, vga_plot, crit} = (Octant_1_X >= 0 && Octant_1_X < 160 && Octant_1_Y >= 0 && Octant_1_Y < 120) ? {Octant_1_X[7:0], Octant_1_Y[6:0], 1'b1, crit_1} : {Octant_1_X[7:0], Octant_1_Y[6:0], 1'b0, crit_1};
                    else if(check_1st_cycle)  {vga_x, vga_y, vga_plot, crit} = (Octant_1_X >= 0 && Octant_1_X < 160 && Octant_1_Y >= 0 && Octant_1_Y < 120) ? {Octant_1_X[7:0], Octant_1_Y[6:0], 1'b1, crit_2} : {Octant_1_X[7:0], Octant_1_Y[6:0], 1'b0, crit_2};
                         else {vga_x, vga_y, vga_plot, check_1st_cycle} = (Octant_1_X >= 0 && Octant_1_X < 160 && Octant_1_Y >= 0 && Octant_1_Y < 120) ? {Octant_1_X[7:0], Octant_1_Y[6:0], 1'b1, 1'b1} : {Octant_1_X[7:0], Octant_1_Y[6:0], 1'b0, 1'b1};

     `Octant_2   :  {vga_x, vga_y, vga_plot} = (Octant_2_X >= 0 && Octant_2_X < 160 && Octant_2_Y >= 0 && Octant_2_Y < 120) ? {Octant_2_X[7:0], Octant_2_Y[6:0], 1'b1} : {Octant_2_X[7:0], Octant_2_Y[6:0], 1'b0};

     `Octant_3   :  {vga_x, vga_y, vga_plot} = (Octant_3_X >= 0 && Octant_3_X < 160 && Octant_3_Y >= 0 && Octant_3_Y < 120) ? {Octant_3_X[7:0], Octant_3_Y[6:0], 1'b1} : {Octant_3_X[7:0], Octant_3_Y[6:0], 1'b0};

     `Octant_4   :  {vga_x, vga_y, vga_plot} = (Octant_4_X >= 0 && Octant_4_X < 160 && Octant_4_Y >= 0 && Octant_4_Y < 120) ? {Octant_4_X[7:0], Octant_4_Y[6:0], 1'b1} : {Octant_4_X[7:0], Octant_4_Y[6:0], 1'b0};

     `Octant_5   :  {vga_x, vga_y, vga_plot} = (Octant_5_X >= 0 && Octant_5_X < 160 && Octant_5_Y >= 0 && Octant_5_Y < 120) ? {Octant_5_X[7:0], Octant_5_Y[6:0], 1'b1} : {Octant_5_X[7:0], Octant_5_Y[6:0], 1'b0};

     `Octant_6   :  {vga_x, vga_y, vga_plot} = (Octant_6_X >= 0 && Octant_6_X < 160 && Octant_6_Y >= 0 && Octant_6_Y < 120) ? {Octant_6_X[7:0], Octant_6_Y[6:0], 1'b1} : {Octant_6_X[7:0], Octant_6_Y[6:0], 1'b0};
     
     `Octant_7   :  {vga_x, vga_y, vga_plot} = (Octant_7_X >= 0 && Octant_7_X < 160 && Octant_7_Y >= 0 && Octant_7_Y < 120) ? {Octant_7_X[7:0], Octant_7_Y[6:0], 1'b1} : {Octant_7_X[7:0], Octant_7_Y[6:0], 1'b0};

     `Octant_8   :  if(crit <= 0) {vga_x, vga_y, vga_plot, offset_y} =  (Octant_8_X >= 0 && Octant_8_X < 160 && Octant_8_Y >= 0 && Octant_8_Y < 120) ? {Octant_8_X[7:0], Octant_8_Y[6:0], 1'b1, offset_y+7'b1} : {Octant_8_X[7:0], Octant_8_Y[6:0], 1'b0, offset_y+7'b1} ;
                    else{vga_x, vga_y, vga_plot, offset_y, offset_x} =  (Octant_8_X >= 0 && Octant_8_X < 160 && Octant_8_Y >= 0 && Octant_8_Y < 120) ? {Octant_8_X[7:0], Octant_8_Y[6:0], 1'b1, offset_y+7'b1, offset_x-8'b1} : {Octant_8_X[7:0], Octant_8_Y[6:0], 1'b0, offset_y+7'b1, offset_x-8'b1};
   
     `Halt       : if(start && !done) {done, vga_plot} = 2'b10;
                   else if (!start && done) {done, mask, vga_plot} = 3'b000;
     default     :{vga_x, vga_y, vga_plot} = 16'bx;
     endcase               
end

endmodule

