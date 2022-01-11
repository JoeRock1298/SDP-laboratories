// Quartus Prime Verilog Template
// 4-State Moore state machine

// A Moore machine's outputs are dependent only on the current state.
// The output is written only when the state changes.  (State
// transitions are synchronous.)

module FSM
(
	input	CLK, fin_80, RST_n, dclk, ADC_PENIRQ_n,
	output ADC_CS, Ena_Trans, Fin_Trans
);

	// Declare state register
	reg [1:0] state, next_state;
	
	//Variables auxiliares
	reg Ena_transaux, ADC_CSaux, Fin_Transaux;
	
	// changing the state encoding type to user define
    (*syn_encoding="user"*)

	// Declare states
	parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;

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
				end
			S1:
				begin
					Ena_transaux = 1'b0;
					ADC_CSaux = 1'b0;
					Fin_Transaux = 1'b0;
				end
			S2:
				begin
					Ena_transaux = 1'b1;
					ADC_CSaux = 1'b1;
					Fin_Transaux = 1'b0;
				end
			S3:
				begin
					Ena_transaux = 1'b0;
					ADC_CSaux = 1'b0;
					Fin_Transaux = 1'b1;
				end
			default:
				begin
					Ena_transaux = 1'b0;
					ADC_CSaux = 1'b0;
					Fin_Transaux = 1'b0;
				end
		endcase
	end

	// Determine the next state
	always @ (state, ADC_PENIRQ_n, dclk, fin_80) 
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
						next_state = S0;

						
				default: next_state = S0;
			endcase
	end
	
	 assign ADC_CS = ADC_CSaux; 
	 assign Ena_Trans = Ena_transaux;
	 assign Fin_Trans = Fin_Transaux;
	 

endmodule