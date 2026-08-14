class apb_monitor;

virtual apb_if vif;
mailbox #(transaction) mon2scb;

task run();

transaction tr;


forever begin
@(posedge vif.PCLK);
#1;

if (vif.PSEL && vif.PENABLE && vif.PREADY) begin

tr = new();

tr.addr  = vif.PADDR;
tr.write = vif.PWRITE;
tr.wdata = vif.PWDATA;

tr.rdata  = vif.PRDATA;
tr.ready  = vif.PREADY;
tr.slverr = vif.PSLVERR;

$display("[MON] ADDR=%0h WRITE=%0b WDATA=%0h RDATA=%0h READY=%0b SLV_ERR=%0b",
         tr.addr, tr.write, tr.wdata, tr.rdata,
         tr.ready, tr.slverr );

mon2scb.put(tr);
end

end

endtask

endclass