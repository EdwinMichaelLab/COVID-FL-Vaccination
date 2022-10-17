    %% diff_eqn1.m:

% FUNCTION NAME:
%   diff_eqn1
%
% DESCRIPTION:
%   This function defines our system of ODEs that we are integrating
%   via ode45().
%
% INPUTS:
%   t: Array of timesteps.
%   pop0: Array of initial class values
%   P: Array of parameters.
%
% OUTPUT:
%   None.

function dPop = diff_eqn1(t,pop0,P)

%% Define variables
beta = P(1); % Original
alpha = P(2);
sigma = P(3);
rho = P(4);
gammaA = P(5);
gammaM = P(6);
gammaH = P(7);
gammaC = P(8);
delta1 = P(9);
delta2 = P(10);
delta3 = P(11);
m  = P(12);
lockdown_ratio = P(13);
epsilon = P(14);
x1 = P(15);
x2 = P(16);
x3 = P(17);
d = P(18);
q = 0; %start at zero, switch on after date. P(19);
quarantine_start = P(20);
z = P(21);
gammaQ = P(22);
deltaQ = P(23);
p = P(24);
beta2 = P(25); % Alpha
beta3 = P(26); % Delta
waning_period = P(27);
omicron_reduction = P(28);
beta4  =  P(29); % Omicron
beta5  =  P(30); % BA.2
k = P(31);
beta6 = P(32); % BA.4
beta7 = P(33); % BA.5

S = pop0(1);
E = pop0(2);
IA = pop0(3);
IP = pop0(4);
IM = pop0(5);
IH = pop0(6);
IC = pop0(7);
D = pop0(8);
R1 = pop0(9);
R2 = pop0(10);
V = pop0(11);
S2 = pop0(12);
R3 = pop0(13);
B = pop0(14);

% 2ND VARIANT (alpha)
E2 = pop0(15);
IA2 = pop0(16);
IP2 = pop0(17);
IM2 = pop0(18);
IH2 = pop0(19);
IC2 = pop0(20);
R4 = pop0(21);
D2 = pop0(22);

% 3RD VARIANT (delta)
E3 = pop0(23);
IA3 = pop0(24);
IP3 = pop0(25);
IM3 = pop0(26);
IH3 = pop0(27);
IC3 = pop0(28);
R5 = pop0(29);
D3 = pop0(30);

% 3rd booster
T = pop0(31);

% 4TH VARIANT (Omicron BA.1)
E4 = pop0(32);
IA4 = pop0(33);
IP4 = pop0(34);
IM4 = pop0(35);
IH4 = pop0(36);
IC4 = pop0(37);
R6 = pop0(38);
D4 = pop0(39);

% Waned-Immunity Booster
W = pop0(40);
W2 = pop0(41);
F = pop0(42);

% Vaccinated-Sus
VS = pop0(43);

% 5TH VARIANT (Omicron BA.2)
E5 = pop0(44);
IA5 = pop0(45);
IP5 = pop0(46);
IM5 = pop0(47);
IH5 = pop0(48);
IC5 = pop0(49);
R7 = pop0(50);
D5 = pop0(51);

% 6TH VARIANT (Omicron BA.4)
E6 = pop0(52);
IA6 = pop0(53);
IP6 = pop0(54);
IM6 = pop0(55);
IH6 = pop0(56);
IC6 = pop0(57);
R8 = pop0(58);
D6 = pop0(59);

% 5TH VARIANT (Omicron BA.5)
E7 = pop0(60);
IA7 = pop0(61);
IP7 = pop0(62);
IM7 = pop0(63);
IH7 = pop0(64);
IC7 = pop0(65);
R9 = pop0(66);
D7 = pop0(67);

% 8TH VARIANT (Hypothetical new variant)
E8 = pop0(68);
IA8 = pop0(69);
IP8 = pop0(70);
IM8 = pop0(71);
IH8 = pop0(72);
IC8 = pop0(73);
R10 = pop0(74);
D8 = pop0(75);

% Define Fixed Quarantine Parameters
f = 0.10;
vac_rate = 0; %(5% / day?)
boost_rate = 0.0476;
waning_factor = 0.10;

