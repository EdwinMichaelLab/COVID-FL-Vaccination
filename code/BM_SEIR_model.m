%% BM SEIR model

%% STEP 1: Define uniform parameter prior min/max values
parameter_priors = ... 
    [0 2.0 % 1: beta1
    2.0 2.0 % 2: alpha - set to quickly move S --> R1 at lockdown start
    0.16 0.5 % 3: sigma inverse of 2-6 days
    0.25 0.5 % 4: rho 25-50% of cases are asymptomatic
    0.125 0.33 % 5: gammaA inverse of 4-14 days recovery
    0.125 0.33 % 6: gammaM
    0.125 0.33 % 7: gammaH
    0.125 0.33 % 8: gammaC
    0.05 0.20 % 9: delta1 inverse of 1-10 days - modified to 1-20 days
    0.06 0.25 % 10: delta2 inverse of 4-15 days
    0.09 1 % 11: delta3 inverse of 1-11 days
    0.08 0.25 % 12: m
    3 5 % 13: REPLACED for potential rebase %% lockdown ratio, alpha/lambda 
    0.1 0.3 % 14: epsilon, proportion of symptomatic cases undetected
    0.05 0.3 % 15: x1
    0.2 0.3 % 16: x2 
    0.2 0.8  % 17: x3
    0.25 0.9  % 18: d 1-[0.58 0.85]
    2 500 % 19: E0
    0.5 1 % 20: z
    0.125 0.33 % 21: gammaQ
    0.06 0.25 % 22: deltaQ
    0.05 0.3 % 23: p
    0 2.0 % 24: beta2
    0 2.0 % 25: beta3 Delta
    2.5 3.5 % 26: Waning Period (1.5 to 2.5 years)
    0.50 0.75 % 27: Reduction in hospitalization due to Omicron
    0 3.0 % 28: beta4 BA.1
    0 3.0 % 29: beta5 BA.2
    0.001 10 % 30: k, dispersion parameter
    0 3.0 % 31: beta6 BA.4 
    0 3.0 % 32: beta7 BA.5
    ];

%other parameters
%fit to section of fit from start?
fit_to_section = false;

%number of samples to retain after RMSD sorting
%NOTE: nSelectFitting >= nSelectSimulating
nSelectFitting = 100;
nSelectSimulating = 100;

%make sure >
nSelectFitting = max(nSelectFitting, nSelectSimulating);

%% STEP 2: Randomly sample parameter sets from prior distributions
ParamSets = SampleParamSets(nDraws,parameter_priors);

%save originals for blending
ParamSets_orig = ParamSets;

%% STEP 3: Run the model using sampled parameter sets up to the last time for which we have data
% setup IC
% Set initial compartment values
IA0 = zeros(1,nDraws) + 0/NPop;
IP0 = Confirmed(1) ./ ((1-ParamSets(14,:)) .* ParamSets(9, :) .* NPop);
IM0 = zeros(1,nDraws) + 0/NPop;
IH0 = zeros(1,nDraws) + 0/NPop;
IC0 = zeros(1,nDraws) + 0/NPop;
D0  = zeros(1,nDraws) + Deaths(1)/NPop;
R10 = zeros(1,nDraws) + 0/NPop;
R20 = zeros(1,nDraws) + 0/NPop;
V0 = zeros(1,nDraws) + 0/NPop;
R30 = zeros(1,nDraws) + 0/NPop;
B0 = zeros(1,nDraws) + 0/NPop;

% 2nd Variant
E20 = zeros(1,nDraws) + 0/NPop;
IA20 = zeros(1,nDraws) + 0/NPop;
IP20 = zeros(1,nDraws) + 0/NPop;
IM20 = zeros(1,nDraws) + 0/NPop;
IH20 = zeros(1,nDraws) + 0/NPop;
IC20 = zeros(1,nDraws) + 0/NPop;
R40 = zeros(1,nDraws) + 0/NPop;
D20 = zeros(1,nDraws) + 0/NPop;

% 3rd Variant
E30 = zeros(1,nDraws) + 0/NPop;
IA30 = zeros(1,nDraws) + 0/NPop;
IP30 = zeros(1,nDraws) + 0/NPop;
IM30 = zeros(1,nDraws) + 0/NPop;
IH30 = zeros(1,nDraws) + 0/NPop;
IC30 = zeros(1,nDraws) + 0/NPop;
R50 = zeros(1,nDraws) + 0/NPop;
D30 = zeros(1,nDraws) + 0/NPop;

% Third Booster
T0 = zeros(1,nDraws) + 0/NPop;

% 4th Variant (Omicron)
E40 = zeros(1,nDraws) + 0/NPop;
IA40 = zeros(1,nDraws) + 0/NPop;
IP40 = zeros(1,nDraws) + 0/NPop;
IM40 = zeros(1,nDraws) + 0/NPop;
IH40 = zeros(1,nDraws) + 0/NPop;
IC40 = zeros(1,nDraws) + 0/NPop;
R60 = zeros(1,nDraws) + 0/NPop;
D40 = zeros(1,nDraws) + 0/NPop;

% Waned-Efficacy Classes
W0 = zeros(1,nDraws) + 0/NPop;
W20 = zeros(1, nDraws) + 0/NPop;
F0 = zeros(1, nDraws) + 0/NPop;

% Vaccinated-Susceptible
VS0 = zeros(1,nDraws) + 0/NPop;

% 5th Variant (BA.2)
E50 = zeros(1,nDraws) + 0/NPop;
IA50 = zeros(1,nDraws) + 0/NPop;
IP50 = zeros(1,nDraws) + 0/NPop;
IM50 = zeros(1,nDraws) + 0/NPop;
IH50 = zeros(1,nDraws) + 0/NPop;
IC50 = zeros(1,nDraws) + 0/NPop;
R70 = zeros(1,nDraws) + 0/NPop;
D50 = zeros(1,nDraws) + 0/NPop;

% 6th Variant (BA.4)
E60 = zeros(1,nDraws) + 0/NPop;
IA60 = zeros(1,nDraws) + 0/NPop;
IP60 = zeros(1,nDraws) + 0/NPop;
IM60 = zeros(1,nDraws) + 0/NPop;
IH60 = zeros(1,nDraws) + 0/NPop;
IC60 = zeros(1,nDraws) + 0/NPop;
R80 = zeros(1,nDraws) + 0/NPop;
D60 = zeros(1,nDraws) + 0/NPop;

