option profile = 1;
option profiletol = 0.01;


$setGlobal Prosp_exist "*"          if "*" only existing lines are taken into account, if "" model can invest into prospective lines
$setGlobal Start_up    ""          if "*" starts ups are not concidered, if "" start ups are concidered
$setGlobal only_380    ""           if "*" only investments in 380 KV lines are taken into account, if "" 220 kV and 380 kV lines are taken into account
$setGlobal Borderexp   "*"           if "*" border expansion, if "" no border expansion
$setGlobal endotrans   "*"          if "*" transmission between countries is modelled engogeniously, if "" then physical flow is added exogeniously
;

Sets

n /n1*n509/
*d /d1*d511/
l /l1*l1680/
g /g1*g559/
s /s1*s175/
Res/res1*res1018/
t/t1*t5/
v /v1*v4/
sr/sr1*sr59/
wr/wr1*wr60/

*H(t,it)

****************************thermal************************************************
gas(g)
lig(g)
coal(g)
nuc(g)
oil(g)
waste(g)

****************************renewable***********************************************
wind(res)
sun(res)
biomass(res)

****************************hydro***************************************************
ror(s)
reservoir(s)
psp(s)
psp_DE(s)

****************************lines***************************************************
ex_l(l)/l1*l840/
pros_l(l)/l841*l941/
*pros_l(l)/l841*l1680/

Border_exist_DE(l)
Border_exist_total(l)

Border_prosp_DE(l)
Border_prosp_total(l)


****************************nodes***************************************************
ref(n)
/n1/
DE(n)
/n1*n495/
NoDeSciGrid(n)
/n65,n97,n182,n203,n222,
n237,n263,n273,n274,n317,
n321,n325,n328,n355,n357,
n358,n359,n361,n362,n404,
n405,n416,n417,n430,n432/

border_states(n)
/n500*n509/
connected_states(n)
/n500*n508/

DK(n) /n500/
SW(n) /n501/
PL(n) /n502/
CZ(n) /n503/
AT(n) /n504/
CH(n) /n505/
FR(n) /n506/
LU(n) /n507/
NL(n) /n508/
BE(n) /n509/


Relevant_Nodes(n)
/n1*n495,n500*n509/

*****************************mapping************************************************
Map_grid(l,n)
Map_send_L(l,n)
Map_res_L(l,n)
MapG(g,n)
MapS(s,n)

MapRes(res,n)
MapSr(n,sr)
MapWr(n,wr)


;
alias (n,nn),(t,tt),(l,ll), (v,vv)

;
****************************************scalars**************************************
Scalars
*max invest budget
IB           /2000000000/
*big M
M            /5000/
*reliability of powerlines (simplification of n-1 criteria)
reliability  /1/
*curtailment costs
cur_costs    /150/
*ratio storage capacity factor
store_cpf    /7/
*base value for per unit calculation
MVABase      /500/

************************ARO

Toleranz            / 1 /

LB                  / -1e10 /

UB                  / 1e10 /

itaux               / 1 /

Gamma_Load          /0/

Gamma_PG_conv       /0/

Gamma_PG_PV         /0/

Gamma_PG_Wind       /0/
;

**************************************parameters**************************************
Parameter
Node_Demand                     upload table
Ger_Demand                      upload table
Grid_tech                       upload table
Gen_conv                        upload table
Gen_res                         upload table
Gen_Hydro                       upload table
priceup                         upload table
availup_hydro                   upload table
availup_res                     upload table
Grid_invest                     upload table

*************************************Load

total_load(t)                   electrical demand in germany in hour t
load(n,t)                       electrical demand in each node in hour t
delta_load(n,t)                 max increase of demand in each node in hour t
load_share(n)                   electrical demand share per node
Neighbor_Demand(t,n)            electrical demand in neighboring countries of germany in hour t
LS_costs(n)                     loadshedding costs per node

Demand_data_fixed(n,t,v)        fixed realisation of demand in subproblem and tranferred to master

*************************************lines

B(l)                            susceptance of existing lines in german Grid
B_prosp_220(l)                  susceptance of existing lines in german Grid
B_prosp_380(l)                  susceptance of existing lines in german Grid
H(l,n)                          flow senitivity matrix
Incidence(l,n)
L_cap(l)                        max. power of each existing line (220 & 380)
L_cap_inv_220(l)                max. power of each prospective 220 kv line
L_cap_inv_380(l)                max. power of each prospective 380 kv line
circuits(l)                     number of parallel lines in grid
I_costs_220(l)                  investment sost per prospective 220 kv line
I_costs_380(l)                  investment sost per prospective 380 kv line

**************************************generation 

PG_M_fixed_conv(g,t,v)           fixed realisation of supply in subproblem and tranferred to master
AF_M_PV_fixed(t,sr,n,v)          fixed PV availability factor in subproblem and tranferred to master
AF_M_Wind_fixed(t,wr,n,v)        fixed Wind availability factor in subproblem and tranferred to master

