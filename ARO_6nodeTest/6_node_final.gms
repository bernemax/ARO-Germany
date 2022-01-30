Sets
t /t1*t20/
n /n1*n6/
g /g1*g5/
l /l1*l9/
v / v1*v10/

* loopindex to control uncertainty Budgets
j /j1*j5/
* loop index to control convergence of UB and LB
i /i1*i5/        

* set of existing lines
ex_l(l) /l1*l3/
* set of prospective lines (just for overvier purpose)
pros_l(l)/l4*l9/
;
alias (n,nn), (v,vv)
;
******************************************************Data******************************************************
Table Generator_data (g,*)
        Gen_cap_LB  Gen_cap_UB     Gen_costs    Delta_PG
g1         0            300           18           30
g2         0            250           25           25 
g3         0            400           16           40
g4         0            300           32           30
g5         0            150           35           15
;
Table Demand_data (n,*)
        Need_LB     Need_UB        LS_costs     Delta_dem
n1      180            220          3000           40
n2      0              0            3000            0
n3      0              0            3000            0
n4      135            165          3000           30
n5      90             110          3000           20
n6      180            220          3000           40
;
Table Line_data (l,*)
          react      I_costs     L_cap        
l1       0.02        0           150          
l2       0.02        0           150          
l3       0.02        0           150           
l4       0.02        700000      150          
l5       0.02        1400000     200          
l6       0.02        1800000     200          
l7       0.02        1600000     200         
l8       0.02        800000      150          
l9       0.02        700000      150              
;

*******************************************************Mapping**************************************************
Set

MapG (g,n)
/g1.n1,g2.n2,g3.n3,g4.n5,g5.n6/

MapSend_l(l,n)
/l1.n1, l2.n1,l3.n4

l4.n2,l5.n2,l6.n3,
l7.n3,l8.n4,l9.n5
/

MapRes_l(l,n)
/l1	.n2,l2.n3,l3.n5

l4.n3,l5.n4,l6.n4,
l7.n6,l8.n6,l9.n6
/

Map_prosp_Send(l,n)
/l4.n2,l5.n2,l6.n3,
l7.n3,l8.n4,l9.n5/

Map_prosp_Res(l,n)
/l4.n3,l5.n4,l6.n4,
l7.n6,l8.n6,l9.n6/

ref(n)      /n1/

;

*execute_unload "check_data.gdx";
*$stop

scalars

Toleranz    / 1 /
LB          / -1e10 /
UB          / 1e10 /
itaux       / 1 /
IB          / 3000000 /
M           / 5000 /

Gamma_Load  /0/
Gamma_PG    /0/
;

Parameters

Demand_data_fixed(n,t,v)        fixed realisation of demand in subproblem and tranferred to master
PG_M_fixed(g,t,v)               fixed realisation of supply in subproblem and tranferred to master



report_main(*,*)
report_decomp(v,*,*)
inv_iter_hist(l,v)
inv_cost_master

;
Variables
*********************************************Master*************************************************

O_M                 Objective var of Master Problem
Theta(n,t,v)        Angle of each node associated with DC power flow equations
PF_M(l,t,v)         power flows derived from DC load flow equation 
 
*********************************************Subproblem*********************************************

O_Sub               Objective var of dual Subproblem
lam(n,t)            dual var lamda assoziated with Equation: MP_marketclear
phi(l,t)            dual var phi assoziated with Equation: MP_PF_Ex
teta_ref(n,t)       dual var beta assoziated with Equation: Theta_ref

;
Positive Variables
*********************************************MASTER*************************************************

ETA                 aux var to reconstruct obj. function of the ARO problem
PG_M(g,t,v)         power generation level of a generator
PLS_M(n,t,v)        load shedding

*********************************************Subproblem*********************************************

Pdem(n,t)           realization of demand (Ro)
PE(g,t)             realization of supply (Ro)

