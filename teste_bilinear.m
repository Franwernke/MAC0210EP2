x = 0;
y = 0;
tam = 100;
#{
  Função que define a imagem (f(x, y))
#}

function result = f(x, y)
  result = sin(x)*cos(y);
endfunction

#{
  Função que avalia o polinomio p(x, y)
#} 

function result = p(a, x, y)
  result = a(1,1) + a(2,1)*x + a(3,1)*y + a(4,1)*x*y;
endfunction

#{
  Recebe o ponto superior direito do quadrado interpolado
#}

x = input("Digite a coordenada x: \n");
y = input("Digite a coordenada y: \n");

x_2 = max(0, x - 1);
x_1 = max(0, x - 2);

y_2 = max(0, y - 1);
y_1 = max(0, y - 2);

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

matriz_f_1 = zeros(tam, tam);
matriz_a_1 = zeros(tam, tam);

file_id = fopen("arq1", "w");

h = 0.01;
for i = (1:tam)
  for j = (1:tam)
    matriz_f_1(tam+1-i, j) = f((x_1 + (j-1)*h), (y_1 + (i-1)*h));
    matriz_a_1(tam+1-i, j) = p(a, (x_1 + (j-1)*h), (y_1 + (i-1)*h));
    fprintf(file_id, "%.3f ", matriz_a_1(tam+1-i, j));
  endfor
  fprintf(file_id, "\n");
endfor  

fclose(file_id);

x = input("Digite a coordenada x: \n");
y = input("Digite a coordenada y: \n");

x_2 = max(0, x - 1);
x_1 = max(0, x - 2);

y_2 = max(0, y - 1);
y_1 = max(0, y - 2);

matrix_x_y = [1, x_1, y_1, x_1*y_1;...
              1, x_1, y_2, x_1*y_2;...
              1, x_2, y_1, x_2*y_1;...
              1, x_2, y_2, x_2*y_2];
              
matrix_fQ = [f(x_1, y_1);...
             f(x_1, y_2);...
             f(x_2, y_1);...
             f(x_2, y_2)];

a = inv(matrix_x_y) * matrix_fQ;

matriz_f_2 = zeros(tam, tam);
matriz_a_2 = zeros(tam, tam);

h = 0.01;
for i = (1:100)
  for j = (1:100)
    matriz_f_2(101-i, j) = f((x_1 + (j-1)*h), (y_1 + (i-1)*h));
    matriz_a_2(101-i, j) = p(a, (x_1 + (j-1)*h), (y_1 + (i-1)*h));
  endfor
endfor

x = input("Digite a coordenada x: \n");
y = input("Digite a coordenada y: \n");

x_2 = max(0, x - 1);
x_1 = max(0, x - 2);

y_2 = max(0, y - 1);
y_1 = max(0, y - 2);

matrix_x_y = [1, x_1, y_1, x_1*y_1;...
              1, x_1, y_2, x_1*y_2;...
              1, x_2, y_1, x_2*y_1;...
              1, x_2, y_2, x_2*y_2];
              
matrix_fQ = [f(x_1, y_1);...
             f(x_1, y_2);...
             f(x_2, y_1);...
             f(x_2, y_2)];

a = inv(matrix_x_y) * matrix_fQ;

matriz_f_3 = zeros(tam, tam);
matriz_a_3 = zeros(tam, tam);

h = 0.01;
for i = (1:tam)
  for j = (1:tam)
    matriz_f_3(tam+1-i, j) = f((x_1 + (j-1)*h), (y_1 + (i-1)*h));
    matriz_a_3(tam+1-i, j) = p(a, (x_1 + (j-1)*h), (y_1 + (i-1)*h));
  endfor
endfor

x = input("Digite a coordenada x: \n");
y = input("Digite a coordenada y: \n");

x_2 = max(0, x - 1);
x_1 = max(0, x - 2);

y_2 = max(0, y - 1);
y_1 = max(0, y - 2);

matrix_x_y = [1, x_1, y_1, x_1*y_1;...
              1, x_1, y_2, x_1*y_2;...
              1, x_2, y_1, x_2*y_1;...
              1, x_2, y_2, x_2*y_2];
              
matrix_fQ = [f(x_1, y_1);...
             f(x_1, y_2);...
             f(x_2, y_1);...
             f(x_2, y_2)];

a = inv(matrix_x_y) * matrix_fQ;

matriz_f_4 = zeros(tam, tam);
matriz_a_4 = zeros(tam, tam);

h = 0.01;
for i = (1:tam)
  for j = (1:tam)
    matriz_f_4(tam+1-i, j) = f((x_1 + (j-1)*h), (y_1 + (i-1)*h));
    matriz_a_4(tam+1-i, j) = p(a, (x_1 + (j-1)*h), (y_1 + (i-1)*h));
  endfor
endfor

matriz_f = [matriz_f_1, matriz_f_2;...
            matriz_f_3, matriz_f_4];
            
matriz_a = [matriz_a_1, matriz_a_2;...
            matriz_a_3, matriz_a_4];

display(a);

imagesc(matriz_a);