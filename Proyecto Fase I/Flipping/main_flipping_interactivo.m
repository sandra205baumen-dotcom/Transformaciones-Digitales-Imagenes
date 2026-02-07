%% PROYECTO PDI - FASE I: FLIPPING 
% Integrantes: 
% - Bautista Méndez Sandra
% - Martínez Santos Fátima Itandehui

clc; 
clear; 
close all;

%% 1. CONFIGURACIÓN DE RUTA ESPECÍFICA
ruta_grises = 'C:\Users\Sandra Bautista\Downloads\Proyecto Fase I\Flipping\ImagenesEscalaDeGrises';

if ~exist(ruta_grises, 'dir')
    fprintf('⚠ Ruta no encontrada. Seleccione manualmente.\n');
    ruta_grises = uigetdir('', 'Seleccione carpeta de imágenes en gris');
    if ruta_grises == 0, return; end
end

archivos = dir(fullfile(ruta_grises, '*.jpg'));

%% 2. BUCLE PRINCIPAL (SELECCIÓN DE IMAGEN)
continuar_programa = true;
while continuar_programa
    clc;
    fprintf('=== MENÚ DE IMÁGENES DISPONIBLES ===\n');
    for i = 1:min(15, length(archivos)), fprintf('%d. %s\n', i, archivos(i).name); end
    fprintf('0. SALIR DEL PROGRAMA\n');
    
    sel = input('\nSeleccione una imagen: ');
    if isempty(sel) || sel == 0, break; end
    
    imgBase = imread(fullfile(ruta_grises, archivos(sel).name));
    
    %% 3. BUCLE DE TRANSFORMACIONES (PERSISTENTE)
    ver_otra_opcion = true;
    while ver_otra_opcion
        clc;
        fprintf('Imagen: %s\n', archivos(sel).name);
        fprintf('--- SELECCIONE TIPO DE VOLTEADO ---\n');
        fprintf('1. Horizontal\n2. Vertical\n3. Ambos\n4. Cambiar Imagen\n0. SALIR \n');
        
        opc = input('Opción: ');
        
        if isempty(opc) || opc == 4, ver_otra_opcion = false; continue; end
        if opc == 0, ver_otra_opcion = false; continuar_programa = false; break; end
        if opc < 1 || opc > 3, continue; end

        % --- LÓGICA DE TÍTULOS DINÁMICOS ---
        switch opc
            case 1, txt_tipo = 'Flipping horizontal';
            case 2, txt_tipo = 'Flipping vertical';
            case 3, txt_tipo = 'Flipping de ambos';
        end

        % --- PROCESAMIENTO COMPARATIVO ---
        % 1. Manual
        res_manual = volteadoManual(imgBase, opc);
        
        % 2. Software (Toolbox)
        if opc == 1, res_tool = fliplr(imgBase);
        elseif opc == 2, res_tool = flipud(imgBase);
        else, res_tool = flip(flip(imgBase,1),2); end
        
        % 3. Matricial (Afín)
        [H, W] = size(imgBase);
        if opc == 1, T = [-1 0 0; 0 1 0; W 0 1];
        elseif opc == 2, T = [1 0 0; 0 -1 0; 0 H 1];
        else, T = [-1 0 0; 0 -1 0; W H 1]; end
        res_mat = imwarp(imgBase, affine2d(T));

        % --- VISUALIZACIÓN CON TÍTULOS DINÁMICOS ---
        fig = figure('Name', ['Análisis: ', txt_tipo], 'Units', 'normalized', 'Position', [0.1 0.3 0.8 0.4]);
        
        subplot(1,4,1); imshow(imgBase); 
        title('1. Original (Gris)');
        
        subplot(1,4,2); imshow(res_manual); 
        title(['2. ', txt_tipo, ' (Manual)']);
        
        subplot(1,4,3); imshow(res_tool); 
        title(['3. ', txt_tipo, ' (Matlab)']);
        
        subplot(1,4,4); imshow(res_mat); 
        title(['4. ', txt_tipo, ' (Matricial)']);

        fprintf('\nVisualizando: %s\nPresione una tecla en la imagen para volver al menú.\n', txt_tipo);
        try
            waitforbuttonpress;
            if isgraphics(fig), close(fig); end
        catch
        end
    end
end
fprintf('\n--- Programa finalizado con éxito ---\n');