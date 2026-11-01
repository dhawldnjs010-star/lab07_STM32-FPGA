`timescale 1ns/1ps
// spi_tx_top TB (학생 작성). 1초 간격을 2000클록, SCK 반주기를 5클록으로 줄여 모의 실행한다.
// Mode 0 슬레이브 모델로 상승 에지에서 MOSI를 읽어 55 A5 00 FF 55 순서를 확인하고, 파형 규칙을 검사한다:
// CS 해제 중 SCK LOW, CS LOW 한 번에 상승 에지 8번, SCK HIGH인 동안 MOSI 변화 없음, SCK 반주기 = 5클록.
module tb;
    initial begin $dumpfile("wave.vcd"); $dumpvars(0, tb); end
    reg clk=0, rst=1, fixed=0;
    always #10 clk = ~clk;
    wire sck, mosi, cs_n, txd; wire [7:0] led;
    spi_tx_top #(.CLK_HZ(800), .BAUD(100), .PERIOD_CYCLES(2000), .HALF(5)) dut(.clk_50mhz(clk), .rst_p(rst),
        .fixed(fixed), .spi_sck(sck), .spi_mosi(mosi), .spi_cs_n(cs_n), .uart_txd(txd), .led_out(led));
    reg [7:0] sh; integer nedge = 0, nbyte = 0; reg [7:0] got [0:7];
    always @(posedge sck) if (!cs_n) begin sh = {sh[6:0], mosi}; nedge = nedge + 1; end
    always @(posedge cs_n) if (!rst) begin
        if (nedge !== 8) $fatal(1, "rising edges per byte = %0d", nedge);
        got[nbyte] = sh; nbyte = nbyte + 1; nedge = 0;
    end
    always @(mosi) if (!rst && !cs_n && sck) $fatal(1, "MOSI changed while SCK high");
    always @(sck) if (!rst && cs_n && sck) $fatal(1, "SCK high while CS high");
    time t_r; integer half_ok = 1;
    always @(posedge sck) t_r = $time;
    always @(negedge sck) if (($time - t_r) != 100) half_ok = 0;   // 5클록 × 20 ns
    // UART 디코드 (DIV 8)
    reg [8*64-1:0] line; integer nchar = 0; reg [7:0] ch; integer i;
    initial forever begin
        @(negedge txd); repeat(12) @(posedge clk);
        for (i = 0; i < 8; i = i + 1) begin ch[i] = txd; repeat(8) @(posedge clk); end
        line = {line[8*63-1:0], ch}; nchar = nchar + 1;
    end
    initial begin
        repeat(3) @(posedge clk); rst = 0;
        wait (nbyte == 5);
        repeat(1000) @(posedge clk);
        if (got[0]!==8'h55 || got[1]!==8'hA5 || got[2]!==8'h00 || got[3]!==8'hFF || got[4]!==8'h55)
            $fatal(1, "tx sequence %h %h %h %h %h", got[0], got[1], got[2], got[3], got[4]);
        if (!half_ok) $fatal(1, "SCK half period");
        if (nchar < 28 || line[8*35-1:0] !== {"TX=55",8'h0D,8'h0A,"TX=A5",8'h0D,8'h0A,"TX=00",8'h0D,8'h0A,"TX=FF",8'h0D,8'h0A,"TX=55",8'h0D,8'h0A})
            $fatal(1, "uart text");
        $display("PASS spi_tx: 55 A5 00 FF 55, 8 rising edges per CS, MOSI stable while SCK high, SCK idle low, UART TX=HH lines");
        $finish;
    end
    initial begin #400000; $fatal(1, "timeout"); end
endmodule
