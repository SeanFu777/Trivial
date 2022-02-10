/*==================================================================================================================================
This is the module thats reponsible for sending the correct coordinates to the vga module to plot the reuleaux triangle.
It instantiates three modified circle module where the FSM of each module only contains two octants to minimize the clock cycle. 
The three vertices are computed using fixed point calculation. The values of sqrt(3)/3 and sqrt(3)/6 are represented using 9 integer
bits and 12 fractional bits. The multiplication rule applies as usual( just like integer). We will round the number up if
the first fractional bit is a "1" as it shows that the decimal part must be >= 1/2.
===================================================================================================================================*/
`define Octant_1    4'b0000
`define Octant_2    4'b0001
`define Octant_3    4'b0010
`define Octant_4    4'b0011
`define Octant_5    4'b0100
`define Octant_6    4'b0101
`define Octant_7    4'b0110
`define Octant_8    4'b0111
`define Halt        4'b1001

module reuleaux(input logic clk, input logic rst_n, input logic [2:0] colour,
                input logic [7:0] centre_x, input logic [6:0] centre_y, input logic [7:0] diameter,
                input logic start, output logic done,
                output logic [7:0] vga_x, output logic [6:0] vga_y,
                output logic [2:0] vga_colour, output logic vga_plot
                );

//signals
logic [3:0]  circle_1_state;
logic [31:0] circle_1_offset_x, circle_1_offset_y;
logic [31:0] Octant_2_X_reg, Octant_2_Y_reg,  Octant_3_X_reg, Octant_3_Y_reg;
logic extra_cycle, start_C1, done_C1;
logic[2:0] state;

logic start_C2, done_C2;
logic start_C3, done_C3;

logic [7:0] vga_x_C1, vga_x_C2, vga_x_C3;
logic [6:0] vga_y_C1, vga_y_C2, vga_y_C3;
logic [2:0] vga_colour_C1, vga_colour_C2, vga_colour_C3;
logic vga_plot_C1, vga_plot_C2, vga_plot_C3;

// fixed point calculation
logic [20:0] sqrt3DIV6, sqrt3DIV3; // 9+12
assign sqrt3DIV6 ={9'b0, 12'b0100_1001_1110}; //0.28867 => 0.0100_1001_1110
assign sqrt3DIV3 ={9'b0, 12'b1001_0011_1101};//0.1001_0011_1101/Well shift operator(decimal part only) will work too i suppouse

logic signed[8:0] vertex_top_x, vertex_left_x, vertex_right_x;
logic signed[7:0] vertex_top_y, vertex_left_y, vertex_right_y;
//find sqrt(3)/3 and sqrt(3)/6 
logic [40:0] temp_diameter_sqrtDIV6, temp_diameter_sqrtDIV3;

assign temp_diameter_sqrtDIV6 = ({diameter,12'b0}*sqrt3DIV6);
assign temp_diameter_sqrtDIV3 = ({diameter,12'b0}*sqrt3DIV3);

//rounding; see if the first fractional bit is a 1
assign vertex_right_x = centre_x + (diameter>>>1);
//assign vertex_right_y = (temp_diameter_sqrtDIV6[23]==1) ? centre_y + temp_diameter_sqrtDIV6[30:24] +1: centre_y + temp_diameter_sqrtDIV6[30:24];
assign vertex_right_y =  centre_y + temp_diameter_sqrtDIV6[30:24] +temp_diameter_sqrtDIV6[23];//alternative 

assign vertex_left_x  = centre_x- (diameter>>>1);
assign vertex_left_y  = (temp_diameter_sqrtDIV6[23]==1) ? centre_y + temp_diameter_sqrtDIV6[30:24] +1 : centre_y + temp_diameter_sqrtDIV6[30:24];

assign vertex_top_x   = centre_x;
assign vertex_top_y   = (temp_diameter_sqrtDIV3[23]==1) ? centre_y - temp_diameter_sqrtDIV3[30:24] -1:  centre_y - temp_diameter_sqrtDIV3[30:24];

//module instantiations
             
circle_1_Bottom OCT23(
                         .clk(clk), 
                         .rst_n(rst_n), 
                         .colour(colour),
                         .centre_x(vertex_top_x), 
                         .centre_y(vertex_top_y), 
                         .radius(diameter),
                         .start(start_C1),
                         .done(done_C1),
                         .vertex_left_x(vertex_left_x), 
                         .vertex_left_y(vertex_left_y),
                         .vertex_right_x(vertex_right_x),
                         .vertex_right_y(vertex_right_y),
                         .vga_x(vga_x_C1),
                         .vga_y(vga_y_C1),
                         .vga_colour(vga_colour_C1), 
                         .vga_plot(vga_plot_C1)

                       );

circle_2_left OCT56
                    (
                         .clk(clk), 
                         .rst_n(rst_n), 
                         .colour(colour),
                         .centre_x(vertex_right_x), 
                         .centre_y(vertex_right_y), 
                         .radius(diameter),
                         .start(start_C2),
                         .done(done_C2),
                         .vertex_left_x(vertex_left_x), 
                         .vertex_left_y(vertex_left_y),
                         .vertex_top_x(vertex_top_x),
                         .vertex_top_y(vertex_top_y),
                         .vga_x(vga_x_C2),
                         .vga_y(vga_y_C2),
                         .vga_colour(vga_colour_C2), 
                         .vga_plot(vga_plot_C2)
                    );

circle_3_right OCT78
                    (
                         .clk(clk), 
                         .rst_n(rst_n), 
                         .colour(colour),
                         .centre_x(vertex_left_x), 
                         .centre_y(vertex_left_y), 
                         .radius(diameter),
                         .start(start_C3),
                         .done(done_C3),
                         .vertex_right_x(vertex_right_x), 
                         .vertex_right_y(vertex_right_y),
                         .vertex_top_x(vertex_top_x),
                         .vertex_top_y(vertex_top_y),
                         .vga_x(vga_x_C3),
                         .vga_y(vga_y_C3),
                         .vga_colour(vga_colour_C3), 
                         .vga_plot(vga_plot_C3)
                    );
//more macros
`define Draw_C1   3'b000
`define Draw_C2   3'b001
`define Draw_C3   3'b010
`define Halting   3'b100
`define Wait_1    3'b101
//simple fsm to make sure only one module will be active at any goven time
always_ff @( posedge clk ) begin
    if(!rst_n) {start_C1, start_C2, start_C3,state, done} ={1'b0, 1'b0, 1'b0, `Wait_1, 1'b0};
    else if(start && !done)
          case(state)
         `Wait_1:    {state, start_C1 ,start_C2, start_C3} = {`Draw_C2, 1'b0, 1'b1, 1'b0};
         `Draw_C2:   {state, start_C1 ,start_C2, start_C3} = (!done_C2) ? {`Draw_C2, 1'b0, 1'b1, 1'b0}:{`Draw_C3, 1'b0, 1'b0, 1'b1};
         `Draw_C3:   {state, start_C1 ,start_C2, start_C3} = (!done_C3) ? {`Draw_C3, 1'b0, 1'b0, 1'b1}:{`Draw_C1, 1'b0, 1'b0, 1'b0};
         `Draw_C1  : {state, start_C1 ,start_C2, start_C3} = (!done_C1) ? {`Draw_C1, 1'b1, 1'b0, 1'b0}:{`Halting, 1'b0, 1'b0, 1'b0};
         `Halting:   {state, start_C1 ,start_C2, start_C3, done} = {`Halting, 1'b0, 1'b0, 1'b0, 1'b1};
    endcase
    else if(!start && done) done =0;
