// -------------------------------------------------------------------------------------------------------------------------
// Universitat Politècnica de València
// Escuela Técnica Superior de Ingenieros de Telecomunicación
// -------------------------------------------------------------------------------------------------------------------------
// Sistemas Digitales Programables
// Curso 2021 - 2022
// -------------------------------------------------------------------------------------------------------------------------
// Nombre del archivo: contador.v
//
// Descripción: Este código Verilog implementa un contador parametrizable correspondiente a la subtarea 1 de la tarea 1.
// Sus funcionalidades son:
//      - RST_n, activo a nivel bajo, sincrono
//      - iCLK, Reloj activo por flanco de subida
//      - ENABLE
//      - iUP_DOWN, pin de dirección de conteo -> UP = 1, DOWN = 0
//		  - oCOUNT, Salida del contador
//		  - oTC, Pin de fin de cuenta (Terminal Count)
//
// -------------------------------------------------------------------------------------------------------------------------
//      Versión: V1.0                   | Fecha Modificación: 27/10/2021
//
//      Autor: Jose Luis Rocabado Rocha
//		  Autor: Rafael Matevosyan
//
// -------------------------------------------------------------------------------------------------------------------------

module contador (iCLK, iRST_n, iENABLE, iUP_DOWN, oCOUNT, oTC);

	parameter fin_cuenta = 20;
	
	`include "MathFun.vh"
	parameter n = CLogB2(fin_cuenta-1);
	
	input iCLK, iRST_n, iENABLE, iUP_DOWN;
	output reg [n-1:0] oCOUNT;
	output oTC;
	
	always @ (posedge iCLK)
		begin
		
			if ( !iRST_n )
				begin
					oCOUNT <= 0;							
				end
				
			
			else if ( iENABLE )

				if(iUP_DOWN)
				
					if ( oCOUNT == fin_cuenta-1)
						begin
							oCOUNT <= 0;				 
						end

					else
						begin
						oCOUNT <= oCOUNT + 1;			
						end
				else
				
					if ( oCOUNT == 0)
						begin
							oCOUNT <= fin_cuenta-1;								
						end

					else
						begin
						oCOUNT <= oCOUNT - 1;
						end
					
			else
				oCOUNT<=oCOUNT;

		end
		
		assign oTC =(oCOUNT == fin_cuenta-1)?1'b1:1'b0;
	
endmodule

