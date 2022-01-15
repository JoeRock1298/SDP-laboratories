// --------------------------------------------------------------------------------------------------------------------------
// Universitat Politècnica de València
// Escuela Técnica Superior de Ingenieros de Telecomunicación
// --------------------------------------------------------------------------------------------------------------------------
// Sistemas Digitales Programables
// Curso 2021 - 2022
// --------------------------------------------------------------------------------------------------------------------------
// Nombre del archivo: ADC_CONTROL_mejorado.v
//
// Descripción: Código de verilog que contendrá la implementación necesaria para la comunicación con el ADC que incoprora la
// pantalla táctil de la placa de desarrollo. Contiene segundo diseño de la subtarea 2 de la práctica 4.
// Añade un decodificador 7 segmentos para visualizar llas corrdenadas en el display ademas de un retraso entre adquisicones.
// Sus funcionalidades son:
//      - RST_n, activo a nivel bajo, sincrono que se conectara al contador
//      - CLK, Reloj activo por flanco de subida de 50MHz
//      - ADC_DIN, Señal de petición de datos al ADC
//		  - ADC_DCLK, Señal de sincronización de la comunicación con el ADC
//		  - SCEN, Señal de selección de inicio de la comunicación con al ADC
//		  - ADC_DOUT, Señal de recepción de datos del ADC
//		  - ADC_BUSY, Flag de estado del ADC. En este diseño no se utiliza
//		  - PENIRQ, Señal de interrupción que indica que la pantalla ha sido presionada
//		  - X_COORD, YCOORD, Corrdenadas leeidas del ADC
//		  - X_COORD_D, Y_COORD_D, H3, Señales de control para la visualización de las coordeanadas en los 7-seg
//
// -------------------------------------------------------------------------------------------------------------------------
//      Versión: V1.0                   | Fecha Modificación: 14/12/2021
//
//      Autor: Jose Luis Rocabado Rocha
//		  Autor: Rafael Matevosyan
//
// -------------------------------------------------------------------------------------------------------------------------

