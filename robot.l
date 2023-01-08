 
%x C_RODAR C_ANDAR C_OBJETO C_PINCA

%{
  #include "robot.tab.h"
%}

%option noyywrap

INICIO BEGIN

VIRAR_ESQUERDA VIRAR"-"ESQUERDA

VIRAR_DIREITA VIRAR"-"DIREITA

PINCA PIN"Ç"A

ANDAR ANDAR

RODAR RODAR

OBJ INIT"-"OBJETO

FIM END

%%


{INICIO}       return INICIO;
{FIM}         return FIM;

{VIRAR_ESQUERDA}	{
                return VIRAR_ESQUERDA;   
            }

{VIRAR_DIREITA}     { return VIRAR_DIREITA;}


{PINCA}\(		{BEGIN(C_PINCA); return INICIO_PINCA ;}
<C_PINCA>(ABRIR|FECHAR)	{ 
                       yylval.id=yytext;   return _PINCA;

}
<C_PINCA>\)		{BEGIN 0;return FIM_PINCA;}

{ANDAR}\(       {BEGIN(C_ANDAR); return INICIO_ANDAR;}
<C_ANDAR>(([1-9][0-9]|[1-9]|100))   {
                            yylval.inteiro=atoi(yytext);    return _ANDAR;

                                                }
<C_ANDAR>\)             {BEGIN 0; return FIM_ANDAR;}

{RODAR}\(		{BEGIN(C_RODAR);return INICIO_RODAR;}
<C_RODAR>(-)?(45|90|135|180|225|270|315|360)	{
						yylval.inteiro=atoi(yytext);	 return _RODAR;
} 
<C_RODAR>\)		{BEGIN 0;return FIM_RODAR;}

{OBJ}\(    {BEGIN(C_OBJETO); return INICIO_OBJETO;}
<C_OBJETO>(([1-9][0-9]|[1-9]|100)) {
                        yylval.inteiro=atoi(yytext); return _OBJETO;
}
<C_OBJETO>","   {return VIRGULA;}
<C_OBJETO>\)		{BEGIN 0; return FIM_OBJETO;}

(","|")"|"{"|"}")    return yytext[0];
[/t ]	;
.	;

%%
