transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/jose_/Dropbox/Pepelu/UPV/MUISE/SDP-Verilog/Practica1 {C:/Users/jose_/Dropbox/Pepelu/UPV/MUISE/SDP-Verilog/Practica1/registro7.v}
vlog -vlog01compat -work work +incdir+C:/Users/jose_/Dropbox/Pepelu/UPV/MUISE/SDP-Verilog/Practica1 {C:/Users/jose_/Dropbox/Pepelu/UPV/MUISE/SDP-Verilog/Practica1/Lights_set.v}
vlog -vlog01compat -work work +incdir+C:/Users/jose_/Dropbox/Pepelu/UPV/MUISE/SDP-Verilog/Practica1 {C:/Users/jose_/Dropbox/Pepelu/UPV/MUISE/SDP-Verilog/Practica1/contador.v}

vlog -vlog01compat -work work +incdir+C:/Users/jose_/Dropbox/Pepelu/UPV/MUISE/SDP-Verilog/Practica1 {C:/Users/jose_/Dropbox/Pepelu/UPV/MUISE/SDP-Verilog/Practica1/tb_Lights_set.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb_Lights_set

add wave *
view structure
view signals
run -all
