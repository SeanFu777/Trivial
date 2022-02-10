/*======================================================================
This is a simple post-syns testbench for the module fillscreen. It is a 
slightly modified version of the trl testbench. It will will force the
screen to be filled twice in order to fully test out the hand-shaking 
protcol. More details will be given in the terminal
======================================================================*/
module tb_syn_fillscreen();

logic clk, rst_n, start, done, vga_plot, err;
logic [2:0] colour, vga_colour;
logic [7:0] vga_x;
logic [6:0] vga_y;

logic [7:0] index_x;
logic [7:0] index_y;


fillscreen DUT  (    
                   clk,   rst_n, colour,
                   start, done,
                   vga_x, vga_y,
                   vga_colour,  vga_plot
                );

initial forever #1 clk = ! clk;

initial begin

    clk   = 1; rst_n = 0; err = 0; #2;
    index_x = 0; index_y = 0;

    //Check Reste State 
    assert( vga_x == 0 && vga_y == 0 && vga_plot == 0 && vga_colour == 0)
    $display("Check: Reset State at%d ps", $time);
    else begin err = 1; $display("Check Failed: Reset State at%d ps", $time);end

    rst_n = 1; start = 1; #1;

    //loop thru all coordinates
    for(index_x = 0; index_x < 160; index_x ++,index_y = 0) begin
        for (index_y = 0; index_y < 120;  index_y ++) begin
            assert(vga_x == index_x && vga_y == index_y && vga_plot == 1 && vga_colour == index_x[2:0] )
            $display("(%d, %d) passed at %d ps", index_x, index_y, $time);
            else begin $display("(%d, %d) failed at %d ps", index_x, index_y, $time); 
                       $display ("index_x  = %d, vga_x = %d", index_x, vga_x);
                       $display ("index_y  = %d, vga_y = %d", index_y, vga_y);
                       $display ("vga_plot = %d, vga_colour =%d", vga_plot,vga_colour);
                       $stop;
                    end
            #2;
        end
    end

    //Check Final States
    assert(done == 1 && vga_x == 159 && vga_y == 119 && vga_plot == 0 && vga_colour == 7)
    begin $display("Check: Ending State at%d ps", $time); #2;end
    else begin err = 1; $display("Check Failed: Ending State at%d ps", $time);end 

    start = 0; #2;
    //Check Hand-shaking protcol
    assert(done == 0 && vga_x == 159 && vga_y == 119 && vga_plot == 0 && vga_colour == 7)
    $display("Check: Halt State at%d ps", $time);
    else begin err = 1; $display("Check Failed: Halt State at%d ps", $time);end
    
    //Loop thru all coordinates again
    start = 1; #2;

        for(index_x = 0; index_x < 160; index_x ++,index_y = 0) begin
        for (index_y = 0; index_y < 120;  index_y ++) begin
            assert(vga_x == index_x && vga_y == index_y && vga_plot == 1 && vga_colour == index_x[2:0] )
            $display("(%d, %d) passed at %d ps", index_x, index_y, $time);
            else begin $display("(%d, %d) failed at %d ps", index_x, index_y, $time); 
                       $display ("index_x  = %d, vga_x = %d", index_x, vga_x);
                       $display ("index_y  = %d, vga_y = %d", index_y, vga_y);
                       $display ("vga_plot = %d, vga_colour =%d", vga_plot,vga_colour);
                       $stop;
                    end
            #2;
        end
    end 
    #10; start = 0; #10;
    $stop;


end

endmodule: tb_syn_fillscreen