**************************************tech & costs
Fc_conv(g,t)                    fuel costs conventional powerplants
Fc_res(res,t)                   fuel costs renewable powerplants
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
cap_res(res)                    max. generation capacity of each RES

Eff_conv(g)                     efficiency of conventional powerplants
Eff_hydro(s)                    efficiency of hydro powerplants
Eff_res(res)                    efficiency of renewable powerplants

**************************************Availability

af_hydro(s,t)                   availability of hydro potential
af_PV_up(t,sr,n)                upper capacity factor of solar energy
delta_af_PV(t,sr,n) 
af_wind_up(t,wr,n)              upper capacity factor of wind energy
delta_af_Wind(t,wr,n) 

**************************************historical physical flow

phy_flow_to_DE(t,n)             physical cross border flow for each country specific node in direct realtion with germany
phy_flow_states_exo(t,n)        physical cross border flow for each country specific node in no realtion with germany

*********************************************report parameters********************************************************

report_main(*,*)
report_decomp(v,*,*)
inv_iter_hist(l,v)
inv_cost_master


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
set=Map_send_L                  rng=Mapping!A3:B1682                    rdim=2 cDim=0
set=Map_res_L                   rng=Mapping!D3:E1682                    rdim=2 cDim=0
set=MapG                        rng=Mapping!G3:H561                     rdim=2 cDim=0
set=MapS                        rng=Mapping!J3:K177                     rdim=2 cDim=0
set=MapRes                      rng=Mapping!S3:T1027                    rdim=2 cDim=0
set=MapWr                       rng=Mapping!M3:N482                     rdim=2 cDim=0
set=MapSr                       rng=Mapping!P3:Q482                     rdim=2 cDim=0
set=Border_exist_DE             rng=Mapping!V3:V47                      rdim=1 cDim=0
set=Border_exist_total          rng=Mapping!W3:W65                      rdim=1 cDim=0
set=Border_prosp_DE             rng=Mapping!X3:X47                      rdim=1 cDim=0
set=Border_prosp_total          rng=Mapping!Y3:Y65                      rdim=1 cDim=0


par=Node_Demand                 rng=Node_Demand!A1:C506                 rDim=1 cdim=1
par=Neighbor_Demand             rng=Neighboring_countries!A2:K8762      rDim=1 cdim=1
par=Ger_Demand                  rng=Node_Demand!E1:F8761                rDim=1 cdim=1
par=Grid_tech                   rng=Grid_tech!A1:H841                   rDim=1 cdim=1
par=Gen_conv                    rng=Gen_conv!B2:J561                    rDim=1 cdim=1
par=Gen_res                     rng=Gen_res!A2:E1120                    rDim=1 cdim=1
par=Gen_Hydro                   rng=Gen_Hydro!A2:F177                   rDim=1 cdim=1
par=priceup                     rng=prices!A1:I8761                     rDim=1 cdim=1
par=availup_hydro               rng=Availability!A2:D8762               rDim=1 cdim=1
par=availup_res                 rng=Availability!E2:DU8762              rDim=1 cdim=1
par=phy_flow_to_DE              rng=Cross_border_flow!A2:J8763          rDim=1 cdim=1
par=phy_flow_states_exo         rng=Cross_border_flow!L2:T8763          rDim=1 cdim=1
par=Grid_invest                 rng=Grid_invest!A2:G842                 rDim=1 cdim=1
$offecho

$onUNDF
$call   gdxxrw Data.xlsx @TEP.txt
$GDXin  Data.gdx
$load   Map_send_L, Map_res_L, MapG, MapS, MapRes, MapSr, MapWr
$load   Border_exist_DE, Border_exist_total, Border_prosp_DE, Border_prosp_total
$load   Node_Demand,Neighbor_Demand, Ger_demand, Grid_tech
$load   Gen_conv, Gen_res, Gen_Hydro, priceup
$load   availup_hydro, availup_res
$load   phy_flow_to_DE, Phy_flow_states_exo
$load   Grid_invest
$GDXin
$offUNDF
;
*####################################subset definitions#############################

Map_Grid(l,n)$(Map_send_L(l,n)) = yes
;
Map_Grid(l,n)$(Map_res_L(l,n)) = yes
;
Relevant_Nodes(n)$NoDeSciGrid(n)  = no
;
De(n)$NoDeSciGrid(n)  = no
;
*no expansion of broderlines
%Borderexp% pros_l(l)$(Border_prosp_DE(l)) = no
;
*Thermal(g) = Gen_conv(g,'class') = 1
*;
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

***************************************hydro****************************************

psp(s)      =    Gen_Hydro(s,'tech') = 1
;
reservoir(s)=    Gen_Hydro(s,'tech') = 2
;
ror(s)      =    Gen_Hydro(s,'tech') = 3
;