% Original
vac_efficacy = 0.75;
boost_efficacy = 0.90;
waning_efficacy = boost_efficacy - waning_factor;
third_boost_efficacy =  0.99;

% Alpha
vac_efficacy2 = 0.70;
boost_efficacy2 = 0.85;
waning_efficacy2 = boost_efficacy2 - waning_factor;
third_boost_efficacy2 =  0.99;

% Delta
vac_efficacy3 = 0.65;
boost_efficacy3 = 0.80;
waning_efficacy3 = boost_efficacy3 - waning_factor;
third_boost_efficacy3 =  0.99;

% Omicron (BA. 1)
% https://www.wsj.com/articles/first-big-omicron-study-finds-two-doses-of-pfizers-vaccine-cuts-hospitalization-risk-by-70-11639495432
vac_efficacy4 = 0.55;% V
boost_efficacy4 = 0.65; % B
waning_efficacy4 = boost_efficacy4 - waning_factor; % W
third_boost_efficacy4 =  0.80; % T
waning_efficacy4_2  =  0.65; % W2 45% efficacy to Omicron

% BA.2
vac_efficacy5 = vac_efficacy4;
boost_efficacy5 = boost_efficacy4;
waning_efficacy5 = boost_efficacy5 - waning_factor;
third_boost_efficacy5 =  third_boost_efficacy4;
waning_efficacy5_2  =  waning_efficacy4_2; % 45% efficacy to Omicron

% BA.4
vac_efficacy6 = vac_efficacy4;
boost_efficacy6 = boost_efficacy4;
waning_efficacy6 = boost_efficacy5 - waning_factor;
third_boost_efficacy6 =  third_boost_efficacy4;
waning_efficacy6_2  =  waning_efficacy4_2; % 45% efficacy to Omicron

% BA.5
vac_efficacy7 = vac_efficacy4;
boost_efficacy7 = boost_efficacy4;
waning_efficacy7 = boost_efficacy5 - waning_factor;
third_boost_efficacy7 =  third_boost_efficacy4;
waning_efficacy7_2  =  waning_efficacy4_2; % 45% efficacy to Omicron

% Hypothetical new variant
vac_efficacy8 = vac_efficacy4;
boost_efficacy8 = boost_efficacy4;
waning_efficacy8 = boost_efficacy5 - waning_factor;
third_boost_efficacy8 =  third_boost_efficacy4;
waning_efficacy8_2  =  waning_efficacy4_2; % 45% efficacy to Omicron

waning_rate2  =  1/(10*7); % 10 week waning period
IExtra = 0;

if t < 288 
    beta2 = 0;
    E2 = 0;
end

if t < 411 
    beta3 = 0;
    E3 = 0;
end

if t < 600
    beta4 = 0;
    E4 = 0;
elseif t > 679
    beta3 = 0;
    E3 = 0;
    beta2 = 0;
    E2 = 0;
    beta = 0;
    E = 0;
end
if t > 757
    beta4 = 0;
    E4 = 0;
end
if t < 686
    beta5 = 0;
    E5 = 0;
elseif t > 872
    beta5 = 0;
    E5 = 0;
end
if t < 760
    beta6 = 0;
    E6 = 0;
end
if t < 781
    beta7 = 0;
    E7 = 0;
end
beta5 = 0; E5 = 0;
beta6 = 0; E6 = 0;% BA.4
beta7 = 0; E7 = 0;% BA.5
beta8 = 0; E8 = 0;% 

% if t < 603 % 634: Dec 1, 603: Nov 1, 2x, 1.5x
%     beta4 = 0; E4 = 0;
%     beta5 = 0; E5 = 0;
% elseif t < 785 % 785: May 1, 846: July 1
%     beta4 = 2.0*mean([beta beta2 beta3]);
%     beta5 = 0; E5 = 0;
%     d = 1;
% else
%     beta4 = 2.0*mean([beta beta2 beta3]);
%     beta5 = 2.5*mean([beta beta2 beta3]);
%     d = 1;
% end





waning_rate_r = 1/(365*waning_period);
waning_rate_v = 1/(5*30);

