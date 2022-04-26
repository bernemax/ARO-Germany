
option profile = 1;
option profiletol = 0.01;


$setGlobal Single_Wind_and_PV         "*"          if "*" no individual Wind and PV generation is considered, if "" Wind and PV are considered individually
$setGlobal Summed_Wind_PV             ""          if "*" no cummulative Wind and PV generation is considered, if "" combined Wind and PV is considered

Sets

n /n1*n510/
d /BM1*BM480,CP1*CP494,NMM1*NMM495,FT1*FT495,TL31*TL443,PPP1*PPP495,
WP1*WP495,TE8*TE493,MC1*MC495,C1*C495,OI1*OI495,X1*X510,Service1*Service495,
House1*House495/

l /l1*l1100/
g /g1*g565/
s /s1*s178/
*sun and wind set
Res/res1*res1021/
*set, that represents the sum of sun and wind
Ren/ren1*ren481/

t/t1*t24/
v /v1*v5/
sr/sr1*sr12/
wr/wr1*wr12/
rr/rr1*rr12/
*CSR/CSR1*CSR12/
*CWR/CWR1*CWR12/

Sun_shine(t) /t8*t16/
*t32*t40, t56*t64, t80*t88, t104*t114/

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
ex_l(l)/l1*l842/
pros_l(l)/l1000*l1100/
*pros_l(l)/l841*l1680/

Border_exist_DE(l)
Border_exist_total(l)

Border_prosp_DE(l)
Border_prosp_total(l)


****************************nodes***************************************************
ref(n)
/n1/
DE_nodes(n)
/n1*n495/
NoDeSciGrid(n)
/n65,n97,n182,n203,n222,
n237,n263,n273,n274,n317,
n321,n325,n328,n355,n357,
n358,n359,n361,n362,n404,
n405,n416,n417,n430,n432/

border_states(n)
/n500*n510/

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
NW(n) /n510/


Relevant_Nodes(n)
/n1*n495,n500*n510/


*****************************mapping************************************************
Map_grid(l,n)
Map_send_L(l,n)
Map_res_L(l,n)
MapD(d,n)
MapG(g,n)
MapS(s,n)

MapRes(res,n)
MapRen(ren,n)
MapSr(sr,n)
MapWr(wr,n)
MapRR(rr,n)


Map_SR_sun(sr,res,n)
Map_WR_Wind(wr,res,n)
Map_RR(rr,ren,n)

SR_sun(sr,res)
WR_wind(wr,res)
RR_ren(rr,ren)

MapBM(d,n)
MapCP(d,n)
MapNMM(d,n)
MapFT(d,n)
MapTL(d,n)
MapPPP(d,n)
MapWP(d,n)
MapTE(d,n)
MapMC(d,n)
MapC(d,n)
MapOI(d,n)
MapX(d,n)
MapService(d,n)
MapHouse(d,n)



;
alias (n,nn),(t,tt),(l,ll), (v,vv)
;
Scalar
Gamma_test /10/
;
$include Loading_Data.gms
;

*execute_unload "check_input.gdx";
*$stop
*######################################variables######################################

Variables
*********************************************Master*************************************************
O_M                         Objective var of Master Problem (total costs)
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
PG_M_Ren(ren,t,v)           cummulative power generation level of renewable solar pv and wind generators

PLS_M_BM(n,t,v)             load shedding Basic Metals sector
PLS_M_CP(n,t,v)             load shedding Chemical and Petrochemical sector
PLS_M_NMM(n,t,v)            load shedding Non-Metallic Minerals sector
PLS_M_FT(n,t,v)             load shedding Food and Tobacco sector
PLS_M_TL(n,t,v)             load shedding Textile and Leather sector
PLS_M_PPP(n,t,v)            load shedding Paper Pulp and Print sector
PLS_M_WP(n,t,v)             load shedding Wood and Wood Products sector
PLS_M_TE(n,t,v)             load shedding Transport Equipment sector
PLS_M_MC(n,t,v)             load shedding Machinery sector
PLS_M_C(n,t,v)              load shedding Construction sector
PLS_M_OI(n,t,v)             load shedding other industry
PLS_M_X(n,t,v)              load shedding missing assignment -> standart industrial sector
PLS_M_ServHous(n,t,v)
PLS_M_States(n,t,v)

End_of_Enlightenment(rr,t)
Start_dunkel_10(rr,t)
Start_dunkel_20(rr,t)
Start_dunkel_30(rr,t)

*********************************************Subproblem*********************************************

Pdem_De(n,t)                realization of Household and service sector demand (unsheaddable) (Ro)
Pdem_States(n,t)            realization of neighbore countries demand (unsheaddable) (Ro)
PE_conv(g,t)                realization of conventional supply (Ro)
AF_PV(t,sr,n)               realization of PV availability (Ro)
AF_wind(t,wr,n)             realization of Wind availability (Ro)
AF_Ren(t,rr,n)              realization of combined wind and pv

phiPG_conv(g,t)             dual var phi assoziated with Equation: MP_PG_conv
phiPG_Hydro(s,t)            dual Var phi assoziated with Equation: MP_PG_Hydro
phiPG_PV(res,t)             dual var phi assoziated with Equation: MP_PG_Sun
phiPG_Wind(res,t)           dual var phi assoziated with Equation: MP_PG_wind
phiPG_Ren(ren,t)            dual variable of combined wind and solar pv generation assoziated with Equation: MP_PG_RR

phiLS_BM(n,t)               dual var phi assoziated with Equation: MP_LS_BM
phiLS_CP(n,t)               dual var phi assoziated with Equation: MP_LS_CP
phiLS_NMM(n,t)              dual var phi assoziated with Equation: MP_LS_NMM
phiLS_FT(n,t)               dual var phi assoziated with Equation: MP_LS_FT
phiLS_TL(n,t)               dual var phi assoziated with Equation: MP_LS_TL
phiLS_PPP(n,t)              dual var phi assoziated with Equation: MP_LS_PPP
phiLS_WP(n,t)               dual var phi assoziated with Equation: MP_LS_WP
phiLS_TE(n,t)               dual var phi assoziated with Equation: MP_LS_TE
phiLS_MC(n,t)               dual var phi assoziated with Equation: MP_LS_MC
phiLS_C(n,t)                dual var phi assoziated with Equation: MP_LS_C
phiLS_OI(n,t)               dual var phi assoziated with Equation: MP_LS_OI
phiLS_X(n,t)                dual var phi assoziated with Equation: MP_LS_X
phiLS_ServHous(n,t)
phiLS_states(n,t)

omega_UB(l,t)               dual var phi assoziated with Equation: MP_PF_EX_Cap_UB
omega_LB(l,t)               dual var phi assoziated with Equation: MP_PF_EX_Cap_LB

