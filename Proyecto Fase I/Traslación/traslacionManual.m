function imgOut = traslacionManual(imgIn, tx, ty)
% TRASLACIONMANUAL: Desplazamiento de pixeles f(x,y)
% tx: Desplazamiento en X (Filas / Vertical)
% ty: Desplazamiento en Y (Columnas / Horizontal)
% Basado en: PDI-IMAGENESFUNCIONES.pdf (pág. 34)

    [N, M, C] = size(imgIn); 
    % Creamos un lienzo negro (ceros) del mismo tamaño
    imgOut = zeros(N, M, C, 'uint8'); 

    for c = 1:C
        for x = 1:N       % Recorrido de Filas
            for y = 1:M   % Recorrido de Columnas
                
                % MAPEO INVERSO para traslación:
                % x' = x - tx  |  y' = y - ty
                x_orig = x - tx; 
                y_orig = y - ty;

                % Validamos que el píxel de origen esté dentro del rango 1..N y 1..M
                if x_orig >= 1 && x_orig <= N && y_orig >= 1 && y_orig <= M
                    % Asignamos el valor de intensidad f(x,y)
                    imgOut(x, y, c) = imgIn(x_orig, y_orig, c);
                end
            end
        end
    end
end