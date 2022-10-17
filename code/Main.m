clear all
states = ["Florida"];

for state = 1:length(states)
    clearvars -except states state populations

    this_state = states(state);

%% Setup random
rng('default');
rng(1234);

tic
%% INPUTS AND SETUP
%maximum cores to use
M = 128;


% Define states to model and read data from Coronavirus.app
Location_arr = [this_state;];
populations = readtable("populations.csv");
statelist = string(table2array(populations(:, 1)));
idx = find(statelist==this_state);
NPop = table2array(populations(idx, 2));
data = csvread(sprintf("%s.csv", this_state));


% Remove today's data because it's a running total and probably low.
data(1, :) = [];

% Find index of last element
last_element = find(data(:, 2) == 0);
if isempty(last_element)
    last_element = length(data(:, 2));
else
    last_element = last_element(1);
end
Confirmed = flip(data(1:last_element, 1));
Deaths = flip(data(1:last_element, 2));
Vaccinated = flip(data(1:last_element, 3));
Vaccinated = [0; diff(Vaccinated)/NPop];
todays_date = datetime(2022,10,10); % First row of data (Florida.csv)
timeRef = (todays_date-last_element+1):todays_date;
Confirmed = Confirmed';
Deaths = Deaths';
vacdata = [(1:length(Vaccinated))' Vaccinated];


% Choose the number of days to simulate beyond latest data (data typically 
% available through yesterday's date)
sim_time = 180;

% Start modeling local epidemic when at least 10 cases were confirmed, effectively
% remove leading zeros from dataset
minNum = min(Confirmed(length(timeRef)-2),10);
Deaths(Confirmed<minNum)=[];
timeRef(Confirmed<minNum)= [];
Confirmed(Confirmed<minNum)=[];
MaxTime = length(timeRef)+sim_time;

days_to_chop=210; % Fit to March 14th 2021

oldConfirmed = Confirmed;
oldDeaths = Deaths;
Deaths = Deaths(1:(end-days_to_chop));
timeRef = timeRef(1:(end-days_to_chop));
Confirmed = Confirmed(1:(end-days_to_chop));
vacdata = vacdata(1:(end-days_to_chop), :);
MaxTime = length(timeRef) + sim_time;

%% Smooth case and death data.
window_length = 10;
smoothed_cases = movmean(diff(Confirmed), window_length);
smoothed_deaths = movmean(diff(Deaths), window_length);

smoothed_cases(smoothed_cases<0) = 0;
smoothed_deaths(smoothed_deaths<0) = 0;

% Correction


Confirmed = [0 cumsum(smoothed_cases)];
Deaths = [0 cumsum(smoothed_deaths)];



% Lockdown: if flag == 0, maintain lockdown ratio as estimated by today's movement data.
% if 1, change lockdown ratio to lockdown_mod.
lockdown_flag = 0;
lockdown_mod = 0.35;

% Social Distancing: if flag == 0, use "d" parameter as estimated from fit.
% if 1, change d to soc_dist_mod%.
soc_dist_flag = 0; 
soc_dist_mod = 0.30;

% Set quarantine option
% q represents the proportion of asymptomatic/presymptomatic/mild cases that 
% are detected through contact tracing and quarantined, effectively
% preventing them from exposing others and producing new cases
% scenarios: 0, 0.25, 0.5, 0.75
quarantine_start_date = datetime(2020, 08, 27); 
quarantine_start = days(quarantine_start_date - timeRef(1));
q = 0; 

% Vaccination (check vac_rate and vac_efficacy in diff_eqn1.m)
vac_start_date = datetime(2021, 01, 01);
vac_start = days(vac_start_date - timeRef(1));
vac_refusal = 0.09; % 50% antivax

mr = zeros(1,1);
%% Linear interpolation between days

% number of prior parameter sets to sample, default 50000
nDraws = 20000;

% do not allow progress output for web
prog_flag = false;
load_2nd_variant;

% d priors

google = readtable("Florida_googletrends.csv");
google_dates = table2array(google(:, 1));
google_vals  = table2array(google(:, 2));
google_vals = google_vals./100;
    
%% CALL BM SEIR MODEL
filepath = "2022States/";
yearstr = "";
waning_rate = 0; % Not used.


BM_SEIR_model()
toc
%% PLOT OUTPUTS
save("2022States/Florida.mat");
end