****************************************res*****************************************

wind(res)   =    Gen_res(res,'tech') = 1
;
sun(res)    =    Gen_res(res,'tech') = 2
;
biomass(res)=    Gen_res(res,'tech') = 3
;

*###################################loading parameter###############################

*****************************************demand*************************************

total_load(t)       =          Ger_demand(t,'total_load')
;
LS_costs(n)         =          Node_Demand(n,'LS_costs')
;
load_share(n)       =          Node_Demand(n,'share')
;

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
Fc_res(biomass,t)   =          priceup(t,'biomass')
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
circuits(l)         =          Grid_tech(l,'circuits')
;
L_cap_inv_220(l)    =          Grid_invest(l,'cap_inv_220')
;
L_cap_inv_380(l)    =          Grid_invest(l,'cap_inv_380')
;
B_prosp_220(l)      =          Grid_invest(l,'Suscep_220')
;
B_prosp_380(l)      =          Grid_invest(l,'Suscep_380')
;


*************************************generators*************************************

Cap_conv(g)         =          Gen_conv(g,'Gen_cap')
;
Cap_hydro(s)        =          Gen_Hydro(s,'Gen_cap')
;
Cap_res(res)        =          Gen_res(res,'Gen_cap')
;
Eff_conv(g)         =          Gen_conv(g,'eff')
;
Eff_hydro(s)        =          Gen_Hydro(s,'eff')
;
Eff_res(res)        =          Gen_res(res,'eff')
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


af_hydro(ror,t)                         =          availup_hydro(t,'ror')
;
af_hydro(psp,t)                         =          availup_hydro(t,'psp')
;
af_hydro(reservoir,t)                   =          availup_hydro(t,'reservoir')
;
af_PV_up(t,sr,n)$MapSR(n,sr)            =          availup_res(t,sr)
;
delta_af_PV(t,sr,n)$MapSR(n,sr)         =           availup_res(t,sr) * 0.5
;
af_Wind_up(t,wr,n)$MapWR(n,wr)          =          availup_res(t,wr)
;
delta_af_Wind(t,wr,n)$MapWR(n,wr)       =            availup_res(t,wr) * 0.5
;
*************************************Investments************************************

I_costs_220(l)      =  Grid_invest(l,'Inv_costs_220')/(8760/card(t))
;
I_costs_380(l)      =  Grid_invest(l,'Inv_costs_380')/(8760/card(t))
;

*************************************calculating************************************

H(l,n)                              =            B(l)* incidence(l,n)
;
load(n,t)$(De(n))                   =            (load_share(n)*total_load(t) ) / 5
;
delta_load(n,t)$(De(n))             =            load_share(n)*total_load(t) * 0.1
; 
load(n,t)$(border_states(n))        =            (Neighbor_Demand(t,n)) 
;
delta_load(n,t)$(border_states(n))  =            Neighbor_Demand(t,n) * 0.1
;
delta_Cap_conv(g)                   =            Cap_conv(g) * 0.9
;


var_costs(g,t)                      =            ((FC_conv(g,t)+ co2_costs(t) * co2_content(g)) / Eff_conv(g))
;
su_costs(g,t)                       =            depri_costs(g) + su_fact(g) * fuel_start(g) * FC_conv(g,t) + co2_content(g) * co2_costs(t)
;

*execute_unload "check.gdx";
*$stop
*************************************upload table clearing**************************

option kill = Node_Demand ;   
option kill = Ger_Demand ; 
option kill = Grid_tech ;
option kill = Gen_conv ;
option kill = Gen_res ;
option kill = Gen_Hydro ;
option kill = priceup ;
option kill = availup_hydro ;
option kill = availup_res ;
option kill = Grid_invest ;

*######################################variables######################################

Variables
*********************************************Master*************************************************
O_M                         Objective var of Master Problem
PF_M(l,t,v)                 power flows derived from DC load flow equation
Theta(n,t,v)                Angle of each node associated with DC power flow equations

*********************************************Subproblem*********************************************

O_Sub                       Objective var of dual Subproblem
lam(n,t)                    dual var lamda assoziated with Equation: MP_marketclear
phi(l,t)                    dual var phi assoziated with Equation: MP_PF_Ex
teta_ref(n,t)               dual var beta assoziated with Equation: Theta_ref
;
positive Variables
*********************************************MASTER*************************************************

ETA                         aux var to reconstruct obj. function of the ARO problem
PG_M_conv(g,t,v)            power generation level of conventional generators
PG_M_Hydro(s,t,v)           power generation from hydro reservoir and psp and ror
PG_M_PV(res,t,v)            power generation level of renewable volatil PV generators
PG_M_Wind(res,t,v)          power generation level of renewable volatil wind generators
PLS_M(n,t,v)                load shedding

*********************************************Subproblem*********************************************

