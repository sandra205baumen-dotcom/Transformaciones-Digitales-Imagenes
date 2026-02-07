function imgOut = volteadoManual(imgIn, modo)
% VOLTEADOMANUAL: Implementación de reflexión mediante mapeo de índices.
% Las transformaciones geométricas de reflexión se basan en la inversión 
% del orden de los elementos en una dimensión específica de la matriz f(x,y).
% No se altera el valor del píxel (brillo), solo su ubicación espacial.
%
% ENTRADAS:
%   imgIn: Matriz de imagen (M x N) en escala de grises.
%   modo:  Entero que define el eje de reflexión.

    % Se obtiene el tamaño de la imagen para los límites del mapeo
    [alto, ancho, ~] = size(imgIn);

    switch modo
        case 1 % REFLEXIÓN HORIZONTAL (Eje Vertical)
            % Fundamento: f(x, y) -> f(x, W - y + 1)
            % Se recorren todas las filas y se invierte el orden de las columnas.
            imgOut = imgIn(:, ancho:-1:1, :);
            
        case 2 % REFLEXIÓN VERTICAL (Eje Horizontal)
            % Fundamento: f(x, y) -> f(H - x + 1, y)
            % Se invierte el orden de las filas mientras las columnas permanecen fijas.
            imgOut = imgIn(alto:-1:1, :, :);
            
        case 3 % REFLEXIÓN EN AMBOS EJES (Rotación de 180°)
            % Fundamento: f(x, y) -> f(H - x + 1, W - y + 1)
            % Es una transformación compuesta que invierte ambas dimensiones.
            imgOut = imgIn(alto:-1:1, ancho:-1:1, :);
    end
end