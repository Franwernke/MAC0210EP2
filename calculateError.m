function result = calculateError(imagem_RGB, decompressed_RGB)
    
    [matriz, MAP] = imread(decompressed_RGB);
    [X, map] = rgb2ind(matriz);
    decompressed_RGB = ind2rgb(X, map);
    
    [matriz, MAP] = imread(imagem_RGB);
    [X, map] = rgb2ind(matriz);
    imagem_RGB = ind2rgb(X, map);
    
    tamNovoRows = rows(decompressed_RGB);
    tamNovoCols = columns(decompressed_RGB);
    
    matriz_dif_R = imagem_RGB(1:tamNovoRows,1:tamNovoCols,1) - decompressed_RGB(:,:,1);
    matriz_dif_G = imagem_RGB(1:tamNovoRows,1:tamNovoCols,2) - decompressed_RGB(:,:,2);
    matriz_dif_B = imagem_RGB(1:tamNovoRows,1:tamNovoCols,3) - decompressed_RGB(:,:,3);
    
    errR = norm(matriz_dif_R, 2)/norm(imagem_RGB(:,:,1), 2);
    errG = norm(matriz_dif_G, 2)/norm(imagem_RGB(:,:,2), 2);
    errB = norm(matriz_dif_B, 2)/norm(imagem_RGB(:,:,3), 2);
    
    result = (errR + errG + errB)/3;
    return;
endfunction