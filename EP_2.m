x = 0;
y = 0;

#{
Funções RGB, chico! Essas são as sugeridas inicialmente pelo professor!
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
Bilinear!
#}

function result = p_1(a, x, y)
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
function result = p_2(a, x, y)
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

function result = bicubic(decompressed_RGB, k, h)
    i = 1;
    while(i <= rows(decompressed_RGB) - k + 1)
      j = 1;
      while(j <= columns(descompressed_RGB) - k + 1)
        
        x_2 = i + k + 1;
        y_2 = j;
        x_1 = i;
        y_1 = j + k + 1;
        
        x_1_r = (x_1 - 1)*h;
        x_2_r = (x_2 - 1)*h;
        y_1_r = (y_1 - 1)*h;
        y_2_r = (y_2 - 1)*h;
        
        
                     
        if (i == 1)
        matriz_fs_R = [decompressed_RGB(x_1, y_1, 1), decompressed_RGB(x_1, y_2, 1), f_y(decompressed_RGB(x_1, y_2, 1), y_1), f_y(x_1, y_2);...
                     decompressed_RGB(x_2, y_1, 1), decompressed_RGB(x_2, y_2, 1), f_y(x_2, y_1), f_y(x_2, y_2);...
                     f_x(x_1, y_1), f_x(x_1, y_2), f_y_x(x_1, y_1), f_y_x(x_1, y_2);...
                     f_x(x_2, y_1), f_x(x_2, y_2), f_y_x(x_2, y_1), f_y_x(x_2, y_2)];
             
        B = [1, 0, 0, 0;...
             0, 0, 1, 0;...
            -3, 3, -2, -1;...
             2, -2, 1, 1];
        
        
        j += 1;
      endwhile
      i += 1;
    endwhile
    
endfunction
#}
#{
Função que gera imagem! ela pega uma matriz de 3 dimensões - uma pra R, uma
pra G e uma pra B e calcula o valor das respectivas funções em tam*tam pon-
tos. Esses pontos começam em (1, 1) e vão até (1 + tam*h, 1 + tam*h). No
caso que eu deixei por padrão, tam = 500 e h = 0.001, portanto checamos
500*500 pontos d'um quadrado de digonais inferior esquerda (1, 1) e superi-
or direita (1.5, 1.5). Desculpe a bagunça no código da matriz, mas temos
que indexar dessa forma pra funcionar baseado no canto direito superior que
eu tinha feito no teste bilinear. Posso te explicar como funciona depois,
mas pode confiar que isso tá funfando! Essa função cria uma imagem
"imagem_RGB.tif" baseado nessa matriz. Checa a imagem no seu diretório! Cê
vai ficar orgulhoso :)

OBS: testes com tam >> 500 deixam o programa BEM lento. Take care ;)
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

#{
Função de compressão de imagem! Ainda tô fazendo, querido! Esse primeiro
pedaço é apenas eu pegando a imagem "imagem_RGB.tif" salva em meu computa-
dor e lendo ela novamente. Os comentários no meio da função eram testes
pra ver se estava funcionando direitnho e se a matriz RGB recuperada da
imagem era 500x500 também. Funcionou perfeitamente e a matriz é 500x500
mesmo! Yuhuuul! O resto é tudo baseado na técnica de compressão que o pro-
fessor sugeriu no enunciado do EP.
#}

function result = compress(originalImg, k)
  
  [matriz, MAP] = imread(originalImg);
  [X, map] = rgb2ind(matriz);
  matriz_RGB = ind2rgb(X, map);
  
  #{
  display(rows(matriz_RGB));
  display(columns(matriz_RGB));
  #}
  #{
  imwrite(matriz_RGB, "imagem_RGB_2.tif");
  #}
  
  p = rows(matriz_RGB);
  n = floor((p + k)/(1 + k));
  
  #{
  display(p);
  display(n);
  #}
  
  compressed_RGB = zeros(n, n, 3);
  i = 1;
  j = 1;
  i_n = 1;
  j_n = 1;
  while(i <= p)
    if(abs(rem(i,k+1))*sign(k) == 0)
      while(j <= p)
        if(abs(rem(j,k+1))*sign(k) == 0)
          compressed_RGB(i_n, j_n, 1) = matriz_RGB(i, j, 1);
          compressed_RGB(i_n, j_n, 2) = matriz_RGB(i, j, 2);
          compressed_RGB(i_n, j_n, 3) = matriz_RGB(i, j, 3);
          j_n = j_n + 1;
        endif
        j = j + 1;
      endwhile
      j_n = 1;
      i_n = i_n + 1;
    endif
    j = 1;
    i = i + 1;
  endwhile
  
  #{
  display(rows(compressed_RGB));
  #}
  
  imwrite(compressed_RGB, "compressed_RGB.png");
  
  result = "compressed_RGB.png";
  return;
  
endfunction

function result = decompress(compressedImg, method, k, h)
  
  [matriz, MAP] = imread(compressedImg);
  [X, map] = rgb2ind(matriz);
  matriz_RGB = ind2rgb(X, map);
  
  n = rows(matriz_RGB);
  p = n + (n - 1)*k;
  
  #{
  display(n)
  display(p);
  #}
  
  decompressed_RGB = zeros(p, p, 3);
  i = 1;
  j = 1;
  i_p = 1;
  j_p = 1;
  while(i <= n)
    aux_i = i_p;
    while(i_p <= aux_i + k)
      if(i_p == aux_i)
        while(j <= n)
          aux_j = j_p;
          while(j_p <= aux_j + k)
            if(j_p == aux_j)
              decompressed_RGB(i_p, j_p, 1) = matriz_RGB(i, j, 1);
              decompressed_RGB(i_p, j_p, 2) = matriz_RGB(i, j, 2);
              decompressed_RGB(i_p, j_p, 3) = matriz_RGB(i, j, 3);
            endif
            j_p = j_p + 1;
          endwhile
          j = j + 1;
        endwhile
      endif
      j_p = 1;
      i_p = i_p + 1;
    endwhile
    j = 1;
    i = i + 1;
  endwhile
  
  #{
  display(rows(decompressed_RGB));
  #}
  
  if(method == 1)
    decompressed_RGB = bilinear(decompressed_RGB, k, h);
  endif
  
  #{
  if(method == 2)
    decompressed_RGB = bicubic(decompressed_RGB, k, h);
  endif
  #}
  
  imwrite(decompressed_RGB, "decompressed_RGB.png");
  
  result = "decompressed_RGB.png";
  return;
  
endfunction

tam = 500;
k = 2;
h = 0.001;

imagem_RGB = generate_image(tam);
compressed_RGB = compress(imagem_RGB, k);
decompressed_RGB_1 = decompress(compressed_RGB, 1, k, h);
#{
decompressed_RGB_2 = decompress(compressed_RGB, 2, k, h);
#}
