x = 0;
y = 0;

function result = f(x, y)
  result = sin(x)*cos(y);
  return;
endfunction

function result = p(a, x, y)
  result = a(1,1) + a(2,1)*x + a(3,1)*y + a(4,1)*x*y;
  return;
endfunction

x = input("Digite a coordenada x: \n");
y = input("Digite a coordenada y: \n");

i = 0;
while(i - x < 0)
  i = i + 1;
endwhile
x_2 = i;
x_1 = i - 1;

i = 0;
while(i - y < 0)
  i = i + 1;
endwhile
y_2 = i;
y_1 = i - 1;

matrix_x_y = [1, x_1, y_1, x_1*y_1;...
              1, x_1, y_2, x_1*y_2;...
              1, x_2, y_1, x_2*y_1;...
              1, x_2, y_2, x_2*y_2];
              
matrix_fQ = [f(x_1, y_1); f(x_1, y_2); f(x_2, y_1); f(x_2, y_2)];

a = inv(matrix_x_y) * matrix_fQ;

matriz_f_1 = zeros(100, 100);
matriz_a_1 = zeros(100, 100);

file_id = fopen("arq1", "w");

i = 1;
j = 1;
h = 0.01;
while(i <= 100)
  while(j <= 100)
    matriz_f_1(101-i, j) = f((x_1 + (j-1)*h), (y_1 + (i-1)*h));
    matriz_a_1(101-i, j) = p(a, (x_1 + (j-1)*h), (y_1 + (i-1)*h));
    fprintf(file_id, "%.3f ", matriz_a_1(101-i, j));
    j = j + 1;
  endwhile
  j = 1;
  fprintf(file_id, "\n");
  i = i + 1;
endwhile

fclose(file_id);

x = input("Digite a coordenada x: \n");
y = input("Digite a coordenada y: \n");

i = 0;
while(i - x < 0)
  i = i + 1;
endwhile
x_2 = i;
x_1 = i - 1;

i = 0;
while(i - y < 0)
  i = i + 1;
endwhile
y_2 = i;
y_1 = i - 1;

matrix_x_y = [1, x_1, y_1, x_1*y_1; 1, x_1, y_2, x_1*y_2; 1, x_2, y_1, x_2*y_1; 1, x_2, y_2, x_2*y_2];
              
matrix_fQ = [f(x_1, y_1); f(x_1, y_2); f(x_2, y_1); f(x_2, y_2)];

a = inv(matrix_x_y) * matrix_fQ;

matriz_f_2 = zeros(100, 100);
matriz_a_2 = zeros(100, 100);

i = 1;
j = 1;
h = 0.01;
while(i <= 100)
  while(j <= 100)
    matriz_f_2(101-i, j) = f((x_1 + (j-1)*h), (y_1 + (i-1)*h));
    matriz_a_2(101-i, j) = p(a, (x_1 + (j-1)*h), (y_1 + (i-1)*h));
    j = j + 1;
  endwhile
  j = 1;
  i = i + 1;
endwhile

x = input("Digite a coordenada x: \n");
y = input("Digite a coordenada y: \n");

i = 0;
while(i - x < 0)
  i = i + 1;
endwhile
x_2 = i;
x_1 = i - 1;

i = 0;
while(i - y < 0)
  i = i + 1;
endwhile
y_2 = i;
y_1 = i - 1;

matrix_x_y = [1, x_1, y_1, x_1*y_1; 1, x_1, y_2, x_1*y_2; 1, x_2, y_1, x_2*y_1; 1, x_2, y_2, x_2*y_2];
              
matrix_fQ = [f(x_1, y_1); f(x_1, y_2); f(x_2, y_1); f(x_2, y_2)];

a = inv(matrix_x_y) * matrix_fQ;

matriz_f_3 = zeros(100, 100);
matriz_a_3 = zeros(100, 100);

i = 1;
j = 1;
h = 0.01;
while(i <= 100)
  while(j <= 100)
    matriz_f_3(101-i, j) = f((x_1 + (j-1)*h), (y_1 + (i-1)*h));
    matriz_a_3(101-i, j) = p(a, (x_1 + (j-1)*h), (y_1 + (i-1)*h));
    j = j + 1;
  endwhile
  j = 1;
  i = i + 1;
endwhile

x = input("Digite a coordenada x: \n");
y = input("Digite a coordenada y: \n");

i = 0;
while(i - x < 0)
  i = i + 1;
endwhile
x_2 = i;
x_1 = i - 1;

i = 0;
while(i - y < 0)
  i = i + 1;
endwhile
y_2 = i;
y_1 = i - 1;

matrix_x_y = [1, x_1, y_1, x_1*y_1; 1, x_1, y_2, x_1*y_2; 1, x_2, y_1, x_2*y_1; 1, x_2, y_2, x_2*y_2];
              
matrix_fQ = [f(x_1, y_1); f(x_1, y_2); f(x_2, y_1); f(x_2, y_2)];

a = inv(matrix_x_y) * matrix_fQ;

matriz_f_4 = zeros(100, 100);
matriz_a_4 = zeros(100, 100);

i = 1;
j = 1;
h = 0.01;
while(i <= 100)
  while(j <= 100)
    matriz_f_4(101-i, j) = f((x_1 + (j-1)*h), (y_1 + (i-1)*h));
    matriz_a_4(101-i, j) = p(a, (x_1 + (j-1)*h), (y_1 + (i-1)*h));
    j = j + 1;
  endwhile
  j = 1;
  i = i + 1;
endwhile

matriz_f = [matriz_f_1, matriz_f_2; matriz_f_3, matriz_f_4];
matriz_a = [matriz_a_1, matriz_a_2; matriz_a_3, matriz_a_4];

display(a);

imagesc(matriz_a);