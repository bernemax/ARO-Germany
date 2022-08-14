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

Gamma_PG_PV         /0/

Gamma_PG_Wind       /0/

Gamma_Ren_total     /60/

Dark_time           /15/

delta_DF            /0.8/

scale_PSP_cap      /100/
;

Parameter
Node_Demand                     upload table
Ger_Demand                      upload table
Grid_tech                       upload table
Gen_conv                        upload table
Gen_res                         upload table
Gen_ren                         upload table
Gen_tot_ren                     upload table
Gen_Hydro                       upload table
priceup                         upload table
availup_hydro                   upload table
availup_ren                     upload table
Grid_invest_new                 upload table
Grid_invest_upgrade             upload table 

*************************************Load

total_load(t)                   electrical demand in germany in hour t
load(n,t)                       electrical demand in each node in hour t
Load_unshed(n,t)
Load_BM(n,t)
Load_CP(n,t)
Load_NMM(n,t)
Load_FT(n,t)
Load_TL(n,t)
Load_PPP(n,t)
Load_WP(n,t)
Load_TE(n,t)
Load_MC(n,t)
Load_C(n,t)
Load_OI(n,t)
Load_X(n,t)
Load_states(n,t)

delta_load(n,t)
load_Ind(n,t)
delta_load_DE(n,t)              max increase of demand in each node in DE in hour t
delta_load_states(n,t) 

load_share(n)                 electrical demand share per node
load_share_BM(n)
Load_share_CP(n)
Load_share_NMM(n)
Load_share_FT(n)
Load_share_TL(n)
Load_share_PPP(n)
Load_share_WP(n)
Load_share_TE(n)
Load_share_MC(n)
Load_share_C(n)
Load_share_OI(n)
Load_share_X(n)
Load_share_Service(n)
Load_share_House(n)

Neighbor_Demand(t,n)            electrical demand in neighboring countries of germany in hour t

LS_costs(n)

LS_costs_BM(n)
LS_costs_CP(n)
LS_costs_NMM(n)
LS_costs_FT(n)
LS_costs_TL(n)
LS_costs_PPP(n)
LS_costs_WP(n)
LS_costs_TE(n)
LS_costs_MC(n)
LS_costs_C(n)
LS_costs_OI(n)
LS_costs_X(n)

Demand_data_fixed(n,t,v) 

Demand_data_fixed_unshed(n,t,v)        fixed realisation of demand in subproblem and tranferred to master
Demand_data_fixed_states(n,t,v)        fixed realisation of demand in subproblem and tranferred to master
*************************************lines

B(l)                            susceptance of existing lines in german Grid
B_prosp(l)                      susceptance of existing lines in german Grid
H(l,n)                          flow senitivity matrix
Incidence(l,n)
L_cap(l)                        max. power of each existing line (220 & 380)
L_cap_prosp(l)                  max. power of each prospective 380 kv line
circuits(l)                     number of parallel lines in grid
I_costs_upg(l)                  investment cost for an upgrade from 220 kv line to 380 kv line
I_costs_new(l)                  investment cost for a new line or connection (e.g. PCI)

Prosp_cap(l)

**************************************generation 

PG_M_fixed_conv(g,t,v)           fixed realisation of supply in subproblem and tranferred to master
*AF_M_PV_fixed(t,sr,n,v)          fixed PV availability factor in subproblem and tranferred to master
*AF_M_Wind_fixed(t,wr,n,v)        fixed Wind availability factor in subproblem and tranferred to master
AF_M_Ren_fixed(n,rr,t,v)         fixed combined wind and solar pv availability 

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
delta_cap_conv(g)               max. decrease of generation capacity of each conventional generator
cap_hydro(s)                    max. generation capacity of each psp
*cap_res(res)                    max. generation capacity of each RES
cap_ren(ren)                    max. generation capacity of combined wind and solar PV  

Eff_conv(g)                     efficiency of conventional powerplants
Eff_hydro(s)                    efficiency of hydro powerplants

**************************************Availability

af_hydro(s,t)                   availability of hydro potential
*af_PV_up(t,sr,n)                upper capacity factor of solar energy
*delta_af_PV(t,sr,n) 
*af_wind_up(t,wr,n)              upper capacity factor of wind energy
*delta_af_Wind(t,wr,n)
af_ren_up(n,rr,t)               upper capacity factor of wind and solar pv energy
delta_af_ren(n,rr,t)

