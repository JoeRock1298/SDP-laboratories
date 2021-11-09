// -------------------------------------------------------------------------------------------------------------------------
// Universitat Politècnica de València
// Escuela Técnica Superior de Ingenieros de Telecomunicación
// -------------------------------------------------------------------------------------------------------------------------
// Sistemas Digitales Programables
// Curso 2021 - 2022
// -------------------------------------------------------------------------------------------------------------------------
// Nombre del archivo: Lights_set.v
//
// Descripción: Este código Verilog implementa el decodificador del contador Johnson de la subtarea 3 de la Tarea 1. 
// Además, se instancia el contador parametrizable de la Subtarea 1, y el registro de desplazamiento de la Subtarea 2.
// Su funcionalidad es:
//      - El contador (frequencia de 50 MHz) se empleará para habilitar con su salida TC la señal de enable del registro de desplazamiento,
//        de forma que el desplazamiento sea cada 0,25 segundos.
//      - iRST_n, activo a nivel bajo asincrono, lleva la maquina al estado 0
//      - iCLK, Reloj activo por flanco de subida
//      - ENABLE  activa a nivel alto, habilita el funcionamiento del controlador; es decir, mientras esté activa el controlador debe hacer girar el motor (ir cambiando de estado).
//      - UP_DOWN sentido de giro del motor. Cuando está a nivel alto el motor gira en el sentido de las agujas del reloj, mientras que a nivel bajo lo hace en sentido contrario.
//      - HALF_FULL, esta línea permite configurar el modo de funcionamiento. Cuando está a nivel alto el motor está en modo HALF, mientras que a nivel bajo el motor se configura en modo NORMAL o WAVE.
// -------------------------------------------------------------------------------------------------------------------------
//      Versión: V1.0                   | Fecha Modificación: 27/10/2021
//
//      Autor: Jose Luis Rocabado Rocha
// 	    Autor: Rafael Matevosyan
//
// -------------------------------------------------------------------------------------------------------------------------

module control_motor (
    input CLK, RESET, UP_DOWN, HALF_PULL, ENABLE,
    output wire A, B, C, D, INH1, INH2
);

reg [2:0] Estado_actual, Estado_siguiente;
parameter S1 = 3'b000, S2 =3'b001, S3 =3'b010, S4 =3'b011, S5 =3'b100, S6 =3'b101, S7 =3'b110, S8 =3'b111;
reg [5:0] x;


always @(posedge CLK, negedge RESET) begin

    if(!RESET)
        Estado_actual <= S1;
    
    else
        if (ENABLE) begin
            Estado_actual <= Estado_siguiente;
        end
end

always @(Estado_actual) begin
    case (Estado_actual)
        S1: 
		  begin
                x[0] = 0;
                x[1] = 1;
                x[2] = 0;
                x[3] = 1;
                x[4] = 1;
                x[5] = 1;
			end

         S2:
            begin
                x[0] = 0;
                x[1] = 0;
                x[2] = 0;
                x[3] = 1;
                x[4] = 0;
                x[5] = 1;   
            end 
            

         S3: 
            begin
                x[0] = 1;
                x[1] = 1;
                x[2] = 0;
                x[3] = 0;
                x[4] = 1;
                x[5] = 1; 
            end 

         S4: 
            begin
                
                x[0] = 1;
                x[1] = 0;
                x[2] = 0;
                x[3] = 0;
                x[4] = 1;
                x[5] = 0;

            end
         S5: 
            begin
                x[0] = 1;
                x[1] = 0;
                x[2] = 1;
                x[3] = 0;
                x[4] = 1;
                x[5] = 1;

            end
         S6: 
            begin
                x[0] = 0;
                x[1] = 0;
                x[2] = 1;
                x[3] = 0;
                x[4] = 0;
                x[5] = 1;

            end
        S7: 
            begin
                x[0] = 0;
                x[1] = 1;
                x[2] = 1;
                x[3] = 0;
                x[4] = 1;
                x[5] = 1; 
 
            end
        S8: 
            begin
                x[0] = 0;
                x[1] = 1;
                x[2] = 0;
                x[3] = 0;
                x[4] = 1;
                x[5] = 0;
            end         
        default: x = 0;
    endcase

end

//Asignacion de los valores del vector x a las salidas mediante un assign
assign A = x[0];
assign B = x[1];
assign C = x[2];
assign D = x[3];
assign INH1 = x[4];
assign INH2 = x[5];

//Determinar el estado siguiente
always @(Estado_actual, ENABLE, UP_DOWN, HAL_FULL) 
    begin

    case (Estado_actual)
        S1: if (HALF_FULL) 
                if (UP_DOWN) 
                    Estado_siguiente = S2;
                else
                    Estado_siguiente = S8;
            else 
                if(UP_DOWN) 
                    Estado_siguiente = S3;
                else
                    Estado_siguiente = S7;

        S2: if (HALF_FULL) 
                if (UP_DOWN) 
                    Estado_siguiente = S3;
                else
                    Estado_siguiente = S1;
            else 
                if(UP_DOWN) 
                    Estado_siguiente = S4;
                else
                    Estado_siguiente = S8;

        S3:  if (HALF_FULL) 
                if (UP_DOWN) 
                    Estado_siguiente = S4;
                else
                    Estado_siguiente = S2;
            else 
                if(UP_DOWN) 
                    Estado_siguiente = S5;
                else
                    Estado_siguiente = S1;  

        S4:  if (HALF_FULL) 
                if (UP_DOWN) 
                    Estado_siguiente = S5;
                else
                    Estado_siguiente = S3;
            else 
                if(UP_DOWN) 
                    Estado_siguiente = S6;
                else
                    Estado_siguiente = S2;

        S5:  if (HALF_FULL) 
                if (UP_DOWN) 
                    Estado_siguiente = S6;
                else
                    Estado_siguiente = S4;
            else 
                if(UP_DOWN) 
                    Estado_siguiente = S7;
                else
                    Estado_siguiente = S3; 

        S6:  if (HALF_FULL) 
                if (UP_DOWN) 
                    Estado_siguiente = S7;
                else
                    Estado_siguiente = S5;
            else 
                if(UP_DOWN) 
                    Estado_siguiente = S8;
                else
                    Estado_siguiente = S4; 

        S7:  if (HALF_FULL) 
                if (UP_DOWN) 
                    Estado_siguiente = S8;
                else
                    Estado_siguiente = S6;
            else 
                if(UP_DOWN) 
                    Estado_siguiente = S1;
                else
                    Estado_siguiente = S5; 

        S8:  if (HALF_FULL) 
                if (UP_DOWN) 
                    Estado_siguiente = S1;
                else
                    Estado_siguiente = S7;
            else 
                if(UP_DOWN) 
                    Estado_siguiente = S2;
                else
                    Estado_siguiente = S6; 

        default: Estado_siguiente = S1;
    endcase

    end




endmodule


