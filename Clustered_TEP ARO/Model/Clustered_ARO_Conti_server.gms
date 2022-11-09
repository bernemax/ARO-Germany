
* Overall UB = 60
* Regional UB = 7
* INV = continious
* INV intrest rate 7%
* Life time investments 40 years


$funclibin stolib stodclib
function random_normal     /stolib.dnormal/
         random_uni        /stolib.duniform/
;

* shows the computational time needed by each prcess until 1 sec.
option profile = 1;
option profiletol = 0.01;

;

Sets

n /n1*n111/
d /BM1*BM480,CP1*CP494,NMM1*NMM495,FT1*FT495,TL31*TL443,PPP1*PPP495,
WP1*WP495,TE8*TE493,MC1*MC495,C1*C495,OI1*OI495,X1*X510,Service1*Service495,
House1*House495/

l /l1*l1100/
g /g1*g622/
s /s1*s178/
*sun and wind set
*Res/res1*res1021/
*set, that represents the sum of sun and wind
Ren/ren1*ren111/

t/t1*t30/
v /v1*v5/
*sr/sr1*sr12/
*wr/wr1*wr12/
rr/rr1*rr12/
*CSR/CSR1*CSR12/
*CWR/CWR1*CWR12/

*Sun_shine(t) /t1*t5/
*t32*t40, t56*t64, t80*t88, t104*t114/

DF
/Df1*DF365/

*H(t,it)

****************************thermal************************************************
gas(g)
lig(g)
coal(g)
nuc(g)
oil(g)
waste(g)
biomass(g)

****************************hydro***************************************************
ror(s)
reservoir(s)
psp(s)
psp_DE(s)

****************************lines***************************************************
ex_l(l)/l1*l254/
pros_l(l)/l1000*l1046/

Border_exist_DE(l)
Border_exist_total(l)

Border_prosp_DE(l)
Border_prosp_total(l)


****************************nodes***************************************************
ref(n)
/n1/
DE_nodes(n)
/n1*n100/

border_states(n)
/n101*n111/

DK(n) /n101/
SW(n) /n102/
PL(n) /n103/
CZ(n) /n104/
AT(n) /n105/
CH(n) /n106/
FR(n) /n107/
LU(n) /n108/
NE(n) /n109/
BE(n) /n110/
NW(n) /n111/


Relevant_Nodes(n)
/n1*n111/

*****************************mapping************************************************
MAP_DF(t,DF)


Map_grid(l,n)
Map_send_L(l,n)
Map_res_L(l,n)
MapD(d,n)
MapG(g,n)
MapS(s,n)

*MapRes(res,n)
MapRen(ren,n)
*MapSr(sr,n)
*MapWr(wr,n)
MapRR(rr,n)

MAP_RR_Ren(rr,ren,n)
RR_ren(rr,ren)
;
alias (n,nn),(t,tt),(l,ll), (v,vv)
;
Scalar
Gamma_test /10/
;
$include Loading_Clustered_Data.gms
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
PG_M_Ren(ren,t,v)           cummulative power generation level of renewable solar pv and wind generators

PLS_M(n,t,v)

inv_new_M(l)                Investment decision variable regarding capacity investment in a new prospective line

*********************************************Subproblem*********************************************
Pdem(n,t)                   Uncertain load in node n in time step t

Pdem_De(n,t)                realization of Household and service sector demand (unsheaddable) (Ro)
Pdem_States(n,t)            realization of neighbore countries demand (unsheaddable) (Ro)
PE_conv(g,t)                realization of conventional supply (Ro)
AF_Ren(t,rr,n)              realization of combined wind and pv

phiPG_conv(g,t)             dual var phi assoziated with Equation: MP_PG_conv
phiPG_Hydro(s,t)            dual Var phi assoziated with Equation: MP_PG_Hydro
phiPG_Ren(ren,t)            dual variable of combined wind and solar pv generation assoziated with Equation: MP_PG_RR

phiLS(n,t)                  dual load shedding variable