% 
third_boost_rate = 0;
if t > 579 % Oct 1st, USA
    third_boost_rate = 1/30; % 6months total, 5 months waning, 1 month to T
end
fourth_boost_rate = 0;
alpha = 0;
lambda = 0;


%% Define differential equations for each compartment
dPop = zeros(length(pop0),1);
ci = 1-(R2*0.1);

% % Compute breakthrough percentage
total_i  = IA+IP+IM+IH+IC+IExtra;
total_i2 = IA2+IP2+IM2+IH2+IC2+IExtra;
total_i3 = IA3+IP3+IM3+IH3+IC3+IExtra;
total_i4 = IA4+IP4+IM4+IH4+IC4+IExtra;
total_i5 = IA5+IP5+IM5+IH5+IC5+IExtra;
total_i6 = IA6+IP6+IM6+IH6+IC6+IExtra;
total_i7 = IA7+IP7+IM7+IH7+IC7+IExtra;
total_i8 = IA8+IP8+IM8+IH8+IC8+IExtra;


S_cases  = d*beta*S*total_i + ci*d*beta2*S*total_i2 + ci*d*beta3*S*total_i3 + ci*d*beta4*S*total_i4 + ci*d*beta5*S*total_i5 + ci*d*beta6*S*total_i6 + ci*d*beta7*S*total_i7 + ci*d*beta8*S*total_i8;
S2_cases = d*beta*(S2)*total_i + ci*d*beta2*(S2)*total_i2 + ci*d*beta3*(S2)*total_i3 + ci*d*beta4*(S2)*total_i4 + ci*d*beta5*(S2)*total_i5 + ci*d*beta6*(S2)*total_i6 + ci*d*beta7*(S2)*total_i7 + ci*d*beta8*(S2)*total_i8;
V_cases  =  beta*d*V*(1-vac_efficacy)*total_i + ci*beta2*d*V*(1-vac_efficacy2)*total_i2 + ci*beta3*d*V*(1-vac_efficacy3)*total_i3 + ci*beta4*d*V*(1-vac_efficacy4)*total_i4 + ci*beta5*d*V*(1-vac_efficacy5)*total_i5 + ci*beta6*d*V*(1-vac_efficacy6)*total_i6 + ci*beta7*d*V*(1-vac_efficacy7)*total_i7 + ci*beta8*d*V*(1-vac_efficacy8)*total_i8;
B_cases  =  beta*d*B*(1-boost_efficacy)*total_i + ci*beta2*d*B*(1-boost_efficacy2)*total_i2 + ci*beta3*d*B*(1-boost_efficacy3)*total_i3 + ci*beta4*d*B*(1-boost_efficacy4)*total_i4 + ci*beta5*d*B*(1-boost_efficacy5)*total_i5 + ci*beta6*d*B*(1-boost_efficacy6)*total_i6 + ci*beta7*d*B*(1-boost_efficacy7)*total_i7 + ci*beta8*d*B*(1-boost_efficacy8)*total_i8;
T_cases  =  beta*d*T*(1-third_boost_efficacy)*total_i + ci*beta2*d*T*(1-third_boost_efficacy2)*total_i2 + ci*beta3*d*T*(1-third_boost_efficacy3)*total_i3 + ci*beta4*d*T*(1-third_boost_efficacy4)*total_i4 + ci*beta5*d*T*(1-third_boost_efficacy5)*total_i5 + ci*beta6*d*T*(1-third_boost_efficacy6)*total_i6 + ci*beta7*d*T*(1-third_boost_efficacy7)*total_i7 + ci*beta8*d*T*(1-third_boost_efficacy8)*total_i8;
W_cases  =  beta*d*W*(1-waning_efficacy)*total_i + ci*beta2*d*W*(1-waning_efficacy2)*total_i2 + ci*beta3*d*W*(1-waning_efficacy3)*total_i3 + ci*beta4*d*W*(1-waning_efficacy4)*total_i4 + ci*beta5*d*W*(1-waning_efficacy5)*total_i5 + ci*beta6*d*W*(1-waning_efficacy6)*total_i6 + ci*beta7*d*W*(1-waning_efficacy7)*total_i7 + ci*beta8*d*W*(1-waning_efficacy8)*total_i8;
W2_cases =  ci*beta4*d*W2*(1-waning_efficacy4_2)*total_i4 + ci*beta5*d*W2*(1-waning_efficacy5_2)*total_i5 + ci*beta6*d*W2*(1-waning_efficacy6_2)*total_i6 + ci*beta7*d*W2*(1-waning_efficacy7_2)*total_i7 + ci*beta8*d*W2*(1-waning_efficacy8_2)*total_i8;
total_cases = S_cases + S2_cases + V_cases + B_cases + T_cases + W_cases + W2_cases;

