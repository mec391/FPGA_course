`timescale 1ns/1ns
module assignment_6_tb();
parameter word_count = 8;
reg i_clk;
reg i_cnt_enable_n;
reg i_reset_n;
reg i_ld_enable_n;
reg [3:0] i_load;
wire [3:0] o_counter1;
wire [word_count-1:0] o_counter2;
wire [word_count-1:0] o_counter3;

assignment_6 UUT(
.i_clk (i_clk),
.i_cnt_enable_n (i_cnt_enable_n),
.i_reset_n (i_reset_n),
.i_ld_enable_n (i_ld_enable_n),
.i_load (i_load),
.o_counter1 (o_counter1),
.o_counter2 (o_counter2),
.o_counter3 (o_counter3)
	);

reg [3:0] r_count_timer = 4'b1111;

//part 1
initial begin
i_clk = 1;
i_cnt_enable_n = 1;
i_reset_n = 1;
i_ld_enable_n = 1;
i_load = 0;

#2 i_reset_n = 0; //toggle reset
#4 i_reset_n = 1;

#2 
while (r_count_timer > 0) //perform full count cycle
	begin
	i_cnt_enable_n = 0;
	r_count_timer = r_count_timer - 1;
	#2 ;
	end

i_cnt_enable_n = 1; //trigger load and load enable
i_ld_enable_n = 0;
i_load = 4'b0011;

#2 i_load = 4'b1100;

#2 i_load = 4'b0000;
i_ld_enable_n = 1;

//part 2
#2 i_reset_n = 0; //toggle reset
#4 i_reset_n = 1;

#2 r_count_timer = 4'b1111;
while (r_count_timer > 0) //perform full count cycle
	begin
	i_cnt_enable_n = 0;
	r_count_timer = r_count_timer - 1;
	#2 ;
	end
i_cnt_enable_n = 1;

//part 3
#2 i_reset_n = 0; //toggle reset
#4 i_reset_n = 1;

#2 i_cnt_enable_n = 0;
end


always begin 
#1 i_clk = !i_clk;
end

endmodule