Ratio_N(n,rr,t,DF)
Ratio_DF(n,rr,t,DF)
Budget_N(n,rr,DF)             budget of renewable availability during a specific time horizion previous to Dunkelflaute even
Budget_Delta(n,rr,DF)
Budget_DF(n,rr,DF)            budget of renewable availability during a specific time horizion previous to Dunkelflaute event
*random(t,n)

compare_av_ren(n,rr,t)

***************************************Uncerttainty budget

Gamma_PG_ren(rr)

**************************************historical physical flow

phy_flow_to_DE(n,t)             physical cross border flow for each country specific node in direct realtion with germany
phy_flow_states_exo(n,t)        physical cross border flow for each country specific node in no realtion with germany

*********************************************report parameters********************************************************

report_main(*,*)
report_decomp(v,*,*)
inv_iter_hist(l,v)
inv_cost_master(v)

Report_dunkel_time_Z(rr)
Report_dunkel_hours_Z(rr,DF)
Report_lines_built(l)
Report_total_cost
Report_line_constr_cost(v)

Report_LS_CP(n,t,vv)
Report_LS_NMM(n,t,vv)
Report_LS_FT(n,t,vv)
Report_LS_TL(n,t,vv)
Report_LS_PPP(n,t,vv)
Report_LS_WP(n,t,vv)
Report_LS_TE(n,t,vv)
Report_LS_MC(n,t,vv)
Report_LS_C(n,t,vv)
Report_LS_OI(n,t,vv)
Report_LS_X(n,t,vv)
Report_LS_node(n,t,vv)
Report_LS_per_hour(t,vv)
Report_LS_total(vv)

Report_PG(*,*,*,*)
Report_lineflow(l,t,vv)


$ontext
Time_restrict_up
Time_restrict_lo
*solve_time(,*)

report_mapped_flow(l,t)                directed flow report
report_mapped_flow_DE(t)               saldo flow report regarding total Ex and imports of germany
report_mapped_ExIm_flow(l,t)           directed flow report from and to DE neigboring countries
report_mapped_ExIm_sum_flow(n)  	   directed summarized flow report from and to DE neigboring countries

report_resulting_load_De(t)
report_price(n,t)
report_price_de(t)

report_total_gen(t)
report_total_gen_g(t)
report_total_gen_r(t)
report_total_gen_s(t)

report_DE_gen_lig(t)
report_DE_gen_coal(t)
report_DE_gen_gas(t)
report_DE_gen_oil(t)
report_DE_gen_nuc(t)
report_DE_gen_waste(t)

report_DE_gen_Sun(t)
report_DE_gen_Wind(t)
report_DE_gen_BIO(t)

report_DE_gen_ROR(t)
report_DE_gen_PSP(t)
report_DE_gen_Reservoir(t)

report_DE_charge(t)

report_countries_gen_lig(n,t)
report_countries_gen_coal(n,t)
report_countries_gen_gas(n,t)
report_countries_gen_oil(n,t)
report_countries_gen_nuc(n,t)
report_countries_gen_waste(n,t)

report_countries_gen_sun(n,t)
report_countries_gen_wind(n,t)
report_countries_gen_bio(n,t)

report_countries_gen_ROR(n,t)
report_countries_gen_PSP(n,t)
report_countries_gen_Reservoir(n,t)

report_Gen_Denmark(n,t)
report_Gen_Sweden(n,t)
report_Gen_Poland(n,t)
report_Gen_Czechia(n,t)
report_Gen_Austria(n,t)
report_Gen_Swiss(n,t)
report_Gen_France(n,t)
report_Gen_Luxemburg(n,t)
report_Gen_Belgium(n,t)
report_Gen_Netherland(n,t)
$offtext
**********************************************input Excel table*******************************************************
;

$onecho > TEP.txt
set=MAP_DF                      rng=Mapping!Z2:AA8762                   rdim=2 cDim=0
set=Map_send_L                  rng=Mapping!A2:B300                     rdim=2 cDim=0
set=Map_res_L                   rng=Mapping!D2:E300                     rdim=2 cDim=0
set=MapG                        rng=Mapping!T2:U223                     rdim=2 cDim=0
set=MapS                        rng=Mapping!W2:X76                      rdim=2 cDim=0
set=MapRen                      rng=Mapping!N2:O120                     rdim=2 cDim=0
set=MapRR                       rng=Mapping!K2:L120                     rdim=2 cDim=0
set=MAP_RR_Ren                  rng=Mapping!G2:I120                     rdim=3 cDim=0
set=RR_ren                      rng=Mapping!Q2:R120                     rdim=2 cDim=0
set=Border_exist_DE             rng=Mapping!V3:V49                      rdim=1 cDim=0

