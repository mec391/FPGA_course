/*
Matthew Capuano
EE 417
Assignment 1
Assignemnt Date: 1/27/2021
*/

module assignment_1(

//design 1:
input  A,
input  B,
input  C,
input  D,
output Y,

//design 2 (1BIT 2-1 MUX):
input  A2,
input  B2,
input  sel2,
output Y2,

//design 2 (4BIT 2-1 MUX):
input [3:0]  A3,
input [3:0]  B3,
input        sel3,
output [3:0] Y3,

//design 2 (4BIT 4-1 MUX):
input [3:0] A4,
input [3:0] B4,
input [3:0] C4,
input [3:0] D4,
input [1:0] sel4,
output [3:0] Y4
);

//design 1:
wire s1;
wire s2;

or or1(s1, A, D);				///implementation of primitive logics gates for design 1
and and1(s2, B, C, !D);
and and2(Y, !s1, s2);


//design 2: (1BIT 2-1MUX)
wire s3;
wire s4;

and and3(s3, B2, sel2);     ////implementation of primitive logic gates for part A of design 2
and and4(s4, A2, !sel2);
or or2(Y2, s3, s4);


//design 2: (4BIT 2-1MUX)
mux2_1 mu0(						////instantiation of 4 instances of 1 bit 2-1 mux, one for each input bit for part C of design 2
.a   (A3[0]),					//the same select bit gets routed to every instance
.b   (B3[0]),
.sel (sel3),
.y   (Y3[0])

);

mux2_1 mu1(
.a   (A3[1]),
.b   (B3[1]),
.sel (sel3),
.y   (Y3[1])

);

mux2_1 mu2(
.a   (A3[2]),
.b   (B3[2]),
.sel (sel3),
.y   (Y3[2])


);


mux2_1 mu3(
.a   (A3[3]),
.b   (B3[3]),
.sel (sel3),
.y   (Y3[3])

);

//design 2: (4Bit 4-1MUX)
mux4_1 mux0(   				///instantiation of 4 instances of 1 bit 4-1 mux, one for each input bit for part D of design 2
.a (A4[0]),						//the same select bits get routed to every instance
.b (B4[0]),
.c (C4[0]),
.d (D4[0]),
.sel1 (sel4[1]),
.sel0 (sel4[0]),
.y (Y4[0])
);

mux4_1 mux1(
.a (A4[1]),
.b (B4[1]),
.c (C4[1]),
.d (D4[1]),
.sel1 (sel4[1]),
.sel0 (sel4[0]),
.y (Y4[1])
);
mux4_1 mux2(
.a (A4[2]),
.b (B4[2]),
.c (C4[2]),
.d (D4[2]),
.sel1 (sel4[1]),
.sel0 (sel4[0]),
.y (Y4[2])
);

mux4_1 mux3(
.a (A4[3]),
.b (B4[3]),
.c (C4[3]),
.d (D4[3]),
.sel1 (sel4[1]),
.sel0 (sel4[0]),
.y (Y4[3])
);

endmodule







//2-1 1 Bit Mux Module      	
module mux2_1(
input a,
input b,
input sel,
output y
);

wire s5;
wire s6;
									///primitive gate logic used when mux2_1 is instantiated
and and5(s5, b, sel);
and and6(s6, a, !sel);
or or3(y, s5, s6);


endmodule


//4-1 1 Bit Mux Module
module mux4_1(
input a,
input b,
input c,
input d,
input sel1,
input sel0,
output y
);

wire s7;
wire s8;
wire s9;
wire s10;
										///primitive gate logic used when mux4_1 is instantiated
and and7(s7, a, !sel1, !sel0);
and and8(s8, b, !sel1,  sel0);
and and9(s9, c,  sel1, !sel0);
and and10(s10, d, sel1, sel0);
or (y, s7, s8, s9, s10);


endmodule

 