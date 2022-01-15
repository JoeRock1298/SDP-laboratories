// ---------------------------------------------------------------------------------------------------------------------------
// Nombre del archivo: conversion_7segmentos.v
//
// Descripción: Código de verilog que contendrá la implementación del decodificador 7 segmentos que nos permitirá visualizar
// las coordenadas en los displays que incorpora la placa de desarrollo. Se reutilizará el diseño utilizado en la práctica 0:
//      - X_COORD, Y_COORD, Entrada de las coordenadas recibidas del ADC
//      - X_COORD_D, Y_COORD_D, Señal decodificada para 3 7-segmentos
//      - H3, señal de defecto para el resto de 7-segmentos
//
// ---------------------------------------------------------------------------------------------------------------------------
//      Versión: V1.0                   | Fecha Modificación: 11/01/2022
//
//      Autor: Jose Luis Rocabado Rocha
//		  Autor: Rafael Matevosyan
//
// ---------------------------------------------------------------------------------------------------------------------------

module conversion_7segmentos(
	input [11:0] X_COORD, Y_COORD, 
	output [20:0] X_COORD_D, Y_COORD_D,
	output [13:0] H3
);

	// decofidicación coordenada X
	HEX X0 ( .hex_digit(X_COORD[3:0]), .seg_a(X_COORD_D[0]), .seg_b(X_COORD_D[1]), .seg_c(X_COORD_D[2]), .seg_d(X_COORD_D[3]), .seg_e(X_COORD_D[4]), .seg_f(X_COORD_D[5]),.seg_g(X_COORD_D[6]) );

	HEX X1 ( .hex_digit(X_COORD[7:4]), .seg_a(X_COORD_D[7]), .seg_b(X_COORD_D[8]), .seg_c(X_COORD_D[9]), .seg_d(X_COORD_D[10]), .seg_e(X_COORD_D[11]), .seg_f(X_COORD_D[12]),.seg_g(X_COORD_D[13]) );

	HEX X2 ( .hex_digit(X_COORD[11:8]), .seg_a(X_COORD_D[14]), .seg_b(X_COORD_D[15]), .seg_c(X_COORD_D[16]), .seg_d(X_COORD_D[17]), .seg_e(X_COORD_D[18]), .seg_f(X_COORD_D[19]),.seg_g(X_COORD_D[20]) );

	// decodificación coordenada Y
	HEX Y0 ( .hex_digit(Y_COORD[3:0]), .seg_a(Y_COORD_D[0]), .seg_b(Y_COORD_D[1]), .seg_c(Y_COORD_D[2]), .seg_d(Y_COORD_D[3]), .seg_e(Y_COORD_D[4]), .seg_f(Y_COORD_D[5]), .seg_g(Y_COORD_D[6]) );

	HEX Y1 ( .hex_digit(Y_COORD[7:4]), .seg_a(Y_COORD_D[7]), .seg_b(Y_COORD_D[8]), .seg_c(Y_COORD_D[9]), .seg_d(Y_COORD_D[10]), .seg_e(Y_COORD_D[11]), .seg_f(Y_COORD_D[12]), .seg_g(Y_COORD_D[13]) );

	HEX Y2 ( .hex_digit(Y_COORD[11:8]), .seg_a(Y_COORD_D[14]), .seg_b(Y_COORD_D[15]), .seg_c(Y_COORD_D[16]), .seg_d(Y_COORD_D[17]), .seg_e(Y_COORD_D[18]), .seg_f(Y_COORD_D[19]), .seg_g(Y_COORD_D[20]) );
	
	// Señal por defecto del resto de displays
	HEX H2 ( .hex_digit(12'bx), .seg_a(H3[0]), .seg_b(H3[1]), .seg_c(H3[2]), .seg_d(H3[3]), .seg_e(H3[4]), .seg_f(H3[5]), .seg_g(H3[6]) );
	
	HEX H7 ( .hex_digit(12'bx), .seg_a(H3[7]), .seg_b(H3[8]), .seg_c(H3[9]), .seg_d(H3[10]), .seg_e(H3[11]), .seg_f(H3[12]), .seg_g(H3[13]) );
	


endmodule