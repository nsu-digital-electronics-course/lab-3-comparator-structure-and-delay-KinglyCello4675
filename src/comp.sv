`timescale 1ns / 1ps

module comp #(
    parameter int parametr = 32  // параметр, регулирующий разрядность компаратора
) (
    input  logic [parametr-1:0] a,  
    input  logic [parametr-1:0] b,
    output logic gt, // a > b
    output logic eq, // a == b
    output logic lt  // a < b
);

    logic [parametr:0]   eq_terms;
    logic [parametr-1:0] gt_terms;
    logic [parametr-1:0] lt_terms;

    assign eq_terms[parametr] = 1'b1;

    genvar i;
    generate 
        for (i = 0; i < parametr; i++) begin : bit_compare
            // проверяем, что биты равны на текущей итерации i и что они были равны на i + 1
            assign eq_terms[i] = eq_terms[i+1] & ~(a[i] ^ b[i]);
            
            // проверяем, что все старшие биты равны и на текущей итерации a=1, b=0
            assign gt_terms[i] = eq_terms[i+1] & a[i] & ~b[i];
            
            // проверяем, что все старшие биты равны и на текущей итерации a=0, b=1
            assign lt_terms[i] = eq_terms[i+1] & ~a[i] & b[i];
        end
    endgenerate

    // завершающая часть кода
    assign eq = eq_terms[0];   // если в конце все биты сошлись, то выводим равенство
    assign gt = |gt_terms;     // проверяем каждый бит через ИЛИ; если было хотя бы одно выполнение условия, то выводим больше
    assign lt = |lt_terms;     // если было хотя бы одно выполнение условия, то выводим меньше

endmodule