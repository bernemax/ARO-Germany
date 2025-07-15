* shows the computational time needed by each prcess until 1 sec.
option profile = 1;
option profiletol = 0.01;

$setGlobal bat ""               if "*" no battery in the model, if "" otherwise
$setGlobal hydrogen ""          if "*" no hydrogen in the model, if "" otherwise
$setGlobal Res_off "*"           if "*" no combined res, if "" otherwise

$setGlobal  ARO_Wind ""          if "*"  Wind reduction, if "" otherwise
$setGlobal  ARO_PV "*"           if "*"  PV reduction, if "" otherwise

$setGlobal Single_PV_Wind ""    if "*" no single Pv & wind, if "" otherwise
;

Sets
*timesteps
t/t1*t2190/
*2190

*node of the specific country
n /DE0,DE1,DE2,DE3,DE4,DE5,DE6,AT0,BE0,CH0,CZ0
,DK0,DK1,EE0,ES0,ES1,ES2,ES3,FI0,FR0,FR1,
FR2,FR3,FR4,FR5,FR6,GB0,GB1,GB2,GB3,GB4,GB5,
HU0,IE0,IT0,IT1,IT2,IT3,IT4,LT0,LU0,LV0,NL0,
NO0,PL0,PT0,SE0,SE1,SI0,SK0
/
*lines/ branches of the grid
l /l1*l97,l1001*l1097/

*conventional baseload generators
g  / 
*nuclear
g3,g8,g11,g16,g22,g29,g35,g41,g48,g53,g60,g64,g68,g71,
g76,g81,g85,g90,g95,g98,g101,g105,g109,g111,g113,g117,
g121,g125,g129,g133,g137,g140,g146,g151,g155,g160,g163,
g167,g169,g172,g178,g180,g183,g187,g191


*Biomass
g6,g10,g13,g19,g26,g32,g39,g45,g51,g56,g62,g67,g93,g97,
g100,g103,g107,g110,g112,g116,g120,g124,g127,g132,g135,
g142,g149,g158,g168
*g132,g138,g145,g152
/
*battery storage set
b /b1*b50/
*hydrogen storage set
h /h1*h50/

*hydro ror, reservoir and PSP set
s /s1,s2,s3,s5,s7,s8,s9,s11,s12,s14,s16,s17,
s18,s19,s20,s21,s22,s23,s25,s28,s29,s30,s31,
s32,s33,s34,s35,s36,s37,s38,s39,s40,s41,s42,
s43,s44,s45,s46,s47,s48,s49,s50,s51,s52,s55,
s56,s58,s59,s60,s61,s62,s63,s64,s65,s66,s67,
s68,s69,s71,s72,s73,s74,s76,s77,s78,s79,s80,
s81,s82,s83,s84,s85,s86,s87,s88,s89,s91,s92,
s93,s94,s95,s96,s97/
*/s1*s97/


* Renewable solar PV, wind onshore and offshore set
Ren/ren1*ren125/

Res/res1*res50/

*regions
rr/rr1*rr6/
*iteration counter set
v /v1*v15/
*weeks time set
WM /WM1,WM21,WM22,WM23,WM24/

****************************Subsets************************************************
*reference node
ref(n)
/DE0/

*lines
ex_l(l)/l1*l97/
pros_l(l)/l1001*l1097/
pros_l_rr1_rr6(l) /l90,l91,l97,l84,l86,l87,l96,l38/
pros_l_rr2_rr3(l) /l80/
pros_l_rr2_rr6(l) /l79/
pros_l_rr3_rr4(l) /l77,l44,l45/
pros_l_rr3_rr5(l) /l15,l16,l58,l1/
pros_l_rr3_rr6(l) /l11,l12,l31,l34,l78/
pros_l_rr5_rr6(l) /l2,l3,l4,l65/
Dc_l(l) /l75,l76,l77,l78,l79,l80,l81,l82,l83,l84,l85,
         l86,l87,l88,l89,l90,l91,l92,l93,l94,l95,l97/ 
AC_l(l)

*thermal
OCGT(g)
CCGT(g)
nuc(g)
lig(g)
coal(g)
oil(g)
waste(g)
biomass(g)

****************************volatil renewables**************************************
wind(ren)
wind_on(ren)
wind_off(ren)
solar_pv(ren)

****************************hydro***************************************************
ror(s)
reservoir(s)
psp(s)
****************************storage**************************************

ex_b(b)
ex_h(h) 

*****************************mapping************************************************
Map_send_L(l,n)
Map_res_L(l,n)
Map_rr_send_l(l,rr)
Map_rr_res_l(l,rr)
Map_grid(l,n)

MapG(g,n)
Map_OCGT(g,n)
Map_CCGT(g,n)
Map_Biomass(g,n)
Map_Nuclear(g,n)

MapS(s,n)
Map_Ren_node(ren,n)
Map_PV(ren,n)
Map_wind(ren,n)
Map_Offwind(ren,n)
Map_Onwind(ren,n)

Map_Battery(b,n)
Map_hydrogen(h,n)

MAP_WM(t,WM)

Map_RR(rr,n)
MAP_RR_G(rr,g)
MAP_RR_OCGT(rr,h)
MAP_RR_B(rr,b)    
Map_RR_ren(rr,ren)
MAP_RR_RoR(rr,s)
MAP_RR_reservoir(rr,s)
MAP_RR_PsP(rr,s)

MAP_RR_Ren_node(rr,ren,n)

Map_Res(res,n)
Map_RR_res(rr,res)
;
alias (n,nn),(t,tt),(l,ll), (v,vv)
;

$include Loading_ARO_GenEx.gms
*execute_unload "check_input.gdx";
*$stop

*######################################variables######################################

Variables
*********************************************Master*************************************************
O_M                         Objective var of Master Problem (total costs)
PF_M(l,t,v)                 power flows derived from DC load flow equation
Theta(t,n,v)                Angle of each node associated with DC power flow equations

*********************************************Subproblem*********************************************

O_Sub                       Objective var of dual Subproblem
lam(t,n)                    dual var lamda assoziated with Equation: MP_marketclear
phi(l,t)                    dual var phi assoziated with Equation: MP_PF_Ex
phi_SL_psp(s,t)             dual var phi assoziated with Equation: MP_Stor_lvl
phi_SL_battery(b,t)         dual var phi assoziated with Equation: MP_battery_lvl
phi_SL_hydrogen(h,t)        dual var phi assoziated with Equation: MP_hydrogen_lvl
teta_ref(t,n)               dual var beta assoziated with Equation: Theta_ref
;
positive Variables
*********************************************MASTER*************************************************

ETA                         aux var to reconstruct obj. function of the ARO problem
PG_M_conv(g,t,v)            power generation level of conventional generators

PG_M_Res(res,t,v)           cummulative power generation level of renewable solar pv and wind generators

PG_M_PV(ren,t,v)            cummulative power generation level of renewable solar pv generators
PG_M_Wind(ren,t,v)          cummulative power generation level of renewable wind generators

PLS_M(t,n,v)                load shedding
PLS_M_1(t,n,v)              load shedding load type 1
PLS_M_2(t,n,v)              load shedding load type 2
PLS_M_3(t,n,v)              load shedding load type 3
L_Cap_exp(l)                Line expansion


PG_M_Hydro(s,t,v)           power generation from hydro reservoir and psp and ror
M_Stor_lvl(s,t,v)           Hydro storage level
M_charge(s,t,v)             hydro storage charge

PG_M_battery(b,t,v)         power generation from battery inverter
M_battery_lvl(b,t,v)        Battery storage level
M_battery_charge(b,t,v)     Battery Inverter storage charge

PG_M_hydrogen(h,t,v)
M_hydrogen_lvl(h,t,v)
M_hydrogen_charge(h,t,v)

*new_line_M(l)                decision variable regarding investment in a new prospective line
Cap_conv_M(g)
Cap_ren_M(ren)
Cap_battery_M(b)


Cap_hydrogen_M(h)
Cap_hydro_stor_M(h)
Cap_electrolysis_M(h)
Cap_OCGT_M(h)


*********************************************Subproblem*********************************************

Pdem(t,n)                   Uncertain load in node n in time step t

PE_conv(g,t)                realization of conventional supply (Ro)

AF_Res(res,t)               realization of combined wind and pv
AF_PV_sub(ren,rr,t)
AF_Wind_sub(ren,rr,t)

mu_PG_conv(g,t)             dual var phi assoziated with Equation: MP_PG_conv
mu_PG_ror(s,t)              dual Var phi assoziated with Equation: MP_PG_Ror
mu_PG_reservoir(s,t)        dual Var phi assoziated with Equation: MP_PG_Reservoir

mu_cap_psp(s,t)            dual Var phi assoziated with Equation: MP_Cap_Stor upper bound
mu_cap_psp_l(s,t)          dual Var phi assoziated with Equation: MP_Cap_Stor lower bound
mu_PG_psp(s,t)             dual var phi assoziated with Equation: MP_PG_Stor
mu_C_psp(s,t)              dual var phi assoziated with Equation: MP_C_Stor

mu_cap_battery(b,t)        dual Var phi assoziated with Equation: MP_Cap_Stor upper bound
mu_cap_battery_l(b,t)      dual Var phi assoziated with Equation: MP_Cap_Stor lower bound
mu_PG_battery(b,t)         dual var phi assoziated with Equation: MP_PG_Stor
mu_C_battery(b,t)          dual var phi assoziated with Equation: MP_C_Stor

