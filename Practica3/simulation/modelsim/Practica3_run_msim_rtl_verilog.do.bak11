transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+W:/www/MUISE/Sistemas\ digitales\ programables/Practica1\ Subir/SDP-laboratories/Practica3 {W:/www/MUISE/Sistemas digitales programables/Practica1 Subir/SDP-laboratories/Practica3/LCD_SYNC.v}
vlog -vlog01compat -work work +incdir+W:/www/MUISE/Sistemas\ digitales\ programables/Practica1\ Subir/SDP-laboratories/Practica3 {W:/www/MUISE/Sistemas digitales programables/Practica1 Subir/SDP-laboratories/Practica3/pll_ltm.v}
vlog -vlog01compat -work work +incdir+W:/www/MUISE/Sistemas\ digitales\ programables/Practica1\ Subir/SDP-laboratories/Practica3 {W:/www/MUISE/Sistemas digitales programables/Practica1 Subir/SDP-laboratories/Practica3/ROM_image.v}
vlog -vlog01compat -work work +incdir+W:/www/MUISE/Sistemas\ digitales\ programables/Practica1\ Subir/SDP-laboratories/Practica3/db {W:/www/MUISE/Sistemas digitales programables/Practica1 Subir/SDP-laboratories/Practica3/db/pll_ltm_altpll.v}
vlog -vlog01compat -work work +incdir+W:/www/MUISE/Sistemas\ digitales\ programables/Practica1\ Subir/SDP-laboratories/Practica3 {W:/www/MUISE/Sistemas digitales programables/Practica1 Subir/SDP-laboratories/Practica3/contador.v}
vlog -vlog01compat -work work +incdir+W:/www/MUISE/Sistemas\ digitales\ programables/Practica1\ Subir/SDP-laboratories/Practica3 {W:/www/MUISE/Sistemas digitales programables/Practica1 Subir/SDP-laboratories/Practica3/IMAGEN_LCD.v}

vlog -vlog01compat -work work +incdir+W:/www/MUISE/Sistemas\ digitales\ programables/Practica1\ Subir/SDP-laboratories/Practica3 {W:/www/MUISE/Sistemas digitales programables/Practica1 Subir/SDP-laboratories/Practica3/IMAGEN_LCD_TB.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  IMAGEN_LCD_TB

add wave *
view structure
view signals
run -all
