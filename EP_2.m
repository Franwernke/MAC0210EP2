x = 0;
y = 0;

#{
Funções RGB inicialmente sugeridas pelo professor.
#}

function result = R(x, y)
  result = sin(x);
  return;
endfunction

function result = G(x, y)
  result = (sin(y) + sin(x))/2;
  return;
endfunction

function result = B(x, y)
  result = sin(x);
  return;
endfunction

#{
Interpolação Bilinear
#}

function result = p_1(a, x, y)
  # Polinômio interpolador com o vetor de coeficientes a
  result = a(1,1) + a(2,1)*x + a(3,1)*y + a(4,1)*x*y;
  return;
endfunction

function result = bilinear(decompressed_RGB, k, h)
  i = 1;
  j = 1;
  while(i <= rows(decompressed_RGB) - k - 1)
    while(j <= columns(decompressed_RGB) - k - 1)
      
      x_2 = i + k + 1;
      y_2 = j;
      x_1 = i;
      y_1 = j + k + 1;
      
      x_1_r = (x_1 - 1)*h;
      x_2_r = (x_2 - 1)*h;
      y_1_r = (y_1 - 1)*h;
      y_2_r = (y_2 - 1)*h;
      
      matrix_x_y = [1, x_1_r, y_1_r, x_1_r*y_1_r;...
                    1, x_1_r, y_2_r, x_1_r*y_2_r;...
                    1, x_2_r, y_1_r, x_2_r*y_1_r;...
                    1, x_2_r, y_2_r, x_2_r*y_2_r];
        
      matrix_fQ_R = [decompressed_RGB(x_1, y_1, 1);...
                     decompressed_RGB(x_1, y_2, 1);...
                     decompressed_RGB(x_2, y_1, 1);...
                     decompressed_RGB(x_2, y_2, 1)];

      matrix_fQ_G = [decompressed_RGB(x_1, y_1, 2);...
                     decompressed_RGB(x_1, y_2, 2);...
                     decompressed_RGB(x_2, y_1, 2);...
                     decompressed_RGB(x_2, y_2, 2)];

      matrix_fQ_B = [decompressed_RGB(x_1, y_1, 3);...
                     decompressed_RGB(x_1, y_2, 3);...
                     decompressed_RGB(x_2, y_1, 3);...
                     decompressed_RGB(x_2, y_2, 3)];

      a_R = inv(matrix_x_y) * matrix_fQ_R;
      a_G = inv(matrix_x_y) * matrix_fQ_G;
      a_B = inv(matrix_x_y) * matrix_fQ_B;
      
      z = i;
      w = j;
      while(z <= i + k + 1)
        while(w <= j + k + 1)
        
          if(decompressed_RGB(z, w, 1) == 0)
            decompressed_RGB(z, w, 1) = p_1(a_R, (z-1)*h, (w-1)*h);
          endif
          
          if(decompressed_RGB(z, w, 2) == 0)
            decompressed_RGB(z, w, 2) = p_1(a_G, (z-1)*h, (w-1)*h);
          endif
          
          if(decompressed_RGB(z, w, 3) == 0)
            decompressed_RGB(z, w, 3) = p_1(a_B, (z-1)*h, (w-1)*h);
          endif
          
          w = w + 1;
        endwhile
        w = j;
        z = z + 1;
      endwhile
      
      j = j + k + 1;
    endwhile
    j = 1;
    i = i + k + 1;
  endwhile
  
  result = decompressed_RGB;
  return;
  
endfunction

#{
Interpolação Bicubica
#}

function result = p_2(a, x, y)
  # Polinômio interpolador com a matriz de coeficientes a
  result = 0;
  i = 1;
  while(i <= 4)
    j = 1;
    while(j <= 4)
      result = result + a(i, j)*(x^(i-1))*(y^(j-1));
      j = j + 1;
    endwhile
    i = i + 1;
  endwhile
  return;
endfunction

function r1 = f_y(x, y, img, h, k)
  #{
    Derivada parcial de em relação a y (usando forward, backward ou central 
  dependendo da situação)
  #}
  if (y == 1)
    r1 = (img(x,y+1+k) - img(x,y))/(h);
  elseif (y == columns(img)) 
    r1 = (img(x,y) - img(x,y-1-k))/(h);
  else
    r1 = (img(x,y+1+k) - img(x,y-1-k))/(2*h);
  endif
  return; 
endfunction;

