transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/jose_/Dropbox/Pepelu/UPV/MUISE/SDP-Verilog/Practica2 {C:/Users/jose_/Dropbox/Pepelu/UPV/MUISE/SDP-Verilog/Practica2/medvedev_kit_LS.v}
vlog -vlog01compat -work work +incdir+C:/Users/jose_/Dropbox/Pepelu/UPV/MUISE/SDP-Verilog/Practica2 {C:/Users/jose_/Dropbox/Pepelu/UPV/MUISE/SDP-Verilog/Practica2/contador.v}

vlog -vlog01compat -work work +incdir+C:/Users/jose_/Dropbox/Pepelu/UPV/MUISE/SDP-Verilog/Practica2 {C:/Users/jose_/Dropbox/Pepelu/UPV/MUISE/SDP-Verilog/Practica2/paso1_TB.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  paso1_TB

add wave *
view structure
view signals
run -all
