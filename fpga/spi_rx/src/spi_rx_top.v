`timescale 1ns/1ps
// STM32_3 과제10 (MCU → FPGA) · 과제12 수신 측 최상위. 학생 작성.
// SPI로 받은 바이트를 LED에 표시하고 FPGA UART(F6, 9600 8N1)로 "RX=HH\r\n"을 PC에 보낸다.
module spi_rx_top #(parameter integer CLK_HZ = 50_000_000, parameter integer BAUD = 9_600)(
    input  wire clk_50mhz, rst_p,
    input  wire spi_sck, spi_mosi, spi_cs_n,
    output wire uart_txd,
    output reg  [7:0] led_out
);
    localparam integer DIV = (CLK_HZ + BAUD/2) / BAUD;
    wire [7:0] rx_data; wire rx_valid;
    wire tx_ready, tx_valid; wire [7:0] tx_data;
    spi_slave_rx u_rx(.clk(clk_50mhz), .rst_p(rst_p), .sck(spi_sck), .mosi(spi_mosi), .cs_n(spi_cs_n),
                      .data(rx_data), .valid(rx_valid));
    hex_line_tx #(.PREFIX("RX=")) u_fmt(.clk(clk_50mhz), .rst_p(rst_p), .start(rx_valid), .value(rx_data),
                      .tx_ready(tx_ready), .tx_valid(tx_valid), .tx_data(tx_data));
    uart_tx #(.DIV(DIV)) u_tx(.clk(clk_50mhz), .rst_p(rst_p), .valid(tx_valid), .data(tx_data),
                      .ready(tx_ready), .tx(uart_txd));
    always @(posedge clk_50mhz) if (rst_p) led_out <= 0; else if (rx_valid) led_out <= rx_data;
endmodule