phiPG(g,t)          dual var phi assoziated with Equation: MP_PG
phiLS(n,t)          dual var phi assoziated with Equation: MP_LS

omega_UB(l,t)       dual var phi assoziated with Equation: MP_PF_EX_Cap_UB
omega_LB(l,t)       dual var phi assoziated with Equation: MP_PF_EX_Cap_LB

teta_UB(n,t)        dual var beta assoziated with Equation: Theta_UB
teta_LB(n,t)        dual var beta assoziated with Equation: Theta_LB

aux_lam(n,t)        aux continuous var to linearize lam(n.t) * Pdem(n.t) in SUB Objective (Pdem can become variable when uncertainty is considered)
aux_phi_PG(g,t)     aux continuous var to linearize phiPG(g.t) * PE(g.t) in SUB Objective (PE can become variable when uncertainty is considered)
aux_phi_LS(n,t)     aux continuous var to linearize phiLS(n.t) * Pdem(n.t) in SUB Objective
;

Binary Variables
*********************************************Master*************************************************

inv_M(l)            decision variable regarding investment in a prospective line

*********************************************Subproblem*********************************************

z_PG(g,t)           decision variable to construct polyhedral UC-set and decides weather Generation is Max or not
z_dem(n,t)          decision variable to construct polyhedral UC-set and decides weather Demand is at a lower or upper bound 
;

Equations
*********************************************Master**************************************************

MP_Objective
MP_IB
MP_marketclear

MP_PG
   
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
SUB_Dual_PG
SUB_Dual_LS
SUB_Dual_PF

SUB_Lin_Dual
SUB_Lin_Dual_n_ref


SUB_US_LOAD
SUB_UB_LOAD
SUB_US_PG
SUB_UB_PG


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
;


*#####################################################################################Master####################################################################################

MP_Objective..                                                      O_M  =e= sum(l, inv_M(l)* Line_data (l,'I_costs')) + ETA
;

MP_IB..                                                             IB   =g= sum(l, inv_M(l)* Line_data (l,'I_costs'))
;

MP_marketclear(n,t,vv)$(ord(vv) lt (itaux+1))..                     Demand_data_fixed(n,t,vv)  - PLS_M(n,t,vv)   =e= sum(g$MapG (g,n), PG_M(g,t,vv))
*Demand_data_fixed(n,t,vv)                                                     
                                                                    +  sum(l$(MapRes_l(l,n) and ex_l(l)), PF_M(l,t,vv))
                                                                    -  sum(l$(MapSend_l(l,n) and ex_l(l)), PF_M(l,t,vv))
                                                                        
                                                                    +  sum(l$Map_prosp_Res(l,n), PF_M(l,t,vv))
                                                                    -  sum(l$Map_prosp_Send(l,n), PF_M(l,t,vv))
;
MP_PG(g,t,vv)$(ord(vv) lt (itaux+1))..                              PG_M(g,t,vv) =l= PG_M_fixed(g,t,vv)
*PG_M_fixed(g,t,vv) 
;


MP_PF_EX(l,t,vv)$(ex_l(l) and (ord(vv) lt (itaux+1)))..             PF_M(l,t,vv) =e= 1/line_data(l,'react') * (sum(n$MapSend_l(l,n),  Theta(n,t,vv)) - sum(n$MapRes_l(l,n),  Theta(n,t,vv)))
;      
MP_PF_EX_Cap_UB(l,t,vv)$(ex_l(l) and ord(vv) lt (itaux+1))..        PF_M(l,t,vv) =l= line_data(l,'L_cap')
;
MP_PF_EX_Cap_LB(l,t,vv)$(ex_l(l) and ord(vv) lt (itaux+1))..        PF_M(l,t,vv) =g= - line_data(l,'L_cap')  
;