function r2 = f_x(x, y, img, h, k)
  #{
    Derivada parcial de em relação a x (usando forward, backward ou central 
  dependendo da situação)
  #}
  if (x == 1)
    r2 = (img(x+1+k,y) - img(x,y))/(h);
  elseif (x == rows(img))
    r2 = (img(x,y) - img(x-1-k,y))/(h);
  else
    r2 = (img(x+1+k,y) - img(x-1-k,y))/(2*h);
  endif
  return;  
endfunction;

function r3 = f_y_x(x, y, img, h, k)
  #{
    Derivada parcial de em relação a x e y
  #}
  if(x == 1)
    r3 = (f_y(x+1+k, y, img, h, k) - f_y(x, y, img, h, k))/h;
  elseif (x == rows(img))
    r3 = (f_y(x, y, img, h, k) - f_y(x-1-k, y, img, h, k))/h;
  else
    r3 = (f_y(x+1+k, y, img, h, k) - f_y(x-1-k, y, img, h, k))/(2*h);
  endif
  return;
endfunction

function result = bicubic(decompressed_RGB, k, h)
   
    B = [1, 0, 0, 0;...
         1, (k+1)*h, ((k+1)*h)^2, ((k+1)*h)^3;...
         0, 1, 0, 0;...
         0, 1, 2*(k+1)*h, 3*(((k+1)*h)^2)];
    
    #{
    B = [1, 0, 0, 0;...
         1, 1, 1, 1;...
         0, 1, 0, 0;...
         0, 1, 2, 3];
    #}
         
    B_inv = inv(B);
    B_t = transpose(B);
    B_t_inv = inv(B_t);
    
    decompressed_RGB_final = zeros(rows(decompressed_RGB), columns(decompressed_RGB), 3);
    
    i = 1;
    while(i <= rows(decompressed_RGB) - k - 1)
      j = 1;
      while(j <= columns(decompressed_RGB) - k - 1)
        
        x_1 = i + k + 1;
        y_1 = j;
        x_2 = i;
        y_2 = j + k + 1;
        
        # Valor da imagem nos 4 pontos que delimitam o quadrado interpolado
        f_1 = [decompressed_RGB(x_1, y_1, 1), decompressed_RGB(x_1, y_1, 2), decompressed_RGB(x_1, y_1, 3)];
        f_2 = [decompressed_RGB(x_1, y_2, 1), decompressed_RGB(x_1, y_2, 2), decompressed_RGB(x_1, y_2, 3)];
        f_3 = [decompressed_RGB(x_2, y_1, 1), decompressed_RGB(x_2, y_1, 2), decompressed_RGB(x_2, y_1, 3)];
        f_4 = [decompressed_RGB(x_2, y_2, 1), decompressed_RGB(x_2, y_2, 2), decompressed_RGB(x_2, y_2, 3)];
        
        Red_Img = decompressed_RGB(:,:,1);
        Green_Img = decompressed_RGB(:,:,2);
        Blue_Img = decompressed_RGB(:,:,3);
        
        matriz_fs_R = ...
        [f_1(1), f_2(1), f_y(x_1, y_1, Red_Img, h, k), f_y(x_1, y_2, Red_Img, h, k);...
         f_3(1), f_4(1), f_y(x_2, y_1, Red_Img, h, k), f_y(x_2, y_2, Red_Img, h, k);...
         f_x(x_1, y_1, Red_Img, h, k), f_x(x_1, y_2, Red_Img, h, k), f_y_x(x_1, y_1, Red_Img, h, k), f_y_x(x_1, y_2, Red_Img, h, k);...
         f_x(x_2, y_1, Red_Img, h, k), f_x(x_2, y_2, Red_Img, h, k), f_y_x(x_2, y_1, Red_Img, h, k), f_y_x(x_2, y_2, Red_Img, h, k)];
        
        display(matriz_fs_R);
        
        matriz_fs_G = ...
        [f_1(2), f_2(2), f_y(x_1, y_1, Green_Img, h, k), f_y(x_1, y_2, Green_Img, h, k);...
         f_3(2), f_4(2), f_y(x_2, y_1, Green_Img, h, k), f_y(x_2, y_2, Green_Img, h, k);...
         f_x(x_1, y_1, Green_Img, h, k), f_x(x_1, y_2, Green_Img, h, k), f_y_x(x_1, y_1, Green_Img, h, k), f_y_x(x_1, y_2, Green_Img, h, k);...
         f_x(x_2, y_1, Green_Img, h, k), f_x(x_2, y_2, Green_Img, h, k), f_y_x(x_2, y_1, Green_Img, h, k), f_y_x(x_2, y_2, Green_Img, h, k)];
        
        matriz_fs_B = ...
        [f_1(3), f_2(3), f_y(x_1, y_1, Blue_Img, h, k), f_y(x_1, y_2, Blue_Img, h, k);...
         f_3(3), f_4(3), f_y(x_2, y_1, Blue_Img, h, k), f_y(x_2, y_2, Blue_Img, h, k);...
         f_x(x_1, y_1, Blue_Img, h, k), f_x(x_1, y_2, Blue_Img, h, k), f_y_x(x_1, y_1, Blue_Img, h, k), f_y_x(x_1, y_2, Blue_Img, h, k);...
         f_x(x_2, y_1, Blue_Img, h, k), f_x(x_2, y_2, Blue_Img, h, k), f_y_x(x_2, y_1, Blue_Img, h, k), f_y_x(x_2, y_2, Blue_Img, h, k)];
        
        
        a_R = B_inv*matriz_fs_R*B_t_inv;
        a_G = B_inv*matriz_fs_G*B_t_inv;
        a_B = B_inv*matriz_fs_B*B_t_inv;
        
        z = i;
        while(z <= i + k + 1)
          w = j;
          while(w <= j + k + 1)
            if(decompressed_RGB(z, w, 1) == 0)
              decompressed_RGB_final(z, w, 1) = p_2(a_R, (z-1)*h, (w-1)*h);
            else
              decompressed_RGB_final(z, w, 1) = decompressed_RGB(z, w, 1);
            endif
          
            if(decompressed_RGB(z, w, 2) == 0)
              decompressed_RGB_final(z, w, 2) = p_2(a_G, (z-1)*h, (w-1)*h);
            else
              decompressed_RGB_final(z, w, 2) = decompressed_RGB(z, w, 2);
            endif
          
            if(decompressed_RGB(z, w, 3) == 0)
              decompressed_RGB_final(z, w, 3) = p_2(a_B, (z-1)*h, (w-1)*h);
            else
              decompressed_RGB_final(z, w, 3) = decompressed_RGB(z, w, 3);
            endif
          
            w = w + 1;
          endwhile
          z += 1;
        endwhile
        
        j = j + k + 1;
      endwhile
      
      i = i + k + 1;
    endwhile
    
    result = decompressed_RGB_final;
    return;
    