teta_UB(n,t)                dual var beta assoziated with Equation: Theta_UB
teta_LB(n,t)                dual var beta assoziated with Equation: Theta_LB

aux_lam_DE(n,t)             aux continuous var to linearize lam(n.t) * Pdem(n.t) in SUB Objective (Pdem can become variable when uncertainty is considered)
aux_lam_states(n,t)         aux continuous var to linearize lam(n.t) * Pdem(n.t) in SUB Objective (Pdem can become variable when uncertainty is considered)
aux_phi_PG(g,t)             aux continuous var to linearize phiPG(g.t) * PE(g.t) in SUB Objective (PE can become variable when uncertainty is considered)
aux_phi_PG_PV(res,t)        aux continuous var to linearize phiPG_PV(sun.t) * AF_PV(sun.t)  in SUB Objective (PE can become variable when uncertainty is considered)
aux_phi_PG_wind(res,t)      aux continuous var to linearize phiPG_wind(wind.t) * AF_wind(wind.t) in SUB Objective (PE can become variable when uncertainty is considered)
aux_phi_LS_DE(n,t)          aux continuous var to linearize phiLS(n.t) * Pdem(n.t) in SUB Objective
aux_phi_LS_states(n,t)

aux_phi_PG_Ren_10(ren,t)
aux_phi_PG_Ren_20(ren,t)
aux_phi_PG_Ren_30(ren,t)
;

Binary Variables
*********************************************Master*************************************************

inv_new_M(l)                decision variable regarding investment in a new prospective line
inv_upg_M(l)                decision variable regarding an possible upgrade of the capacity of an existing line

*********************************************Subproblem*********************************************

z_PG_conv(g,t)              decision variable to construct polyhedral UC-set and decides weather conventional Generation potential is Max or not
z_PG_PV(sr,t)               decision variable to construct polyhedral UC-set and decides weather PV Generation potential is Max or not
z_PG_Wind(wr,t)             decision variable to construct polyhedral UC-set and decides weather wind Generation potential is Max or not
z_dem_De(n,t)               decision variable to construct polyhedral UC-set and decides weather Demand is at a lower or upper bound
z_dem_states(n,t)

z_PG_Ren_10(rr,t)           decision variable to construct polyhedral UC-set and decides weather combined pv and wind generation potential is Max or not
z_PG_Ren_20(rr,t)
z_PG_Ren_30(rr,t)

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
MP_PG_RR


MP_PF_EX
MP_PF_EX_Cap_UB
MP_PF_EX_Cap_LB

MP_PF_PROS_Cap_UB
MP_PF_PROS_Cap_LB
MP_PF_PROS_LIN_UB
MP_PF_PROS_LIN_LB

MP_LS_BM
MP_LS_CP
MP_LS_NMM
MP_LS_FT
MP_LS_TL
MP_LS_PPP
MP_LS_WP
MP_LS_TE
MP_LS_MC
MP_LS_C
MP_LS_OI
MP_LS_X
MP_LS_Service_House
MP_LS_States

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
SUB_Dual_PG_Ren

SUB_Dual_LS_BM
SUB_Dual_LS_CP
SUB_Dual_LS_NMM
SUB_Dual_LS_FT
SUB_Dual_LS_TL
SUB_Dual_LS_PPP
SUB_Dual_LS_WP
SUB_Dual_LS_TE
SUB_Dual_LS_MC
SUB_Dual_LS_C
SUB_Dual_LS_OI
SUB_Dual_LS_X
SUB_Dual_LS_ServiceHouse
SUB_Dual_LS_States

SUB_Dual_PF

SUB_Lin_Dual
SUB_Lin_Dual_n_ref

SUB_US_LOAD_DE
SUB_US_LOAD_States
SUB_UB_LOAD

SUB_US_PG_conv
SUB_UB_PG_conv

SUB_US_PG_sun
SUB_UB_PG_sun
SUB_PV_time_coupling

SUB_US_PG_wind
SUB_UB_PG_wind
SUB_wind_time_coupling

SUB_US_PG_RR
SUB_UB_Total
SUB_UB_PG_RR_10
SUB_UB_PG_RR_20
SUB_UB_PG_RR_30
SUB_RR_time_coupling
SUB_RR_timing_z
*SUB_RR_Enlightenment_end
SUB_RR_Dunkel_start_10
SUB_RR_Dunkel_start_20
SUB_RR_Dunkel_start_30
SUB_RR_Free_Start
SUB_RR_Free_END


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
SUB_lin21
SUB_lin22
SUB_lin23
SUB_lin24
SUB_lin25
SUB_lin26
SUB_lin27
SUB_lin28
SUB_lin29
SUB_lin30
SUB_lin31
SUB_lin32
SUB_lin33
SUB_lin34
SUB_lin35
SUB_lin36
SUB_lin37
SUB_lin38
SUB_lin39
SUB_lin40
;
*#####################################################################################Master####################################################################################


MP_Objective(vv)..                                                                              O_M  =e= sum(l, inv_new_M(l) * I_costs_new(l)) + ETA
;

MP_IB(vv)..                                                                                     IB   =g= sum(l, inv_new_M(l) * I_costs_new(l))
;

MP_marketclear(n,t,vv)$(ord(vv) lt (itaux+1))..                                                 Demand_data_fixed_unshed(n,t,vv) - PLS_M_ServHous(n,t,vv)
                                                                                                + Load_BM(n,t)  - PLS_M_BM(n,t,vv)
                                                                                                + Load_CP(n,t)  - PLS_M_CP(n,t,vv)
                                                                                                + Load_NMM(n,t) - PLS_M_NMM(n,t,vv)
                                                                                                + Load_FT(n,t)  - PLS_M_FT(n,t,vv)
                                                                                                + Load_TL(n,t)  - PLS_M_TL(n,t,vv)
                                                                                                + Load_PPP(n,t) - PLS_M_PPP(n,t,vv)
                                                                                                + Load_WP(n,t)  - PLS_M_WP(n,t,vv)
                                                                                                + Load_TE(n,t)  - PLS_M_TE(n,t,vv)
                                                                                                + Load_MC(n,t)  - PLS_M_MC(n,t,vv)
                                                                                                + Load_C(n,t)   - PLS_M_C(n,t,vv)
                                                                                                + Load_OI(n,t)  - PLS_M_OI(n,t,vv)
                                                                                                + Load_X(n,t)   - PLS_M_X(n,t,vv)
                                                                                                + Demand_data_fixed_states(n,t,vv)- PLS_M_States(n,t,vv)   =e= sum(g$MapG (g,n), PG_M_conv(g,t,vv))

                                                                                                + sum(s$MapS(s,n),  PG_M_Hydro(s,t,vv))

