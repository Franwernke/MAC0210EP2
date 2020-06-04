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
  
  imwrite(matriz_RGB, "imagem_RGB.tif");
  
  result = "imagem_RGB.tif";
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

function compress(originalImg, k)
  
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
  n = (p - k)/(1 + k);
  display(n);
  
  compressed_RGB = zeros(n, n, 3);
  i = 1;
  j = 1;
  i_n = 1;
  j_n = 1;
  while(i <= p)
    if(abs(rem(i,k))*sign(k) == 0)
      while(j <= p)
        if(abs(rem(j,k))*sign(k) == 0)
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
  
  imwrite(compressed_RGB, "compressed_RGB.tif");
  
endfunction

tam = 500;

imagem_RGB = generate_image(tam);
compress(imagem_RGB, 2);