mu_cap_hydrogen(h,t)        dual Var phi assoziated with Equation: MP_Cap_Stor upper bound
mu_cap_hydrogen_l(h,t)      dual Var phi assoziated with Equation: MP_Cap_Stor lower bound
mu_PG_hydrogen(h,t)         dual var phi assoziated with Equation: MP_PG_Stor
mu_C_hydrogen(h,t)          dual var phi assoziated with Equation: MP_C_Stor

mu_PG_PV(ren,t)
aux_phi_PV(ren,t)
mu_PG_wind(ren,t)
aux_phi_wind(ren,t)

phiPG_Res(res,t)            dual variable of combined wind and solar pv generation assoziated with Equation: MP_PG_RR
aux_phi_Res_WM(res,t)       aux continuous var to linearize

mu_LS(t,n)                  dual load shedding variable
mu_LS_1(t,n)                dual load shedding variable load type 1
mu_LS_2(t,n)                dual load shedding variable load type 2
mu_LS_3(t,n)                dual load shedding variable load type 3

omega_UB(l,t)               dual var phi assoziated with Equation: MP_PF_EX_Cap_UB
omega_LB(l,t)               dual var phi assoziated with Equation: MP_PF_EX_Cap_LB

teta_UB(t,n)                dual var beta assoziated with Equation: Theta_UB
teta_LB(t,n)                dual var beta assoziated with Equation: Theta_LB
 
;

Binary Variables

*********************************************Subproblem*********************************************

z_dem(t,n)                  decision variable to construct polyhedral UC-set and decides weather Demand is at a lower or upper bound
z_PG_Res(rr,WM)             decision variable to construct polyhedral UC-set and decides weather combined pv and wind generation potential is Max or not
z_PG_PV(rr,WM)              decision variable to construct polyhedral UC-set and decides weather PV Generation potential is Max or not
z_PG_Wind(rr,WM)            decision variable to construct polyhedral UC-set and decides weather wind Generation potential is Max or not
;

Equations
*********************************************Master**************************************************
MP_Objective
MP_marketclear

MP_PG_Res
MP_PG_PV
MP_PG_Wind

MP_PG_conv
MP_PG_ROR
MP_PG_Reservoir

MP_PG_Stor
MP_C_Stor
MP_Cap_Stor
MP_Stor_lvl_start
MP_Stor_lvl

MP_PG_battery
MP_C_battery
MP_Cap_battery
MP_battery_lvl_start
MP_battery_lvl

MP_PG_hydrogen
MP_C_hydrogen
MP_Cap_hydrogen
MP_hydrogen_lvl_start
MP_hydrogen_lvl

MP_PF_EX
MP_PF_EX_Cap_UB
MP_PF_EX_Cap_LB

MP_LS_1
MP_LS_2
MP_LS_3

Theta_UB
Theta_LB
Theta_ref
MP_ETA

*********************************************Subproblem*********************************************

SUB_Dual_Objective

SUB_Dual_PG_Res
SUB_Dual_PG_PV
SUB_Dual_PG_Wind

SUB_Dual_PG_conv
SUB_Dual_PG_ror
SUB_Dual_PG_reservoir

SUB_Dual_PG_psp
SUB_Dual_C_psp
SUB_Dual_lvl_psp
SUB_Dual_lvl_psp_start

SUB_Dual_PG_battery
SUB_Dual_C_battery
SUB_Dual_lvl_battery
SUB_Dual_lvl_battery_start

SUB_Dual_PG_hydrogen
SUB_Dual_C_hydrogen
SUB_Dual_lvl_hydrogen
SUB_Dual_lvl_hydrogen_start

SUB_Dual_LS_1
SUB_Dual_LS_2
SUB_Dual_LS_3

SUB_Dual_PF_AC
SUB_Dual_PF_DC
SUB_Lin_Dual
SUB_Lin_Dual_n_ref

SUB_US_LOAD
SUB_US_PG_Res
SUB_UB_Total_Res
SUB_UB_PG_Res

SUB_US_PG_PV
SUB_UB_PV_Total
SUB_UB_PG_PV_RR

SUB_US_PG_Wind
SUB_UB_Wind_Total
SUB_UB_PG_Wind_RR

SUB_lin33
SUB_lin34
SUB_lin35
SUB_lin36

SUB_lin37
SUB_lin38
SUB_lin39
SUB_lin40

SUB_lin41
SUB_lin42
SUB_lin43
SUB_lin44

SUBtest

;
*#####################################################################################Master####################################################################################

MP_Objective(vv)..                                                                              O_M  =e=
                                                                                                        sum((ren), (Cap_ren_ex(ren) + Cap_ren_M(ren) ) * IC_ren(ren))
                                                                                                        + sum((g),(Cap_conv_ex(g)) * FOM_conv(g) * df)
                                                                                                        + sum((s), Cap_hydro(s) * FOM_hydro(s))
*                                                                                                        
                                                                                                        + sum((b), ((Cap_battery_M(b) * 6)  * IC_bs(b) )
                                                                                                        +           (Cap_battery_M(b) * IC_bi(b) ))
                                                                                                                    
                                                                                                        + sum((h), ((Cap_hydrogen_M(h) * 168) * IC_hs(h))
                                                                                                        +           (Cap_hydrogen_M(h) * IC_hel(h))
                                                                                                        +           (Cap_OCGT_M(h) * IC_hOCGT(h) ))
                                                                                                        
                                                                                                        + sum(l, L_Cap_exp(l) * IC_Line(l))
                                                                                                        + ETA

;


*********************************************************************************Balancing constraint************************************************************************************

MP_marketclear(t,n,vv)$(ord(vv) lt (itaux+1))..
                                                                                                Demand_data_fixed(t,n,vv) - PLS_M_1(t,n,vv) - PLS_M_2(t,n,vv)  - PLS_M_3(t,n,vv)
                                                                                              
                                                                                                =e= sum((g)$MapG(g,n), PG_M_conv(g,t,vv))
                                                                                               
%Res_off%                                                                                       + sum((res)$Map_Res(res,n), PG_M_Res(res,t,vv))
                                                                                                
%Single_PV_Wind%                                                                                + sum((ren)$Map_PV(ren,n), PG_M_PV(ren,t,vv))
%Single_PV_Wind%                                                                                + sum((ren)$Map_Wind(ren,n), PG_M_Wind(ren,t,vv))

                                                                                                + sum((ror)$MapS(ror,n),  PG_M_Hydro(ror,t,vv))
                                                                                                + sum((reservoir)$MapS(reservoir,n),  PG_M_Hydro(reservoir,t,vv))
                                                                                                + sum((psp)$MapS(psp,n), PG_M_Hydro(psp,t,vv)
                                                                                                -                        M_charge(psp,t,vv))
                                                                                                
%bat%                                                                                           + sum((b)$Map_battery(b,n), PG_M_battery(b,t,vv)
%bat%                                                                                           -                       M_battery_charge(b,t,vv))

%hydrogen%                                                                                      + sum((h)$Map_hydrogen(h,n), PG_M_hydrogen(h,t,vv)
%hydrogen%                                                                                      -                       M_hydrogen_charge(h,t,vv))
                                                                                                
                                                                                                +  sum(l$(Map_Res_l(l,n) and ex_l(l)), PF_M(l,t,vv))
                                                                                                -  sum(l$(Map_Send_l(l,n) and ex_l(l)), PF_M(l,t,vv))

;
*********************************************************************************Volatil Generation**************************************************************************************

MP_PG_Res(res,t,vv)$(ord(vv) lt (itaux+1))..                                                    PG_M_Res(res,t,vv)       =l= Res_Cap_fixed(res,t,vv) 
;
MP_PG_PV(ren,rr,t,vv)$(MAP_RR_Ren(rr,ren) and solar_pv(ren) and (ord(vv) lt (itaux+1)))..       PG_M_PV(ren,t,vv)        =l= (Cap_ren_ex(ren)+ Cap_ren_M(ren)) * AF_M_PV_fixed(ren,rr,t,vv)
;
MP_PG_Wind(ren,rr,t,vv)$(MAP_RR_Ren(rr,ren) and wind(ren) and (ord(vv) lt (itaux+1)))..         PG_M_Wind(ren,t,vv)      =l= (Cap_ren_ex(ren)+ Cap_ren_M(ren)) * AF_M_Wind_fixed(ren,rr,t,vv)
;

*********************************************************************************Dispatchable Generation*********************************************************************************

MP_PG_conv(g,t,vv)$(ord(vv) lt (itaux+1))..                                                     PG_M_conv(g,t,vv)        =l= Cap_conv_ex(g)+ Cap_conv_M(g)
;
MP_PG_ROR(ror,t,vv)$(ord(vv) lt (itaux+1))..                                                    PG_M_Hydro(ror,t,vv)     =l= Cap_hydro(ror)  * af_hydro(t,ror)
;
MP_PG_Reservoir(reservoir,t,vv)$(ord(vv) lt (itaux+1))..                                        PG_M_Hydro(reservoir,t,vv) =l= Cap_hydro(reservoir) * af_hydro(t,reservoir)
;

*********************************************************************************Hydro Storage Generation********************************************************************************

