module apb_slave #(parameter DATA_WIDTH = 32, ADDR_WIDTH = 32, N=2, ERR_VALUE=8'd32)(
input logic PCLK, ///PERIPHERAL CLOCK
input logic PRESETn, //ACTIVE LOW RESET
input logic PSEL,  //SLAVE SEL
input logic PENABLE, //ENABLE SIGNAL
input logic PWRITE, // 1 -> WRITE, 0-> READ
input logic [ADDR_WIDTH-1:0] PADDR, //ADDRESS OF SLAVE
input logic [DATA_WIDTH-1:0] PWDATA, // WRITE DATA

output logic [DATA_WIDTH-1:0] PRDATA, //READ DATA
output logic PREADY, 
output logic PSLVERR
);


logic [$clog2(N+1)-1:0]wait_counter ;

logic [ADDR_WIDTH-1:0] addr_reg;
logic [DATA_WIDTH-1:0] wdata_reg;
logic write_reg;

logic [DATA_WIDTH-1:0] mem [0:31]; //32-bit with 32 loc MEMEORY

typedef enum logic [1:0] {IDLE, SETUP, ACCESS} state_t;
state_t present_state, next_state;

always_ff@(posedge PCLK or negedge PRESETn) begin
if(!PRESETn) begin
present_state <= IDLE;
end
else present_state <= next_state;
end


always_comb begin
next_state = present_state;

case(present_state)

//IDLE
IDLE: begin
if(PSEL && !PENABLE) next_state = SETUP;
end

//SETUP
SETUP:begin
if(PSEL && PENABLE) begin
next_state = ACCESS;
end
end

//ACCESS
ACCESS: begin
if(wait_counter == N-1) begin
if(PSEL && !PENABLE) next_state = SETUP;
else next_state = IDLE;
end
else next_state = ACCESS;
end

default: next_state = IDLE;
endcase
end

//SETUP PHASE

always_ff@(posedge PCLK or negedge PRESETn)
begin
if(!PRESETn)begin
addr_reg <= 0;
wdata_reg <= 0;
write_reg <= 0;
end
else if (present_state == SETUP) begin
addr_reg <= PADDR;
wdata_reg <= PWDATA;
write_reg <= PWRITE;
end
end

//WAIT STATE

always_ff@(posedge PCLK or negedge PRESETn)begin
if(!PRESETn) 
wait_counter <= 0;
else if(present_state == ACCESS)begin
if(wait_counter < N-1) 
wait_counter <= wait_counter + 1;
end
else
wait_counter <= 0;
end

//OUTPUT + DATA

always_ff@(posedge PCLK or negedge PRESETn)begin
if(!PRESETn)begin
PRDATA <= 0;
PREADY <= 0;
PSLVERR <= 0;
end
else begin 
PREADY <= 0;
PSLVERR <= 0;
if (present_state == ACCESS)begin
if(wait_counter == N-1) begin
PREADY <= 1;

if(addr_reg >= $size(mem)) begin //ERR_VLAUE is pre setted value which is considered INAVLID
PSLVERR <= 1;
end else begin
if(write_reg) begin
mem[addr_reg] <= wdata_reg;
end
else begin
PRDATA <= mem[addr_reg];
end
end
end
end
end
end
endmodule
