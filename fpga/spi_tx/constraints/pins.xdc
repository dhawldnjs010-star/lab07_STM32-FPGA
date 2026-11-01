# STM32_3 과제11·12 송신 측 (최상위: spi_tx_top). SPI Mode 0, SCK 500 kHz, 1초마다 한 바이트
# 핀 출처: Xilinx S7 Pin Map의 BreadBoard I/O 표 (BDIO00 F8, BDIO01 E8, BDIO02 A7), DIP_SW1 Y1, 조교 LAB3 xdc (B6, K4, F6)
# 보드의 PORT A ENABLE 스위치를 켠다.
# 연결 (과제11, MCU 슬레이브): I/O 00 -> MCU PB3(SCK, Arduino D3), I/O 01 -> PA7(MOSI, D11), I/O 02 -> PA4(NSS, A2), GND 공통
# 연결 (과제12): I/O 00·01·02 -> 수신 FPGA의 I/O 00·01·02, GND 공통
set_property PACKAGE_PIN B6 [get_ports clk_50mhz]
set_property PACKAGE_PIN K4 [get_ports rst_p]      ;# SW_1
set_property PACKAGE_PIN Y1 [get_ports fixed]      ;# DIP_SW1: 1이면 0x55만 반복
set_property PACKAGE_PIN F8 [get_ports spi_sck]    ;# PORT A I/O 00
set_property PACKAGE_PIN E8 [get_ports spi_mosi]   ;# PORT A I/O 01
set_property PACKAGE_PIN A7 [get_ports spi_cs_n]   ;# PORT A I/O 02
set_property PACKAGE_PIN F6 [get_ports uart_txd]   ;# USB-UART -> PC
set_property PACKAGE_PIN L4  [get_ports {led_out[7]}]   ;# LED_D1
set_property PACKAGE_PIN M4  [get_ports {led_out[6]}]   ;# LED_D2
set_property PACKAGE_PIN M2  [get_ports {led_out[5]}]   ;# LED_D3
set_property PACKAGE_PIN N7  [get_ports {led_out[4]}]   ;# LED_D4
set_property PACKAGE_PIN M7  [get_ports {led_out[3]}]   ;# LED_D5
set_property PACKAGE_PIN M3  [get_ports {led_out[2]}]   ;# LED_D6
set_property PACKAGE_PIN M1  [get_ports {led_out[1]}]   ;# LED_D7
set_property PACKAGE_PIN N5  [get_ports {led_out[0]}]   ;# LED_D8
set_property IOSTANDARD LVCMOS33 [get_ports *]
create_clock -name clk_50mhz -period 20.000 [get_ports clk_50mhz]
set_false_path -from [get_ports {rst_p fixed}]