MP_PG_Stor(psp,t,vv)$(ord(vv) lt (itaux+1))..                                                   PG_M_Hydro(psp,t,vv)        =l= Cap_hydro(psp) 
;
MP_C_Stor(psp,t,vv)$(ord(vv) lt (itaux+1))..                                                    M_charge(psp,t,vv)          =l= Cap_hydro(psp) 
;
MP_Cap_Stor(psp,t,vv)$(ord(vv) lt (itaux+1))..                                                  M_Stor_lvl(psp,t,vv)        =l= (Cap_hydro(psp) * psp_cpf) / scale
;

MP_Stor_lvl_start(psp,t,vv)$(ord(vv) lt (itaux+1)and ord(t) = 1)..                              M_Stor_lvl(psp,t,vv)        =e= ((Cap_hydro(psp) * psp_cpf)/ scale)/2 + M_charge(psp,t,vv) * 0.75  -  PG_M_Hydro(psp,t,vv) 
;
MP_Stor_lvl(psp,t,vv)$(ord(vv) lt (itaux+1) and ord(t) gt 1)..                                  M_Stor_lvl(psp,t,vv)        =e= M_Stor_lvl(psp,t-1,vv) + M_charge(psp,t,vv)* 0.75  -  PG_M_Hydro(psp,t,vv) 
;

*********************************************************************************Battery********************************************************************************

MP_PG_Battery(b,t,vv)$(ord(vv) lt (itaux+1))..                                                   PG_M_Battery(b,t,vv)        =l= Cap_battery_M(b) 
;
MP_C_Battery(b,t,vv)$(ord(vv) lt (itaux+1))..                                                    M_Battery_charge(b,t,vv)    =l= Cap_battery_M(b) 
;
MP_Cap_Battery(b,t,vv)$(ord(vv) lt (itaux+1))..                                                  M_Battery_lvl(b,t,vv)        =l= (Cap_battery_M(b) *6) / scale 
;

MP_Battery_lvl_start(b,vv)$(ord(vv) lt (itaux+1))..                                              M_Battery_lvl(b,'t1',vv)       =e= 0 + M_Battery_charge(b,'t1',vv) * 0.96 - PG_M_Battery(b,'t1',vv) 
;
MP_Battery_lvl(b,t,vv)$(ord(vv) lt (itaux+1) and ord(t) gt 1)..                                  M_Battery_lvl(b,t,vv)        =e= M_Battery_lvl(b,t-1,vv) + M_Battery_charge(b,t,vv) * 0.96  -  PG_M_Battery(b,t,vv) 
;

*********************************************************************************hydrogen********************************************************************************

MP_PG_hydrogen(h,t,vv)$(ord(vv) lt (itaux+1))..                                                   PG_M_hydrogen(h,t,vv)        =l= Cap_OCGT_M(h) 
;
MP_C_hydrogen(h,t,vv)$(ord(vv) lt (itaux+1))..                                                    M_hydrogen_charge(h,t,vv)    =l= Cap_hydrogen_M(h) 
;
MP_Cap_hydrogen(h,t,vv)$(ord(vv) lt (itaux+1))..                                                  M_hydrogen_lvl(h,t,vv)        =l= (Cap_hydrogen_M(h) * 168)/ scale
;

MP_hydrogen_lvl_start(h,vv)$(ord(vv) lt (itaux+1))..                                              M_hydrogen_lvl(h,'t1',vv)        =e= 0 +   M_hydrogen_charge(h,'t1',vv) * 0.6  - PG_M_hydrogen(h,'t1',vv) * 1.7
;
MP_hydrogen_lvl(h,t,vv)$(ord(vv) lt (itaux+1) and ord(t) gt 1)..                                  M_hydrogen_lvl(h,t,vv)        =e= M_hydrogen_lvl(h,t-1,vv) +  M_hydrogen_charge(h,t,vv) *0.6   -  PG_M_hydrogen(h,t,vv)* 1.7 
;

*********************************************************************************DC Power flow lines***********************************************************************************

MP_PF_EX(l,t,vv)$(ex_l(l) and AC_l(l) and (ord(vv) lt (itaux+1)))..                             PF_M(l,t,vv) =e= B_sus(l) * (sum(n$Map_Send_l(l,n),  Theta(t,n,vv)) - sum(n$Map_Res_l(l,n),  Theta(t,n,vv))) * MVAbase
;
MP_PF_EX_Cap_UB(l,t,vv)$(ex_l(l) and (ord(vv) lt (itaux+1)))..                                  PF_M(l,t,vv) =l= L_cap(l) + L_Cap_exp(l)
;
MP_PF_EX_Cap_LB(l,t,vv)$(ex_l(l) and (ord(vv) lt (itaux+1)))..                                  PF_M(l,t,vv) =g= - (L_cap(l) + L_Cap_exp(l))
;



Theta_UB(t,n,vv)..                                                                              3.1415          =g= Theta(t,n,vv)
;
Theta_LB(t,n,vv)..                                                                              - 3.1415         =l= Theta(t,n,vv)
;
Theta_ref(t,n,vv)..                                                                             Theta(t,n,vv)$ref(n)      =e= 0
;


*********************************************************************************Load shedding*******************************************************************************************

MP_LS_1(t,n,vv)$(ord(vv) lt (itaux+1))..                                                          PLS_M_1(t,n,vv)  =l= Demand_data_fixed(t,n,vv) * 0.05
;
MP_LS_2(t,n,vv)$(ord(vv) lt (itaux+1))..                                                          PLS_M_2(t,n,vv)  =l= Demand_data_fixed(t,n,vv) * 0.15
;
MP_LS_3(t,n,vv)$(ord(vv) lt (itaux+1))..                                                          PLS_M_3(t,n,vv)  =l= Demand_data_fixed(t,n,vv) * 0.8
;

*********************************************************************************Iterative Objective function****************************************************************************


MP_ETA(vv)$(ord(vv) lt (itaux+1))..                                                             ETA =g=   sum((g,t), var_costs(g) * PG_M_conv(g,t,vv))                                                                                                 
                                                                                                
                                                                                                + sum((t,n),  PLS_M_1(t,n,vv) * LS_costs_1 + PLS_M_2(t,n,vv) * LS_costs_2 + PLS_M_3(t,n,vv) * LS_costs_3)


;
*#####################################################################################Subproblem####################################################################################

SUB_Dual_Objective..                                                O_Sub =e= sum((t,n), lam(t,n) * load(t,n)) 

                                                                    + sum((g,t), - mu_PG_conv(g,t) * Cap_conv_S(g))
                                                                    
%Single_PV_Wind%                                                    + sum((ren,t)$(solar_pv(ren)),
%Single_PV_Wind%                                                    - mu_PG_PV(ren,t) * (Cap_ren_S(ren) * af_PV(ren,t))                                                                   
%Single_PV_Wind%                                                    + aux_phi_PV(ren,t)  * (Cap_ren_S(ren) * delta_af_PV(ren,t)))
                                                                    
%Single_PV_Wind%                                                    + sum((ren,t)$(wind(ren)),
%Single_PV_Wind%                                                    - mu_PG_wind(ren,t) * (Cap_ren_S(ren) * af_Wind(ren,t))
%Single_PV_Wind%                                                    + aux_phi_wind(ren,t)  * (Cap_ren_S(ren) * delta_af_wind(ren,t)))

%Res_off%                                                           + sum((res,t),
%Res_off%                                                           - phiPG_Res(res,t) * Res_cap_sub(res,t)
%Res_off%                                                           + aux_phi_Res_WM(res,t)  * Delta_Res_cap_sub(res,t))


                                                                    + sum((ror,t), - mu_PG_ror(ror,t) * (Cap_Hydro(ror)  * af_hydro(t,ror)))
                                                                    + sum((reservoir,t), - mu_PG_reservoir(reservoir,t) * (Cap_Hydro(reservoir) * af_hydro(t,reservoir)))
                                                                    
                                                                    
                                                                    - sum((psp,t), mu_PG_psp(psp,t) * (Cap_hydro(psp))
                                                                    + mu_C_psp(psp,t) * Cap_hydro(psp)
                                                                    + mu_cap_psp(psp,t) * ((Cap_hydro(psp) * psp_cpf)/ scale))
                                                                    + sum((psp,t)$(ord(t) =1),  phi_SL_psp(psp,t) * (((Cap_hydro(psp) * psp_cpf)/scale)/2))
                                                                    
%bat%                                                               + sum((b,t)$ex_b(b), - mu_PG_battery(b,t) * (Cap_inverter_S(b))
%bat%                                                               - mu_C_battery(b,t) * (Cap_inverter_S(b) )
%bat%                                                               - mu_cap_battery(b,t) * Cap_battery_S(b))


%hydrogen%                                                          + sum((h,t)$ex_h(h), - mu_PG_hydrogen(h,t) * (Cap_Gen_S(h))
%hydrogen%                                                          - mu_C_hydrogen(h,t) * (Cap_electrolysis_S(h))
%hydrogen%                                                          - mu_cap_hydrogen(h,t) * Cap_hydrogen_S(h))

                                                                    
                                                              
                                                                    + sum((t,n), - mu_LS_1(t,n) * (load(t,n)*0.05))
                                                                    + sum((t,n), - mu_LS_2(t,n) * (load(t,n)*0.15))
                                                                    + sum((t,n), - mu_LS_3(t,n) * (load(t,n) * 0.80))
                                                                    
                                                                    + sum((l,t)$ex_l(l), - omega_UB(l,t) *  Cap_line_S(l))
                                                                    + sum((l,t)$ex_l(l), - omega_LB(l,t) *  Cap_line_S(l))

;
*****************************************************************Dual Power generation equation*****************************************************************

