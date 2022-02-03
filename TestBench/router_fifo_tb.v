module router_fifo_tb();

reg clk,resetn,soft_reset,w_en,r_en,lfd_state;
wire full,empty;
reg [7:0] data_in;
wire [7:0] data_out;
parameter t=10;

router_fifo dut(clk,resetn,soft_reset,w_en,r_en,lfd_state,data_in,full,empty,data_out);

reg [7:0]header,payload_data,parity;
reg [5:0]payload_l;
reg [1:0] d_addr;
integer i;

task initialize;
begin
{clk,soft_reset,w_en,r_en,lfd_state}=0;
resetn=1'b1;
end
endtask

always
begin
#t clk= ~clk;
end

task reset;
begin
  @(negedge clk);
   resetn=1'b0;
  @(negedge clk);
    resetn=1'b1;
  end
endtask

task s_reset;
begin
   @(negedge clk);
      soft_reset=1'b1;
   @(negedge clk);
     soft_reset=1'b0;
end
endtask

task pkt_gen;
begin
     @(negedge clk)
        payload_l=6'd8;
       d_addr=2'b01;
      header={payload_l,d_addr};
     data_in=header;
     lfd_state=1'b1;
     w_en=1'b1;

for(i=0;i<payload_l;i=i+1)
   begin
    @(negedge clk);
    lfd_state=0;
    payload_data={$random}%256;
     data_in=payload_data;
    end

@(negedge clk);
 parity={$random}%256;
   data_in=parity;
   
   @(negedge clk);
   w_en=1'b0;
end

endtask

task read;
begin
r_en=1'b1;
end
endtask

initial
begin
initialize;
reset;
s_reset;
pkt_gen;
#10 read;
end
endmodule














		
