Scalars
*max invest budget
IB /inf/
*big M
M            /10000/
*reliability of powerlines (simplification of n-1 criteria)
reliability  /1/
*curtailment costs
cur_costs    /150/
*ratio storage capacity factor
store_cpf    /7/
*base value for per unit calculation
MVABase      /500/

************************ARO

Toleranz            / 100 /

LB                  / -1e10 /

UB                  / 1e10 /

itaux               / 1 /

Gamma_Load          /0/

Gamma_PG_conv       /0/


Gamma_Ren_total     /60/

Gamma_PV_total      /10/

Gamma_wind_total    /10/

Dark_time           /15/

delta_DF            /0.8/

scale_PSP_cap       /100/

Gamma_test          /10/

psp_cpf              /8/

;

Parameter
Node_Demand                     upload table
Node_share                      upload table
Grid_tech                       upload table
Gen_conv                        upload table
Gen_ren                         upload table
Gen_Hydro                       upload table
priceup                         upload table
availup_hydro                   upload table

Grid_invest_new                 upload table
Grid_invest_upgrade             upload table 

*************************************Load

load(t,n)                       electrical demand in each node in hour t
load_share(n)                   electrical demand share per node
delta_load(t,n)

LS_costs(n)                     load shedding costs

Demand_data_fixed(t,n,v)        fixed realisation of demand in subproblem and tranferred to master

*************************************lines
incidence(l,n)
H(l,n)

B(l)                            susceptance of existing lines in german Grid
B_prosp(l)                      susceptance of existing lines in german Grid

L_cap(l)                        max. power of each existing line (220 & 380)
L_cap_prosp(l)                  max. power of each prospective 380 kv line

I_costs_upg(l)                  investment cost for an upgrade from 220 kv line to 380 kv line
I_costs_new(l)                  investment cost for a new line or connection (e.g. PCI)

Prosp_cap(l)

**************************************generation 

PG_M_fixed_conv(g,t,v)           fixed realisation of supply in subproblem and tranferred to master
AF_M_ren_fixed(t,rr,n,v)            fixed combined renewable availability factor in subproblem and tranferred to master
AF_M_PV_fixed(t,rr,n,v)             fixed PV availability factor in subproblem and tranferred to master
AF_M_Wind_fixed(t,rr,n,v)           fixed Wind availability factor in subproblem and tranferred to master

compare_wind(t,rr,n,v)

**************************************tech & costs
Fc_conv(g,t)                    fuel costs conventional powerplants
CO2_content(g)                  Co2 content
CO2_costs(t)                    CO2 costs
SU_costs(g,t)                   start-up costs conventionals
su_fact(g)                      start-up factor conventionals
fuel_start(g)                   fuel consumption factor if start-up decision
depri_costs(g)                  deprication costs conventionals
var_costs(g,t)                  variable costs conventional power plants

cap_conv(g)                     max. generation capacity of each conventional generator

cap_hydro(s)                    max. generation capacity of each psp

cap_ren(ren)                    max. generation capacity of combined wind and solar PV  

Eff_conv(g)                     efficiency of conventional powerplants
Eff_hydro(s)                    efficiency of hydro powerplants

**************************************Availability
availup_hydro
af_hydro(t,s)                   availability of hydro potential

af_PV_up(t,n)                   upper capacity factor of solar energy
delta_af_PV(t,n)                maximum derivation of capacity factor of solar energy

af_wind_up(t,n)                 upper capacity factor of wind energy
delta_af_Wind(t,n)              maximum derivation of capacity factor of wind energy


Ratio_N(n,rr,t,WM)
Budget_N(n,rr,WM)

Ratio_WM(n,rr,t,WM) 
Budget_Delta(n,rr,WM)
***************************************Uncerttainty budget

Gamma_PG_hydro
Gamma_PG_PV(rr)
Gamma_PG_Wind(rr)

Gamma_PG_ren(rr)

*********************************************report parameters********************************************************
inv_cost_master(v)
report_main(*,*)
report_decomp(v,*,*)



**********************************************input Excel table*******************************************************
;

$onecho > TEP.txt
set=MAP_WM                      rng=Mapping!P2:Q8762                    rdim=2 cDim=0
set=Map_send_L                  rng=Mapping!J2:K195                     rdim=2 cDim=0
set=Map_res_L                   rng=Mapping!M2:N195                     rdim=2 cDim=0
set=MapG                        rng=Mapping!A2:B173                     rdim=2 cDim=0
set=MapS                        rng=Mapping!G2:H98                      rdim=2 cDim=0
set=Map_Ren_node                rng=Mapping!D2:E127                     rdim=2 cDim=0
set=Map_PV                      rng=Mapping!S2:T60                      rdim=2 cDim=0
set=Map_wind                    rng=Mapping!V2:W80                      rdim=2 cDim=0
set=Map_RR                      rng=Mapping!Y2:Z60                      rdim=2 cDim=0
set=Map_RR_ren                  rng=Mapping!AB2:AC130                   rdim=2 cDim=0
set=MAP_RR_Ren_node             rng=Mapping!AE2:AG130                   rdim=3 cDim=0

