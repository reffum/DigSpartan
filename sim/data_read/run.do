
set IP "../../pcores/MyProcessorIPLib/pcores/data_read_v1_00_a/hdl/verilog"
set XILINX "c:/XilinxISE/14.7/ISE_DS/ISE"

proc compilecode {} {
    global IP
    global XILINX

    vlog ${IP}/data_read_common.hv
    vlog ${IP}/data_read_buffer.v
    vlog ${IP}/data_read_axi_write.v
    vlog ${IP}/data_read_axi_read.v
    vlog ${IP}/data_read.v    
    
    vlog -novopt tb.sv
}

proc simulate {} {
    vsim -novopt -onfinish final tb
    
    assertion fail -recursive -action break tb
    log -r /*

    add wave -group AXI /UUT/S_AXI_*
    add wave /UUT/LVDS_CLK /UUT/LVDS_IN /UUT/P12_SEL1 /UUT/P12_SEL3

    config wave -signalnamewidth 1
    
    run -all

    wave zoom full
}

alias c "compilecode"
alias s "simulate"
