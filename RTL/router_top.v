module router_top(clk,resetn,data_in,pkt_valid,read_enb_0,read_enb_1,read_enb_2,
                    data_out_0,data_out_1,data_out_2,vld_out_0,vld_out_1,vld_out_2,err,busy);

input [7:0]data_in;
input pkt_valid,clk,resetn,read_enb_0,read_enb_1,read_enb_2;
output [7:0]data_out_0,data_out_1,data_out_2;
output vld_out_0,vld_out_1,vld_out_2,err,busy;

wire [2:0]write_en;
wire [7:0]doutw;

router_fifo FIFO_0(.clk(clk),
                   .resetn(resetn),
                   .w_en(write_en[0]),
                   .r_en(read_enb_0),
                  .soft_reset(soft_reset_0),
                  .data_in(doutw),
                   .data_out(data_out_0),
                   .lfd_state(lfd_state),
                     .full(full_0),
                    .empty(empty_0)); 

router_fifo FIFO_1(.clk(clk),
                   .resetn(resetn),
                   .w_en(write_en[1]),
                   .r_en(read_enb_1),
                  .soft_reset(soft_reset_1),
                  .data_in(doutw),
                   .data_out(data_out_1),
                   .lfd_state(lfd_state),
                     .full(full_1),
                    .empty(empty_1)); 

router_fifo FIFO_2(.clk(clk),
                   .resetn(resetn),
                   .w_en(write_en[2]),
                   .r_en(read_enb_2),
                  .soft_reset(soft_reset_2),
                  .data_in(doutw),
                   .data_out(data_out_2),
                   .lfd_state(lfd_state),
                     .full(full_2),
                    .empty(empty_2));

router_sync SYN(.clk(clk),
                     .resetn(resetn),
                     .data_in(data_in[1:0]),
                     .detect_add(detect_add),
                     .full_0(full_0),
                     .full_1(full_1),
                     .full_2(full_2),
                     .empty_0(empty_0),
                     .empty_1(empty_1),
                     .empty_2(empty_2),
                     .write_enb_reg(write_enb_reg),
                     .read_enb_0(read_enb_0),
                     .read_enb_1(read_enb_1),
                     .read_enb_2(read_enb_2),
                     .write_enb(write_en),
                     .fifo_full(fifo_full),
                     .vld_out_0(vld_out_0),
                     .vld_out_1(vld_out_1),
                     .vld_out_2(vld_out_2),
                     .soft_reset_0(soft_reset_0),
                     .soft_reset_1(soft_reset_1),
                     .soft_reset_2(soft_reset_2));

router_fsm FSM(.clk(clk),
                .resetn(resetn),
                .pkt_valid(pkt_valid),
                .data_in(data_in[1:0]),
                .fifo_full(fifo_full),
                .fifo_empty_0(empty_0),
                .fifo_empty_1(empty_1),
                .fifo_empty_2(empty_2),
                .soft_reset_0(soft_reset_0),
                .soft_reset_1(soft_reset_1),
                .soft_reset_2(soft_reset_2),
                .parity_done(parity_done),
                .low_pkt_valid(low_pkt_valid),
                .write_enb_reg(write_enb_reg),
                .detect_add(detect_add),
                .ld_state(ld_state),
                .laf_state(laf_state),
                .lfd_state(lfd_state),
                .full_state(full_state),
                .rst_int_reg(rst_int_reg),
                .busy(busy));

router_reg REG(.clk(clk),
               .resetn(resetn),
               .pkt_valid(pkt_valid),
               .data_in(data_in),
               .fifo_full(fifo_full),
               .detect_add(detect_add),
               .ld_state(ld_state),
               .laf_state(laf_state),
               .full_state(full_state),
               .lfd_state(lfd_state),
               .rst_int_reg(rst_int_reg),
               .err(err),
               .parity_done(parity_done),
               .low_pkt_valid(low_pkt_valid),
               .dout(doutw));
endmodule
