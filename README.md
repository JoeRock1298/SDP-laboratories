# SDP-laboratories
Lab exercices from MUISE master degree
EP4CE115F29C7
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
//      - El registro de desplazamiento funciona como un contador Johnson (generará 14 ciclos  para el juego de luces).
//      - iRST_n, activo a nivel bajo
//      - iCLK, Reloj activo por flanco de subida
//      - ENABLE
//      - LEDS_out, salida del juego de luces
//
// -------------------------------------------------------------------------------------------------------------------------
//      Versión: V1.0                   | Fecha Modificación: 27/10/2021
//
//      Autor: Jose Luis Rocabado Rocha
// 	  Autor: Rafael Matevosyan
//
// -------------------------------------------------------------------------------------------------------------------------
