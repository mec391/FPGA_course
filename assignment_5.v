/*
Matthew Capuano  -- EE 417 Lab 5, State machines for manchester, nrz, pam4 conversion, experimenting with different SM styles w/ 1, 2, or 3 always blocks
*/

module assignment_5(
input i_clk,

//manchester / NRZ conversion
input i_manchester,
input i_nrz,

output o_nrz_moore,
output o_nrz_mealy,
output o_manchester_moore,
output o_manchester_mealy,

//nrz to pam4 conversion
input i_nrz_p4,
input [1:0] i_pam4,

output o_nrz_moore_p4,
output [1:0] o_pam4_moore,
output [1:0] o_pam4_moore_2,

output o_clk_div,

output [3:0] debug,

input i_reset_n
);

wire w_clk_div; //half speed of i_clk

reg [3:0] r_state0; //man-nrz mealy
reg [3:0] r_state1; //man-nrz moore
reg [3:0] r_state2; //nrz-man mealy
reg [3:0] r_state3; //nrz-man moore
reg [3:0] r_state4; //nrz-pam4 moore
reg [3:0] r_state4_2; //nrz-pam4 mealy no delay
reg [3:0] r_state5; //pam4-nrz mealy 

reg [3:0] r_state0_out;
reg [3:0] r_state1_out;
reg [3:0] r_state2_out;
reg [3:0] r_state3_out; 
reg [3:0] r_state4_out;
reg [3:0] r_state4_2_out;
reg [3:0] r_state5_out;

localparam RESET = 0;
localparam HI = 1;
localparam LO = 2;
localparam HI_LO = 3;
localparam LO_HI = 4;
assign debug = r_state0;

//man-nrz mealy - tested and works - 
assign o_nrz_mealy = r_state0_out;
always@(posedge i_clk or negedge i_reset_n)
begin
	if (~i_reset_n) begin r_state0 <= RESET; r_state0_out <= 0; end
else begin
case(r_state0)
RESET: begin
	if(i_manchester) begin r_state0 <= HI; r_state0_out <= r_state0_out; end
	else begin r_state0 <= LO; r_state0_out <= r_state0_out; end
	end
HI: begin
	if(i_manchester) begin r_state0 <= r_state0; r_state0_out <= r_state0_out; end
	else begin r_state0 <= HI_LO; r_state0_out <= 1; end
	end
LO:begin
	if(i_manchester) begin r_state0 <= LO_HI; r_state0_out <= 0; end
	else begin r_state0 <= r_state0; r_state0_out <= r_state0_out; end
	end
HI_LO:begin
	if(i_manchester) begin r_state0 <= HI; r_state0_out <= r_state0_out; end
	else begin r_state0 <= LO; r_state0_out <= r_state0_out; end
   end
LO_HI:begin
	if(i_manchester) begin r_state0 <= HI; r_state0_out <= r_state0_out; end
	else begin r_state0 <= LO; r_state0_out <= r_state0_out; end
   end

default:begin
	r_state0 <= 0;
	r_state0_out <= 0;
	end
endcase
end
end

//man-nrz moore //0-1 LO, 1-0 HI - needs tested
reg [3:0] r_next_state1;
assign o_nrz_moore = r_state1_out;
always@(posedge i_clk or negedge i_reset_n) //update state
begin
if(~i_reset_n) r_state1 <= RESET;
else r_state1 <= r_next_state1;
end
always@(r_state1) //compute output
begin
case(r_state1)
RESET: r_state1_out <= 0;
HI: r_state1_out <= r_state1_out;
LO: r_state1_out <= r_state1_out;
HI_LO: r_state1_out <= 1;
LO_HI: r_state1_out <= 0;
default: r_state1_out <= 0;
endcase
end
always@(r_state1 or i_manchester)//compute next state
begin
case(r_state1)
RESET: begin
if(i_manchester) r_next_state1 <= HI;
else r_next_state1 <= LO;
end
HI:begin
if(i_manchester) r_next_state1 <= r_next_state1;
else r_next_state1 <= HI_LO;
end
LO:begin
if(i_manchester) r_next_state1 <= LO_HI;
else r_next_state1 <= r_next_state1;
end
HI_LO:begin
if(i_manchester) r_next_state1 <= HI;
else r_next_state1 <= LO;
end
LO_HI:begin
if (i_manchester) r_next_state1 <= HI;
else r_next_state1 <= LO;
end
default: r_next_state1 <= RESET;
endcase
end

