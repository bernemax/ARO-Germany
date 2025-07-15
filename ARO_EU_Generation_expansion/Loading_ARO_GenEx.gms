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

df /0.05/

************************ARO

Toleranz            / 1 /

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
battery_up                      upload table
hydrogen_up                     upload table

Grid_invest_new                 upload table
Grid_invest_upgrade             upload table 

*************************************Load

load(t,n)                       electrical demand in each node in hour t
load_share(n)                   electrical demand share per node
delta_load(t,n)

LS_costs                        load shedding costs

Demand_data_fixed(t,n,v)        fixed realisation of demand in subproblem and tranferred to master

*************************************lines
incidence(l,n)
*H(l,n)
B_sus(l)                        susceptance of existing lines in german Grid
L_cap(l)                        max. power of each existing line (220 & 380)

**************************************generation 
Cap_conv_ex(g)
Cap_conv_S(g)
Cap_ren_ex(ren)
Cap_ren_S(ren)
Cap_inverter_S(b)
Cap_battery_S(b)
Cap_Gen_S(h)
Cap_electrolysis_S(h)
Cap_hydrogen_S(h)
scale
AF_M_ren_fixed(t,rr,n,v)            fixed combined renewable availability factor in subproblem and tranferred to master
AF_M_PV_fixed(ren,rr,t,v)             fixed PV availability factor in subproblem and tranferred to master
AF_M_Wind_fixed(ren,rr,t,v)           fixed Wind availability factor in subproblem and tranferred to master

compare_wind(t,rr,n,v)

**************************************tech 
Fc_conv(g,t)                    fuel costs conventional powerplants
CO2_content(g)                  Co2 content

su_fact(g)                      start-up factor conventionals
fuel_start(g)                   fuel consumption factor if start-up decision
depri_costs(g)                  deprication costs conventionals
var_costs                       variable costs conventional power plants

OM_costs_s                      operation and maintanace costs hydropower

cap_hydro(s)                    max. generation capacity of each psp

Eff_conv(g)                     efficiency of conventional powerplants
Eff_hydro(s)                    efficiency of hydro powerplants



*************************************Costs
CO2_costs(t)                    CO2 costs
SU_costs(g,t)                   start-up costs conventionals

IC_bi(b)                        investment costs battery inverter in EUR per kW
IC_bs(b)                        investment costs battery storage in EUR per kWh
IC_conv(g)
IC_ren(ren)

IC_hel(h)         
IC_hfc(h)          
IC_hs(h)

scale_to_year
      
**************************************Availability
availup_hydro
af_hydro(t,s)                   availability of hydro potential

af_PV_up(t,ren)
af_PV(ren,t)                      upper capacity factor of solar energy
delta_af_PV(ren,t)                maximum derivation of capacity factor of solar energy

af_wind_up(t,ren) 
af_wind(ren,t)                    upper capacity factor of wind energy
delta_af_Wind(ren,t)              maximum derivation of capacity factor of wind energy

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
report_cap_conv(n,g,v,*)
report_cap_ren(n,ren,v,*)
report_cap_battery(n,b,v,*)
report_cap_hydrogen(n,h,v,*)

 

**********************************************input Excel table*******************************************************
;

$onecho > TEP.txt
set=MAP_WM                      rng=Mapping!P2:Q8762                    rdim=2 cDim=0
set=Map_send_L                  rng=Mapping!J2:K195                     rdim=2 cDim=0
set=Map_res_L                   rng=Mapping!M2:N195                     rdim=2 cDim=0
set=MapG                        rng=Mapping!A2:B173                     rdim=2 cDim=0
set=Map_OCGT                    rng=Mapping!AI2:AJ21                    rdim=2 cDim=0
set=Map_CCGT                    rng=Mapping!AL2:AM40                    rdim=2 cDim=0
set=Map_Biomass                 rng=Mapping!AO2:AP30                    rdim=2 cDim=0
set=Map_Nuclear                 rng=Mapping!AR2:AS27                    rdim=2 cDim=0
set=MapS                        rng=Mapping!G2:H98                      rdim=2 cDim=0
set=Map_Ren_node                rng=Mapping!D2:E127                     rdim=2 cDim=0
set=Map_PV                      rng=Mapping!S2:T60                      rdim=2 cDim=0
set=Map_wind                    rng=Mapping!V2:W80                      rdim=2 cDim=0
set=Map_Onwind                  rng=Mapping!AU2:AV51                    rdim=2 cDim=0
set=Map_Offwind                 rng=Mapping!AX2:AY27                    rdim=2 cDim=0
set=Map_battery                 rng=Mapping!BA2:BB52                    rdim=2 cDim=0
set=Map_Hydrogen                rng=Mapping!BD2:BE52                    rdim=2 cDim=0
set=Map_RR                      rng=Mapping!Y2:Z60                      rdim=2 cDim=0
set=Map_RR_ren                  rng=Mapping!AB2:AC130                   rdim=2 cDim=0
set=MAP_RR_Ren_node             rng=Mapping!AE2:AG130                   rdim=3 cDim=0

