`timescale 1ns/1ps

module tb_apb_top;
import apb_package::*;
    // Clock
    logic PCLK;

    // Interface
    apb_if vif(PCLK);

    // DUT
    apb_slave #(
        .DATA_WIDTH(32),
        .ADDR_WIDTH(32),
        .N(2),
        .ERR_VALUE(8'd32)
    ) dut (
        .PCLK    (PCLK),
        .PRESETn (vif.PRESETn),
        .PSEL    (vif.PSEL),
        .PENABLE (vif.PENABLE),
        .PWRITE  (vif.PWRITE),
        .PADDR   (vif.PADDR),
        .PWDATA  (vif.PWDATA),

        .PRDATA  (vif.PRDATA),
        .PREADY  (vif.PREADY),
        .PSLVERR (vif.PSLVERR)
    );


    // Clock generation
    initial begin
        PCLK = 0;
        forever #5 PCLK = ~PCLK;
    end


    // Test
apb_test test;

    initial begin

        test = new(vif);

        test.run();

        #1000;
        $finish;

    end

endmodule
