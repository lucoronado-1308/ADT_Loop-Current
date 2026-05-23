clear all;
close all;
clc;
format short g

% Ruta al directorio donde se encuentran los archivos .nc
path (path,'/Volumes/LLACA/Posdoc_matlab/ADT/');
% Buscar todos los archivos .mat de ADT mensuales
mat_files = dir('ADT*.mat');

% Definir los límites geográficos del Golfo de México
lat_min = 16;
lat_max = 30;
lon_min = -97.5;
lon_max = -75;

% Inicializar variables para almacenar los datos del Golfo de México
all_latitude_gulf_mexico = [];
all_longitude_gulf_mexico = [];
all_adt_gulf_mexico = [];
all_month = [];
all_year = [];

% Recorrer todos los archivos .mat
for i = 1:numel(mat_files)
    % Cargar el archivo .mat actual
    current_mat = load(mat_files(i).name);
    
    % Obtener los datos del archivo .mat actual
    adt_adj = current_mat.adt_adj;
    latitude = current_mat.latitude;
    longitude = current_mat.longitude;
    month = current_mat.month;
    year = current_mat.year;
    
    % Crear una máscara lógica para seleccionar las filas y columnas dentro del rango del Golfo de México
    lat_mask = latitude >= lat_min & latitude <= lat_max;
    lon_mask = longitude >= lon_min & longitude <= lon_max;
    
    % Aplicar la máscara lógica para filtrar los datos de ADT, latitud y longitud
    adt_gulf_mexico = adt_adj(lat_mask, lon_mask);
    latitude_gulf_mexico = latitude(lat_mask);
    longitude_gulf_mexico = longitude(lon_mask);
    
    % Concatenar los datos del Golfo de México
    all_latitude_gulf_mexico = [all_latitude_gulf_mexico; latitude_gulf_mexico];
    all_longitude_gulf_mexico = [all_longitude_gulf_mexico; longitude_gulf_mexico];
    all_adt_gulf_mexico = [all_adt_gulf_mexico; adt_gulf_mexico(:)];
    all_month = [all_month; repmat(month, numel(adt_gulf_mexico), 1)];
    all_year = [all_year; repmat(year, numel(adt_gulf_mexico), 1)];
end

% Crear una tabla con los datos del Golfo de México
data_gulf_mexico = table(all_latitude_gulf_mexico, all_longitude_gulf_mexico, all_month, all_year, all_adt_gulf_mexico, ...
    'VariableNames', {'Latitud', 'Longitud', 'Mes', 'Year', 'ADT'});

% Guardar la tabla en un archivo CSV
writetable(data_gulf_mexico, 'ADT_gulf_mexico.csv');
disp('Datos del Golfo de México guardados en: ADT_gulf_mexico.csv');