SUB_Dual_PG_Res(res,t,n)$Map_Res(res,n)..                             lam(t,n) - phiPG_Res(res,t)                         =l=   0
;
SUB_Dual_PG_PV(ren,t,n)$Map_PV(ren,n)..                               lam(t,n) - mu_PG_PV(ren,t)                          =l=   0
; 
SUB_Dual_PG_wind(ren,t,n)$Map_Wind(ren,n)..                           lam(t,n) - mu_PG_wind(ren,t)                        =l=   0
;

SUB_Dual_PG_conv(g,t,n)$MapG(g,n)..                                   lam(t,n) -  mu_PG_conv(g,t)                         =l=   var_costs(g)
;
SUB_Dual_PG_ror(ror,t,n)$MapS(ror,n)..                                lam(t,n) -  mu_PG_ror(ror,t)                        =l=   0 
; 
SUB_Dual_PG_reservoir(reservoir,t,n)$MapS(reservoir,n)..              lam(t,n) -  mu_PG_reservoir(reservoir,t)            =l=   0  
;

**************************************************************************Dual Hydro PSP*****************************************************************

SUB_Dual_PG_psp(psp,t,n)$MapS(psp,n)..                                lam(t,n)  - phi_SL_psp(psp,t) - mu_PG_psp(psp,t)            =l=   0
;
SUB_Dual_C_psp(psp,t,n)$MapS(psp,n)..                                 - lam(t,n) +  phi_SL_psp(psp,t)  *0.75 - mu_C_psp(psp,t)          =l=   0
;

SUB_Dual_lvl_psp(psp,t)$(ord(t) gt 1)..                               phi_SL_psp(psp,t) -  phi_SL_psp(psp,t-1) - mu_cap_psp(psp,t) + mu_cap_psp_l(psp,t)    =e=   0
;

SUB_Dual_lvl_psp_start(psp,t)$(ord(t) = 1)..                          phi_SL_psp(psp,t)  - mu_cap_psp(psp,t) + mu_cap_psp_l(psp,t)                          =e=   0
*
;

*********************************************************************Dual Battery equation*****************************************************************

SUB_Dual_PG_battery(b,t,n)$(Map_battery(b,n) and ex_b(b))..           lam(t,n) - phi_SL_battery(b,t) - mu_PG_battery(b,t)            =l=   0
;
SUB_Dual_C_battery(b,t,n)$(Map_battery(b,n) and ex_b(b))..            - lam(t,n) +  phi_SL_battery(b,t) *0.96 - mu_C_battery(b,t)          =l=   0
;

SUB_Dual_lvl_battery(b,t)$(ord(t) le card(t) and ex_b(b))..           - phi_SL_battery(b,t) +  phi_SL_battery(b,t+1)  + mu_cap_battery_l(b,t) - mu_cap_battery(b,t)    =e=   0
;

SUB_Dual_lvl_battery_start(b,t)$(ord(t) = card(t) and ex_b(b))..      - phi_SL_battery(b,t)  + mu_cap_battery_l(b,t)  - mu_cap_battery(b,t)                         =e=   0
*
;

*********************************************************************Dual Hydrogen equation*****************************************************************

SUB_Dual_PG_hydrogen(h,t,n)$(Map_hydrogen(h,n)and ex_h(h))..          lam(t,n)  - phi_SL_hydrogen(h,t)* 1.7 - mu_PG_hydrogen(h,t)            =l=   0
;
SUB_Dual_C_hydrogen(h,t,n)$(Map_hydrogen(h,n) and ex_h(h))..          - lam(t,n) +  phi_SL_hydrogen(h,t) *0.6 - mu_C_hydrogen(h,t)          =l=   0
;

SUB_Dual_lvl_hydrogen(h,t)$(ord(t) le card(t) and ex_h(h))..          - phi_SL_hydrogen(h,t) +  phi_SL_hydrogen(h,t+1) + mu_cap_hydrogen_l(h,t) - mu_cap_hydrogen(h,t)     =e=   0
;

SUB_Dual_lvl_hydrogen_start(h,t)$(ord(t) = card(t) and ex_h(h))..    - phi_SL_hydrogen(h,t)  + mu_cap_hydrogen_l(h,t) -  mu_cap_hydrogen(h,t)                         =e=   0
;


*****************************************************************Dual Load shedding equation*********************************************************************

SUB_Dual_LS_1(t,n)..                                                     lam(t,n) -  mu_LS_1(t,n)  =l=   LS_costs_1
;
SUB_Dual_LS_2(t,n)..                                                     lam(t,n) -  mu_LS_2(t,n)  =l=   LS_costs_2
;
SUB_Dual_LS_3(t,n)..                                                     lam(t,n) -  mu_LS_3(t,n)  =l=   LS_costs_3
;
*****************************************************************Dual Power flow equations***********************************************************************

SUB_Dual_PF_AC(l,t)$(ex_l(l) and AC_l(l))..                         - sum(n$(Map_Send_l(l,n)), lam(t,n)) + sum(n$(Map_Res_l(l,n)), lam(t,n))
                                                                    - omega_UB(l,t)  + omega_LB(l,t) + (phi(l,t)/MVAbase)
                                                                                                                      =e= 0
;
SUB_Dual_PF_DC(l,t)$(ex_l(l) and DC_l(l))..                         - sum(n$(Map_Send_l(l,n)), lam(t,n)) + sum(n$(Map_Res_l(l,n)), lam(t,n))
                                                                    - omega_UB(l,t)  + omega_LB(l,t) 
                                                                                                                      =e= 0
;
SUB_LIN_Dual(t,n)..                                                 - sum(l$(Map_Send_l(l,n) and ex_l(l) and AC_l(l)  and not ref(n) ),  B_sus(l) * phi(l,t))
                                                                    + sum(l$(Map_Res_l(l,n) and ex_l(l)  and AC_l(l)  and not ref(n) ),   B_sus(l) * phi(l,t))
                                                                                                      =e= 0
;
SUB_Lin_Dual_n_ref(t,n)..                                           - sum(l$(Map_Send_l(l,n) and ex_l(l) and AC_l(l)  and ref(n)), B_sus(l)  * phi(l,t))
                                                                    + sum(l$(Map_Res_l(l,n) and ex_l(l) and AC_l(l)   and ref(n)),  B_sus(l)  * phi(l,t))

                                                                    +  teta_ref(t,n)                                  =e= 0

;

*****************************************************************Uncertainty Sets/ and polyhedral uncertainty budgets (level 2 problem)***************************

SUB_US_LOAD(t,n)..                                                  Pdem(t,n)  =e= load(t,n) 
;


SUB_US_PG_Res(res,rr,t,WM)$(MAP_WM(t,WM) and Map_RR_res(rr,res))..         AF_Res(res,t) =e=  Res_cap_sub(res,t)
                                                                                             - z_PG_Res(rr,WM) * Delta_Res_cap_sub(res,t) 
;
SUB_UB_Total_Res..                                                   Gamma_Res_total - sum((WM,rr),  z_PG_Res(rr,WM)) =g= 0
;
SUB_UB_PG_Res(rr)..                                                  sum(WM, z_PG_Res(rr,WM))  =l= Gamma_PG_res(rr)
;

SUB_US_PG_PV(ren,rr,t,WM)$(MAP_WM(t,WM) and solar_pv(ren) and Map_RR_ren(rr,ren))..   AF_PV_sub(ren,rr,t)  =e=  af_PV(ren,t)
                                                                                                     - z_PG_PV(rr,WM) * delta_af_PV(ren,t)
;
SUB_UB_PV_Total..                                                   Gamma_PV_total - sum((WM,rr),  z_PG_PV(rr,WM)) =g= 0
;
SUB_UB_PG_PV_RR(rr)..                                               sum(WM, z_PG_PV(rr,WM))  =l= Gamma_PG_PV(rr)         
;

SUB_US_PG_Wind(ren,rr,t,WM)$(MAP_WM(t,WM) and wind(ren) and Map_RR_ren(rr,ren))..         AF_Wind_sub(ren,rr,t)  =e= af_Wind(ren,t)
                                                                                                            - z_PG_wind(rr,WM) * delta_af_wind(ren,t)
;
SUB_UB_wind_Total..                                                 Gamma_wind_total - sum((WM,rr),  z_PG_wind(rr,WM)) =g= 0
;
SUB_UB_PG_wind_RR(rr)..                                             sum(WM, z_PG_wind(rr,WM))  =l= Gamma_PG_wind(rr)         
;


*****************************************************************linearization*********************************************************************************

*******for combined PV and wind

SUB_lin33(res,rr,t,WM)$(MAP_WM(t,WM) and Map_RR_res(rr,res))..         aux_phi_Res_WM(res,t)                              =l= M *  z_PG_Res(rr,WM) 
;
SUB_lin34(res,rr,t,WM)$(MAP_WM(t,WM) and Map_RR_res(rr,res))..         phiPG_Res(res,t) -  aux_phi_Res_WM(res,t)          =l= M *  (1 - z_PG_Res(rr,WM) )
;
SUB_lin35(res,rr,t,WM)$(MAP_WM(t,WM) and Map_RR_res(rr,res))..         - M * z_PG_Res(rr,WM)                              =l= aux_phi_Res_WM(res,t) 
;   
SUB_lin36(res,rr,t,WM)$(MAP_WM(t,WM) and Map_RR_res(rr,res))..         - M * (1 - z_PG_Res(rr,WM) )                       =l= phiPG_Res(res,t) -  aux_phi_Res_WM(res,t) 
;