par=load                        rng=Demand!A1:AY8761                    rDim=1 cdim=1
par=Grid_tech                   rng=Grid_tech!A1:J200                   rDim=1 cdim=1
par=Gen_conv                    rng=Conventional!B1:L173                rDim=1 cdim=1
par=Gen_ren                     rng=Renewable!B1:L169                   rDim=1 cdim=1
par=battery_up                  rng=storage!A1:H51                      rDim=1 cdim=1
par=hydrogen_up                 rng=storage!J1:S51                      rDim=1 cdim=1
par=Gen_Hydro                   rng=Hydro!B1:H98                        rDim=1 cdim=1
par=priceup                     rng=Ressource_prices!A1:H8761           rDim=1 cdim=1
par=availup_hydro               rng=Availability!A2:D8762               rDim=1 cdim=1
par=af_PV_up                    rng=Availability!F3:BD8763              rDim=1 cdim=1
par=delta_af_PV                 rng=Reduction!A2:AY8762                 rDim=1 cdim=1
par=af_wind_up                  rng=Availability!BF3:EB8763             rDim=1 cdim=1
par=delta_af_Wind               rng=Reduction!BB2:CZ8762                rDim=1 cdim=1
$offecho    

$onUNDF
$call   gdxxrw Data_Input.xlsx @TEP.txt
$GDXin  Data_Input.gdx
$load   load
$load   MAP_WM, Map_send_L, Map_res_L,  MapS, Map_Ren_node, Map_PV, Map_Wind, Map_RR, Map_RR_ren, MAP_RR_Ren_node
$load   MapG, Map_OCGT, Map_CCGT, Map_Biomass, Map_Nuclear, Map_Onwind, Map_Offwind, Map_battery, Map_Hydrogen
$load   Grid_tech, Gen_conv, Gen_ren, Gen_Hydro
$load   priceup, battery_up, hydrogen_up
$load   availup_hydro, af_PV_up, delta_af_PV, af_wind_up, delta_af_Wind
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

OCGT(g)     =    Gen_conv(g,'tech')  = 6
;
CCGT(g)     =    Gen_conv(g,'tech')  = 1
;
nuc(g)      =    Gen_conv(g,'tech')  = 5
;
oil(g)      =    Gen_conv(g,'tech')  = 2
;
coal(g)     =    Gen_conv(g,'tech')  = 3
;
lig(g)      =    Gen_conv(g,'tech')  = 4
;
biomass(g)  =    Gen_conv(g,'tech')  = 10
;
MapG(g,n) = no;

*MapG(g,n)$(Map_Nuclear(g,n) )  =  yes;

MapG(g,n)$(Map_Nuclear(g,n) )  =  yes;
*and Map_Biomass(g,n)
*MapG(g,n)$(Map_CCGT(g,n) or Map_OCGT(g,n) or Map_Nuclear(g,n) )  =  yes;


