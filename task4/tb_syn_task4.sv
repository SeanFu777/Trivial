`timescale 1 ps / 1 ps
/*======================================================================
This is a simple post-syn testbench for the module task 4. It will assert key[3]
first and then check several crtical states and signals. The user should 
check the VGA simulator to see if the results are correct
======================================================================*/
module tb_syn_task4();

logic clk, err, VGA_PLOT;
logic [3:0]KEY;
logic [2:0] VGA_COLOUR;
logic [7:0] VGA_X;
logic [6:0] VGA_Y;

logic [9:0] SW, LEDR;
logic [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
logic [7:0] VGA_R, VGA_G, VGA_B;
logic VGA_HS, VGA_VS, VGA_CLK;

logic [3:0] circle_1_state;
logic [31:0]Octant_2_X_reg, Octant_2_Y_reg,  Octant_3_X_reg, Octant_3_Y_reg;
logic extra_cycle,start_C1,done_C1;
logic [2:0] R_state;

task4 DUT(  
            .CLOCK_50(clk), 
            .KEY(KEY),
            .VGA_X(VGA_X),
            .VGA_Y(VGA_Y),
            .VGA_COLOUR(VGA_COLOUR), 
            .VGA_PLOT(VGA_PLOT),
            .*
         );
         
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
    
initial forever  #1 clk = ! clk;

initial begin
    clk =1; KEY[3] = 0; err =0; #4;
    KEY[3] = 1; #3; //@6; wait 2 cycles

    assert (VGA_Y==0 && VGA_X==0 && VGA_PLOT==1 ) 
    $display("fillscreen activated at %d ps", $time);
    else  begin err = 1;  $display("Check: Fillscreen Failed at %d ps", $time);end

    #38398;//wait 120*160 cycles
    assert (VGA_Y==119 && VGA_X==159 && VGA_PLOT==1 ) 
    $display("fillscreen ended at %d ps", $time);
    else  begin err = 1;  $display("Check: Fillscreen Failed at %d ps", $time);end

    #6;//3 cycles

    assert (VGA_Y==72 && VGA_X==60 && VGA_PLOT==1 ) 
    $display("reuleaux activated at %d ps", $time);
    else  begin err = 1;  $display("Check: Reuleaux Failed at %d ps", $time);end

    #370;
    assert (VGA_Y==65 && VGA_X==109 && VGA_PLOT==0 ) 
    $display("reuleaux ended at %d ps", $time);
    else  begin err = 1;  $display("Check: Reuleaux Closing Failed at %d ps", $time);end #2;

    #6;
    assert (VGA_Y==0 && VGA_X==0 && VGA_PLOT==0 ) 
    $display("reuleaux_2 ended at %d ps", $time);
    else  begin err = 1;  $display("Check: Reuleaux Closing Failed at %d ps", $time);end

    #4;
    assert (VGA_Y==0 && VGA_X==0 && VGA_PLOT==0 ) 
    $display("Plotted at %d ps", $time);
    else  begin err = 1;  $display("Check: Reuleaux Plot Failed at %d ps", $time);end

    $stop;
end

endmodule: tb_syn_task4
