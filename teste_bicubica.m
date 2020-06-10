x = 0;
y = 0;

function result = f(x, y)
  result = sin(x)*cos(y);
  return;
endfunction

function result = f_x(x, y, h)
  
  #  result = cos(x)*cos(y);
  
  result = (f(x+h, y) - f(x-h, y))/2*h;
  
  return;
endfunction

function result = f_y(x, y, h)
  
  #  result = sin(x)*(-sin(y));
  
  result = (f(x, y+h) - f(x, y-h))/2*h;
  
  return;
endfunction

function result = f_y_x(x, y, h)
  
  #  result = cos(x)*(-sin(y));
  
  result = (f_y(x+h, y, h) - f_y(x-h, y, h))/2*h;
  
  return;
endfunction


function result = p(a, x, y)
  result = 0;
  i = 1;
  while(i <= 4)
    j = 1;
    while(j <= 4)
      result = result + a(j, i)*(x^(i-1))*(y^(j-1));
      j = j + 1;
    endwhile
    i = i + 1;
  endwhile
  return;
endfunction

x = input("Digite a coordenada x: \n");
y = input("Digite a coordenada y: \n");


x_2 = ceil(x);
x_1 = x_2 - 1;

y_2 = ceil(y);
y_1 = y_2 - 1;

h = 0.005;

matriz_fs = [f(x_1, y_1), f(x_1, y_2), f_y(x_1, y_1, h), f_y(x_1, y_2, h);...
             f(x_2, y_1), f(x_2, y_2), f_y(x_2, y_1, h), f_y(x_2, y_2, h);...
             f_x(x_1, y_1, h), f_x(x_1, y_2, h), f_y_x(x_1, y_1, h), f_y_x(x_1, y_2, h);...
             f_x(x_2, y_1, h), f_x(x_2, y_2, h), f_y_x(x_2, y_1, h), f_y_x(x_2, y_2, h)];
             
B = [1, 0, 0, 0;...
     0, 0, 1, 0;...
     -3, 3, -2, -1;...
     2, -2, 1, 1];

a = B*matriz_fs*transpose(B);

matriz_f_1 = zeros(200, 200);
matriz_a_1 = zeros(200, 200);

#{
  The given matrix 200x200 is going to form an image, by iterating for f(x, y)
  and p(x, y) we have the interpolated matrix and the original one.
  We begin at the bottom left of the image, then go to the right completing the
  row where we stand and every 200 pixels we change the row up.  
#}


i = 1;
while(i <= 200)
  j = 1;
  while(j <= 200)
    matriz_f_1(201-i, j) = f((x_1 + (j-1)*h), (y_1 + (i-1)*h));
    matriz_a_1(201-i, j) = p(a, x_1 + (j-1)*h, (y_1 + (i-1)*h));
    j = j + 1;
  endwhile
  i = i + 1;
endwhile

disp(a);
imagesc(matriz_a_1);