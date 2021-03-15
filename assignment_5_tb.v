`timescale 1ns/1ns
module assignment_5_tb();
	reg   i_clk;
	
	reg  i_nrz_p4;
	wire [1:0] o_pam4_moore;
	wire [1:0] o_pam4_moore_2;
	
	reg [1:0] i_pam4;
	wire o_nrz_moore_p4;

	reg i_manchester;
	wire o_nrz_moore;
	wire o_clk_div;
	wire o_nrz_mealy;
	wire [3:0] debug;
	wire o_manchester_moore;
	reg i_nrz;

	reg i_reset_n;
	
	wire o_manchester_mealy;

assignment_5 UUT(
.i_clk (i_clk),
.i_nrz_p4 (i_nrz_p4),
.o_pam4_moore (o_pam4_moore),
.o_pam4_moore_2 (o_pam4_moore_2),
.i_pam4 (i_pam4),
.o_nrz_moore_p4 (o_nrz_moore_p4),

.debug (debug),

.o_clk_div (o_clk_div),
.i_manchester (i_manchester),
.o_nrz_moore (o_nrz_moore),
.o_nrz_mealy (o_nrz_mealy),
.o_manchester_moore (o_manchester_moore),
.i_nrz (i_nrz),

.i_reset_n (i_reset_n),
.o_manchester_mealy (o_manchester_mealy)
	);

initial begin
	i_nrz = 1;
	i_clk = 1;
	i_nrz_p4 = 0;
	i_pam4 = 0;
	i_manchester = 0;
	i_reset_n = 1;

	//toggle reset
	#2 i_reset_n = 0;
	#2 i_reset_n = 1;

	//nrz-pam4 
	#2 i_nrz_p4 = 0; //zero
	#2 i_nrz_p4 = 0; 

	#2 i_nrz_p4 = 0; //one
	#2 i_nrz_p4 = 1; 

	#2 i_nrz_p4 = 1; //two
	#2 i_nrz_p4 = 0;

	#2 i_nrz_p4 = 1; //three
	#2 i_nrz_p4 = 1;

	#2 i_nrz_p4 = 0; //zero
	#2 i_nrz_p4 = 0;

	//pam4-nrz
	#2 i_pam4 = 0; //zero
	#2 i_pam4 = 0;

	#2 i_pam4 = 1; //one
	#2 i_pam4 = 1;

	#2 i_pam4 = 2; //two
	#2 i_pam4 = 2;

	#2 i_pam4 = 3; //three
	#2 i_pam4 = 3;

	#2 i_pam4 = 0; //zero
	#2 i_pam4 = 0;

	//manchester - NRZ
	#2 i_manchester = 0;
	#2 i_manchester = 1; //NRZ should be lo
	#2 i_manchester = 1;
	#2 i_manchester = 0; //NRZ should be hi
	#2 i_manchester = 0;
	#2 i_manchester = 1; //NRZ should be lo

	//NRZ-manchester
	#2 i_nrz = 0; //manchester should do a lo-hi transition
	#2 i_nrz = 0;
	#2 i_nrz = 1;//manchester should do a hi-lo transition
	#2 i_nrz = 1;
	#2 i_nrz = 0;//manchester should do a lo-hi transition
	#2 i_nrz = 0;
end

always begin 
#1 i_clk = !i_clk;
end

//initial begin
//$monitor($time,,"nrz input = %b : pam4_moore = %d : pam4_moore_no_delay = %d : pam4 input = %d : nrz out = %b",i_nrz_p4, o_pam4_moore, o_pam4_moore_2, i_pam4, o_nrz_moore_p4);
//end 



endmodule