//nrz-man mealy  -- THIS NEEDS TESTED
localparam LO1 = 1;
localparam HI1 = 2;
localparam LO2 = 3;
localparam HI2 = 4;

assign o_manchester_mealy = r_state2_out;
always@(posedge i_clk or negedge i_reset_n)
begin
if(~i_reset_n) begin r_state2 <= RESET; r_state2_out <= 0; end
else begin
case (r_state2)
RESET: begin
if(i_nrz) begin r_state2 <= HI1; r_state2_out <= 1; end
	else begin r_state2 <= LO1; r_state2_out  <= 0; end
	end
LO1: begin
if(i_nrz)begin r_state2 <= r_state2; r_state2_out <= r_state2_out; end
	else begin r_state2 <= LO2; r_state2_out <= 1; end
	end
HI1: begin
if(i_nrz) begin r_state2 <= HI2; r_state2_out <= 0; end
	else begin r_state2 <= r_state2; r_state2_out <= r_state2_out; end
	end
LO2: begin
if(i_nrz) begin r_state2 <= HI1; r_state2_out <= 1; end
	else begin r_state2 <= LO1; r_state2_out <= 0; end 
end
HI2: begin
if (i_nrz) begin r_state2 <= HI1; r_state2_out <= 1; end
	else begin r_state2 <= LO1; r_state2_out <= 0; end
end
default : begin
r_state2 <= 0;
r_state2_out <= 0;
end
endcase
end
end

//nrz-man moore -- needs test
reg [3:0] r_next_state3;
assign o_manchester_moore = r_state3_out;
always@(posedge i_clk or negedge i_reset_n) //update state
begin
	if(~i_reset_n) begin r_state3 <= RESET;  end
else  r_state3 <= r_next_state3;
end
always@( r_state3) //compute output
begin
case(r_state3)
RESET: begin
r_state3_out <= 0;
end
LO1:begin
r_state3_out <= 0;
end
HI1:begin
r_state3_out <= 1;
end
LO2:begin
r_state3_out <= 1;
end
HI2:begin
r_state3_out <= 0;
end
default:begin
r_state3_out <= 0;
end
endcase
end

always@(r_state3 or i_nrz)//compute next state
begin
case(r_state3)
RESET:begin
if(i_nrz) r_next_state3 <= HI1;
else r_next_state3 <= LO1;
end
LO1:begin
if(i_nrz) r_next_state3 <= r_next_state3;
else r_next_state3 <= LO2;
end
HI1:begin
if(i_nrz) r_next_state3 <= HI2;
else r_next_state3 <= r_next_state3;
end
LO2:begin
if(i_nrz) r_next_state3 <= HI1;
else r_next_state3 <= LO1;
end
HI2:begin
if(i_nrz) r_next_state3 <= HI1;
else r_next_state3 <= LO1;
end
default:begin
r_next_state3 <= 0;
end
endcase
end

//nrz-pam4  moore - 1 clock cycle delay - tested and works
localparam FIRST_ZERO = 1;
localparam FIRST_ONE = 2;
localparam OUT_ZERO = 3;
localparam OUT_ONE = 4;
localparam OUT_TWO = 5;
localparam OUT_THREE =6;

assign o_pam4_moore = r_state4_out;