*******for PV

SUB_lin37(ren,rr,t,WM)$(MAP_WM(t,WM) and solar_pv(ren) and Map_RR_ren(rr,ren))..         aux_phi_PV(ren,t)                                  =l= M *  z_PG_PV(rr,WM) 
;
SUB_lin38(ren,rr,t,WM)$(MAP_WM(t,WM) and solar_pv(ren) and Map_RR_ren(rr,ren))..         mu_PG_PV(ren,t) -  aux_phi_PV(ren,t)               =l= M *  (1 - z_PG_PV(rr,WM) )
;
SUB_lin39(ren,rr,t,WM)$(MAP_WM(t,WM) and solar_pv(ren) and Map_RR_ren(rr,ren))..         - M * z_PG_PV(rr,WM)                               =l= aux_phi_PV(ren,t) 
;   
SUB_lin40(ren,rr,t,WM)$(MAP_WM(t,WM) and solar_pv(ren) and Map_RR_ren(rr,ren))..         - M * (1 - z_PG_PV(rr,WM) )                        =l= mu_PG_PV(ren,t) -  aux_phi_PV(ren,t) 
;

**********for Wind

SUB_lin41(ren,rr,t,WM)$(MAP_WM(t,WM) and wind(ren) and Map_RR_ren(rr,ren))..         aux_phi_wind(ren,t)                                =l= M *  z_PG_wind(rr,WM)
;
SUB_lin42(ren,rr,t,WM)$(MAP_WM(t,WM) and wind(ren) and Map_RR_ren(rr,ren))..         mu_PG_wind(ren,t) -  aux_phi_wind(ren,t)           =l= M *  (1 - z_PG_wind(rr,WM))
;
SUB_lin43(ren,rr,t,WM)$(MAP_WM(t,WM) and wind(ren) and Map_RR_ren(rr,ren))..         - M * z_PG_wind(rr,WM)                             =l= aux_phi_wind(ren,t)
;   
SUB_lin44(ren,rr,t,WM)$(MAP_WM(t,WM) and wind(ren) and Map_RR_ren(rr,ren))..         - M * (1 - z_PG_wind(rr,WM) )                      =l= mu_PG_wind(ren,t) -  aux_phi_wind(ren,t)
;

*execute_unload "check_EQ.gdx";
*$stop
********************************************Model definition**********************************************
model Master_VO
/
MP_Objective
/
;
Master_VO.scaleopt = 1
;
model Master
/
MP_Objective
MP_marketclear

%Res_off%MP_PG_Res
%Single_PV_Wind%MP_PG_PV
%Single_PV_Wind%MP_PG_Wind

MP_PG_conv
MP_PG_ROR
MP_PG_Reservoir

MP_PG_Stor
MP_C_Stor
MP_Cap_Stor
MP_Stor_lvl_start
MP_Stor_lvl

%bat%MP_PG_battery
%bat%MP_C_battery
%bat%MP_Cap_battery
%bat%MP_battery_lvl_start
%bat%MP_battery_lvl

%hydrogen%MP_PG_hydrogen
%hydrogen%MP_C_hydrogen
%hydrogen%MP_Cap_hydrogen
%hydrogen%MP_hydrogen_lvl_start
%hydrogen%MP_hydrogen_lvl

MP_PF_EX
MP_PF_EX_Cap_UB
MP_PF_EX_Cap_LB


MP_LS_1
MP_LS_2
MP_LS_3

Theta_ref
MP_ETA
/
;
Master.scaleopt = 1
;
*solve Master using MIP minimizing O_M;
*execute_unload "check_Master.gdx";
*$stop

model Subproblem
/
SUB_Dual_Objective

%Res_off%SUB_Dual_PG_Res
%Single_PV_Wind%SUB_Dual_PG_PV
%Single_PV_Wind%SUB_Dual_PG_Wind

SUB_Dual_PG_conv
SUB_Dual_PG_ror
SUB_Dual_PG_reservoir

SUB_Dual_PG_psp
SUB_Dual_C_psp
SUB_Dual_lvl_psp
SUB_Dual_lvl_psp_start

%bat%SUB_Dual_PG_battery
%bat%SUB_Dual_C_battery
%bat%SUB_Dual_lvl_battery
%bat%SUB_Dual_lvl_battery_start

%hydrogen%SUB_Dual_PG_hydrogen
%hydrogen%SUB_Dual_C_hydrogen
%hydrogen%SUB_Dual_lvl_hydrogen
%hydrogen%SUB_Dual_lvl_hydrogen_start

SUB_Dual_PF_AC
SUB_Dual_PF_DC
SUB_Lin_Dual
SUB_Lin_Dual_n_ref

SUB_Dual_LS_1
SUB_Dual_LS_2
SUB_Dual_LS_3


%Res_off%SUB_US_PG_Res
%Res_off%SUB_UB_Total_Res
%Res_off%SUB_UB_PG_Res

%Single_PV_Wind%SUB_US_PG_PV
%Single_PV_Wind%SUB_UB_PV_Total
%Single_PV_Wind%SUB_UB_PG_PV_RR

%Single_PV_Wind%SUB_US_PG_Wind
%Single_PV_Wind%SUB_UB_Wind_Total
%Single_PV_Wind%SUB_UB_PG_Wind_RR

%Res_off%SUB_lin33
%Res_off%SUB_lin34
%Res_off%SUB_lin36

%Single_PV_Wind%SUB_lin37
%Single_PV_Wind%SUB_lin38
%Single_PV_Wind%SUB_lin39
%Single_PV_Wind%SUB_lin40

%Single_PV_Wind%SUB_lin41
%Single_PV_Wind%SUB_lin42
%Single_PV_Wind%SUB_lin43
%Single_PV_Wind%SUB_lin44



/
;
option threads =  -1
;
option optcr = 0
;




Gamma_Load = 0
;
Gamma_PG_PV(rr) = 1
;
Gamma_PV_total = 4
;

Gamma_PG_Wind(rr) = 1
;
Gamma_Wind_total = 4
;

Gamma_Res_total = 0
;
Gamma_PG_res(rr) = 0
;
*inv_iter_hist(l,v)  = 0;
LB                  = -1e12
;
UB                  =  1e12
;

*Fixing capacity

Cap_conv_M.fx(g)  = 0
;
*Cap_ren_ex(ren) = 0
*;
*Cap_ren_M.fx(ren) = 0
*;
*Cap_battery_M.fx(b)=0
*;