% 5th Variant (BA.5)
E70 = zeros(1,nDraws) + 0/NPop;
IA70 = zeros(1,nDraws) + 0/NPop;
IP70 = zeros(1,nDraws) + 0/NPop;
IM70 = zeros(1,nDraws) + 0/NPop;
IH70 = zeros(1,nDraws) + 0/NPop;
IC70 = zeros(1,nDraws) + 0/NPop;
R90 = zeros(1,nDraws) + 0/NPop;
D70 = zeros(1,nDraws) + 0/NPop;


% 5th Variant (New Variant)
E80 = zeros(1,nDraws) + 0/NPop;
IA80 = zeros(1,nDraws) + 0/NPop;
IP80 = zeros(1,nDraws) + 0/NPop;
IM80 = zeros(1,nDraws) + 0/NPop;
IH80 = zeros(1,nDraws) + 0/NPop;
IC80 = zeros(1,nDraws) + 0/NPop;
R100 = zeros(1,nDraws) + 0/NPop;
D80 = zeros(1,nDraws) + 0/NPop;


% % E0 and S0 defined in parfor loop
INPop = 1/NPop;
E0 = ParamSets(19,:) .* INPop; % E0 = P(18)/NPop;
E20 = ParamSets(19,:) .* INPop;
E30 = ParamSets(19,:).* INPop;
E40 = ParamSets(19,:).*INPop;
E50 = ParamSets(19,:).*INPop;
E60 = ParamSets(19,:).*INPop;
E70 = ParamSets(19,:).*INPop;
E80 = ParamSets(19,:).*INPop;


S0 = (1 - IA0(1) - IP0(1) - IM0(1) - IH0(1) - IC0(1) - D0(1) - R10(1) - R20(1) - R30(1) - V0(1) - B0(1)) - E0 - E20 - E30 - E40 - E50 - E60 - E70 -E80; % S0 = 1 - sum([E0,IA0,IP0,IM0,IH0,IC0,D0,R10,R20]);

% Initalize vaccine refusal class, S2
S20 = S0.*vac_refusal;
S0 = S0 - S20;
%initialize traj. storage
S = S0; S2 = S20; E = E0; IA = IA0; IP = IP0; IM = IM0; IH = IH0;
IC = IC0; D = D0; R1 = R10; R2 = R20; V = V0;
R3 = R30; B = B0;

E2 = E20; IA2 = IA20; IP2 = IP20; IM2 = IM20; IH2 = IH20;
IC2 = IC20;R4 = R40;D2 = D20;

E3 = E30; IA3 = IA30; IP3 = IP30; IM3 = IM30; IH3 = IH30;
IC3 = IC30;R5 = R50;D3 = D30;

T = T0;

E4 = E40; IA4 = IA40; IP4 = IP40; IM4 = IM40; IH4 = IH40;
IC4 = IC40;R6 = R60;D4 = D40;

W = W0; W2 = W20; F = F0; VS = VS0;

E5 = E50; IA5 = IA50; IP5 = IP50; IM5 = IM50; IH5 = IH50;
IC5 = IC50;R7 = R70;D5 = D50;

E6 = E60; IA6 = IA60; IP6 = IP60; IM6 = IM60; IH6 = IH60;
IC6 = IC60;R8 = R80;D6 = D60;

E7 = E70; IA7 = IA70; IP7 = IP70; IM7 = IM70; IH7 = IH70;
IC7 = IC70;R9 = R90;D7 = D70;

E8 = E80; IA8 = IA80; IP8 = IP80; IM8 = IM80; IH8 = IH80;
IC8 = IC80;R10 = R100;D8 = D80;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%setup segments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%setup segments
%equi-spaced?%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
segment_length = window_length;
loops = floor(length(timeRef) / segment_length);

%lookup for segments
segment_steps = zeros(1,loops + 1);

current_step = 1;

for i = 1:loops
    segment_steps(i) = current_step;
    current_step = current_step + segment_length;
end

%get ending point
if length(timeRef) - current_step < segment_length
    current_step = length(timeRef);
end

segment_steps(end) = current_step;

%user designated?%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%segment_steps = [1 14 length(timeRef)];

%show steps
segment_steps

% get number of segments
num_segments = length(segment_steps);

% and progress steps per segment
prog_steps = floor(50/num_segments);

