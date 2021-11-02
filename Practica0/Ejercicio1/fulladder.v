module fulladder(a, b, cin, La, Lb, Lc, Ld, Le, Lf, Lg );

	input [3:0]a;
	input [3:0]b; 
	input cin;
	wire cout1,cout2,cout3;
	wire [3:0] s;
	wire cout;
	output wire La, Lb, Lc, Ld, Le, Lf, Lg; 

	adder A1 (.a(a[0]),.b(b[0]),.cin(cin),.s(s[0]),.cout(cout1));
	adder A2 (.a(a[1]),.b(b[1]),.cin(cout1),.s(s[1]),.cout(cout2));
	adder A3 (.a(a[2]),.b(b[2]),.cin(cout2),.s(s[2]),.cout(cout3));
	adder A4 (.a(a[3]),.b(b[3]),.cin(cout3),.s(s[3]),.cout(cout));

	HEX d1 (.hex_digit(s), .seg_a(La), .seg_b(Lb), .seg_c(Lc), .seg_d(Ld), .seg_e(Le), .seg_f(Lf), .seg_g(Lg));

endmodule