omega_UB(l,t)               dual var phi assoziated with Equation: MP_PF_EX_Cap_UB
omega_LB(l,t)               dual var phi assoziated with Equation: MP_PF_EX_Cap_LB

teta_UB(n,t)                dual var beta assoziated with Equation: Theta_UB
teta_LB(n,t)                dual var beta assoziated with Equation: Theta_LB
 
aux_phi_Ren_DF(ren,t)       aux continuous var to linearize
;

Binary Variables
*********************************************Master*************************************************

*inv_new_M(l)                decision variable regarding investment in a new prospective line
*inv_upg_M(l)                decision variable regarding an possible upgrade of the capacity of an existing line

*********************************************Subproblem*********************************************

z_PG_conv(g,t)              decision variable to construct polyhedral UC-set and decides weather conventional Generation potential is Max or not
*z_PG_PV(sr,t)               decision variable to construct polyhedral UC-set and decides weather PV Generation potential is Max or not
*z_PG_Wind(wr,t)             decision variable to construct polyhedral UC-set and decides weather wind Generation potential is Max or not
z_dem_De(n,t)               decision variable to construct polyhedral UC-set and decides weather Demand is at a lower or upper bound
z_dem_states(n,t)

z_dem(n,t)

z_PG_Ren(DF,rr)             decision variable to construct polyhedral UC-set and decides weather combined pv and wind generation potential is Max or not
;

Equations
*********************************************Master**************************************************
MP_Objective
MP_IB
MP_marketclear

MP_PG_conv
MP_PG_Hydro
MP_PG_RR

MP_PF_EX
MP_PF_EX_Cap_UB
MP_PF_EX_Cap_LB

MP_PF_PROS
MP_PF_PROS_Cap_UB
MP_PF_PROS_Cap_LB


MP_LS
Theta_UB
Theta_LB
Theta_ref
MP_ETA

*********************************************Subproblem*********************************************

SUB_Dual_Objective

SUB_Dual_PG_conv
SUB_Dual_PG_hydro
SUB_Dual_PG_Ren

SUB_Dual_LS

SUB_Dual_PF

SUB_Lin_Dual
SUB_Lin_Dual_n_ref

SUB_US_LOAD_DE
SUB_US_LOAD_States

SUB_US_PG_conv

SUB_US_PG_RR
SUB_UB_Total
SUB_UB_PG_RR

SUB_lin33
SUB_lin34
SUB_lin35
SUB_lin36


;
*#####################################################################################Master####################################################################################
MP_Objective(vv)..                                                                              O_M  =e= sum(l$(pros_l(l)), inv_new_M(l) * (I_costs_new(l)/L_cap_prosp(l))) + ETA
;

MP_IB(vv)..                                                                                     IB   =g= sum(l$(pros_l(l)), inv_new_M(l) * (I_costs_new(l)/L_cap_prosp(l)))
;

MP_marketclear(n,t,vv)$(ord(vv) lt (itaux+1))..
*                                                                                                Demand_data_fixed_unshed(n,t,vv)

                                                                                                Demand_data_fixed(n,t,vv) - PLS_M(n,t,vv)
                                                                                              
                                                                                                =e= sum(g$MapG (g,n), PG_M_conv(g,t,vv))

                                                                                                + sum(s$MapS(s,n),  PG_M_Hydro(s,t,vv))
                                                                                                +  sum(ren$MapRen(ren,n), PG_M_Ren(ren,t,vv))

                                                                                                +  sum(l$(Map_Res_l(l,n) and ex_l(l)), PF_M(l,t,vv))
                                                                                                -  sum(l$(Map_Send_l(l,n) and ex_l(l)), PF_M(l,t,vv))

                                                                                                +  sum(l$(Map_Res_l(l,n) and pros_l(l)), PF_M(l,t,vv))
                                                                                                -  sum(l$(Map_Send_l(l,n) and pros_l(l)), PF_M(l,t,vv))

;