%loop over segments
for i = 1:(length(segment_steps) - 1)
    current_step = segment_steps(i)
    segment_end = segment_steps(i+1);
    
    google_idx = find(google_dates <= timeRef(segment_end));
    goog = google_vals(google_idx(end));
    low_goog = max(0, goog-0.15);
    high_goog = min(1, goog+0.15);
    google_priors = SampleParamSets(nDraws, [low_goog high_goog]);
    ParamSets(18, :) = 1-google_priors;
    
    % solve first fortnight
    [S0,E0,IA0,IP0,IM0,IH0,IC0,D0,R10,R20,V0,S20,R30,B0,E20,IA20,IP20,IM20,IH20,IC20,...
        R40,D20,E30,IA30,IP30,IM30,IH30,IC30,R50,D30,T0,E40,IA40,IP40,IM40,IH40,IC40,...
        R60,D40,W0,W20,F0,VS0,E50,IA50,IP50,IM50,IH50,IC50,R70,D50,...
        E60,IA60,IP60,IM60,IH60,IC60,R80,D60,E70,IA70,IP70,IM70,IH70,IC70,R90,D70,...
        E80,IA80,IP80,IM80,IH80,IC80,R100,D80] = SEIR_covid_model(ParamSets,NPop,...
        S(end,:),E(end,:),IA(end,:),IP(end,:),IM(end,:),IH(end,:),IC(end,:),D(end,:),R1(end,:),R2(end,:),...
        V(end,:),S2(end,:),R3(end,:),B(end,:),E2(end,:),IA2(end,:),IP2(end,:),IM2(end,:), ...
	IH2(end,:),IC2(end,:),R4(end,:),D2(end,:),E3(end,:),IA3(end,:),IP3(end,:),IM3(end,:), ...
    IH3(end,:),IC3(end,:),R5(end,:),D3(end,:),T(end,:),E4(end,:),IA4(end,:),IP4(end,:),IM4(end,:), ...
    IH4(end,:),IC4(end,:),R6(end,:),D4(end,:),W(end,:),W2(end,:),F(end,:),VS(end,:), ...
    E5(end,:),IA5(end,:),IP5(end,:),IM5(end,:), IH5(end,:),IC5(end,:),R7(end,:),D5(end,:), ...
        E6(end,:),IA6(end,:),IP6(end,:),IM6(end,:), IH6(end,:),IC6(end,:),R8(end,:),D6(end,:), ...
        E7(end,:),IA7(end,:),IP7(end,:),IM7(end,:), IH7(end,:),IC7(end,:),R9(end,:),D7(end,:), ...
         E8(end,:),IA8(end,:),IP8(end,:),IM8(end,:), IH8(end,:),IC8(end,:),R10(end,:),D8(end,:), ...
    current_step,segment_end,q, ...
    quarantine_start,vac_start,goog,prog_flag,M,mr,vacdata,prog_steps);

    % prepend IC, the first point is at t0
    S = [S; S0(2:end,:)];
    E = [E; E0(2:end,:)];
    IA = [IA; IA0(2:end,:)];
    IP = [IP; IP0(2:end,:)];
    IM = [IM; IM0(2:end,:)];
    IH = [IH; IH0(2:end,:)];
    IC = [IC; IC0(2:end,:)];
    D = [D; D0(2:end,:)];
    R1 = [R1; R10(2:end,:)];
    R2 = [R2; R20(2:end,:)];
    V = [V; V0(2:end,:)];
    S2 = [S2; S20(2:end,:)];
    R3 = [R3; R30(2:end,:)];
    B = [B; B0(2:end,:)];
    
    E2 = [E2; E20(2:end,:)];
    IA2 = [IA2; IA20(2:end,:)];
    IP2 = [IP2; IP20(2:end,:)];
    IM2 = [IM2; IM20(2:end,:)];
    IH2 = [IH2; IH20(2:end,:)];
    IC2 = [IC2; IC20(2:end,:)];
    R4 = [R4; R40(2:end,:)];
    D2 = [D2; D20(2:end,:)];
    
    E3 = [E3; E30(2:end,:)];
    IA3 = [IA3; IA30(2:end,:)];
    IP3 = [IP3; IP30(2:end,:)];
    IM3 = [IM3; IM30(2:end,:)];
    IH3 = [IH3; IH30(2:end,:)];
    IC3 = [IC3; IC30(2:end,:)];
    R5 = [R5; R50(2:end,:)];
    D3 = [D3; D30(2:end,:)];
    
    T = [T; T0(2:end,:)];
    
    E4 = [E4; E40(2:end,:)];
    IA4 = [IA4; IA40(2:end,:)];
    IP4 = [IP4; IP40(2:end,:)];
    IM4 = [IM4; IM40(2:end,:)];
    IH4 = [IH4; IH40(2:end,:)];
    IC4 = [IC4; IC40(2:end,:)];
    R6 = [R6; R60(2:end,:)];
    D4 = [D4; D40(2:end,:)];

    W = [W; W0(2:end,:)];
    W2 = [W2; W20(2:end,:)];

    F = [F; F0(2:end,:)];
    VS = [VS; VS0(2:end,:)];

    E5 = [E5; E50(2:end,:)];
    IA5 = [IA5; IA50(2:end,:)];
    IP5 = [IP5; IP50(2:end,:)];
    IM5 = [IM5; IM50(2:end,:)];
    IH5 = [IH5; IH50(2:end,:)];
    IC5 = [IC5; IC50(2:end,:)];
    R7 = [R7; R70(2:end,:)];
    D5 = [D5; D50(2:end,:)];

    E6 = [E6; E60(2:end,:)];
    IA6 = [IA6; IA60(2:end,:)];
    IP6 = [IP6; IP60(2:end,:)];
    IM6 = [IM6; IM60(2:end,:)];
    IH6 = [IH6; IH60(2:end,:)];
    IC6 = [IC6; IC60(2:end,:)];
    R8 = [R8; R80(2:end,:)];
    D6 = [D6; D60(2:end,:)];

    E7 = [E7; E70(2:end,:)];
    IA7 = [IA7; IA70(2:end,:)];
    IP7 = [IP7; IP70(2:end,:)];
    IM7 = [IM7; IM70(2:end,:)];
    IH7 = [IH7; IH70(2:end,:)];
    IC7 = [IC7; IC70(2:end,:)];
    R9 = [R9; R90(2:end,:)];
    D7 = [D7; D70(2:end,:)];

    E8 = [E8; E80(2:end,:)];
    IA8 = [IA8; IA80(2:end,:)];
    IP8 = [IP8; IP80(2:end,:)];
    IM8 = [IM8; IM80(2:end,:)];
    IH8 = [IH8; IH80(2:end,:)];
    IC8 = [IC8; IC80(2:end,:)];
    R10 = [R10; R100(2:end,:)];
    D8 = [D8; D80(2:end,:)];

    % Correct S, V for vaccination.
    totalv = 0;
    totalb = 0;
    for vac_day = current_step:segment_end
        if vac_day > vacdata(1, 1) && vac_day <= vacdata(end, 1)
            [~, idx] = min(abs(vacdata(:, 1) - vac_day));
            totalv = totalv + vacdata(idx, 2);
        elseif vac_day > vacdata(end, 1)
            totalv = totalv + mean(vacdata((end-7:end), 2));
        end
    end