always@(posedge i_clk)
begin
case(r_state4)
	RESET: begin
			r_state4_out <= 0;
			if(~i_nrz_p4) r_state4 <= FIRST_ZERO;
			else r_state4 <= FIRST_ONE;
			end

	FIRST_ZERO: begin
			r_state4_out <= r_state4_out;
			if(~i_nrz_p4) r_state4 <= OUT_ZERO;
			else r_state4 <= OUT_ONE;
				end
	FIRST_ONE: begin
			r_state4_out <= r_state4_out;
			if(~i_nrz_p4) r_state4 <= OUT_TWO;
			else r_state4 <= OUT_THREE;
				end

	OUT_ZERO:  begin
			r_state4_out <= 0;
			if(~i_nrz_p4) r_state4 <= FIRST_ZERO;
			else r_state4 <= FIRST_ONE;
				end

	OUT_ONE:  begin
			r_state4_out <= 1;
			if(~i_nrz_p4) r_state4 <= FIRST_ZERO;
			else r_state4 <= FIRST_ONE;
			 	end

	OUT_TWO:  begin
			r_state4_out <= 2;
			if(~i_nrz_p4) r_state4 <= FIRST_ZERO;
			else r_state4 <= FIRST_ONE;
				end

	OUT_THREE: begin
			r_state4_out <= 3;
			if(~i_nrz_p4) r_state4 <= FIRST_ZERO;
			else r_state4 <= FIRST_ONE;
				end
	default: begin
			r_state4_out <= 0;
			r_state4 <= RESET;
			end
endcase
end


//nrz-pam4 - mealy - no clock cycle delay - tested and works
assign o_pam4_moore_2 = r_state4_2_out;

always@(posedge i_clk)
begin
case(r_state4_2)
	RESET: begin
			if(~i_nrz_p4) begin r_state4_2 <= FIRST_ZERO;  r_state4_2_out <= 0; end
			else begin			 r_state4_2 <= FIRST_ONE;  r_state4_2_out <= 0; end 
			end

	FIRST_ZERO: begin
			if(~i_nrz_p4) begin r_state4_2 <= OUT_ZERO;  r_state4_2_out <= 0; end
			else begin 			r_state4_2 <= OUT_ONE;  r_state4_2_out <= 1; end
				end
	FIRST_ONE: begin
			if(~i_nrz_p4) begin r_state4_2 <= OUT_TWO;   r_state4_2_out <= 2; end
			else begin 			r_state4_2 <= OUT_THREE; r_state4_2_out <= 3; end
				end

	OUT_ZERO:  begin
			if(~i_nrz_p4) begin r_state4_2 <= FIRST_ZERO; r_state4_2_out <= r_state4_2_out; end
			else begin 			r_state4_2 <= FIRST_ONE;  r_state4_2_out <= r_state4_2_out; end
				end

	OUT_ONE:  begin
			if(~i_nrz_p4) begin r_state4_2 <= FIRST_ZERO; r_state4_2_out <= r_state4_2_out; end
			else begin 			r_state4_2 <= FIRST_ONE;  r_state4_2_out <= r_state4_2_out; end
			 	end

	OUT_TWO:  begin
			if(~i_nrz_p4) begin r_state4_2 <= FIRST_ZERO; r_state4_2_out <= r_state4_2_out; end
			else begin 			r_state4_2 <= FIRST_ONE;  r_state4_2_out <= r_state4_2_out; end
				end

	OUT_THREE: begin
			if(~i_nrz_p4) begin r_state4_2 <= FIRST_ZERO;  r_state4_2_out <= r_state4_2_out; end
			else begin 			r_state4_2 <= FIRST_ONE;   r_state4_2_out <= r_state4_2_out; end
				end
	default: begin
			r_state4_2_out <= 0;
			r_state4_2 <= RESET;
			end
endcase
end

localparam FIRST_TWO = 3;
localparam FIRST_THREE = 4;
localparam SEC_ZERO = 5;
localparam SEC_ONE = 6;
localparam SEC_TWO = 7;
localparam SEC_THREE = 8;

//pam4-nrz mealy - tested and works
assign o_nrz_moore_p4 = r_state5_out;

