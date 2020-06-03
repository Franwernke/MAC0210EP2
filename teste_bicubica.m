x = 0;
y = 0;

function result = f(x, y)
  result = sin(x)*cos(y);
  return;
endfunction

function result = f_x(x, y)
  #{
  result = (f(x+0.1, y) - f(x-0.1, y))/0.2;
  #}
  result = cos(x)*cos(y);
  return;
endfunction

function result = f_y(x, y)
  #{
  result = (f(x, y+0.1) - f(x, y-0.1))/0.2;
  #}
  result = sin(x)*(-sin(y));
  return;
endfunction

function result = f_y_x(x, y)
  #{
  result = (f_y(x+0.1, y) - f_y(x-0.1, y))/0.2;
  #}
  result = cos(x)*(-sin(y));
  return;
endfunction

function result = p(a, x, y)
  result = 0;
  i = 1;
  j = 1;
  while(i <= 4)
    while(j <= 4)
      result = result + a(i, j)*(x^(i-1))*(y^(j-1));
      j = j + 1;
    endwhile
    j = 1;
    i = i + 1;
  endwhile
  return;
endfunction

x = input("Digite a coordenada x: \n");
y = input("Digite a coordenada y: \n");

i = 0;
while(i - x < 0)
  i = i + 1;
endwhile
x_2 = i;
x_1 = i - 0.1;

i = 0;
while(i - y < 0)
  i = i + 1;
endwhile
y_2 = i;
y_1 = i - 0.1;

matriz_fs = [f(x_1, y_1), f(x_1, y_2), f_y(x_1, y_1), f_y(x_1, y_2);...
             f(x_2, y_1), f(x_2, y_2), f_y(x_2, y_1), f_y(x_2, y_2);...
             f_x(x_1, y_1), f_x(x_1, y_2), f_y_x(x_1, y_1), f_y_x(x_1, y_2);...
             f_x(x_2, y_1), f_x(x_2, y_2), f_y_x(x_2, y_1), f_y_x(x_2, y_2)];
             
B = [1, 0, 0, 0;...
     1, 0.00000001, 0.00000001, 0.00000001;...
     0, 1, 0, 0;...
     0, 1, 0.00000002, 0.00000003];

a = inv(B)*matriz_fs*inv(transpose(B));

matriz_f_1 = zeros(200, 200);
matriz_a_1 = zeros(200, 200);

file_id = fopen("arq2", "w");

i = 1;
j = 1;
h = 0.005;
while(i <= 200)
  while(j <= 200)
    matriz_f_1(201-i, j) = f((x_1 + (j-1)*h), (y_1 + (i-1)*h));
    matriz_a_1(201-i, j) = p(a, (x_1 + (j-1)*h), (y_1 + (i-1)*h));
    fprintf(file_id, "%.3f ", matriz_a_1(201-i, j));
    j = j + 1;
  endwhile
  j = 1;
  fprintf(file_id, "\n");
  i = i + 1;
endwhile

fclose(file_id);

imagesc(matriz_f_1);