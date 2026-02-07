function imgOut = rotarBilinealManual(imgIn, angulo)
% ROTARBILINEALMANUAL: Rotación con remuestreo bilineal matricial.
% x: Filas (crece hacia abajo) | y: Columnas (crece a la derecha)
% Basado en la representación f(x,y) de la Dra. Verónica Rodríguez.

    [N, M, C] = size(imgIn); 
    imgIn = double(imgIn);
    imgOut = zeros(N, M, C, 'uint8');
    
    % Centro de rotación (pivote en la matriz N x M)
    cx = (N + 1) / 2; 
    cy = (M + 1) / 2;
    
    % Ángulo a radianes (theta positivo = antihorario)
    theta = deg2rad(angulo);
    cosA = cos(theta); 
    sinA = sin(theta);

    for c = 1:C
        for x = 1:N       
            for y = 1:M   
                % MAPEO INVERSO (Matriz Inversa de Rotación)
                % Se calcula qué punto de la imagen original corresponde al pixel (x,y)
                x_orig = (x - cx) * cosA + (y - cy) * sinA + cx;
                y_orig = -(x - cx) * sinA + (y - cy) * cosA + cy;

                % Verificación de límites dentro de la matriz f(x,y)
                if x_orig >= 1 && x_orig < N && y_orig >= 1 && y_orig < M
                    
                    % Localización de la vecindad inmediata (4-vecinos)
                    x1 = floor(x_orig); x2 = x1 + 1;
                    y1 = floor(y_orig); y2 = y1 + 1;
                    
                    % Distancias fraccionales (pesos dx, dy)
                    dx = x_orig - x1;
                    dy = y_orig - y1;

                    % Matriz de vecindad f(x,y) de 2x2
                    V = [imgIn(x1, y1, c), imgIn(x1, y2, c);
                         imgIn(x2, y1, c), imgIn(x2, y2, c)];
                    
                    % Interpolación Bilineal Matricial: Wx * V * Wy
                    Wx = [1 - dx, dx]; 
                    Wy = [1 - dy; dy];
                    
                    imgOut(x, y, c) = uint8(Wx * V * Wy);
                end
            end
        end
    end
end