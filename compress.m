#{
  Função de compressão de imagem. A partir de uma matriz de tamanho 
TAM (<= tam) por TAM distribui os pontos com informação igualmente 
entre intervalos de k pontos pretos.
#}

function result = compress(originalImg, k)
  
  [matriz, MAP] = imread(originalImg);
  [X, map] = rgb2ind(matriz);
  matriz_RGB = ind2rgb(X, map);
  
  p = rows(matriz_RGB);
  
  n = floor((p + k)/(1 + k));
  
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
  
  imwrite(compressed_RGB, "compressed_RGB.png");
  
  result = "compressed_RGB.png";
  return;
  
endfunction