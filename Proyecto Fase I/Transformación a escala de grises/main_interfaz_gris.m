%% PROYECTO PDI - FASE I: TRANSFORMACIÓN A ESCALAS DE GRISES
% Integrantes del equipo: 
% - Bautista Méndez Sandra
% - Martínez Santos Fátima Itandehui

clc; 
clear; 
close all;

%% 1. CARGAR DATASET

fprintf('=== CONFIGURACIÓN DE DATASET ===\n');
ruta_carpeta = uigetdir('', 'Seleccione la carpeta con imágenes');
if ruta_carpeta == 0, fprintf('Operación cancelada.\n'); return; end

% Búsqueda de archivos
extensiones = {'*.jpg', '*.jpeg', '*.png', '*.bmp', '*.tif'};
imagenes = {};
for i = 1:length(extensiones)
    archivos = dir(fullfile(ruta_carpeta, extensiones{i}));
    for j = 1:length(archivos)
        imagenes{end+1} = struct('ruta', fullfile(ruta_carpeta, archivos(j).name), ...
                                 'nombre', archivos(j).name);
    end
end

if isempty(imagenes), fprintf('No hay imágenes en la carpeta.\n'); return; end

%% 2. BUCLE PRINCIPAL DE LA INTERFAZ
continuar_programa = true;

while continuar_programa
    clc;
    fprintf('=== MENÚ PRINCIPAL ===\n');
    max_mostrar = min(10, length(imagenes));
    for i = 1:max_mostrar
        fprintf('%d. %s\n', i, imagenes{i}.nombre);
    end
    if length(imagenes) > max_mostrar
        fprintf('... (%d imágenes en total)\n', length(imagenes));
    end
    fprintf('0. SALIR DEL PROGRAMA\n');
    
    seleccion = input(sprintf('\nSeleccione una imagen (1-%d) o 0 para salir: ', length(imagenes)));
    
    if isempty(seleccion) || seleccion < 0 || seleccion > length(imagenes)
        fprintf('Selección inválida. Presione Enter para reintentar.');
        pause; continue;
    end
    
    if seleccion == 0
        continuar_programa = false;
        fprintf('Saliendo del programa... ¡Hasta luego!\n');
        break;
    end

    % Cargar imagen seleccionada
    imgRGB = imread(imagenes{seleccion}.ruta);
    nombre_img = imagenes{seleccion}.nombre;
    
    %% 3. BUCLE DE AJUSTE DE PESOS (Para la misma imagen)
    ver_otra_imagen = false;
    while ~ver_otra_imagen
        clc;
        fprintf('Imagen actual: %s\n', nombre_img);
        fprintf('--- AJUSTE DE PESOS (wR + wG + wB = 1) ---\n');
        
        sumWeights = 0;
        while abs(sumWeights - 1) > 0.0001
            wr = input('  Peso Rojo (R): ');
            wg = input('  Peso Verde (G): ');
            wb = input('  Peso Azul (B): ');
            sumWeights = wr + wg + wb;
            if abs(sumWeights - 1) > 0.0001
                fprintf('Error: La suma es %.2f. Debe ser 1. Reintente.\n', sumWeights);
            end
        end
        misPesos = [wr, wg, wb];

        % Procesamiento
        imgGrisTool = rgb2gray(imgRGB); % Basado en estándar BT.601
        imgGrisManual = transformarGrisManual(imgRGB, misPesos); % Implementación con la función que emplea la fórmula

        % Visualización de la comparativa de grises
        fig = figure('Name', ['Análisis de intensidad: ', nombre_img], 'NumberTitle', 'off', ...
                     'Units', 'normalized', 'Position', [0.1 0.2 0.8 0.5]);
        
        % 1. Imagen original
        subplot(1,3,1); 
        imshow(imgRGB); 
        title(['1. Original RGB'], 'Interpreter', 'none');

        % 2. Herramienta estándar (rgb2gray)
        subplot(1,3,2); 
        imshow(imgGrisTool); 
        title({'2. Herramienta MATLAB (rgb2gray)'; ...
               'Estándar BT.601: [0.2989, 0.5870, 0.1140]'}, 'FontSize', 10);
        
        % 3. Implementación con pesos ajustables
        subplot(1,3,3); 
        imshow(imgGrisManual); 
        title({'3. Implementación Ajustable'; ...
               sprintf('Pesos: [R:%.2f, V:%.2f, A:%.2f]', wr, wg, wb)}, 'FontSize', 10);
        
        % Validación visual de la unidad en la parte inferior
        annotation('textbox', [0.4, 0.02, 0.2, 0.05], 'String', ...
                   sprintf('Suma de pesos: %.2f', (wr + wg + wb)), ...
                   'EdgeColor', 'none', 'HorizontalAlignment', 'center', ...
                   'FontWeight', 'bold', 'Color', [0.2 0.5 0.2]);
        
        % Submenú de navegación
        fprintf('\n¿Qué desea hacer ahora?\n');
        fprintf('1. Probar otros pesos con la MISMA imagen\n');
        fprintf('2. Regresar al menú para elegir OTRA imagen\n');
        fprintf('0. SALIR del programa\n');
        
        opcion = input('Seleccione una opción: ');
        
        if isgraphics(fig), close(fig); end % Cerrar figura antes de seguir
        
        if opcion == 2
            ver_otra_imagen = true;
        elseif opcion == 0
            ver_otra_imagen = true;
            continuar_programa = false;
        elseif opcion ~= 1
            fprintf('Opción no válida, regresando a selección de pesos.\n');
            pause(1);
        end
    end
end
% 4. FIN
fprintf('\n--- Programa finalizado ---\n');
fprintf('Se ha validado la restricción de unidad (sum w_i = 1) para preservar el rango dinámico.\n');
fprintf('La herramienta nativa utiliza una proyección fija optimizada para el ojo humano.\n');
fprintf('La versión manual permite resaltar características espectrales específicas (como el fuego).\n');