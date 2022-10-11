close all;clear all;    
county = "Hillsborough";

load(sprintf("2022States/final_Florida_.mat", county));
MaxTime = MaxTime + 365; % Add 5 years to simulation.
BM_SEIR_model2()
save(sprintf("2022States/%s_emergence_highie.mat", county));


