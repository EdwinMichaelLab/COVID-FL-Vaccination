%% SEIR_covid_model.m:

% FUNCTION NAME:
%   SEIR_covid_model
%
% DESCRIPTION:
%   This is a helper function for getting the model ready for ode45().
%
% INPUTS:
%   ParamSets: Array of sampled parameters.
%   NPop: Integer, population size
%   MaxTime: Integer, how far to integrate
%   lockdown: Integer, how long to be under lockdown.
%
% OUTPUT:
%   Arrays containing the class values as a function of time.


function [S_out,E_out,IA_out,IP_out,IM_out,IH_out,IC_out,D_out,R1_out,...
		R2_out,V_out,S2_out,R3_out,B_out,E2_out,IA2_out,IP2_out,IM2_out,...
        IH2_out,IC2_out,R4_out,D2_out,E3_out,IA3_out,IP3_out,IM3_out,...
        IH3_out,IC3_out,R5_out,D3_out,T_out,E4_out,IA4_out,IP4_out,IM4_out,...
        IH4_out,IC4_out,R6_out,D4_out,W_out,W2_out,F_out,VS_out,E5_out,IA5_out,IP5_out,IM5_out,...
        IH5_out,IC5_out,R7_out,D5_out,...
        E6_out,IA6_out,IP6_out,IM6_out,IH6_out,IC6_out,R8_out,D6_out,...
        E7_out,IA7_out,IP7_out,IM7_out,IH7_out,IC7_out,R9_out,D7_out,...
        E8_out,IA8_out,IP8_out,IM8_out,IH8_out,IC8_out,R10_out,D8_out] = SEIR_covid_model2(ParamSets,NPop,...
    S0,E0,IA0,IP0,IM0,IH0,IC0,D0,R10,R20,...
    V0,S20,R30,B0,E20,IA20,IP20,IM20,IH20,IC20,R40,D20,...
    E30,IA30,IP30,IM30,IH30,IC30,R50,D30,T0,E40,IA40,IP40,...
    IM40,IH40,IC40,R60,D40,W0,W20,F0,VS0,E50,IA50,IP50,IM50,IH50,IC50,R70,D50,...
    E60,IA60,IP60,IM60,IH60,IC60,R80,D60,...
    E70,IA70,IP70,IM70,IH70,IC70,R90,D70,...
    E80,IA80,IP80,IM80,IH80,IC80,R100,D80,...
    StartTime,MaxTime,...
    q,quarantine_start,vac_start,goog,prog_flag,M,mr,vacdata,prog_steps)

%% Initialize simulation

% Set initial compartment values, now passed to integrator

% initialize output arrays

S_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
E_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
IA_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
IP_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
IM_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
IH_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
IC_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
D_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
R1_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
R2_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
V_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
S2_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
R3_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
B_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));

E2_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
IA2_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
IP2_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
IM2_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
IH2_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
IC2_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
R4_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
D2_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));

E3_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
IA3_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
IP3_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
IM3_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
IH3_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
IC3_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
R5_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
D3_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));

T_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));

E4_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
IA4_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
IP4_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
IM4_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
IH4_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
IC4_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
R6_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
D4_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));

W_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
W2_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
F_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
VS_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));

E5_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
IA5_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
IP5_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
IM5_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
IH5_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
IC5_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
R7_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
D5_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));

E6_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
IA6_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
IP6_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
IM6_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
IH6_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
IC6_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
R8_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
D6_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));

E7_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
IA7_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
IP7_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
IM7_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
IH7_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
IC7_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
R9_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
D7_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));

E8_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
IA8_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
IP8_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
IM8_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
IH8_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
IC8_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
R10_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));
D8_out = zeros(MaxTime - StartTime + 1,length(ParamSets(1,:)));

% calculate value to scale progress counts 
pstep = floor(length(ParamSets(1,:)) / prog_steps);


% timing
simu_clk = zeros(1,length(ParamSets(1,:)));

