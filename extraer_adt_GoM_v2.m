clear all;
close all;
clc;
format short g
path (path,'/Volumes/LLACA/Posdoc_matlab/ADT/');

ncdisp('dt_global_allsat_msla_h_y2002_m01.nc')

% Definir los límites del Golfo de México
lat_min = 16;
lat_max = 30;
lon_min = -97.5;
lon_max = -80;

% Convertir longitud de grados oeste a grados este
lon_min = mod(lon_min, 360);
lon_max = mod(lon_max, 360);

% Inicializar variables para almacenar coordenadas
latitude_gm = [];
longitude_gm = [];
adt_gm = [];

% Crear una lista de archivos .nc
files = dir('dt_global_allsat_msla_h_y*.nc');

for i = 1:length(files)
    % Cargar el archivo .nc
    ncfile = files(i).name;
    
    % Extraer la fecha del nombre del archivo
    [~, name, ~] = fileparts(ncfile);
    year = str2double(name(26:29)); % Extraer el año desde la posición 29 hasta 32
    month = str2double(name(32:33)); % Extraer el mes desde la posición 34 hasta 35
    
    % Leer las variables del archivo .nc
    latitudes = ncread(ncfile, 'latitude');
    longitudes = ncread(ncfile, 'longitude');
    adt = ncread(ncfile, 'sla'); % No aplicar el factor de escala aquí
    
    % Encontrar los índices de las latitudes y longitudes dentro del rango deseado
    lat_idx = find(latitudes >= lat_min & latitudes <= lat_max);
    lon_idx = find(longitudes >= lon_min & longitudes <= lon_max);

    % Filtrar las coordenadas y ADT para el Golfo de México
    lat_gm = latitudes(lat_idx);
    lon_gm = longitudes(lon_idx);
    adt_gm_data = adt(lon_idx, lat_idx, :);
    
    % Concatenar los datos de ADT para este archivo al conjunto total
    adt_gm = cat(3, adt_gm, adt_gm_data);
    
    % Guardar las coordenadas solo una vez en el primer archivo
    if isempty(latitude_gm)
        latitude_gm = lat_gm;
        longitude_gm = lon_gm;
        save('coordenadasADT.mat', 'latitude_gm', 'longitude_gm');
    end
    
    % Crear el nombre del archivo de salida
    outfile = sprintf('ADT%04d%02d.mat', year, month);

    % Guardar los datos filtrados en un archivo .mat
    save(outfile, 'adt_gm', 'lat_gm', 'lon_gm', 'year', 'month');
end

% Aplicar el factor de escala a todos los valores de adt_gm
adt_gm = adt_gm * 0.0001;

% Guardar todos los datos filtrados en un archivo .mat
save('ADT_gm_total.mat', 'adt_gm', 'latitude_gm', 'longitude_gm');