Loop(v$((UB - LB) gt Toleranz),

Demand_data_fixed(t,n,v) = load(t,n)
;
AF_M_PV_fixed(ren,rr,t,v)  = af_PV(ren,t)
;
AF_M_Wind_fixed(ren,rr,t,v)  = af_Wind(ren,t)
;

if( ord(v) = 1,

Option LP = CPLEX
;
*#######################################################Step 2
Cap_ren_M.fx(ren) = 0
;
L_Cap_exp.fx(l)  = 0
;
Cap_conv_M.fx(g)  = 0
;

    solve Master_VO using MIP minimizing O_M
    ;

else

itaux = ord(v)-1
;
Cap_ren_ex(ren) = 0
;
Cap_ren_M.up(ren) = 300
;
Cap_battery_M.up(b) = 500
;
Cap_hydrogen_M.up(h) = 200
;
L_Cap_exp.up(l)  = L_cap(l) 
;

Option LP = Gurobi
;

Master.optfile = 1
;
$onecho > Gurobi.opt
method=2
BarConvTol =  0
Crossover = 0
$offEcho


option BRatio = 1;



    solve Master using LP minimizing O_M
    ;
  );
*######################################################Step 3

LB =  O_M.l
;
inv_cost_master(v) =
                      sum(ren, (Cap_ren_M.l(ren)+ Cap_ren_ex(ren)) * IC_ren(ren)* df)

                    + sum((g),(Cap_conv_ex(g)) * FOM_conv(g) * df)
                    + sum((s), Cap_hydro(s) * FOM_hydro(s))
                    + sum((b), ((Cap_battery_M.l(b) * 6))  * (IC_bs(b))* df)
                    + sum((b), Cap_battery_M.l(b) * IC_bi(b) * df)
                    + sum((h),  ((Cap_hydrogen_M.l(h)* 168))* (IC_hs(h)) * df)
                    + sum((h), Cap_hydrogen_M.l(h) * IC_hel(h) * df)
                    + sum((h), Cap_OCGT_M.l(h) * IC_hOCGT(h) * df)
                    + sum(l, L_Cap_exp.l(l) * IC_Line(l))
;


            report_decomp(v,'itaux','')         = itaux;
            report_decomp(v,'Gamma_Load','')    = Gamma_Load                                                    + EPS;
            report_decomp(v,'GAMMA_PG_conv','') = GAMMA_PG_conv                                                 + EPS;
            report_decomp(v,'GAMMA_PG_PV','')   = Gamma_PV_total                                                + EPS;
            report_decomp(v,'GAMMA_PG_wind','') = Gamma_Wind_total                                              + EPS;
            report_decomp(v,'investment cost','')     = inv_cost_master(v)                                      + EPS;
            report_decomp(v,'M_obj','')         = O_M.L                                                         + EPS;
            report_decomp(v,'ETA','')           = ETA.l                                                         + EPS;
            report_decomp(v,'LB','')            = LB;
            report_decomp(v,'M_Shed_1','')        = SUM((t,n), PLS_M_1.l(t,n,v))                                 + EPS;
            report_decomp(v,'M_Shed_2','')        = SUM((t,n), PLS_M_2.l(t,n,v))                                 + EPS;
            report_decomp(v,'M_GC','')          = SUM((g,t), var_costs(g) * PG_M_conv.l(g,t,v))                     + EPS;
            report_decomp(v,'M_LS_1','')          = SUM((t,n), LS_costs_1 * PLS_M_1.l(t,n,v))                    + EPS;
            report_decomp(v,'M_LS_2','')          = SUM((t,n), LS_costs_2 * PLS_M_2.l(t,n,v))                    + EPS;
            report_decomp(v,'M_Hydro_costs','')       = SUM((t,s),PG_M_Hydro.l(s,t,v)* FOM_hydro(s))           + EPS;

            report_cap_conv(n,g,v,'Nuclear')         = Cap_conv_M.l(g)$Map_Nuclear(g,n) + Cap_conv_ex(g)$Map_Nuclear(g,n);
            report_cap_ren(n,ren,v,'On_Wind')        = Cap_ren_M.l(ren)$Map_Onwind(ren,n);
            report_cap_ren(n,ren,v,'Off_Wind')       = Cap_ren_M.l(ren)$Map_Offwind(ren,n);
            report_cap_ren(n,ren,v,'PV')             = Cap_ren_M.l(ren)$Map_PV(ren,n);
            report_cap_battery(n,b,v,'Battery')      =(Cap_battery_M.l(b) * (6))$Map_Battery(b,n);
            report_cap_battery(n,b,v,'Inverter')     = Cap_battery_M.l(b)$Map_Battery(b,n);
            report_Cap_hydrogen(n,h,v,'Hydrogen storage')   = (Cap_hydrogen_M.l(h) * (168))$Map_hydrogen(h,n);
            report_Cap_hydrogen(n,h,v,'Electrosysis')       = Cap_hydrogen_M.l(h)$Map_hydrogen(h,n);
            report_Cap_hydrogen(n,h,v,'OCGT')          = Cap_OCGT_M.l(h)$Map_hydrogen(h,n);
            
           


;
*######################################################Step 4

$include ex_storage.gms
$include ex_hydrogen.gms

Cap_conv_S(g) = Cap_conv_ex(g) + Cap_conv_M.l(g)
;
Cap_ren_S(ren)=  Cap_ren_ex(ren) + Cap_ren_M.l(ren)
;
Cap_battery_S(b)$ex_b(b) = (Cap_battery_M.l(b) *6) / scale
;
Cap_inverter_S(b)$ex_b(b) = Cap_battery_M.l(b)
;
Cap_Hydrogen_S(h) = (Cap_hydrogen_M.l(h) *168) / scale
;
Cap_Gen_S(h) = Cap_OCGT_M.l(h)
;
Cap_electrolysis_S(h) = Cap_hydrogen_M.l(h)
;
Cap_line_S(l) =  L_cap(l) + L_Cap_exp.l(l)
;
Res_cap_sub(res,t) = Res_Cap_M(t,res)
;
*######################################################Step 5

option MIP = Gurobi
;

z_PG_PV.fx(rr,'WM1') = 0
;
z_PG_wind.fx(rr,'WM1') = 0
;


Subproblem.optfile = 2
;
$onecho > Gurobi.op2
ScaleFlag = 1
barhomogeneous = 1
NumericFocus =1
Presolve=2
BarConvTol =  0.0
$offEcho

solve Subproblem using MIP maximizing O_Sub
;
*######################################################Step 6

UB = min(UB,
            (
            sum(ren, (Cap_ren_M.l(ren) + Cap_ren_ex(ren)) * IC_ren(ren)* df)
            + sum((g),(Cap_conv_ex(g)) * FOM_conv(g) * df)
            + sum((s), Cap_hydro(s) * FOM_hydro(s))
            + sum((b), ((Cap_battery_M.l(b) * 6))  * (IC_bs(b))* df)
            + sum((b), Cap_battery_M.l(b) * IC_bi(b) * df)
            + sum((h), ((Cap_hydrogen_M.l(h)* 168))* (IC_hs(h)) * df)
            + sum((h), Cap_hydrogen_M.l(h) * IC_hel(h) * df)
            + sum((h), Cap_OCGT_M.l(h)* IC_hOCGT(h) * df)
             + sum(l, L_Cap_exp.l(l) * IC_Line(l))
            + O_Sub.l))
;
            report_decomp(v,'network','')       = card(ex_l);
            report_decomp(v,'Sub_obj','')       = O_Sub.L                                                       + EPS;
            report_decomp(v,'UB','')            = UB;
            report_decomp(v,'UB-LB','')         = UB - LB                                                       + EPS;
            report_decomp(v,'Sub_Shed_1','')      = SUM((t,n), - mu_LS_1.m(t,n))    + EPS;
            report_decomp(v,'Sub_Shed_2','')      = SUM((t,n), - mu_LS_2.m(t,n))    + EPS;
            report_decomp(v,'Sub_Gen','')       = SUM((g,t), - mu_PG_conv.m(g,t))                                 + EPS;
            report_decomp(v,'Sub_Hydro','')     = SUM((reservoir,t), - (mu_PG_reservoir.m(reservoir,t))) + EPS; 


*######################################################Step 7
Demand_data_fixed(t,n,v) = load(t,n)
;
%Single_PV_Wind% AF_M_PV_fixed(ren,rr,t,v) = AF_PV_sub.l(ren,rr,t)
%Single_PV_Wind% ;
%Single_PV_Wind% AF_M_Wind_fixed(ren,rr,t,v) = AF_Wind_sub.l(ren,rr,t)
%Single_PV_Wind% ;
%Res_off%Res_Cap_fixed(res,t,v) = AF_Res.l(res,t)
%Res_off%;

report_track_z(rr,WM,v,'PV')= z_PG_PV.l(rr,WM)
;
report_track_z(rr,WM,v,'Wind')= z_PG_wind.l(rr,WM)
;
*
execute_unload "check.gdx";
;
)

***************************************************output**************************************************
Parameter
Report_dunkel_time_Z(rr)
Report_dunkel_PV_Z(rr,WM)
Report_dunkel_Wind_Z(rr,WM)
Report_lines_built(l) 
Report_total_cost
Report_LS_node(t,n,vv)
Report_LS_per_hour(t,vv)
Report_LS_total(vv)
Report_LS_costs_total(vv)
Report_PG(*,*,t,vv)
Report_line_exp(l)
Report_PP_constr_cost(v)
Report_Invcost_conv(g,*)
Report_Invcost_ren(ren,*)
Report_Invcost_battery(b,*)
Report_Invcost_hydrogen(h,*)
Report_Invcost(*)
Report_Invcost_line
Inv_total_conv(g,*)
Inv_total_ren(ren,*)
report_cap_final(n,*,*)
Report_Balance_Flow_regions(rr,v)
Report_Expansion_regions(*,*)
Report_average_nodal_price(n,v)
Report_gen_Region(*,*,*)
Report_total_Gen_cap(*)
Report_FOM(*)

;
Report_dunkel_PV_Z(rr,WM) =  z_PG_PV.l(rr,WM)
;
Report_dunkel_Wind_Z(rr,WM) = z_PG_wind.l(rr,WM)
;
Report_total_cost = O_M.l
;
Report_PP_constr_cost(v) = inv_cost_master(v)
;
Report_LS_node(t,n,vv) = PLS_M_1.l(t,n,vv) + PLS_M_2.l(t,n,vv) +PLS_M_3.l(t,n,vv)
;
Report_LS_per_hour(t,vv) = sum(n,Report_LS_node(t,n,vv))
;
Report_LS_total(vv) = sum(t,Report_LS_per_hour(t,vv))
;
Report_LS_costs_total(vv) = sum((t,n), PLS_M_1.l(t,n,vv) * LS_costs_1  + PLS_M_2.l(t,n,vv) * LS_costs_2 + PLS_M_3.l(t,n,vv) * LS_costs_3)
;
Report_average_nodal_price(n,vv) = (sum(t, MP_marketclear.m(t,n,vv))/card(t)) * (-1)
;
report_cap_final(n,g,'Nuclear') = Cap_conv_ex(g)$Map_Nuclear(g,n) +  Cap_conv_M.l(g)$Map_Nuclear(g,n)
;
report_cap_final(n,g,'Biomass') = Cap_conv_ex(g)$Map_Biomass(g,n)
;
report_cap_final(n,ren,'On_Wind') =Cap_ren_M.l(ren)$Map_Onwind(ren,n) 
;
report_cap_final(n,ren,'Off_Wind') = Cap_ren_M.l(ren)$Map_Offwind(ren,n) 
;
report_cap_final(n,ren,'PV') = Cap_ren_M.l(ren)$Map_PV(ren,n) 
;
report_cap_final(n,b,'battery storage') = (Cap_battery_M.l(b) * 6)$Map_Battery(b,n)
;
report_cap_final(n,b,'battery inverter') = (Cap_battery_M.l(b))$Map_Battery(b,n)
;
report_cap_final(n,h,'OCGT') = (Cap_OCGT_M.l(h))$Map_hydrogen(h,n)
;
report_cap_final(n,h,'hydrogen storage') = (Cap_hydrogen_M.l(h) * 168)$Map_hydrogen(h,n)
;
report_cap_final(n,h,'Electrolysis') = (Cap_hydrogen_M.l(h))$Map_hydrogen(h,n)
;

