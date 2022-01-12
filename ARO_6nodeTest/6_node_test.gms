Sets
t /t1*t24/
n /n1*n6/
g /g1*g5/
l /l1*l9/
v / v1*v5/

ex_l(l) /l1*l3/
pros_l(l)/l4*l9/
;
alias (n,nn), (v,vv)
;
******************************************************Data******************************************************
Table Generator_data (g,*)
        Gen_cap_LB  Gen_cap_UB     Gen_costs    Delta_PG
g1         0            300           18           300
g2         0            250           25           250 
g3         0            400           16           400
g4         0            300           32           300
g5         0            150           35           150
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
/g1.n1,g2.n3,g3.n6/
MapSend_l(l,n)
/ l1.n1, l2.n1, l3.n4/
   
MapRes_l(l,n)
/ l1	.n2,l2.n3,l3.n5/

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
Tol         / 1 /
LB          / -1e10 /
UB          / 1e10 /
itaux       / 0 /
IB          / 3000000 /
M           / 5000 /

Gamma_Load  /0/
Gamma_PG    /0/
;

Parameters
* fixed realisation of demand in subproblem, tranferred to master
Demand_data_fixed(n,t,v)
* fixed realisation of supply in subproblem, tranferred to master
PG_M_fixed(g,t,v)    

;
Variables
*********************************************Master*************************************************

 O_M                Objective var of Master Problem
 Theta(n,t,v)       Anggle of each node associated with DC power flow equations 
 
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
PF_M(l,t,v)         power flows derived from DC load flow equation
PLS_M(n,t,v)        load shedding

*********************************************Subproblem*********************************************

Pdem(n,t)           realization of demand (Ro)
PE(g,t)             realization of supply (Ro)
phiPG(g,t)
*phiPG_UB(g,t)       dual var phi assoziated with Equation: MP_PG (MP_PG_UB)
*phiPG_LB(g,t)       dual var phi assoziated with Equation: MP_PG (MP_PG_LB)
phiLS(n,t)
*phiLS_UB(n,t)       dual var phi assoziated with Equation: MP_LS (MP_LS_UB)  
*phiLS_LB(n,t)       dual var phi assoziated with Equation: MP_LS (MP_LS_LB)
my_UB(n,t)
my_LB(n,t)

omega_UB(l,t)       dual var phi assoziated with Equation: MP_PF_EX_Cap_UB
omega_LB(l,t)       dual var phi assoziated with Equation: MP_PF_EX_Cap_LB

beta_UB(l,t)        dual var beta assoziated with Equation: MP_PF_PROS_Cap_UB
beta_LB(l,t)        dual var beta assoziated with Equation: MP_PF_PROS_Cap_LB
beta_UB_lin(l,t)    dual var beta assoziated with Equation: MP_PF_PROS_LIN_UB
beta_LB_lin(l,t)    dual var beta assoziated with Equation: MP_PF_PROS_LIN_LB

teta_UB(n,t)        dual var beta assoziated with Equation: Theta_UB
teta_LB(n,t)        dual var beta assoziated with Equation: Theta_LB

aux_lam(n,t)        aux continuous var to linearize lam(n.t) * Pdem(n.t) in SUB Objective
aux_phi_PG(g,t)     aux continuous var to linearize phiPG(g.t) * PE(g.t) in SUB Objective
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

SUB_Lin_Dual_Send
*SUB_Lin_Dual_Res
SUB_Lin_Dual_Send_n_ref
*SUB_Lin_Dual_Res_n_ref
SUB_Dual_decision


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


;


*#####################################################################################Master####################################################################################

MP_Objective..                                                      O_M  =e= sum(l, inv_M(l)* Line_data (l,'I_costs')) + ETA
;

MP_IB..                                                             IB   =g= sum(l, inv_M(l)* Line_data (l,'I_costs'))
;

MP_marketclear(n,t,vv)$(ord(vv) lt (itaux+1))..                    Demand_data (n,'Need_LB') - PLS_M(n,t,vv)   =e= sum(g$MapG (g,n), PG_M(g,t,vv))
*Demand_data_fixed(n,t,vv)                                                         
                                                                    +  sum(l$MapRes_l(l,n), PF_M(l,t,vv))
                                                                    -  sum(l$MapSend_l(l,n), PF_M(l,t,vv))
                                                                        
                                                                    +  sum(l$Map_prosp_Res(l,n), PF_M(l,t,vv))
                                                                    -  sum(l$Map_prosp_Send(l,n), PF_M(l,t,vv))
;
MP_PG(g,t,vv)$(ord(vv) lt (itaux+1))..                              PG_M(g,t,vv) =l= Generator_data (g,'Gen_cap_UB')
* PG_M_fixed(g,t,vv)
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


MP_LS(n,t,vv)$(ord(vv) lt (itaux+1))..                              PLS_M(n,t,vv) =l= Demand_data (n,'Need_LB')
*Demand_data_fixed(n,t,vv)
;


Theta_UB(n,t,vv)$(ord(vv) lt (itaux+1))..                           3.1415          =g= Theta(n,t,vv)
;
Theta_LB(n,t,vv)$(ord(vv) lt (itaux+1))..                           - 3.1415         =l= Theta(n,t,vv)
;
Theta_ref(n,t,vv)$(ord(vv) lt (itaux+1))..                          Theta(n,t,vv)$ref(n)      =e= 0
; 


