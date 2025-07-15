Scalars
*max invest budget
IB /inf/
*big M
M            /1000/
*reliability of powerlines (simplification of n-1 criteria)
reliability  /1/
*curtailment costs
cur_costs    /150/
*ratio storage capacity factor
store_cpf    /7/
*base value for per unit calculation
MVABase      /50/

df  /1/

************************ARO

Toleranz            / 0.01 /

LB                  / -1e10 /

UB                  / 1e10 /

itaux               / 1 /

Gamma_Load          /0/

Gamma_PG_conv       /0/


Gamma_Res_total     /0/

Gamma_PV_total      /0/

Gamma_wind_total    /0/

Dark_time           /15/

delta_DF            /0.8/

scale_PSP_cap       /100/

Gamma_test          /10/

psp_cpf              /8/

* load shedding costs load type 1
LS_costs_1          /1000/                 
*load shedding costs load type 2
LS_costs_2          /3000/         
* load shedding costs load type 3
LS_costs_3          /12000/           
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
LS_costs 


Demand_data_fixed(t,n,v)        fixed realisation of demand in subproblem and tranferred to master

*************************************lines
incidence(l,n)
B_sus(l)                        susceptance of existing lines in german Grid
L_cap(l)                        max. power of each existing line (220 & 380)
Cap_line_S(l)

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

Res_Cap_fixed(res,t,v) 
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
var_costs(g)                       variable costs conventional power plants

OM_costs_s(s)                   operation and maintanace costs hydropower

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
IC_hOCGT(h)         
IC_hs(h)
IC_Line(l)

FOM_hydro(s)
FOM_bi(b)
FOM_bs(b)
FOM_conv(g)
FOM_ren(ren)
FOM_Hst(h)
FOM_Hel(h)
FOM_OCGT(h)


scale_to_year
      
**************************************Availability
availup_hydro
af_hydro(t,s)                   availability of hydro potential

af_PV_up(t,ren)
af_PV(ren,t)                      upper capacity factor of solar energy
delta_af_PV_up(t,ren)
delta_af_PV(ren,t)                maximum derivation of capacity factor of solar energy

af_wind_up(t,ren) 
af_wind(ren,t)                    upper capacity factor of wind energy
delta_af_Wind_up(t,ren)
delta_af_Wind(ren,t)              maximum derivation of capacity factor of wind energy

Ratio_N(n,rr,t,WM)
Budget_N(n,rr,WM)

Ratio_WM(n,rr,t,WM) 
Budget_Delta(n,rr,WM)

Res_Cap_M(t,res) 
Res_cap_sub(res,t)
Delta_Res_cap_sub(res,t)
***************************************Uncerttainty budget

Gamma_PG_hydro
Gamma_PG_PV(rr)
Gamma_PG_Wind(rr)
Gamma_PG_ren(rr)


Gamma_PG_res(rr)

*********************************************report parameters********************************************************
inv_cost_master(v)
report_main(*,*)
report_decomp(v,*,*)
report_cap_conv(n,g,v,*)
report_cap_ren(n,ren,v,*)
report_cap_battery(n,b,v,*)
report_cap_hydrogen(n,h,v,*)
report_track_z(rr,WM,v,*)
report_objective(v)
Report_Curtailment(*,v)
Report_Gen_share(*,v)
Report_gen_tech(*,t,v)
Report_total_Gen(*,v)
Saldo_PSP(*,v)
Saldo_PSP_region(*,*,v)
Gen_PSP(*,v)
Gen_PSP_region(*,*,v)
Saldo_battery(*,v)
Saldo_battery_region(*,*,v)
Gen_battery(*,v)
Gen_battery_region(*,*,v)
Saldo_Hydrogen(*,v)
Saldo_Hydrogen_region(*,*,v)
Gen_Hydrogen(*,v)
Gen_Hydrogen_region(*,*,v)

  


