option profile = 1;
option profiletol = 0.01;


$setGlobal Prosp_exist "*"          if "*" only existing lines are taken into account, if "" model can invest into prospective lines
$setGlobal Start_up    ""          if "*" starts ups are not concidered, if "" start ups are concidered
$setGlobal only_380    ""           if "*" only investments in 380 KV lines are taken into account, if "" 220 kV and 380 kV lines are taken into account
$setGlobal Borderexp   ""           if "*" border expansion, if "" no border expansion
$setGlobal endotrans   "*"          if "*" transmission between countries is modelled engogeniously, if "" then physical flow is added exogeniously
;

Sets

n /n1*n509/
*d /d1*d511/
l /l1*l1680/
g /g1*g559/
s /s1*s175/
Res/res1*res1018/
t/t1*t23/
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
exist(l)/l1*l840/
prosp(l)/l841*l1680/

Border_exist_DE(l)
Border_exist_total(l)

Border_prosp_DE(l)
Border_prosp_total(l)


****************************nodes***************************************************
ref(n)   /n1/
DE(n)    /n1*n495/
NoDeSciGrid(n) /n65,n97,n182,n203,n222,n237,n263,n273,n274,n317,n321,n325,n328,n355,n357,n358
n359,n361,n362,n404,n405,n416,n417,n430,n432/
border_states(n) /n500*n509/
connected_states(n) /n500*n508/

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


Relevant_Nodes(n)/n1*n495,n500*n509/

*****************************mapping************************************************
Map_grid(l,n)
Map_send_L(l,n)
Map_res_L(l,n)
MapG(g,n)
MapS(s,n)
*MapD(d,n)

MapRes(res,n)

MapSr(n,sr)
MapWr(n,wr)


;
alias (n,nn),(t,tt),(l,ll)

;
****************************************scalars**************************************
Scalars
ILmax        /2000000000/
*max invest budget
M            /5000/
*big M
reliability  /1/
*reliability of powerlines (simplification of n-1 criteria)
cur_costs    /150/
*curtailment costs
store_cpf    /7/
*ratio storage capacity factor
MVABase      /500/
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
availup_res
*availup_sun                     upload table
*availup_wind                    upload table
Grid_invest                     upload table

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
Fc_conv(g,t)                    fuel costs conventional powerplants
Fc_res(res,t)                   fuel costs renewable powerplants
CO2_content(g)                  Co2 content
CO2_costs(t)                    CO2 costs
SU_costs(g,t)                   start-up costs conventionals

su_fact(g)                      start-up factor conventionals
fuel_start(g)                   fuel consumption factor if start-up decision
depri_costs(g)                  deprication costs conventionals

total_load(t)                   electrical demand in germany in hour t
load(n,t)                       electrical demand in each node in hour t
load_share(n)                   electrical demand share per node
Neighbor_Demand(t,n)            electrical demand in neighboring countries of germany in hour t
LS_costs(n)                     loadshedding costs per node
var_costs(g,t)                  variable costs conventional power plants

cap_conv(g)                     max. generation capacity of each conventional generator
cap_hydro(s)                    max. generation capacity of each psp
cap_res(res)                    max. generation capacity of each RES

Eff_conv(g)                     efficiency of conventional powerplants
Eff_hydro(s)                    efficiency of hydro powerplants
Eff_res(res)                    efficiency of renewable powerplants

af_hydro(s,t)                   availability of hydro potential
af_sun(t,sr,n)                  capacity factor of solar energy
af_wind(t,wr,n)                 capacity factor of wind energy

phy_flow_to_DE(t,n)             physical cross border flow for each country specific node in direct realtion with germany
phy_flow_states_exo(t,n)        physical cross border flow for each country specific node in no realtion with germany

*********************************************report parameters********************************************************

Time_restrict_up
Time_restrict_lo
*solve_time(,*)

mapped_flow(l,t)                directed flow report
mapped_flow_DE(t)               saldo flow report regarding total Ex and imports of germany
mapped_ExIm_flow(l,t)           directed flow report from and to DE neigboring countries
mapped_ExIm_sum_flow(n)  	   directed summarized flow report from and to DE neigboring countries

resulting_load_De(t)
price(n,t)
price_de(t)

total_gen(t)
total_gen_g(t)
total_gen_r(t)
total_gen_s(t)

DE_gen_lig(t)
DE_gen_coal(t)
DE_gen_gas(t)
DE_gen_oil(t)
DE_gen_nuc(t)
DE_gen_waste(t)

