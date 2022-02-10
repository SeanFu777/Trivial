/*==========================================================================
This is a simple post-syns testbench for the module task 2. This module is 
modified based on the rtl testbench where internal signals have been ignored.
It will assert key[3] first and then check several crtical states and signals. 
The user should check the VGA simulator to see if the results are correct
===========================================================================*/
`timescale 1 ps / 1 ps

module tb_syn_task2();


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

task2 DUT(  
            .CLOCK_50(clk), 
            .KEY(KEY),
            .VGA_X(VGA_X),
            .VGA_Y(VGA_Y),
            .VGA_COLOUR(VGA_COLOUR), 
            .VGA_PLOT(VGA_PLOT)
         );

initial forever  #1 clk = ! clk;

initial begin

    
    clk =1; KEY[3] = 0; err =0; #2;
    KEY[3] = 1; #4;

    assert(  VGA_X == 0 && VGA_Y == 0 && VGA_PLOT == 1)
    $display("Initial State Checked");
    else begin err =1; $display("Initial State Failed at %d ", $time);end
    
    #38400;

    assert( VGA_X == 159 && VGA_Y == 119 && VGA_PLOT == 0)
    $display("Ending State 1(Assert Done) Checked");
    else begin err =1; $display("Ending State 1(Assert Done) Failed");end

    #2;

    assert( VGA_X == 159 && VGA_Y == 119 && VGA_PLOT == 0)
    $display("Ending State 2(De-assert Start) Checked");
    else begin err =1; $display("Ending State 2(De-assert Start) Failed");end

    #2;

    assert( VGA_X == 159 && VGA_Y == 119 && VGA_PLOT == 0)
    $display("Ending State 3(De-assert Done) Checked");
    else begin err =1; $display("Ending State 3(De-assert Done) Failed");end

    $stop;
end


endmodule: tb_syn_task2