%Single_Wind_and_PV%                                                                            +  sum(sun$MapRes(sun,n), PG_M_PV(sun,t,vv))
%Single_Wind_and_PV%                                                                            +  sum(wind$MapRes(wind,n), PG_M_Wind(wind,t,vv))
%Summed_Wind_PV%                                                                                +  sum(ren$MapRen(ren,n), PG_M_Ren(ren,t,vv))

                                                                                                +  sum(l$(Map_Res_l(l,n) and ex_l(l)), PF_M(l,t,vv))
                                                                                                -  sum(l$(Map_Send_l(l,n) and ex_l(l)), PF_M(l,t,vv))

                                                                                                +  sum(l$(Map_Res_l(l,n) and pros_l(l)), PF_M(l,t,vv))
                                                                                                -  sum(l$(Map_Send_l(l,n) and pros_l(l)), PF_M(l,t,vv))

;


MP_PG_conv(g,t,vv)$(ord(vv) lt (itaux+1))..                                                     PG_M_conv(g,t,vv)       =l= PG_M_fixed_conv(g,t,vv)
;
MP_PG_Hydro(s,t,vv)$(ord(vv) lt (itaux+1))..                                                    PG_M_Hydro(s,t,vv)      =l= Cap_hydro(s)
;
MP_PG_PV(sun,sr,n,t,vv)$(Map_SR_sun(sr,sun,n) and (ord(vv) lt (itaux+1)))..                     PG_M_PV(sun,t,vv)       =l= Cap_res(sun) * AF_M_PV_fixed(t,sr,n,vv)
;
MP_PG_Wind(wind,wr,n,t,vv)$(Map_WR_Wind(wr,wind,n) and (ord(vv) lt (itaux+1)))..                PG_M_Wind(wind,t,vv)    =l= Cap_res(wind) * AF_M_Wind_fixed(t,wr,n,vv)
;
MP_PG_RR(ren,rr,n,t,vv)$(Map_RR(rr,ren,n) and (ord(vv) lt (itaux+1)))..                         PG_M_Ren(ren,t,vv)       =l= Cap_ren(ren) * AF_M_Ren_fixed(t,rr,n,vv)
;

MP_PF_EX(l,t,vv)$(ex_l(l)  and (ord(vv) lt (itaux+1)))..                                        PF_M(l,t,vv) =e= B(l) * (sum(n$Map_Send_l(l,n),  Theta(n,t,vv)) - sum(n$Map_Res_l(l,n),  Theta(n,t,vv)))
;
MP_PF_EX_Cap_UB(l,t,vv)$(ex_l(l) and (ord(vv) lt (itaux+1)))..                                  PF_M(l,t,vv) =l= L_cap(l)
;
MP_PF_EX_Cap_LB(l,t,vv)$(ex_l(l)  and (ord(vv) lt (itaux+1)))..                                 PF_M(l,t,vv) =g= - L_cap(l)
;


MP_PF_PROS_Cap_UB(l,t,vv)$(pros_l(l) and (ord(vv) lt (itaux+1)))..                              PF_M(l,t,vv) =l= L_cap_prosp(l) * inv_new_M(l)
;
MP_PF_PROS_Cap_LB(l,t,vv)$(pros_l(l) and (ord(vv) lt (itaux+1)))..                              PF_M(l,t,vv) =g= - L_cap_prosp(l) * inv_new_M(l)
;
MP_PF_PROS_LIN_UB(l,t,vv)$(pros_l(l) and (ord(vv) lt (itaux+1)))..                              (1-inv_new_M(l)) *M   =g= PF_M(l,t,vv) - B_prosp(l) * (sum(n$Map_Send_l(l,n),  Theta(n,t,vv)) - sum(n$Map_Res_l(l,n),  Theta(n,t,vv)))
;
MP_PF_PROS_LIN_LB(l,t,vv)$(pros_l(l) and (ord(vv) lt (itaux+1)))..                              -(1-inv_new_M(l)) *M  =l= PF_M(l,t,vv) - B_prosp(l) * (sum(n$Map_Send_l(l,n),  Theta(n,t,vv)) - sum(n$Map_Res_l(l,n),  Theta(n,t,vv)))
;


MP_LS_BM(n,t,vv)$( ord(vv) lt (itaux+1))..                                                      PLS_M_BM(n,t,vv) =l= Load_BM(n,t)
;
MP_LS_CP(n,t,vv)$( ord(vv) lt (itaux+1))..                                                      PLS_M_CP(n,t,vv) =l= Load_CP(n,t)
;
MP_LS_NMM(n,t,vv)$( ord(vv) lt (itaux+1))..                                                     PLS_M_NMM(n,t,vv) =l= Load_NMM(n,t)
;
MP_LS_FT(n,t,vv)$( ord(vv) lt (itaux+1))..                                                      PLS_M_FT(n,t,vv) =l= Load_FT(n,t)
;
MP_LS_TL(n,t,vv)$( ord(vv) lt (itaux+1))..                                                      PLS_M_TL(n,t,vv) =l= Load_TL(n,t)
;
MP_LS_PPP(n,t,vv)$( ord(vv) lt (itaux+1))..                                                     PLS_M_PPP(n,t,vv) =l= Load_PPP(n,t)
;
MP_LS_WP(n,t,vv)$( ord(vv) lt (itaux+1))..                                                      PLS_M_WP(n,t,vv) =l= Load_WP(n,t)
;
MP_LS_TE(n,t,vv)$( ord(vv) lt (itaux+1))..                                                      PLS_M_TE(n,t,vv) =l= Load_TE(n,t)
;
MP_LS_MC(n,t,vv)$( ord(vv) lt (itaux+1))..                                                      PLS_M_MC(n,t,vv) =l= Load_MC(n,t)
;
MP_LS_C(n,t,vv)$( ord(vv) lt (itaux+1))..                                                       PLS_M_C(n,t,vv) =l= Load_C(n,t)
;
MP_LS_OI(n,t,vv)$( ord(vv) lt (itaux+1))..                                                      PLS_M_OI(n,t,vv) =l= Load_OI(n,t)
;
MP_LS_X(n,t,vv)$( ord(vv) lt (itaux+1))..                                                       PLS_M_X(n,t,vv) =l= Load_X(n,t)
;
MP_LS_Service_House(n,t,vv)$( ord(vv) lt (itaux+1))..                                           PLS_M_ServHous(n,t,vv) =l= Demand_data_fixed_unshed(n,t,vv) 
;
MP_LS_States(n,t,vv)$( ord(vv) lt (itaux+1))..                                                  PLS_M_States(n,t,vv) =l= Demand_data_fixed_states(n,t,vv)
;


