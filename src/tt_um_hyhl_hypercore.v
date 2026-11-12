module tt_um_hyhl_hypercore (
    input  wire [7:0] ui_in,
    output wire [7:0] uo_out,
    input  wire [7:0] uio_in,
    output wire [7:0] uio_out,
    output wire [7:0] uio_oe,
    input  wire       clk,
    input  wire       rst_n
);
    wire [31:0] pc_out_w;
    wire [31:0] alu_out_w;

    cpu_top u_cpu (
        .clk(clk),
        .rst(ui_in[0]),        // ui[0] 做复位，高有效
        .pc_out(pc_out_w),
        .alu_result_out(alu_out_w)
    );

    assign uo_out[3:0] = pc_out_w[3:0];
    assign uo_out[7:4] = 4'b0;
    assign uio_out = 8'b0;
    assign uio_oe  = 8'b0;
endmodule
