# lab07 FPGA 실습용 Vivado 프로젝트 생성 스크립트
# 사용 (Vivado Tcl Console):
#   set ex spi_rx       ;# spi_rx | spi_tx
#   source C:/Users/djawl/lab07_STM32-FPGA/fpga/vivado_setup.tcl
# 하는 일: 프로젝트 생성 -> RTL·XDC·TB 등록 -> top 지정 -> XSim 실행(PASS 확인)
# 비트스트림까지 만들려면 이어서:  make_bit
set root C:/Users/djawl/lab07_STM32-FPGA/fpga
if {![info exists ex] || [lsearch {spi_rx spi_tx} $ex] < 0} { error "먼저 set ex spi_rx|spi_tx" }
array set impl_top {spi_rx spi_rx_top spi_tx spi_tx_top}
array set sim_top {spi_rx tb spi_tx tb}
set dir $root/$ex
create_project $ex $dir/vivado -part xc7s75fgga484-1 -force
add_files -norecurse [glob $dir/src/*.v]
# spi_rx의 loopback_tb.sv는 spi_tx 소스가 필요해 Vivado에는 넣지 않는다 (Icarus로 따로 실행)
add_files -fileset constrs_1 -norecurse $dir/constraints/pins.xdc
set_property SOURCE_SET sources_1 [get_filesets sim_1]
add_files -fileset sim_1 -norecurse $dir/sim/tb.sv
set_property top $impl_top($ex) [get_filesets sources_1]
set_property top $sim_top($ex) [get_filesets sim_1]
set_property top_lib xil_defaultlib [get_filesets sim_1]
set_property -name {xsim.simulate.runtime} -value {300us} -objects [get_filesets sim_1]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
launch_simulation
puts "== $ex: Tcl Console에서 PASS 문장을 확인하세요. 구현 top = $impl_top($ex), 시뮬레이션 top = $sim_top($ex)"

proc make_bit {} {
    reset_run synth_1
    launch_runs impl_1 -to_step write_bitstream -jobs 4
    wait_on_run impl_1
    puts "== impl_1: [get_property STATUS [get_runs impl_1]]"
}
