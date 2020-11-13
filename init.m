load('dados.mat');
open('EPS.slx');
data = table(t_w,iluminado);

ts = timeseries(iluminado, t_w);

ts_potencia_solar = timeseries(Potencia_Solar_area);