Pdem(n,t)                   realization of demand (Ro)
PE_conv(g,t)                realization of conventional supply (Ro)
AF_PV(t,sr,n)                realization of PV availability (Ro)
AF_wind(t,wr,n)              realization of Wind availability (Ro)

phiPG_conv(g,t)             dual var phi assoziated with Equation: MP_PG_conv
phiPG_Hydro(s,t)            dual Var phi assoziated with Equation: MP_PG_Hydro
phiPG_PV(res,t)             dual var phi assoziated with Equation: MP_PG_Sun
phiPG_wind(res,t)           dual var phi assoziated with Equation: MP_PG_wind

phiLS(n,t)                  dual var phi assoziated with Equation: MP_LS

omega_UB(l,t)               dual var phi assoziated with Equation: MP_PF_EX_Cap_UB
omega_LB(l,t)               dual var phi assoziated with Equation: MP_PF_EX_Cap_LB

teta_UB(n,t)                dual var beta assoziated with Equation: Theta_UB
teta_LB(n,t)                dual var beta assoziated with Equation: Theta_LB

aux_lam(n,t)                aux continuous var to linearize lam(n.t) * Pdem(n.t) in SUB Objective (Pdem can become variable when uncertainty is considered)
aux_phi_PG(g,t)             aux continuous var to linearize phiPG(g.t) * PE(g.t) in SUB Objective (PE can become variable when uncertainty is considered)
aux_phi_PG_PV(res,t)        aux continuous var to linearize phiPG_PV(sun.t) * AF_PV(sun.t)  in SUB Objective (PE can become variable when uncertainty is considered)
aux_phi_PG_wind(res,t)      aux continuous var to linearize phiPG_wind(wind.t) * AF_wind(wind.t) in SUB Objective (PE can become variable when uncertainty is considered)
aux_phi_LS(n,t)             aux continuous var to linearize phiLS(n.t) * Pdem(n.t) in SUB Objective
;

Binary Variables
*********************************************Master*************************************************

inv_M(l)                    decision variable regarding investment in a prospective line

*********************************************Subproblem*********************************************

z_PG_conv(g,t)              decision variable to construct polyhedral UC-set and decides weather conventional Generation is Max or not
z_PG_PV(res,t)              decision variable to construct polyhedral UC-set and decides weather PV Generation is Max or not
z_PG_wind(res,t)            decision variable to construct polyhedral UC-set and decides weather wind Generation is Max or not
z_dem(n,t)                  decision variable to construct polyhedral UC-set and decides weather Demand is at a lower or upper bound 

*********************old***************************
x(l)                  investment in 220 kV line
y(l)                  investment in 380 kV line
***************************************************
;

Equations
*********************************************Master**************************************************
MP_Objective
MP_IB
MP_marketclear

MP_PG_conv
MP_PG_Hydro
MP_PG_PV
MP_PG_Wind
   
MP_PF_EX       
MP_PF_EX_Cap_UB
MP_PF_EX_Cap_LB

MP_PF_PROS_Cap_UB
MP_PF_PROS_Cap_LB
MP_PF_PROS_LIN_UB
MP_PF_PROS_LIN_LB
  
MP_LS
Theta_UB
Theta_LB
Theta_ref     
MP_ETA

*********************************************Subproblem*********************************************

SUB_Dual_Objective

SUB_Dual_PG_conv
SUB_Dual_PG_hydro
SUB_Dual_PG_sun
SUB_Dual_PG_wind

SUB_Dual_LS
SUB_Dual_PF

SUB_Lin_Dual
SUB_Lin_Dual_n_ref

SUB_US_LOAD
SUB_UB_LOAD

SUB_US_PG_conv
SUB_UB_PG_conv

SUB_US_PG_sun
SUB_UB_PG_sun

SUB_US_PG_wind
SUB_UB_PG_wind

SUB_lin1
SUB_lin2
SUB_lin3
SUB_lin4

SUB_lin5
SUB_lin6
SUB_lin7
SUB_lin8
SUB_lin9
SUB_lin10
SUB_lin11
SUB_lin12
SUB_lin13
SUB_lin14
SUB_lin15
SUB_lin16
SUB_lin17
SUB_lin18
SUB_lin19
SUB_lin20
;

;
*#####################################################################################Master####################################################################################

MP_Objective..                                                      O_M  =e= sum(l, inv_M(l) * I_costs_380(l)) + ETA
;

MP_IB..                                                             IB   =g= sum(l, inv_M(l) * I_costs_380(l))
;