% %         S --> V transition
%     S(segment_end, :) = S(segment_end, :) - totalv;
%     V(segment_end, :) = V(segment_end, :) + totalv;
%     
% %     V --> B transition
%     B(segment_end, :) = B(segment_end, :) + totalb;
%     V(segment_end, :) = V(segment_end, :) - totalb;
    totalvorig = totalv;    
    for paramset=1:nDraws
        totalv = (1-R2(segment_end, paramset)-R4(segment_end, paramset)-R5(segment_end, paramset))*totalvorig;

        if S(segment_end, paramset) - totalv >= 0
            S(segment_end, paramset) = S(segment_end, paramset) - totalv;
            V(segment_end, paramset) = V(segment_end, paramset) + totalv;
        else
            V(segment_end, paramset) = V(segment_end, paramset) + S(segment_end, paramset);
            S(segment_end, paramset) = 0;
        end
    end

    
    % lets grab the reasonable trajectories,
    % we use a form of relative RMSE as a distance metric to indicate how far 
    % the model outputs are from the observed case data. The RMSE is calculated 
    % based on cumulative confirmed case counts and deaths.
    % First, we need to calculate the model-predicted cumulative confirmed 
    % cases. We assume the number of new cases that will be detected each day to 
    % be a fraction of those leaving presymptomatic class and entering the 
    % symptomatic pipeline. We assume epsilon of those are mildly symptomatic 
    % cases that will not get tested/reported.
    epsilon = ParamSets(14,:);
    delta1 = ParamSets(9, :);
    x3 = ParamSets(17, :);
    m = ParamSets(12, :);

    %fit to this section? or from start?
    %if from start we need the pred_C from start
    if fit_to_section
        %pred_C = cumsum((1-epsilon).*IP0.*delta1*NPop);
        pred_C = (1-epsilon).*IP0.*delta1*NPop;
        pred_D = x3.*m.*(IC+IC2+IC3+IC4+IC5)*NPop;
        fit_start = current_step;
    else
        %pred_C = cumsum((1-epsilon).*IP.*delta1*NPop);
        pred_C = (1-epsilon).*IP.*delta1*NPop;
        pred_D = x3.*m.*(IC+IC2+IC3+IC4+IC5)*NPop;
        fit_start = 1;
    end
    
    % B199 Cases RMSE
    pred_C2 = (1-epsilon).*IP2.*delta1*NPop;
    pred_C3 = (1-epsilon).*IP3.*delta1*NPop;
    pred_C4 = (1-epsilon).*IP4.*delta1*NPop;
    pred_C5 = (1-epsilon).*IP5.*delta1*NPop;
    pred_C6 = (1-epsilon).*IP6.*delta1*NPop;
    pred_C7 = (1-epsilon).*IP7.*delta1*NPop;
    pred_C8 = (1-epsilon).*IP8.*delta1*NPop;




    %NOTE: I was fitting to the current segment, seems to work better from
    %the start to the current point!
    % Reformat model predictions and observed data for confirmed
    % cases and deaths
    
    
   % B199 Cases x1, y1
     x1 = pred_C(1:length(diff(Confirmed(fit_start:segment_end))),:); % model-predicted cumulative cases
     y1 = (1-frac1(fit_start:segment_end-1)-frac2(fit_start:segment_end-1)-frac3(fit_start:segment_end-1)-frac4(fit_start:segment_end-1)).*diff(Confirmed(fit_start:segment_end))'; % observed cumulative cases
     x2 = pred_D(1:length(diff(Confirmed(fit_start:segment_end))),:); % model-predicted deaths
     y2 = diff(Deaths(fit_start:segment_end))'; % observed deaths
     x3 = pred_C2(1:length(diff(Confirmed(fit_start:segment_end))),:); % model-predicted cumulative cases
     y3 = frac1(fit_start:segment_end-1).*diff(Confirmed(fit_start:segment_end))'; % observed cumulative cases
     x4 = pred_C3(1:length(diff(Confirmed(fit_start:segment_end))),:); % model-predicted cumulative cases
     y4 = frac2(fit_start:segment_end-1).*diff(Confirmed(fit_start:segment_end))'; % observed cumulative cases
     x5 = pred_C4(1:length(diff(Confirmed(fit_start:segment_end))),:); % model-predicted cumulative cases
     y5 = frac3(fit_start:segment_end-1).*diff(Confirmed(fit_start:segment_end))'; % observed cumulative cases
     x6 = pred_C5(1:length(diff(Confirmed(fit_start:segment_end))),:); % model-predicted cumulative cases
     y6 = frac4(fit_start:segment_end-1).*diff(Confirmed(fit_start:segment_end))'; % observed cumulative cases
     x7 = pred_C6(1:length(diff(Confirmed(fit_start:segment_end))),:); % model-predicted cumulative cases
     y7 = frac5(fit_start:segment_end-1).*diff(Confirmed(fit_start:segment_end))'; % observed cumulative cases
     x8 = pred_C7(1:length(diff(Confirmed(fit_start:segment_end))),:); % model-predicted cumulative cases
     y8 = frac6(fit_start:segment_end-1).*diff(Confirmed(fit_start:segment_end))'; % observed cumulative cases
     
     % BA.2 January 23rd 2022 emergence
%      if current_step > 781
%         RMSE = sqrt(mean([((x1-y1).^2)./std(x1);((x3-y3).^2)./std(x3);((x4-y4).^2)./std(x4);((x5-y5).^2)./std(x5);((x6-y6).^2)./std(x6);((x7-y7).^2)./std(x7);((x8-y8).^2)./std(x8);]));
%      elseif current_step > 760
%         RMSE = sqrt(mean([((x1-y1).^2)./std(x1);((x3-y3).^2)./std(x3);((x4-y4).^2)./std(x4);((x5-y5).^2)./std(x5);((x6-y6).^2)./std(x6);((x7-y7).^2)./std(x7);]));
%      elseif current_step > 686
%         RMSE = sqrt(mean([((x1-y1).^2)./std(x1);((x3-y3).^2)./std(x3);((x4-y4).^2)./std(x4);((x5-y5).^2)./std(x5);((x6-y6).^2)./std(x6);]));
     if current_step > 600
        RMSE = sqrt(mean([((x1-y1).^2)./std(x1);((x3-y3).^2)./std(x3);((x4-y4).^2)./std(x4);((x5-y5).^2)./std(x5);]));
     elseif current_step > 410
        RMSE = sqrt(mean([((x1-y1).^2)./std(x1);((x3-y3).^2)./std(x3);((x4-y4).^2)./std(x4)]));
     elseif current_step > 288
        RMSE = sqrt(mean([((x1-y1).^2)./std(x1);((x3-y3).^2)./std(x3);]));
     else
        RMSE = sqrt(mean([((x1-y1).^2)./std(x1);]));
     end
     