if total_cases == 0 
    waning_fractions = zeros(1,3);
else
    waning_fractions = [S_cases S2_cases V_cases+B_cases+T_cases+W_cases+W2_cases];
    waning_fractions = waning_fractions./total_cases;
end

dPop(1) = -d*beta*S*total_i - ci*d*beta2*S*total_i2 - ci*d*beta3*S*total_i3 - ci*d*beta4*S*total_i4 - ci*d*beta5*S*total_i5 - ci*d*beta6*S*total_i6 - ci*d*beta7*S*total_i7 - ci*d*beta8*S*total_i8 - alpha*S +lambda*R1 -  S*vac_rate + waning_fractions(1)*waning_rate_r*(R2+R4+R5+R6+R7+R8+R9+R10); % S
dPop(2) = d*beta*(S+S2+VS)*total_i - sigma*rho*E - sigma*(1-rho)*E + beta*d*V*(1-vac_efficacy)*total_i  + beta*d*B*(1-boost_efficacy)*total_i + beta*d*T*(1-third_boost_efficacy)*total_i  + beta*d*W*(1-waning_efficacy)*total_i; % E
dPop(3) = sigma*rho*E - gammaA*IA; % IA
dPop(4) = sigma*(1-rho)*E - delta1*IP; % IP
dPop(5) = delta1*IP - x1*delta2*IM - (1-x1)*gammaM*IM; % IM
dPop(6) = x1*delta2*IM - x2*delta3*IH - (1-x2)*gammaH*IH; % IH
dPop(7) = x2*delta3*IH - (1-x3)*gammaC*IC - x3*m*IC; % IC
dPop(8) = x3*m*IC; % D
dPop(9) = alpha*S - lambda*R1; % R1
dPop(10) = gammaA*IA + (1-x1)*gammaM*IM + (1-x2)*gammaH*IH + (1-x3)*gammaC*IC - R2*waning_rate_r; % R2
dPop(11) = S*vac_rate - beta*d*V*(1-vac_efficacy)*total_i - ci*beta2*d*V*(1-vac_efficacy2)*total_i2- ci*beta3*d*V*(1-vac_efficacy3)*total_i3 -  ci*beta4*d*V*(1-vac_efficacy4)*total_i4 -  ci*beta5*d*V*(1-vac_efficacy5)*total_i5 -  ci*beta6*d*V*(1-vac_efficacy6)*total_i6 -  ci*beta7*d*V*(1-vac_efficacy7)*total_i7 -  ci*beta8*d*V*(1-vac_efficacy8)*total_i8 - V*boost_rate; % V
dPop(12) = -d*beta*(S2)*total_i -ci*d*beta2*(S2)*total_i2 -ci*d*beta3*(S2)*total_i3 - ci*d*beta4*S2*total_i4  - alpha*S2 +lambda*R3 + waning_fractions(2)*waning_rate_r*(R2+R4+R5+R6+R7+R8+R9+R10) - ci*d*beta5*S2*total_i5 - ci*d*beta6*S2*total_i6 - ci*d*beta7*S2*total_i7 - ci*d*beta8*S2*total_i8;
dPop(13) = alpha*S2 -lambda*R3;
dPop(14) = V*boost_rate - beta*d*B*(1-boost_efficacy)*total_i - ci*beta2*d*B*(1-boost_efficacy2)*total_i2 - ci*beta3*d*B*(1-boost_efficacy3)*total_i3 - ci*beta4*d*B*(1-boost_efficacy4)*total_i4 - ci*beta5*d*B*(1-boost_efficacy5)*total_i5 - ci*beta6*d*B*(1-boost_efficacy6)*total_i6 - ci*beta7*d*B*(1-boost_efficacy7)*total_i7 - ci*beta8*d*B*(1-boost_efficacy8)*total_i8 -  waning_rate_v*B - third_boost_rate*B;

