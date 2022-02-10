`timescale 1 ps / 1 ps
/*======================================================================
This is a simple post syns testbench for the module task 3. It will assert key[3]
first and then check several crtical states and signals. The user should 
check the VGA simulator to see if the results are correct.
======================================================================*/
module tb_syn_task3();


logic clk, err, VGA_PLOT;
logic [3:0]KEY;
logic [2:0] VGA_COLOUR;
logic [7:0] VGA_X;
logic [6:0] VGA_Y;

logic [9:0] SW, LEDR;
logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
logic [7:0] VGA_R, VGA_G, VGA_B;
logic VGA_HS, VGA_VS, VGA_CLK;

// From piazza, used here for simulating the results on the reduced vga screen 
always @(posedge clk, negedge KEY[3]) begin
        if (KEY[3] === 1'b0) begin
`ifdef MODEL_TECH
            mti_fli::mti_Command("if { [namespace exists ::de1vga] } { ::de1vga::reset } else { echo \"VGA RESET\" }");
`else
            $display("VGA RESET");
`endif
        end else if (VGA_PLOT === 1'b1) begin
`ifdef MODEL_TECH
            mti_fli::mti_Command($sformatf("if { [namespace exists ::de1vga] } { ::de1vga::plot %0d %0d %0d } else { echo \"VGA PLOT %0d,%0d %0d\" }", VGA_X, VGA_Y, VGA_COLOUR, VGA_X, VGA_Y, VGA_COLOUR));
`else
            $display("VGA PLOT %0d,%0d %0d", VGA_X, VGA_Y, VGA_COLOUR);
`endif
        end
    end
    
task3 DUT(  
            .CLOCK_50(clk), 
            .KEY(KEY),
            .VGA_X(VGA_X),
            .VGA_Y(VGA_Y),
            .VGA_COLOUR(VGA_COLOUR), 
            .VGA_PLOT(VGA_PLOT)
         );
initial forever  #1 clk = ! clk;

initial begin
    #1;
    $display(">>>>>>>>>>>>>>>>>>Task 3 Testbench<<<<<<<<<<<<<<");

    clk =1; KEY[3] = 0; err =0; #4;
    KEY[3] = 1; #1;

    assert(VGA_X ==0 && VGA_Y==0 && VGA_PLOT == 0)
    $display("Check: Reset Passed at %d ps", $time);
    else begin $display("Check: Reset Failed at %d ps", $time); err = 1; end #2;

    assert(VGA_X ==0 && VGA_Y==0 && VGA_PLOT == 1)
    $display("Check: Fillscreen Initialization Passed at %d ps", $time);
    else begin $display("Check: Fillscreen Initialization Failed at %d ps", $time); err = 1; end #2;

    #38400;

    assert(VGA_PLOT !== 1)
    $display("Check: State Transition to Draw_Cirlce Passed at %d ps", $time);
    else begin $display("Check: State Transition to Draw_Cirlce Failed at %d ps", $time); err = 1; end #4;

    assert(VGA_X ==60 && VGA_Y==120 && VGA_PLOT == 1)
    $display("Check: Draw_Circle Initialization Passed at %d ps", $time);
    else begin $display("Check: Draw_Circle Initialization Failed at %d ps", $time); err = 1; end #2; //38413

    #460;
    assert(VGA_X ==108 && VGA_Y==89 && VGA_PLOT == 1)
    $display("Check: Draw_Circle Closing Passed at %d ps", $time);
    else begin $display("Check: Draw_Circle Closing Failed at %d ps", $time); err = 1; end #2; //38413
    #10;

    assert( VGA_PLOT !== 1)
    $display("Check: Stop State Passed at %d ps", $time);
    else begin $display("Check: Stop State Failed at %d ps", $time); err = 1; end #2; //38413

    $display(">>>>>>>>>>>>>>>>>>Task 3 Testbench<<<<<<<<<<<<<<");


    $stop;
end

endmodule: tb_syn_task3
