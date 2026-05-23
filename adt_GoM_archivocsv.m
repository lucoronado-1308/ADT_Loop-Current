clear all;
close all;
clc;
format short g

% Cargar las coordenadas del Golfo de México
load('coordenadasADT.mat'); % Asegúrate de que este es el nombre correcto

% Inicializar variables para almacenar datos de ADT
data = table();

% Crear una lista de archivos .mat
files = dir('ADT*.mat');

for i = 1:length(files)
    % Cargar el archivo .mat
    load(files(i).name);

    % Extraer la fecha del nombre del archivo
    [~, name, ~] = fileparts(files(i).name);
    year = str2double(name(4:7));
    month = str2double(name(8:9));
    
    % Verificar la longitud de los vectores antes de continuar
    disp(['Longitud de lat_gm: ' num2str(length(lat_gm))]);
    disp(['Longitud de lon_gm: ' num2str(length(lon_gm))]);
    disp(['Longitud de adt_gm: ' num2str(length(adt_gm))]);

    % Ajustar la longitud de los vectores para que coincidan
    min_length = min([length(lat_gm), length(lon_gm), length(adt_gm)]);
    lat_gm = lat_gm(1:min_length);
    lon_gm = lon_gm(1:min_length);
    adt_gm = adt_gm(1:min_length);

    % Crear una tabla temporal con los datos filtrados
    temp_table = table();
    temp_table.Latitud = lat_gm(:);
    temp_table.Longitud = lon_gm(:);
    temp_table.Mes = repmat(month, min_length, 1);
    temp_table.Year = repmat(year, min_length, 1);
    temp_table.ADT = adt_gm(:);
    
    % Concatenar con la tabla principal
    data = [data; temp_table];
end

% Guardar la tabla en un archivo CSV
writetable(data, 'ADT_golfo_mexico.csv');

% Guardar la tabla en un archivo TXT con delimitador de tabulación
writetable(data, 'ADT_golfo_mexico.txt', 'Delimiter', '\t');

