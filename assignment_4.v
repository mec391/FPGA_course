//Matthew Capuano -- EE 417 -- Feb. 17 2021
//Assignment 4:
//Part 1 = 4 bit BCD input to single 7 bit Seven-Seg Output - values 10-15 return BLANK
//Part 2 = 4 bit BCD input to two 7 bit Seven-Seg Outputs - displays up to value 15
//Extra Credit = Structural/Logic Level Equivalent of Part 2 using comparator and MUX
module assignment_4
(

//part 1 - Seven Segment Display
input      [3:0] bcd_in,
output reg [6:0] seven_seg_out,

//part 2 - Binary-Coded Decimal
output reg [6:0] hex0,
output reg [6:0] hex1,

//Extra Credit - Structural Design
output     [6:0] d0,
output     [6:0] d1

);
parameter BLANK = 7'b111_1111;
parameter ZERO  = 7'b000_0001;
parameter ONE   = 7'b100_1111;
parameter TWO   = 7'b001_0010;
parameter THREE = 7'b000_0110;
parameter FOUR  = 7'b100_1100;
parameter FIVE  = 7'b010_0100;
parameter SIX   = 7'b010_0000;
parameter SEVEN = 7'b000_1111;
parameter EIGHT = 7'b000_0000;
parameter NINE  = 7'b000_1100;

//part 1 - Seven Segment Display
always@(bcd_in)
case (bcd_in)
0:  seven_seg_out = ZERO; //0
1:  seven_seg_out = ONE;  //1
2:  seven_seg_out = TWO;  //2
3:  seven_seg_out = THREE;//3
4:  seven_seg_out = FOUR; //4
5:  seven_seg_out = FIVE; //5 
6:  seven_seg_out = SIX;  //6
7:  seven_seg_out = SEVEN;//7
8:  seven_seg_out = EIGHT;//8
9:  seven_seg_out = NINE; //9
10: seven_seg_out = BLANK; //OFF
11: seven_seg_out = BLANK; //OFF
12: seven_seg_out = BLANK; //OFF
13: seven_seg_out = BLANK; //OFF
14: seven_seg_out = BLANK; //OFF
15: seven_seg_out = BLANK; //OFF
default: seven_seg_out = 7'bZ;
endcase

//Part 2 - Binary-Coded Decimal
always@(bcd_in)
case (bcd_in)
0:  begin
	hex1 = ZERO; hex0 = ZERO;
	end
1:  begin
	hex1 = ZERO; hex0 = ONE;
	end
2:  begin
	hex1 = ZERO; hex0 = TWO;
	end
3:  begin
	hex1 = ZERO; hex0 = THREE;
	end
4:  begin
	hex1 = ZERO; hex0 = FOUR;
	end
5:  begin
	hex1 = ZERO; hex0 = FIVE;
	end
6:  begin
	hex1 = ZERO; hex0 = SIX;
	end
7:  begin
	hex1 = ZERO; hex0 = SEVEN;
	end
8:  begin
	hex1 = ZERO; hex0 = EIGHT;
	end
9:  begin
	hex1 = ZERO; hex0 = NINE;
	end
10: begin
	hex1 = ONE; hex0 = ZERO;
	end
11:begin
	hex1 = ONE; hex0 = ONE;
	end 
12: begin
	hex1 = ONE; hex0 = TWO;
	end
13: begin
	hex1 = ONE; hex0 = THREE;
	end
14: begin
	hex1 = ONE; hex0 = FOUR;
	end
15: begin
	hex1 = ONE; hex0 = FIVE;
	end
default: begin
		hex1 = 7'bZ; hex0 = 7'bZ;
		end
endcase


//Extra Credit - Structural Design
//if bcd_in =< 9, assert comparator LO, d1 = 0 (comparator), d0 = bcd_in (mux SEL: LO = comparator)
//if bcd_in >  9, assert comparator HI, d1 = 1 (comparator), d0 = circuit A (mux SEL HI = comparator)
wire comp_out;
assign comp_out = (bcd_in[3] & bcd_in[1]) | (bcd_in[3] & bcd_in[2]); //1 if > 9, 0 if < 9
assign d1 = comp_out ? ONE : ZERO; //route comparator output to D1

wire [3:0] mux_out;
wire [3:0] A_out;
assign mux_out = comp_out ? A_out : bcd_in; //route comparator output to MUX SEL

//switch statement for BCD to 7 seg from the MUX output (either circuit A or bcd_in)
assign d0[6] = (~mux_out[3] & ~mux_out[2] & ~mux_out[1] & mux_out[0]) | (~mux_out[3] & mux_out[2] & ~mux_out[1] & ~mux_out[0]);
assign d0[5] = (~mux_out[3] & mux_out[2] & ~mux_out[1] & mux_out[0]) | (~mux_out[3] & mux_out[2] & mux_out[1] & ~mux_out[0]);
assign d0[4] = ~mux_out[3] & ~mux_out[2] & mux_out[1] & ~mux_out[0];
assign d0[3] = (~mux_out[2] & ~mux_out[1] & mux_out[0]) | (~mux_out[3] & mux_out[2] & ~mux_out[1] & ~mux_out[0]) | (~mux_out[3] & mux_out[2] & mux_out[1] & mux_out[0]);
assign d0[2] = (~mux_out[3] & mux_out[0]) | (~mux_out[2] & ~mux_out[1] & mux_out[0]) | (~mux_out[3] & mux_out[2] & ~mux_out[1]);
assign d0[1] = (~mux_out[3] & ~mux_out[2] & mux_out[0]) | (~mux_out[3] & ~mux_out[2] & mux_out[1]) | (~mux_out[3] & mux_out[1] & mux_out[0]);
assign d0[0] = (~mux_out[3] & ~mux_out[2] & ~mux_out[1]) | (~mux_out[3] & mux_out[2] & mux_out[1] & mux_out[0]);

circuit_A cirA(
.bcd_in (bcd_in),
.out_a (A_out)
	);
endmodule

module circuit_A( //circuit A logic to subtract 10 from bcd_in when bcd_in is > 9
input [3:0] bcd_in,
output [3:0] out_a
);
assign out_a[3] = 0;
assign out_a[2] = bcd_in[3] & bcd_in[2] & bcd_in[1];
assign out_a[1] = bcd_in[3] & bcd_in[2] & ~bcd_in[1];
assign out_a[0] =(bcd_in[3] & bcd_in[1] & bcd_in[0]) | (bcd_in[3] & bcd_in[2] & bcd_in[0]);
endmodule