par=load                        rng=Demand!A1:AY8761                    rDim=1 cdim=1
par=Grid_tech                   rng=Grid_tech!A1:J200                   rDim=1 cdim=1
par=Gen_conv                    rng=Conventional!B1:K173                rDim=1 cdim=1
par=Gen_ren                     rng=Renewable!B1:F169                   rDim=1 cdim=1
par=Gen_Hydro                   rng=Hydro!B1:H98                        rDim=1 cdim=1
par=priceup                     rng=Ressource_prices!A1:H8761           rDim=1 cdim=1
par=availup_hydro               rng=Availability!A2:D8762               rDim=1 cdim=1
par=af_PV_up                    rng=Availability!F2:BD8762              rDim=1 cdim=1
par=af_wind_up                  rng=Availability!BG2:DE8762             rDim=1 cdim=1
$offecho

$onUNDF
$call   gdxxrw Data_Input.xlsx @TEP.txt
$GDXin  Data_Input.gdx
$load   load
$load   MAP_WM, Map_send_L, Map_res_L, MapG, MapS, Map_Ren_node, Map_PV, Map_Wind, Map_RR, Map_RR_ren, MAP_RR_Ren_node
$load   Grid_tech, Gen_conv, Gen_ren, Gen_Hydro
$load   priceup
$load   availup_hydro, af_PV_up, af_wind_up
$GDXin
$offUNDF

*res availiability corrisponding to german 60 zones
*par=availup_res                 rng=Availability!E2:DU8762              rDim=1 cdim=1 
;
*####################################subset definitions & initialization #############################

Map_Grid(l,n)$(Map_send_L(l,n)) = yes
;
Map_Grid(l,n)$(Map_res_L(l,n)) = yes
;

CCGT(g)     =    Gen_conv(g,'tech')  = 1
;
OCGT(g)     =    Gen_conv(g,'tech')  = 6
;
oil(g)      =    Gen_conv(g,'tech')  = 2
;
coal(g)     =    Gen_conv(g,'tech')  = 3
;
lig(g)      =    Gen_conv(g,'tech')  = 4
;
nuc(g)      =    Gen_conv(g,'tech')  = 5
;
biomass(g)  =    Gen_conv(g,'tech')  = 10
;

***************************************renewables***********************************

wind_on(ren)    =    Gen_ren (ren,'tech')  = 11
;
wind_off(ren)   =    Gen_ren (ren,'tech')  = 12
;
solar_pv(ren)   =    Gen_ren (ren,'tech')  = 13
;

***************************************hydro****************************************

psp(s)      =    Gen_Hydro(s,'tech') = 21
;
reservoir(s)=    Gen_Hydro(s,'tech') = 22
;
ror(s)      =    Gen_Hydro(s,'tech') = 20
;

*###################################loading parameter###############################

*****************************************demand*************************************

LS_costs(n)             =          5000
;
*****************************************prices*************************************

Fc_conv(CCGT,t)      =          priceup(t,'gas')
;
Fc_conv(OCGT,t)      =          priceup(t,'gas')
;
Fc_conv(oil,t)      =          priceup(t,'oil')
;
Fc_conv(coal,t)     =          priceup(t,'coal')
;
Fc_conv(lig,t)      =          priceup(t,'lignite')
;
Fc_conv(nuc,t)      =          priceup(t,'nuclear')
;
Fc_conv(biomass,t)  =          priceup(t,'biomass')
;
CO2_costs(t)        =          priceup(t,'CO2')
;

************************************Grid technical**********************************

B(l)$ex_l(l)        =          Grid_tech(l,'Susceptance')
;
incidence(l,n)      =          Map_Grid(l,n)
;
L_cap(l)            =          Grid_tech(l,'L_cap')
;
*L_cap_prosp(l)      =          Grid_invest_new(l,'new_cap')
*;
B_prosp(l)$pros_l(l)=          Grid_tech(l,'Susceptance')
;
H(l,n)              =          B(l)* incidence(l,n)
;
*************************************generators*************************************

Cap_conv(g)         =          Gen_conv(g,'cap')
;
Cap_hydro(s)        =          Gen_Hydro(s,'cap')
;
cap_ren(ren)        =          Gen_ren(ren,'cap') 
;
Eff_conv(g)         =          Gen_conv(g,'efficiency')
;
Eff_hydro(s)        =          Gen_Hydro(s,'eff_disp')
;
Co2_content(g)      =          Gen_conv(g,'CO2')
;
su_fact(g)          =          Gen_conv(g,'su_fact')
;
depri_costs(g)      =          Gen_conv(g,'depri_costs')
;
fuel_start(g)       =          Gen_conv(g,'fuel_start')
;

************************************availability************************************


af_hydro(t,ror)                       =          availup_hydro(t,'ror')
;
af_hydro(t,psp)                       =          availup_hydro(t,'psp')
;
af_hydro(t,reservoir)                 =          availup_hydro(t,'reservoir')
;

delta_af_PV(t,n)                        =          af_PV_up(t,n)  * 0.8
;
delta_af_Wind(t,n)                      =          af_Wind_up(t,n) * 0.8
;

*************************************Investments************************************

I_costs_new(l)$pros_l(l)      =  ((Grid_tech(l,'capital costs')/(8760/card(t))) * 0.07)/(1-(1+0.07)**(-40))	
;
*************************************calculating************************************

var_costs(g,t)                           =            ((FC_conv(g,t)+ co2_costs(t) * co2_content(g)) / Eff_conv(g))
;
su_costs(g,t)                            =            depri_costs(g) + su_fact(g) * fuel_start(g) * FC_conv(g,t) + co2_content(g) * co2_costs(t)
;

