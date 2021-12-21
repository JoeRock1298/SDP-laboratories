transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+W:/www/MUISE/Sistemas\ digitales\ programables/Practica1\ Subir/SDP-laboratories/Practica4 {W:/www/MUISE/Sistemas digitales programables/Practica1 Subir/SDP-laboratories/Practica4/ADC_CONTROL.v}
vlog -vlog01compat -work work +incdir+W:/www/MUISE/Sistemas\ digitales\ programables/Practica1\ Subir/SDP-laboratories/Practica4 {W:/www/MUISE/Sistemas digitales programables/Practica1 Subir/SDP-laboratories/Practica4/FSM.v}
vlog -vlog01compat -work work +incdir+W:/www/MUISE/Sistemas\ digitales\ programables/Practica1\ Subir/SDP-laboratories/Practica4 {W:/www/MUISE/Sistemas digitales programables/Practica1 Subir/SDP-laboratories/Practica4/contador.v}

vlog -vlog01compat -work work +incdir+W:/www/MUISE/Sistemas\ digitales\ programables/Practica1\ Subir/SDP-laboratories/Practica4 {W:/www/MUISE/Sistemas digitales programables/Practica1 Subir/SDP-laboratories/Practica4/EMULE_ADC.vo}
vlog -vlog01compat -work work +incdir+W:/www/MUISE/Sistemas\ digitales\ programables/Practica1\ Subir/SDP-laboratories/Practica4 {W:/www/MUISE/Sistemas digitales programables/Practica1 Subir/SDP-laboratories/Practica4/tb_Touch_Control.v}
vlog -vlog01compat -work work +incdir+W:/www/MUISE/Sistemas\ digitales\ programables/Practica1\ Subir/SDP-laboratories/Practica4 {W:/www/MUISE/Sistemas digitales programables/Practica1 Subir/SDP-laboratories/Practica4/MFB.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  tb_Touch_Control

add wave *
view structure
view signals
run -all
