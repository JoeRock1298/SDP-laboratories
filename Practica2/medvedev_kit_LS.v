// -------------------------------------------------------------------------------------------------------------------------
// Universitat Politècnica de València
// Escuela Técnica Superior de Ingenieros de Telecomunicación
// -------------------------------------------------------------------------------------------------------------------------
// Sistemas Digitales Programables
// Curso 2021 - 2022
// -------------------------------------------------------------------------------------------------------------------------
// Nombre del archivo: medvedev_kit_LS.v
//
// Descripción: Este código Verilog implementa la máquina de estados Medvedev del contador Johnson de la subtarea 3 de 
// la Tarea 2. Sus funcionalidades son:
//      - Funciona a flanco positivo del reloj de 50MHz
//      - Reset asincrono y activo a nivel bajo
//      - Enable activo a nivel lto
//      - Salida [7:0] correspondiente al estado de los LED's
// -------------------------------------------------------------------------------------------------------------------------
//      Versión: V1.0                   | Fecha Modificación: 11/11/2021
//
//      Autor: Jose Luis Rocabado Rocha
// 	    Autor: Rafael Matevosyan
//
// -------------------------------------------------------------------------------------------------------------------------

module medvedev_kit_LS (
    input iCLK, iRST_n, iENABLE,
    output [7:0] oLEDG 
);

// changing the state encoding type to user define
(* syn_encoding = "user"*)

//declaring variables
reg [8:0] Estado_actual, Estado_siguiente;

//declaring parameters
parameter S1 = 9'b010000000, S2 = 9'b001000000, S3 = 9'b000100000, S4 = 9'b000010000;
parameter S5 = 9'b000001000, S6 = 9'b000000100, S7 = 9'b000000010, S8 = 9'b000000001; 
parameter S9 = {1'b1, S7[7:0]}, S10 = {1'b1, S6[7:0]}, S11 = {1'b1, S5[7:0]};
parameter S12 = {1'b1, S4[7:0]}, S13 = {1'b1, S3[7:0]}, S14 = {1'b1, S2[7:0]};

always @(Estado_actual, iENABLE) 
begin
    case (Estado_actual)
        S1:
            if (iENABLE) // internally if it's not it stays the same
                Estado_siguiente = S2;
        S2:
            if (iENABLE) 
                Estado_siguiente = S3;
        S3:
            if (iENABLE)
                Estado_siguiente = S4;
        S4:
            if (iENABLE) 
                Estado_siguiente = S5;
        S5:
            if (iENABLE) 
                Estado_siguiente = S6;
        S6:
            if (iENABLE)
                Estado_siguiente = S7;
        S7:
            if (iENABLE) 
                Estado_siguiente = S8;
        S8:
            if (iENABLE) 
                Estado_siguiente = S9;
        S9:
            if (iENABLE)
                Estado_siguiente = S10;
        S10:
            if (iENABLE) 
                Estado_siguiente = S11;
        S11:
            if (iENABLE) 
                Estado_siguiente = S12;
        S12:
            if (iENABLE)
                Estado_siguiente = S13;
        S13:
            if (iENABLE) 
                Estado_siguiente = S14;
        default: Estado_siguiente = S1;
    endcase
end

always @(posedge iCLK, negedge iRST_n) 
begin
    if (!iRST_n)
        Estado_actual <= S1;
    else 
        if (iENABLE)
            Estado_actual <= Estado_siguiente;  
end

assign oLEDG = Estado_actual[7:0];

endmodule