DE_gen_Sun(t)
DE_gen_Wind(t)
DE_gen_BIO(t)

DE_gen_ROR(t)
DE_gen_PSP(t)
DE_gen_Reservoir(t)

DE_charge(t)

countries_gen_lig(n,t)
countries_gen_coal(n,t)
countries_gen_gas(n,t)
countries_gen_oil(n,t)
countries_gen_nuc(n,t)
countries_gen_waste(n,t)

countries_gen_sun(n,t)
countries_gen_wind(n,t)
countries_gen_bio(n,t)

countries_gen_ROR(n,t)
countries_gen_PSP(n,t)
countries_gen_Reservoir(n,t)

Gen_Denmark(n,t)
Gen_Sweden(n,t)
Gen_Poland(n,t)
Gen_Czechia(n,t)
Gen_Austria(n,t)
Gen_Swiss(n,t)
Gen_France(n,t)
Gen_Luxemburg(n,t)
Gen_Belgium(n,t)
Gen_Netherland(n,t)

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
%Borderexp% prosp(l)$(Border_prosp_DE(l)) = no
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


af_hydro(ror,t)             =          availup_hydro(t,'ror')
;
af_hydro(psp,t)             =          availup_hydro(t,'psp')
;
af_hydro(reservoir,t)       =          availup_hydro(t,'reservoir')
;
af_sun(t,sr,n)$MapSR(n,sr)  =          availup_res(t,sr)
;
af_wind(t,wr,n)$MapWR(n,wr) =          availup_res(t,wr)
;
*************************************Investments************************************

I_costs_220(l)      =  Grid_invest(l,'Inv_costs_220')/(8760/card(t))
;
I_costs_380(l)      =  Grid_invest(l,'Inv_costs_380')/(8760/card(t))
;

*************************************calculating************************************

H(l,n)                              =            B(l)* incidence(l,n)
;
load(n,t)$(De(n))                   =            load_share(n)*total_load(t)
;
load(n,t)$(border_states(n))        =            Neighbor_Demand(t,n)
;
var_costs(g,t)                      =            ((FC_conv(g,t)+ co2_costs(t) * co2_content(g)) / Eff_conv(g))
;
su_costs(g,t)                       =            depri_costs(g) + su_fact(g) * fuel_start(g) * FC_conv(g,t) + co2_content(g) * co2_costs(t)
;

execute_unload "check.gdx";
$stop
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
Costs
Power_flow(l,t)
Theta(n,t)
;

positive Variables
Gen_g (g,t)             generation conventionals
Gen_r(res,t)            generation renewables
Gen_s (s,t)             generation hydro

storagelvl(s,t)
charge(s,t)

Su(g,t)
P_on(g,t)

Load_shed (n,t)
Curtailment (res,t)
X_dem(n,t)             variable to prevent model from infeasibility due to increasing el. demand at high costs
;

Binary variables
x(l)                  investment in 220 kV line
y(l)                  investment in 380 kV line
;



Equations
Total_costs
Line_investment
Balance

max_gen
max_cap
startup_constr

max_res_biomass
max_res_sun
max_res_wind

max_ror
min_reservoir
max_reservoir

Store_level_start
Store_level
Store_level_end
Store_level_max
Store_prod_max
Store_prod_max_end

Ex_line_angle
Ex_Line_neg_flow
Ex_line_pos_flow


Prosp_line_neg_flow
Prosp_line_pos_flow

Linearization_prosp_220_line_neg
Linearization_prosp_220_line_pos

Linearization_prosp_380_line_neg
Linearization_prosp_380_line_pos

LS_det
Theta_LB
Theta_UB
Theta_ref
;
*#######################################################objective##########################################################

Total_costs..                costs =e=   sum((g,t), Var_costs(g,t) * Gen_g(g,t))
%Start_up%                             + sum((g,t), Su(g,t) *su_costs(g,t))
                                       + sum((res,t), Fc_res(res,t) * Gen_r(res,t))
                                       + sum((n,t), LS_costs(n) * Load_shed(n,t))
                                       + sum((res,t), Curtailment(res,t) * cur_costs)
                                       
%Prosp_exist%                          + sum((n,t), X_dem(n,t))* 350
%Prosp_exist%                          + sum((l,t)$prosp(l),I_costs_220(l)*x(l)+I_costs_380(l)*y(l))
;

Line_investment..            sum((l)$prosp(l), I_costs_380(l)*y(l)
%only_380%                                   + I_costs_220(l)*x(l)
                                                                    )
                                                                    =l= ILmax
