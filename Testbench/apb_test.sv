import apb_package::*;

class apb_test;

apb_env env;
scoreboard scb;

int num_txn = 11;

function new(virtual apb_if vif);
env = new(vif);
endfunction

task run();

env.drv.reset();

env.run(num_txn);
@(env.scb.test_done);

$display("================================");
$display("APB TEST SUMMARY");
$display("MATCHES    = %0d", env.scb.match_cnt);
$display("MISMATCHES = %0d", env.scb.mismatch_cnt);
$display("ERROR = %0d", env.scb.error_cnt);
$display("================================");

endtask

endclass
