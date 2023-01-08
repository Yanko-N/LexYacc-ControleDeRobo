%{
  #include <math.h>
  #include <stdbool.h>
  #include <stdio.h>
  #include <string.h>
 
  int pos_x=1, pos_y=1, andar_n=0, braco=0;
  int x_object=0 , y_object=0;
  char * e_object = "solto";
  char * dir = "Norte(+yy)", *dir_braco="Sul", *e_pinca="Fechada";
  
  int numErros=0;
  int yylex();
  int yyerror(char *s);
%}


%union {
int inteiro;
char *id;
}


%token <id> INICIO FIM  VIRAR_DIREITA VIRAR_ESQUERDA _PINCA INICIO_PINCA FIM_PINCA INICIO_ANDAR FIM_ANDAR INICIO_RODAR FIM_RODAR INICIO_OBJETO FIM_OBJETO VIRGULA
%token <inteiro> _ANDAR _RODAR _OBJETO

%start s

%%

s: INICIO '{' instrucao_obj ',' instrucoes_n '}' FIM
   |INICIO '{' instrucoes '}' FIM;


instrucao_obj: INICIO_OBJETO _OBJETO VIRGULA _OBJETO FIM_OBJETO {x_object = $2;
                                                            y_object = $4;
                                                            
                                                        printf("O objeto esta nas coordenadas: (%d,%d)",x_object,y_object);}; 


instrucoes_n: instrucoes_n ',' instrucoes
            | instrucoes;

