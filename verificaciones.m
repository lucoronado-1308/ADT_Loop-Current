%verificaciones

% Cargar los datos del archivo NC
ncfile = 'dt_global_allsat_msla_h_y2002_m01.nc'; % Reemplaza con el nombre de tu archivo NC
ADT_nc = ncread(ncfile, 'sla') * 0.0001; % Aplicar el factor de escala

% Cargar los datos del archivo MAT
load('ADT200201.mat'); % Reemplaza con el nombre de tu archivo MAT

% Mostrar los primeros cinco valores de ADT del archivo NC y del archivo MAT
disp('Primeros cinco valores de ADT del archivo NC:');
disp(ADT_nc(1:5));
disp('Primeros cinco valores de ADT del archivo MAT:');
disp(adt_gm(1:5));
