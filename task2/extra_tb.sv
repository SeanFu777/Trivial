module tb_rtl_fillscreen();

logic clk, rst_n, start, done, vga_plot, err;
logic [2:0] colour, vga_colour;
logic [7:0] vga_x;
logic [6:0] vga_y;

fillscreen DUT  (    
                   clk,   rst_n, colour,
                   start, done,
                   vga_x, vga_y,
                   vga_colour,  vga_plot
                );

initial forever #5 clk = ! clk;

initial begin
    clk   = 1; rst_n = 0; err = 0; #10;
    
    assert(DUT.mask == 0 && DUT.done == 0 && vga_x == 0 && vga_y == 0 && vga_plot == 0 && vga_colour == 0)
    $display("Check: Reset State at%d ps", $time);
    else begin err = 1; $display("Check Failed: Reset State at%d ps", $time);end

    rst_n = 1; start = 1; #10;

    assert(DUT.mask == 1 && DUT.done == 0 && vga_x == 0 && vga_y == 0 && vga_plot == 1 && vga_colour == 0)
    $display("Check: Start State at%d ps", $time);
    else begin err = 1; $display("Check Failed: Start State at%d ps", $time);end

    #192000;
    assert(DUT.mask == 0 && DUT.done == 1 && vga_x == 159 && vga_y == 119 && vga_plot == 0 && vga_colour == 7)
    $display("Check: Ending State at%d ps", $time);
    else begin err = 1; $display("Check Failed: Ending State at%d ps", $time);end
    
    start = 0;#10;
    assert(DUT.mask == 0 && DUT.done == 0 && vga_x == 159 && vga_y == 119 && vga_plot == 0 && vga_colour == 7)
    $display("Check: Halt State at%d ps", $time);
    else begin err = 1; $display("Check Failed: Halt State at%d ps", $time);end


    #50;
    start =1; #100;
    $stop;


end

endmodule: tb_rtl_fillscreen
