//4 switches for bcd input, anything above 9 will output blank
//route to 7 segment output
module assignment_7
(
input      [3:0] bcd_in,
output reg [6:0] seven_seg_out,
output 	   [3:0] bcd_out
);

/*
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
*/
parameter BLANK = 7'b111_1111;
parameter ZERO  = 7'b100_0000;
parameter ONE   = 7'b111_1001;
parameter TWO   = 7'b010_0100; //0 1 6 4 3
parameter THREE = 7'b011_0000; //0 1 6 2 3
parameter FOUR  = 7'b001_1001; //5 6 1 2 
parameter FIVE  = 7'b001_0010; //0 5 6 2 3
parameter SIX   = 7'b000_0010; //0 5 6 4 3 2 
parameter SEVEN = 7'b111_1000; //0 1 2
parameter EIGHT = 7'b000_0000;  
parameter NINE  = 7'b001_1000; //0 5 6 1 2

assign bcd_out = bcd_in;
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

endmodule