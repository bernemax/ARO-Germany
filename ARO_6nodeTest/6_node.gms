Sets
t /t1*t24/
n /n1*n6/
g /g1*g3/
l /l1*l9/
v / v1*v5/

ex_l(l) /l1*l3/
pros_l(l)/l4*l9/
;
alias (n,nn), (v,vv)
;
******************************************************Data******************************************************
Table Generator_data (g,*)
        Gen_cap_LB  Gen_cap_UB     Gen_costs
g1         0            300           18
g2         0            250           25
g3         0            400           16
g4         0            300           32
g5         0            150           35
;
Table Demand_data (n,*)
        Need_LB     Need_UB        LS_costs
n1      180            220          3000
n2      0              0            3000
n3      0              0            3000
n4      135            165          3000
n5      90             110          3000
n6      180            220          3000
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

execute_unload "check_data.gdx";
$stop

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
teta_UB(n,t)        dual var beta assoziated with Equation: Theta_UB
teta_LB(n,t)        dual var beta assoziated with Equation: Theta_LB
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
PE(g)               realization of supply (Ro)
lam(n,t)            dual var lamda assoziated with Equation: MP_marketclear
phiPG(g,t)          dual var phi assoziated with Equation: MP_PG
phiLS(n,t)          dual var phi assoziated with Equation: MP_LS

phi(l,t)            dual var phi assoziated with Equation: MP_PF_Ex
omega_UB(l,t)       dual var phi assoziated with Equation: MP_PF_EX_Cap_UB
omega_LB(l,t)       dual var phi assoziated with Equation: MP_PF_EX_Cap_LB

beta_UB(l,t)        dual var beta assoziated with Equation: MP_PF_PROS_Cap_UB
beta_LB(l,t)        dual var beta assoziated with Equation: MP_PF_PROS_Cap_LB
beta_UB_lin(l,t)    dual var beta assoziated with Equation: MP_PF_PROS_LIN_UB
beta_LB_lin(l,t)    dual var beta assoziated with Equation: MP_PF_PROS_LIN_LB

aux_PL(l,t)         aux continuous var to linearize inv_M(l) * beta_L_prosp term    
;

Binary Variables
*********************************************Master*************************************************

inv_M(l)            decision variable regarding investment in a prospective line

*********************************************Subproblem*********************************************
*inv_SUB(l)  
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
SUB_Lin_Dual_Res
SUB_Lin_Dual_Send_n_ref
SUB_Lin_Dual_Res_n_ref
SUB_Dual_decision

SUB_US_PG
SUB_US_LOAD

*SUB_lin1
*SUB_lin2
*SUB_lin3
*SUB_lin4

;


*#####################################################################################Master####################################################################################

MP_Objective..                                                      O_M  =e= sum(l, inv_M(l)* Line_data (n,nn,'I_costs')) + ETA
;

MP_IB..                                                             IB   =g= sum(l, inv_M(l)* Line_data (n,nn,'I_costs'))
;

MP_marketclear(n,t,vv)$(ord(vv) lt (itaux+1))..                     Demand_data_fixed(n,t,vv) - PLS_M(n,t,vv)   =e= sum(g, PG_M(g,t,vv))
                                                         
                                                                    +  sum(l$MapRes_l(l,n), PL_M(l,t,vv))
                                                                    -  sum(l$MapSend_l(l,n), PL_M(l,t,vv))
                                                                        
                                                                    +  sum(l$Map_prosp_Send(l,n), PL_M(l,t,vv))
                                                                    -  sum(l$Map_prosp_Send(l,n), PL_M(l,t,vv))
;
MP_PG(g,t,vv)$(ord(vv) lt (itaux+1))..                              PG_M(g,t,vv) =l= PG_M_fixed(g,t,vv)
;


