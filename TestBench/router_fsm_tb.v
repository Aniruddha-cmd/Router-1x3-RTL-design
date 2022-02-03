module router_fsm_tb();

reg clk,resetn,pkt_valid,fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,
                  soft_reset_0,soft_reset_1,soft_reset_2,parity_done,low_pkt_valid;
reg [1:0] data_in;
wire  write_enb_reg,detect_add,ld_state,laf_state,lfd_state,full_state,rst_int_reg,busy;

router_fsm dut(clk,resetn,pkt_valid,data_in,fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,
                  soft_reset_0,soft_reset_1,soft_reset_2,parity_done,low_pkt_valid,write_enb_reg,detect_add,ld_state,
                   laf_state,lfd_state,full_state,rst_int_reg,busy);
parameter t=10;

always
begin
#t clk= ~clk;
end

task initialize;
begin
resetn=1'b1;
{clk,pkt_valid,fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,
                  soft_reset_0,soft_reset_1,soft_reset_2,parity_done,low_pkt_valid}=0;
end
endtask

task reset;
begin
@(negedge clk);
   resetn= 1'b0;
@(negedge clk);
   resetn=1'b1;
end
endtask

task t1;
begin
@(negedge clk);
pkt_valid=1;
data_in=2'b01;
fifo_empty_1=1'b1;
@(negedge clk);
@(negedge clk);
fifo_full=0;
pkt_valid=0;
@(negedge clk);
@(negedge clk);
fifo_full=0;
end
endtask

task t2;
begin
@(negedge clk)
pkt_valid=1;
data_in=2'b00;
fifo_empty_0=1'b1;
@(negedge clk);
@(negedge clk);
fifo_full=1'b1;
@(negedge clk);
fifo_full=1'b0;
@(negedge clk);
parity_done=0;
low_pkt_valid=1;
@(negedge clk);
@(negedge clk);
fifo_full=0;
end
endtask

task t3;
begin
@(negedge clk);
pkt_valid=1;
data_in=2'b10;
fifo_empty_2=1'b1;
@(negedge clk);
@(negedge clk);
fifo_full=0;
pkt_valid=0;
@(negedge clk);
@(negedge clk);
fifo_full=1;
@(negedge clk);
fifo_full=0;
@(negedge clk);
parity_done=1;
end
endtask

task t4;
begin
@(negedge clk);
pkt_valid=1;
data_in=2'b01;
fifo_empty_1=1;
@(negedge clk)
fifo_full=1;
@(negedge clk);
//soft_reset_1=1;
fifo_full=0;
@(negedge clk);
parity_done=0;
low_pkt_valid=0;
@(negedge clk);
fifo_full=0;
pkt_valid=0;
@(negedge clk);
@(negedge clk);
fifo_full=0;
end
endtask

initial
begin
initialize;
reset;
#10 t1;
#20;
 t2;
#20;
 t3;
#20;
 t4;
$finish;
end 
endmodule