**********************************************input Excel table*******************************************************
;

$onecho > TEP.txt
set=MAP_WM                      rng=Mapping!P2:Q8762                    rdim=2 cDim=0
set=Map_send_L                  rng=Mapping!J2:K195                     rdim=2 cDim=0
set=Map_res_L                   rng=Mapping!M2:N195                     rdim=2 cDim=0
set=MapG                        rng=Mapping!A2:B192                     rdim=2 cDim=0
set=Map_OCGT                    rng=Mapping!AI2:AJ21                    rdim=2 cDim=0
set=Map_CCGT                    rng=Mapping!AL2:AM40                    rdim=2 cDim=0
set=Map_Biomass                 rng=Mapping!AO2:AP30                    rdim=2 cDim=0
set=Map_Nuclear                 rng=Mapping!AR2:AS50                    rdim=2 cDim=0
set=MapS                        rng=Mapping!G2:H98                      rdim=2 cDim=0
set=Map_Ren_node                rng=Mapping!D2:E127                     rdim=2 cDim=0
set=Map_PV                      rng=Mapping!S2:T60                      rdim=2 cDim=0
set=Map_wind                    rng=Mapping!V2:W80                      rdim=2 cDim=0
set=Map_Onwind                  rng=Mapping!AU2:AV51                    rdim=2 cDim=0
set=Map_Offwind                 rng=Mapping!AX2:AY27                    rdim=2 cDim=0
set=Map_battery                 rng=Mapping!BA2:BB52                    rdim=2 cDim=0
set=Map_Hydrogen                rng=Mapping!BD2:BE52                    rdim=2 cDim=0
set=Map_RR                      rng=Mapping!BY2:BZ60                    rdim=2 cDim=0
set=Map_RR_G                    rng=Mapping!Y2:Z192                     rdim=2 cDim=0
set=MAP_RR_OCGT                 rng=Mapping!BS2:BT60                    rdim=2 cDim=0            
set=MAP_RR_B                    rng=Mapping!BV2:BW60                    rdim=2 cDim=0   
set=Map_RR_ren                  rng=Mapping!AB2:AC130                   rdim=2 cDim=0
set=MAP_RR_Ren_node             rng=Mapping!AE2:AG130                   rdim=3 cDim=0
set=Map_Res                     rng=Mapping!BG2:BH130                   rdim=2 cDim=0
set=Map_RR_RoR                  rng=Mapping!CB2:CC40                    rdim=2 cDim=0
set=Map_RR_Reservoir            rng=Mapping!CE2:CF40                    rdim=2 cDim=0
set=Map_RR_PSP                  rng=Mapping!CH2:CI40                    rdim=2 cDim=0
set=Map_RR_res                  rng=Mapping!BJ2:BK130                   rdim=2 cDim=0
set=Map_rr_send_l               rng=Mapping!BM2:BN53                    rdim=2 cDim=0
set=Map_rr_res_l                rng=Mapping!BP2:BQ53                    rdim=2 cDim=0