Theta_UB(n,t,vv)$(Relevant_Nodes(n) and (ord(vv) lt (itaux+1)))..                               3.1415          =g= Theta(n,t,vv)
;
Theta_LB(n,t,vv)$(Relevant_Nodes(n) and (ord(vv) lt (itaux+1)))..                               - 3.1415         =l= Theta(n,t,vv)
;
Theta_ref(n,t,vv)$(ord(vv) lt (itaux+1))..                                                      Theta(n,t,vv)$ref(n)      =e= 0
;


MP_ETA(vv)$(ord(vv) lt (itaux+1))..                                                             ETA =g=   sum((g,t), var_costs(g,t) * PG_M_conv(g,t,vv))
                                                                                                + sum((s,t), 20 * PG_M_hydro(s,t,vv))
                                                                                                
                                                                                                + sum((n,t), LS_costs_BM(n) * PLS_M_BM(n,t,vv))
                                                                                                + sum((n,t), LS_costs_CP(n) * PLS_M_CP(n,t,vv))
                                                                                                + sum((n,t), LS_costs_NMM(n) * PLS_M_NMM(n,t,vv))
                                                                                                + sum((n,t), LS_costs_FT(n) * PLS_M_FT(n,t,vv))
                                                                                                + sum((n,t), LS_costs_TL(n) * PLS_M_TL(n,t,vv))
                                                                                                + sum((n,t), LS_costs_PPP(n) * PLS_M_PPP(n,t,vv))
                                                                                                + sum((n,t), LS_costs_WP(n) * PLS_M_WP(n,t,vv))
                                                                                                + sum((n,t), LS_costs_TE(n) * PLS_M_TE(n,t,vv))
                                                                                                + sum((n,t), LS_costs_MC(n) * PLS_M_MC(n,t,vv))
                                                                                                + sum((n,t), LS_costs_C(n) * PLS_M_C(n,t,vv))
                                                                                                + sum((n,t), LS_costs_OI(n) * PLS_M_OI(n,t,vv))
                                                                                                + sum((n,t), LS_costs_X(n) * PLS_M_X(n,t,vv))
                                                                                                
                                                                                                + sum((n,t), 20000 * PLS_M_ServHous(n,t,vv))
                                                                                                + sum((n,t), LS_costs_X(n) * PLS_M_States(n,t,vv))

;
*#####################################################################################Subproblem####################################################################################

SUB_Dual_Objective..                                                O_Sub =e= sum((n,t), lam(n,t)  * (load_Ind(n,t) + Load_unshed(n,t) + Load_states(n,t))
                                                                    + aux_lam_DE(n,t) *    ( + delta_load_DE(n,t))
                                                                    + aux_lam_states(n,t) * ( + delta_load_states(n,t)))


                                                                    + sum((g,t), - phiPG_conv(g,t) * Cap_conv(g)
                                                                    + aux_phi_PG(g,t) * ( +  delta_Cap_conv(g)))

                                                                    + sum((s,t), - phiPG_hydro(s,t) * Cap_Hydro(s))

%Single_Wind_and_PV%                                                + sum((sr,sun,n,t)$Map_SR_sun(sr,sun,n),
%Single_Wind_and_PV%                                                - phiPG_PV(sun,t) * (Cap_res(sun) *  af_PV_up(t,sr,n))
%Single_Wind_and_PV%                                                + aux_phi_PG_PV(sun,t) * ( Cap_res(sun) * delta_af_PV(t,sr,n)))

%Single_Wind_and_PV%                                                + sum((wr,wind,n,t)$Map_WR_Wind(wr,wind,n),
%Single_Wind_and_PV%                                                - phiPG_Wind(wind,t) * (Cap_res(wind) *  af_Wind_up(t,wr,n))
%Single_Wind_and_PV%                                                + aux_phi_PG_wind(wind,t)  * ( Cap_res(wind) * delta_af_wind(t,wr,n)))

%Summed_Wind_PV%                                                    + sum((rr,ren,n,t)$Map_RR(rr,ren,n),
%Summed_Wind_PV%                                                    - phiPG_Ren(ren,t) * ( Cap_ren(ren) * af_ren_up(t,rr,n))
%Summed_Wind_PV%                                                    + aux_phi_PG_Ren_10(ren,t) * ( Cap_ren(ren) * delta_af_ren_10(t,rr,n))
                                                                    + aux_phi_PG_Ren_20(ren,t) * ( Cap_ren(ren) * delta_af_ren_20(t,rr,n))
                                                                    + aux_phi_PG_Ren_30(ren,t) * ( Cap_ren(ren) * delta_af_ren_30(t,rr,n)))

                                                                    + sum((n,t), - phiLS_BM(n,t) * Load_BM(n,t)
                                                                    + (- phiLS_CP(n,t) * Load_CP(n,t))
                                                                    + (- phiLS_NMM(n,t) * Load_NMM(n,t))
                                                                    + (- phiLS_FT(n,t) * Load_FT(n,t))
                                                                    + (- phiLS_TL(n,t) * Load_TL(n,t))
                                                                    + (- phiLS_PPP(n,t) * Load_PPP(n,t))
                                                                    + (- phiLS_WP(n,t) * Load_WP(n,t))
                                                                    + (- phiLS_TE(n,t) * Load_TE(n,t))
                                                                    + (- phiLS_MC(n,t) * Load_MC(n,t))
                                                                    + (- phiLS_C(n,t) * Load_C(n,t))
                                                                    + (- phiLS_OI(n,t) * Load_OI(n,t))
                                                                    + (- phiLS_X(n,t) * Load_X(n,t))
                                                                    
                                                                    + (- phiLS_ServHous(n,t) * Load_unshed(n,t))
                                                                    + (- phiLS_states(n,t) * Load_states(n,t))

                                                                    + aux_phi_LS_DE(n,t) * ( - delta_load_DE(n,t))
                                                                    + aux_phi_LS_states(n,t) * (- delta_load_states(n,t)))


                                                                    + sum((l,t)$ex_l(l), - omega_UB(l,t) *  L_cap(l))
                                                                    + sum((l,t)$ex_l(l), - omega_LB(l,t) *  L_cap(l))

                                                                    + sum((l,t)$ex_l(l), - omega_UB(l,t) *  L_cap_prosp(l))
                                                                    + sum((l,t)$ex_l(l), - omega_LB(l,t) *  L_cap_prosp(l))

                                                                    + sum((n,t), - teta_UB(n,t) * 3.1415)
                                                                    + sum((n,t), - teta_LB(n,t) * 3.1415)
;
*****************************************************************Dual Power generation equation*****************************************************************

