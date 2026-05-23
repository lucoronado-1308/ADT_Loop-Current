clear all;
close all;
clc;
format short g

% Ruta al directorio donde se encuentran los archivos .nc
path (path,'/Volumes/LLACA/Posdoc_matlab/ADT/');


% Mostrar información sobre la estructura de los archivos .nc
ncdisp('dt_global_allsat_msla_h_y2002_m01.nc');

% Inicializar variables para almacenar coordenadas y datos de altitud
latitude = [];
longitude = [];
adt = [];

% Crear una lista de archivos .nc
files = dir('dt_global_allsat_msla_h_y*.nc');

% Inicializar una tabla vacía para almacenar los datos
data = table();

% Recorrer todos los archivos .nc
for i = 1:length(files)
    % Cargar el archivo .nc
    ncfile = files(i).name;
    
    % Extraer la fecha del nombre del archivo
    [~, name, ~] = fileparts(ncfile);
    year = str2double(name(26:29)); % Extraer el año
    month = str2double(name(32:33)); % Extraer el mes
    
    % Leer las variables del archivo .nc
    latitudes = ncread(ncfile, 'latitude');
    longitudes = ncread(ncfile, 'longitude');
    adt(:,:,i) = ncread(ncfile, 'sla'); % Almacenar altitudes
    
    % Almacenar las coordenadas si es la primera iteración
    if i == 1
        latitude = latitudes;
        longitude = longitudes;
    end
end

% Aplicar el factor de escala (si es necesario)
adt = adt * 0.0001;

% Ajustar las dimensiones de latitudes y longitudes
[lon_grid, lat_grid] = meshgrid(longitude, latitude);

% Inicializar una celda para almacenar los nombres de los archivos .mat
mat_filenames = cell(1, length(files));

% Guardar los datos ajustados en archivos .mat
for i = 1:length(files)
    % Extraer la fecha del nombre del archivo
    [~, name, ~] = fileparts(files(i).name);
    year = str2double(name(26:29)); % Extraer el año
    month = str2double(name(32:33)); % Extraer el mes
    
    % Crear el nombre del archivo MAT de salida
    outfile_mat = sprintf('ADT%04d%02d.mat', year, month);
    
    % Ajustar las dimensiones de adt para que coincidan con las de latitudes y longitudes
    adt_adj = permute(adt(:,:,i), [2, 1, 3]); % Cambiar el orden de las dimensiones
    adt_adj = reshape(adt_adj, [], 1); % Convertir adt a un vector columna
    
    % Guardar los datos ajustados en el archivo .mat
    save(outfile_mat, 'adt_adj', 'latitude', 'longitude', 'year', 'month');
    
    % Almacenar el nombre del archivo .mat
    mat_filenames{i} = outfile_mat;
end

% Visualizar los nombres de los archivos .mat guardados
disp('Archivos .mat guardados:');
disp(mat_filenames);

% Crear una tabla con los datos ajustados para guardar en un archivo CSV
data = table();
data.Latitud = repmat(latitude', numel(longitude), 1);
data.Longitud = repelem(longitude, numel(latitude));
data.Mes = repmat((1:12)', numel(latitude) * numel(longitude), length(files));
data.Year = repelem((2002:2024)', numel(latitude) * numel(longitude) * 12, length(files));
data.ADT = reshape(adt, [], 1);

% Guardar la tabla en un archivo CSV
writetable(data, 'ADT_global.csv');
disp('Archivo CSV guardado: ADT_global.csv');
