starting_date = length(timeRef);
for day_segment=starting_date:(MaxTime-2)
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
    W20 = W2(:,id);
    F0 = F(:,id);

    VS0 = VS(:, id);

    E50 = E5(:,id); IA50 = IA5(:,id); IP50 = IP5(:,id); IM50 = IM5(:,id); 
    IH50 = IH5(:, id); IC50 = IC5(:,id); R70 = R7(:,id);D50 = D5(:,id);

    E60 = E6(:,id); IA60 = IA6(:,id); IP60 = IP6(:,id); IM60 = IM6(:,id); 
    IH60 = IH6(:, id); IC60 = IC6(:,id); R80 = R8(:,id);D60 = D6(:,id);
    
    E70 = E7(:,id); IA70 = IA7(:,id); IP70 = IP7(:,id); IM70 = IM7(:,id); 
    IH70 = IH7(:, id); IC70 = IC7(:,id); R90 = R9(:,id);D70 = D7(:,id);
    
    E80 = E8(:,id); IA80 = IA8(:,id); IP80 = IP8(:,id); IM80 = IM8(:,id); 
    IH80 = IH8(:, id); IC80 = IC8(:,id); R100 = R10(:,id);D80 = D8(:,id);

    goog = google_vals(end);

%     if day_segment > 672 && day_segment < 679
%         oldparams = ParamSets;
%         load("2022_01_20/96Florida_7day_latest.mat", "ParamSets");
%         newparams = ParamSets;
%         ParamSets = oldparams;
%         ParamSets(18, :) = newparams(18, :);
%     else
%         oldparams = ParamSets;
%         load("2022_01_20/final_Florida_7day_latest.mat", "ParamSets");
%         newparams = ParamSets;
%         ParamSets = oldparams;
%         ParamSets(18, :) = newparams(18, :);
%     end
    [S,E,IA,IP,IM,IH,IC,D,R1,R2,V,S2,R3,B,E2,IA2,IP2,IM2,IH2,IC2,R4,D2,E3,IA3,IP3,IM3,IH3,IC3,R5,D3,...
        T,E4,IA4,IP4,IM4,IH4,IC4,R6,D4,W,W2,F,VS,E5,IA5,IP5,IM5,IH5,IC5,R7,D5,...
        E6,IA6,IP6,IM6,IH6,IC6,R8,D6,E7,IA7,IP7,IM7,IH7,IC7,R9,D7,...
        E8,IA8,IP8,IM8,IH8,IC8,R10,D8] = SEIR_covid_model2(ParamSets,NPop,...
        S0(end,:),E0(end,:),IA0(end,:),IP0(end,:),IM0(end,:),IH0(end,:),IC0(end,:),D0(end,:),R10(end,:),R20(end,:),...
        V0(end,:),S20(end,:),R30(end,:),B0(end,:),E20(end,:),IA20(end,:),IP20(end,:),IM20(end,:), ...
	IH20(end,:),IC20(end,:),R40(end,:),D20(end,:),E30(end,:),IA30(end,:),IP30(end,:),IM30(end,:), ...
    IH30(end,:),IC30(end,:),R50(end,:),D30(end,:),T0(end,:),E40(end,:),IA40(end,:),IP40(end,:),IM40(end,:), ...
    IH40(end,:),IC40(end,:),R60(end,:),D40(end,:),W0(end,:),W20(end,:),F0(end,:),VS0(end,:),E50(end,:),...
    IA50(end,:),IP50(end,:),IM50(end,:), ...
    IH50(end,:),IC50(end,:),R70(end,:),D50(end,:), ...
    E60(end,:),IA60(end,:),IP60(end,:),IM60(end,:), IH60(end,:),IC60(end,:),R80(end,:),D60(end,:), ...
    E70(end,:),IA70(end,:),IP70(end,:),IM70(end,:), IH70(end,:),IC70(end,:),R90(end,:),D70(end,:),...
    E80(end,:),IA80(end,:),IP80(end,:),IM80(end,:), IH80(end,:),IC80(end,:),R100(end,:),D80(end,:),day_segment,day_segment+1,q,quarantine_start, ...
    vac_start,goog,prog_flag,M,mr,vacdata,prog_steps);
    
% prepend IC, the first point is at t0
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



%     % Correct S, V for vaccination.
%     rels = [410 441 471 502 533];
%     if day_segment > rels(1)
%         total = 0;
%     else
%         total = 0.5*vacdata(end,2);

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

pred_D = x3.*m.*(IC+IC2+IC3+IC4+IC5)*NPop;
pred_C = (1-epsilon).*IP.*delta1*NPop;
pred_C2 = (1-epsilon).*IP2.*delta1*NPop;
pred_C3 = (1-epsilon).*IP3.*delta1*NPop;
pred_C4 = (1-epsilon).*IP4.*delta1*NPop;
pred_C5 = (1-epsilon).*IP5.*delta1*NPop;
pred_C6 = (1-epsilon).*IP6.*delta1*NPop;
pred_C7 = (1-epsilon).*IP7.*delta1*NPop;
pred_C8 = (1-epsilon).*IP8.*delta1*NPop;

