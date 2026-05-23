clear all;
close all;
clc;
format short g

% Ruta al directorio donde se encuentran los archivos .nc
path (path,'/Volumes/LLACA/Posdoc_matlab/ADT/');

% Mostrar información sobre la estructura de los archivos .nc
ncdisp('dt_global_twosat_phy_l4_20221223_vDT2021.nc');

% Inicializar variables para almacenar coordenadas y datos de altitud
latitude = [];
longitude = [];
adt = [];

% Crear una lista de archivos .nc
files = dir('dt_global_allsat_msla_h_y*.nc');

% Inicializar variables para almacenar latitudes y longitudes una vez
latitude = ncread(files(1).name, 'latitude');
longitude = ncread(files(1).name, 'longitude');
num_files = length(files);

% Inicializar la matriz adt con las dimensiones correctas
adt = zeros(1440, 720, num_files);

% Recorrer todos los archivos .nc
for i = 1:num_files
    % Cargar el archivo .nc
    ncfile = files(i).name;
    
    % Extraer la fecha del nombre del archivo
    [~, name, ~] = fileparts(ncfile);
    year = str2double(name(26:29)); % Extraer el año
    month = str2double(name(32:33)); % Extraer el mes
    
    % Leer la variable adt del archivo .nc
    adt(:,:,i) = ncread(ncfile, 'sla'); % Almacenar alturas
end

% Aplicar el factor de escala (si es necesario)
adt = adt * 0.0001;

% Inicializar una celda para almacenar los nombres de los archivos .mat
mat_filenames = cell(1, num_files);

% Guardar los datos ajustados en archivos .mat
for i = 1:num_files
    % Extraer la fecha del nombre del archivo
    [~, name, ~] = fileparts(files(i).name);
    year = str2double(name(26:29)); % Extraer el año
    month = str2double(name(32:33)); % Extraer el mes
    
    % Crear el nombre del archivo MAT de salida
    outfile_mat = sprintf('ADT%04d%02d.mat', year, month);
    
    % Ajustar las dimensiones de adt para que coincidan con las de latitudes y longitudes
    adt_adj = adt(:,:,i);
    
    % Guardar los datos ajustados en el archivo .mat
    save(outfile_mat, 'adt_adj', 'latitude', 'longitude', 'year', 'month');
    
    % Almacenar el nombre del archivo .mat
    mat_filenames{i} = outfile_mat;
end

% Visualizar los nombres de los archivos .mat guardados
disp('Archivos .mat guardados:');
disp(mat_filenames);

% Crear una tabla con los datos ajustados para guardar en un archivo TXT
num_records = numel(latitude) * numel(longitude) * num_files;
lat_col = repmat(latitude, numel(longitude), num_files);
lon_col = repelem(longitude, numel(latitude), num_files);
adt_col = reshape(adt, [], 1);

% Repetir las columnas de Mes y Year según corresponda
year_col = repelem(2002:(2001 + num_files), numel(latitude) * numel(longitude))';
month_col = repmat(1:12, 1, numel(latitude) * numel(longitude) * (num_files / 12))';

% Crear la tabla de datos
data = table(lat_col(:), lon_col(:), month_col(:), year_col(:), adt_col(:), ...
    'VariableNames', {'Latitud', 'Longitud', 'Mes', 'Year', 'ADT'});

% Guardar la tabla en un archivo TXT con delimitador de tabulación
writetable(data, 'ADT_global.txt', 'Delimiter', '\t');
disp('Archivo TXT guardado: ADT_global.txt');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Buscar todos los archivos .mat
mat_files = dir('ADT*.mat');

% Inicializar variables para almacenar los datos combinados
all_latitude = [];
all_longitude = [];
all_adt = [];
all_mat_filenames = {};

% Recorrer todos los archivos .mat
for i = 1:numel(mat_files)
    % Cargar el archivo .mat actual
    current_mat = load(mat_files(i).name);
    
    % Guardar las coordenadas
    all_latitude = [all_latitude; current_mat.latitude];
    all_longitude = [all_longitude; current_mat.longitude];
    
    % Concatenar los datos de adt
    all_adt = cat(3, all_adt, current_mat.adt_adj);
    
    % Guardar el nombre del archivo .mat actual
    all_mat_filenames = [all_mat_filenames; mat_files(i).name];
end

% Guardar todos los datos combinados en un solo archivo .mat
combined_data_filename = 'combined_ADT_data.mat';
save(combined_data_filename, 'all_latitude', 'all_longitude', 'all_adt', 'all_mat_filenames');
disp(['Datos combinados guardados en: ' combined_data_filename]);



%COORDENADAS


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Buscar todos los archivos .mat
mat_files = dir('ADT*.mat');

% Inicializar variables para almacenar las coordenadas combinadas
all_latitude = [];
all_longitude = [];

% Recorrer todos los archivos .mat
for i = 1:numel(mat_files)
    % Cargar el archivo .mat actual
    current_mat = load(mat_files(i).name);
    
    % Guardar las coordenadas
    all_latitude = [all_latitude; current_mat.latitude];
    all_longitude = [all_longitude; current_mat.longitude];
end

% Guardar las coordenadas en un archivo .mat
coordinates_filename = 'coordenadasADT.mat';
save(coordinates_filename, 'all_latitude', 'all_longitude');
disp(['Coordenadas guardadas en: ' coordinates_filename]);
