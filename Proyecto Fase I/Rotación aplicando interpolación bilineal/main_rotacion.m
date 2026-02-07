%% PROYECTO PDI - FASE I: INTERFAZ COMPLETA
% Integrantes: Bautista Méndez Sandra, Martínez Santos Fátima Itandehui
clc; clear; close all;

% Ruta del dataset
ruta = 'C:\Users\Sandra Bautista\Downloads\Proyecto Fase I\ImagenesEscalaDeGrises';
archivos = dir(fullfile(ruta, '*.jpg'));

if isempty(archivos), error('No se hallaron imágenes en la ruta.'); end

programa_activo = true;
while programa_activo
    clc;
    fprintf('====================================================\n');
    fprintf('   SISTEMA INTERACTIVO PDI: CATÁLOGO DE IMÁGENES\n');
    fprintf('====================================================\n');
    for i = 1:min(15, length(archivos))
        fprintf('%2d. %s\n', i, archivos(i).name);
    end
    fprintf(' 0. SALIR\n');
    
    sel = input('\nSeleccione el número de imagen: ');
    
    if isempty(sel) || sel == 0, break; end
    
    % Cargar imagen
    imgOriginal = imread(fullfile(ruta, archivos(sel).name));
    
    ajustando = true;
    while ajustando
        clc;
        fprintf('Trabajando con: %s\n', archivos(sel).name);
        ang = input('Ángulo de rotación (-360 a 360) o 999 para regresar: ');
        
        if isempty(ang) || ang == 999
            ajustando = false;
            continue;
        end
        
        % Procesamiento 
        tic; imgManual = rotarBilinealManual(imgOriginal, ang); t_man = toc;
        tic; imgTool = imrotate(imgOriginal, ang, 'bilinear', 'crop'); t_tool = toc;
        
        % Visualización Triple
        fig = figure('Name', 'Resultados Fase I: Rotación', 'Units', 'normalized', 'Position', [0.05 0.3 0.9 0.4]);
        
        % 1. Imagen Original
        subplot(1,3,1); imshow(imgOriginal); 
        title('1. Imagen Original (Gris)');
        
        % 2. Implementación Manual
        subplot(1,3,2); imshow(imgManual); 
        title({['2. Manual (f(x,y))']; [num2str(t_man, '%.4f'), ' s']});
        
        % 3. Software Comercial
        subplot(1,3,3); imshow(imgTool); 
        title({['3. Software (imrotate)']; [num2str(t_tool, '%.4f'), ' s']});
        
        fprintf('\nVisualización lista. Pulse cualquier tecla EN LA FIGURA para continuar.\n');
        
        % Seguro para evitar error de waitforbuttonpress
        if isgraphics(fig)
            try
                waitforbuttonpress;
            catch
                % El usuario cerró la figura
            end
        end
        
        if isgraphics(fig), close(fig); end
    end
end
fprintf('\nPrograma finalizado con éxito.\n');