always@(posedge i_clk)
begin
case(r_state5)
RESET: begin
		if(i_pam4 == 0) begin r_state5 <= FIRST_ZERO; r_state5_out <= 0; end
		else if (i_pam4 == 1) begin r_state5 <= FIRST_ONE; r_state5_out <= 0; end
		else if (i_pam4 == 2) begin r_state5 <= FIRST_TWO; r_state5_out <= 1; end
		else if (i_pam4 == 3) begin r_state5 <= FIRST_THREE; r_state5_out <= 1; end
		else begin r_state5 <= r_state5; r_state5_out <= r_state5_out; end
		end
FIRST_ZERO: begin
			r_state5 <= SEC_ZERO; r_state5_out <= 0;
			end

FIRST_ONE: begin
			r_state5 <= SEC_ONE; r_state5_out <= 1;
			end

FIRST_TWO: begin
			r_state5 <= SEC_TWO; r_state5_out <= 0;
			end

FIRST_THREE: begin
			r_state5 <= SEC_THREE; r_state5_out <= 1;
			end

SEC_ZERO:  begin
			if(i_pam4 == 0) begin r_state5 <= FIRST_ZERO; r_state5_out <= 0; end
		else if (i_pam4 == 1) begin r_state5 <= FIRST_ONE; r_state5_out <= 0; end
		else if (i_pam4 == 2) begin r_state5 <= FIRST_TWO; r_state5_out <= 1; end
		else if (i_pam4 == 3) begin r_state5 <= FIRST_THREE; r_state5_out <= 1; end
			else begin r_state5 <= r_state5; r_state5_out <= r_state5_out; end
			end

SEC_ONE:  begin
			if(i_pam4 == 0) begin r_state5 <= FIRST_ZERO; r_state5_out <= 0; end
		else if (i_pam4 == 1) begin r_state5 <= FIRST_ONE; r_state5_out <= 0; end
		else if (i_pam4 == 2) begin r_state5 <= FIRST_TWO; r_state5_out <= 1; end
		else if (i_pam4 == 3) begin r_state5 <= FIRST_THREE; r_state5_out <= 1; end
			else begin r_state5 <= r_state5; r_state5_out <= r_state5_out; end
		 end

SEC_TWO:  begin
		if(i_pam4 == 0) begin r_state5 <= FIRST_ZERO; r_state5_out <= 0; end
		else if (i_pam4 == 1) begin r_state5 <= FIRST_ONE; r_state5_out <= 0; end
		else if (i_pam4 == 2) begin r_state5 <= FIRST_TWO; r_state5_out <= 1; end
		else if (i_pam4 == 3) begin r_state5 <= FIRST_THREE; r_state5_out <= 1; end
			else begin r_state5 <= r_state5; r_state5_out <= r_state5_out; end
		end

SEC_THREE: begin
		if(i_pam4 == 0) begin r_state5 <= FIRST_ZERO; r_state5_out <= 0; end
		else if (i_pam4 == 1) begin r_state5 <= FIRST_ONE; r_state5_out <= 0; end
		else if (i_pam4 == 2) begin r_state5 <= FIRST_TWO; r_state5_out <= 1; end
		else if (i_pam4 == 3) begin r_state5 <= FIRST_THREE; r_state5_out <= 1; end
			else begin r_state5 <= r_state5; r_state5_out <= r_state5_out; end
			end
	default: 
		begin r_state5 <= 0; r_state5_out <= 0; end

endcase


end


clk_divider cd0(
.i_clk(i_clk),
.o_div_clk(w_clk_div)
	);
assign o_clk_div = w_clk_div;

endmodule

//use input clock as double speed clk for manchester encoding,
//use clk divider to drive system clock for rest of system
module clk_divider(
input i_clk,
output  o_div_clk
	);
reg clkr = 1;
assign o_div_clk = clkr;
always@(posedge i_clk)
begin
	clkr <= !clkr;
end


endmodule