Report_total_Gen_cap('Nuclear') =  sum(g$nuc(g),Cap_conv_ex(g))
;
Report_total_Gen_cap('Biomass') = sum(g$biomass(g),Cap_conv_ex(g))
;
Report_total_Gen_cap('On_Wind') =  sum(ren$wind_on(ren), Cap_ren_M.l(ren))
;
Report_total_Gen_cap('Off_Wind') = sum(ren$wind_off(ren), Cap_ren_M.l(ren))
;
Report_total_Gen_cap('PV') =    sum(ren$solar_pv(ren), Cap_ren_M.l(ren))
;
Report_total_Gen_cap('battery storage') = sum(b,Cap_battery_M.l(b) * 6 )
;
Report_total_Gen_cap('battery inverter') = sum(b, Cap_battery_M.l(b))
;
Report_total_Gen_cap('hydrogen storage') = sum(h,Cap_hydrogen_M.l(h) * 168 )
;
Report_total_Gen_cap('Electrolysis') = sum(h,Cap_hydrogen_M.l(h) )
;
Report_total_Gen_cap('OCGT') = sum(h,Cap_OCGT_M.l(h) )
;
Report_total_Gen_cap('ROR') =  sum(ror,Cap_hydro(ror))
;
Report_total_Gen_cap('PSP') = sum(psp, Cap_hydro(psp))
;
Report_total_Gen_cap('Reservoir') =  sum(reservoir, Cap_hydro(reservoir))
;

Report_FOM('Nuclear') = sum(g$nuc(g),Cap_conv_ex(g) * FOM_conv(g))
;
Report_FOM('Biomass') = sum(g$Biomass(g),Cap_conv_ex(g) * FOM_conv(g))
;
Report_FOM('On_Wind') = sum(ren$wind_on(ren), Cap_ren_M.l(ren) * FOM_ren(ren))
;
Report_FOM('Off_Wind') = sum(ren$wind_off(ren), Cap_ren_M.l(ren) * FOM_ren(ren))
;
Report_FOM('PV') = sum(ren$solar_pv(ren), Cap_ren_M.l(ren) * FOM_ren(ren))
;
Report_FOM('battery storage') =  sum(b,Cap_battery_M.l(b) * 6 * FOM_bs(b) )
;
Report_FOM('battery inverter') = sum(b,Cap_battery_M.l(b) * FOM_bi(b) )
;
Report_FOM('hydrogen storage') =sum(h,Cap_hydrogen_M.l(h) * 168 * FOM_Hst(h) )
;
Report_FOM('Electrolysis') = sum(h,Cap_hydrogen_M.l(h) * FOM_Hel(h) )
;
Report_FOM('OCGT') = sum(h,Cap_OCGT_M.l(h) * FOM_OCGT(h))
;
Report_FOM('ROR') = sum(ror,Cap_hydro(ror) * FOM_hydro(ror) )
;
Report_FOM('PSP') = sum(psp, Cap_hydro(psp) * FOM_hydro(psp) )
;
Report_FOM('Reservoir') = sum(reservoir, Cap_hydro(reservoir) * FOM_hydro(reservoir))
;




Report_line_exp(l) = L_Cap_exp.l(l)
;
Report_Invcost_ren(ren,'On_Wind') = sum(n, report_cap_final(n,ren,'On_Wind')) * IC_ren(ren)$wind_on(ren)
;
Report_Invcost_ren(ren,'Off_Wind') = sum(n, report_cap_final(n,ren,'Off_Wind')) * IC_ren(ren)$wind_off(ren)
;
Report_Invcost_ren(ren,'PV') = sum(n, report_cap_final(n,ren,'PV')) * IC_ren(ren)$solar_pv(ren)
;
Report_Invcost_battery(b,'battery storage') = sum(n, report_cap_final(n,b,'battery storage')) * IC_bs(b)
;
Report_Invcost_battery(b,'battery inverter') = sum(n, report_cap_final(n,b,'battery inverter')) * IC_bi(b)
;
Report_Invcost_hydrogen(h,'OCGT') = sum(n,report_cap_final(n,h,'OCGT')) * IC_hOCGT(h)
;
Report_Invcost_hydrogen(h,'hydrogen storage') = sum(n,report_cap_final(n,h,'hydrogen storage')) * IC_hs(h)
;
Report_Invcost_hydrogen(h,'Electrolysis') = sum(n,report_cap_final(n,h,'Electrolysis')) * IC_hel(h)
;
Report_Invcost_line = sum(l, Report_line_exp(l) * IC_Line(l))  
;
Report_Invcost('On_Wind') = sum(ren, Report_Invcost_ren(ren,'On_Wind')) * 1000000
;
Report_Invcost('Off_Wind') = sum(ren, Report_Invcost_ren(ren,'Off_Wind')) * 1000000
;
Report_Invcost('PV') = sum(ren, Report_Invcost_ren(ren,'PV')) * 1000000
;
Report_Invcost('battery storage') = sum(b, Report_Invcost_battery(b,'battery storage')) * 1000000
;
Report_Invcost('battery inverter') =  sum(b, Report_Invcost_battery(b,'battery inverter')) * 1000000
;
Report_Invcost('OCGT') = sum(h, Report_Invcost_hydrogen(h,'OCGT')) * 1000000
;
Report_Invcost('hydrogen storage') = sum(h, Report_Invcost_hydrogen(h,'hydrogen storage')) * 1000000
;
Report_Invcost('Electrolysis') = sum(h, Report_Invcost_hydrogen(h,'Electrolysis')) * 1000000
;
Report_Invcost('Nuclear') = sum((g), Cap_conv_M.l(g) * IC_conv(g)) * 1000000
;
Report_Invcost('line') = sum(l, Report_line_exp(l) * IC_Line(l)) * 1000000
;
Report_Balance_Flow_regions(rr,v) = sum((t,l)$((ord(t) gt 1176 and ord(t) le 1218) and Map_rr_res_l(l,rr)), PF_M.l(l,t,v))
                                - sum((t,l)$((ord(t) gt 1176 and ord(t) le 1218) and Map_rr_send_l(l,rr)), PF_M.l(l,t,v))
;
Report_Expansion_regions('Region 1','Region 6') = sum(l$pros_l_rr1_rr6(l) , L_Cap_exp.l(l))
;
Report_Expansion_regions('Region 2','Region 3') = sum(l$pros_l_rr2_rr3(l) , L_Cap_exp.l(l))
;
Report_Expansion_regions('Region 2','Region 6') = sum(l$pros_l_rr2_rr6(l) , L_Cap_exp.l(l))
;
Report_Expansion_regions('Region 3','Region 4') = sum(l$pros_l_rr3_rr4(l)  , L_Cap_exp.l(l))
;
Report_Expansion_regions('Region 3','Region 5') = sum(l$pros_l_rr3_rr5(l)  , L_Cap_exp.l(l))
;
Report_Expansion_regions('Region 3','Region 6') = sum(l$pros_l_rr3_rr6(l)  , L_Cap_exp.l(l))
;
Report_Expansion_regions('Region 5','Region 6') = sum(l$pros_l_rr5_rr6(l)  , L_Cap_exp.l(l))
;

report_objective(v) = O_M.l
;

Saldo_PSP(t,v) = sum(psp, PG_M_Hydro.l(psp,t,v)) - sum(psp, M_charge.l(psp,t,v))
;
Saldo_PSP_region(t,rr,v) = sum(psp$MAP_RR_PsP(rr,psp), PG_M_Hydro.l(psp,t,v)) - sum(psp$MAP_RR_PsP(rr,psp), M_charge.l(psp,t,v))
;
Gen_PSP(t,v) = Saldo_PSP(t,v)$(Saldo_PSP(t,v) gt 0)
;
Gen_PSP_region(t,rr,v) = Saldo_PSP_region(t,rr,v)$(Saldo_PSP_region(t,rr,v) gt 0)
;


Saldo_battery(t,v) = sum((b), PG_M_battery.l(b,t,v)) - sum(b, M_Battery_charge.l(b,t,v))
;
Saldo_battery_region(t,rr,v) = sum((b)$MAP_RR_B(rr,b), PG_M_battery.l(b,t,v)) - sum(b$MAP_RR_B(rr,b), M_Battery_charge.l(b,t,v))
;
Gen_battery(t,v) = Saldo_battery(t,v)$(Saldo_battery(t,v) gt 0)
;
Gen_battery_region(t,rr,v) = Saldo_battery_region(t,rr,v)$(Saldo_battery_region(t,rr,v) gt 0)
;


Saldo_Hydrogen(t,v) = sum(h,  PG_M_hydrogen.l(h,t,v)) - sum(h, M_hydrogen_charge.l(h,t,v) )
;
Saldo_Hydrogen_region(t,rr,v) = sum(h$MAP_RR_OCGT(rr,h),  PG_M_hydrogen.l(h,t,v)) - sum(h$MAP_RR_OCGT(rr,h), M_hydrogen_charge.l(h,t,v))
;
Gen_Hydrogen(t,v) = Saldo_Hydrogen(t,v)$(Saldo_Hydrogen(t,v) gt 0)
;
Gen_Hydrogen_region(t,rr,v)= Saldo_Hydrogen_region(t,rr,v)$(Saldo_Hydrogen_region(t,rr,v) gt 0)
;