instrucoes: VIRAR_DIREITA{ if(dir == "Norte(+yy)")
	   { dir = "Este(+xx)";
		     printf("\nO Compilator virou para a: %s", dir);
		   }
		  else if(dir == "Este(+xx)")
		   { dir = "Sul(-yy)";
		     printf("\nO Compilator virou para a:  %s",dir);
		   }
		  else if(dir == "Sul(-yy)")
		   { dir = "Oeste(-xx)";
		     printf("\nO Compilator virou para a: %s",dir);
    		   }
		  else{
		   dir = "Norte(+yy)";
		   printf("\nO Compilator virou para a:  %s",dir);
		  }
}
	    |VIRAR_ESQUERDA{ if(dir == "Norte(+yy)")
                   { dir = "Oeste(-xx)";
                     printf("\nO Compilator virou para a:  %s", dir);
                   }
                  else if(dir == "Oeste(+xx)")
                   { dir = "Sul(-yy)";
                     printf("\nO Compilator virou para a:  %s",dir);
                   }
                  else if(dir == "Sul(-yy)")
                   { dir = "Este(+xx)";
                     printf("\nO Compilator virou para a: %s",dir);
                   }
                  else{
                   dir = "Norte(+yy)";
                   printf("\nO Compilator virou para a:  %s",dir);
                  }
}	

            | INICIO_ANDAR _ANDAR FIM_ANDAR { andar_n = $2;	
					   if(dir == "Norte(+yy)")
						{
							if((pos_y + andar_n) > 100)
								 printf("\nO Compilator nao consegue chegar a essas coordenadas porque cairía do plano.");
						  	else
							{
								 pos_y = pos_y + andar_n;
								 printf("\nANDAR -> O Compilator andou %d passos para %s", andar_n, dir);
							}
						printf("\nO Compilator encontra-se nas coordenadas:  (%d,%d)",pos_x,pos_y);	
						}
				  		else if(dir == "Sul(-yy)")
								{
						  		  if((pos_y - andar_n) < 1)
                                                                   printf("\nO Compilator nao consegue chegar a essas coordenadas porque cairía do plano.");
                                                                        else
                                                                        {
                                                                         pos_y = pos_y - andar_n;
                                                                         printf("\nO Compilator andou %d metros para %s", andar_n, dir);
                                                                        }
							printf("\nO Compilator encontra-se nas coordenadas: (%d,%d)",pos_x,pos_y);
								}
					  		else if(dir == "Este(+xx)")
								{
						  		  if((pos_x + andar_n) > 100)
                                                                   printf("\nO Compilator nao consegue chegar a essas coordenadas porque cairía do plano.");
                                                                        else
                                                                        {
                                                                         pos_x = pos_x + andar_n;
                                                                         printf("\nO Compilator andou %d metros para %s", andar_n, dir);
                                                                        }
							printf("\nO compilator encontra-se nas coordenadas: (%d,%d)",pos_x,pos_y);
								}
					  		else{
								 if((pos_x - andar_n) < 1)
                                                                   printf("\nO Compilator nao consegue chegar a essas coordenadas porque cairía do plano.");
                                                                        else
                                                                        {
                                                                        pos_x =pos_x - andar_n;
                                                                         printf("\nO Compilator andou %d passos para %s", andar_n, dir);
                                                                        }
							printf("\nO compilator encontra-se nas coordenas: (%d,%d)",pos_x,pos_y);
					      		}	
              if(e_object == "agarrado")
                {
                             
                if(braco == 180)
				{
					x_object=pos_x;
					y_object=pos_y+1;

				}

			   else if(braco == 135)
 				{
					x_object=pos_x+1;
					y_object=pos_y+1;

                }
 			   else if(braco == 90)
				{
                    			x_object=pos_x+1;
					y_object=pos_y;

                }

			   else if(braco == 45)
 				{
                   		        x_object=pos_x+1;
					y_object=pos_y-1;
                }
			   else if(braco == 0)
				{
                		        x_object=pos_x;
					y_object=pos_y-1;
                }

			   else if(braco == 315)
				{
                    			x_object=pos_x-1;
					y_object=pos_y-1;
                }
			   else if(braco == 270)
				{
                    			x_object=pos_x-1;
					y_object=pos_y;
                }
			   else
				{
                    			x_object=pos_x-1;
					y_object=pos_y+1;
                }
			    printf("O objeto encontra-se nas coordenadas: (%d,%d)", x_object, y_object);
                }
                }
					  
						
            | INICIO_RODAR _RODAR FIM_RODAR {
							 if( $2 == 360 || $2 == -360)
								{
								printf("O Braço do compilator continuou na mesma posição:\n %dº\n", braco);
								}
							  else
								{
								 	if((braco + $2) <= 0)
									{
										braco += $2 + 360;
										printf("\no compilator rodou o braço para: %dº\n", braco);
									}
									else if((braco + $2) >= 360)
									{
                                                                                braco += $2 - 360;
                                                                                printf("\no compilator rodou o braço para: %dº\n", braco);
                                                                        }
									else
 									{
                                                                                braco = braco + $2;
                                                                                printf("\no compilator rodou o braço para: %dº\n", braco);
                                                                        }

								}
                                if(braco == 0)
                                    {
                                    dir_braco = "Sul";
                                    printf("Obraço do compilator encontra-se na posiçao: %dº, em direçao a: %s\n", braco, dir_braco);
                                    if(e_object == "agarrado"){
                                                                x_object=pos_x;
                                                                y_object=pos_y-1;	
                                                                 printf("\nO objeto encontra-se na posiçao: (%d,%d)\n", x_object, y_object);		 			
                                                    }
                                    }
                                    else if(braco == 45)
                                    {
                                    dir_braco = "Sudeste";
                                    printf("OBraço do compilator encontra-se na posiçao: %dº, em direçao a: %s\n", braco, dir_braco);
                                    if(e_object == "agarrado"){
                                                                x_object=pos_x+1;
                                                                y_object=pos_y-1;	
                                                                 printf("\nO objeto encontra-se na posiçao: (%d,%d)\n", x_object, y_object);		 			
                                                    }
                                    }
                                    else if(braco == 90)
                                    {
                                    dir_braco = "Este";
                                    printf("Obraço do compilator encontra-se na posiçao: %dº,em direçao a: %s\n", braco, dir_braco);
                                    if(e_object == "agarrado"){
                                                                x_object=pos_x+1;
                                                                y_object=pos_y;	
                                                                printf("\nO objeto encontra-se na posiçao: (%d,%d)\n", x_object, y_object);		 			
                                                    }
                                    }
                                    else if(braco == 135)
                                    {
                                    dir_braco = "Nordeste";
                                    printf("OBraço do compilator encontra-se nas posiçao: %dº,em direçao a: %s\n", braco, dir_braco);
                                    if(e_object == "agarrado"){
                                                                x_object=pos_x+1;
                                                                y_object=pos_y+1;	
                                                                 printf("\nO objeto encontra-se nas posicao: (%d,%d)\n", x_object, y_object);		 			
                                                    }
                                    }
                                    else if(braco == 180)
                                    {
                                    dir_braco = "Norte";
                                    printf("OBraço do compilator encontra-se na posiçao: %dº,em direçao a: %s\n", braco, dir_braco);
                                    if(e_object == "agarrado"){
                                                                x_object=pos_x;
                                                                y_object=pos_y+1;	
                                                                  printf("\nO objeto encontra-se na posiçao: (%d,%d)\n", x_object, y_object);		 			
                                                    }
                                    }
                                    else if(braco == 225)
                                    {
                                    dir_braco = "Noroeste";
                                    printf("OBraço do compilator encontra-se na posiçao: %dº,em direcao a: %s\n", braco, dir_braco);
                                    if(e_object == "agarrado"){
                                                                x_object=pos_x-1;
                                                                y_object=pos_y+1;	
                                                                  printf("\nO objeto encontra-se na posicao: (%d,%d)\n", x_object, y_object);			 			
                                                    }
                                    }
                                    else if(braco == 270)
                                    {
                                    dir_braco = "Oeste";
                                    printf("OBraço do compilator encontra-se na posiçao: %dº,em direcao a: %s\n", braco, dir_braco);
                                    if(e_object == "agarrado"){
                                                                x_object=pos_x-1;
                                                                y_object=pos_y;	
                                                                  printf("\nO objeto encontra-se na posicao: (%d,%d)\n", x_object, y_object);			 			
                                                    }
                                    }
                                    else
                                    {
                                    dir_braco = "Sudoeste";
                                    printf("OBraço do compilator encontra-se na posicao: %dº,em direcao a:%s\n", braco, dir_braco);
                                    if(e_object == "agarrado"){
                                                                x_object=pos_x-1;
                                                                y_object=pos_y-1;
                                                                 printf("\nOobjeto encontra-se na posicao: (%d,%d)\n", x_object, y_object);			 			
                                                    }
                                    }
}


            |INICIO_PINCA _PINCA FIM_PINCA { 
                    
				  if(e_pinca=="Fechada")
						{
						   if(strlen($2) == 6)
							{
							 e_pinca = "Aberta";
                             printf("\nA PINCA encontra-se: %s", e_pinca);
                             if(e_object == "agarrado")
                             {
                                e_object = "solto";
                                printf("\nO objeto foi solto nas coordenadas: (%d,%d)",x_object,y_object);
                             }
							}
					   	   else
						{
						printf("\nA PINCA JA SE ENCONTRA: %s ", e_pinca);}
					}
				   else
		  			{
                                          if(strlen($2) == 7)
                                          {
                                             e_pinca = "Fechada";
                                             printf("\nA PINCA encontra-se: %s", e_pinca);
                                             if(x_object == (pos_x+1) && y_object ==pos_y )
                                             {
                                                if(dir_braco == "Este")
                                                {
						   e_object = "agarrado";	
                                                    printf("\nOBJETO AGARRADO");
                                                }
                                             }
                                            else if(x_object ==pos_x && y_object == (pos_y+1) )
                                             {
                                                if(dir_braco == "Norte")
                                                {
                                                    e_object = "agarrado";
                                                    printf("\nOBJETO AGARRADO");
                                                }
                                             }
                                            else if(x_object == (pos_x+1) && y_object == (pos_y+1) )
                                             {
                                                if(dir_braco == "Nordeste")
                                                {
                                                    e_object = "agarrado";
                                                    printf("\nOBJETO AGARRADO");
                                                }
                                             }
                                            else if(x_object == (pos_x-1) && y_object ==pos_y )
                                             {
                                                if(dir_braco == "Oeste")
                                                {
                                                    e_object = "agarrado";
                                                    printf("\nOBJETO AGARRADO");
                                                }
                                             }
                                            else if(x_object == (pos_x-1) && y_object == (pos_y+1) )
                                             {
                                                if(dir_braco == "Noroeste")
                                                {
                                                    e_object = "agarrado";
                                                    printf("\nOBJETO AGARRADO");
                                                }
                                             }
                                            else if(x_object ==pos_x && y_object == (pos_y-1) )
                                             {
                                                if(dir_braco == "Sul")
                                                {
                                                    e_object = "agarrado";
                                                    printf("\nOBJETO AGARRADO");
                                                }
                                             }
                                            else if(x_object == (pos_x-1) && y_object == (pos_y-1) )
                                             {
                                                if(dir_braco == "Sudoeste")
                                                {
                                                    e_object = "agarrado";
                                                    printf("\nOBJETO AGARRADO");
                                                }
                                             }
                                            else if (x_object == (pos_x+1) && y_object == (pos_y-1) )
                                            {
                                                if(dir_braco == "Sudeste")
                                                {
                                                    e_object = "agarrado";
                                                    printf("\nOBJETO AGARRADO");
                                                }
                                          }
                                           else{
                                            printf("\nNENHUM OBJETO AGARRADO");
                                           }

                                          
                                        }
                                        else    
                                        {
                                              printf("\nA PINCA JA SE ENCONTRA: %s", e_pinca);}}



				};
            
            



%%

int main(){
 yyparse();

 printf("\n ----------Posição Final---------- \n");
 printf("Direcao: %s\n",dir);
 printf("Posicao do compilator: (%d,%d)\n",pos_x,pos_y);
 printf("Estado da Pinca: %s\n", e_pinca);
 printf("o Objeto encontra-se nas coordenadas: (%d,%d)\n ", x_object, y_object );
}




int yyerror(char * s){
    printf("erro sintatico/semantico: %s\n",s);
    fprintf (stderr, "%s\n", s);
}
