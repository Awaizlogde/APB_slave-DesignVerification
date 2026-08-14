class transaction;

rand bit [31:0] addr;
rand bit [31:0] wdata;

rand bit write;

bit [31:0] rdata;
bit ready;
bit slverr;

constraint addr_c { addr inside {[0: 31]}; }

endclass
