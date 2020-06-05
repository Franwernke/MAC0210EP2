x = 0;
y = 0;
tam = 100;
#{
  Função que define a imagem: f(x, y)
#}

function result = f(x, y)
  result = sin(x)*cos(y);
endfunction

#{
  Função que avalia o polinômio p(x, y) dados 4 coeficientes no vetor "a"
#} 

function result = p(a, x, y)
  result = a(1,1) + a(2,1)*x + a(3,1)*y + a(4,1)*x*y;
endfunction

for t = (1:4)
    #{
      Recebe o ponto superior direito do quadrado interpolado
    #}

    x = input("Digite a coordenada x: \n");
    y = input("Digite a coordenada y: \n");

    x_2 = max(0, ceil(x - 1));
    x_1 = max(0, ceil(x - 2));

    y_2 = max(0, ceil(y - 1));
    y_1 = max(0, ceil(y - 2));

    #{
    As matrizes a seguir representam os 4 pontos que definem o quadrado e a 
    f(x, y) em cada um dos mesmos
      Queremos achar os coeficientes de p(x, y) = a_1 + a_2*x + a_3*y + a_4*x*y
      então resolvemos o sistema linear M_x_y * a = M_fQ para o vetor a de coef.
    #}

    matrix_x_y = [1, x_1, y_1, x_1*y_1;...
                  1, x_1, y_2, x_1*y_2;...
                  1, x_2, y_1, x_2*y_1;...
                  1, x_2, y_2, x_2*y_2];
                  
    matrix_fQ = [f(x_1, y_1);...
                 f(x_1, y_2);...
                 f(x_2, y_1);...
                 f(x_2, y_2)];

    a = inv(matrix_x_y) * matrix_fQ;

    #{
        Define a matriz-imagem usando a função real f(x, y) e o polinômio
        p(x, y) para compararmos a interpolação e a imagem real
    #}
    
    matriz_f_parcial = zeros(tam, tam);
    matriz_a_parcial = zeros(tam, tam);

    file_id = fopen("arq1", "w");

    #{
        h é o passo entre um ponto e outro que aplicamos a interpolação/função.
    #}
    
    h = 0.01;
    
    #{
        Para cada ponto do Quadrado de tam x tam, 
        fazemos f(x_1 + passo, y_1 + passo) para compor a imagem original, 
        e p(x_1 + passo, y_1 + passo) para compor a imagem interpolada.
    #}
    
    for i = (1:tam)
      for j = (1:tam)
        matriz_f_parcial(tam+1-i, j) = f((x_1 + (j-1)*h), (y_1 + (i-1)*h));
        matriz_a_parcial(tam+1-i, j) = p(a, (x_1 + (j-1)*h), (y_1 + (i-1)*h));
        fprintf(file_id, "%.3f ", matriz_a_parcial(tam+1-i, j));
      endfor
      fprintf(file_id, "\n");
    endfor
    
    #{
        O quadrado então criado é adicionado a imagem maior, sempre da equerda
        superior para a direita inferior
    #}
    
    if t == 1 || t == 2
      matriz_f(1,t) = matriz_f_parcial;
    elseif t == 3 || t == 4
      matriz_f(2,t-2) = matriz_f_parcial;
    endif
    if t == 1 || t == 2
      matriz_a(1,t) = matriz_a_parcial;
    elseif t == 3 || t == 4
      matriz_a(2,t-2) = matriz_a_parcial;
    endif
    
endfor

fclose(file_id);

display(a);

imagesc(matriz_a);