MP_PF_PROS_Cap_UB(l,t,vv)$(pros_l(l) and ord(vv) lt (itaux+1))..    PF_M(l,t,vv) =l= line_data(l,'L_cap') * inv_M(l)
;
MP_PF_PROS_Cap_LB(l,t,vv)$(pros_l(l) and ord(vv) lt (itaux+1))..    PF_M(l,t,vv) =g= - line_data(l,'L_cap') * inv_M(l)
;
MP_PF_PROS_LIN_UB(l,t,vv)$(pros_l(l) and (ord(vv) lt (itaux+1)))..  (1-inv_M(l)) *M   =g= PF_M(l,t,vv) - (1/line_data(l,'react') * (sum(n$Map_prosp_Send(l,n),  Theta(n,t,vv)) - sum(n$Map_prosp_Res(l,n),  Theta(n,t,vv))))
;
MP_PF_PROS_LIN_LB(l,t,vv)$(pros_l(l) and (ord(vv) lt (itaux+1)))..  -(1-inv_M(l)) *M  =l= PF_M(l,t,vv) - (1/line_data(l,'react') * (sum(n$Map_prosp_Send(l,n),  Theta(n,t,vv)) - sum(n$Map_prosp_Res(l,n),  Theta(n,t,vv))))
;


MP_LS(n,t,vv)$(ord(vv) lt (itaux+1))..                              PLS_M(n,t,vv) =l= Demand_data_fixed(n,t,vv)
*Demand_data_fixed(n,t,vv)
;


Theta_UB(n,t,vv)$(ord(vv) lt (itaux+1))..                           3.1415          =g= Theta(n,t,vv)
;
Theta_LB(n,t,vv)$(ord(vv) lt (itaux+1))..                           - 3.1415         =l= Theta(n,t,vv)
;
Theta_ref(n,t,vv)$(ord(vv) lt (itaux+1))..                          Theta(n,t,vv)$ref(n)      =e= 0
; 


MP_ETA(vv)$(ord(vv) lt (itaux+1))..                                 ETA =g=   sum((g,t), Generator_data (g,'Gen_costs') * PG_M(g,t,vv))

                                                                    + sum((n,t), Demand_data (n,'LS_costs') * PLS_M(n,t,vv))
                                    
;
*#####################################################################################Subproblem####################################################################################

SUB_Dual_Objective..                                                O_Sub =e= sum((n,t), lam(n,t) * Demand_data (n,'Need_LB') 
                                                                    + aux_lam(n,t) *    ( + Demand_data (n,'delta_dem')))
*(Demand_data (n,'Need_LB') + Demand_data (n,'delta_dem')))                                                                    
                                                                    + sum((g,t), - phiPG(g,t) * Generator_data (g,'Gen_cap_UB')
                                                                    + aux_phi_PG(g,t) * ( + Generator_data (g,'delta_PG')))
*(Generator_data (g,'Gen_cap_UB') - Generator_data (g,'delta_PG')))                                                                    
                                                                    + sum((n,t), - phiLS(n,t) * Demand_data (n,'Need_LB') 
                                                                    + aux_phi_LS(n,t) * ( - Demand_data (n,'delta_dem'))) 
*(Demand_data (n,'Need_LB') + Demand_data (n,'delta_dem')))                                                                    
                                                                    + sum((l,t), - omega_UB(l,t) * line_data(l,'L_cap'))
                                                                    + sum((l,t), - omega_LB(l,t) * line_data(l,'L_cap'))
                                                                    
                                                                    + sum((n,t), - teta_UB(n,t) * 3.1415)
                                                                    + sum((n,t), - teta_LB(n,t) * 3.1415)
;
*****************************************************************Dual Power generation equation

SUB_Dual_PG(g,t)..                                                  sum(n$MapG(g,n), lam(n,t) -  phiPG(g,t)) =l=   Generator_data (g,'Gen_costs')  
;
*****************************************************************Dual Load shedding equation

SUB_Dual_LS(t)..                                                    sum(n, lam(n,t) -  phiLS(n,t)) =l=  3000  
*sum(nn, lam(n,t) -  phiLS(n,t)) =l=  Demand_data (n,'LS_costs')
;
*****************************************************************Dual Power flow equations

