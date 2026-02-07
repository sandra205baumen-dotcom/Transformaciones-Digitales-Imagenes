%% SCRIPT 2: IMPLEMENTACIÓN PROPIA CON CAMBIO DE PARÁMETROS
% Objetivo: Optimizar la escala de grises para detección de incendios.

rutaIn = 'C:\Users\Sandra Bautista\Downloads\Proyecto Fase I\Transformación a escala de grises\Imagenes';
rutaOut = fullfile(rutaIn, 'Resultados_Manual_Optimizado');
if ~exist(rutaOut, 'dir'), mkdir(rutaOut); end

% --- ANÁLISIS DE PARÁMETROS ---
% En incendios, el canal Rojo (R) contiene la mayor energía radiante.
% Incrementamos wR para maximizar el contraste de las llamas y brasas.
% Parámetro propuesto: 80% Rojo, 10% Verde, 10% Azul.
misPesos = [0.80, 0.10, 0.10]; 

lista = dir(fullfile(rutaIn, '*.jpg'));

fprintf('Iniciando transformación manual optimizada para fuego...\n');

for k = 1:length(lista)
    img = imread(fullfile(rutaIn, lista(k).name));
    
    % Llamada a la implementación propia (transformación paramétrica)
    % Esta función permite el control total sobre el resultado visual.
    imgGris = transformarGrisManual(img, misPesos); 
    
    imwrite(imgGris, fullfile(rutaOut, lista(k).name));
end
fprintf('Completado. Se ha resaltado el canal rojo con w=%.2f\n', misPesos(1));