MP_marketclear(n,t,vv)..                     load(n,t)  - PLS_M(n,t,vv)   =e= sum(g$MapG (g,n), PG_M_conv(g,t,vv))
                                                                    
                                                                    + sum(s$MapS(s,n),  PG_M_Hydro(s,t,vv))

                                                                    +  sum(sun$MapRes(sun,n), PG_M_PV(sun,t,vv))
                                                                    +  sum(wind$MapRes(wind,n), PG_M_Wind(wind,t,vv))
                                                    
                                                                    +  sum(l$(Map_Res_l(l,n) and ex_l(l)), PF_M(l,t,vv))
                                                                    -  sum(l$(Map_Send_l(l,n) and ex_l(l)), PF_M(l,t,vv))
                                                                        
                                                                    +  sum(l$(Map_Res_l(l,n) and pros_l(l)), PF_M(l,t,vv))
                                                                    -  sum(l$(Map_Send_l(l,n) and pros_l(l)), PF_M(l,t,vv))
                                                                    
;


MP_PG_conv(g,t,vv)..                           PG_M_conv(g,t,vv)       =l= Cap_conv(g)
;
MP_PG_Hydro(s,t,vv)..                          PG_M_Hydro(s,t,vv)      =l= Cap_hydro(s)
;
MP_PG_PV(sun,sr,n,t,vv)$(MapSR(n,sr) and MapRes(sun,n) and (ord(vv) lt (itaux+1)))..           PG_M_PV(sun,t,vv)      =l= Cap_res(sun) * af_PV_up(t,sr,n) 
;
MP_PG_Wind(wind,wr,n,t,vv)$(MapWR(n,wr) and MapRes(wind,n) and (ord(vv) lt (itaux+1)))..       PG_M_Wind(wind,t,vv)    =l= Cap_res(wind) * af_Wind_up(t,wr,n) 
;



MP_PF_EX(l,t,vv)$(ex_l(l))..                    PF_M(l,t,vv) =e= B(l) * (sum(n$Map_Send_l(l,n),  Theta(n,t,vv)) - sum(n$Map_Res_l(l,n),  Theta(n,t,vv)))
;      
MP_PF_EX_Cap_UB(l,t,vv)$(ex_l(l))..             PF_M(l,t,vv) =l= L_cap(l)
;
MP_PF_EX_Cap_LB(l,t,vv)$(ex_l(l) )..            PF_M(l,t,vv) =g= - L_cap(l)  
;


MP_PF_PROS_Cap_UB(l,t,vv)$(pros_l(l) )..        PF_M(l,t,vv) =l= L_cap_inv_380(l) * inv_M(l)
;
MP_PF_PROS_Cap_LB(l,t,vv)$(pros_l(l) )..        PF_M(l,t,vv) =g= - L_cap_inv_380(l) * inv_M(l)
;
MP_PF_PROS_LIN_UB(l,t,vv)$(pros_l(l) )..        (1-inv_M(l)) *M   =g= PF_M(l,t,vv) - B_prosp_380(l) * (sum(n$Map_Send_l(l,n),  Theta(n,t,vv)) - sum(n$Map_Res_l(l,n),  Theta(n,t,vv)))
;
MP_PF_PROS_LIN_LB(l,t,vv)$(pros_l(l))..         -(1-inv_M(l)) *M  =l= PF_M(l,t,vv) - B_prosp_380(l) * (sum(n$Map_Send_l(l,n),  Theta(n,t,vv)) - sum(n$Map_Res_l(l,n),  Theta(n,t,vv)))
;


MP_LS(n,t,vv)..                                                     PLS_M(n,t,vv) =l= load(n,t)
*Demand_data_fixed(n,t,vv)
;


Theta_UB(n,t,vv)$(Relevant_Nodes(n))..                            3.1415          =g= Theta(n,t,vv)
;
Theta_LB(n,t,vv)$(Relevant_Nodes(n))..                           - 3.1415         =l= Theta(n,t,vv)
;
Theta_ref(n,t,vv)..                                     Theta(n,t,vv)$ref(n)      =e= 0
; 


MP_ETA(vv)..                                                                  ETA =g=   sum((g,t), var_costs(g,t) * PG_M_conv(g,t,vv))
    
                                                                    + sum((s,t), 20 * PG_M_hydro(s,t,vv))
                                                                    + sum((n,t), LS_costs(n) * PLS_M(n,t,vv))
                                                                    
                                    
;
*#####################################################################################Subproblem####################################################################################

