class apb_generator;

mailbox #(transaction) gen2drv;

bit [31:0] written_addr[$];
int num_txn;

function new(mailbox #(transaction) gen2drv);
this.gen2drv = gen2drv;
endfunction

task run(int num_txn); //Randomized run
transaction tr;

//Random Writes 5 Valid 
repeat(5) begin

tr = new();

if (!tr.randomize() with {write==1;} )
$fatal("[GEN]Transaction randomization failed");
written_addr.push_back(tr.addr);
gen2drv.put(tr);
$display("[GEN] WRITE ADDR=%0h WRITE=%0b WDATA=%0h",tr.addr, tr.write, tr.wdata);
end

//5 Valid Read same Address
foreach (written_addr[i])begin
tr = new();

tr.addr = written_addr[i];
tr.write = 0;
tr.wdata = 0;

gen2drv.put(tr);
$display("[GEN] READ ADDR=%0h WRITE=%0b",tr.addr, tr.write);
end

//1 Invalid address
tr = new ();
tr.addr = 32;
tr.wdata = 32'hDEAD_0001;
tr.write = 0;

gen2drv.put(tr);

$display("[GEN] INVALID READ ADDR=%0h WRITE=%0b",tr.addr, tr.write);


endtask

//Directed run 
/*
task run(int num_txn);
transaction tr;

// WRITE
tr = new();
tr.addr  = 5;
tr.write = 1;
tr.wdata = 32'hAAAA;
gen2drv.put(tr);

tr = new();
tr.addr  = 10;
tr.write = 1;
tr.wdata = 32'hBBBB;
gen2drv.put(tr);

tr = new();
tr.addr  = 20;
tr.write = 1;
tr.wdata = 32'hCCCC;
gen2drv.put(tr);

// READ
tr = new();
tr.addr  = 5;
tr.write = 0;
gen2drv.put(tr);

tr = new();
tr.addr  = 10;
tr.write = 0;
gen2drv.put(tr);

tr = new();
tr.addr  = 20;
tr.write = 0;
gen2drv.put(tr);
endtask
*/

endclass
