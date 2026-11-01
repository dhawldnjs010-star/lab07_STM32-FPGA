# lab07 STM32_3 과제10·12 수신 - SPI 슬레이브 (spi_rx)

`spi_rx_top(clk_50mhz, rst_p, spi_sck, spi_mosi, spi_cs_n, uart_txd, led_out[7:0])`.
SCK·MOSI·CS_n을 2단 동기화하고 SCK 상승 에지에서 MOSI를 시프트 레지스터에 넣어, 8비트가 모이면 LED와 UART("RX=HH\r\n", 9600 8N1)로 내보낸다. CS_n이 HIGH가 되면 비트 카운터를 0으로 돌린다.

| 경로 | 내용 |
|---|---|
| src/spi_slave_rx.v | 동기화, 상승 에지 검출, 시프트 레지스터·비트 카운터 |
| src/hex_line_tx.v | 바이트 → "RX=HH\r\n" 7글자 |
| src/uart.v | 조교 LAB3 uart_tx 그대로 |
| src/spi_rx_top.v | 최상위 |
| sim/tb.sv | Mode 0 마스터 모델로 55 A5 00 FF, 끊긴 바이트 뒤 3C, UART 글자 확인 |
| sim/loopback_tb.sv | 과제12: spi_tx_top → spi_rx_top (클록 따로) |
| constraints/pins.xdc | SCK F8, MOSI E8, CS A7 (PORT A I/O 00~02), UART F6, LED |
| evidence/pre/ | PASS 로그, VCD, 오류 주입(하강 에지에서 읽으면 FATAL), loopback 로그 |

loopback 실행 (fpga/spi_rx에서): `iverilog -g2012 -s loopback_tb -o lb.vvp ../spi_tx/src/uart.v ../spi_tx/src/hex_line_tx.v ../spi_tx/src/spi_master_tx.v ../spi_tx/src/spi_tx_top.v src/spi_slave_rx.v src/spi_rx_top.v sim/loopback_tb.sv && vvp lb.vvp`
