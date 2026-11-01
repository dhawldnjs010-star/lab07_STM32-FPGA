# FPGA (STM32_3 주차, 11/2) · SPI 과제10~12

조교 매뉴얼 `Glaysia/ece2_474` v1.1.0 `docs/STM32_3.md`(= `Glaysia/ece2_26_2_2` `c/stm32/docs/STM32_3.md`)의 FPGA SPI 과제를
fpga-lab-template(Glaysia/fpga-lab-template, 커밋 0b3318e466e9d77f7d3880df09c827788f361913) 구조로 직접 작성했다. 이번 주차는 교재 추가 실습이 없다.

| 폴더 | 설계 최상위 | 시뮬레이션 top | 과제 | 내용 |
|---|---|---|---|---|
| spi_rx | `spi_rx_top` | `tb` (+ `loopback_tb`) | 과제10, 과제12 수신 | SPI 슬레이브(Mode 0) 수신 → LED, UART "RX=HH" |
| spi_tx | `spi_tx_top` | `tb` | 과제11, 과제12 송신 | 1초마다 55 A5 00 FF를 SPI 마스터(SCK 500 kHz)로 송신 → LED, UART "TX=HH" |

`src/uart.v`는 조교 LAB3 UART 에코 예제의 uart_tx를 쓰기 위해 그대로 복사했다. 나머지 `src/`, `sim/`은 학생 작성이다.
실행: 각 폴더에서 `python tools/fpga_lab.py simulate`. 과제12 모의 실행은 `spi_rx/sim/loopback_tb.sv`(아래 명령, `evidence/pre/loopback_*`).
Vivado: Tcl Console에서 `set ex spi_rx` 후 `source .../fpga/vivado_setup.tcl`, 이어서 `make_bit`.

핀: 브레드보드 영역 PORT A I/O 00 = SCK(F8), I/O 01 = MOSI(E8), I/O 02 = CS(A7), UART TX F6, SW_1 리셋, LED 8개 (Xilinx S7 Pin Map BreadBoard I/O 표).
보드에서 확인할 가정: PORT A I/O가 출력으로도 쓰이는지(과제11), PORT A ENABLE 스위치를 켜야 연결되는지.