par=load                        rng=Demand!A1:AY8761                    rDim=1 cdim=1
par=Grid_tech                   rng=Grid_tech!A1:J200                   rDim=1 cdim=1
par=Gen_conv                    rng=Conventional!B1:L192                rDim=1 cdim=1
par=Gen_ren                     rng=Renewable!B1:L169                   rDim=1 cdim=1
par=battery_up                  rng=storage!A1:H51                      rDim=1 cdim=1
par=hydrogen_up                 rng=storage!J1:S51                      rDim=1 cdim=1
par=Gen_Hydro                   rng=Hydro!B1:H98                        rDim=1 cdim=1
par=priceup                     rng=Ressource_prices!A1:H8761           rDim=1 cdim=1
par=availup_hydro               rng=Availability!A2:D8762               rDim=1 cdim=1
par=af_PV_up                    rng=Availability!F3:BD8763              rDim=1 cdim=1
par=delta_af_PV_up              rng=Reduction!A3:AY2196                 rDim=1 cdim=1
par=af_wind_up                  rng=Availability!BF3:EC8763             rDim=1 cdim=1
par=delta_af_Wind_up            rng=Reduction!BA3:DX2196                rDim=1 cdim=1
par=Res_Cap_M                   rng=Renewable!Z2:BX8763                 rDim=1 cdim=1
$offecho    
$onUNDF
$call   gdxxrw Data_Input_ARO.xlsx @TEP.txt
$GDXin  Data_Input_ARO.gdx
$load   load
$load   MAP_WM, Map_send_L, Map_res_L,  MapS, Map_Ren_node, Map_PV, Map_Wind,Map_RR
$load   Map_RR_G, MAP_RR_OCGT,MAP_RR_B,  Map_RR_ren, MAP_RR_Ren_node, Map_Res, Map_RR_res, Map_RR_RoR, Map_RR_Reservoir, MAp_RR_PSP
$load   MapG, Map_OCGT, Map_CCGT, Map_Biomass, Map_Nuclear, Map_Onwind, Map_Offwind, Map_battery, Map_Hydrogen, Map_rr_send_l, Map_rr_res_l
$load   Grid_tech, Gen_conv, Gen_ren, Gen_Hydro
$load   priceup, battery_up, hydrogen_up
$load   availup_hydro, af_PV_up, delta_af_PV_up, af_wind_up, delta_af_Wind_up, Res_Cap_M
$GDXin
$offUNDF

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
MapG(g,n) = no
;
MapG(g,n)$(Map_Nuclear(g,n) or  Map_Biomass(g,n))  =  yes
;
AC_l(l)$(ex_l(l))  =  yes
;
AC_l(l)$(Dc_l(l))  =  no
;


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

B_sus(l)$ex_l(l)     =         Grid_tech(l,'Susceptance')
;
incidence(l,n)      =          Map_Grid(l,n)
;
L_cap(l)            =          Grid_tech(l,'L_cap') 
;
*from MW to GW
L_cap(l)            =          L_cap(l)/1000
;
*************************************generators*************************************

Cap_conv_ex(g)$(nuc(g) or biomass(g))  = Gen_conv(g,'cap') /1000
;
Cap_hydro(s)        =          Gen_Hydro(s,'cap') /1000
;
Cap_ren_ex(ren)     =          Gen_ren(ren,'cap_2050') 
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

af_PV(ren,t)                            =        round(af_PV_up(t,ren),2)
;
delta_af_PV(ren,t)                      =        round(delta_af_PV_up(t,ren),2)
;
af_wind(ren,t)                          =        round(af_Wind_up(t,ren),2)
;
delta_af_Wind(ren,t)                    =        round(delta_af_Wind_up(t,ren),2)
;


Delta_Res_cap_sub(res,t)$(ord(t) gt 1 and ord(t) le 672)  =  Res_Cap_M(t,res) * 0.7
;

*************************************Investments************************************
*from EUR / MW to  EUR / GW
IC_conv(g)        = Gen_conv(g,'IC_costs_conv') *1000
;
IC_ren(ren)       =    Gen_ren(ren,'IC_costs_ren') *1000
;
IC_bi(b)          =   battery_up(b,'inv_inverter') *1000
;
IC_bs(b)          =   battery_up(b,'inv_storage') *1000
;
IC_hel(h)          = hydrogen_up(h,'inv_electrolysis')   *1000
;    
IC_hOCGT(h)        =  hydrogen_up(h,'inv_Hydrogen OCGT') *1000
;         
IC_hs(h)           =   hydrogen_up(h,'inv_Hydrogen storage') *1000
;
FOM_conv(nuc)      =   100000 * 1000
;
FOM_conv(biomass)  =   80000 * 1000
;

