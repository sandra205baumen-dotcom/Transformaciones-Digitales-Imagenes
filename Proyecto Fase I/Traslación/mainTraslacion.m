%% PROYECTO PDI - FASE I: INCISO C (TRASLACIÓN)
% Alumnas: Sandra Bautista y Fátima Martínez
clc; 
clear; 
close all;

% Ruta del dataset de incendios
ruta = 'C:\Users\Sandra Bautista\Downloads\Proyecto Fase I\ImagenesEscalaDeGrises';
archivos = dir(fullfile(ruta, '*.jpg'));

if isempty(archivos), error('No se encontraron imágenes.'); end

continuar_programa = true;
while continuar_programa
    clc;
    fprintf('=== INCISO C: TRASLACIÓN MATRICIAL ===\n');
    for i = 1:min(10, length(archivos)), fprintf('%d. %s\n', i, archivos(i).name); end
    fprintf('0. SALIR\n');
    
    sel = input('\nSeleccione el número de imagen: ');
    if isempty(sel) || sel == 0, break; end
    
    imgOriginal = imread(fullfile(ruta, archivos(sel).name));
    
    ajustando = true;
    while ajustando
        clc;
        fprintf('Imagen activa: %s\n', archivos(sel).name);
        tx = input('Desplazamiento en X (Filas - Entero): ');
        ty = input('Desplazamiento en Y (Columnas - Entero): ');
        
        % Ejecución manual
        imgResultado = traslacionManual(imgOriginal, tx, ty);
        
        % Visualización
        fig = figure('Name', 'Resultado Traslación');
        subplot(1,2,1); imshow(imgOriginal); title('Original');
        subplot(1,2,2); imshow(imgResultado); title(['Traslación: X=', num2str(tx), ' Y=', num2str(ty)]);
        
        fprintf('\nVisualización activa. Presione una tecla en la IMAGEN para continuar.\n');
        
        % SEGURO CONTRA EL ERROR DE WAITFORBUTTONPRESS
        if isgraphics(fig)
            try
                waitforbuttonpress; 
            catch
                % Si la ventana se cierra, el programa no truena
            end
        end
        if isgraphics(fig), close(fig); end
        
        resp = input('¿Desea otro valor en esta imagen? (1:Sí / 0:Cambiar imagen): ');
        if isempty(resp) || resp == 0, ajustando = false; end
    end
end