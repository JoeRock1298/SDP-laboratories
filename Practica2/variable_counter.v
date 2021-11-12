// -------------------------------------------------------------------------------------------------------------------------
// Universitat Politècnica de València
// Escuela Técnica Superior de Ingenieros de Telecomunicación
// -------------------------------------------------------------------------------------------------------------------------
// Sistemas Digitales Programables
// Curso 2021 - 2022
// -------------------------------------------------------------------------------------------------------------------------
// Nombre del archivo: variable_counter.v
//
// Descripción: Este código Verilog implementa el contador variable de modulo parametrizable la subtarea 3 de la 
// Tarea 2 (Paso 2).
// Sus funcionalidades son:
//      - Funciona a flanco positivo del reloj de 50MHz
//      - Reset asincrono y activo a nivel bajo
//      - Entrada [3:0] iMOD que especifica el modulo a contar (2-16) 
//      - Salidas enable y up_down para la funcionalidad comentada arriba
//		  - Enable activo a nivel alto
//		  - Entrada modo. Si es 1 se selecciona el modulo de la entrada y si es 0, se selecciona el módulo maximo (parámetro)
//		  - Salidas del contador y del final de cuenta
//
// -------------------------------------------------------------------------------------------------------------------------
//      Versión: V1.0                   | Fecha Modificación: 12/11/2021
//
//      Autor: Jose Luis Rocabado Rocha
// 	  Autor: Rafael Matevosyan
//
// -------------------------------------------------------------------------------------------------------------------------

module variable_counter #(parameter width_counter = 4)(
    input iCLK, iRST_n, iENABLE, iMODE,
    input [width_counter-1:0] iMOD,
    output oTC,
    output [width_counter-1:0] oCOUNT
);
    //Declaring auxiliar variables
    reg [width_counter-1:0] out;
    wire [width_counter-1:0] end_count;

    //Declaring parameters
    localparam [width_counter-1:0] modulo_good = 2 ** width_counter - 1;

    //Assigning inputs and ouputs
    assign end_count = (iMODE)? iMOD : modulo_good;
    assign oCOUNT = out;
    assign oTC = ((out == end_count) && (iENABLE))? 1:0;
    
    always @(posedge iCLK, negedge iRST_n) 
    begin
        if(!iRST_n)
            out <= 0;
        else
            if(iENABLE)
                if (out == end_count)
                    out <= 0;
                else
                    out <= out + 1;
    end
    
endmodule