MP_PF_EX(l,t,vv)$ex_l(l)$(ord(vv) lt (itaux+1))..                   PF_M(l,t,vv) =e= 1/line_data(l,'react') * (sum(l$MapSend_l(l,n),  Theta(n,t,vv)) - sum(l$MapRes_l(l,n),  Theta(n,t,vv)))
;      
MP_PF_EX_Cap_UB(l,t,vv)$(ord(vv) lt (itaux+1))..                    PF_M(l,t,vv) =l= line_data(l,'L_cap')
;
MP_PF_EX_Cap_LB(l,t,vv)$(ord(vv) lt (itaux+1))..                    PF_M(l,t,vv) =g= - line_data(l,'L_cap')  
;


MP_PF_PROS_Cap_UB(l,t,vv)$(ord(vv) lt (itaux+1))..                  PF_M(l,t,vv) =l= line_data(l,'L_cap') * inv_M(l)
;
MP_PF_PROS_Cap_LB(l,t,vv)$(ord(vv) lt (itaux+1))..                  PF_M(l,t,vv) =g= - line_data(l,'L_cap') * inv_M(l)
;
MP_PF_PROS_LIN_UB(l,t,vv)$pros_l(l)$(ord(vv) lt (itaux+1))..        (1-inv_M(l)) *M   =e= PF_M(l,t,vv) - (1/line_data(l,'react') * (sum(l$Map_prosp_Send(l,n),  Theta(n,t,vv)) - sum(l$Map_prosp_Send(l,n),  Theta(n,t,vv))))
;
MP_PF_PROS_LIN_LB(l,t,vv)$pros_l(l)$(ord(vv) lt (itaux+1))..        -(1-inv_M(l)) *M  =e= PF_M(l,t,vv) - (1/line_data(l,'react') * (sum(l$Map_prosp_Send(l,n),  Theta(n,t,vv)) - sum(l$Map_prosp_Send(l,n),  Theta(n,t,vv))))
;


MP_LS(n,t,vv)$(ord(vv) lt (itaux+1))..                              PLS_M(n,t,vv) =l=  Demand_data_fixed(n,t,vv)
;


Theta_UB(n,t,vv)$(ord(vv) lt (itaux+1))..                           3.1415          =g= Theta(n,t,vv)
;
Theta_LB(n,t,vv)$(ord(vv) lt (itaux+1))..                           - 3.1415         =l= Theta(n,t,vv)
;
Theta_ref(n,t,vv)$(ord(vv) lt (itaux+1))..                          Theta(n,t,vv)$ref(n)      =e= 0
; 


MP_ETA(vv)$(ord(vv) lt (itaux+1))..                                 ETA =e=    sum((g,t), Generator_data (g,'Gen_costs') * PG_M(g,t,vvv))

                                                                    + sum((n,t), Demand_data (n,'LS_costs') * Load_shed(n,t,vv))
                                    
;
*#####################################################################################Subproblem####################################################################################

SUB_Dual_Objective..                                                O_Sub =e= sum((n,t), lam(n,t) * Pdem(n,t))
                                                                    + sum((g,t), - phiPG(g,t) * PE(g))
                                                                    + sum((n,t), - phiLS(n,t) * Pdem(n,t))
                                                                    + sum((l,t), - omega_UB(l,t) * line_data(l,'L_cap'))
                                                                    + sum((l,t), - omega_LB(l,t) * line_data(l,'L_cap'))
                                                                    + sum((l,t),   beta_UB_lin(l,t) * M)
                                                                    + sum((l,t), - beta_LB_lin(l,t) * M)
                                                                    + sum((n,t), - teta_UB(n,t) * 3.1415)
                                                                    + sum((n,t), - teta_LB(n,t) * 3.1415)
;
*****************************************************************Dual Power generation equation

SUB_Dual_PG(g,t)..                                                  sum(n$Map(g,n), lam(n,t) -  phiPG(g,t)) =l=   Generator_data (g,'Gen_costs')    
;
*****************************************************************Dual Load shedding equation

