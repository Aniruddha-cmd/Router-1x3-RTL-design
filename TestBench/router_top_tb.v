module router_top_tb();

reg [7:0]data_in;
reg pkt_valid,clk,resetn,read_enb_0,read_enb_1,read_enb_2;
wire [7:0]data_out_0,data_out_1,data_out_2;
wire vld_out_0,vld_out_1,vld_out_2,err,busy;
integer i;
event a;
event b;
router_top dut(clk,resetn,data_in,pkt_valid,read_enb_0,read_enb_1,read_enb_2,
                    data_out_0,data_out_1,data_out_2,vld_out_0,vld_out_1,vld_out_2,err,busy);

always
begin
forever
#5 clk= ~clk;
end

task initialize;
begin
resetn=1'b1;
{clk,pkt_valid,read_enb_0,read_enb_1,read_enb_2}=0;
end
endtask

task reset;
begin
@(negedge clk);
resetn=1'b0;
@(negedge clk);
resetn=1'b1;
end
endtask

task pkt_gen1;
reg [7:0] header,payload_data,parity;
reg [5:0] payload_l;
reg [1:0] des_addf;
          begin
           @(negedge clk);
           wait(!busy)
           begin
           @(negedge clk);
           pkt_valid=1'b1;
          payload_l=6'd14;
           des_addf=2'b01;
           header={payload_l,des_addf};
           data_in=header;
           parity=0^header;
           end
          @(negedge clk);
            wait(!busy)
      
    for(i=0;i<payload_l;i=i+1)

           begin
          @(negedge clk);
            wait(!busy)
           payload_data={$random}%256;
           data_in=payload_data;
           parity=parity^data_in;
           end
          @(negedge clk);
            wait(!busy)
           pkt_valid=0;
           data_in=parity;
		   ->b;
          end
endtask

task pkt_gen2;
reg [7:0] header,payload_data,parity;
reg [5:0] payload_l;
reg [1:0] des_addf;
          begin
          @(negedge clk);
           wait(!busy)
           begin
           @(negedge clk);
           pkt_valid=1'b1;
          payload_l=6'd17;
           des_addf=2'b10;
           header={payload_l,des_addf};
           data_in=header;
           parity=0^header;
           end
          @(negedge clk);
              wait(!busy)
      for(i=0;i<payload_l;i=i+1)

           begin
           
           @(negedge clk);
             wait(!busy)
           payload_data={$random}%256;
           data_in=payload_data;
		   -> a;
           parity=parity^data_in;
           end
      @(negedge clk);
            wait(!busy)
           pkt_valid=0;
           data_in=parity;
   end
endtask

initial
begin
@(a);
wait(vld_out_2)
	begin
	read_enb_2=1;
	end
end
initial
begin
@(b);
wait(vld_out_1)
begin
read_enb_1=1;
end
end

initial
begin
initialize;
reset;
pkt_gen1;
pkt_gen2;
#1000;
$finish;
end
endmodule

            



