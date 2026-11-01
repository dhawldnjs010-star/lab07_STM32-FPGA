`timescale 1ns/1ps
// 과제12 (FPGA → FPGA) 모의 실행 (학생 작성): spi_tx_top(송신 FPGA)의 SCK·MOSI·CS를 spi_rx_top(수신 FPGA)에 그대로 연결한다.
// 두 보드는 각자의 50 MHz 클록을 쓰므로 수신 측 클록을 조금 다르게(20.6 ns) 두었다. SCK는 실제 설정인 500 kHz(HALF 50).
module loopback_tb;
    initial begin $dumpfile("loopback_wave.vcd"); $dumpvars(0, loopback_tb); end
    reg clk_a=0, clk_b=0, rst=1;
    always #10 clk_a = ~clk_a;
    always #10.3 clk_b = ~clk_b;
    wire sck, mosi, cs_n, txd_a, txd_b; wire [7:0] led_a, led_b;
    spi_tx_top #(.CLK_HZ(800), .BAUD(100), .PERIOD_CYCLES(6000), .HALF(50)) a(.clk_50mhz(clk_a), .rst_p(rst), .fixed(1'b0),
        .spi_sck(sck), .spi_mosi(mosi), .spi_cs_n(cs_n), .uart_txd(txd_a), .led_out(led_a));
    spi_rx_top #(.CLK_HZ(800), .BAUD(100)) b(.clk_50mhz(clk_b), .rst_p(rst), .spi_sck(sck), .spi_mosi(mosi), .spi_cs_n(cs_n),
        .uart_txd(txd_b), .led_out(led_b));
    integer n = 0; reg [7:0] rxs [0:7], txs [0:7];
    always @(posedge clk_b) if (b.rx_valid) begin rxs[n] = b.rx_data; txs[n] = a.value; n = n + 1; end
    integer k;
    initial begin
        repeat(3) @(posedge clk_a); rst = 0;
        wait (n == 6);
        for (k = 0; k < 6; k = k + 1) begin
            $display("byte %0d: TX=%02X RX=%02X", k, txs[k], rxs[k]);
            if (rxs[k] !== txs[k]) $fatal(1, "mismatch at %0d", k);
        end
        $display("PASS loopback: FPGA spi_tx -> FPGA spi_rx, 6 bytes (55 A5 00 FF 55 A5), separate clocks"); $finish;
    end
    initial begin #1000000; $fatal(1, "timeout"); end
endmodule
