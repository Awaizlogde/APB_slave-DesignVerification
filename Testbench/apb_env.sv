class apb_env;

apb_driver     drv;
apb_monitor    mon;
scoreboard     scb;
apb_generator  gen;

mailbox #(transaction) gen2drv;
mailbox #(transaction) mon2scb;

virtual apb_if vif;


function new(virtual apb_if vif);

this.vif = vif;

//create mailboxes
gen2drv = new();
mon2scb = new();

//create components
gen = new(gen2drv);
drv = new(vif, gen2drv);
mon = new();
scb = new(mon2scb);

//connect virtual if
drv.vif = vif;
mon.vif = vif;

//connect mailboxes
drv.gen2drv = gen2drv;
mon.mon2scb = mon2scb;

endfunction


task run(int num_txn);

fork

drv.run(num_txn);
mon.run();
scb.run(11);
join_none
gen.run(num_txn);
endtask

endclass