MP_PG_conv(g,t,vv)$(ord(vv) lt (itaux+1))..                                                     PG_M_conv(g,t,vv)       =l= PG_M_fixed_conv(g,t,vv)
;
MP_PG_Hydro(s,t,vv)$(ord(vv) lt (itaux+1))..                                                    PG_M_Hydro(s,t,vv)      =l= Cap_hydro(s)
;
MP_PG_RR(ren,rr,n,t,vv)$(MAP_RR_Ren(rr,ren,n) and (ord(vv) lt (itaux+1)))..                     PG_M_Ren(ren,t,vv)       =l= Cap_ren(ren) * AF_M_Ren_fixed(t,rr,n,vv)
;

MP_PF_EX(l,t,vv)$(ex_l(l)  and (ord(vv) lt (itaux+1)))..                                        PF_M(l,t,vv) =e= B(l) * (sum(n$Map_Send_l(l,n),  Theta(n,t,vv)) - sum(n$Map_Res_l(l,n),  Theta(n,t,vv))) * MVAbase
;
MP_PF_EX_Cap_UB(l,t,vv)$(ex_l(l) and (ord(vv) lt (itaux+1)))..                                  PF_M(l,t,vv) =l= L_cap(l)
;
MP_PF_EX_Cap_LB(l,t,vv)$(ex_l(l)  and (ord(vv) lt (itaux+1)))..                                 PF_M(l,t,vv) =g= - L_cap(l)
;


MP_PF_PROS(l,t,vv)$(pros_l(l)  and (ord(vv) lt (itaux+1)))..                                    PF_M(l,t,vv) =e= B_prosp(l) * (sum(n$Map_Send_l(l,n),  Theta(n,t,vv)) - sum(n$Map_Res_l(l,n),  Theta(n,t,vv))) * MVAbase
;
MP_PF_PROS_Cap_UB(l,t,vv)$(pros_l(l) and (ord(vv) lt (itaux+1)))..                              PF_M(l,t,vv) =l=  inv_new_M(l)
;
MP_PF_PROS_Cap_LB(l,t,vv)$(pros_l(l) and (ord(vv) lt (itaux+1)))..                              PF_M(l,t,vv) =g= - inv_new_M(l)
;



MP_LS(n,t,vv)$(ord(vv) lt (itaux+1))..                                                          PLS_M(n,t,vv) =l= Demand_data_fixed(n,t,vv)
;


Theta_UB(n,t,vv)$(Relevant_Nodes(n) and (ord(vv) lt (itaux+1)))..                               3.1415          =g= Theta(n,t,vv)
;
Theta_LB(n,t,vv)$(Relevant_Nodes(n) and (ord(vv) lt (itaux+1)))..                               - 3.1415         =l= Theta(n,t,vv)
;
Theta_ref(n,t,vv)$(ord(vv) lt (itaux+1))..                                                      Theta(n,t,vv)$ref(n)      =e= 0
;


MP_ETA(vv)$(ord(vv) lt (itaux+1))..                                                             ETA =g=   sum((g,t), var_costs(g,t) * PG_M_conv(g,t,vv))
                                                                                                + sum((s,t), 20 * PG_M_hydro(s,t,vv))
                                                                                                
                                                                                                + sum((n,t), LS_costs(n) * PLS_M(n,t,vv))

;
*#####################################################################################Subproblem####################################################################################

