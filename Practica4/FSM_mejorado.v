// -------------------------------------------------------------------------------------------------------------------------
// Nombre del archivo: FSM_mejorado.v
//
// Descripción: Código de verilog que contendrá la implementación de la máquina de estados que controlará la comunicación 
// con el ADC que incoprora la pantalla táctil de la placa de desarrollo. Incorpora un estado adicional que permitirá
// controlar el tiempo entre adquisición de coordenadas. Sus funcionalidades son:
//      - CLK, Reloj activo por flanco de subida de 50MHz
//      - fin_80, Enable activo a nivel bajo. Nos indicará cuando el contador de semiciclos llega a su fin
//      - RST_n, activo a nivel bajo, sincrono que se conectara al contador
//		  - dclk, Señal de sincronización de la comunicación con el ADC
//		  - SCEN, Señal de selección de inicio de la comunicación con al ADC
//		  - ADC_PENIRQ_n, Señal de interrupción del ADC activo a nivel bajo
//		  - Wait_irq, Señal de interrupción que controla el delay entre adquisiciones 
//		  - ADC_CS, Señal de selección del ADC.
//		  - Ena_Trans, Flag de habilicatión de la comunicación
//		  - Fin_trans, Flag del final de la transmisión
//		  - Wait_en, Flag de la hbailitación del retraso entre adquisiciones
//
// -------------------------------------------------------------------------------------------------------------------------
//      Versión: V1.0                   | Fecha Modificación: 14/01/2022
//
//      Autor: Jose Luis Rocabado Rocha
//		  Autor: Rafael Matevosyan
//
// -------------------------------------------------------------------------------------------------------------------------

module FSM_mejorado
(
	input	CLK, fin_80, RST_n, dclk, ADC_PENIRQ_n, Wait_irq,
	output ADC_CS, Ena_Trans, Fin_Trans, Wait_en
);

	// Declare state register
	reg [2:0] state, next_state;
	
	//Variables auxiliares
	reg Ena_transaux, ADC_CSaux, Fin_Transaux, Wait_enaux;
	
	// changing the state encoding type to user define
    (*syn_encoding="user"*)

	// Declare states
	parameter S0 = 3'b000, S1 = 3'b001, S2 = 2'b010, S3 = 2'b011, S4 = 3'b100;

	//State register
    always @(posedge CLK, negedge RST_n) 
    begin
        if (!RST_n) 
            state <= S0;             
        else 
            state <= next_state;            
    end
	
	// Output depends only on the state
	always @ (state) begin
		case (state)
			S0:
				begin
					Ena_transaux = 1'b0;
					ADC_CSaux = 1'b0;
					Fin_Transaux = 1'b0;
					Wait_enaux = 1'b0;
				end
			S1:
				begin
					Ena_transaux = 1'b0;
					ADC_CSaux = 1'b0;
					Fin_Transaux = 1'b0;
					Wait_enaux = 1'b0;
				end
			S2:
				begin
					Ena_transaux = 1'b1;
					ADC_CSaux = 1'b1;
					Fin_Transaux = 1'b0;
					Wait_enaux = 1'b0;
				end
			S3:
				begin
					Ena_transaux = 1'b0;
					ADC_CSaux = 1'b0;
					Fin_Transaux = 1'b1;
					Wait_enaux = 1'b0;
				end
			S4:
				begin
					Ena_transaux = 1'b0;
					ADC_CSaux = 1'b0;
					Fin_Transaux = 1'b0;
					Wait_enaux = 1'b1;
				end
			default:
				begin
					Ena_transaux = 1'b0;
					ADC_CSaux = 1'b0;
					Fin_Transaux = 1'b0;
					Wait_enaux = 1'b0;
				end
		endcase
	end

	// Determine the next state
	always @ (state, ADC_PENIRQ_n, dclk, fin_80, Wait_irq) 
	begin
			next_state = S0;
		
			case (state)
				S0:
					next_state = S1;
				S1:
					if (ADC_PENIRQ_n)
						next_state = S1;
					else
						next_state = S2;
				S2:
					if (dclk == 1 && fin_80 == 1 )
						next_state = S3;
					else
						next_state = S2;
				S3:
						next_state = S4;
				S4:
					if (Wait_irq)
						next_state = S0;
					else
						next_state = S4;
				default: next_state = S0;
			endcase
	end
	
	 assign ADC_CS = ADC_CSaux; 
	 assign Ena_Trans = Ena_transaux;
	 assign Fin_Trans = Fin_Transaux;
	 assign Wait_en = Wait_enaux;

endmodule
