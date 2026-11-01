`timescale 1ns/1ps
// spi_rx_top TB (학생 작성). Mode 0 마스터 모델로 0x55, 0xA5, 0x00, 0xFF를 보내고,
// 4비트만 보낸 뒤 CS를 올린 끊긴 바이트 다음에 0x3C가 처음부터 바르게 받아지는지 확인한다.
// UART는 1비트 = 8클록으로 줄이고(CLK_HZ 800, BAUD 100), PC로 나가는 글자를 디코드해 비교한다.
module tb;
    initial begin $dumpfile("wave.vcd"); $dumpvars(0, tb); end
    localparam integer HALF_NS = 200;     // SCK 반주기 200 ns (시스템 클록 10클록)
    reg clk=0, rst=1, sck=0, mosi=0, cs_n=1;
    always #10 clk = ~clk;                 // 50 MHz
    wire txd; wire [7:0] led;
    spi_rx_top #(.CLK_HZ(800), .BAUD(100)) dut(.clk_50mhz(clk), .rst_p(rst), .spi_sck(sck), .spi_mosi(mosi),
        .spi_cs_n(cs_n), .uart_txd(txd), .led_out(led));
    // Mode 0 마스터: 첫 상승 전에 MSB 준비, 하강에서 다음 비트
    task send(input [7:0] v, input integer nbits);
        integer b;
        begin
            cs_n = 0; mosi = v[7]; #(HALF_NS);
            for (b = 7; b > 7 - nbits; b = b - 1) begin
                sck = 1; #(HALF_NS);
                sck = 0; if (b > 0) mosi = v[b-1]; #(HALF_NS);
            end
            cs_n = 1; mosi = 0; #(20000);      // UART 한 줄(7글자) 보낼 시간
        end
    endtask
    // UART 수신 모델 (DIV = 8클록)
    reg [8*64-1:0] line; integer nchar = 0; reg [7:0] ch; integer i;
    initial forever begin
        @(negedge txd); repeat(12) @(posedge clk);
        for (i = 0; i < 8; i = i + 1) begin ch[i] = txd; repeat(8) @(posedge clk); end
        line = {line[8*63-1:0], ch}; nchar = nchar + 1;
    end
    integer got = 0; reg [7:0] seen [0:7];
    always @(posedge clk) if (dut.rx_valid) begin seen[got] = dut.rx_data; got = got + 1; end
    initial begin
        repeat(3) @(posedge clk); rst = 0; #1000;
        send(8'h55, 8); if (led !== 8'h55) $fatal(1, "LED 55 got %h", led);
        send(8'hA5, 8); if (led !== 8'hA5) $fatal(1, "LED A5 got %h", led);
        send(8'h00, 8); if (led !== 8'h00) $fatal(1, "LED 00 got %h", led);
        send(8'hFF, 8); if (led !== 8'hFF) $fatal(1, "LED FF got %h", led);
        send(8'hC3, 4);                                   // 4비트만 보내고 CS 해제 → 버려야 함
        if (got !== 4) $fatal(1, "partial byte accepted");
        send(8'h3C, 8); if (led !== 8'h3C) $fatal(1, "after partial got %h", led);
        if (got !== 5 || seen[0]!==8'h55 || seen[1]!==8'hA5 || seen[2]!==8'h00 || seen[3]!==8'hFF || seen[4]!==8'h3C)
            $fatal(1, "rx sequence");
        if (nchar !== 35) $fatal(1, "uart chars %0d", nchar);
        if (line[8*35-1:0] !== {"RX=55",8'h0D,8'h0A,"RX=A5",8'h0D,8'h0A,"RX=00",8'h0D,8'h0A,"RX=FF",8'h0D,8'h0A,"RX=3C",8'h0D,8'h0A})
            $fatal(1, "uart text");
        $display("PASS spi_rx: 55 A5 00 FF, partial byte dropped, 3C, UART RX=HH lines"); $finish;
    end
    initial begin #400000; $fatal(1, "timeout"); end
endmodule