par=Node_Demand                 rng=Demand!A1:B120                      rDim=1 cdim=1
par=Neighbor_Demand             rng=Demand!H2:S8762                     rDim=1 cdim=1
par=Ger_Demand                  rng=Demand!D1:E8761                     rDim=1 cdim=1
par=Grid_tech                   rng=Grid_tech!A1:D245                   rDim=1 cdim=1
par=Gen_conv                    rng=Gen_conv!O1:V223                    rDim=1 cdim=1
par=Gen_ren                     rng=Gen_ren!A1:D120                     rDim=1 cdim=1
par=Gen_Hydro                   rng=Gen_Hydro!S1:W75                    rDim=1 cdim=1
par=priceup                     rng=Ressource_prices!A1:I8761           rDim=1 cdim=1
par=availup_hydro               rng=Availability!A2:D8762               rDim=1 cdim=1
par=availup_ren                 rng=Availability!T2:EA8762              rDim=1 cdim=1
par=Grid_invest_new             rng=Grid_invest!B1:E25                  rDim=1 cdim=1
$offecho

$onUNDF
$call   gdxxrw Data_reduced_Network_100.xlsx @TEP.txt
$GDXin  Data_reduced_Network_100.gdx
$load   Map_DF, Map_send_L, Map_res_L, MapG, MapS, MapRen, MapRR, MAP_RR_Ren, RR_ren 
$load   Border_exist_DE	
$load   Node_Demand, Neighbor_Demand, Ger_demand, Grid_tech
$load   Gen_conv, Gen_ren, Gen_Hydro, priceup
$load   availup_hydro, availup_ren
$load   Grid_invest_new
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

gas(g)      =    Gen_conv(g,'tech')  = 1
;
oil(g)      =    Gen_conv(g,'tech')  = 2
;
coal(g)     =    Gen_conv(g,'tech')  = 3
;
lig(g)      =    Gen_conv(g,'tech')  = 4
;
nuc(g)      =    Gen_conv(g,'tech')  = 5
;
waste(g)    =    Gen_conv(g,'tech')  = 6
;
biomass(g)  =    Gen_conv(g,'tech')  = 7
;

***************************************hydro****************************************

psp(s)      =    Gen_Hydro(s,'tech') = 1
;
reservoir(s)=    Gen_Hydro(s,'tech') = 2
;
ror(s)      =    Gen_Hydro(s,'tech') = 3
;

*###################################loading parameter###############################

*****************************************demand*************************************

total_load(t)           =          Ger_demand(t,'total_load')
;
load_share(n)           =          Node_Demand(n,'Cluster_weight')
;
load(n,t)               =          load_share(n) * total_load(t) 
;
load(n,t)$border_states(n) =       Neighbor_Demand(t,n) 
;
LS_costs(n)             =          5000
;
*Test(n,t)               =          Neighbor_Demand(t,n) 
*;
$ontext
LS_costs_BM(n)          =          LS_costs_up('BM')
;
LS_costs_CP(n)          =          LS_costs_up('CP')
;
LS_costs_NMM(n)         =          LS_costs_up('NMM')
;
LS_costs_FT(n)          =          LS_costs_up('FT')
;
LS_costs_TL(n)          =          LS_costs_up('TL')
;
LS_costs_PPP(n)         =          LS_costs_up('PPP')
;
LS_costs_WP(n)          =          LS_costs_up('WP')
;
LS_costs_TE(n)          =          LS_costs_up('TE')
;
LS_costs_MC(n)          =          LS_costs_up('MC')
;
LS_costs_C(n)           =          LS_costs_up('C')
;
LS_costs_OI(n)          =          LS_costs_up('OI')
;
LS_costs_X(n)           =          LS_costs_up('X')
;

