% Cargar los datos de ADT
load('tu_archivo.mat'); % Asegúrate de que el nombre del archivo sea correcto

% Filtrar los datos para el primer conjunto de 20 años (2002-2021)
indices_periodo = year >= 2002 & year <= 2022;
latitude_periodo = latitude(indices_periodo);
longitude_periodo = longitude(indices_periodo);
month_periodo = month(indices_periodo);
adt_adj_periodo = adt_adj(indices_periodo);

% Calcular la elevación promedio mensual para cada mes
elevacion_promedio_mensual = zeros(1, 12);
for mes = 1:12
    indices_mes = month_periodo == mes;
    adt_mes = adt_adj_periodo(indices_mes);
    elevacion_promedio_mensual(mes) = mean(adt_mes);
    fprintf('Mes %d: Elevación promedio = %.2f cm\n', mes, elevacion_promedio_mensual(mes));
end

% Identificar la corriente de lazo basada en el valor promedio de la elevación
umbral_corriente_lazo = 40; % Valor umbral según la metodología
corriente_lazo_meses = find(elevacion_promedio_mensual >= umbral_corriente_lazo);

% Mostrar los meses en los que se identificó la corriente de lazo
fprintf('\nMeses con corriente de lazo identificada (elevación promedio >= %d cm):\n', umbral_corriente_lazo);
disp(corriente_lazo_meses);