SUB_Dual_PF(l,t)..                                                  - sum(n$(MapSend_l(l,n) and ex_l(l)), lam(n,t)) + sum(n$(MapRes_l(l,n) and ex_l(l)), lam(n,t))
                                                                    - omega_UB(l,t)  + omega_LB(l,t) + phi(l,t)
                                                                                                                      =e= 0
;
SUB_LIN_Dual(n,t)..                                                 - sum(l$(MapSend_l(l,n) and ex_l(l) and not ref(n)), (1/line_data(l,'react')) * phi(l,t))
                                                                    + sum(l$(MapRes_l(l,n) and ex_l(l) and not ref(n)),  (1/line_data(l,'react')) * phi(l,t))
                                                                    -  teta_UB(n,t)
                                                                    +  teta_LB(n,t)                                   =e= 0
;
SUB_Lin_Dual_n_ref(n,t)..                                           - sum(l$(MapSend_l(l,n) and ex_l(l) and ref(n)), (1/line_data(l,'react')) * phi(l,t))
                                                                    + sum(l$(MapRes_l(l,n) and ex_l(l) and ref(n)),  (1/line_data(l,'react')) * phi(l,t))
                                                                    +  teta_ref(n,t)                                  =e= 0

;

*****************************************************************Uncertainty Sets/ and polyhedral uncertainty budgets (level 2 problem)

SUB_US_LOAD(n,t)..                                                  Pdem(n,t)  =e= Demand_data (n,'Need_LB') + Demand_data (n,'delta_dem') * z_dem(n,t)
;
SUB_UB_LOAD..                                                       sum((n,t), z_dem(n,t))  =l= Gamma_load 
;

SUB_US_PG(g,t)..                                                    PE(g,t)    =e= Generator_data (g,'Gen_cap_UB') - Generator_data (g,'delta_PG') * z_PG(g,t)
;
SUB_UB_PG..                                                         sum((g,t), z_PG(g,t))   =l= Gamma_PG 
;
*****************************************************************linearization


SUB_lin1(n,t)..                                                     aux_lam(n,t)                    =l= M * z_dem(n,t)
;
SUB_lin2(n,t)..                                                     lam(n,t)  - aux_lam(n,t)        =l= M * ( 1 - z_dem(n,t))
;
SUB_lin3(n,t)..                                                     - M * z_dem(n,t)                =l= aux_lam(n,t)
;
SUB_lin4(n,t)..                                                     - M * ( 1 - z_dem(n,t))         =l= lam(n,t)  - aux_lam(n,t) 
;


SUB_lin5(g,t)..                                                     aux_phi_PG(g,t)                 =l= M *   z_PG(g,t)
*sum(n$MapG(g,n), z_PG(g,t))
;
SUB_lin6(g,t)..                                                     phiPG(g,t) - aux_phi_PG(g,t)    =l= M *  ( 1 - z_PG(g,t))
*sum(n$MapG(g,n), 1 - z_PG(g,t))
;
SUB_lin7(g,t)..                                                     - M *   z_PG(g,t)               =l= aux_phi_PG(g,t)
;
SUB_lin8(g,t)..                                                     - M *  ( 1 - z_PG(g,t))         =l= phiPG(g,t) - aux_phi_PG(g,t)
;



SUB_lin9(n,t)..                                                     aux_phi_LS(n,t)                 =l= M * z_dem(n,t)
;
SUB_lin10(n,t)..                                                    phiLS(n,t) - aux_phi_LS(n,t)    =l= M * ( 1 - z_dem(n,t))
;
SUB_lin11(n,t)..                                                    - M * z_dem(n,t)                =l= aux_phi_LS(n,t)
;
SUB_lin12(n,t)..                                                    - M * ( 1 - z_dem(n,t))         =l= phiLS(n,t) - aux_phi_LS(n,t)
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

