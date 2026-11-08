# spi_rx 실험 후 요약 (과제10 · 과제12 수신 측)

- XSim (`sim/tb.sv`, 300 µs): LED 55 → a5 → 00 → ff → 3c, UART `RX=HH` 줄 5개. `evidence/post/xsim_wave.png`
- 구현: WNS 13.885 ns, WHS 0.121 ns, Failed Routes 0, 전력 0.104 W (Vivado 추정). `evidence/post/vivado_runs.png`
- 과제10 보드: MCU `TX=FF, 55, A5, 00, FF, 55` 순서와 FPGA `RX=FF, 55, A5, 00, FF, 55`가 같다. LED도 1초마다 55 → A5 → 00 → FF (`../../evidence/post/stm32/task10_*`)
- 과제12 보드: 옆 조 FPGA(spi_tx)와 PORT A I/O 00~02끼리 연결. 영상에서 LED가 00(5.0 s) → FF(6.0 s)로 바뀜. UART 화면은 찍지 못했다. `evidence/post/task12_*`
