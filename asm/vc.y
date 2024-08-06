%token t_la t_lr t_value t_sp t_epc t_csr t_s0 t_s1 t_a0 t_a1 t_a2 t_a3 t_a4 t_a5 t_and t_or t_xor t_sub t_add t_mv t_nop t_inv t_ebreak t_jalr t_jr t_lw t_lb t_sw t_sb t_lea t_lui t_li t_beqz t_bnez t_bltz t_bgez t_j t_jal t_sll t_srl t_sra t_word t_byte t_name t_nl t_mul t_mulhi t_mmu t_addb t_addbu t_syscall t_stmp t_swapsp t_shl t_shr t_zext t_sext t_ldio t_stio t_flush t_dcache t_icache t_ret t_swap t_addpc t_div
%start  program
%%

exp:		e t_shl exp		{ $$ = $1 << $3; }
	|	e t_shr exp		{ $$ = $1 >> $3; }
	|	e			{ $$ = $1; }
	;
e:		e0 '&' e		{ $$ = $1 & $3; }
	|	e0 '|' e		{ $$ = $1 | $3; }
	|	e0 '^' e		{ $$ = $1 ^ $3; }
	|	e0			{ $$ = $1; }
	;

e0:		e1 '+' e0		{ $$ = $1 + $3; }
	|	e1 '-' e0		{ $$ = $1 - $3; }
	|	e1			{ $$ = $1; }
	;

e1:		e2 '*' e1		{ $$ = $1 * $3; }
	|	e2 '/' e1		{ $$ = ($3==0?0:$1 / $3); }
	|	e2			{ $$ = $1; }
	;
e2:		'+' e2 			{ $$ = $2; }
	|	'-' e2 			{ $$ = -$2; }
	|	'~' e2 			{ $$ = ~$2; }
	|	'(' exp ')' 		{ $$ = $2; }
	|	t_value 		{ $$ = $1; }
	;

xr:		rm 			{ $$ = 8|$1; }
	|	rx			{ $$ = $1; }
	;

rx: 		t_lr			{ $$ = 1; }
	|	t_epc			{ $$ = 3; }
	|	t_csr			{ $$ = 4; }
	|	t_mmu			{ $$ = 5; }
	|	t_stmp			{ $$ = 6; }
	|	t_mulhi			{ $$ = 7; }
	;
r:		xr			{ $$ = $1; }
	|	t_sp			{ $$ = 2; }
	;
rm:		t_s0 			{ $$ = 0; }
	|	t_s1 			{ $$ = 1; }
	|	t_a0			{ $$ = 2; }
	|	t_a1			{ $$ = 3; }
	|	t_a2			{ $$ = 4; }
	|	t_a3			{ $$ = 5; }
	|	t_a4			{ $$ = 6; }
	|	t_a5			{ $$ = 7; }
	;