SUB_Dual_Objective..                                                O_Sub =e= sum((n,t), lam(n,t) * load(n,t) 
                                                                    + aux_lam(n,t) *    ( + delta_load(n,t)))
                                                                    
                                                               
                                                                    + sum((g,t), - phiPG_conv(g,t) * Cap_conv(g)
                                                                    + aux_phi_PG(g,t) * ( +  delta_Cap_conv(g)))
                                                                    
                                                                    + sum((s,t), - phiPG_hydro(s,t) * Cap_Hydro(s))
                                                                   
                                                                    + sum((sun,t,sr,n)$(MapSR(n,sr) and MapRes(sun,n)),
                                                                    - phiPG_PV(sun,t) * (Cap_res(sun) *  af_PV_up(t,sr,n))
                                                                    + aux_phi_PG_PV(sun,t) * ( Cap_res(sun) * delta_af_PV(t,sr,n)))
                                                                    
                                                                    + sum((wind,t,wr,n)$(MapWR(n,wr) and MapRes(wind,n)),
                                                                    - phiPG_Wind(wind,t) * (Cap_res(wind) *  af_Wind_up(t,wr,n))
                                                                    + aux_phi_PG_Wind(Wind,t) * ( Cap_res(wind) * delta_af_wind(t,wr,n)))


                                                                    + sum((n,t), - phiLS(n,t) * load(n,t) 
                                                                    + aux_phi_LS(n,t) * ( - delta_load(n,t))) 
                                                                 
                                                                    + sum((l,t)$ex_l(l), - omega_UB(l,t) *  L_cap(l))
                                                                    + sum((l,t)$ex_l(l), - omega_LB(l,t) *  L_cap(l))
                                                                    
                                                                    + sum((l,t)$ex_l(l), - omega_UB(l,t) *  L_cap_inv_380(l))
                                                                    + sum((l,t)$ex_l(l), - omega_LB(l,t) *  L_cap_inv_380(l))
                                                                    
                                                                    + sum((n,t), - teta_UB(n,t) * 3.1415)
                                                                    + sum((n,t), - teta_LB(n,t) * 3.1415)
;
*****************************************************************Dual Power generation equation

SUB_Dual_PG_conv(g,t)..                                             sum(n$MapG(g,n) , lam(n,t) -  phiPG_conv(g,t))                           =l= var_costs(g,t)
;
SUB_Dual_PG_hydro(s,t)..                                            sum(n$MapS(s,n) , lam(n,t) -  phiPG_hydro(s,t))                          =l=   20
;
SUB_Dual_PG_sun(sun,t)..                                            sum(n$MapRes(sun,n), lam(n,t) -  phiPG_PV(sun,t))                        =l=   0
;
SUB_Dual_PG_wind(wind,t)..                                          sum(n$MapRes(wind,n), lam(n,t) -  phiPG_Wind(wind,t))                    =l=   0
;

*****************************************************************Dual Load shedding equation

SUB_Dual_LS(t)..                                                    sum(n, lam(n,t) -  phiLS(n,t))                         =l=  3000  
* sum(n$Relevant_Nodes(n), lam(n,t) -  phiLS(n,t))                         =l=  3000  
;
*****************************************************************Dual Power flow equations

SUB_Dual_PF(l,t)$ex_l(l)..                                          - sum(n$(Map_Send_l(l,n)), lam(n,t)) + sum(n$(Map_Res_l(l,n)), lam(n,t))
                                                                    - omega_UB(l,t)  + omega_LB(l,t) + phi(l,t)
                                                                                                                      =e= 0
;
SUB_LIN_Dual(n,t)..                                                 - sum(l$(Map_Send_l(l,n) and ex_l(l) and not ref(n) ),  B(l) * phi(l,t))
                                                                    - sum(l$(Map_Send_l(l,n) and ex_l(l) and not ref(n) ),  B_prosp_380(l) * phi(l,t))
                                                                    + sum(l$(Map_Res_l(l,n) and ex_l(l) and not ref(n) ),   B(l) * phi(l,t))
                                                                    + sum(l$(Map_Res_l(l,n) and ex_l(l) and not ref(n) ),   B_prosp_380(l) * phi(l,t))
                                                                    -  teta_UB(n,t)
                                                                    +  teta_LB(n,t)                                  =e= 0
;
SUB_Lin_Dual_n_ref(n,t)..                                           - sum(l$(Map_Send_l(l,n) and ex_l(l) and ref(n)), B(l)  * phi(l,t))
                                                                    + sum(l$(Map_Res_l(l,n) and ex_l(l) and ref(n)),  B(l)  * phi(l,t))
                                                                    
                                                                    +  teta_ref(n,t)                                  =e= 0

;

*****************************************************************Uncertainty Sets/ and polyhedral uncertainty budgets (level 2 problem)

SUB_US_LOAD(n,t)..                                                  Pdem(n,t)  =e= load(n,t) + delta_load(n,t) * z_dem(n,t)
;
SUB_UB_LOAD..                                                       sum((n,t), z_dem(n,t))  =l= Gamma_load 
;

SUB_US_PG_conv(g,t)..                                               PE_conv(g,t) =e= Cap_conv(g) - delta_Cap_conv(g) * z_PG_conv(g,t)
;
SUB_UB_PG_conv..                                                    sum((g,t), z_PG_conv(g,t))   =l= Gamma_PG_conv 
;

SUB_US_PG_sun(sun,sr,n,t)$(MapSR(n,sr) and MapRes(sun,n))..         AF_PV(t,sr,n) =e= af_PV_up(t,sr,n) - delta_af_PV(t,sr,n) * z_PG_PV(sun,t)
;
SUB_UB_PG_sun(t)..                                                  sum(sun, z_PG_PV(sun,t))   =l= Gamma_PG_PV 
;