% 2ND VARIANT:
dPop(15) = ci*d*beta2*(S+S2+VS)*total_i2 - sigma*rho*E2 - sigma*(1-rho)*E2 + ci*beta2*d*V*(1-vac_efficacy2)*total_i2  + ci*beta2*d*B*(1-boost_efficacy2)*total_i2 +  ci*beta2*d*T*(1-third_boost_efficacy2)*total_i2 + ci*beta2*d*W*(1-waning_efficacy2)*total_i2; % E
dPop(16) = sigma*rho*E2 - gammaA*IA2; % IA
dPop(17) = sigma*(1-rho)*E2 - delta1*IP2; % IP
dPop(18) = delta1*IP2 - x1*delta2*IM2 - (1-x1)*gammaM*IM2; % IM
dPop(19) = x1*delta2*IM2 - x2*delta3*IH2 - (1-x2)*gammaH*IH2; % IH
dPop(20) = x2*delta3*IH2 - (1-x3)*gammaC*IC2 - x3*m*IC2; % IC
dPop(21) = gammaA*IA2 + (1-x1)*gammaM*IM2 + (1-x2)*gammaH*IH2 + (1-x3)*gammaC*IC2 - R4*waning_rate_r;% R2
dPop(22) = x3*m*IC2; % D4

% 3RD VARIANT:
dPop(23) = ci*d*beta3*(S+S2+VS)*total_i3 - sigma*rho*E3 - sigma*(1-rho)*E3 + ci*beta3*d*V*(1-vac_efficacy3)*total_i3  + ci*beta3*d*B*(1-boost_efficacy3)*total_i3 + ci*beta3*d*T*(1-third_boost_efficacy3)*total_i3 + ci*beta3*d*W*(1-waning_efficacy3)*total_i3; % E
dPop(24) = sigma*rho*E3 - gammaA*IA3; % IA 
dPop(25) = sigma*(1-rho)*E3 - delta1*IP3; % IP
dPop(26) = delta1*IP3 - x1*delta2*IM3 - (1-x1)*gammaM*IM3; % IM
dPop(27) = x1*delta2*IM3 - x2*delta3*IH3 - (1-x2)*gammaH*IH3; % IH
dPop(28) = x2*delta3*IH3 - (1-x3)*gammaC*IC3 - x3*m*IC3; % IC
dPop(29) = gammaA*IA3 + (1-x1)*gammaM*IM3 + (1-x2)*gammaH*IH3 + (1-x3)*gammaC*IC3 - R5*waning_rate_r; % R2
dPop(30) = x3*m*IC3; % D4

% Booster
dPop(31) = third_boost_rate*(W+B) - beta*d*T*(1-third_boost_efficacy)*total_i - ci*beta2*d*T*(1-third_boost_efficacy2)*total_i2 - ci*beta3*d*T*(1-third_boost_efficacy3)*total_i3- ci*beta4*d*T*(1-third_boost_efficacy4)*total_i4 - ci*beta5*d*T*(1-third_boost_efficacy5)*total_i5 - ci*beta6*d*T*(1-third_boost_efficacy6)*total_i6 - ci*beta7*d*T*(1-third_boost_efficacy7)*total_i7 - ci*beta8*d*T*(1-third_boost_efficacy8)*total_i8 - waning_rate2*T;

