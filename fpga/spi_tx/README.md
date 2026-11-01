# lab07 STM32_3 과제11·12 송신 - SPI 마스터 (spi_tx)

`spi_tx_top(clk_50mhz, rst_p, fixed, spi_sck, spi_mosi, spi_cs_n, uart_txd, led_out[7:0])`.
1초마다 0x55, 0xA5, 0x00, 0xFF를 차례로 보낸다(DIP_SW1 = 1이면 0x55만). CS_n을 내리고 MSB를 준비한 뒤 SCK를 50클록마다 반전(500 kHz)하고, 하강 에지에서 다음 비트로 바꾼다. 보낸 값은 LED와 UART("TX=HH\r\n")로 표시한다.

| 경로 | 내용 |
|---|---|
| src/spi_master_tx.v | Mode 0 마스터 상태 기계 (IDLE → SETUP → SHIFT → HOLD) |
| src/spi_tx_top.v | 1초 타이머, 송신값 순환, LED·UART |
| src/hex_line_tx.v, src/uart.v | UART 표시 (spi_rx와 같음) |
| sim/tb.sv | 슬레이브 모델로 순서, 상승 에지 8번, SCK HIGH 동안 MOSI 고정, SCK 대기 LOW, 반주기 확인 |
| constraints/pins.xdc | SCK F8, MOSI E8, CS A7 (PORT A I/O 00~02), DIP_SW1, UART F6, LED |
| evidence/pre/ | PASS 로그, VCD, 오류 주입(상승 에지에서 MOSI를 바꾸면 FATAL) |