SUB_US_PG_wind(wind,wr,n,t)$(MapWR(n,wr) and MapRes(wind,n))..      AF_wind(t,wr,n) =e= af_Wind_up(t,wr,n) - delta_af_wind(t,wr,n) * z_PG_Wind(wind,t)
;
SUB_UB_PG_wind(t)..                                                 sum(wind, z_PG_Wind(wind,t))   =l= Gamma_PG_Wind 
;

*****************************************************************linearization


SUB_lin1(n,t)..                                                     aux_lam(n,t)                                    =l= M * z_dem(n,t)
;
SUB_lin2(n,t)..                                                     lam(n,t)  - aux_lam(n,t)                        =l= M * ( 1 - z_dem(n,t))
;
SUB_lin3(n,t)..                                                     - M * z_dem(n,t)                                =l= aux_lam(n,t)
;
SUB_lin4(n,t)..                                                     - M * ( 1 - z_dem(n,t))                         =l= lam(n,t)  - aux_lam(n,t) 
;


SUB_lin5(g,t)..                                                     aux_phi_PG(g,t)                                 =l= M *   z_PG_conv(g,t)
;
SUB_lin6(g,t)..                                                     phiPG_conv(g,t) - aux_phi_PG(g,t)               =l= M *  ( 1 - z_PG_conv(g,t))
;
SUB_lin7(g,t)..                                                     - M *   z_PG_conv(g,t)                          =l= aux_phi_PG(g,t)
;
SUB_lin8(g,t)..                                                     - M *  ( 1 - z_PG_conv(g,t))                    =l= phiPG_conv(g,t) - aux_phi_PG(g,t)
;
*$ontext
SUB_lin9(sun,t)..                                                   aux_phi_PG_PV(sun,t)                            =l= M *   z_PG_PV(sun,t)
;
SUB_lin10(sun,t)..                                                  phiPG_PV(sun,t) - aux_phi_PG_PV(sun,t)          =l= M *  ( 1 - z_PG_PV(sun,t))
;
SUB_lin11(sun,t)..                                                  - M *   z_PG_PV(sun,t)                          =l= aux_phi_PG_PV(sun,t)
;
SUB_lin12(sun,t)..                                                  - M *  ( 1 - z_PG_PV(sun,t))                    =l= phiPG_PV(sun,t) - aux_phi_PG_PV(sun,t)
;

SUB_lin13(wind,t)..                                                 aux_phi_PG_Wind(wind,t)                         =l= M *   z_PG_Wind(wind,t)
;
SUB_lin14(wind,t)..                                                 phiPG_Wind(wind,t) - aux_phi_PG_Wind(wind,t)    =l= M *  ( 1 - z_PG_Wind(wind,t))
;
SUB_lin15(wind,t)..                                                 - M *   z_PG_Wind(wind,t)                       =l= aux_phi_PG_Wind(wind,t)
;
SUB_lin16(wind,t)..                                                 - M *  ( 1 - z_PG_Wind(wind,t))                 =l= phiPG_Wind(wind,t) - aux_phi_PG_Wind(wind,t)
;
*$offtext

SUB_lin17(n,t)..                                                    aux_phi_LS(n,t)                                 =l= M * z_dem(n,t)
;
SUB_lin18(n,t)..                                                    phiLS(n,t) - aux_phi_LS(n,t)                    =l= M * ( 1 - z_dem(n,t))
;
SUB_lin19(n,t)..                                                    - M * z_dem(n,t)                                =l= aux_phi_LS(n,t)
;
SUB_lin20(n,t)..                                                    - M * ( 1 - z_dem(n,t))                         =l= phiLS(n,t) - aux_phi_LS(n,t)
;

********************************************Model definition**********************************************
model Master_VO
/
MP_Objective
MP_IB
/

;
model Master
/
MP_Objective
MP_IB
MP_marketclear

MP_PG_conv
MP_PG_Hydro
MP_PG_PV
MP_PG_Wind
   
MP_PF_EX       
MP_PF_EX_Cap_UB
MP_PF_EX_Cap_LB

MP_PF_PROS_Cap_UB
MP_PF_PROS_Cap_LB
MP_PF_PROS_LIN_UB
MP_PF_PROS_LIN_LB
  
MP_LS
Theta_UB
Theta_LB
Theta_ref     
MP_ETA
/
;
*solve Master using MIP minimizing O_M;
*execute_unload "check_Master.gdx";
*$stop

model Subproblem
/
SUB_Dual_Objective

SUB_Dual_PG_conv
SUB_Dual_PG_hydro
SUB_Dual_PG_sun
SUB_Dual_PG_wind

SUB_Dual_LS
SUB_Dual_PF