module ADC_CONTROL_mejorado(
					iCLK,
					iRST_n,
					oADC_DIN,
					oADC_DCLK,
					oSCEN,
					iADC_DOUT,
					iADC_BUSY,
					iADC_PENIRQ_n,
					oX_COORD,
					oY_COORD,
					X_COORD_D, 
					Y_COORD_D,
					H3
					);

	parameter SYSCLK_FRQ	= 50000000;
	parameter ADC_DCLK_FRQ	= 70000;
	parameter ADC_DCLK_CNT	= SYSCLK_FRQ/(ADC_DCLK_FRQ*2);
	localparam X_CONTROL = 8'b10010010;
	localparam Y_CONTROL = 8'b11010010;

	input			iCLK;
	input			iRST_n;
	input			iADC_DOUT;
	input			iADC_PENIRQ_n;
	input			iADC_BUSY;
	output			oADC_DIN;	
	output			oADC_DCLK;
	output			oSCEN;
	output	[11:0]	oX_COORD;
	output	[11:0]	oY_COORD;
	output   [20:0] X_COORD_D, Y_COORD_D;
	output	[13:0]	H3;

	//Wires
	wire trans_en, trans_eof, half_dclk, dclk, fin_80;  
	wire [6:0] count_80; 
	wire [11:0] testX = 12'h76F;
	wire [11:0] testy = 12'h76F;
	wire wait_en, wait_irq; // this is part of the upgrade
	
	reg ADC_DIN;
	reg [11:0]	X_COORDaux, Y_COORDaux;
	

	//contador del ADC_DCLK_CNT TC 
	contador #(.fin_cuenta(ADC_DCLK_CNT)) ADC_CNT1 (.iCLK(iCLK), .iRST_n(iRST_n), .iENABLE(trans_en), .iUP_DOWN(1), .oCOUNT(), .oTC(dclk) );

	//contador del ADC_DCLK_CNT/2 TC
	contador #(.fin_cuenta(ADC_DCLK_CNT/2)) ADC_CNT1_HALF (.iCLK(iCLK), .iRST_n(iRST_n), .iENABLE(trans_en), .iUP_DOWN(1), .oCOUNT(), .oTC(half_dclk) );

	//contador del ADC_DCLK_CNT TC
	contador #(.fin_cuenta(80)) ADC_CNT_80 (.iCLK(iCLK), .iRST_n(iRST_n), .iENABLE(dclk), .iUP_DOWN(1), .oCOUNT(count_80), .oTC(fin_80) );

	//Generador ADC_DCLK
	assign oADC_DCLK = (iRST_n)?count_80[0]:0;
	
	//FSM
	//FSM Control (.CLK(iCLK), .fin_80(fin_80), .RST_n(iRST_n), .dclk(dclk), .ADC_PENIRQ_n(iADC_PENIRQ_n), .ADC_CS(oSCEN), .Ena_Trans(trans_en), .Fin_Trans(trans_eof)  );
	
	//upgraded FSM
	FSM_mejorado Control (.CLK(iCLK), .fin_80(fin_80), .RST_n(iRST_n), .dclk(dclk), .ADC_PENIRQ_n(iADC_PENIRQ_n),
								 .Wait_irq(wait_irq), .ADC_CS(oSCEN), .Ena_Trans(trans_en), .Fin_Trans(trans_eof), .Wait_en(wait_en));
	
	//Decodificador
	conversion_7segmentos decodificador ( .X_COORD(X_COORDaux), .Y_COORD(Y_COORDaux), .X_COORD_D(X_COORD_D), .Y_COORD_D(Y_COORD_D), .H3(H3));
	
	//Generador ADC_DIN
	always @(posedge iCLK) 
	begin
		
		if (!iRST_n) 
			ADC_DIN <= 0;
		
		else
			if(trans_en)
			begin
			
					case (count_80)
						0: ADC_DIN <= X_CONTROL[7];
						1: ADC_DIN <= X_CONTROL[7];
						2: ADC_DIN <= X_CONTROL[6];
						3: ADC_DIN <= X_CONTROL[6];
						4: ADC_DIN <= X_CONTROL[5];
						5: ADC_DIN <= X_CONTROL[5];
						6: ADC_DIN <= X_CONTROL[4];
						7: ADC_DIN <= X_CONTROL[4];
						8: ADC_DIN <= X_CONTROL[3];
						9: ADC_DIN <= X_CONTROL[3];
						10: ADC_DIN <= X_CONTROL[2];
						11: ADC_DIN <= X_CONTROL[2];
						12: ADC_DIN <= X_CONTROL[1];
						13: ADC_DIN <= X_CONTROL[1];
						14: ADC_DIN <= X_CONTROL[0];
						15: ADC_DIN <= X_CONTROL[0];
						
						32: ADC_DIN <= Y_CONTROL[7];
						33: ADC_DIN <= Y_CONTROL[7];
						34: ADC_DIN <= Y_CONTROL[6];
						35: ADC_DIN <= Y_CONTROL[6];
						36: ADC_DIN <= Y_CONTROL[5];
						37: ADC_DIN <= Y_CONTROL[5];
						38: ADC_DIN <= Y_CONTROL[4];
						39: ADC_DIN <= Y_CONTROL[4];
						40: ADC_DIN <= Y_CONTROL[3];
						41: ADC_DIN <= Y_CONTROL[3];
						42: ADC_DIN <= Y_CONTROL[2];
						43: ADC_DIN <= Y_CONTROL[2];
						44: ADC_DIN <= Y_CONTROL[1];
						45: ADC_DIN <= Y_CONTROL[1];
						46: ADC_DIN <= Y_CONTROL[0];
						47: ADC_DIN <= Y_CONTROL[0];
			
						default: ADC_DIN <= 0;
					endcase
			end
	end
		
	assign oADC_DIN = ADC_DIN;
		
		
		//Generador ADC_DOUT
	always @(posedge iCLK) 
	begin
		
		if (!iRST_n) 
		begin
			X_COORDaux <= 0;
			Y_COORDaux <= 0;
			
		end 
		
		else
		
			if(trans_en)
			begin
			
			
				case (count_80)
					18:   X_COORDaux[11] <= iADC_DOUT;
					19:   X_COORDaux[11] <= iADC_DOUT;
					20:   X_COORDaux[10] <= iADC_DOUT;
					21:   X_COORDaux[10] <= iADC_DOUT;
					22:   X_COORDaux[9] <= iADC_DOUT;
					23:   X_COORDaux[9] <= iADC_DOUT;
					24:   X_COORDaux[8] <= iADC_DOUT;
					25:   X_COORDaux[8] <= iADC_DOUT;
					26:   X_COORDaux[7] <= iADC_DOUT;
					27:   X_COORDaux[7] <= iADC_DOUT;
					28:   X_COORDaux[6] <= iADC_DOUT;
					29:   X_COORDaux[6] <= iADC_DOUT;
					30:   X_COORDaux[5] <= iADC_DOUT;
					31:   X_COORDaux[5] <= iADC_DOUT;
					32:   X_COORDaux[4] <= iADC_DOUT;
					33: 	X_COORDaux[4] <= iADC_DOUT;
					34:   X_COORDaux[3] <= iADC_DOUT;
					35: 	X_COORDaux[3] <= iADC_DOUT;
					36:   X_COORDaux[2] <= iADC_DOUT;
					37: 	X_COORDaux[2] <= iADC_DOUT;
					38:   X_COORDaux[1] <= iADC_DOUT;
					39: 	X_COORDaux[1] <= iADC_DOUT;
					40:   X_COORDaux[0] <= iADC_DOUT;
					41: 	X_COORDaux[0] <= iADC_DOUT;
					
					50: 	Y_COORDaux[11] <= iADC_DOUT;
					51:   Y_COORDaux[11] <= iADC_DOUT;
					52:   Y_COORDaux[10] <= iADC_DOUT;
					53:   Y_COORDaux[10] <= iADC_DOUT;
					54:   Y_COORDaux[9] <= iADC_DOUT;
					55:   Y_COORDaux[9] <= iADC_DOUT;
					56:   Y_COORDaux[8] <= iADC_DOUT;
					57:   Y_COORDaux[8] <= iADC_DOUT;
					58:   Y_COORDaux[7] <= iADC_DOUT;
					59:   Y_COORDaux[7] <= iADC_DOUT;
					60:   Y_COORDaux[6] <= iADC_DOUT;
					61:   Y_COORDaux[6] <= iADC_DOUT;
					62:   Y_COORDaux[5] <= iADC_DOUT;
					63:   Y_COORDaux[5] <= iADC_DOUT;
					64: 	Y_COORDaux[4] <= iADC_DOUT;
					65: 	Y_COORDaux[4] <= iADC_DOUT;
					66: 	Y_COORDaux[3] <= iADC_DOUT;
					67: 	Y_COORDaux[3] <= iADC_DOUT;
					68: 	Y_COORDaux[2] <= iADC_DOUT;
					69: 	Y_COORDaux[2] <= iADC_DOUT;
					70: 	Y_COORDaux[1] <= iADC_DOUT;
					71: 	Y_COORDaux[1] <= iADC_DOUT;
					72: 	Y_COORDaux[0] <= iADC_DOUT;
					73: 	Y_COORDaux[0] <= iADC_DOUT;
			
				default:
					begin
					
						X_COORDaux <= X_COORDaux;
						Y_COORDaux <= Y_COORDaux;
					
					end
			endcase
			end
	end
		
		assign oX_COORD = X_COORDaux;
		assign oY_COORD = Y_COORDaux;

	
	//Adding upgrades
	contador #(.fin_cuenta(25000000)) HALF_S_CNT (.iCLK(iCLK), .iRST_n(iRST_n), .iENABLE(wait_en), .iUP_DOWN(1), .oCOUNT(), .oTC(wait_irq)); 
	
	
endmodule