SUB_Dual_PG_conv(g,t)..                                             sum((n)$MapG(g,n) , lam(n,t) -  phiPG_conv(g,t))                           =l= var_costs(g,t)
;
SUB_Dual_PG_hydro(s,t)..                                            sum((n)$MapS(s,n) , lam(n,t) -  phiPG_hydro(s,t))                          =l=   20
;
SUB_Dual_PG_sun(sun,t)..                                            sum((n)$(MapRes(sun,n)), lam(n,t) -  phiPG_PV(sun,t))                      =l=   0
;
SUB_Dual_PG_wind(wind,t)..                                          sum((n)$(MapRes(wind,n)), lam(n,t) -  phiPG_Wind(wind,t))                  =l=   0
;
SUB_Dual_PG_Ren(ren,t)..                                            sum((n)$(MapRen(ren,n)), lam(n,t) - phiPG_Ren(ren,t))                      =l=   0
;

*****************************************************************Dual Load shedding equation*********************************************************************

SUB_Dual_LS_BM(n,t)$(DE_nodes(n))..                                  lam(n,t) -  phiLS_BM(n,t)                        =l=  LS_costs_BM(n)
;
SUB_Dual_LS_CP(n,t)$(DE_nodes(n))..                                  lam(n,t) -  phiLS_CP(n,t)                        =l=  LS_costs_CP(n)
;
SUB_Dual_LS_NMM(n,t)$(DE_nodes(n))..                                 lam(n,t) -  phiLS_NMM(n,t)                       =l=  LS_costs_NMM(n)
;
SUB_Dual_LS_FT(n,t)$(DE_nodes(n))..                                  lam(n,t) -  phiLS_FT(n,t)                        =l=  LS_costs_FT(n)
;
SUB_Dual_LS_TL(n,t)$(DE_nodes(n))..                                  lam(n,t) -  phiLS_TL(n,t)                        =l=  LS_costs_TL(n)
;
SUB_Dual_LS_PPP(n,t)$(DE_nodes(n))..                                 lam(n,t) -  phiLS_PPP(n,t)                       =l=  LS_costs_PPP(n)
;
SUB_Dual_LS_WP(n,t)$(DE_nodes(n))..                                  lam(n,t) -  phiLS_WP(n,t)                        =l=  LS_costs_WP(n)
;
SUB_Dual_LS_TE(n,t)$(DE_nodes(n))..                                  lam(n,t) -  phiLS_TE(n,t)                        =l=  LS_costs_TE(n)
;
SUB_Dual_LS_MC(n,t)$(DE_nodes(n))..                                  lam(n,t) -  phiLS_MC(n,t)                        =l=  LS_costs_MC(n)
;
SUB_Dual_LS_C(n,t)$(DE_nodes(n))..                                   lam(n,t) -  phiLS_C(n,t)                         =l=  LS_costs_C(n)
;
SUB_Dual_LS_OI(n,t)$(DE_nodes(n))..                                  lam(n,t) -  phiLS_OI(n,t)                        =l=  LS_costs_OI(n)
;
SUB_Dual_LS_X(n,t)$(DE_nodes(n))..                                   lam(n,t) -  phiLS_X(n,t)                         =l=  LS_costs_X(n)
;
SUB_Dual_LS_ServiceHouse(n,t)$(DE_nodes(n))..                        lam(n,t) -  phiLS_ServHous(n,t)                  =l=  20000
;
SUB_Dual_LS_States(n,t)$(border_states(n))..                         lam(n,t) -  phiLS_states(n,t)                    =l=  LS_costs_X(n)
;

*****************************************************************Dual Power flow equations***********************************************************************

SUB_Dual_PF(l,t)$ex_l(l)..                                          - sum(n$(Map_Send_l(l,n)), lam(n,t)) + sum(n$(Map_Res_l(l,n)), lam(n,t))
                                                                    - omega_UB(l,t)  + omega_LB(l,t) + phi(l,t)
                                                                                                                      =e= 0
;
SUB_LIN_Dual(n,t)..                                                 - sum(l$(Map_Send_l(l,n) and ex_l(l) and not ref(n) ),  B(l) * phi(l,t))
                                                                    - sum(l$(Map_Send_l(l,n) and ex_l(l) and not ref(n) ),  B_prosp(l) * phi(l,t))
                                                                    + sum(l$(Map_Res_l(l,n) and ex_l(l) and not ref(n) ),   B(l) * phi(l,t))
                                                                    + sum(l$(Map_Res_l(l,n) and ex_l(l) and not ref(n) ),   B_prosp(l) * phi(l,t))
                                                                    -  teta_UB(n,t)
                                                                    +  teta_LB(n,t)                                  =e= 0
;
SUB_Lin_Dual_n_ref(n,t)..                                           - sum(l$(Map_Send_l(l,n) and ex_l(l) and ref(n)), B(l)  * phi(l,t))
                                                                    + sum(l$(Map_Res_l(l,n) and ex_l(l) and ref(n)),  B(l)  * phi(l,t))

                                                                    +  teta_ref(n,t)                                  =e= 0

;

*****************************************************************Uncertainty Sets/ and polyhedral uncertainty budgets (level 2 problem)***************************

SUB_US_LOAD_DE(n,t)$(DE_nodes(n))..                                 Pdem_De(n,t)   =e= Load_unshed(n,t) + delta_load_DE(n,t) * z_dem_De(n,t)
;
SUB_US_LOAD_States(n,t)$(border_states(n))..                        Pdem_States(n,t) =e= Load_states(n,t) + delta_load_states(n,t) * z_dem_states(n,t)
;
SUB_UB_LOAD(t)..                                                    sum((n), z_dem_De(n,t) + z_dem_states(n,t))  =l= Gamma_load
;

SUB_US_PG_conv(g,t)..                                               PE_conv(g,t) =e= Cap_conv(g) - delta_Cap_conv(g) * z_PG_conv(g,t)
;
SUB_UB_PG_conv..                                                    sum((g,t), z_PG_conv(g,t))   =l= Gamma_PG_conv
;
*$ontext
SUB_US_PG_sun(sr,sun,n,t)$Map_SR_sun(sr,sun,n)..                    AF_PV(t,sr,n) =e= af_PV_up(t,sr,n) - delta_af_PV(t,sr,n) * z_PG_PV(sr,t)
;
SUB_UB_PG_sun(t)..                                                  sum(sr, z_PG_PV(sr,t))   =l= Gamma_PG_PV
;
SUB_PV_time_coupling(sr,t)$(Sun_shine(t))..                         z_PG_PV(sr,t) =e= z_PG_PV(sr,t+1)
;
*$ontext
SUB_US_PG_wind(wr,wind,n,t)$Map_WR_wind(wr,wind,n)..                AF_wind(t,wr,n) =e= af_Wind_up(t,wr,n) - delta_af_wind(t,wr,n) * z_PG_Wind(wr,t)
;
SUB_UB_PG_wind(t)..                                                 sum(wr, z_PG_Wind(wr,t))   =l= Gamma_PG_Wind
;
SUB_wind_time_coupling(wr,t)$(ord(t) gt 1)..                        z_PG_Wind(wr,t) =e= z_PG_Wind(wr,t-1)
;