SUB_Lin_Dual
SUB_Lin_Dual_n_ref

SUB_US_LOAD
SUB_UB_LOAD

SUB_US_PG_conv
SUB_UB_PG_conv

SUB_US_PG_sun
SUB_UB_PG_sun

SUB_US_PG_wind
SUB_UB_PG_wind

SUB_lin1
SUB_lin2
SUB_lin3
SUB_lin4

SUB_lin5
SUB_lin6
SUB_lin7
SUB_lin8
SUB_lin9
SUB_lin10
SUB_lin11
SUB_lin12
SUB_lin13
SUB_lin14
SUB_lin15
SUB_lin16
SUB_lin17
SUB_lin18
SUB_lin19
SUB_lin20
/
;
option optcr = 0.1
;
Gamma_Load = 0
;
Gamma_PG_conv = 0
;
Gamma_PG_PV = 100
;
Gamma_PG_Wind = 0
;
*inv_iter_hist(l,v)  = 0;
LB                  = -1e10
;
UB                  =  1e10
;
itaux               = 0
;

Loop(v$((UB - LB) gt Toleranz),

Demand_data_fixed(n,t,v) = load(n,t)
;
PG_M_fixed_conv(g,t,v) = Cap_conv(g)
;
AF_M_PV_fixed(t,sr,n,v) =   af_PV_up(t,sr,n)
;
AF_M_Wind_fixed(t,wr,n,v) =  af_wind_up(t,wr,n)
;

itaux = ord(v)
;
if( ord(v) = 1,

*Demand_data_fixed(n,t,v) = load(n,t)
*;
*PG_M_fixed_conv(g,t,v)= Cap_conv(g)
*;
*AF_M_PV_fixed(t,sr,n,v) =   af_PV_up(t,sr,n)
*;
*AF_M_Wind_fixed(t,wr,n,v) =  af_wind_up(t,wr,n)
*;


*#######################################################Step 2

    solve Master_VO using MIP minimizing O_M
    ;

else

    solve Master using MIP minimizing O_M
    ;
  );
*######################################################Step 3

LB =  O_M.l
*O_M.l
;
inv_cost_master = sum(l,  inv_M.l(l)* I_costs_380(l));

            report_decomp(v,'itaux','')         = itaux;
            report_decomp(v,'Gamma_Load','')    = Gamma_Load                                                    + EPS;
            report_decomp(v,'GAMMA_PG_conv','') = GAMMA_PG_conv                                                 + EPS;
            report_decomp(v,'GAMMA_PG_PV','')   = GAMMA_PG_PV                                                   + EPS;
            report_decomp(v,'GAMMA_PG_wind','') = GAMMA_PG_wind                                                 + EPS;
            report_decomp(v,'Line built',l)     = inV_M.l(l)                                                         ;
            report_decomp(v,'line cost','')     = inv_cost_master                                               + EPS;
            report_decomp(v,'M_obj','')         = O_M.L                                                         + EPS;
            report_decomp(v,'ETA','')           = ETA.l                                                         + EPS;
            report_decomp(v,'LB','')            = LB;
            report_decomp(v,'M_Shed','')        = SUM((n,t), PLS_M.l(n,t,v))                                    + EPS;
            report_decomp(v,'M_GC','')          = SUM((g,t), var_costs(g,t) * PG_M_conv.l(g,t,v))               + EPS;
            report_decomp(v,'M_LS','')          = SUM((n,t), LS_costs(n) * PLS_M.l(n,t,v))                      + EPS;
         

;
*######################################################Step 4

$include network_expansion_merge.gms

;
*######################################################Step 5

solve Subproblem using MIP maximizing O_Sub
;
*######################################################Step 6

UB = min(UB, (sum(l, inv_M.l(l)* I_costs_380(l)) + O_Sub.l))
;

            report_decomp(v,'network','')       = card(ex_l);
            report_decomp(v,'Sub_obj','')       = O_Sub.L                                                       + EPS;
            report_decomp(v,'UB','')            = UB;
            report_decomp(v,'Sub_Shed','')      = SUM((n,t), phiLS.m(n,t))                                      + EPS;
            report_decomp(v,'UB-LB','')         = UB - LB                                                       + EPS;
            report_decomp(v,'Gen_conv','')      = SUM((g,t), PE_conv.l(g,t))                                    + EPS;
            
*######################################################Step 7

Demand_data_fixed(n,t,v) = Pdem.l(n,t)
;
PG_M_fixed_conv(g,t,v) = PE_conv.l(g,t)
;
AF_M_PV_fixed(t,sr,n,v) = AF_PV.l(t,sr,n)
;
AF_M_Wind_fixed(t,wr,n,v) = AF_Wind.l(t,wr,n)
;

*execute_unload "check_ARO_toy_complete.gdx"
$include network_expansion_clean.gms
;
)

execute_unload "TEP_ARO_Test.gdx";
$stop