load_share_BM(n)        =          Node_Demand(n,'BM')
;
Load_share_CP(n)        =          Node_Demand(n,'CP')
;
Load_share_NMM(n)       =          Node_Demand(n,'NMM')
;
Load_share_FT(n)        =          Node_Demand(n,'FT')
;
Load_share_TL(n)        =          Node_Demand(n,'TL')
;
Load_share_PPP(n)       =          Node_Demand(n,'PPP')
;
Load_share_WP(n)        =          Node_Demand(n,'WP')
;
Load_share_TE(n)        =          Node_Demand(n,'TE')
;
Load_share_MC(n)        =          Node_Demand(n,'MC')
;
Load_share_C(n)         =          Node_Demand(n,'C')
;
Load_share_OI(n)        =          Node_Demand(n,'OI')
;       
Load_share_X(n)         =          Node_Demand(n,'X')
;
Load_share_Service(n)   =          Node_Demand(n,'Service')
;
Load_share_House(n)     =          Node_Demand(n,'House')
;
$offtext
*****************************************prices*************************************

Fc_conv(gas,t)      =          priceup(t,'gas')
;
Fc_conv(oil,t)      =          priceup(t,'oil')
;
Fc_conv(coal,t)     =          priceup(t,'coal')
;
Fc_conv(lig,t)      =          priceup(t,'lignite')
;
Fc_conv(nuc,t)      =          priceup(t,'nuclear')
;
Fc_conv(waste,t)    =          priceup(t,'waste')
;
Fc_conv(biomass,t)  =          priceup(t,'biomass')
;
CO2_costs(t)        =          priceup(t,'CO2')
;

************************************Grid technical**********************************

B(l)                =          Grid_tech(l,'Susceptance')
;
incidence(l,n)      =          Map_Grid(l,n)
;
L_cap(l)            =          Grid_tech(l,'L_cap')
;
*circuits(l)         =          Grid_tech(l,'circuits')
*;
L_cap_prosp(l)      =          Grid_invest_new(l,'new_cap')
;
B_prosp(l)          =          Grid_invest_new(l,'Susceptance')
;
H(l,n)              =          B(l)* incidence(l,n)
;
*************************************generators*************************************

Cap_conv(g)         =          Gen_conv(g,'Gen_cap')
;
Cap_hydro(s)        =          Gen_Hydro(s,'Gen_cap')
;
*Cap_res(res)        =          Gen_res(res,'Gen_cap')
*;
cap_ren(ren)        =          Gen_ren(ren,'Cap_ren') 
;
Eff_conv(g)         =          Gen_conv(g,'eff')
;
Eff_hydro(s)        =          Gen_Hydro(s,'eff')
;
*Eff_res(res)        =          Gen_res(res,'eff')
*;
Co2_content(g)      =          Gen_conv(g,'CO2')
;
su_fact(g)          =          Gen_conv(g,'su_fact')
;
depri_costs(g)      =          Gen_conv(g,'depri_costs')
;
fuel_start(g)       =          Gen_conv(g,'fuel_start')
;

************************************availability************************************


af_hydro(ror,t)                         =          availup_hydro(t,'ror')
;
af_hydro(psp,t)                         =          availup_hydro(t,'psp')
;
af_hydro(reservoir,t)                   =          availup_hydro(t,'reservoir')
;
*af_PV_up(t,sr,n)$MapSR(sr,n)            =          availup_res(t,sr)
*;
*delta_af_PV(t,sr,n)$MapSR(sr,n)         =          availup_res(t,sr) * 0.95
*;
*af_Wind_up(t,wr,n)$MapWr(wr,n)          =          availup_res(t,wr)
*;
*delta_af_Wind(t,wr,n)$MapWr(wr,n)       =          availup_res(t,wr) * 0.95
*;
af_ren_up(n,rr,t)$MapRR(rr,n)              =          availup_ren(t,n)
;
delta_af_ren(n,rr,t)$MapRR(rr,n)           =      (af_ren_up(n,rr,t) - 0.2)$(af_ren_up(n,rr,t) gt 0.2)
;
*delta_af_ren(n,rr,t)$MapRR(rr,n)           =      (af_ren_up(n,rr,t) - 0.2)$(af_ren_up(n,rr,t) gt 0.2)
*;


*************************************Investments************************************

I_costs_new(l)      =  ((Grid_invest_new(l,'Inv_costs_new')/(8760/card(t))) * 0.07)/(1-(1+0.07)**(-40))	
;
*I_costs_upg(l)      =  (Grid_invest_upgrade(l,'Inv_costs_upgrade')/(8760/card(t))) 
*;
*************************************calculating************************************
$ontext

