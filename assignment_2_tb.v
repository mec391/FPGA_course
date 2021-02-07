`timescale 1ns/1ns

module assignment_2_tb();

//input drivers
reg [3:0] A;
reg [3:0] B;


//output receivers
wire a_eq_b_out;
wire a_lt_b_out;
wire a_gt_b_out;


//route to unit under test
assignment_2 UUT(
 
.a 				(A),
.b 				(B),
.a_eq_b_out 	(a_eq_b_out),
.a_lt_b_out 	(a_lt_b_out),
.a_gt_b_out 	(a_gt_b_out)

);

//feed input logic to UUT
initial begin

   {A,B} = 8'b0000_0000;//0
#1 {A,B} = 8'b0000_0001;//1
#1 {A,B} = 8'b0000_0010;//2
#1 {A,B} = 8'b0000_0011;//3
#1 {A,B} = 8'b0000_0100;//4
#1 {A,B} = 8'b0000_0101;//5
#1 {A,B} = 8'b0000_0110;//6
#1 {A,B} = 8'b0000_0111;//7
#1 {A,B} = 8'b0000_1000;//8
#1 {A,B} = 8'b0000_1001;//9
#1 {A,B} = 8'b0000_1010;//10
#1 {A,B} = 8'b0000_1011;//11
#1 {A,B} = 8'b0000_1100;//12
#1 {A,B} = 8'b0000_1101;//13
#1 {A,B} = 8'b0000_1110;//14
#1 {A,B} = 8'b0000_1111;//15

#1 {A,B} = 8'b1100_0011;
#1 {A,B} = 8'b0011_1100;
#1 {A,B} = 8'b0100_0011;
#1 {A,B} = 8'b0001_1101;
#1 {A,B} = 8'b1000_0100;
#1 {A,B} = 8'b0010_1111;
#1 {A,B} = 8'b1010_0100;
#1 {A,B} = 8'b0110_1111;
end

//generate monitor
initial begin
$monitor($time,,"%h %h %b %b %b",A, B, a_eq_b_out, a_lt_b_out, a_gt_b_out);
end 

endmodule