SUB_Dual_Objective..                                                O_Sub =e= sum((n,t), lam(n,t) * load(n,t)) 

                                                                    + sum((g,t), - phiPG_conv(g,t) * Cap_conv(g))

                                                                    + sum((s,t), - phiPG_hydro(s,t) * Cap_Hydro(s))


                                                                    + sum((rr,ren,n,DF,t)$(MAP_RR_Ren(rr,ren,n)),
                                                                    - phiPG_Ren(ren,t) * (Cap_ren(ren) * (Ratio_N(t,DF,rr,n)$MAP_DF(t,DF) * Budget_N(DF,rr,n)))
                                                                    + aux_phi_Ren_DF(ren,t)  * (Cap_ren(ren) * (Ratio_DF(t,DF,rr,n)$MAP_DF(t,DF) * Budget_Delta(DF,rr,n))))
                                                                
                                                                    + sum((n,t), - phiLS(n,t) * load(n,t))
                                                                    
                                                                    + sum((l,t)$ex_l(l), - omega_UB(l,t) *  L_cap(l))
                                                                    + sum((l,t)$ex_l(l), - omega_LB(l,t) *  L_cap(l))

                                                                    + sum((l,t)$ex_l(l), - omega_UB(l,t) *  Prosp_cap(l))
                                                                    + sum((l,t)$ex_l(l), - omega_LB(l,t) *  Prosp_cap(l))

;
*****************************************************************Dual Power generation equation*****************************************************************

SUB_Dual_PG_conv(g,t)..                                             sum((n)$MapG(g,n) , lam(n,t) -  phiPG_conv(g,t))                           =l= var_costs(g,t)
;
SUB_Dual_PG_hydro(s,t)..                                            sum((n)$MapS(s,n) , lam(n,t) -  phiPG_hydro(s,t))                          =l=   20
;
SUB_Dual_PG_Ren(ren,t)..                                            sum((n)$MapRen(ren,n), lam(n,t) - phiPG_Ren(ren,t))                     =l=   0
;

*****************************************************************Dual Load shedding equation*********************************************************************

SUB_Dual_LS(t)..                                                    sum(n, lam(n,t) -  phiLS(n,t))  =l=  sum(n,LS_costs(n) ) 
;

*****************************************************************Dual Power flow equations***********************************************************************

SUB_Dual_PF(l,t)$ex_l(l)..                                          - sum(n$(Map_Send_l(l,n)), lam(n,t)) + sum(n$(Map_Res_l(l,n)), lam(n,t))
                                                                    - omega_UB(l,t)  + omega_LB(l,t) + (phi(l,t)/MVAbase)
                                                                                                                      =e= 0
;
SUB_LIN_Dual(n,t)..                                                 - sum(l$(Map_Send_l(l,n) and ex_l(l) and not ref(n) ),  B(l) * phi(l,t))
                                                                    - sum(l$(Map_Send_l(l,n) and ex_l(l) and not ref(n) ),  B_prosp(l) * phi(l,t))
                                                                    + sum(l$(Map_Res_l(l,n) and ex_l(l) and not ref(n) ),   B(l) * phi(l,t))
                                                                    + sum(l$(Map_Res_l(l,n) and ex_l(l) and not ref(n) ),   B_prosp(l) * phi(l,t))
*                                                                    -  teta_UB(n,t) +  teta_LB(n,t)
                                                                                                      =e= 0
;
SUB_Lin_Dual_n_ref(n,t)..                                           - sum(l$(Map_Send_l(l,n) and ex_l(l) and ref(n)), B(l)  * phi(l,t))
                                                                    + sum(l$(Map_Res_l(l,n) and ex_l(l) and ref(n)),  B(l)  * phi(l,t))

                                                                    +  teta_ref(n,t)                                  =e= 0

;

*****************************************************************Uncertainty Sets/ and polyhedral uncertainty budgets (level 2 problem)***************************

SUB_US_LOAD_DE(n,t)..                                               Pdem(n,t)  =e= load(n,t) 
;
SUB_US_LOAD_States(n,t)$(border_states(n))..                        Pdem_States(n,t) =e= Load_states(n,t) 
;

SUB_US_PG_conv(g,t)..                                               PE_conv(g,t) =l= Cap_conv(g)
;