*EUR  / MW & km in EUR/GW & km
IC_line(l)         =   Grid_tech(l,'annualised investment costs') *1000
;
******************************
*from EUR / GW to Million EUR / GW
IC_conv(g)        =    round(IC_conv(g) / 1000000,2)
;
IC_ren(ren)       =    round(IC_ren(ren)/ 1000000,2)
;
IC_bi(b)          =   round(IC_bi(b) / 1000000,2)
;
IC_bs(b)          =   round(IC_bs(b) / 1000000,2)
;
IC_hel(h)         =  round(IC_hel(h) / 1000000,2)
;
IC_hOCGT(h)        =   round(IC_hOCGT(h) / 1000000,2)
;
IC_hs(h)           =   round(IC_hs(h) / 1000000,2)
;
IC_line(l)         =   round(IC_line(l) /1000000,2)
;

*************************************Operation and Maintanance cost************************************
*from EUR / kW to  EUR / GW

FOM_hydro(psp)       = 45 * 1000000
;
FOM_hydro(ror)       = 35 * 1000000
;
FOM_hydro(reservoir) = 40 * 1000000
;
FOM_bi(b)            = 0.6 * 1000000
;
FOM_bs(b)            = 0.6 * 1000000
;
FOM_Hel(h)           = 14 * 1000000
;
FOM_Hst(h)           = 0.5 * 1000000
;
FOM_OCGT(h)          = 8.7  * 1000000
;
FOM_ren(wind_on)     = 9.63 * 1000000
;
FOM_ren(wind_off)    = 13.80 * 1000000
;
FOM_ren(solar_pv)    = 7.40 * 1000000
;
FOM_conv(nuc)        = 100 * 1000000
;
FOM_conv(biomass)    = 80 * 1000000
;

*************************************scaling************************************
scale               = 8760/card(t)
;
scale_to_year       = 8760/card(t)
;

*************************************OM and Variable Costs**********************
*in EUR/ MWh
LS_costs               =      12000 *  scale_to_year 
;
LS_costs_1             =     LS_costs_1   * scale_to_year 
;
LS_costs_2             =     LS_costs_2   * scale_to_year 
;
LS_costs_3             =     LS_costs_3   * scale_to_year 
;
var_costs(nuc)         =     (3/0.33)  * scale_to_year
;
var_costs(biomass)     =     (4.5/0.47)  * scale_to_year
;

******************************from EUR / MWh to Million EUR / GWh

LS_costs_1             =     (LS_costs_1   * 1000) / 1000000
;
LS_costs_2             =     (LS_costs_2   * 1000) / 1000000
;
LS_costs_3             =     (LS_costs_3   * 1000) / 1000000
;

LS_costs            =          (LS_costs * 1000) / 1000000
;
var_costs(g)        =        round( var_costs(g) * 1000 / 1000000,2)
;

*******************************from Eur/GW to million EUR / GW

FOM_hydro(psp)       = FOM_hydro(psp) / 1000000
;
FOM_hydro(ror)       = FOM_hydro(ror) / 1000000
;
FOM_hydro(reservoir) = FOM_hydro(reservoir) / 1000000
;
FOM_bi(b)            = FOM_bi(b)  / 1000000
;
FOM_bs(b)            = FOM_bs(b)  / 1000000
;
FOM_Hel(h)           = FOM_Hel(h) / 1000000
;
FOM_Hst(h)           = FOM_Hst(h) / 1000000
;
FOM_OCGT(h)          = FOM_OCGT(h)  / 1000000
;
FOM_ren(wind_on)     = FOM_ren(wind_on) / 1000000
;
FOM_ren(wind_off)    = FOM_ren(wind_off) / 1000000
;
FOM_ren(solar_pv)    = FOM_ren(solar_pv) / 1000000
;
FOM_conv(nuc)        = FOM_conv(nuc) / 1000000
;
FOM_conv(biomass)    = FOM_conv(biomass) / 1000000
;