Report_total_Gen('TWh',v) =  sum((g,t), PG_M_conv.l(g,t,v))
                  + sum((ren,t), PG_M_PV.l(ren,t,v))
                  + sum((ren,t), PG_M_Wind.l(ren,t,v))
                  + sum((ror,t),   PG_M_Hydro.l(ror,t,v))
                  + sum((reservoir,t),   PG_M_Hydro.l(reservoir,t,v))
                  + sum(t,       Gen_PSP(t,v))
                  + sum(t,       Gen_battery(t,v))
                  + sum(t,       Gen_Hydrogen(t,v))
                  + sum((n,t),   PLS_M_1.l(t,n,v))
                  + sum((n,t),   PLS_M_2.l(t,n,v))
                  + sum((n,t),   PLS_M_3.l(t,n,v))
                 
;
Report_gen_tech('Nuclear',t,v) = sum((g)$nuc(g), PG_M_conv.l(g,t,v)) +0.001
;
Report_gen_tech('Biomass',t,v) = sum((g)$biomass(g), PG_M_conv.l(g,t,v))+0.001
;
Report_gen_tech('On_Wind',t,v) = sum((ren)$wind_on(ren), PG_M_Wind.l(ren,t,v))+0.001
;
Report_gen_tech('Off_Wind',t,v) =  sum((ren)$wind_off(ren), PG_M_Wind.l(ren,t,v))+0.001
;
Report_gen_tech('PV',t,v)      = sum((ren)$solar_pv(ren), PG_M_PV.l(ren,t,v))+0.001
;
Report_gen_tech('OCGT',t,v)    = sum((h), PG_M_hydrogen.l(h,t,v))+0.001
;
Report_gen_tech('Battery',t,v) = sum((b), PG_M_battery.l(b,t,v))+0.001
;
Report_gen_tech('ROR',t,v)     = sum((ror), PG_M_Hydro.l(ror,t,v))+0.001
;
Report_gen_tech('Reservoir',t,v) = sum((reservoir), PG_M_Hydro.l(reservoir,t,v))+0.001
;
Report_gen_tech('PSP',t,v)     = sum((psp), PG_M_Hydro.l(psp,t,v))+0.001
;


Report_Gen_share('Nuclear',v) = sum((g,t)$nuc(g), PG_M_conv.l(g,t,v))/ Report_total_Gen('TWh',v)
;
Report_Gen_share('Biomass',v) = sum((g,t)$biomass(g), PG_M_conv.l(g,t,v))/ Report_total_Gen('TWh',v)
;
Report_Gen_share('On_Wind',v) = sum((ren,t)$wind_on(ren), PG_M_Wind.l(ren,t,v))/ Report_total_Gen('TWh',v)
;
Report_Gen_share('Off_Wind',v) = sum((ren,t)$wind_off(ren), PG_M_Wind.l(ren,t,v))/ Report_total_Gen('TWh',v)
;
Report_Gen_share('PV',v) = sum((ren,t)$solar_pv(ren), PG_M_PV.l(ren,t,v))/ Report_total_Gen('TWh',v)
;
Report_Gen_share('OCGT',v) = sum(t, Gen_Hydrogen(t,v))/ Report_total_Gen('TWh',v)
;
Report_Gen_share('Battery',v) = sum(t, Gen_battery(t,v))/ Report_total_Gen('TWh',v)
;
Report_Gen_share('ROR',v) = sum((ror,t), PG_M_Hydro.l(ror,t,v))/ Report_total_Gen('TWh',v)
;
Report_Gen_share('Reservoir',v) = sum((reservoir,t), PG_M_Hydro.l(reservoir,t,v))/ Report_total_Gen('TWh',v)
;
Report_Gen_share('PSP',v) = sum( t, Gen_PSP(t,v))/ Report_total_Gen('TWh',v)
;
Report_Gen_share('LS1',v) = sum((n,t), PLS_M_1.l(t,n,v))/ Report_total_Gen('TWh',v)
;
Report_Gen_share('LS2',v) = sum((n,t), PLS_M_2.l(t,n,v))/ Report_total_Gen('TWh',v)
;
Report_Gen_share('LS3',v) = sum((n,t), PLS_M_3.l(t,n,v))/ Report_total_Gen('TWh',v)
;


Report_gen_Region('Nuclear',rr,v) = sum((g,t)$(nuc(g) and MAP_RR_G(rr,g)) , PG_M_conv.l(g,t,v))
;
Report_Gen_Region('Biomass',rr,v) = sum((g,t)$(biomass(g)and MAP_RR_G(rr,g)), PG_M_conv.l(g,t,v))
;
Report_Gen_Region('On_Wind',rr,v) = sum((ren,t)$(wind_on(ren) and Map_RR_ren(rr,ren)), PG_M_Wind.l(ren,t,v))
;
Report_Gen_Region('Off_Wind',rr,v) = sum((ren,t)$(wind_off(ren) and Map_RR_ren(rr,ren)), PG_M_Wind.l(ren,t,v))
;
Report_Gen_Region('PV',rr,v) = sum((ren,t)$(solar_pv(ren) and Map_RR_ren(rr,ren)), PG_M_PV.l(ren,t,v))
;
Report_Gen_Region('OCGT',rr,v) = sum(t, Gen_Hydrogen_region(t,rr,v))
;
Report_Gen_Region('Battery',rr,v) =  sum(t,Gen_battery_region(t,rr,v))
;
Report_Gen_Region('ROR',rr,v) = sum((ror,t)$MAP_RR_RoR(rr,ror), PG_M_Hydro.l(ror,t,v))
;
Report_Gen_Region('Reservoir',rr,v) = sum((reservoir,t)$MAP_RR_reservoir(rr,reservoir), PG_M_Hydro.l(reservoir,t,v))
;
Report_Gen_Region('PSP',rr,v) = sum(t, Gen_PSP_region(t,rr,v))
;
Report_Gen_Region('LS1',rr,v) = sum((n,t)$Map_RR(rr,n), PLS_M_1.l(t,n,v))
;
Report_Gen_Region('LS2',rr,v) = sum((n,t)$Map_RR(rr,n), PLS_M_2.l(t,n,v))
;
Report_Gen_Region('LS3',rr,v) = sum((n,t)$Map_RR(rr,n), PLS_M_3.l(t,n,v))
;
Report_gen_Region('Total Charge Battery',rr,v) = sum((b,t)$MAP_RR_B(rr,b), M_Battery_charge.l(b,t,v))
;
Report_gen_Region('Total Charge OCGT',rr,v) = sum((h,t)$MAP_RR_OCGT(rr,h), M_hydrogen_charge.l(h,t,v))
;
Report_gen_Region('Total Charge PSP',rr,v) = sum((psp,t)$MAP_RR_PsP(rr,psp), M_charge.l(psp,t,v))
;
Report_gen_Region('Total Gen Battery',rr,v) =  sum((b,t)$MAP_RR_B(rr,b), PG_M_battery.l(b,t,v)) 
;
Report_gen_Region('Total Gen OCGT',rr,v) = sum((h,t)$MAP_RR_OCGT(rr,h),  PG_M_hydrogen.l(h,t,v))
;
Report_gen_Region('Total Gen PSP',rr,v) =  sum((psp,t)$MAP_RR_PsP(rr,psp), PG_M_Hydro.l(psp,t,v))  
;


Report_Curtailment('Onshore',v) = sum((ren,t)$wind_on(ren),PG_M_Wind.l(ren,t,v)) / sum((ren,rr,t)$wind_on(ren), Cap_ren_M.l(ren) * AF_M_Wind_fixed(ren,rr,t,v))
;
Report_Curtailment('Offshore',v) = sum((ren,t)$wind_off(ren),PG_M_Wind.l(ren,t,v)) / sum((ren,rr,t)$wind_off(ren), Cap_ren_M.l(ren) * AF_M_Wind_fixed(ren,rr,t,v))
;
Report_Curtailment('Solar PV',v) = sum((ren,t)$solar_pv(ren),PG_M_PV.l(ren,t,v)) / sum((ren,rr,t)$solar_pv(ren), Cap_ren_M.l(ren) * AF_M_PV_fixed(ren,rr,t,v))
;
Report_Curtailment('Total',v) = sum((ren,t),PG_M_Wind.l(ren,t,v) + PG_M_PV.l(ren,t,v)) / (sum((ren,rr,t)$wind_on(ren), Cap_ren_M.l(ren) * AF_M_Wind_fixed(ren,rr,t,v))
                                                                                         + sum((ren,rr,t)$wind_off(ren), Cap_ren_M.l(ren) * AF_M_Wind_fixed(ren,rr,t,v))
                                                                                         + sum((ren,rr,t)$solar_pv(ren), Cap_ren_M.l(ren) * AF_M_PV_fixed(ren,rr,t,v)))
;

execute_unload "Results.gdx"
Report_dunkel_PV_Z, Report_dunkel_Wind_Z, Report_PP_constr_cost, Report_total_cost,
Report_LS_node, Report_LS_per_hour, Report_LS_total,Report_LS_costs_total,report_cap_final,Report_total_Gen_cap, Report_line_exp,
Report_Invcost_conv,Report_Invcost_ren,Report_Invcost_battery,Report_Invcost_hydrogen,
Report_Invcost, Report_Invcost_line, Report_total_Gen, Report_Gen_tech, Report_Gen_share, Report_Curtailment,
Report_Balance_Flow_regions, Report_Expansion_regions, Report_average_nodal_price, report_track_z, Report_Gen_Region,Report_FOM
;

$stop
