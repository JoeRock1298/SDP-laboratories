// -------------------------------------------------------------------------------------------------------------------------
// Universitat Politècnica de València
// Escuela Técnica Superior de Ingenieros de Telecomunicación
// -------------------------------------------------------------------------------------------------------------------------
// Sistemas Digitales Programables
// Curso 2021 - 2022
// -------------------------------------------------------------------------------------------------------------------------
// Nombre del archivo: HEX.v
//
// Descripción: Decodificador de hexadecimal a 7 segmentos. Funcionalidades:
//      - hex_digit, Entrada de señal exadecimal
//      - seg_x, [a-g]. Salidas correspondientes a los segmentos del display
//
// -------------------------------------------------------------------------------------------------------------------------
//      Versión: V1.0                   | Fecha Modificación: 27/10/2021
//
//      Autor: Jose Luis Rocabado Rocha
//		  Autor: Rafael Matevosyan
//
// -------------------------------------------------------------------------------------------------------------------------

module HEX ( 
    input [3:0] hex_digit,
    output seg_a, 
	 output seg_b, 
	 output seg_c, 
	 output seg_d, 
	 output seg_e, 
	 output seg_f, 
	 output seg_g);  //funciones de salida
	 
    reg [6:0] segment_data; //definimos reg al utilizarlo dentro de un always

    always@(hex_digit) //lista de sensibilidad
        case (hex_digit)               

            4'b 0000: segment_data=7'b 1111110;
            4'b 0001: segment_data=7'b 0110000;
            4'b 0010: segment_data=7'b 1101101;
            4'b 0011: segment_data=7'b 1111001;
            4'b 0100: segment_data=7'b 0110011;
            4'b 0101: segment_data=7'b 1011011;
            4'b 0110: segment_data=7'b 1011111; 
            4'b 0111: segment_data=7'b 1110000;
            4'b 1000: segment_data=7'b 1111111;
            4'b 1001: segment_data=7'b 1110011;
            4'b 1010: segment_data=7'b 1110111;
            4'b 1011: segment_data=7'b 0011111;
            4'b 1100: segment_data=7'b 1001110;
            4'b 1101: segment_data=7'b 0111101;
            4'b 1110: segment_data=7'b 1001111;
            4'b 1111: segment_data=7'b 1000111;        
            default: segment_data=7'b 1111111;
        endcase

   assign  seg_a=!segment_data[6];
   assign  seg_b=!segment_data[5];
   assign  seg_c=!segment_data[4];
   assign  seg_d=!segment_data[3];
   assign  seg_e=!segment_data[2];
   assign  seg_f=!segment_data[1];
   assign  seg_g=!segment_data[0];

    
endmodule