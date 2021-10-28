// -------------------------------------------------------------------------------------------------------------------------
// Universitat Politècnica de València
// Escuela Técnica Superior de Ingenieros de Telecomunicación
// -------------------------------------------------------------------------------------------------------------------------
// Sistemas Digitales Programables
// Curso 2021 - 2022
// -------------------------------------------------------------------------------------------------------------------------
// Nombre del archivo: registro7.v
//
// Descripción: Este código Verilog implementa el regitstro de desplazamiento de 7 bits correspondiente a la subtarea 2 de la tarea 1.
// Sus funcionalidades son:
//      - RST_n, activo a nivel bajo, sincrono
//      - iCLK, Reloj activo por flanco de subida
//      - ENABLE
//      - iSR, entrada serie
//		- oPR, Salida paralela
//		- oSR, Salida serie
//
// -------------------------------------------------------------------------------------------------------------------------
//      Versión: V1.0                   | Fecha Modificación: 27/10/2021
//
//      Autor: Jose Luis Rocabado Rocha
//		  Autor: Rafael Matevosyan
//
// -------------------------------------------------------------------------------------------------------------------------

module registro7 (iCLK, iRST_n, iENABLE, iSR, oPR, oSR);
	
	input iCLK, iRST_n, iENABLE, iSR;
	output wire [6:0] oPR;
	output wire oSR;
	reg [6:0] x;		//Variable auxiliar para conectar las salidas a un valor fijo
 	
	always @ (posedge iCLK)
		begin
			if ( !iRST_n )
				begin
					x <= 0;
				end							
			else if ( iENABLE )
				begin
					x[6] <= iSR;			//Asignacion de la entrada al ultimo bit
					x[5:0] <= oPR[6:1]; 	//Desplazamiento del registro
				end
		end
		
		assign oPR[6:0] = x[6:0];
		assign oSR = x[0];
		
endmodule