SUB_Dual_LS(t)..                                                    sum(n$Map(g,n), lam(n,t) -  phiLS(n,t)) =l=   3000
;
*****************************************************************Dual Power flow equations

SUB_Dual_PF(t)..                                                    sum(l, lam(n,t)  - omega_UB(l,t)  + omega_LB(l,t) + phi(l,t) - beta_UB(l,t) + beta_LB(l,t) - beta_UB_lin(l,t) + beta_LB_lin(l,t)) =l= 0
;
SUB_LIN_Dual_Send(t)..                                              sum(n$MapSend_l(l,n), - (1/line_data(l,'react')) * phi(l,t))
                                                                    + sum(l, (1/line_data(l,'react')) * beta_UB_lin(l,t))
                                                                    - sum(l, (1/line_data(l,'react')) * beta_LB_lin(l,t))
                                                                    - sum(n$MapSend_l(l,n), teta_UB(n,t) + teta_UB(n,t))                                 =l= 0
;
SUB_LIN_Dual_Res(t)..                                               sum(n$MapRes_l(l,n),(1/line_data(l,'react')) * phi(l,t)
                                                                    - sum(l, (1/line_data(l,'react')) * beta_UB_lin(l,t))
                                                                    + sum(l, (1/line_data(l,'react')) * beta_LB_lin(l,t)) 
                                                                    - sum(n$MapRes_l(l,n), teta_B(n,t) + teta_UB(n,t))                                   =l= 0       
;
SUB_Lin_Dual_Send_n_ref(t)..                                        sum(n$(MapSend_l(l,n) and ref(n)),(1/line_data(l,'react')) * phi(l,t)
                                                                    - sum(l, (1/line_data(l,'react')) * beta_UB_lin(l,t))
                                                                    + sum(l, (1/line_data(l,'react')) * beta_LB_lin(l,t)) 
                                                                    - sum(n$(MapSend_l(l,n) and ref(n)), teta_B(n,t) + teta_UB(n,t) + teta_ref(n,t))     =e= 0
;
SUB_Lin_Dual_Res_n_ref(t)..                                         sum(n$(MapRes_l(l,n) and ref(n)),(1/line_data(l,'react')) * phi(l,t)
                                                                    - sum(l, (1/line_data(l,'react')) * beta_UB_lin(l,t))
                                                                    + sum(l, (1/line_data(l,'react')) * beta_LB_lin(l,t)) 
                                                                    - sum(n$(MapRes_l(l,n) and ref(n)), teta_B(n,t) + teta_UB(n,t) + teta_ref(n,t))      =e= 0
;
SUB_Dual_decision(t)..                                              sum(l, - (1/line_data(l,'react'))* beta_UB_lin(l,t))
                                                                    + sum(l,  (1/line_data(l,'react'))* beta_LB_lin(l,t))
                                                                    - sum(l,  (1/line_data(l,'react'))* beta_UB_lin(l,t))
                                                                    - sum(l,  (1/line_data(l,'react'))* beta_LB_lin(l,t))                                =l= 0
;

*****************************************************************Uncertainty Sets/ budgets (level 2 problem)

SUB_US_PG..                                                         sum(n,Generator_data (g,'Gen_cap') - PE(g)) / sum(n,Generator_data (g,'Gen_cap')) =l= Gamma_PG
;
SUB_US_LOAD..                                                       sum(n,Pdem(n,t) - Demand_data (n,'Need_LB'))/sum(n,Demand_data (n,'Need_UB')- Demand_data(n,'Need_LB')) =l= Gamma_load
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

model Subproblem
/
SUB_Dual_Objective
SUB_Dual_PG
SUB_Dual_LS
SUB_Dual_PF

SUB_Lin_Dual_Send
SUB_Lin_Dual_Res
SUB_Lin_Dual_Send_n_ref
SUB_Lin_Dual_Res_n_ref
SUB_Dual_decision

SUB_US_PG
SUB_US_LOAD
/
;