Load_unshed(n,t)$(DE_nodes(n))           =            (Load_share_Service(n) + Load_share_House(n)) *total_load(t)
;
Load_BM(n,t)$(DE_nodes(n))               =             load_share_BM(n) *total_load(t)
;
Load_CP(n,t)$(DE_nodes(n))               =             Load_share_CP(n) *total_load(t)
;
Load_NMM(n,t)$(DE_nodes(n))              =             Load_share_NMM(n) *total_load(t)
;
Load_FT(n,t)$(DE_nodes(n))               =             Load_share_FT(n) *total_load(t)
;
Load_TL(n,t)$(DE_nodes(n))               =             Load_share_TL(n) *total_load(t)
;
Load_PPP(n,t)$(DE_nodes(n))              =             Load_share_PPP(n) *total_load(t)
;
Load_WP(n,t)$(DE_nodes(n))               =             Load_share_WP(n) *total_load(t)
;
Load_TE(n,t)$(DE_nodes(n))               =             Load_share_TE(n) *total_load(t)
;
Load_MC(n,t)$(DE_nodes(n))               =             Load_share_MC(n) *total_load(t)
;
Load_C(n,t)$(DE_nodes(n))                =             Load_share_C(n) *total_load(t)
;
Load_OI(n,t)$(DE_nodes(n))               =             Load_share_OI(n) *total_load(t)
;
Load_X(n,t)$(DE_nodes(n))                =             Load_share_X(n) *total_load(t)
;
load_Ind(n,t)$(DE_nodes(n))              =             Load_BM(n,t) + Load_CP(n,t) + Load_NMM(n,t) + Load_FT(n,t) + Load_TL(n,t) + Load_PPP(n,t)
                                                       + Load_WP(n,t) + Load_TE(n,t) + Load_MC(n,t) + Load_C(n,t) + Load_OI(n,t) + Load_X(n,t)
;

delta_load_DE(n,t)$(DE_nodes(n))         =            ((Load_share_Service(n) + Load_share_House(n))*total_load(t)) * 0.1
; 
Load_states(n,t)$(border_states(n))      =            Load_share_X(n)*Neighbor_Demand(t,n)
;
delta_load_states(n,t)$(border_states(n))=            (Load_share_X(n)*Neighbor_Demand(t,n)) * 0.1
;
delta_Cap_conv(g)                        =            Cap_conv(g) * 0.9
;


*********************for general LS
delta_load(n,t)                          =            ((Load_share_Service(n) + Load_share_House(n))*total_load(t)) * 0.1
;
load(n,t)                                =            load_share_Service(n) + Load_share_House(n) + load_Ind(n,t)
;
load(n,t)$(border_states(n))             =            (Neighbor_Demand(t,n)) 
;
$offtext
*********************


var_costs(g,t)                           =            ((FC_conv(g,t)+ co2_costs(t) * co2_content(g)) / Eff_conv(g))
;
su_costs(g,t)                            =            depri_costs(g) + su_fact(g) * fuel_start(g) * FC_conv(g,t) + co2_content(g) * co2_costs(t)
;


*************************for ren buget approach
*random(t,n) = random_uni(-1,1)/10
*;
Budget_N(n,rr,DF)                        = sum((t)$MAP_DF(t,DF), af_ren_up(n,rr,t))
;              
Budget_Delta(n,rr,DF)                    = sum((t)$MAP_DF(t,DF), delta_af_ren(n,rr,t))
;
Budget_DF(n,rr,DF)                       = Budget_N(n,rr,DF) - Budget_Delta(n,rr,DF)
;
Ratio_N(n,rr,t,DF)$(MAP_DF(t,DF) and MapRR(rr,n) and (Budget_N(n,rr,DF) gt 0))     = af_ren_up(n,rr,t)/(Budget_N(n,rr,DF))
;

Ratio_DF(n,rr,t,DF)$(MAP_DF(t,DF) and MapRR(rr,n) and (af_ren_up(n,rr,t) = 0 ))    = 0
;
Ratio_DF(n,rr,t,DF)$(MAP_DF(t,DF) and MapRR(rr,n) and (Budget_N(n,rr,DF) gt 0) and (Budget_Delta(n,rr,DF) gt 0 ))    = delta_af_ren(n,rr,t) / Budget_Delta(n,rr,DF)
;