%      % NO DEATH RMSE
%      if current_step > 410
%         RMSE = sqrt(mean([((x1-y1).^2)./std(x1);((x3-y3).^2)./std(x3);((x4-y4).^2)./std(x4)]));
%      elseif current_step > 288
%         RMSE = sqrt(mean([((x1-y1).^2)./std(x1);((x3-y3).^2)./std(x3);]));
%      else
%         RMSE = sqrt(mean([((x1-y1).^2)./std(x1);]));
%      end

    % calculate combined RMSE metric, MSE normalized by standard deviation to
    % avoid higher weighting of confirmed cases than deaths (there are much 
    % fewer deaths than cases!)
    %RMSE = sqrt(mean(((x1-y1).^2)./std(x1))); % Only fit to Confirmed cases for now
    [x,ind] = sort(RMSE);
    
    % select the best nSelectFitting (200) parameter sets based on the corresponding RMSE metric
    id = ind(1:nSelectFitting);
    
    %ParamSets = ParamSets(:,id);
    %Now take selected trajectories 
    % Set initial compartment values
    S = S(:,id); E = E(:,id); IA = IA(:,id); IP = IP(:,id); IM = IM(:,id); 
    IH = IH(:,id); IC = IC(:,id); D = D(:,id); R1 = R1(:,id); R2 = R2(:,id);
    V = V(:,id); S2 = S2(:,id); R3 = R3(:,id);
    B = B(:, id); 
    
    E2 = E2(:,id); IA2 = IA2(:,id); IP2 = IP2(:,id); IM2 = IM2(:,id); 
    IH2 = IH2(:, id); IC2 = IC2(:,id); R4 = R4(:,id);D2 = D2(:,id);
    
        
    E3 = E3(:,id); IA3 = IA3(:,id); IP3 = IP3(:,id); IM3 = IM3(:,id); 
    IH3 = IH3(:, id); IC3 = IC3(:,id); R5 = R5(:,id);D3 = D3(:,id);
    
    T = T(:,id);

    E4 = E4(:,id); IA4 = IA4(:,id); IP4 = IP4(:,id); IM4 = IM4(:,id); 
    IH4 = IH4(:, id); IC4 = IC4(:,id); R6 = R6(:,id);D4 = D4(:,id);

    W = W(:, id); W2 = W2(:, id); F = F(:, id); VS = VS(:, id);

    E5 = E5(:,id); IA5 = IA5(:,id); IP5 = IP5(:,id); IM5 = IM5(:,id); 
    IH5 = IH5(:, id); IC5 = IC5(:,id); R7 = R7(:,id);D5 = D5(:,id);

    E6 = E6(:,id); IA6 = IA6(:,id); IP6 = IP6(:,id); IM6 = IM6(:,id); 
    IH6 = IH6(:, id); IC6 = IC6(:,id); R8 = R8(:,id);D6 = D6(:,id);

    E7 = E7(:,id); IA7 = IA7(:,id); IP7 = IP7(:,id); IM7 = IM7(:,id); 
    IH7 = IH7(:, id); IC7 = IC7(:,id); R9 = R9(:,id);D7 = D7(:,id);

    E8 = E8(:,id); IA8 = IA8(:,id); IP8 = IP8(:,id); IM8 = IM8(:,id); 
    IH8 = IH8(:, id); IC8 = IC8(:,id); R10 = R10(:,id);D8 = D8(:,id);
    %and parameters
    ParamSets = ParamSets(:,id);
    
    %if last loop don't bother with replicating traj. and new priors
    if i < length(segment_steps) - 1

        %replicate traj. to get nDraw simulations.
        %number of replications
        nReplicas = nDraws / nSelectFitting;

        S = repmat(S,1,nReplicas);
        E = repmat(E,1,nReplicas);
        IA = repmat(IA,1,nReplicas);
        IP = repmat(IP,1,nReplicas);
        IM = repmat(IM,1,nReplicas);
        IH = repmat(IH,1,nReplicas);
        IC = repmat(IC,1,nReplicas);
        D = repmat(D,1,nReplicas);
        R1 = repmat(R1,1,nReplicas);
        R2 = repmat(R2,1,nReplicas);
        V = repmat(V,1,nReplicas);
        S2 = repmat(S2,1,nReplicas);
        R3 = repmat(R3,1,nReplicas);
        B = repmat(B,1,nReplicas);
        
        E2 = repmat(E2,1,nReplicas);
        IA2 = repmat(IA2,1,nReplicas);
        IP2 = repmat(IP2,1,nReplicas);
        IM2 = repmat(IM2,1,nReplicas);
        IH2 = repmat(IH2,1,nReplicas);
        IC2 = repmat(IC2,1,nReplicas);
        R4 = repmat(R4,1,nReplicas);
        D2 = repmat(D2,1,nReplicas);
        
        E3 = repmat(E3,1,nReplicas);
        IA3 = repmat(IA3,1,nReplicas);
        IP3 = repmat(IP3,1,nReplicas);
        IM3 = repmat(IM3,1,nReplicas);
        IH3 = repmat(IH3,1,nReplicas);
        IC3 = repmat(IC3,1,nReplicas);
        R5 = repmat(R5,1,nReplicas);
        D3 = repmat(D3,1,nReplicas);
        
        T = repmat(T,1,nReplicas);

        E4 = repmat(E4,1,nReplicas);
        IA4 = repmat(IA4,1,nReplicas);
        IP4 = repmat(IP4,1,nReplicas);
        IM4 = repmat(IM4,1,nReplicas);
        IH4 = repmat(IH4,1,nReplicas);
        IC4 = repmat(IC4,1,nReplicas);
        R6 = repmat(R6,1,nReplicas);
        D4 = repmat(D4,1,nReplicas);

        W = repmat(W,1,nReplicas);
        W2 = repmat(W2,1,nReplicas);

        F = repmat(F,1,nReplicas);
        VS = repmat(VS,1,nReplicas);
        
        
        E5 = repmat(E5,1,nReplicas);
        IA5 = repmat(IA5,1,nReplicas);
        IP5 = repmat(IP5,1,nReplicas);
        IM5 = repmat(IM5,1,nReplicas);
        IH5 = repmat(IH5,1,nReplicas);
        IC5 = repmat(IC5,1,nReplicas);
        R7 = repmat(R7,1,nReplicas);
        D5 = repmat(D5,1,nReplicas);

        E6 = repmat(E6,1,nReplicas);
        IA6 = repmat(IA6,1,nReplicas);
        IP6 = repmat(IP6,1,nReplicas);
        IM6 = repmat(IM6,1,nReplicas);
        IH6 = repmat(IH6,1,nReplicas);
        IC6 = repmat(IC6,1,nReplicas);
        R8 = repmat(R8,1,nReplicas);
        D6 = repmat(D6,1,nReplicas);

        E7 = repmat(E7,1,nReplicas);
        IA7 = repmat(IA7,1,nReplicas);
        IP7 = repmat(IP7,1,nReplicas);
        IM7 = repmat(IM7,1,nReplicas);
        IH7 = repmat(IH7,1,nReplicas);
        IC7 = repmat(IC7,1,nReplicas);
        R9 = repmat(R9,1,nReplicas);
        D7 = repmat(D7,1,nReplicas);

        E8 = repmat(E8,1,nReplicas);
        IA8 = repmat(IA8,1,nReplicas);
        IP8 = repmat(IP8,1,nReplicas);
        IM8 = repmat(IM8,1,nReplicas);
        IH8 = repmat(IH8,1,nReplicas);
        IC8 = repmat(IC8,1,nReplicas);
        R10 = repmat(R10,1,nReplicas);
        D8 = repmat(D8,1,nReplicas);


     	% Save parameters?
     	%save(sprintf("%s/%s/%i%s_%s.mat", filepath, Location_arr(1), i, Location_arr(1),yearstr), "ParamSets");
     	save(sprintf("%s/%i%s_%s.mat", filepath, i, Location_arr(1),yearstr), "ParamSets");

        %Create new priors? Only if not end of loop
        disp("creating new parameters")
        
        %get range from selected priors
        %note we have culled ParamSets by here
        %selectedParamSets = ParamSets(:,id);
        parameter_priors_new=[min(ParamSets,[],2) max(ParamSets,[],2)];

        %Randomly sample parameter sets from prior distributions
        ParamSets = SampleParamSets(nDraws,parameter_priors_new);

        %blend with original set
        blend_probability = 0.50;

        %throw rands, and take that proportion from original
        %currently does NOT blend within parameter sets!
        R = rand(1,nDraws);
        ParamSets(:,R<blend_probability) = ParamSets_orig(:,R<blend_probability);
    end