SUB_US_PG_RR(rr,ren,n,t)$Map_RR(rr,ren,n)..                          AF_Ren(t,rr,n) =e= af_ren_up(t,rr,n) - delta_af_ren_10(t,rr,n) * z_PG_Ren_10(rr,t) - delta_af_ren_20(t,rr,n) * z_PG_Ren_20(rr,t) - delta_af_ren_30(t,rr,n) * z_PG_Ren_30(rr,t)
;
SUB_UB_Total..                                                       Gamma_Ren_total - sum((rr,t),  z_PG_Ren_10(rr,t) +  z_PG_Ren_20(rr,t) +  z_PG_Ren_30(rr,t)) =g= 0
;
SUB_UB_PG_RR_10(rr)..                                                sum((t),  z_PG_Ren_10(rr,t))  =l= Gamma_PG_ren_10(rr)
;
SUB_UB_PG_RR_20(rr)..                                                sum((t),  z_PG_Ren_20(rr,t))  =l= Gamma_PG_ren_20(rr)
;
SUB_UB_PG_RR_30(rr)..                                                sum((t),  z_PG_Ren_30(rr,t))  =l= Gamma_PG_ren_30(rr)
;
SUB_RR_timing_z(rr,t)..                                              z_PG_Ren_10(rr,t) + z_PG_Ren_20(rr,t) + z_PG_Ren_30(rr,t) =l= 1
;
SUB_RR_time_coupling(rr,t)..                                         sum(tt$(ord(tt) <= ord (t) and ord(tt) >= (ord(t) - dark_time)), Start_dunkel_10(rr,tt) + Start_dunkel_20(rr,t) + Start_dunkel_30(rr,t)) =l=  z_PG_Ren_10(rr,t) + z_PG_Ren_20(rr,t) + z_PG_Ren_30(rr,t)
;
*SUB_RR_Enlightenment_end(rr,t)..                                     End_of_Enlightenment(rr,t) =g= z_PG_Ren_10(rr,t-1) + z_PG_Ren_10(rr,t)
*;
SUB_RR_Dunkel_start_10(rr,t)..                                       Start_dunkel_10(rr,t)   =g=  z_PG_Ren_10(rr,t) - z_PG_Ren_10(rr,t-1)
*+ z_PG_Ren_20(rr,t) - z_PG_Ren_20(rr,t-1) + z_PG_Ren_30(rr,t) - z_PG_Ren_30(rr,t-1)
;
SUB_RR_Dunkel_start_20(rr,t)..                                       Start_dunkel_20(rr,t)   =g=  z_PG_Ren_20(rr,t) - z_PG_Ren_20(rr,t-1)
;
SUB_RR_Dunkel_start_30(rr,t)..                                       Start_dunkel_30(rr,t)   =g=  z_PG_Ren_30(rr,t) - z_PG_Ren_30(rr,t-1)
;
SUB_RR_Free_Start(rr,t)$(ord(t) eq 1)..                              z_PG_Ren_10(rr,t) + z_PG_Ren_20(rr,t) + z_PG_Ren_30(rr,t) =e= 0
;
SUB_RR_Free_END(rr,t)$(ord(t) eq card(t))..                          z_PG_Ren_10(rr,t) + z_PG_Ren_20(rr,t) + z_PG_Ren_30(rr,t) =e= 0
;
*****************************************************************linearization*********************************************************************************


SUB_lin1(n,t)$(DE_nodes(n))..                                       aux_lam_DE(n,t)                                    =l= M * z_dem_De(n,t)
;
SUB_lin2(n,t)$(DE_nodes(n))..                                       lam(n,t)  - aux_lam_DE(n,t)                        =l= M * ( 1 - z_dem_De(n,t))
;
SUB_lin3(n,t)$(DE_nodes(n))..                                       - M * z_dem_De(n,t)                                =l= aux_lam_DE(n,t)
;
SUB_lin4(n,t)$(DE_nodes(n))..                                       - M * ( 1 - z_dem_De(n,t))                         =l= lam(n,t)  - aux_lam_DE(n,t)
;

SUB_lin5(n,t)$(border_states(n))..                                  aux_lam_states(n,t)                                =l= M * z_dem_states(n,t)
;
SUB_lin6(n,t)$(border_states(n))..                                  lam(n,t)  - aux_lam_states(n,t)                    =l= M * ( 1 - z_dem_states(n,t))
;
SUB_lin7(n,t)$(border_states(n))..                                  - M * z_dem_states(n,t)                            =l= aux_lam_states(n,t)
;
SUB_lin8(n,t)$(border_states(n))..                                  - M * ( 1 - z_dem_states(n,t))                     =l= lam(n,t)  - aux_lam_states(n,t)
;

SUB_lin9(g,t)..                                                     aux_phi_PG(g,t)                                 =l= M *   z_PG_conv(g,t)
;
SUB_lin10(g,t)..                                                     phiPG_conv(g,t) - aux_phi_PG(g,t)               =l= M *  ( 1 - z_PG_conv(g,t))
;
SUB_lin11(g,t)..                                                     - M *   z_PG_conv(g,t)                          =l= aux_phi_PG(g,t)
;
SUB_lin12(g,t)..                                                     - M *  ( 1 - z_PG_conv(g,t))                    =l= phiPG_conv(g,t) - aux_phi_PG(g,t)
;
*$ontext
SUB_lin13(sr,sun,t)$SR_sun(sr,sun)..                                aux_phi_PG_PV(sun,t)                             =l= M *   z_PG_PV(sr,t)
;
SUB_lin14(sr,sun,t)$SR_sun(sr,sun)..                                phiPG_PV(sun,t) - aux_phi_PG_PV(sun,t)           =l= M *  ( 1 - z_PG_PV(sr,t))
;
SUB_lin15(sr,sun,t)$SR_sun(sr,sun)..                                - M *   z_PG_PV(sr,t)                            =l= aux_phi_PG_PV(sun,t)
;
SUB_lin16(sr,sun,t)$SR_sun(sr,sun)..                                - M *  ( 1 - z_PG_PV(sr,t))                      =l= phiPG_PV(sun,t) - aux_phi_PG_PV(sun,t)
;
*$ontext
SUB_lin17(wr,wind,t)$WR_wind(wr,wind)..                             aux_phi_PG_wind(wind,t)                           =l= M *   z_PG_Wind(wr,t)
;
SUB_lin18(wr,wind,t)$WR_wind(wr,wind)..                             phiPG_Wind(wind,t) - aux_phi_PG_wind(wind,t)      =l= M *  ( 1 - z_PG_Wind(wr,t))
;
SUB_lin19(wr,wind,t)$WR_wind(wr,wind)..                             - M *   z_PG_Wind(wr,t)                           =l= aux_phi_PG_wind(wind,t)
;
SUB_lin20(wr,wind,t)$WR_wind(wr,wind)..                             - M *  ( 1 - z_PG_Wind(wr,t))                     =l= phiPG_Wind(wind,t) - aux_phi_PG_wind(wind,t)
;
*$offtext