***************************************renewables***********************************
wind_on(ren)    =    Gen_ren (ren,'tech')  = 11
;
wind_off(ren)   =    Gen_ren (ren,'tech')  = 12
;
wind(ren)$(wind_on(ren) or wind_off(ren)) = yes
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
load(t,n)           = load(t,n)/1000
;
*****************************************prices*************************************
*Fc_conv(OCGT,t)      =          priceup(t,'gas')
*;
*Fc_conv(CCGT,t)      =          priceup(t,'gas')
*;
Fc_conv(nuc,t)      =          priceup(t,'nuclear')
;
Fc_conv(oil,t)      =          priceup(t,'oil')
;
Fc_conv(coal,t)     =          priceup(t,'coal')
;
Fc_conv(lig,t)      =          priceup(t,'lignite')
;
Fc_conv(biomass,t)  =          priceup(t,'biomass')
;

CO2_costs(t)        =          priceup(t,'CO2')
;

************************************Grid technical**********************************

B_sus(l)$ex_l(l)     =          Grid_tech(l,'Susceptance')
;
incidence(l,n)      =          Map_Grid(l,n)
;
L_cap(l)            =          Grid_tech(l,'L_cap') 
;
*from MW to GW
L_cap(l)            =          L_cap(l)/1000
;
*************************************generators*************************************

Cap_conv_ex(g)$nuc(g)  = Gen_conv(g,'cap') /1000
;
Cap_hydro(s)        =          Gen_Hydro(s,'cap') /1000
;
cap_ren_ex(ren)$(wind_on(ren) and solar_pv(ren))       =0
*Gen_ren(ren,'cap') /1000
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

af_PV(ren,t)                            =          af_PV_up(t,ren)
;
delta_af_PV(ren,t)                      =          0
;
delta_af_PV(ren,t)$(ord(t) le 31)       =          af_PV(ren,t) * 0.9
;
delta_af_PV(ren,t)$(ord(t) gt 334)      =          af_PV(ren,t) * 0.9
;

af_wind(ren,t)                          =          af_Wind_up(t,ren)
;
delta_af_Wind(ren,t)                    =          0
;
delta_af_Wind(ren,t)$(ord(t) le 31)     =          af_wind(ren,t) * 0.7
;
delta_af_Wind(ren,t)$(ord(t) gt 334)    =          af_wind(ren,t) * 0.7
;

*************************************Investments************************************
*from MW to GW
IC_conv(g)        = Gen_conv(g,'IC_costs_conv') *1000
;
IC_ren(ren)       =    Gen_ren(ren,'IC_costs_ren') *1000
;
*from MW to GW
IC_bi(b)          =   battery_up(b,'inv_inverter') *1000
;
IC_bs(b)          =   battery_up(b,'inv_storage') *1000
;

IC_hel(h)          =   hydrogen_up(h,'inv_electrolysis') *1000 
;
IC_hfc(h)          =   hydrogen_up(h,'inv_Hydrogen OCGT') *1000
;
IC_hs(h)           =   hydrogen_up(h,'inv_Hydrogen storage') *1000
;
******************************from EUR to Million EUR
IC_conv(g)        =    IC_conv(g) / 1000000
;
IC_ren(ren)       =    IC_ren(ren)/ 1000000
;
*from MW to GW
IC_bi(b)          =   IC_bi(b) / 1000000
;
IC_bs(b)          =   IC_bs(b) / 1000000
;

IC_hel(h)          =   IC_hel(h) / 1000000
;
IC_hfc(h)          =   IC_hfc(h) / 1000000
;
IC_hs(h)           =   IC_hs(h) / 1000000
;
*************************************calculating************************************
scale               = 8760/card(t)
;
scale_to_year       = 8760/card(t)
;
LS_costs            =          3000000 * scale_to_year
;
*from Mw to GW
OM_costs_s          =          45 * 1000 * scale_to_year
;
var_costs           =               0.218182
*((FC_conv(g,t)+ co2_costs(t) * co2_content(g)) / Eff_conv(g))  * 1000 * scale_to_year
;
*su_costs(g,t)       =            depri_costs(g) + su_fact(g) * fuel_start(g) * FC_conv(g,t) + co2_content(g) * co2_costs(t)
*;

******************************from EUR to Million EUR

LS_costs         =          LS_costs / 1000000
;
*from Mw to GW
OM_costs_s       =          OM_costs_s/ 1000000 
;
var_costs        =            var_costs / 1000000
;

