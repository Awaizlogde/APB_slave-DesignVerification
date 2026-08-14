
class apb_driver;

virtual apb_if vif;

mailbox #(transaction) gen2drv;

function new(virtual apb_if vif, mailbox #(transaction) gen2drv);
this.vif = vif;
this.gen2drv = gen2drv;

endfunction

task reset();
vif.PRESETn = 0;
vif.PADDR = 0;
vif.PWDATA = 0;
vif.PSEL = 0;
vif.PENABLE = 0;
vif.PWRITE = 0;

repeat(2) @(posedge vif.PCLK);
vif.PRESETn = 1;

$display("[DRIVER] Reset complete @ %0t", $time);

endtask


task run(int num_txn);
transaction tr;
$display("[DRIVER] started");
forever begin

gen2drv.get(tr);
 $display("[DRIVER] got transaction");
@(posedge vif.PCLK)
vif.PADDR = tr.addr;
vif.PWDATA = tr.wdata;
vif.PWRITE = tr.write;
$display("[DRIVER] Driving ADDR=%0h WRITE=%0b WDATA=%0h",
         tr.addr, tr.write, tr.wdata);
// SETUP
vif.PSEL    = 1;
vif.PENABLE = 0;
@(posedge vif.PCLK);

// ACCESS
vif.PSEL = 1;
vif.PENABLE = 1;

@(posedge vif.PCLK);

// Wait for slave

while (!vif.PREADY) begin
    $display("[DRIVER] Waiting PREADY @ %0t", $time);
    @(posedge vif.PCLK);
end

// End transfer
vif.PSEL    = 0;
vif.PENABLE = 0;
end

endtask

endclass