end

disp("End of fitting")

%% STEP 4: Select best-fitting models based on distance metric 
%NOTE: we only need to do this if nSelectFitting > nSelectSimulating

% we use a form of relative RMSE as a distance metric to indicate how far 
% the model outputs are from the observed case data. The RMSE is calculated 
% based on cumulative confirmed case counts and deaths.

% First, we need to calculate the model-predicted cumulative confirmed 
% cases. We assume the number of new cases that will be detected each day to 
% be a fraction of those leaving presymptomatic class and entering the 
% symptomatic pipeline. We assume epsilon of those are mildly symptomatic 
% cases that will not get tested/reported.
epsilon = ParamSets(14,:);
delta1 = ParamSets(9, :);
x3 = ParamSets(17, :);
m = ParamSets(12, :);

pred_C = (1-epsilon).*IP.*delta1*NPop;
pred_D = x3.*m.*(IC+IC2+IC3+IC4+IC5)*NPop;
pred_C2 = (1-epsilon).*IP2.*delta1*NPop;
pred_C3 = (1-epsilon).*IP3.*delta1*NPop;
pred_C4 = (1-epsilon).*IP4.*delta1*NPop;
pred_C5 = (1-epsilon).*IP5.*delta1*NPop;
pred_C6 = (1-epsilon).*IP6.*delta1*NPop;
pred_C7 = (1-epsilon).*IP7.*delta1*NPop;
pred_C8 = (1-epsilon).*IP8.*delta1*NPop;


%pred_C = cumsum((1-epsilon).*IP.*delta1*NPop);

% Define the last time point of data to use for fitting (3 options)

% Option 1: use all data (normal case)
%endt = length(Confirmed); % all data
endt = length(diff(Confirmed)); % all data

% Option 2: manual implementation of sequential fitting - change endt to 
% indicate how many days of data to fit, run the model with each endt and 
% compare 
% endt = round(0.4 * length(Confirmed)); % 40% of data
% endt = round(0.6 * length(Confirmed)); % 60% of data
% endt = round(0.8 * length(Confirmed)); % 85% of data

% Option 3: fit only to pre-lockdown data
% endt = find(timeRef == datetime('27-Mar-2020')); % up to start of lockdown

% Based on endt, reformat model predictions and observed data for confirmed
% cases and deaths
% x1 = pred_C(1:length(Confirmed(1:endt)),:); % model-predicted cumulative cases
% y1 = Confirmed(1:endt)'; % observed cumulative cases
% x2 = NPop*D(1:length(Confirmed(1:endt)),:); % model-predicted deaths
% y2 = Deaths(1:endt)'; % observed deaths

x1 = pred_C(1:length(diff(Confirmed(1:endt))),:); % model-predicted cumulative cases
y1 = (1-frac1(1:endt-1)-frac2(1:endt-1)-frac3(1:endt-1)-frac4(1:endt-1)).*diff(Confirmed(1:endt))'; % observed cumulative cases
x2 = pred_D(1:length(diff(Confirmed(1:endt))),:); % model-predicted deaths
y2 = diff(Deaths(1:endt))'; % observed deaths
x3 = pred_C2(1:length(diff(Confirmed(1:endt))),:); % model-predicted cumulative cases
y3 = frac1(1:endt-1).*diff(Confirmed(1:endt))'; % observed cumulative cases
x4 = pred_C3(1:length(diff(Confirmed(1:endt))),:); % model-predicted cumulative cases
y4 = frac2(1:endt-1).*diff(Confirmed(1:endt))'; % observed cumulative cases
x5 = pred_C4(1:length(diff(Confirmed(1:endt))),:); % model-predicted cumulative cases
y5 = frac3(1:endt-1).*diff(Confirmed(1:endt))'; % observed cumulative cases
x6 = pred_C5(1:length(diff(Confirmed(1:endt))),:); % model-predicted cumulative cases
y6 = frac4(1:endt-1).*diff(Confirmed(1:endt))'; % observed cumulative cases
x7 = pred_C6(1:length(diff(Confirmed(1:endt))),:); % model-predicted cumulative cases
y7 = frac5(1:endt-1).*diff(Confirmed(1:endt))'; % observed cumulative cases
x8 = pred_C7(1:length(diff(Confirmed(1:endt))),:); % model-predicted cumulative cases
y8 = frac6(1:endt-1).*diff(Confirmed(1:endt))'; % observed cumulative cases
       
% calculate combined RMSE metric, MSE normalized by standard deviation to
% avoid higher weighting of confirmed cases than deaths (there are much 
% fewer deaths than cases!)
RMSE = sqrt(mean([((x1-y1).^2)./std(x1);((x3-y3).^2)./std(x3);((x4-y4).^2)./std(x4);((x5-y5).^2)./std(x5)]));
%RMSE = sqrt(mean([((x1-y1).^2)./std(x1);((x3-y3).^2)./std(x3);((x4-y4).^2)./std(x4);]));

% select the best nSelectSimulating (200) parameter sets based on the corresponding RMSE metric
[x,i] = sort(RMSE);
id = i(1:nSelectSimulating);
ParamSets = ParamSets(:,id);

% Display median d over the last segment + lockdown ratio    on last day
latest_d = median(ParamSets(18, :)); 
%latest_lockdown = movement_data(length(timeRef));
if lockdown_flag
    mr = @(t) lockdown_mod/(1-lockdown_mod);
end

if soc_dist_flag
    ParamSets(18, :) = soc_dist_mod;
end

