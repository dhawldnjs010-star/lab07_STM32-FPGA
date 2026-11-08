# spi_tx 실험 후 요약 (과제11 · 과제12 송신 측)

- XSim (`sim/tb.sv`): SCK 500 kHz, CS 하나에 상승 에지 8번, 55 A5 00 FF 55와 UART `TX=HH`. `evidence/post/xsim_wave.png`
- 구현: WNS 15.177 ns, WHS 0.143 ns, Failed Routes 0, 전력 0.104 W (Vivado 추정). `evidence/post/vivado_runs.png`
- 오실로스코프 (CH1 SCK, CH2 MOSI, 2 µs/div): SCK 499.9~500.0 kHz, 한 바이트에 펄스 8개. MOSI를 상승 에지에서 읽으면 0101 0101(0x55), 1010 0101(0xA5), 1111 1111(0xFF)
- `task11_scope_FF_ch2inv.jpg`는 CH2 측정값이 최대 0.1 V·최소 −3.66 V로 나온 사진으로, 같은 0xFF 구간이 위아래 뒤집혀 보인다
- 과제11 보드: DIP_SW1 = 1에서 FPGA `TX=55`, MCU(ROLE 1) `RX=55`가 1초마다 함께 나왔다
