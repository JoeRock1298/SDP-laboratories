transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/jose_/Dropbox/Pepelu/UPV/MUISE/SDP-Verilog/Practica4 {C:/Users/jose_/Dropbox/Pepelu/UPV/MUISE/SDP-Verilog/Practica4/ADC_CONTROL.v}
vlog -vlog01compat -work work +incdir+C:/Users/jose_/Dropbox/Pepelu/UPV/MUISE/SDP-Verilog/Practica4 {C:/Users/jose_/Dropbox/Pepelu/UPV/MUISE/SDP-Verilog/Practica4/FSM.v}
vlog -vlog01compat -work work +incdir+C:/Users/jose_/Dropbox/Pepelu/UPV/MUISE/SDP-Verilog/Practica4 {C:/Users/jose_/Dropbox/Pepelu/UPV/MUISE/SDP-Verilog/Practica4/contador.v}

vlog -vlog01compat -work work +incdir+C:/Users/jose_/Dropbox/Pepelu/UPV/MUISE/SDP-Verilog/Practica4 {C:/Users/jose_/Dropbox/Pepelu/UPV/MUISE/SDP-Verilog/Practica4/tb_Touch_Control.v}
vlog -vlog01compat -work work +incdir+C:/Users/jose_/Dropbox/Pepelu/UPV/MUISE/SDP-Verilog/Practica4 {C:/Users/jose_/Dropbox/Pepelu/UPV/MUISE/SDP-Verilog/Practica4/MFB.v}
vlog -vlog01compat -work work +incdir+C:/Users/jose_/Dropbox/Pepelu/UPV/MUISE/SDP-Verilog/Practica4 {C:/Users/jose_/Dropbox/Pepelu/UPV/MUISE/SDP-Verilog/Practica4/EMULE_ADC.vo}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb_Touch_Control

add wave *
view structure
view signals
run -all