MP_PG
   
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
SUB_Dual_PG
SUB_Dual_LS
SUB_Dual_PF

SUB_Lin_Dual
SUB_Lin_Dual_n_ref

SUB_US_LOAD
SUB_UB_LOAD
SUB_US_PG
SUB_UB_PG

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
/
;
*solve Subproblem using MIP maximizing O_SUB;
*execute_unload "check_Master.gdx";
*$stop
*#######################################################Step 1
option optcr = 0
;
Gamma_Load = 50
;
Gamma_PG = 60
;
*inv_iter_hist(l,v)  = 0;
LB                  = -1e10
;
UB                  =  1e10
;
itaux               = 0
;

Loop(v$((UB - LB) gt Toleranz),

*Demand_data_fixed(n,t,v) = Demand_data (n,'Need_LB')
*;
*PG_M_fixed(g,t,v)= Generator_data (g,'Gen_cap_UB')
*;

itaux = ord(v)
;
if( ord(v) = 1,

Demand_data_fixed(n,t,v) = Demand_data (n,'Need_LB')
;
PG_M_fixed(g,t,v)= Generator_data (g,'Gen_cap_UB')
;

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
inv_cost_master = sum(l,  inv_M.l(l)* Line_data(l,'I_costs'));

            report_decomp(v,'itaux','')         = itaux;
            report_decomp(v,'Gamma_Load','')    = Gamma_Load                                                    + EPS;
            report_decomp(v,'GAMMA_PG','')      = GAMMA_PG                                                      + EPS;
            report_decomp(v,'Line built',l)     = inV_M.l(l)                                                         ;
            report_decomp(v,'line cost','')     = inv_cost_master                                               + EPS;
            report_decomp(v,'M_obj','')         = O_M.L                                                         + EPS;
            report_decomp(v,'ETA','')           = ETA.l                                                         + EPS;
            report_decomp(v,'LB','')            = LB;
            report_decomp(v,'M_Shed','')        = SUM((n,t), PLS_M.l(n,t,v))                                    + EPS;
            report_decomp(v,'M_GC','')          = SUM((g,t), Generator_data (g,'Gen_costs')*PG_M.l(g,t,v))      + EPS;
            report_decomp(v,'M_LS','')          = SUM((n,t), Demand_data (n,'LS_costs')*PLS_M.l(n,t,v))         + EPS;
         

;
*######################################################Step 4

$include network_expansion_merge.gms

;
*######################################################Step 5

solve Subproblem using MIP maximizing O_Sub
;
*######################################################Step 6

UB = min(UB, (sum(l, inv_M.l(l)* Line_data (l,'I_costs')) + O_Sub.l))
;

            report_decomp(v,'network','')       = card(ex_l);
            report_decomp(v,'Sub_obj','')       = O_Sub.L                                                       + EPS;
            report_decomp(v,'UB','')            = UB;
            report_decomp(v,'Sub_Shed','')      = SUM((n,t), phiLS.m(n,t))                                      + EPS;
            report_decomp(v,'UB-LB','')         = UB - LB                                                       + EPS;
            report_decomp(v,'Gen','')           = SUM((g,t), PE.l(g,t))                                         + EPS;
            
*######################################################Step 7
$include network_expansion_clean.gms
;

Demand_data_fixed(n,t,v) = Pdem.l(n,t)
;
PG_M_fixed(g,t,v)= PE.l(g,t)
;

*execute_unload "check_ARO_toy_complete.gdx"
;
)

execute_unload "check_ARO_toy_complete.gdx";
$stop

$ontext
loop(j,

    GAMMA_D = 0;
    GAMMA_S = 0;
    inv_iter_hist(l,v)  = 0;
    LB                  = -1e10;
    UB                  =  1e10;
    itaux               = 0;
*$offtext    


 loop(i,

    inv_iter_hist(l,v)  = 0;
    LB                  = -1e10;
    UB                  =  1e10;
    itaux               = 0;
    inv_cost_master     = 0;
$offtext