SUB_US_PG_RR(t,DF,rr,n)$(MAP_DF(t,DF) and MapRR(rr,n))..            AF_Ren(t,rr,n) =e=  Ratio_N(t,DF,rr,n) * Budget_N(DF,rr,n) - z_PG_Ren(DF,rr) * (Ratio_DF(t,DF,rr,n) * Budget_Delta(DF,rr,n)) 
;
SUB_UB_Total..                                                      Gamma_Ren_total - sum((DF,rr),  z_PG_Ren(DF,rr)) =g= 0
;
SUB_UB_PG_RR(rr)..                                                  sum(DF, z_PG_Ren(DF,rr))  =l= Gamma_PG_ren(rr)
;
*****************************************************************linearization*********************************************************************************


SUB_lin33(t,DF,rr,ren)$(MAP_DF(t,DF) and RR_Ren(rr,ren))..         aux_phi_Ren_DF(ren,t)                              =l= M *  z_PG_Ren(DF,rr) 
;
SUB_lin34(t,DF,rr,ren)$(MAP_DF(t,DF) and RR_Ren(rr,ren))..         phiPG_Ren(ren,t) -  aux_phi_Ren_DF(ren,t)          =l= M *  (1 - z_PG_Ren(DF,rr) )
;
SUB_lin35(t,DF,rr,ren)$(MAP_DF(t,DF) and RR_Ren(rr,ren))..         - M * z_PG_Ren(DF,rr)                              =l= aux_phi_Ren_DF(ren,t) 
;   
SUB_lin36(t,DF,rr,ren)$(MAP_DF(t,DF) and RR_Ren(rr,ren))..         - M * (1 - z_PG_Ren(DF,rr) )                       =l= phiPG_Ren(ren,t) -  aux_phi_Ren_DF(ren,t) 
;


*execute_unload "check_EQ.gdx";
*$stop
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
MP_PG_RR

MP_PF_EX
MP_PF_EX_Cap_UB
MP_PF_EX_Cap_LB

MP_PF_PROS
MP_PF_PROS_Cap_UB
MP_PF_PROS_Cap_LB


MP_LS
*Theta_UB
*Theta_LB
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
SUB_Dual_PG_Ren

SUB_Dual_LS
SUB_Dual_PF

SUB_Lin_Dual
SUB_Lin_Dual_n_ref

SUB_US_LOAD_DE
*SUB_US_LOAD_States

SUB_US_PG_conv

SUB_US_PG_RR
SUB_UB_Total
SUB_UB_PG_RR

SUB_lin33
SUB_lin34
SUB_lin35
SUB_lin36

/
;
option optcr = 0
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
Gamma_PG_ren(rr) = 7
;
*inv_iter_hist(l,v)  = 0;
LB                  = -1e10
;
UB                  =  1e10
;

