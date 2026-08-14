class scoreboard;

mailbox #(transaction) mon2scb;

event test_done;

bit [31:0] ref_mem[31:0];

int match_cnt, mismatch_cnt, checked_cnt;
int error_cnt;

function new(mailbox #(transaction) mon2scb);
this.mon2scb = mon2scb;

match_cnt = 0;
mismatch_cnt = 0;
checked_cnt = 0;
error_cnt = 0;

foreach (ref_mem[i])
ref_mem[i] = 0;

endfunction

task run(int num_txn);

bit [31:0] expected;
transaction tr;

forever begin

mon2scb.get(tr);

checked_cnt ++;
$display("CHECK COUNT = %0d",checked_cnt);

if(tr.slverr)begin
error_cnt++;
$display("[SCB] PSLAVE ERROR ADDR = %0h", tr.addr);
end
else
if(tr.write) begin
ref_mem[tr.addr] = tr.wdata;
$display("[SCB] WRITE ADDR = %0h  DATA=%0h", tr.addr, tr.wdata);
end
else begin
expected = ref_mem[tr.addr];

if(tr.rdata == expected)begin
match_cnt++;
$display("[SCB] READ PASS ADDR = %0h EXPECTED = %0h ACTUAL=%0h", tr.addr, expected,tr.rdata);
end
else begin
mismatch_cnt++;
$display("[SCB] READ FAIL ADDR = %0h EXPECTED = %0h ACTUAL=%0h", tr.addr, expected,tr.rdata);

end
end

if(checked_cnt == num_txn) 
-> test_done;

end

endtask

endclass