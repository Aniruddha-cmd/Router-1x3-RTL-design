module router_reg_tb();

reg clk,resetn,pkt_valid,fifo_full,detect_add,ld_state,laf_state,full_state,lfd_state,rst_int_reg;
reg [7:0] data_in;
wire [7:0]dout;
wire err,parity_done,low_pkt_valid;
integer i,j;
parameter t=10;

router_reg DUT(clk,resetn,
              pkt_valid,data_in,fifo_full,
             detect_add,ld_state,laf_state,
               full_state,
                lfd_state,rst_int_reg,
                err,parity_done,
                low_pkt_valid,dout);
				
always
begin
#t clk= ~clk;
end

task initialize;
begin
resetn=1'b1;
{clk,pkt_valid,fifo_full,detect_add,ld_state,laf_state,full_state,lfd_state,rst_int_reg}=0;
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

task pkt_generate;
reg [7:0] header,payload_data,parity;
reg [5:0] payload_l;
reg [1:0] des_add;
          begin
             @(negedge clk);
             payload_l=18;
             des_add=2'b01;
             detect_add=1'b1;
             pkt_valid=1'b1;
             header={payload_l,des_add};
             data_in=header;
             parity=0;
             parity= parity^header;
              
            @(negedge clk);
             lfd_state=1;
             detect_add=0;
      
          for(i=0;i<payload_l;i=i+1)
              begin
              @(negedge clk);
              lfd_state=0;
              ld_state=1;
          payload_data={$random}%256;
             data_in=payload_data;
            parity= parity^data_in;
            end
        
         @(negedge clk);
            pkt_valid=0;
            data_in=parity;
          @(negedge clk);
            ld_state=0;
     end
     
endtask
task pkt_gen2;
reg [7:0] header,payload_data,parity;
reg [5:0] payload_l;
reg [1:0] des_add;
          begin
             @(negedge clk);
             payload_l=6;
             des_add=2'b01;
             detect_add=1'b1;
             pkt_valid=1'b1;
             header={payload_l,des_add};
             data_in=header;
             //parity=0;
             //parity= parity^header;
              
            @(negedge clk);
             lfd_state=1;
             detect_add=0;
      
          for(j=0;j<payload_l;j=j+1)
              begin
              @(negedge clk);
              lfd_state=0;
              ld_state=1;
          payload_data={$random}%256;
             data_in=payload_data;
           // parity= parity^data_in;
            end
        
         @(negedge clk);
            pkt_valid=0;
            parity={$random}%256;
            data_in=parity;
          @(negedge clk);
            ld_state=0;
     end
     
endtask


initial
begin
initialize;
reset;
#20;
 pkt_generate;
#100;
pkt_gen2;
$finish;
end
endmodule       
    