% 4TH VARIANT:
dPop(32) = ci*d*beta4*(S+S2+VS)*total_i4 - sigma*rho*E4 - sigma*(1-rho)*E4 + ci*beta4*d*V*(1-vac_efficacy4)*total_i4  + ci*beta4*d*B*(1-boost_efficacy4)*total_i4 + ci*beta4*d*T*(1-third_boost_efficacy4)*total_i4 + ci*beta4*d*W*(1-waning_efficacy4)*total_i4 + ci*beta4*d*W2*(1-waning_efficacy4_2)*total_i4; % + waning_fractions(4)*waning_rate_r*(R2+R4+R5+R6); % E
dPop(33) = sigma*rho*E4 - gammaA*IA4; % IA 
dPop(34) = sigma*(1-rho)*E4 - delta1*IP4; % IP
dPop(35) = delta1*IP4 - (1-omicron_reduction)*x1*delta2*IM4 - (1-x1)*gammaM*IM4; % IM
dPop(36) = (1-omicron_reduction)*x1*delta2*IM4 - x2*delta3*IH4 - (1-x2)*gammaH*IH4; % IH
dPop(37) = x2*delta3*IH4 - (1-x3)*gammaC*IC4 - x3*m*IC4; % IC
dPop(38) = gammaA*IA4 + (1-x1)*gammaM*IM4 + (1-x2)*gammaH*IH4 + (1-x3)*gammaC*IC4 - R6*waning_rate_r; % R2
dPop(39) = x3*m*IC4; % D4

dPop(40) = waning_rate_v*B - third_boost_rate*W - beta*d*W*(1-waning_efficacy)*total_i - ci*beta2*d*W*(1-waning_efficacy2)*total_i2 - ci*beta3*d*W*(1-waning_efficacy3)*total_i3 - ci*beta4*d*W*(1-waning_efficacy4)*total_i4 - ci*beta5*d*W*(1-waning_efficacy5)*total_i5 - ci*beta6*d*W*(1-waning_efficacy6)*total_i6 - ci*beta7*d*W*(1-waning_efficacy7)*total_i7 - ci*beta8*d*W*(1-waning_efficacy8)*total_i8;
dPop(41) = waning_rate2*T - ci*beta4*d*W2*(1-waning_efficacy4_2)*total_i4 - fourth_boost_rate*W2 - ci*beta5*d*W2*(1-waning_efficacy5_2)*total_i5 - ci*beta6*d*W2*(1-waning_efficacy6_2)*total_i6 - ci*beta7*d*W2*(1-waning_efficacy7_2)*total_i7 - ci*beta8*d*W2*(1-waning_efficacy8_2)*total_i8;
dPop(42) = fourth_boost_rate*W2;

dPop(43) = waning_fractions(3)*waning_rate_r*(R2+R4+R5+R6+R7+R8+R9+R10) - d*beta*VS*total_i - ci*d*beta2*VS*total_i2 - ci*d*beta3*VS*total_i3 - ci*d*beta4*VS*total_i4 - ci*d*beta5*VS*total_i5 - ci*d*beta6*VS*total_i6 - ci*d*beta7*VS*total_i7 - ci*d*beta8*VS*total_i8; %VS


% 5TH VARIANT:
dPop(44) = ci*d*beta5*(S+S2+VS)*total_i5 - sigma*rho*E5 - sigma*(1-rho)*E5 + ci*beta5*d*V*(1-vac_efficacy5)*total_i5  + ci*beta5*d*B*(1-boost_efficacy5)*total_i5 + ci*beta5*d*T*(1-third_boost_efficacy5)*total_i5 + ci*beta5*d*W*(1-waning_efficacy5)*total_i5 + ci*beta5*d*W2*(1-waning_efficacy5_2)*total_i5;
dPop(45) = sigma*rho*E5 - gammaA*IA5; % IA 
dPop(46) = sigma*(1-rho)*E5 - delta1*IP5; % IP
dPop(47) = delta1*IP5 - (1-omicron_reduction)*x1*delta2*IM5 - (1-x1)*gammaM*IM5; % IM
dPop(48) = (1-omicron_reduction)*x1*delta2*IM5 - x2*delta3*IH5 - (1-x2)*gammaH*IH5; % IH
dPop(49) = x2*delta3*IH5 - (1-x3)*gammaC*IC5 - x3*m*IC5; % IC
dPop(50) = gammaA*IA5 + (1-x1)*gammaM*IM5 + (1-x2)*gammaH*IH5 + (1-x3)*gammaC*IC5 - R7*waning_rate_r; % R2
dPop(51) = x3*m*IC5; % D4