ins:		t_and  rm ',' rm 	{ $$ = 0x8c61|($2<<7)|($4<<2); }      
	|	t_or  rm ',' rm         { $$ = 0x8c41|($2<<7)|($4<<2); } 
	|	t_mul  rm ',' rm        { $$ = 0x8c03|($2<<7)|($4<<2); } 
	|	t_div  rm ',' rm        { $$ = 0x8c23|($2<<7)|($4<<2); } 
	|	t_addb  rm ',' rm       { $$ = 0x8c43|($2<<7)|($4<<2); } 
	|	t_addbu  rm ',' rm      { $$ = 0x8c63|($2<<7)|($4<<2); } 
	|	t_swap  rm ',' rm      	{ $$ = 0x9c03|($2<<7)|($4<<2); } 
	|	t_addpc  rm      	{ $$ = 0x9c23|($2<<7); } 
	|	t_sext  rm      	{ $$ = 0x9c43|($2<<7); } 
	|	t_zext  rm      	{ $$ = 0x9c63|($2<<7); } 
	|	t_xor  rm ',' rm        { $$ = 0x8c21|($2<<7)|($4<<2); } 
	|	t_sub  rm ',' rm        { $$ = 0x8c01|($2<<7)|($4<<2); } 
	|	t_and  rm ',' exp	{ $$ = 0x8801|($2<<7)|imm6($4); }
	|	t_or  rm ',' exp	{ $$ = 0x8803|($2<<7)|imm6($4); }
	|	t_add  t_sp ',' exp 	{ $$ = 0x6101 | addsp($4); }
	|	t_add  t_sp ',' r       { $$ = 0x8002|(2<<7)|($4<<2); } 
	|	t_add  rm ',' exp	{ $$ = 0x0001|($2<<7)|imm8($4, 0); }
	|	t_add  rm ',' r        	{ $$ = 0x9002|((8|$2)<<7)|($4<<2); } 
	|	t_add  rx ',' r        	{ $$ = 0x9002|($2<<7)|($4<<2); } 
	|	t_mv   r ',' r        	{ $$ = 0x8002|($2<<7)|($4<<2); } 
	|	t_nop  			{ $$ = 0x0001; }
	|	t_inv  		 	{ $$ = 0x0003; }
	|	t_syscall  		{ $$ = 0x0017; }
	|	t_swapsp  		{ $$ = 0x001b; }
	|	t_ebreak  		{ $$ = 0x0007; }
	|	t_jalr r  		{ $$ = 0x9002|($2<<7); }
	|	t_jr r  		{ $$ = 0x8002|($2<<7); }
	|	t_ret	  		{ $$ = 0x8002|(1<<7); }
	|	t_lw r ',' exp '(' t_sp ')'{ $$ = 0x4002|($2<<7)|offX($4); }
	|	t_lw r ',' '(' t_sp ')'	{ $$ = 0x4002|($2<<7)|offX(0); }
	|	t_lb r ',' exp '(' t_sp ')'{ $$ = 0x6002|($2<<7)|off($4); chkr($2); }
	|	t_lb r ',' '(' t_sp ')'	{ $$ = 0x6002|($2<<7)|off(0); chkr($2); }
	|	t_lw r ',' exp '(' rm ')'{ $$ = 0x4000|($6<<7)|roffX($4)|(($2&7)<<2); chkr($2); }
	|	t_lw r ',' '(' rm ')'	{ $$ = 0x4000|($5<<7)|roffX(0)|(($2&7)<<2); chkr($2); }
	|	t_lb r ',' exp '(' rm ')'{ $$ = 0x6000|($6<<7)|roff($4)|(($2&7)<<2); chkr($2); }
	|	t_lb r ',' '(' rm ')'	{ $$ = 0x6000|($5<<7)|roff(0)|(($2&7)<<2); chkr($2); }
	|	t_sw r ',' exp '(' t_sp ')'{ $$ = 0xc002|($2<<7)|offX($4); }
	|	t_sw r ',' '(' t_sp ')'	{ $$ = 0xc002|($2<<7)|offX(0); }
	|	t_sb r ',' exp '(' t_sp ')'{ $$ = 0xe002|($2<<7)|off($4); chkr($2); }
	|	t_sb r ',' '(' t_sp ')'	{ $$ = 0xe002|($2<<7)|off(0); chkr($2); }
	|	t_sw r ',' exp '(' rm ')'{ $$ = 0xc000|($6<<7)|roffX($4)|(($2&7)<<2); chkr($2); }
	|	t_sw r ',' '(' rm ')'	{ $$ = 0xc000|($5<<7)|roffX(0)|(($2&7)<<2); chkr($2); }
	|	t_sb r ',' exp '(' rm ')'{ $$ = 0xe000|($6<<7)|roff($4)|(($2&7)<<2); chkr($2); }
	|	t_sb r ',' '(' rm ')'	{ $$ = 0xe000|($5<<7)|roff(0)|(($2&7)<<2); chkr($2); }
	|	t_lea rm ',' exp '(' t_sp ')' { $$ = 0x0000 | ($2<<2) | zoffX($4); }
	|	t_lea rm ',' '(' t_sp ')'{ $$ = 0x0000 | ($2<<2) | zoffX(0); }
	|	t_lui    rm ',' exp	{ $$ = 0x6001 | ((8|$2)<<7) | luioff($4,0); }	
	|	t_li     rm ',' exp	{ if (simple_li($4)) { $$ = 0x4001 | ($2<<7) | lioff($4); } else
						{
							int delta = $4;
							if (delta&0x80) {
                                                		delta = (delta&~0xff)+0x100;
                                        		} else {
                                                		delta = delta&~0xff;
                                        		}
						 	code[pc++] = 0x6001|((8|$2)<<7)|luioff(delta, 0);
							delta = ($4)&0xff;
                                			if (delta&0x80)
                                        			delta = -(0x100-delta);
							$$ = 0x0001 | ($2<<7) | imm8(delta, 0);
						}}
	|	t_beqz	rm ',' t_name	{ $$ = 0xc001 | ($2<<7); ref_label($4, 3, 0); }
	|	t_bnez	rm ',' t_name	{ $$ = 0xe001 | ($2<<7); ref_label($4, 3, 0); }
	|	t_bltz	rm ',' t_name	{ $$ = 0xe003 | ($2<<7); ref_label($4, 3, 0); }
	|	t_bgez	rm ',' t_name	{ $$ = 0xc003 | ($2<<7); ref_label($4, 3, 0); }
	|	t_j	t_name		{ $$ = 0xa001; ref_label($2, 2, 0); }
	|	t_jal	t_name		{ $$ = 0x2001; ref_label($2, 2, 0); }
	|	t_sll	rm ',' rm	{ $$ = 0x1002 | ($2<<7) | ($4<<2); }
	|	t_sll	rm ',' exp	{ $$ = 0x0002 | ($2<<7) | shift_exp($4); }
	|	t_srl	rm ',' rm	{ $$ = 0x9001 | ($2<<7) | ($4<<2); }
	|	t_srl	rm ',' exp 	{ $$ = 0x8001 | ($2<<7) | shift_exp($4); }
	|	t_sra	rm ',' rm	{ $$ = 0x9401 | ($2<<7) | ($4<<2); }
	|	t_sra	rm ',' exp	{ $$ = 0x8401 | ($2<<7) | shift_exp($4); }
	|	t_la	rm ',' t_name 	{ ref_label($4, 4, 0); code[pc++] = 0x6001|((8|$2)<<7); $$ = 0x0001 | ($2<<7); ref_label($4, 5, 0); }
	|	t_la	rm ',' t_name '+' exp 	{ ref_label($4, 4, $6); code[pc++] = 0x6001|((8|$2)<<7); $$ = 0x0001 | ($2<<7); ref_label($4, 5, $6); }
	|	'.' t_word exp		{ $$ = $3; }
	|	'.' t_word t_name 	{ $$ = 0; ref_label($3, 1, 0);}
	|	'.' t_word t_name '+' exp { $$ = $5; ref_label($3, 1, 0); }
	|	t_ldio r ',' exp '(' rm ')'{ $$ = 0x4003|($6<<7)|roffIO($4)|(($2&7)<<2); chkr($2); }
	|	t_ldio r ',' '(' rm ')'	{ $$ = 0x4003|($5<<7)|roffIO(0)|(($2&7)<<2); chkr($2); }
	|	t_stio r ',' exp '(' rm ')'{ $$ = 0x2003|($6<<7)|roffIO($4)|(($2&7)<<2); chkr($2); }
	|	t_stio r ',' '(' rm ')'	{ $$ = 0x2003|($5<<7)|roffIO(0)|(($2&7)<<2); chkr($2); }
	|	t_flush	'(' rm ')'	{ $$ = 0xa003|($3<<7); }
	|	t_flush	cache		{ $$ = 0x0023|($2<<2); }
	;

cache:		t_icache		{ $$ = 2; }
	|	t_dcache		{ $$ = 1; }
	|	t_dcache t_icache	{ $$ = 3; }
	|	t_icache t_dcache	{ $$ = 3; }


label:		t_name ':'		{ declare_label($1); }
	;

line:		label t_nl 		
	|	label ins t_nl		{ process_op($2);  }
	|	ins t_nl		{ process_op($1);  }
	|	'.' '=' exp t_nl	{ pc = $3/2; }
	|	'.' '=' '.' '+' exp t_nl{ pc += $5/2; }
	|	t_nl
	;

program:	line
	|	program line
	;