Loop(v$((UB - LB) gt Toleranz),

Demand_data_fixed(n,t,v) = load(n,t)
;
PG_M_fixed_conv(g,t,v) = Cap_conv(g)
;
AF_M_Ren_fixed(t,rr,n,v)  = af_ren_up(t,rr,n)
;


itaux = ord(v)
;
if( ord(v) = 1,



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
inv_cost_master(v) = sum(l,  inv_new_M.l(l) * (I_costs_new(l)/L_cap_prosp(l)));

            report_decomp(v,'itaux','')         = itaux;
            report_decomp(v,'Gamma_Load','')    = Gamma_Load                                                    + EPS;
            report_decomp(v,'GAMMA_PG_conv','') = GAMMA_PG_conv                                                 + EPS;
            report_decomp(v,'GAMMA_PG_PV','')   = GAMMA_PG_PV                                                   + EPS;
            report_decomp(v,'GAMMA_PG_wind','') = GAMMA_PG_wind                                                 + EPS;
            report_decomp(v,'Line built',l)     = inv_new_M.l(l)                                                     ;
            report_decomp(v,'line cost','')     = inv_cost_master(v)                                            + EPS;
            report_decomp(v,'M_obj','')         = O_M.L                                                         + EPS;
            report_decomp(v,'ETA','')           = ETA.l                                                         + EPS;
            report_decomp(v,'LB','')            = LB;
            report_decomp(v,'M_Shed','')        = SUM((n,t), PLS_M.l(n,t,v))                                    + EPS;
            report_decomp(v,'M_GC','')          = SUM((g,t), var_costs(g,t) * PG_M_conv.l(g,t,v))               + EPS;
            report_decomp(v,'M_LS','')          = SUM((n,t), LS_costs(n) * PLS_M.l(n,t,v))                      + EPS;

           
;
*######################################################Step 4

$include network_expansion_merge_conti.gms
;
Prosp_cap(l) = inv_new_M.l(l)
;

*######################################################Step 5

solve Subproblem using MIP maximizing O_Sub
;
*######################################################Step 6

UB = min(UB, (sum(l, inv_new_M.l(l) * (I_costs_new(l)/L_cap_prosp(l))) + O_Sub.l))
;

            report_decomp(v,'network','')       = card(ex_l);
            report_decomp(v,'Sub_obj','')       = O_Sub.L                                                       + EPS;
            report_decomp(v,'UB','')            = UB;
*            report_decomp(v,'Sub_Shed','')      = SUM((n,d,t), phiLS.m(n,d,t))                                      + EPS;
            report_decomp(v,'UB-LB','')         = UB - LB                                                       + EPS;
*            report_decomp(v,'Gen_conv','')      = SUM((g,t), PE_conv.l(g,t))                                    + EPS;
            compare_av_ren(t,rr,n)              = AF_Ren.l(t,rr,n) - af_ren_up(t,rr,n);
*######################################################Step 7
Demand_data_fixed(n,t,v) = load(n,t)
;
PG_M_fixed_conv(g,t,v) = Cap_conv(g)
;
AF_M_Ren_fixed(t,rr,n,v) = AF_Ren.l(t,rr,n)
;

*execute_unload "check_ARO_toy_complete.gdx"
$include network_expansion_clean.gms
execute_unload "check_Loop_Run_server.gdx";
;
)

execute_unload "check_TEP_ARO_server.gdx";
***************************************************output**************************************************

Report_dunkel_time_Z(rr) = sum(DF, z_PG_Ren.l(DF,rr))
;
Report_dunkel_hours_Z(df,rr) =  z_PG_Ren.l(DF,rr)
;
Report_lines_built(l) = inv_new_M.l(l)
;
Report_total_cost = O_M.l
;
Report_line_constr_cost(V) = inv_cost_master(v)
;

Report_LS_node(n,t,vv) = PLS_M.l(n,t,vv)
;
Report_LS_per_hour(t,vv) = sum(n,Report_LS_node(n,t,vv))
;
Report_LS_total(vv) = sum(t,Report_LS_per_hour(t,vv))
;


Report_PG('conv',g,t,vv)  = PG_M_conv.l(g,t,vv)
;
Report_PG('ROR',ror,t,vv)  = PG_M_Hydro.l(ror,t,vv)
;
Report_PG('PSP',psp,t,vv)  = PG_M_Hydro.l(psp,t,vv)
;
Report_PG('Reservoir',reservoir,t,vv)  = PG_M_Hydro.l(reservoir,t,vv)
;
Report_PG('REN',ren,t,vv)  = PG_M_Ren.l(ren,t,vv)
;

Report_lineflow(l,t,vv) = PF_M.l(l,t,vv)
;

execute_unload "Results_Clustered_ARO_server.gdx"
Report_dunkel_time_Z, Report_dunkel_hours_Z, Report_lines_built, Report_total_cost,
Report_line_constr_cost, Report_LS_CP, Report_LS_NMM, Report_LS_FT, Report_LS_TL,
Report_LS_PPP, Report_LS_WP, Report_LS_TE, Report_LS_MC, Report_LS_C, Report_LS_OI,
Report_LS_X,Report_LS_node,Report_LS_per_hour,Report_LS_total, Report_PG, Report_lineflow
;

execute '=gams Master lo=2 gdx=Results_Clustered_ARO_server'
;
execute '=gdx2xls Results_Clustered_ARO_server.gdx'
;
*execute '=shellExecute Results_1.xlsx'
*;


$stop