% 6TH VARIANT:
dPop(52) = ci*d*beta6*(S+S2+VS)*total_i6 - sigma*rho*E6 - sigma*(1-rho)*E6 + ci*beta6*d*V*(1-vac_efficacy6)*total_i6  + ci*beta6*d*B*(1-boost_efficacy6)*total_i6 + ci*beta6*d*T*(1-third_boost_efficacy6)*total_i6 + ci*beta6*d*W*(1-waning_efficacy6)*total_i6 + ci*beta6*d*W2*(1-waning_efficacy6_2)*total_i6;
dPop(53) = sigma*rho*E6 - gammaA*IA6; % IA 
dPop(54) = sigma*(1-rho)*E6 - delta1*IP6; % IP
dPop(55) = delta1*IP6 - (1-omicron_reduction)*x1*delta2*IM6 - (1-x1)*gammaM*IM6; % IM
dPop(56) = (1-omicron_reduction)*x1*delta2*IM6 - x2*delta3*IH6 - (1-x2)*gammaH*IH6; % IH
dPop(57) = x2*delta3*IH6 - (1-x3)*gammaC*IC6 - x3*m*IC6; % IC
dPop(58) = gammaA*IA6 + (1-x1)*gammaM*IM6 + (1-x2)*gammaH*IH6 + (1-x3)*gammaC*IC6 - R8*waning_rate_r; % R2
dPop(59) = x3*m*IC6; % D8

% 7TH VARIANT:
dPop(60) = ci*d*beta7*(S+S2+VS)*total_i7 - sigma*rho*E7 - sigma*(1-rho)*E7 + ci*beta7*d*V*(1-vac_efficacy7)*total_i7  + ci*beta7*d*B*(1-boost_efficacy7)*total_i7 + ci*beta7*d*T*(1-third_boost_efficacy7)*total_i7 + ci*beta7*d*W*(1-waning_efficacy7)*total_i7 + ci*beta7*d*W2*(1-waning_efficacy7_2)*total_i7;
dPop(61) = sigma*rho*E7 - gammaA*IA7; % IA 
dPop(62) = sigma*(1-rho)*E7 - delta1*IP7; % IP
dPop(63) = delta1*IP7 - (1-omicron_reduction)*x1*delta2*IM7 - (1-x1)*gammaM*IM7; % IM
dPop(64) = (1-omicron_reduction)*x1*delta2*IM7 - x2*delta3*IH7 - (1-x2)*gammaH*IH7; % IH
dPop(65) = x2*delta3*IH7 - (1-x3)*gammaC*IC7 - x3*m*IC7; % IC
dPop(66) = gammaA*IA7 + (1-x1)*gammaM*IM7 + (1-x2)*gammaH*IH7 + (1-x3)*gammaC*IC7 - R9*waning_rate_r; % R2
dPop(67) = x3*m*IC7; % D4

% 8TH VARIANT:
dPop(68) = ci*d*beta8*(S+S2+VS)*total_i8 - sigma*rho*E8 - sigma*(1-rho)*E8 + ci*beta8*d*V*(1-vac_efficacy8)*total_i8  + ci*beta8*d*B*(1-boost_efficacy8)*total_i8 + ci*beta8*d*T*(1-third_boost_efficacy8)*total_i8 + ci*beta8*d*W*(1-waning_efficacy8)*total_i8 + ci*beta8*d*W2*(1-waning_efficacy8_2)*total_i8;
dPop(69) = sigma*rho*E8 - gammaA*IA8; % IA 
dPop(70) = sigma*(1-rho)*E8 - delta1*IP8; % IP
dPop(71) = delta1*IP8 - (1-omicron_reduction)*x1*delta2*IM8 - (1-x1)*gammaM*IM8; % IM
dPop(72) = (1-omicron_reduction)*x1*delta2*IM8 - x2*delta3*IH8 - (1-x2)*gammaH*IH8; % IH
dPop(73) = x2*delta3*IH8 - (1-x3)*gammaC*IC8 - x3*m*IC8; % IC
dPop(74) = gammaA*IA8 + (1-x1)*gammaM*IM8 + (1-x2)*gammaH*IH8 + (1-x3)*gammaC*IC8 - R10*waning_rate_r; % R2
dPop(75) = x3*m*IC8; % D4

end
