# Project Guide
This repository stores the code, equations, and parameters associated with the Michael Group SEIR multi-variant model with vaccination, applied to the State of Florida.

### Data Sources

The following data repositories are used to fit the base model:
1. [Coronavirus.app](https://coronavirus.app/tracking/florida) - Provides daily confirmed case, death, and vaccination data.
2. [The Helix COVID-19 Surveillance Dashboard](https://www.helix.com/pages/helix-covid-19-surveillance-dashboard) - Provides genetic surveillance for the US, including the proportion of Alpha and Delta variant cases over time.
3. [Unacast Covid-19 Social Distancing Scoreboard](https://www.unacast.com/covid19/social-distancing-scoreboard) - Provides GPS Mobility Data in Florida, which is used to inform lockdown measures (classes M<sub>1</sub> and M<sub>2</sub>).
4. [Google Trends](https://trends.google.com/trends/explore?date=2020-03-01%202021-10-25&geo=US-FL&q=covid) - Provides the popularity of a given Google Search query, which is used to provide the priors of the social distancing parameter, `d`.

### Fitting and running the base scenario
The repository comes with all of the data needed to fit the base model. Florida's daily case, death, and vaccination data up to
September 24th can be found in `Florida.csv`. The fitting procedure is run via the script `Main.m`:

`matlab -nodisplay -nosplash < Main.m`

This will produce output `Florida.mat`, which contains the predictions of all
state functions until the end of the year. With this file loaded, you can plot
median proportion of people with vaccine-induced immunity using the following code:

`plot(median(V+B, 2));`

Other state functions can be visualized similarly.

### Scenarios (Social Measures, Vaccination, Waning Immunity)

After running the base fit, we can run various mitigation strategies going into the future. To do this, load `final_Florida.mat` which contains the state of the simulation at the end of the fitting window.
To simulate a full release of social measures, add `d = 1` to `diff_eqn1.m`, just before the definitions of the differential
equations.

To increase/decrease the vaccination rate, adjust line 444 in
`BM_SEIR_model.m`. For instance, to double the vaccination rate
going forward:

`totalv = 1.5*mean(Vaccinated(end-7:end));`

This would apply 1.5 times the average daily vaccination rate over the
last 7 days.

### Model Description

In this study, we simulated the ongoing SARS-CoV-2 outbreak in the State of Florida using a variation of an SEIR model described in detail in Newcomb and colleagues. The ordinary differential equations (ODEs) describing the model are given fully below. Briefly, we assume Florida is a closed population and ignore demographic changes such that the total population size remains constant. The population is divided into compartments representing various infection stages: susceptible (S), exposed (E), infectious asymptomatic (IA), infectious pre-symptomatic (IP), infectious with mild symptoms (IM), infectious with severe symptoms requiring hospitalization (IH), infectious with severe symptoms requiring intensive care including ventilation (IC), recovered and immune (R), first-dose vaccinated (V), completely vaccinated (B), waned-immunity (W) and deceased (D). We further consider that a fraction (conservatively set at 10%) of the susceptible population, S, will refuse vaccinations, and we simply move this fraction to a new class (S2) that otherwise behave like S. Both susceptible classes can move into lockdown states M<sub>1</sub> and M<sub>2</sub>.

Three variants are explicitly modeled: the alpha variant (B.1.1.7), the delta variant (B.1.617.2), and all other variants including the original strain. The daily confirmed cases in Florida are multiplied by the proportions of the variants as given by the Helix dataset. This allows us to estimate the transmission rates of each variant over time.

The specific transitions and rate parameters governing the evolution of the system, along with their prior and posterior fitted values, are described in the Table below. For information regarding parameter estimation, refer to the Methods section of the paper. The strength of social distancing measures as a result of public health policies to limit contacts is captured through the estimation of a scaling factor, d, which is in turn multiplied by the transmission rate, beta, to obtain the population-level transmission intensity operational at any given time in each population. This factor accounts for the transmission modifying effects of mask wearing, reductions in mobility and mixing, work from home, and any other deviations from the normal social behavior of each population prior to the epidemic.

The vaccination data for Florida is directly applied by moving the proportion of the population that is vaccinated over a 10- day block from the S class to the V (1st dose) class. Individuals then move from the V to the B (2nd dose booster) class at a daily rate approximating a 21 day interval between vaccine doses. Average vaccination rates estimated from the last week of vaccination data (Sept. 17 - Sept. 24, 2021) were used to simulate into the future. The future impacts of changes in social mitigation interventions and vaccination rates are simulated by altering the values of d and the vaccination rate.

## System of ODEs

![System of Equations](equations.png)

## Table of Parameters/Priors

Model parameter priors, along with best-fitting values.

| Parameter | Definition | **Prior range** | **Median Fit** | Units/notes |
| --- | --- | --- | --- | --- |
| β<sub>1</sub> | Transmission rate, Original Variant | **0.125 – 2.0** | **1.0463** | Estimated as R<sub>0</sub>\*gamma in SIR model |
| β<sub>2</sub> | Transmission rate, Alpha Variant (B.1.1.7) | **0.125 – 2.0** | **0.9744** | Estimated as R<sub>0</sub>\*gamma in SIR model |
| β<sub>3</sub> | Transmission rate, Delta Variant (B.1.617.2) | **0.125 – 2.0** | **0.3553** | Estimated as R<sub>0</sub>\*gamma in SIR model |
| σ | Rate of moving from exposed class to infectious class | **0.16 – 0.5** | **0.2779** | 1/σ is the latent period; assumed 2-6 days |
| ⍴ | Proportion of exposed who become asymptomatic | **0.25 – 0.50** | **0.4034** |   |
| γ<sub>A</sub> | Recovery rate of asymptomatic cases | **0.125 – 0.33** | **0.2267** | 1/γ<sub>A</sub> is the infectious period; assumed 3-8 days |
| γ<sub>M</sub> | Recovery rate of cases with mild symptoms | **0.125 – 0.33** | **0.2368** | 1/<sub>M</sub> is the infectious period; assumed 3-8 days |
| γ<sub>H</sub> | Recovery rate of cases with severe symptoms requiring hospitalization | **0.125 – 0.33** | **0.2315** | 1/γ<sub>H</sub> is the infectious period of severe cases; assumed 3-8 days |
| γ<sub>C</sub> | Recovery rate of cases with severe symptoms requiring intensive care | **0.125 – 0.33** | **0.2234** | 1/γ<sub>C</sub> is the infectious period; assumed 3-8 days |
| δ<sub>1</sub> | Rate of moving from presymptomatic class to mild symptomatic | **0.05 – 0.20** | **0.1748** | 1/time from start of infectious period to illness onset; assume 5-20 days |
| δ<sub>2</sub> | Rate of moving from mild case to hospitalized class | **0.06 – 0.25** | **0.1558** | 1/time from illness onset to hospitalization; assume 4-15 days |
| δ<sub>3</sub> | Rate of moving from hospitalized class to ICU | **0.09 – 1** | **0.4957** | 1/time from hospitalization to ICU; assume 1-11 days |
| m | Mortality rate of ICU class | **0.08 – 0.25** | **0.1707** | 1/time from ICU to death |
| p | Proportion of cases detected by testing | **0.1 – 0.3** | **0.1733** |
| x<sub>1</sub> | Proportion of mild cases that progress to hospital | **0.05 – 0.3** | **0.1724** | 5-30% of mild cases are hospitalized |
| x<sub>2</sub> | Proportion of hospital cases that progress to ICU | **0.2 – 0.3** | **0.2499** | 20-30% of hospitalized cases require an ICU |
| x<sub>3</sub> | Proportion of ICU cases that die | **0.2 – 0.8** | **0.4955** | Proportion of ICU cases that die |
| d | Reduction in transmission due to social distancing, face masks, etc. | **0.25 – 0.9** | **0.6738** |   |
| 𝜀<sub>V1</sub> | Vaccine Efficacy, Original Variant | **Fixed, 0.75** |   |
| 𝜀<sub>V2</sub> | Vaccine Efficacy, Alpha Variant (B.1.1.7) | **Fixed, 0.70** |   |
| 𝜀<sub>V3</sub> | Vaccine Efficacy, Delta Variant (B.1.617.2) | **Fixed, 0.65** |   |
| 𝜀<sub>B1</sub> | Booster Efficacy, Original Variant | **Fixed, 0.90** |   |
| 𝜀<sub>B2</sub> | Booster Efficacy, Alpha Variant (B.1.1.7) | **Fixed, 0.85** |   |
| 𝜀<sub>B3</sub> | Booster Efficacy, Delta Variant (B.1.617.2)  | **Fixed, 0.80** |   |
| 𝜀<sub>W1</sub> | Waning Efficacy, Original Variant | **Fixed, 0.80** |   |
| 𝜀<sub>W2</sub> | Waning Efficacy, Alpha Variant (B.1.1.7) | **Fixed, 0.75** |   |
| 𝜀<sub>W3</sub> | Waning Efficacy, Delta Variant (B.1.617.2)  | **Fixed, 0.70** |   |
| ξ<sub>v</sub> | Vaccination Rate | **Varies over time, according to vaccination data** |
| ξ<sub>B</sub> | Booster Rate | **Fixed, assumed to be given over 6 weeks (ξ<sub>B</sub>  = 0.025)** |
| ξ<sub>W</sub> | Waning Rate | **Scenarios: 1-year, 2.5-year, and 5-year waning periods (1/ξ<sub>W</sub>)** |
