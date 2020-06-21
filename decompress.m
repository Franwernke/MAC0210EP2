function result = decompress(compressedImg, method, k, h)
  
  [matriz, MAP] = imread(compressedImg);
  [X, map] = rgb2ind(matriz);
  matriz_RGB = ind2rgb(X, map);
  
  n = rows(matriz_RGB);

  p = n + (n - 1)*k;
  
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
  
  if(method == 1)
    decompressed_RGB = bilinear(decompressed_RGB, k, h);
    imwrite(decompressed_RGB, "decompressed_RGB.png");
    result = "decompressed_RGB.png";
  endif
  
  
  if(method == 2)
    decompressed_RGB = bicubic(decompressed_RGB, k, h);
    imwrite(decompressed_RGB, "decompressed_RGB_2.png");
    result = "decompressed_RGB_2.png";
  endif
  
  return;
  
endfunction