end
//a signal selection function that uses a purely combinational alwasy block
//the vga outputs depend on the state
always_comb begin 
    case(state)
    `Draw_C1: {vga_x,vga_y,vga_colour,vga_plot} = {vga_x_C1, vga_y_C1, vga_colour_C1, vga_plot_C1};
    `Draw_C2: {vga_x,vga_y,vga_colour,vga_plot} = {vga_x_C2, vga_y_C2, vga_colour_C2, vga_plot_C2};
    `Draw_C3: {vga_x,vga_y,vga_colour,vga_plot} = {vga_x_C3, vga_y_C3, vga_colour_C3, vga_plot_C3};
    default : {vga_x,vga_y,vga_colour,vga_plot} = 20'bz;
    endcase
end
endmodule



/*===========================================================
This is a modified circle module where unnecessaery state
are  removed. Several inputs have been sign extend to avoid 
underflow/overflowing
===========================================================*/
module circle_1_Bottom(input logic clk, input logic rst_n, input logic [2:0] colour,
              input logic signed [8:0] centre_x, input logic signed [7:0] centre_y, input logic [7:0] radius,
              input logic start, output logic done,
              input logic signed[8:0] vertex_left_x , input logic signed[7:0] vertex_left_y,
              input logic signed[8:0] vertex_right_x, input logic signed[7:0] vertex_right_y,
              output logic [7:0] vga_x, output logic [6:0] vga_y,
              output logic [2:0] vga_colour, output logic vga_plot
              );
//signals
logic signed [31:0] offset_x;
logic signed [31:0] offset_y;
logic signed [31:0] crit, crit_1, crit_2;
logic [3:0] present_state;
logic mask, check_1st_cycle, extra_cycle;


assign crit_1 = crit+2*(offset_y)+1;
assign crit_2 = crit+2*(offset_y - offset_x) + 1;

logic signed [31:0] Octant_2_X, Octant_2_Y, Octant_2_X_reg, Octant_2_Y_reg;
assign Octant_2_X = centre_x + offset_y;
assign Octant_2_Y = centre_y + offset_x;

logic signed [31:0] Octant_3_X, Octant_3_Y, Octant_3_X_reg, Octant_3_Y_reg;
assign Octant_3_X = centre_x - offset_y;
assign Octant_3_Y = centre_y + offset_x;

assign circle_1_state = present_state;
assign circle_1_offset_x = offset_x;
assign circle_1_offset_y = offset_y;

always_ff @( posedge clk ) begin//fsm; its like the cricle module however several states have been removed to reduec clk cycle
     if(!rst_n) begin//reset
            offset_x       = radius          ; offset_y = 0;
            {done, vga_x, vga_y, vga_colour, vga_plot, mask, present_state} = {1'b0, 8'b0, 7'b0, 3'b0, 1'b0, 1'b0, `Octant_2};
          end 
     else if ({start, mask} == 2'b10) begin //wait
          {done, vga_x, vga_y, vga_colour, vga_plot, offset_x, offset_y, mask, present_state, crit, check_1st_cycle} = {1'b0, 8'b0, 7'b0, 3'b0, 1'b0, {24'b0,radius}, 32'b0, 1'b1, `Octant_2, 32'b1-radius, 1'b0};
          
     end
          else if ({start, mask} == 2'b11) //main state transition
                    case(present_state)
                         `Octant_2   :     if (extra_cycle) present_state = (offset_x >= offset_y) ? `Octant_3 : `Halt;
                                                            else {present_state,extra_cycle}= {`Octant_2,1'b1};
                         `Octant_3   :     present_state = `Octant_2;
                         `Halt       :     present_state = `Halt;
                         default     :     present_state = `Halt;
                    endcase

     case(present_state)// assignment, Octant_2 is responsible for updating the crit signal and octant 3 is responsible for updating the offsets
     `Octant_2   :  if(crit<=0 && check_1st_cycle) {vga_x, vga_y, vga_plot, crit, Octant_2_X_reg, Octant_2_Y_reg} = (Octant_2_X >= 0 && Octant_2_X < 160 && Octant_2_Y >= 0 && Octant_2_Y < 120 && (Octant_2_X <= vertex_right_x && Octant_2_Y >= vertex_right_y )) ? {Octant_2_X[7:0], Octant_2_Y[6:0], 1'b1, crit_1, Octant_2_X, Octant_2_Y} : {Octant_2_X[7:0], Octant_2_Y[6:0], 1'b0, crit_1, Octant_2_X, Octant_2_Y};
                    else if(check_1st_cycle)  {vga_x, vga_y, vga_plot, crit, Octant_2_X_reg, Octant_2_Y_reg} = (Octant_2_X >= 0 && Octant_2_X < 160 && Octant_2_Y >= 0 && Octant_2_Y < 120 && (Octant_2_X <= vertex_right_x && Octant_2_Y >= vertex_right_y )) ? {Octant_2_X[7:0], Octant_2_Y[6:0], 1'b1, crit_2, Octant_2_X, Octant_2_Y} : {Octant_2_X[7:0], Octant_2_Y[6:0], 1'b0, crit_2, Octant_2_X, Octant_2_Y};
                         else {vga_x, vga_y, vga_plot, check_1st_cycle, Octant_2_X_reg, Octant_2_Y_reg} = (Octant_2_X >= 0 && Octant_2_X < 160 && Octant_2_Y >= 0 && Octant_2_Y < 120 && (Octant_2_X <= vertex_right_x && Octant_2_Y >= vertex_right_y )) ? {Octant_2_X[7:0], Octant_2_Y[6:0], 1'b1, 1'b1, Octant_2_X, Octant_2_Y} : {Octant_2_X[7:0], Octant_2_Y[6:0], 1'b0, 1'b1, Octant_2_X, Octant_2_Y};

     `Octant_3   :  if(crit <= 0) {vga_x, vga_y, vga_plot, offset_y, Octant_3_X_reg, Octant_3_Y_reg} =  (Octant_3_X >= 0 && Octant_3_X < 160 && Octant_3_Y >= 0 && Octant_3_Y < 120 && (Octant_3_X >= vertex_left_x && Octant_3_Y >= vertex_left_y )) ? {Octant_3_X[7:0], Octant_3_Y[6:0], 1'b1, offset_y+7'b1, Octant_3_X, Octant_3_Y} : {Octant_3_X[7:0], Octant_3_Y[6:0], 1'b0, offset_y+7'b1, Octant_3_X, Octant_3_Y} ;
                    else{vga_x, vga_y, vga_plot, offset_y, offset_x, Octant_3_X_reg, Octant_3_Y_reg} =  (Octant_3_X >= 0 && Octant_3_X < 160 && Octant_3_Y >= 0 && Octant_3_Y < 120 && (Octant_3_X >= vertex_left_x && Octant_3_Y >= vertex_left_y )) ? {Octant_3_X[7:0], Octant_3_Y[6:0], 1'b1, offset_y+7'b1, offset_x-8'b1, Octant_3_X, Octant_3_Y} : {Octant_3_X[7:0], Octant_3_Y[6:0], 1'b0, offset_y+7'b1, offset_x-8'b1, Octant_3_X, Octant_3_Y};
   
     `Halt       : if(start && !done) {done, vga_plot} = 2'b10;
                   else if (!start && done) {done, mask, vga_plot} = 3'b000;

     default     :{vga_x, vga_y, vga_plot} = 16'bx;
     endcase               
end

endmodule


//Circle on the right side that draws the left curve of the reuleaus triangle.
//The center of the circle is the right vertex
//Starting condition：vertex_top, vertex_left
//Ending condition： The same as the circle since two octants both converge from the two starting point to a single point

/*===========================================================
This is a modified circle module where unnecessaery state
are  removed. Several inputs have been sign extend to avoid 
underflow/overflowing
===========================================================*/
module circle_2_left(input logic clk, input logic rst_n, input logic [2:0] colour,
              input logic signed [8:0] centre_x, input logic [7:0] centre_y, input logic [7:0] radius,
              input logic start, output logic done,
              input logic signed [8:0] vertex_left_x , input logic signed [7:0] vertex_left_y,
              input logic signed [8:0] vertex_top_x  , input logic signed [7:0] vertex_top_y,
              output logic [7:0] vga_x, output logic [6:0] vga_y,
              output logic [2:0] vga_colour, output logic vga_plot);
//signals
logic signed [31:0] offset_x;
logic signed [31:0] offset_y;
logic signed [31:0] crit, crit_1, crit_2;
logic [3:0] present_state;
logic mask, check_1st_cycle, extra_cycle;

assign crit_1 = crit+2*(offset_y)+1;
assign crit_2 = crit+2*(offset_y - offset_x) + 1;

logic signed [31:0] Octant_5_X, Octant_5_Y, Octant_5_X_reg, Octant_5_Y_reg;
assign Octant_5_X = centre_x - offset_x;
assign Octant_5_Y = centre_y - offset_y;

logic signed [31:0] Octant_6_X, Octant_6_Y, Octant_6_X_reg, Octant_6_Y_reg;
assign Octant_6_X = centre_x - offset_y;
assign Octant_6_Y = centre_y - offset_x;


always_ff @( posedge clk ) begin//fsm; its like the cricle module however several states have been removed to reduec clk cycle
     if(!rst_n) begin//reset
               offset_x       = radius          ; offset_y = 0;
               {done, vga_x, vga_y, vga_colour, vga_plot, mask, present_state} = {1'b0, 8'b0, 7'b0, 3'b0, 1'b0, 1'b0, `Octant_5};
     end//then wait 1 clk cycle
     else if ({start, mask} == 2'b10) {done, vga_x, vga_y, vga_colour, vga_plot, offset_x, offset_y, mask, present_state, crit, check_1st_cycle} = {1'b0, 8'b0, 7'b0, 3'b0, 1'b0, {24'b0,radius}, 32'b0, 1'b1, `Octant_5, 32'b1-radius, 1'b0};
          else if ({start, mask} == 2'b11) //main state transition
                    case(present_state)
                         `Octant_5   :     if (extra_cycle) present_state = (offset_x >= offset_y) ? `Octant_6 : `Halt;
                                                            else {present_state,extra_cycle,Octant_6_X_reg, Octant_6_Y_reg}= {`Octant_5,1'b1,Octant_6_X, Octant_6_Y};
                         `Octant_6   :     present_state = `Octant_5;
                         `Halt       :     present_state = `Halt;
                         default     :     present_state = `Halt;
                    endcase

     case(present_state)// assignment, Octant_5 is responsible for updating the crit signal and octant 6 is responsible for updating the offsets
     `Octant_5   :  if(crit<=0 && check_1st_cycle) {vga_x, vga_y, vga_plot, crit, Octant_5_X_reg, Octant_5_Y_reg} = (Octant_5_X >= 0 && Octant_5_X < 160 && Octant_5_Y >= 0 && Octant_5_Y < 120 && (Octant_5_X >= vertex_left_x && Octant_5_Y <= vertex_left_y )) ? {Octant_5_X[7:0], Octant_5_Y[6:0], 1'b1, crit_1, Octant_5_X, Octant_5_Y} : {Octant_5_X[7:0], Octant_5_Y[6:0], 1'b0, crit_1, Octant_5_X, Octant_5_Y};
                    else if(check_1st_cycle)  {vga_x, vga_y, vga_plot, crit, Octant_5_X_reg, Octant_5_Y_reg} = (Octant_5_X >= 0 && Octant_5_X < 160 && Octant_5_Y >= 0 && Octant_5_Y < 120 && (Octant_5_X >= vertex_left_x && Octant_5_Y <= vertex_left_y )) ? {Octant_5_X[7:0], Octant_5_Y[6:0], 1'b1, crit_2, Octant_5_X, Octant_5_Y} : {Octant_5_X[7:0], Octant_5_Y[6:0], 1'b0, crit_2, Octant_5_X, Octant_5_Y};
                         else {vga_x, vga_y, vga_plot, check_1st_cycle, Octant_5_X_reg, Octant_5_Y_reg} = (Octant_5_X >= 0 && Octant_5_X < 160 && Octant_5_Y >= 0 && Octant_5_Y < 120 && (Octant_5_X >= vertex_left_x && Octant_5_Y <= vertex_left_y )) ? {Octant_5_X[7:0], Octant_5_Y[6:0], 1'b1, 1'b1, Octant_5_X, Octant_5_Y} : {Octant_5_X[7:0], Octant_5_Y[6:0], 1'b0, 1'b1, Octant_5_X, Octant_5_Y};

     `Octant_6   :  if(crit <= 0) {vga_x, vga_y, vga_plot, offset_y, Octant_6_X_reg, Octant_6_Y_reg} =  (Octant_6_X >= 0 && Octant_6_X < 160 && Octant_6_Y >= 0 && Octant_6_Y < 120 && (Octant_6_X <= vertex_top_x && Octant_6_Y >= vertex_top_y )) ? {Octant_6_X[7:0], Octant_6_Y[6:0], 1'b1, offset_y+7'b1, Octant_6_X, Octant_6_Y} : {Octant_6_X[7:0], Octant_6_Y[6:0], 1'b0, offset_y+7'b1, Octant_6_X, Octant_6_Y} ;
                    else{vga_x, vga_y, vga_plot, offset_y, offset_x, Octant_6_X_reg, Octant_6_Y_reg} =  (Octant_6_X >= 0 && Octant_6_X < 160 && Octant_6_Y >= 0 && Octant_6_Y < 120 && (Octant_6_X <= vertex_top_x && Octant_6_Y >= vertex_top_y )) ? {Octant_6_X[7:0], Octant_6_Y[6:0], 1'b1, offset_y+7'b1, offset_x-8'b1, Octant_6_X, Octant_6_Y} : {Octant_6_X[7:0], Octant_6_Y[6:0], 1'b0, offset_y+7'b1, offset_x-8'b1, Octant_6_X, Octant_6_Y};
   
     `Halt       : if(start && !done) {done, vga_plot} = 2'b10;
                   else if (!start && done) {done, mask, vga_plot} = 3'b000;

     default     :{vga_x, vga_y, vga_plot} = 16'bx;
     endcase               
end

endmodule

//Circle on the left side that draws the right curve of the reuleaus triangle.
//The center of the circle is the left vertex
//Starting condition：vertex_top, vertex_left
//Ending condition： The same as the circle since two octants both converge from the two starting point to a single point\

/*===========================================================
This is a modified circle module where unnecessaery state
are  removed. Several inputs have been sign extend to avoid 
underflow/overflowing
===========================================================*/
module circle_3_right(input logic clk, input logic rst_n, input logic [2:0] colour,
              input logic signed [8:0] centre_x, input logic signed [7:0] centre_y, input logic [7:0] radius,
              input logic start, output logic done,
              input logic signed [8:0] vertex_right_x , input logic signed [7:0] vertex_right_y,
              input logic signed [8:0] vertex_top_x   , input logic signed [7:0] vertex_top_y,
              output logic [7:0] vga_x, output logic [6:0] vga_y,
              output logic [2:0] vga_colour, output logic vga_plot);

logic signed [31:0] offset_x;
logic signed [31:0] offset_y;
logic signed [31:0] crit, crit_1, crit_2;
logic [3:0] present_state;
logic mask, check_1st_cycle, extra_cycle;


assign crit_1 = crit+2*(offset_y)+1;
assign crit_2 = crit+2*(offset_y - offset_x) + 1;

logic signed [31:0] Octant_7_X, Octant_7_Y, Octant_7_X_reg, Octant_7_Y_reg;
assign Octant_7_X = centre_x + offset_y;
assign Octant_7_Y = centre_y - offset_x;

logic signed [31:0] Octant_8_X, Octant_8_Y, Octant_8_X_reg, Octant_8_Y_reg;
assign Octant_8_X = centre_x + offset_x;
assign Octant_8_Y = centre_y - offset_y;


always_ff @( posedge clk ) begin//fsm; its like the cricle module however several states have been removed to reduec clk cycle
     if(!rst_n) //reset
     begin
          offset_x       = radius          ; offset_y = 0;
          {done, vga_x, vga_y, vga_colour, vga_plot, mask, present_state} = {1'b0, 8'b0, 7'b0, 3'b0, 1'b0, 1'b0, `Octant_7};
     end//then wait 1 clk cycle
     else if ({start, mask} == 2'b10) {done, vga_x, vga_y, vga_colour, vga_plot, offset_x, offset_y, mask, present_state, crit, check_1st_cycle} = {1'b0, 8'b0, 7'b0, 3'b0, 1'b0, {24'b0,radius}, 32'b0, 1'b1, `Octant_7, 32'b1-radius, 1'b0};
          else if ({start, mask} == 2'b11) 
                    case(present_state)//main state transition
                         `Octant_7   :     if (extra_cycle) present_state = (offset_x >= offset_y) ? `Octant_8 : `Halt;
                                                            else {present_state,extra_cycle,Octant_7_X_reg, Octant_7_Y_reg}= {`Octant_7,1'b1,Octant_7_X, Octant_7_Y};
                         `Octant_8   :     present_state = `Octant_7;
                         `Halt       :     present_state = `Halt;
                         default     :     present_state = `Halt;
                    endcase

     case(present_state)// assignment, Octant_7 is responsible for updating the crit signal and octant 8 is responsible for updating the offsets
     `Octant_7   :  if(crit<=0 && check_1st_cycle) {vga_x, vga_y, vga_plot, crit, Octant_7_X_reg, Octant_7_Y_reg} = (Octant_7_X >= 0 && Octant_7_X < 160 && Octant_7_Y >= 0 && Octant_7_Y < 120 && (Octant_7_X >= vertex_top_x && Octant_7_Y >= vertex_top_y )) ? {Octant_7_X[7:0], Octant_7_Y[6:0], 1'b1, crit_1, Octant_7_X, Octant_7_Y} : {Octant_7_X[7:0], Octant_7_Y[6:0], 1'b0, crit_1, Octant_7_X, Octant_7_Y};
                    else if(check_1st_cycle)  {vga_x, vga_y, vga_plot, crit, Octant_7_X_reg, Octant_7_Y_reg} = (Octant_7_X >= 0 && Octant_7_X < 160 && Octant_7_Y >= 0 && Octant_7_Y < 120 && (Octant_7_X >= vertex_top_x && Octant_7_Y >= vertex_top_y )) ? {Octant_7_X[7:0], Octant_7_Y[6:0], 1'b1, crit_2, Octant_7_X, Octant_7_Y} : {Octant_7_X[7:0], Octant_7_Y[6:0], 1'b0, crit_2, Octant_7_X, Octant_7_Y};
                         else {vga_x, vga_y, vga_plot, check_1st_cycle, Octant_7_X_reg, Octant_7_Y_reg} = (Octant_7_X >= 0 && Octant_7_X < 160 && Octant_7_Y >= 0 && Octant_7_Y < 120 && (Octant_7_X >= vertex_top_x && Octant_7_Y >= vertex_top_y ))  ? {Octant_7_X[7:0], Octant_7_Y[6:0], 1'b1, 1'b1, Octant_7_X, Octant_7_Y} : {Octant_7_X[7:0], Octant_7_Y[6:0], 1'b0, 1'b1, Octant_7_X, Octant_7_Y};

     `Octant_8   :  if(crit <= 0) {vga_x, vga_y, vga_plot, offset_y, Octant_8_X_reg, Octant_8_Y_reg} =  (Octant_8_X >= 0 && Octant_8_X < 160 && Octant_8_Y >= 0 && Octant_8_Y < 120 && (Octant_8_X <= vertex_right_x && Octant_8_Y <= vertex_right_y )) ? {Octant_8_X[7:0], Octant_8_Y[6:0], 1'b1, offset_y+7'b1, Octant_8_X, Octant_8_Y} : {Octant_8_X[7:0], Octant_8_Y[6:0], 1'b0, offset_y+7'b1, Octant_8_X, Octant_8_Y} ;
                    else{vga_x, vga_y, vga_plot, offset_y, offset_x, Octant_8_X_reg, Octant_8_Y_reg} =  (Octant_8_X >= 0 && Octant_8_X < 160 && Octant_8_Y >= 0 && Octant_8_Y < 120 && (Octant_8_X <= vertex_right_x && Octant_8_Y <= vertex_right_y )) ? {Octant_8_X[7:0], Octant_8_Y[6:0], 1'b1, offset_y+7'b1, offset_x-8'b1, Octant_8_X, Octant_8_Y} : {Octant_8_X[7:0], Octant_8_Y[6:0], 1'b0, offset_y+7'b1, offset_x-8'b1, Octant_8_X, Octant_8_Y};
   
     `Halt       : if(start && !done) {done, vga_plot} = 2'b10;
                   else if (!start && done) {done, mask, vga_plot} = 3'b000;

     default     :{vga_x, vga_y, vga_plot} = 16'bx;
     endcase               
end

endmodule