%% Loop through calculations for each parameter set
% can run in parallel for faster computation
parfor (i = 1:length(ParamSets(1,:)), M)
%for i = 1:length(ParamSets(1,:))
    % time loop start
    simu_clk_strt = tic;
    
    %printout progress periodically to 
    %tell web service how far we have progressed
    if prog_flag & mod(i,pstep) == 0
        disp('progress')
    end

    % pull out one set of parameters
    P = ParamSets(:,i); 
    
    
    % numerically integrate the differential equations
    options = odeset('RelTol', 1e-5);
    [t, pop] = ode45(@diff_eqn2,StartTime:1:MaxTime,...
        [S0(i),E0(i),IA0(i),IP0(i),IM0(i),IH0(i),IC0(i),D0(i),...
		R10(i),R20(i),V0(i),S20(i),R30(i),B0(i),E20(i),IA20(i),IP20(i),...
		IM20(i),IH20(i),IC20(i),R40(i),D20(i),E30(i),IA30(i),IP30(i),...
		IM30(i),IH30(i),IC30(i),R50(i),D30(i),T0(i), ...
        E40(i),IA40(i),IP40(i),IM40(i),IH40(i),IC40(i),...
        R60(i),D40(i),W0(i),W20(i),F0(i),VS0(i),E50(i),IA50(i),IP50(i),IM50(i),IH50(i),IC50(i),...
        R70(i),D50(i)...
        E60(i),IA60(i),IP60(i),IM60(i),IH60(i),IC60(i),R80(i),D60(i)...
        E70(i),IA70(i),IP70(i),IM70(i),IH70(i),IC70(i),R90(i),D70(i),...
        E80(i),IA80(i),IP80(i),IM80(i),IH80(i),IC80(i),R100(i),D80(i)],...
        options,...
       [P(1:18)',q,quarantine_start,P(20:32)',vac_start,goog]);
   
    % store the predictions for each compartment for each parameter set

    if MaxTime-StartTime == 1
        S_out(:,i) = [pop(1,1) pop(end,1)];
        E_out(:,i) = [pop(1,2) pop(end,2)];
        IA_out(:,i) = [pop(1,3) pop(end,3)];
        IP_out(:,i) = [pop(1,4) pop(end,4)];
        IM_out(:,i) = [pop(1,5) pop(end,5)];
        IH_out(:,i) = [pop(1,6) pop(end,6)];
        IC_out(:,i) = [pop(1,7) pop(end,7)];
        D_out(:,i) = [pop(1,8) pop(end,8)];
        R1_out(:,i) = [pop(1,9) pop(end,9)];
        R2_out(:,i) = [pop(1,10) pop(end,10)];
        V_out(:,i) = [pop(1,11) pop(end,11)];
        S2_out(:,i) = [pop(1,12) pop(end,12)];  
        R3_out(:,i) = [pop(1,13) pop(end,13)];
        B_out(:,i)  = [pop(1,14) pop(end,14)];

        E2_out(:,i) = [pop(1,15) pop(end,15)];
        IA2_out(:,i) = [pop(1,16) pop(end,16)];
        IP2_out(:,i) = [pop(1,17) pop(end,17)];
        IM2_out(:,i) = [pop(1,18) pop(end,18)];
        IH2_out(:,i) = [pop(1,19) pop(end,19)];
        IC2_out(:,i) = [pop(1,20) pop(end,20)];
        R4_out(:,i) = [pop(1,21) pop(end,21)];
        D2_out(:,i) = [pop(1,22) pop(end,22)];

        E3_out(:,i) = [pop(1,23) pop(end,23)];
        IA3_out(:,i) = [pop(1,24) pop(end,24)];
        IP3_out(:,i) = [pop(1,25) pop(end,25)];
        IM3_out(:,i) = [pop(1,26) pop(end,26)];
        IH3_out(:,i) = [pop(1,27) pop(end,27)];
        IC3_out(:,i) = [pop(1,28) pop(end,28)];
        R5_out(:,i) = [pop(1,29) pop(end,29)];
        D3_out(:,i) = [pop(1,30) pop(end,30)];

        T_out(:,i) = [pop(1,31) pop(end,31)];

        E4_out(:,i) = [pop(1,32) pop(end,32)];
        IA4_out(:,i) = [pop(1,33) pop(end,33)];
        IP4_out(:,i) = [pop(1,34) pop(end,34)];
        IM4_out(:,i) = [pop(1,35) pop(end,35)];
        IH4_out(:,i) = [pop(1,36) pop(end,36)];
        IC4_out(:,i) = [pop(1,37) pop(end,37)];
        R6_out(:,i) = [pop(1,38) pop(end,38)];
        D4_out(:,i) = [pop(1,39) pop(end,39)];

        W_out(:,i) = [pop(1,40) pop(end,40)];
        W2_out(:,i) = [pop(1,41) pop(end,41)];
        F_out(:,i) = [pop(1,42) pop(end,42)];
        VS_out(:,i) = [pop(1,43) pop(end,43)];

        E5_out(:,i) = [pop(1,44) pop(end,44)];
        IA5_out(:,i) = [pop(1,45) pop(end,45)];
        IP5_out(:,i) = [pop(1,46) pop(end,46)];
        IM5_out(:,i) = [pop(1,47) pop(end,47)];
        IH5_out(:,i) = [pop(1,48) pop(end,48)];
        IC5_out(:,i) = [pop(1,49) pop(end,49)];
        R7_out(:,i) = [pop(1,50) pop(end,50)];
        D5_out(:,i) = [pop(1,51) pop(end,51)];

        E6_out(:,i) = [pop(1,52) pop(end,52)];
        IA6_out(:,i) = [pop(1,53) pop(end,53)];
        IP6_out(:,i) = [pop(1,54) pop(end,54)];
        IM6_out(:,i) = [pop(1,55) pop(end,55)];
        IH6_out(:,i) = [pop(1,56) pop(end,56)];
        IC6_out(:,i) = [pop(1,57) pop(end,57)];
        R8_out(:,i) = [pop(1,58) pop(end,58)];
        D6_out(:,i) = [pop(1,59) pop(end,59)];

        E7_out(:,i) = [pop(1,60) pop(end,60)];
        IA7_out(:,i) = [pop(1,61) pop(end,61)];
        IP7_out(:,i) = [pop(1,62) pop(end,62)];
        IM7_out(:,i) = [pop(1,63) pop(end,63)];
        IH7_out(:,i) = [pop(1,64) pop(end,64)];
        IC7_out(:,i) = [pop(1,65) pop(end,65)];
        R9_out(:,i) = [pop(1,66) pop(end,66)];
        D7_out(:,i) = [pop(1,67) pop(end,67)];


        E8_out(:,i) = [pop(1,68) pop(end,68)];
        IA8_out(:,i) = [pop(1,69) pop(end,69)];
        IP8_out(:,i) = [pop(1,70) pop(end,70)];
        IM8_out(:,i) = [pop(1,71) pop(end,71)];
        IH8_out(:,i) = [pop(1,72) pop(end,72)];
        IC8_out(:,i) = [pop(1,73) pop(end,73)];
        R10_out(:,i) = [pop(1,74) pop(end,74)];
        D8_out(:,i) = [pop(1,75) pop(end,75)];
    else
        S_out(:,i) = pop(:,1);
        E_out(:,i) = pop(:,2);
        IA_out(:,i) = pop(:,3);
        IP_out(:,i) = pop(:,4);
        IM_out(:,i) = pop(:,5);
        IH_out(:,i) = pop(:,6);
        IC_out(:,i) = pop(:,7);
        D_out(:,i) = pop(:,8);
        R1_out(:,i) = pop(:,9);
        R2_out(:,i) = pop(:,10);
        V_out(:,i) = pop(:,11);
        S2_out(:,i) = pop(:,12);    
        R3_out(:,i) = pop(:,13);
        B_out(:,i)  = pop(:,14);

        E2_out(:,i) = pop(:,15);
        IA2_out(:,i) = pop(:,16);
        IP2_out(:,i) = pop(:,17);
        IM2_out(:,i) = pop(:,18);
        IH2_out(:,i) = pop(:,19);
        IC2_out(:,i) = pop(:,20);
        R4_out(:,i) = pop(:,21);
        D2_out(:,i) = pop(:,22);

        E3_out(:,i) = pop(:,23);
        IA3_out(:,i) = pop(:,24);
        IP3_out(:,i) = pop(:,25);
        IM3_out(:,i) = pop(:,26);
        IH3_out(:,i) = pop(:,27);
        IC3_out(:,i) = pop(:,28);
        R5_out(:,i) = pop(:,29);
        D3_out(:,i) = pop(:,30);

        T_out(:,i) = pop(:,31);

        E4_out(:,i) = pop(:,32);
        IA4_out(:,i) = pop(:,33);
        IP4_out(:,i) = pop(:,34);
        IM4_out(:,i) = pop(:,35);
        IH4_out(:,i) = pop(:,36);
        IC4_out(:,i) = pop(:,37);
        R6_out(:,i) = pop(:,38);
        D4_out(:,i) = pop(:,39);

        W_out(:,i) = pop(:,40);
        W2_out(:,i) = pop(:,41);
        F_out(:,i) = pop(:,42);
        VS_out(:,i) = pop(:,43);

        E5_out(:,i) = pop(:,44);
        IA5_out(:,i) = pop(:,45);
        IP5_out(:,i) = pop(:,46);
        IM5_out(:,i) = pop(:,47);
        IH5_out(:,i) = pop(:,48);
        IC5_out(:,i) = pop(:,49);
        R7_out(:,i) = pop(:,50);
        D5_out(:,i) = pop(:,51);

        E6_out(:,i) = pop(:,52);
        IA6_out(:,i) = pop(:,53);
        IP6_out(:,i) = pop(:,54);
        IM6_out(:,i) = pop(:,55);
        IH6_out(:,i) = pop(:,56);
        IC6_out(:,i) = pop(:,57);
        R8_out(:,i) = pop(:,58);
        D6_out(:,i) = pop(:,59);

        E8_out(:,i) = pop(:,68);
        IA8_out(:,i) = pop(:,69);
        IP8_out(:,i) = pop(:,70);
        IM8_out(:,i) = pop(:,71);
        IH8_out(:,i) = pop(:,72);
        IC8_out(:,i) = pop(:,73);
        R10_out(:,i) = pop(:,74);
        D8_out(:,i) = pop(:,75);
    end

    %time loop end
    simu_clk(i) = toc(simu_clk_strt);
    
end

%print compute time
disp("ODE compute time: " + (mean(simu_clk) * length(ParamSets(1,:))) + " seconds, max " + max(simu_clk) + " seconds.");

end
