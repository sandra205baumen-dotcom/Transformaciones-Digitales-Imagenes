function imgGris = transformarGrisManual(imgRGB, pesos)
% TRANSFORMAR GRIS MANUAL: Convierte una imagen f(x,y,c) a g(x,y)
% Implementación basada en la combinación lineal de canales cromáticos.
%
% ENTRADAS:
%   imgRGB: Matriz de M x N x 3 (uint8)
%   pesos:  Vector [wR, wG, wB] que define la importancia de cada canal.
%           Sujeto a la restricción: wR + wG + wB = 1.

    % 1. Validación de parámetros
    % Si el usuario no define pesos, aplicamos el estándar ITU-R BT.601
    if nargin < 2
        pesos = [0.2989, 0.5870, 0.1140]; 
    end
    
    % 2. Descomposición del modelo de color (Mapping)
    % Se extraen las componentes fR, fG, fB y se convierten a 'double'.
    % IMPORTANTE: Se usa double para evitar errores de cuantización y 
    % saturación (overflow) durante la sumatoria de intensidades.
    R = double(imgRGB(:,:,1)); 
    G = double(imgRGB(:,:,2));
    B = double(imgRGB(:,:,3));
    
    % 3. Transformación lineal de intensidad
    % Aplicamos la ecuación: g(x,y) = wR*R(x,y) + wG*G(x,y) + wB*B(x,y)
    % Esta operación reduce la dimensionalidad del dato de 3D a 1D.
    imgGrisDouble = (pesos(1) * R) + (pesos(2) * G) + (pesos(3) * B);
    
    % 4. Re-cuantización y normalización
    % Convertimos el resultado de punto flotante a entero de 8 bits (uint8).
    % Esto devuelve la función al rango discreto [0, 255].
    imgGris = uint8(imgGrisDouble);
end