%% STEP 5: Run the model for the full simulation period using the sampled parameter sets
% setup IC
% Set initial compartment values
S0 = S(:,id);
E0 = E(:,id);
IA0 = IA(:,id);
IP0 = IP(:,id);
IM0 = IM(:,id);
IH0 = IH(:,id);
IC0 = IC(:,id);
D0 = D(:,id);
R10 = R1(:,id);
R20 = R2(:,id);
V0 = V(:,id);
S20 = S2(:,id);
R30 = R3(:,id);
B0 = B(:,id);

E20 = E2(:,id);
IA20 = IA2(:,id);
IP20 = IP2(:,id);
IM20 = IM2(:,id);
IH20 = IH2(:,id);
IC20 = IC2(:,id);
R40 = R4(:,id);
D20 = D2(:,id);

E30 = E3(:,id);
IA30 = IA3(:,id);
IP30 = IP3(:,id);
IM30 = IM3(:,id);
IH30 = IH3(:,id);
IC30 = IC3(:,id);
R50 = R5(:,id);
D30 = D3(:,id);

T0 = T(:,id);


E40 = E4(:,id);
IA40 = IA4(:,id);
IP40 = IP4(:,id);
IM40 = IM4(:,id);
IH40 = IH4(:,id);
IC40 = IC4(:,id);
R60 = R6(:,id);
D40 = D4(:,id);

W0 = W(:,id);
W20 = W2(:, id);

F0 = F(:, id);
VS0 = VS(:, id);

E50 = E5(:,id);
IA50 = IA5(:,id);
IP50 = IP5(:,id);
IM50 = IM5(:,id);
IH50 = IH5(:,id);
IC50 = IC5(:,id);
R70 = R7(:,id);
D50 = D5(:,id);

E60 = E6(:,id);
IA60 = IA6(:,id);
IP60 = IP6(:,id);
IM60 = IM6(:,id);
IH60 = IH6(:,id);
IC60 = IC6(:,id);
R80 = R8(:,id);
D60 = D6(:,id);

E70 = E7(:,id);
IA70 = IA7(:,id);
IP70 = IP7(:,id);
IM70 = IM7(:,id);
IH70 = IH7(:,id);
IC70 = IC7(:,id);
R90 = R9(:,id);
D70 = D7(:,id);

E80 = E8(:,id);
IA80 = IA8(:,id);
IP80 = IP8(:,id);
IM80 = IM8(:,id);
IH80 = IH8(:,id);
IC80 = IC8(:,id);
R100 = R10(:,id);
D80 = D8(:,id);

save(sprintf("%s/final_%s_%s.mat", filepath, Location_arr(1), yearstr));
%load("final.mat");
% mr = @(t) 0.27/(1-0.27);
% 

