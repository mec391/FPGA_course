//assignment 6

//4bit binary synchronous counter with negative edge trigger sync, sync load and reset, parallel load of data, active low enable
//scalable 8 bit ring counter that moves from msb to lsb, resets to msb = 1 and others = 0

//minor timing issues with part 3, fix if have time
module assignment_6#(
parameter word_size = 8)
(
input i_clk,
input i_cnt_enable_n,
input i_reset_n,
input i_ld_enable_n,
input [3:0] i_load,

output reg [3:0] o_counter1,
output reg [word_size-1:0] o_counter2,
output reg [word_size-1:0] o_counter3
	);
integer ii=0;

//part 1 - 4 bit sync counter
always@(negedge i_clk) //run the counter
begin
if(~i_reset_n) o_counter1 <= 4'd0;
else
if(~i_ld_enable_n) o_counter1 <= i_load; //load enable take priority over count enable, to both count and load, do something like
else										//if(~i_ld_enable_n && ~i_cnt_enable_n) o_counter1 <= i_load + 1;
if(~i_cnt_enable_n) o_counter1 <= o_counter1 + 1;
else o_counter1 <= o_counter1;
end

//part 2 scalable ring counter
always@(posedge i_clk) //run the counter
begin
if(~i_reset_n)
begin
o_counter2[word_size-1] = 1;
o_counter2[word_size-2:0] = 0;
end
else
if(~i_cnt_enable_n)
begin
for (ii=0; ii < word_size-1; ii=ii+1) o_counter2[ii] <= o_counter2[ii+1]; //shift over values excluding MSB assignment
o_counter2[word_size-1] <= o_counter2[0]; //assign MSB - move LSB to MSB
end
else o_counter2 <= o_counter2;
end

//part 3 alternating updown ring counter

//2 bit counter where at 0 it outputs ring_down, at 1 it outputs ring_up and then updates the the two counters

reg [word_size-1:0] r_up_ring;
reg [word_size-1:0] r_down_ring;
reg r_ring_toggle;


always@(posedge i_clk) //run the counter
begin


if(~i_reset_n)
begin
r_ring_toggle <= 0;
r_down_ring[word_size-1] <= 1;
r_down_ring[word_size-2:0] <= 0;
r_up_ring[0] <= 1;
r_up_ring[word_size-1:1] <= 0;
o_counter3[word_size-1] <= 1;
o_counter3[word_size-2:0] <= 0;
end
else
	if(~i_cnt_enable_n)
	begin
	r_ring_toggle <= ~r_ring_toggle;
	end
	else begin 
	r_ring_toggle <= r_ring_toggle;
	end

case(r_ring_toggle)
0:begin
o_counter3 <= r_down_ring;
end
1:begin
o_counter3 <= r_up_ring;

for (ii=0; ii < word_size-1; ii=ii+1) r_down_ring[ii] <= r_down_ring[ii+1]; //shift over values excluding MSB assignment
r_down_ring[word_size-1] <= r_down_ring[0]; //assign MSB - move LSB to MSB

for (ii=0; ii < word_size-1; ii=ii+1) r_up_ring[ii+1] <= r_up_ring[ii]; 
r_up_ring[0] <= r_up_ring[word_size-1]; 
end
endcase

end


endmodule

