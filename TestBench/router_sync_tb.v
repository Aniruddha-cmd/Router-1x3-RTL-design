module router_sync_tb();

reg clk,resetn,detect_add,full_0,full_1,full_2,empty_0,empty_1,empty_2,write_enb_reg,read_enb_0,read_enb_1,read_enb_2;
reg [1:0] data_in;
wire [2:0] write_enb;
wire vld_out_0,vld_out_1,vld_out_2;
wire fifo_full,soft_reset_0,soft_reset_1,soft_reset_2;
parameter t=10;

router_sync dut(clk,resetn,data_in,detect_add,full_0,full_1,full_2,
                empty_0,empty_1,empty_2,write_enb_reg,read_enb_0,read_enb_1,read_enb_2,
                     write_enb,fifo_full,vld_out_0,vld_out_1,vld_out_2,
                     soft_reset_0,soft_reset_1,soft_reset_2);


always
begin
#t clk= ~clk;
end

task reset;
begin
    @(negedge clk)
     resetn=1'b0;
    @(negedge clk);
     resetn=1'b1;
end
endtask

task initialize;
begin
resetn=1'b1;
{clk,detect_add,full_0,full_1,full_2,empty_0,empty_1,empty_2,write_enb_reg}=0;
end
endtask

task stimulus;
begin
@(negedge clk);
 detect_add=1'b1;
 data_in=2'b00;
 write_enb_reg=1'b1;
 empty_0=1'b0;
 empty_1=1'b0;
 empty_2=1'b0;
 full_0=1'b1;
 full_1=1'b1;
 full_2=1'b1;
 read_enb_0=1'b0;
 read_enb_1=1'b1;
 read_enb_2=1'b1;
end
endtask

initial
begin
initialize;
reset;
stimulus;
#1000;
$finish;
end

endmodule
  