SUB_lin21(n,t)$(DE_nodes(n))..                                    aux_phi_LS_DE(n,t)                               =l= M * z_dem_De(n,t)
;
SUB_lin22(n,t)$(DE_nodes(n))..                                    phiLS_ServHous(n,t) - aux_phi_LS_DE(n,t)               =l= M * ( 1 - z_dem_De(n,t))
;
SUB_lin23(n,t)$(DE_nodes(n))..                                    - M * z_dem_De(n,t)                              =l= aux_phi_LS_DE(n,t)
;
SUB_lin24(n,t)$(DE_nodes(n))..                                    - M * ( 1 - z_dem_De(n,t))                      =l= phiLS_ServHous(n,t) - aux_phi_LS_DE(n,t)
;

SUB_lin25(n,t)$(border_states(n))..                               aux_phi_LS_states(n,t)                           =l= M * z_dem_states(n,t)
;
SUB_lin26(n,t)$(border_states(n))..                               phiLS_states(n,t) - aux_phi_LS_states(n,t)       =l= M * ( 1 - z_dem_states(n,t))
;
SUB_lin27(n,t)$(border_states(n))..                               - M * z_dem_states(n,t)                          =l= aux_phi_LS_states(n,t)
;
SUB_lin28(n,t)$(border_states(n))..                               - M * ( 1 - z_dem_states(n,t))                  =l= phiLS_states(n,t) - aux_phi_LS_states(n,t)
;

SUB_lin29(rr,ren,t)$RR_Ren(rr,ren)..                                aux_phi_PG_Ren_10(ren,t)                             =l= M *  z_PG_Ren_10(rr,t)
;
SUB_lin30(rr,ren,t)$RR_Ren(rr,ren)..                                phiPG_Ren(ren,t) -  aux_phi_PG_Ren_10(ren,t)         =l= M *  (1 - z_PG_Ren_10(rr,t))
;
SUB_lin31(rr,ren,t)$RR_Ren(rr,ren)..                                - M * z_PG_Ren_10(rr,t)                              =l= aux_phi_PG_Ren_10(ren,t)
;
SUB_lin32(rr,ren,t)$RR_Ren(rr,ren)..                                - M * (1 - z_PG_Ren_10(rr,t) )                       =l= phiPG_Ren(ren,t) -  aux_phi_PG_Ren_10(ren,t)
;

SUB_lin33(rr,ren,t)$RR_Ren(rr,ren)..                                aux_phi_PG_Ren_20(ren,t)                             =l= M *  z_PG_Ren_20(rr,t)
;
SUB_lin34(rr,ren,t)$RR_Ren(rr,ren)..                                phiPG_Ren(ren,t) -  aux_phi_PG_Ren_20(ren,t)         =l= M *  (1 - z_PG_Ren_20(rr,t))
;
SUB_lin35(rr,ren,t)$RR_Ren(rr,ren)..                                - M * z_PG_Ren_20(rr,t)                              =l= aux_phi_PG_Ren_20(ren,t)
;
SUB_lin36(rr,ren,t)$RR_Ren(rr,ren)..                                - M * (1 - z_PG_Ren_20(rr,t) )                       =l= phiPG_Ren(ren,t) -  aux_phi_PG_Ren_20(ren,t)
;

SUB_lin37(rr,ren,t)$RR_Ren(rr,ren)..                                aux_phi_PG_Ren_30(ren,t)                             =l= M *  z_PG_Ren_30(rr,t)
;
SUB_lin38(rr,ren,t)$RR_Ren(rr,ren)..                                phiPG_Ren(ren,t) -  aux_phi_PG_Ren_30(ren,t)         =l= M *  (1 - z_PG_Ren_30(rr,t))
;
SUB_lin39(rr,ren,t)$RR_Ren(rr,ren)..                                - M * z_PG_Ren_30(rr,t)                              =l= aux_phi_PG_Ren_30(ren,t)
;
SUB_lin40(rr,ren,t)$RR_Ren(rr,ren)..                                - M * (1 - z_PG_Ren_30(rr,t) )                       =l= phiPG_Ren(ren,t) -  aux_phi_PG_Ren_30(ren,t)
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
%Single_Wind_and_PV%MP_PG_PV
%Single_Wind_and_PV%MP_PG_Wind
%Summed_Wind_PV%MP_PG_RR


MP_PF_EX
MP_PF_EX_Cap_UB
MP_PF_EX_Cap_LB

MP_PF_PROS_Cap_UB
MP_PF_PROS_Cap_LB
MP_PF_PROS_LIN_UB
MP_PF_PROS_LIN_LB

MP_LS_BM
MP_LS_CP
MP_LS_NMM
MP_LS_FT
MP_LS_TL
MP_LS_PPP
MP_LS_WP
MP_LS_TE
MP_LS_MC
MP_LS_C
MP_LS_OI
MP_LS_X
MP_LS_Service_House
MP_LS_States

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
%Single_Wind_and_PV%SUB_Dual_PG_sun
%Single_Wind_and_PV%SUB_Dual_PG_wind
%Summed_Wind_PV%SUB_Dual_PG_Ren


SUB_Dual_LS_BM
SUB_Dual_LS_CP
SUB_Dual_LS_NMM
SUB_Dual_LS_FT
SUB_Dual_LS_TL
SUB_Dual_LS_PPP
SUB_Dual_LS_WP
SUB_Dual_LS_TE
SUB_Dual_LS_MC
SUB_Dual_LS_C
SUB_Dual_LS_OI
SUB_Dual_LS_X
SUB_Dual_LS_ServiceHouse
SUB_Dual_LS_States

SUB_Dual_PF

SUB_Lin_Dual
SUB_Lin_Dual_n_ref

SUB_US_LOAD_DE
SUB_US_LOAD_States
SUB_UB_LOAD


