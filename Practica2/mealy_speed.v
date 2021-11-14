// -------------------------------------------------------------------------------------------------------------------------
// Universitat Politècnica de València
// Escuela Técnica Superior de Ingenieros de Telecomunicación
// -------------------------------------------------------------------------------------------------------------------------
// Sistemas Digitales Programables
// Curso 2021 - 2022
// -------------------------------------------------------------------------------------------------------------------------
// Nombre del archivo: mealy_speed.v
//
// Descripción: Este código Verilog implementa la máquina de estados Mealy de la subtarea 3 de la Tarea 2 (Paso 2).
// Sus funcionalidades son:
//      - Funciona a flanco positivo del reloj de 50MHz
//      - Reset asincrono y activo a nivel bajo
//      - Como entrada: los pulsadores key[2] y key[1] que controlarán la velocidad en el paso final.
//		  Para este paso, su funcionalidad es incrementar o decrementar el contador que se connectará despues.
//      - Salidas enable y up_down para la funcionalidad comentada arriba
//
// -------------------------------------------------------------------------------------------------------------------------
//      Versión: V1.0                   | Fecha Modificación: 11/11/2021
//
//      Autor: Jose Luis Rocabado Rocha
// 	    Autor: Rafael Matevosyan
//
// -------------------------------------------------------------------------------------------------------------------------

module mealy_speed(
    input iCLK, iRST_n, iKEY2, iKEY1,
    output oENABLE, oUP_DOWN
);
    // changing the state encoding type to user define
    (*syn_encoding="user"*)
    
    //Declaring auxiliar variables
    reg [1:0] out, state, next_state;
	wire [1:0] in;

    //Assigning inputs and ouputs
    assign in = {iKEY2, iKEY1};
    assign oENABLE = (iRST_n)? out[1]:0;
    assign oUP_DOWN = (iRST_n)? out[0]:0;
    
    //Declaring parameters
    localparam S0 = 2'b 00, S1 = 2'b01, S2 = 2'b10;

    //State register
    always @(posedge iCLK, negedge iRST_n) 
    begin
        if (!iRST_n) 
            state <= S0;             
        else 
            state <= next_state;            
    end

    //Deciding the next estate. We change the speed at each latching and release of the KEY's
    //If the KEY is still latched, the output changes but stays in the same state until it is released abling the system to capture a new latch
    always @(state, in) 
    begin
        case (state)
            S0:
                if (in == 2'b01 ) 
                begin
                    out = 2'b11;
                    next_state = S1;
                end
                else if (in == 2'b10 )
                begin
                    out = 2'b10;
                    next_state = S2;
                end 
					 else
					 begin
						  out = 2'b0X;
                    next_state = S0;
					 end
            S1:
                if (in == 2'b01)
                begin
                    out = 2'b00;
                    next_state = S1;
                end
                else
                begin
                    out = 2'b0x;
                    next_state = S0;
                end
            S2:
                if (in == 2'b10)
                begin
                    out = 2'b00;
                    next_state = S2;
                end
                else
                begin
                    out = 2'b0x;
                    next_state = S0;
                end
            default: 
                begin
                    out = 2'b0x;
                    next_state = S0;
                end
        endcase     
    end

endmodule