;

*####################################################energy balance########################################################

Balance(n,t)$(Relevant_Nodes(n))..                (load(n,t) - Load_shed(n,t))  =e= sum(g$MapG(g,n),Gen_g(g,t))


                                                           + sum(biomass$MapRes(biomass,n),Gen_r(biomass,t))
                                                           + sum(sun$MapRes(sun,n),Gen_r(sun,t))
                                                           + sum(wind$MapRes(wind,n),Gen_r(wind,t))

                                                           + sum(s$MapS(s,n), Gen_s(s,t))
                                                           - sum(l$(Map_send_L(l,n) and exist(l)),Power_flow(l,t))
                                                           + sum(l$(Map_res_L(l,n) and exist(l)),Power_flow(l,t))
*                                                           + sum(l$map_grid(l,n),Power_flow(l,t)$exist(l))
*                                                           

%Prosp_exist%                                              - sum(l$(Map_send_L(l,n) and prosp(l)),Power_flow(l,t))
%Prosp_exist%                                              + sum(l$(Map_res_L(l,n) and prosp(l)),Power_flow(l,t))

                                                           - sum(psp$MapS(psp,n), charge(psp,t))
                                                           

%endotrans%                                                + phy_flow_to_DE(t,n)
                                                           + phy_flow_states_exo(t,n)
*                                                           - X_dem(n,t)
;
**Eff_res(biomass)
*######################################################generation##########################################################

max_gen(g,t)..                                                  Gen_g(g,t) =l= P_on(g,t)
;
max_cap(g,t)..                                                  P_on(g,t)  =l= cap_conv(g)
;
startup_constr(g,t)..                                           P_on(g,t) - P_on(g,t-1) =l= Su(g,t)
;
max_res_biomass(biomass,t)..                                    gen_r(biomass,t) =l=  cap_res(biomass)
;
max_res_sun(sun,sr,n,t)$(MapSR(n,sr) and MapRes(sun,n))..       gen_r(sun,t) =e=  af_sun(t,sr,n) * cap_res(sun)- Curtailment(sun,t)
;
max_res_wind(wind,wr,n,t)$(MapWR(n,wr) and MapRes(wind,n))..    gen_r(wind,t) =e= af_wind(t,wr,n) * cap_res(wind)- Curtailment(wind,t)
;

********************************************************Hydro RoR**********************************************************

max_ror(ror,t)..                                            gen_s(ror,t) =l= af_hydro(ror,t) * cap_hydro(ror)
;

********************************************************Hydro PsP**********************************************************
Store_level_start(psp,t)$(ord(t) =1)..                      storagelvl(psp,t) =e= cap_hydro(psp) *0.5 + charge(psp,t) * eff_hydro(psp) - gen_s(psp,t)
;
Store_level(psp,t)$(ord(t) gt 1)..                          storagelvl(psp,t) =e= storagelvl(psp,t-1) + charge(psp,t-1) * eff_hydro(psp) - gen_s(psp,t-1)
;
Store_level_end(psp,t)$(ord(t) = card(t))..                 storagelvl(psp,t) =e= cap_hydro(psp) *0.5 
;
Store_level_max(psp,t)..                                    storagelvl(psp,t) =l= cap_hydro(psp) * store_cpf
;
Store_prod_max(psp,t)..                                     gen_s(psp,t) + charge(psp,t) *1.2 =l= cap_hydro(psp) * af_hydro(psp,t)
;
Store_prod_max_end(psp,t)$(ord(t) = card(t))..              gen_s(psp,t)      =l= storagelvl(psp,t)
;
*****************************************************Hydro reservoir******************************************************

min_reservoir(reservoir,t)..                                gen_s(reservoir,t) =G= cap_hydro(reservoir) * af_hydro(reservoir,t) * 0.15
;
max_reservoir(reservoir,t)..                                gen_s(reservoir,t) =l= cap_hydro(reservoir) * af_hydro(reservoir,t)
;

*##########################################################Grid###########################################################



