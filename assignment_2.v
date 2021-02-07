//Matthew Capuano - EE 417 - Feb 3 2021 - assignment 2

//top module: (assignment_2) is 4 bit, 2 input comparator using a 2 bit comparator instantiations

//submodule:  (two_bit_comp) is a 2 bit comparator that uses 3 different implementations,
//	where only the implementation that gets routed to the top module gets synthesized

module assignment_2(
//4 bit inputs
input [3:0] a,
input [3:0] b,


//4 bit comparator outputs
output a_eq_b_out,
output a_gt_b_out,
output a_lt_b_out

);

wire a_eq_b_MSB;
wire a_lt_b_MSB;
wire a_gt_b_MSB;
wire a_eq_b_LSB;
wire a_lt_b_LSB;
wire a_gt_b_LSB;

//2 input 2 bit comparator inst. MSB
two_bit_comp tbcg0(
.a (a[3:2]),
.b (b[3:2]),
.a_eq_b (a_eq_b_MSB),
.a_lt_b (a_lt_b_MSB),
.a_gt_b (a_gt_b_MSB)

);

//2 input 2 bit comparator isnt. LSB
two_bit_comp tbcg1(
.a (a[1:0]),
.b (b[1:0]),
.a_eq_b (a_eq_b_LSB),
.a_lt_b (a_lt_b_LSB),
.a_gt_b (a_gt_b_LSB)

);

assign a_eq_b_out = a_eq_b_MSB & a_eq_b_LSB; 					//logic for the output of the 2 two_bit_comp submodules
assign a_lt_b_out = a_lt_b_MSB | (a_eq_b_MSB & a_lt_b_LSB);
assign a_gt_b_out = a_gt_b_MSB | (a_eq_b_MSB & a_gt_b_LSB);

endmodule





///2 bit comparator module using 3 different implementations
module two_bit_comp(
input [1:0] a,
input [1:0] b,
output a_eq_b,
output a_lt_b,
output a_gt_b

);

//2 bit comparator primitive gates fn
wire a_eq_b_gates;
wire a_lt_b_gates;
wire a_gt_b_gates;

wire s0, s1, s2, s3;									//a == b ciruit
and and0(s0, ~a[1], ~a[0], ~b[1], ~b[0]); 
and and1(s1, ~a[1], a[0], ~b[1], b[0]);
and and2(s2, a[1], a[0], b[1], b[0]);
and and3(s3, a[1], ~a[0], b[1], ~b[0]);
or   or0(a_eq_b_gates, s0, s1, s2, s3);

wire s4, s5, s6;								//a < b circuit 
and and4(s4, ~a[1], b[1]);
and and5(s5, ~a[1], ~a[0], b[0]);
and and6(s6, ~a[0], b[1], b[0]);
or   or1(a_lt_b_gates, s4, s5, s6);

wire s7, s8, s9;							//a > b circuit
and and7(s7, a[1], ~b[1]);
and and8(s8, a[0], ~b[1], ~b[0]);
and and9(s9, a[1], a[0], ~b[0]);
or    or2(a_gt_b_gates, s7, s8, s9);																								
 

 //2 bit comparator switching fn 
wire a_eq_b_switch;
wire a_lt_b_switch;
wire a_gt_b_switch;
 
assign a_eq_b_switch = ((~a[1]) & (~a[0]) & (~b[1]) & (~b[0])) | ((~a[1]) & a[0] & (~b[1])  & b[0]) | (a[1] & a[0] & b[1] & b[0]) | (a[1] & (~a[0]) & b[1] & (~b[0]));
assign a_lt_b_switch = ((~a[1]) & b[1]) | ((~a[1]) & (~a[0]) & b[0]) | ((~a[0]) & b[1] & b[0]);
assign a_gt_b_switch = (a[1] & (~b[1])) | (a[0] & (~b[1]) & (~b[0])) | (a[1] & a[0] & (~b[0]));
 
 
//2 bit comparator conditional fn
wire a_eq_b_cond;
wire a_lt_b_cond;
wire a_gt_b_cond;

assign a_eq_b_cond = (a == b)? 1'b1 : 1'b0;
assign a_lt_b_cond =  (a < b)? 1'b1 : 1'b0;
assign a_gt_b_cond =  (a > b)? 1'b1 : 1'b0;


//route one of the implementations to the output
assign a_eq_b = a_eq_b_cond;
assign a_lt_b = a_lt_b_cond;
assign a_gt_b = a_gt_b_cond; 
endmodule