endfunction

#{
 Função que gera imagem. Ela pega uma matriz de 3 dimensões - uma pra R, uma
pra G e uma pra B e calcula o valor das respectivas funções em tam*tam pon-
tos. Esses pontos começam em (1, 1) e vão até (1 + tam*h, 1 + tam*h). 
Por padrão, tam = 500 e h = 0.001, portanto checamos 500*500 pontos de um 
quadrado de diagonais inferior esquerda (1, 1) e superior direita (1.5, 1.5).
 Essa função cria uma imagem "imagem_RGB.tif" baseado nessa matriz. 
#}

function result = generate_image(tam)
  matriz_RGB = zeros(tam, tam, 3);
  x = 0;
  y = 0;
  h = 0.001;
  
  i = 1;
  j = 1;
  while(i <= tam)
    while(j <= tam)
      matriz_RGB((tam + 1) - i, j, 1) = R(x + (j-1)*h, y + (i-1)*h);
      matriz_RGB((tam + 1) - i, j, 2) = G(x + (j-1)*h, y + (i-1)*h);
      matriz_RGB((tam + 1) - i, j, 3) = B(x + (j-1)*h, y + (i-1)*h);
      j = j + 1;
    endwhile
    j = 1;
    i = i + 1;
  endwhile
  
  imwrite(matriz_RGB, "imagem_RGB.png");
  
  result = "imagem_RGB.png";
  return;
  
endfunction

tam = 500;
k = 2;
h = 0.001;

imagem_RGB = generate_image(tam);
compressed_RGB = compress(imagem_RGB, k);
#{
decompressed_RGB_1 = decompress(compressed_RGB, 1, k, h);
error1 = calculateError(imagem_RGB, decompressed_RGB_1);
#}
decompressed_RGB_2 = decompress(compressed_RGB, 2, k, h);
#{
error2 = calculateError(imagem_RGB, decompressed_RGB_2);
#}

#disp(error2);