SUB_US_PG_conv
SUB_UB_PG_conv

%Single_Wind_and_PV%SUB_US_PG_sun
%Single_Wind_and_PV%SUB_UB_PG_sun
%Single_Wind_and_PV%SUB_PV_time_coupling

%Single_Wind_and_PV%SUB_US_PG_wind
%Single_Wind_and_PV%SUB_UB_PG_wind
%Single_Wind_and_PV%SUB_wind_time_coupling

%Summed_Wind_PV%SUB_US_PG_RR
%Summed_Wind_PV%SUB_UB_Total
%Summed_Wind_PV%SUB_UB_PG_RR_10
%Summed_Wind_PV%SUB_UB_PG_RR_20
%Summed_Wind_PV%SUB_UB_PG_RR_30
%Summed_Wind_PV%SUB_RR_timing_z
%Summed_Wind_PV%SUB_RR_time_coupling
%Summed_Wind_PV%SUB_RR_Dunkel_start_10
%Summed_Wind_PV%SUB_RR_Dunkel_start_20
%Summed_Wind_PV%SUB_RR_Dunkel_start_30
%Summed_Wind_PV%SUB_RR_Free_Start
%Summed_Wind_PV%SUB_RR_Free_END



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
%Single_Wind_and_PV%SUB_lin13
%Single_Wind_and_PV%SUB_lin14
%Single_Wind_and_PV%SUB_lin15
%Single_Wind_and_PV%SUB_lin16
%Single_Wind_and_PV%SUB_lin17
%Single_Wind_and_PV%SUB_lin18
%Single_Wind_and_PV%SUB_lin19
%Single_Wind_and_PV%SUB_lin20
%Summed_Wind_PV%SUB_lin21
%Summed_Wind_PV%SUB_lin22
%Summed_Wind_PV%SUB_lin23
%Summed_Wind_PV%SUB_lin24
SUB_lin25
SUB_lin26
SUB_lin27
SUB_lin28
SUB_lin29
SUB_lin30
SUB_lin31
SUB_lin32
SUB_lin33
SUB_lin34
SUB_lin35
SUB_lin36
SUB_lin37
SUB_lin38
SUB_lin39
SUB_lin40
/
;
option optcr = 0.0
;
Gamma_Load = 0
;
Gamma_PG_conv = 0
;
Gamma_PG_PV = 0
;
Gamma_PG_Wind = 0
;
Gamma_Ren_total = 60
;
Gamma_PG_ren_10(rr) = 5
;
Gamma_PG_ren_20(rr) = 20
;
Gamma_PG_ren_30(rr) = 0
;
*inv_iter_hist(l,v)  = 0;
LB                  = -1e10
;
UB                  =  1e10
;
itaux               = 0
;

Loop(v$((UB - LB) gt Toleranz),

Demand_data_fixed_unshed(n,t,v) = Load_unshed(n,t)
;
Demand_data_fixed_states(n,t,v) = Load_states(n,t)
;
PG_M_fixed_conv(g,t,v) = Cap_conv(g)
;
%Single_Wind_and_PV% AF_M_PV_fixed(t,sr,n,v) =   af_PV_up(t,sr,n)
;
%Single_Wind_and_PV% AF_M_Wind_fixed(t,wr,n,v) =  af_wind_up(t,wr,n)
;
%Summed_Wind_PV% AF_M_Ren_fixed(t,rr,n,v)  = af_ren_up(t,rr,n)
;

itaux = ord(v)
;
if( ord(v) = 1,

*Demand_data_fixed(n,d,t,v) = load(n,d,t)
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
inv_cost_master = sum(l,  inv_new_M.l(l)* I_costs_new(l));

            report_decomp(v,'itaux','')         = itaux;
            report_decomp(v,'Gamma_Load','')    = Gamma_Load                                                    + EPS;
            report_decomp(v,'GAMMA_PG_conv','') = GAMMA_PG_conv                                                 + EPS;
            report_decomp(v,'GAMMA_PG_PV','')   = GAMMA_PG_PV                                                   + EPS;
            report_decomp(v,'GAMMA_PG_wind','') = GAMMA_PG_wind                                                 + EPS;
            report_decomp(v,'Line built',l)     = inv_new_M.l(l)                                                         ;
            report_decomp(v,'line cost','')     = inv_cost_master                                               + EPS;
            report_decomp(v,'M_obj','')         = O_M.L                                                         + EPS;
            report_decomp(v,'ETA','')           = ETA.l                                                         + EPS;
            report_decomp(v,'LB','')            = LB;
*            report_decomp(v,'M_Shed','')        = SUM((n,d,t), PLS_M.l(n,t,v))                                    + EPS;
            report_decomp(v,'M_GC','')          = SUM((g,t), var_costs(g,t) * PG_M_conv.l(g,t,v))               + EPS;
*            report_decomp(v,'M_LS','')          = SUM((n,d,t), LS_costs(d) * PLS_M.l(n,d,t,v))                      + EPS;


;
*######################################################Step 4

$include network_expansion_merge.gms

;
*######################################################Step 5

solve Subproblem using MIP maximizing O_Sub
;
*######################################################Step 6

UB = min(UB, (sum(l, inv_new_M.l(l)* I_costs_new(l)) + O_Sub.l))
;

            report_decomp(v,'network','')       = card(ex_l);
            report_decomp(v,'Sub_obj','')       = O_Sub.L                                                       + EPS;
            report_decomp(v,'UB','')            = UB;
*            report_decomp(v,'Sub_Shed','')      = SUM((n,d,t), phiLS.m(n,d,t))                                      + EPS;
            report_decomp(v,'UB-LB','')         = UB - LB                                                       + EPS;
*            report_decomp(v,'Gen_conv','')      = SUM((g,t), PE_conv.l(g,t))                                    + EPS;

*######################################################Step 7

Demand_data_fixed_unshed(n,t,v) =  Pdem_De.l(n,t)
;
Demand_data_fixed_states(n,t,v) = Pdem_States.l(n,t)
;
PG_M_fixed_conv(g,t,v) = PE_conv.l(g,t)
;
%Single_Wind_and_PV% AF_M_PV_fixed(t,sr,n,v) = AF_PV.l(t,sr,n)
;
%Single_Wind_and_PV% AF_M_Wind_fixed(t,wr,n,v) = AF_Wind.l(t,wr,n)
;
%Summed_Wind_PV% AF_M_Ren_fixed(t,rr,n,vv) = AF_Ren.l(t,rr,n)
;

*execute_unload "check_ARO_toy_complete.gdx"
$include network_expansion_clean.gms
execute_unload "check_Test_Loop_Run.gdx";
;
)

execute_unload "check_TEP_ARO_Test.gdx";
$stop