MP_ETA(vv)$(ord(vv) lt (itaux+1))..                                 ETA =e=    sum((g,t), Generator_data (g,'Gen_costs') * PG_M(g,t,vv))

                                                                    + sum((n,t), Demand_data (n,'LS_costs') * PLS_M(n,t,vv))
                                    
;
*#####################################################################################Subproblem####################################################################################

SUB_Dual_Objective..                                                O_Sub =e= sum((n,t), lam(n,t) * Demand_data (n,'Need_LB')
                                                                    + aux_lam(n,t) * (Demand_data (n,'Need_LB') + Demand_data (n,'delta_dem')))
                                                                    
                                                                    + sum((g,t), - phiPG(g,t) * Generator_data (g,'Gen_cap_UB')
                                                                    + aux_phi_PG(g,t) * (Generator_data (g,'Gen_cap_UB') - Generator_data (g,'delta_PG')))
                                                                    
                                                                    + sum((n,t), - phiLS(n,t) * Demand_data (n,'Need_LB'))
                                                                    + sum((l,t), - omega_UB(l,t) * line_data(l,'L_cap'))
                                                                    + sum((l,t), - omega_LB(l,t) * line_data(l,'L_cap'))
                                                                    + sum((n,t), - teta_UB(n,t) * 3.1415)
                                                                    + sum((n,t), - teta_LB(n,t) * 3.1415)
;
*****************************************************************Dual Power generation equation

SUB_Dual_PG(g,t)..                                                  sum(n$MapG(g,n), lam(n,t) -  phiPG(g,t)) =l=   Generator_data (g,'Gen_cap_UB')    
;
*****************************************************************Dual Load shedding equation

SUB_Dual_LS(t)..                                                    sum(n, lam(n,t) -  phiLS(n,t)) =l=   3000
;
*****************************************************************Dual Power flow equations

SUB_Dual_PF(l,t)..                                                  - sum(n$MapSend_l(l,n), lam(n,t)) + sum(n$MapRes_l(l,n), lam(n,t))
                                                                    - omega_UB(l,t)  + omega_LB(l,t) + phi(l,t)
                                                                                                                      =l= 0
;
SUB_LIN_Dual_Send(n,t)..                                            - sum(l$MapSend_l(l,n), (1/line_data(l,'react')) * phi(l,t))
                                                                    + sum(l$MapRes_l(l,n),  (1/line_data(l,'react')) * phi(l,t))
                                                                    -  teta_UB(n,t)
                                                                    +  teta_LB(n,t)                                   =e= 0
;
SUB_Lin_Dual_Send_n_ref(n,t)..                                      - sum(l$(MapSend_l(l,n) and ref(n)), (1/line_data(l,'react')) * phi(l,t))
                                                                    + sum(l$(MapRes_l(l,n) and ref(n)),  (1/line_data(l,'react')) * phi(l,t))
                                                                    +  teta_ref(n,t)                                   =e= 0

;

*****************************************************************Uncertainty Sets/ and polyhedral uncertainty budgets (level 2 problem)

SUB_US_LOAD(n,t)..                                                  Pdem(n,t)  =e= Demand_data (n,'Need_LB') + Demand_data (n,'delta_dem') * z_dem(n,t)
;
SUB_UB_LOAD..                                                       sum((n,t), z_dem(n,t))  =l= Gamma_load
;

SUB_US_PG(g,t)..                                                    PE(g,t)    =e= Generator_data (g,'Gen_ca_UB') - Generator_data (g,'delta_PG') * z_PG(g,t)
;
SUB_UB_PG..                                                         sum((g,t), z_PG(g,t))   =l= Gamma_PG
;
*****************************************************************linearization


SUB_lin1(n,t)..                                                     aux_lam(n,t)                    =l= M * z_dem(n,t)
;
SUB_lin2(n,t)..                                                     lam(n,t)  - aux_lam(n,t)        =l= M * ( 1 - z_dem(n,t))
;
SUB_lin3(g,t)..                                                     aux_phi_PG(g,t)                 =l= M * sum(n$MapG(g,n), z_PG(g,t))
;
SUB_lin4(g,t)..                                                     phiPG(g,t) - aux_phi_PG(g,t)    =l= M * sum(n$MapG(g,n), 1 - z_PG(g,t))
;
SUB_lin5(n,t)..                                                     aux_phi_LS(n,t)                 =l= M * z_dem(n,t)
;
SUB_lin6(n,t)..                                                     phiLS(n,t) - aux_phi_LS(n,t)    =l= M * ( 1 - z_dem(n,t))
;

********************************************Model definition**********************************************

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
solve Master using MIP minimizing O_M;
execute_unload "check_Master.gdx";

model Subproblem
/
SUB_Dual_Objective
SUB_Dual_PG
SUB_Dual_LS
SUB_Dual_PF

SUB_Lin_Dual_Send
SUB_Lin_Dual_Send_n_ref

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
/
;

solve Subproblem using MIP maximizing O_Sub;
execute_unload "check_SUB.gdx";
$stop
