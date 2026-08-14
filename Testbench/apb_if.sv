
interface apb_if(input logic PCLK);
  logic PRESETn;
  logic [31:0] PADDR;
  logic [31:0] PWDATA;
  logic PSEL;
  logic PENABLE;
  logic PWRITE;
  logic [31:0] PRDATA;
  logic PREADY;
  logic PSLVERR;

// Master Clocking Block: Ensures drive/sample happens at the right time
//clocking clk @(posedge PCLK);
//default input #1ns output #1ns;
//output PADDR, PWDATA, PSEL, PENABLE, PWRITE, PRESETn;
//input  PRDATA, PREADY, PSLVERR;
//endclocking

endinterface