for day_segment=length(timeRef):MaxTime-2
    S0 = S(:,id);
    E0 = E(:,id);
    IA0 = IA(:,id);
    IP0 = IP(:,id);
    IM0 = IM(:,id);
    IH0 = IH(:,id);
    IC0 = IC(:,id);
    D0 = D(:,id);
    R10 = R1(:,id);
    R20 = R2(:,id);
    V0 = V(:,id);
    S20 = S2(:,id);
    R30 = R3(:,id);
    B0 = B(:,id);
    
    E20 = E2(:,id);
    IA20 = IA2(:,id);
    IP20 = IP2(:,id);
    IM20 = IM2(:,id);
    IH20 = IH2(:,id);
    IC20 = IC2(:,id);
    R40 = R4(:,id);
    D20 = D2(:,id);
    
    E30 = E3(:,id);
    IA30 = IA3(:,id);
    IP30 = IP3(:,id);
    IM30 = IM3(:,id);
    IH30 = IH3(:,id);
    IC30 = IC3(:,id);
    R50 = R5(:,id);
    D30 = D3(:,id);
    
    T0 = T(:,id);

    E40 = E4(:,id);
    IA40 = IA4(:,id);
    IP40 = IP4(:,id);
    IM40 = IM4(:,id);
    IH40 = IH4(:,id);
    IC40 = IC4(:,id);
    R60 = R6(:,id);
    D40 = D4(:,id);

    W0 = W(:,id);
    W20 = W2(:, id);
    F0 = F(:, id);
    VS0 = VS(:, id);
    
    E50 = E5(:,id);
    IA50 = IA5(:,id);
    IP50 = IP5(:,id);
    IM50 = IM5(:,id);
    IH50 = IH5(:,id);
    IC50 = IC5(:,id);
    R70 = R7(:,id);
    D50 = D5(:,id);

    E60 = E6(:,id);
    IA60 = IA6(:,id);
    IP60 = IP6(:,id);
    IM60 = IM6(:,id);
    IH60 = IH6(:,id);
    IC60 = IC6(:,id);
    R80 = R8(:,id);
    D60 = D6(:,id);


    E70 = E7(:,id);
    IA70 = IA7(:,id);
    IP70 = IP7(:,id);
    IM70 = IM7(:,id);
    IH70 = IH7(:,id);
    IC70 = IC7(:,id);
    R90 = R9(:,id);
    D70 = D7(:,id);

    E80 = E8(:,id);
    IA80 = IA8(:,id);
    IP80 = IP8(:,id);
    IM80 = IM8(:,id);
    IH80 = IH8(:,id);
    IC80 = IC8(:,id);
    R100 = R10(:,id);
    D80 = D8(:,id);

    goog = google_vals(end);
    [S,E,IA,IP,IM,IH,IC,D,R1,R2,V,S2,R3,B,E2,IA2,IP2,IM2,IH2,IC2,R4,D2,E3,IA3,IP3,IM3,IH3,IC3,R5,D3,...
        T,E4,IA4,IP4,IM4,IH4,IC4,R6,D4,W,W2,F,VS,E5,IA5,IP5,IM5,IH5,IC5,R7,D5,...
        E6,IA6,IP6,IM6,IH6,IC6,R8,D6,E7,IA7,IP7,IM7,IH7,IC7,R9,D7,...
        E8,IA8,IP8,IM8,IH8,IC8,R10,D8] = SEIR_covid_model(ParamSets,NPop,...
        S0(end,:),E0(end,:),IA0(end,:),IP0(end,:),IM0(end,:),IH0(end,:),IC0(end,:),D0(end,:),R10(end,:),R20(end,:),...
        V0(end,:),S20(end,:),R30(end,:),B0(end,:),E20(end,:),IA20(end,:),IP20(end,:),IM20(end,:), ...
	IH20(end,:),IC20(end,:),R40(end,:),D20(end,:),E30(end,:),IA30(end,:),IP30(end,:),IM30(end,:), ...
    IH30(end,:),IC30(end,:),R50(end,:),D30(end,:),T0(end,:),E40(end,:),IA40(end,:),IP40(end,:),IM40(end,:), ...
    IH40(end,:),IC40(end,:),R60(end,:),D40(end,:),W0(end,:),W20(end,:),F0(end,:),VS0(end,:),E50(end,:),...
    IA50(end,:),IP50(end,:),IM50(end,:), ...
    IH50(end,:),IC50(end,:),R70(end,:),D50(end,:),...
    E60(end,:),IA60(end,:),IP60(end,:),IM60(end,:), IH60(end,:),IC60(end,:),R80(end,:),D60(end,:),...
    E70(end,:),IA70(end,:),IP70(end,:),IM70(end,:), IH70(end,:),IC70(end,:),R90(end,:),D70(end,:),...
    E80(end,:),IA80(end,:),IP80(end,:),IM80(end,:), IH80(end,:),IC80(end,:),R100(end,:),D80(end,:),...
    day_segment,day_segment+1,q,quarantine_start, ...
    vac_start,goog,prog_flag,M,mr,vacdata,prog_steps);
    
       % prepend IC, the first point is at t0
    S = [S0; S(2:end,:)];
    E = [E0; E(2:end,:)];
    IA = [IA0; IA(2:end,:)];
    IP = [IP0; IP(2:end,:)];
    IM = [IM0; IM(2:end,:)];
    IH = [IH0; IH(2:end,:)];
    IC = [IC0; IC(2:end,:)];
    D = [D0; D(2:end,:)];
    R1 = [R10; R1(2:end,:)];
    R2 = [R20; R2(2:end,:)];
    V = [V0; V(2:end,:)];
    S2 = [S20; S2(2:end,:)];
    R3 = [R30; R3(2:end,:)];
    B = [B0; B(2:end,:)];
    
    E2 = [E20; E2(2:end,:)];
    IA2 = [IA20; IA2(2:end,:)];
    IP2 = [IP20; IP2(2:end,:)];
    IM2 = [IM20; IM2(2:end,:)];
    IH2 = [IH20; IH2(2:end,:)];
    IC2 = [IC20; IC2(2:end,:)];
    R4 = [R40; R4(2:end,:)];
    D2 = [D20; D2(2:end,:)];  
        
    E3 = [E30; E3(2:end,:)];
    IA3 = [IA30; IA3(2:end,:)];
    IP3 = [IP30; IP3(2:end,:)];
    IM3 = [IM30; IM3(2:end,:)];
    IH3 = [IH30; IH3(2:end,:)];
    IC3 = [IC30; IC3(2:end,:)];
    R5 = [R50; R5(2:end,:)];
    D3 = [D30; D3(2:end,:)];  

    T = [T0; T(2:end,:)];  

    E4 = [E40; E4(2:end,:)];
    IA4 = [IA40; IA4(2:end,:)];
    IP4 = [IP40; IP4(2:end,:)];
    IM4 = [IM40; IM4(2:end,:)];
    IH4 = [IH40; IH4(2:end,:)];
    IC4 = [IC40; IC4(2:end,:)];
    R6 = [R60; R6(2:end,:)];
    D4 = [D40; D4(2:end,:)];  

    W = [W0; W(2:end,:)];  
    W2 = [W20; W2(2:end,:)];    
    F = [F0; F(2:end,:)];
    VS = [VS0; VS(2:end,:)];

    E5 = [E50; E5(2:end,:)];
    IA5 = [IA50; IA5(2:end,:)];
    IP5 = [IP50; IP5(2:end,:)];
    IM5 = [IM50; IM5(2:end,:)];
    IH5 = [IH50; IH5(2:end,:)];
    IC5 = [IC50; IC5(2:end,:)];
    R7 = [R70; R7(2:end,:)];
    D5 = [D50; D5(2:end,:)];  

    E6 = [E60; E6(2:end,:)];
    IA6 = [IA60; IA6(2:end,:)];
    IP6 = [IP60; IP6(2:end,:)];
    IM6 = [IM60; IM6(2:end,:)];
    IH6 = [IH60; IH6(2:end,:)];
    IC6 = [IC60; IC6(2:end,:)];
    R8 = [R80; R8(2:end,:)];
    D6 = [D60; D6(2:end,:)];  

    E7 = [E70; E7(2:end,:)];
    IA7 = [IA70; IA7(2:end,:)];
    IP7 = [IP70; IP7(2:end,:)];
    IM7 = [IM70; IM7(2:end,:)];
    IH7 = [IH70; IH7(2:end,:)];
    IC7 = [IC70; IC7(2:end,:)];
    R9 = [R90; R9(2:end,:)];
    D7 = [D70; D7(2:end,:)];

    E8 = [E80; E8(2:end,:)];
    IA8 = [IA80; IA8(2:end,:)];
    IP8 = [IP80; IP8(2:end,:)];
    IM8 = [IM80; IM8(2:end,:)];
    IH8 = [IH80; IH8(2:end,:)];
    IC8 = [IC80; IC8(2:end,:)];
    R10 = [R100; R10(2:end,:)];
    D8 = [D80; D8(2:end,:)];  


    totalvorig = mean(vacdata((end-7:end), 2));

    for paramset=1:nSelectSimulating
        % Correct S, V for vaccination
        totalv = (1-R2(end, paramset)-R4(end, paramset)-R5(end, paramset))*totalvorig;
        
        if S(end, paramset) - totalv >= 0
            S(end, paramset) = S(end, paramset) - totalv;
            V(end, paramset) = V(end, paramset) + totalv;
        else
            V(end, paramset) = V(end, paramset) + S(end, paramset);
            S(end, paramset) = 0;
        end
    end
end


% recalcuate the predicted cumulative confirmed cases for full simulation
% period
epsilon = ParamSets(14,:);
delta1 = ParamSets(9, :);
x3 = ParamSets(17, :);
m = ParamSets(12, :);

pred_D = x3.*m.*(IC+IC2+IC3+IC4)*NPop;
pred_C = (1-epsilon).*IP.*delta1*NPop;
pred_C2 = (1-epsilon).*IP2.*delta1*NPop;
pred_C3 = (1-epsilon).*IP3.*delta1*NPop;
pred_C4 = (1-epsilon).*IP4.*delta1*NPop;
pred_C5 = (1-epsilon).*IP5.*delta1*NPop;
pred_C6 = (1-epsilon).*IP6.*delta1*NPop;
pred_C7 = (1-epsilon).*IP7.*delta1*NPop;
pred_C8 = (1-epsilon).*IP8.*delta1*NPop;

