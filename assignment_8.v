//UART Transmitter - design from book
//specify loadable shift register(muxes with control) or revolving selector(state machine with counter) for parallel to serial conversion
//hardware implementation: clock controlled by pushbutton?? load data on 7 seg
module assignment_8#(
parameter word_size = 8)
(
output o_serial_out,
input [word_size-1:0] i_data_bus, 

input i_load_xmt_data, //load the data reg
input i_byte_rdy, //ready for transmission
input i_T_byte, //start transmission
input i_clk,
input i_reset_n
);

wire w_load_xmt_datareg;
wire w_load_xmt_shftreg;
wire w_start;
wire w_shift;
wire w_clear;
wire w_BC_lt_BCmax;

//instantiate control unit
Control_Unit cu0(

//to/from the data path module	
.o_load_xmt_datareg (w_load_xmt_datareg),
.o_load_xmt_shftreg (w_load_xmt_shftreg),
.o_start (w_start),
.o_shift (w_shift),
.o_clear (w_clear),
.i_BC_lt_BCmax (w_BC_lt_BCmax),

//from the top module
.i_load_xmt_datareg (i_load_xmt_data),
.i_byte_rdy (i_byte_rdy),
.i_T_byte (i_T_byte),

.i_clk (i_clk),
.i_reset_n (i_reset_n)
);


//instantiate datapath unit
Datapath_Unit du0(
//to top module
.o_serial_out (o_serial_out),
.i_data_bus (i_data_bus),

.i_clk (i_clk),
.i_reset_n (i_reset_n),

//to/from control unit module
.o_BC_lt_BCmax (w_BC_lt_BCmax),
.i_load_xmt_datareg (w_load_xmt_datareg),
.i_load_xmt_shftreg (w_load_xmt_shftreg),
.i_start (w_start),
.i_shift (w_shift),
.i_clear (w_clear)
);
endmodule

module Control_Unit#(
parameter one_hot_cnt = 3, //one hot states
parameter state_cnt = one_hot_cnt, //bits in state reg
parameter size_bit_cnt = 3,
parameter idle = 3'b001, //one hot encoding
parameter waiting = 3'b010,
parameter sending = 3'b100,
parameter all_ones = 9'b1_1111_1111
)
(
output reg o_load_xmt_datareg, //load the data bus to XMT datareg
output reg o_load_xmt_shftreg, //load XMT data reg to XMT shiftreg
output reg o_start,  		//launch bitshifting in XMT shiftreg
output reg o_shift,			//shift bits in XMT shiftreg
output reg o_clear,       //clear bit_count after last msg
input i_load_xmt_datareg,  //assert load datareg in state idle
input i_byte_rdy,  //assert load shiftreg in state idle
input i_T_byte,
input i_BC_lt_BCmax,
input i_clk,
input i_reset_n
);
reg [state_cnt-1:0]r_state;
reg [state_cnt-1:0]r_next_state;

always@(r_state, i_load_xmt_datareg,i_byte_rdy,i_T_byte,i_BC_lt_BCmax) //define output and next state
begin
o_load_xmt_datareg = 0;
o_load_xmt_shftreg = 0;
o_start = 0;
o_shift = 0;
o_clear = 0;
r_next_state = idle;

case(r_state)
idle:	if(i_load_xmt_datareg == 1'b1)
		begin
		o_load_xmt_datareg = 1;
		r_next_state = idle;
		end
		else if (i_byte_rdy == 1'b1)
		begin
		o_load_xmt_shftreg = 1;
		r_next_state = waiting;
		end	
waiting: if(i_T_byte == 1)
		 begin
		 o_start = 1;
		 r_next_state = sending;
		 end else r_next_state = waiting;
sending: if(i_BC_lt_BCmax)
		 begin
		 o_shift = 1;
		 r_next_state = sending;
		 end
		 else begin
		 o_clear = 1;
		 r_next_state = idle;
		 end
default: r_next_state = idle;
endcase
end
always@(posedge i_clk, negedge i_reset_n) //perform state transitions
begin
if(i_reset_n == 1'b0)
r_state <= idle;
else r_state <= r_next_state;
end
endmodule

module Datapath_Unit#(
parameter word_size = 8,
parameter size_bit_cnt =3,
parameter all_ones = {(word_size+1){1'b1}}
)
(
output o_serial_out,
output o_BC_lt_BCmax,
input [word_size-1:0] i_data_bus,
input i_load_xmt_datareg,
input i_load_xmt_shftreg,
input i_start,
input i_shift,
input i_clear,
input i_clk,
input i_reset_n
);

reg [word_size-1:0] r_xmt_datareg;
reg [word_size:0] r_xmt_shftreg;
reg [size_bit_cnt:0] r_bit_cnt;

assign o_serial_out = r_xmt_shftreg[0];
assign o_BC_lt_BCmax = (r_bit_cnt < word_size + 1);

always@(posedge i_clk, negedge i_reset_n) //register transfers
if(~i_reset_n)
begin
r_xmt_shftreg <= all_ones;
r_bit_cnt <= 0;
end
else begin
if(i_load_xmt_datareg == 1'b1) r_xmt_datareg <= i_data_bus; //get data bus
if(i_load_xmt_shftreg == 1'b1) r_xmt_shftreg <= {r_xmt_datareg, 1'b1}; //load shift reg, insert stop bit

if(i_start== 1'b1) r_xmt_shftreg[0] <= 0; //start xmission
if(i_clear == 1'b1) r_bit_cnt <= 0;
if(i_shift == 1'b1) begin
r_xmt_shftreg <= {1'b1, r_xmt_shftreg[word_size:1]}; //shift right, fill with 1s
r_bit_cnt <= r_bit_cnt + 1;
end
end

endmodule