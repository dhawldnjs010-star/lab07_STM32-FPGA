`timescale 1ns/1ps
// STM32_3 과제11 (FPGA → MCU) · 과제12 송신 측 최상위. 학생 작성.
// PERIOD_CYCLES(기본 1초)마다 0x55, 0xA5, 0x00, 0xFF를 차례로 SPI로 보낸다.
// DIP_SW1(fixed)을 올리면 순환 대신 0x55만 반복한다. 보낸 값은 LED와 UART("TX=HH\r\n")로 표시한다.
module spi_tx_top #(
    parameter integer CLK_HZ = 50_000_000,
    parameter integer BAUD = 9_600,
    parameter integer PERIOD_CYCLES = 50_000_000,   // 1초
    parameter integer HALF = 50                      // SCK 500 kHz
)(
    input  wire clk_50mhz, rst_p,
    input  wire fixed,                               // 1이면 0x55만 보냄
    output wire spi_sck, spi_mosi, spi_cs_n,
    output wire uart_txd,
    output reg  [7:0] led_out
);
    localparam integer DIV = (CLK_HZ + BAUD/2) / BAUD;
    reg [31:0] timer;
    reg [1:0] k;
    reg start;
    reg [7:0] value;
    wire busy, done;
    wire tx_ready, tx_valid; wire [7:0] tx_data;
    function [7:0] pattern(input [1:0] i);
        case (i) 2'd0: pattern = 8'h55; 2'd1: pattern = 8'hA5; 2'd2: pattern = 8'h00; default: pattern = 8'hFF; endcase
    endfunction
    always @(posedge clk_50mhz) begin
        if (rst_p) begin timer <= 0; k <= 0; start <= 0; value <= 0; led_out <= 0; end
        else begin
            start <= 0;
            if (timer == PERIOD_CYCLES-1) begin
                timer <= 0;
                if (!busy) begin
                    value <= fixed ? 8'h55 : pattern(k);
                    led_out <= fixed ? 8'h55 : pattern(k);
                    start <= 1;
                    if (!fixed) k <= k + 1'b1;
                end
            end else timer <= timer + 1;
        end
    end
    spi_master_tx #(.HALF(HALF)) u_spi(.clk(clk_50mhz), .rst_p(rst_p), .start(start), .data(value),
                      .sck(spi_sck), .mosi(spi_mosi), .cs_n(spi_cs_n), .busy(busy), .done(done));
    hex_line_tx #(.PREFIX("TX=")) u_fmt(.clk(clk_50mhz), .rst_p(rst_p), .start(done), .value(value),
                      .tx_ready(tx_ready), .tx_valid(tx_valid), .tx_data(tx_data));
    uart_tx #(.DIV(DIV)) u_tx(.clk(clk_50mhz), .rst_p(rst_p), .valid(tx_valid), .data(tx_data),
                      .ready(tx_ready), .tx(uart_txd));
endmodule
