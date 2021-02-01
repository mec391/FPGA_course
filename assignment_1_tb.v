`timescale 1ns/1ns

module assignment_1_tb();

//Design 1 and Design 2 (1 BIT 2-1MUX)
reg A, B, C, D;
wire Y, Y2;

//Design 2 (4 BIT 2-1MUX)
reg [3:0]  A3, B3;
reg 		  sel3;
wire [3:0] Y3;

//Design 2 (4 BIT 4-1MUX)
reg [3:0] A4, B4, C4, D4;
reg [1:0] sel4;
wire [3:0] Y4;

assignment_1 UUT(
//Design 1 
.A 	(A),
.B 	(B),
.C 	(C),
.D 	(D),
.Y 	(Y),
//Design 2 1bit 2-1 Mux
.A2   (B),
.B2   (C),
.sel2 (D),
.Y2   (Y2),
//Design 2 4bit 2-1 Mux
.A3   (A3),
.B3   (B3),
.sel3 (sel3),
.Y3   (Y3),
//Design 2 4bit 4-1 Mux
.A4  (A4),
.B4  (B4),
.C4  (C4),
.D4  (D4),
.sel4 (sel4),
.Y4  (Y4)

);

initial begin
//Design 1 and Design 2 (1 BIT 2-1MUX)			//Inputs increment up by 1 per timestep
   A = 0; B = 0; C = 0; D = 0; //0				
#1 A = 0; B = 0; C = 0; D = 1; //1				//For design 2 (1 bit 2-1Mux), only the 3 LSB are needed (0-7)
#1 A = 0; B = 0; C = 1; D = 0; //2
#1 A = 0; B = 0; C = 1; D = 1; //3
#1 A = 0; B = 1; C = 0; D = 0; //4
#1 A = 0; B = 1; C = 0; D = 1; //5
#1 A = 0; B = 1; C = 1; D = 0; //6
#1 A = 0; B = 1; C = 1; D = 1; //7
#1 A = 1; B = 0; C = 0; D = 0; //8
#1 A = 1; B = 0; C = 0; D = 1; //9
#1 A = 1; B = 0; C = 1; D = 0; //10
#1 A = 1; B = 0; C = 1; D = 1; //11
#1 A = 1; B = 1; C = 0; D = 0; //12
#1 A = 1; B = 1; C = 0; D = 1; //13
#1 A = 1; B = 1; C = 1; D = 0; //14 
#1 A = 1; B = 1; C = 1; D = 1; //15

//Design 2 (4 BIT 2-1MUX)							//inputs increment up by 1 per timestep
#1 A3 = 0;      B3 = 8;      sel3 = 0; 	   //A starts at 0, B starts at 8
#1 A3 = A3 + 1; B3 = B3 + 1; sel3 = 1;			//Select switches between 0 and 1
#1 A3 = A3 + 1; B3 = B3 + 1; sel3 = 0;
#1 A3 = A3 + 1; B3 = B3 + 1; sel3 = 1;
#1 A3 = A3 + 1; B3 = B3 + 1; sel3 = 0;
#1 A3 = A3 + 1; B3 = B3 + 1; sel3 = 1;
#1 A3 = A3 + 1; B3 = B3 + 1; sel3 = 0;
#1 A3 = A3 + 1; B3 = B3 + 1; sel3 = 1;

//Design 2 (4 BIT 4-1MUX)                    //inputs increment up by 1 per timestep, with each input staggered by 4
#1 A4 = 0; B4 = 4; C4 = 8; D4 = 12; sel4 = 0;//Select increments by 1 each timestep starting with 0 (A)
#1 A4 = A4 + 1; B4 = B4 + 1; C4 = C4 + 1; D4 = D4 + 1; sel4 = sel4 + 1;
#1 A4 = A4 + 1; B4 = B4 + 1; C4 = C4 + 1; D4 = D4 + 1; sel4 = sel4 + 1;
#1 A4 = A4 + 1; B4 = B4 + 1; C4 = C4 + 1; D4 = D4 + 1; sel4 = sel4 + 1;
#1 A4 = A4 + 1; B4 = B4 + 1; C4 = C4 + 1; D4 = D4 + 1; sel4 = sel4 + 1;
#1 A4 = A4 + 1; B4 = B4 + 1; C4 = C4 + 1; D4 = D4 + 1; sel4 = sel4 + 1;
#1 A4 = A4 + 1; B4 = B4 + 1; C4 = C4 + 1; D4 = D4 + 1; sel4 = sel4 + 1;
#1 A4 = A4 + 1; B4 = B4 + 1; C4 = C4 + 1; D4 = D4 + 1; sel4 = sel4 + 1;
#1 A4 = A4 + 1; B4 = B4 + 1; C4 = C4 + 1; D4 = D4 + 1; sel4 = sel4 + 1;
end


endmodule