Ex_line_angle(l,t)$exist(l)..                               power_flow(l,t) + EPS =e=  (B(l)*(sum(n$Map_send_L(l,n), Theta(n,t))-sum(n$Map_res_L(l,n), Theta(n,t))))* MVABase
;
*Ex_line_angle(l,t)$exist(l)..                               power_flow(l,t) + EPS =e=  (B(l)*(sum(n$Map_Grid(l,n), Theta(n,t) -Theta)nn,t)* MVABase
*;
*Ex_line_angle(l,t)$exist(l)..                               power_flow(l,t) =e=  sum(n$H(l,n), H(l,n)*(Theta(n,t)$Map_send_L(l,n) - Theta(n,t)$Map_res_L(l,n))) *500
*;
Ex_line_neg_flow(l,t)$exist(l)..                            power_flow(l,t) + EPS =g= -L_cap(l)*circuits(l)*reliability
;
Ex_line_pos_flow(l,t)$exist(l)..                            power_flow(l,t) + EPS =l=  L_cap(l)*circuits(l)*reliability
;

Prosp_line_neg_flow(l,t)$prosp(l)..                         power_flow(l,t) + EPS =g= (- y(l) * L_cap_inv_380(l)
%only_380%                                                                             - x(l) * L_cap_inv_220(l)
                                                                                                                ) * reliability
;
Prosp_line_pos_flow(l,t)$prosp(l)..                         power_flow(l,t) + EPS =l= (  y(l) * L_cap_inv_380(l)
%only_380%                                                                             + x(l) * L_cap_inv_220(l) 
                                                                                                                ) * reliability
;
Linearization_prosp_220_line_neg(l,t)$prosp(l)..            -(1-x(l))*M   =l= power_flow(l,t) - B_prosp_220(l) * (sum(n$Map_send_L(l,n),Theta(n,t))-sum(n$Map_res_l(l,n),Theta(n,t))) * MVABase  + EPS
;
Linearization_prosp_220_line_pos(l,t)$prosp(l)..            (1-x(l))*M    =g= power_flow(l,t) - B_prosp_220(l) * (sum(n$Map_send_L(l,n),Theta(n,t))-sum(n$Map_res_l(l,n),Theta(n,t))) * MVABase  + EPS
;
Linearization_prosp_380_line_neg(l,t)$prosp(l)..            -(1-y(l))*M   =l= power_flow(l,t) - B_prosp_380(l) * (sum(n$Map_send_L(l,n),Theta(n,t))-sum(n$Map_res_l(l,n),Theta(n,t))) * MVABase  + EPS
;
Linearization_prosp_380_line_pos(l,t)$prosp(l)..            (1-y(l))*M    =g= power_flow(l,t) - B_prosp_380(l) * (sum(n$Map_send_L(l,n),Theta(n,t))-sum(n$Map_res_l(l,n),Theta(n,t))) * MVABase  + EPS
;

LS_det(n,t)..                                               load_shed(n,t)  =l= load(n,t)
;
Theta_LB(n,t)..                                             -3.1415         =l= Theta(n,t)
;
Theta_UB(n,t)..                                             3.1415          =g= Theta(n,t)
;
Theta_ref(n,t)..                                            Theta(n,t)$ref(n) =l= 0
;
*execute_unload "check.gdx";
*$stop
*#########################################################Solving##########################################################

Model Large_Stat_det_Tep
/
Total_costs
%Prosp_exist%Line_investment
Balance

max_gen
max_cap
%Start_up%startup_constr

max_res_biomass
max_res_sun
max_res_wind

max_ror
min_reservoir
max_reservoir

Store_level_start
Store_level
Store_level_end
Store_level_max
Store_prod_max
Store_prod_max_end

Ex_line_angle
Ex_Line_neg_flow
Ex_line_pos_flow


%Prosp_exist%Prosp_line_neg_flow
%Prosp_exist%Prosp_line_pos_flow

%only_380%%Prosp_exist%Linearization_prosp_220_line_neg
%only_380%%Prosp_exist%Linearization_prosp_220_line_pos

%Prosp_exist%Linearization_prosp_380_line_neg
%Prosp_exist%Linearization_prosp_380_line_pos


LS_det
Theta_LB
Theta_UB
Theta_ref

/;
*#######################################################Solving##########################################################

Large_Stat_det_Tep.scaleopt = 1
;
%Prosp_exist% option optcr =0.05
;
solve Large_Stat_det_Tep using MIP minimizing costs
;
price(n,t) = Balance.m(n,t)*(-1)
;
execute_unload "check.gdx"
;

*#################################################defining REPORT parameters###############################################
*********************************************************powerflows********************************************************

*$ontext
mapped_flow(l,t) = power_flow.l(l,t)
;
mapped_ExIm_flow(l,t) = mapped_flow(l,t)$(exist_borderlines_DE(l))
;
mapped_flow_DE(t) = sum((l),mapped_ExIm_flow(l,t))
;
*$offtext

$ontext
mapped_flow(l,t,n) = power_flow.l(l,t)$(Map_send_L(l,n))- power_flow.l(l,t)$(Map_res_L(l,n))
;
mapped_ExIm_flow(l,t,n) = mapped_flow(l,t,n)$(exist_borderlines_DE(l) and DE(n))
;
mapped_ExIm_sum_flow(n) = sum((t,l),mapped_ExIm_flow(l,t,n))
;
mapped_flow_DE(t) = sum((l,n),mapped_ExIm_flow(l,t,n))
;
$offtext
*******************************************************load and prices*****************************************************


price(n,t) = Balance.m(n,t)*(-1)
;
price_de(t) =sum(n$De(n),price(n,t)/467)
;
resulting_load_De(t) = total_load(t) + mapped_flow_DE(t)
*                    - sum(n$(De(n)),Load_shed.l(n,t))
                    + sum((s,n)$(MapS(s,n) and DE(n)),charge.l(s,t)) 
             
;
De_charge(t) = sum((s,n)$(MapS(s,n) and DE(n)),charge.l(s,t))
;
********************************************************total generation DE************************************************


total_gen_g(t) = sum((g,n)$(MapG(g,n) and DE(n)), gen_g.l(g,t))
;
total_gen_r(t) = sum((res,n)$(MapRes(res,n) and DE(n)), gen_r.l(res,t))
;
total_gen_s(t) = sum((s,n)$(MapS(s,n) and DE(n)), gen_s.l(s,t))
;
total_gen(t) = total_gen_g(t) + total_gen_r(t) + total_gen_s(t)
;

*************************************************Germany conventional generation*******************************************

DE_gen_lig(t) = sum((lig,n)$(MapG(lig,n) and DE(n)),Gen_g.l(lig,t))+EPS
;
DE_gen_coal(t)= sum((coal,n)$(MapG(coal,n) and DE(n)),Gen_g.l(coal,t))+EPS
;
DE_gen_gas(t) = sum((gas,n)$(MapG(gas,n) and DE(n)),Gen_g.l(gas,t))+EPS
;
DE_gen_oil(t) = sum((oil,n)$(MapG(oil,n) and DE(n)),Gen_g.l(oil,t))+EPS
;
DE_gen_nuc(t) = sum((nuc,n)$(MapG(nuc,n) and DE(n)),Gen_g.l(nuc,t))+EPS
;
DE_gen_waste(t) = sum((waste,n)$(MapG(waste,n) and DE(n)),Gen_g.l(waste,t))+EPS
;
*************************************************Germany renwebable generation*********************************************

DE_gen_Sun(t) = sum((sun,n)$(MapRes(sun,n)and DE(n)),Gen_r.l(sun,t))+EPS
;
DE_gen_Wind(t) = sum((wind,n)$(MapRes(wind,n)and DE(n)),Gen_r.l(wind,t))+EPS
;
DE_gen_BIO(t) = sum((biomass,n)$(MapRes(biomass,n)and DE(n)),Gen_r.l(biomass,t))+EPS
;
****************************************************Germany Hydro generation**********************************************

DE_gen_ROR(t) = sum((ror,n)$(MapS(ror,n) and DE(n)), Gen_s.l(ror,t))+EPS
;
DE_gen_PSP(t) =  sum((psp,n)$(MapS(psp,n) and DE(n)), Gen_s.l(psp,t))+EPS
;
DE_gen_Reservoir(t) = sum((reservoir,n)$(MapS(reservoir,n) and DE(n)), Gen_s.l(reservoir,t))+EPS
;
*#######################################################countries#########################################################
***********************************************countries conventional generation******************************************

countries_gen_lig(n,t)$border_states(n) = sum(lig$(MapG(lig,n)),Gen_g.l(lig,t))+EPS
;
countries_gen_coal(n,t)$border_states(n) = sum(coal$(MapG(coal,n)),Gen_g.l(coal,t))+EPS
;
countries_gen_gas(n,t)$border_states(n) = sum(gas$(MapG(gas,n)),Gen_g.l(gas,t))+EPS
;
countries_gen_oil(n,t)$border_states(n) = sum(oil$(MapG(oil,n)),Gen_g.l(oil,t))+EPS
;
countries_gen_nuc(n,t)$border_states(n)= sum(nuc$(MapG(nuc,n)),Gen_g.l(nuc,t))+EPS
;
countries_gen_waste(n,t)$border_states(n)= sum(waste$(MapG(waste,n)),Gen_g.l(waste,t))+EPS
;
***********************************************countries renwebable generation********************************************

countries_gen_sun(n,t)$border_states(n) = sum(sun$(MapRes(sun,n)),Gen_r.l(sun,t))+EPS
;
countries_gen_wind(n,t)$border_states(n)= sum(wind$(MapRes(wind,n)),Gen_r.l(wind,t))+EPS
;
countries_gen_bio(n,t)$border_states(n) = sum(biomass$(MapRes(biomass,n)),Gen_r.l(biomass,t))+EPS
;
***********************************************countries hydro generation*************************************************

countries_gen_ROR(n,t)$border_states(n) = sum(ror$(MapS(ror,n)), Gen_s.l(ror,t))+EPS
;
countries_gen_PSP(n,t)$border_states(n) = sum(psp$(MapS(psp,n)), Gen_s.l(psp,t))+EPS
;
countries_gen_Reservoir(n,t)$border_states(n) = sum(reservoir$(MapS(reservoir,n)), Gen_s.l(reservoir,t))+EPS
;
**************************************************countries sum gen********************************************************
$ontext
Gen_Denmark(n,t)$DK(n) = Sum((g,res,s),gen_g.l(g,t) + gen_r.l(res,t) +gen_s.l(s,t))
;
Gen_Sweden(n,t)$SW(n)  = Sum((g,res,s),gen_g.l(g,t) + gen_r.l(res,t) +gen_s.l(s,t))
;
Gen_Poland(n,t)$PL(n)  = Sum((g,res,s),gen_g.l(g,t) + gen_r.l(res,t) +gen_s.l(s,t))
;
Gen_Czechia(n,t)$CZ(n) = Sum((g,res,s),gen_g.l(g,t) + gen_r.l(res,t) +gen_s.l(s,t))
;
Gen_Austria(n,t)$AT(n) = Sum((g,res,s),gen_g.l(g,t) + gen_r.l(res,t) +gen_s.l(s,t))
;
Gen_Swiss(n,t)$CH(n)   = Sum((g,res,s),gen_g.l(g,t) + gen_r.l(res,t) +gen_s.l(s,t))
;
Gen_France(n,t)$FR(n)  = Sum((g,res,s),gen_g.l(g,t) + gen_r.l(res,t) +gen_s.l(s,t))
;
Gen_Luxemburg(n,t)$LU(n)= Sum((g,res,s),gen_g.l(g,t) + gen_r.l(res,t) +gen_s.l(s,t))
;
Gen_Belgium(n,t)$BE(n) = Sum((g,res,s),gen_g.l(g,t) + gen_r.l(res,t) +gen_s.l(s,t))
;
Gen_Netherland(n,t)$NL(n)= Sum((g,res,s),gen_g.l(g,t) + gen_r.l(res,t) +gen_s.l(s,t))
;
$offtext
****************************************************load gdx DE************************************************************

execute_unload "check.gdx"
;
execute_unload "results_DE.gdx"
power_flow.l,  x.l,  y.l,  storagelvl.l, gen_g, price, price_de, 
mapped_ExIm_flow, mapped_flow_DE, De_charge,
DE_gen_lig, DE_gen_coal, DE_gen_gas, DE_gen_oil, DE_gen_nuc, DE_gen_waste,
DE_gen_Sun, DE_gen_wind, DE_gen_bio,
DE_gen_ROR, DE_gen_PSP,  DE_gen_Reservoir,
total_load, resulting_load_De, total_gen
;
******************************************load gdx Neighbor countries******************************************************
execute_unload "results_NC.gdx"
countries_gen_lig, countries_gen_coal, countries_gen_gas, countries_gen_oil, countries_gen_nuc, countries_gen_waste,
countries_gen_sun, countries_gen_wind, countries_gen_bio,
countries_gen_ROR, countries_gen_PSP,  countries_gen_Reservoir

;
*************************************************output DE to excel********************************************************

execute '=gams Large_Stat_det_Tep lo=2 gdx=results_DE'
;
execute '=gdx2xls results_DE.gdx'
;
execute '=shellExecute results_De.xlsx'
;
****************************************output Neighbor countries (NC) to excel********************************************

execute '=gams Large_Stat_det_Tep lo=2 gdx=results_NC'
;
execute '=gdx2xls results_NC.gdx'
;
execute '=shellExecute results_NC.xlsx'
;

**************************************************output overview DE*******************************************************

execute '=shellExecute results_view.xlsx'

**************************************************End of the world*********************************************************
*$offtext