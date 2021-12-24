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

 O_M
 Theta(n,t,v)
 
*********************************************Subproblem*********************************************

 O_Sub
;
Positive Variables
*********************************************MASTER*************************************************

ETA             aux var to reconstruct obj. function of the ARO problem
PG_M(g,t,v)     power generation level
PF_M(l,t,v)     power flows
PLS_M(n,t,v)    load shedding

*********************************************Subproblem*********************************************

Pdem(n,t)       realization of demand (Ro)
PE(g)           realization of supply (Ro)
lam(n,t)        dual var lamda assoziated with Equation: MP_marketclear
phiPG(g,t)      dual var phi assoziated with Equation: MP_PG
*phiPL(l,t)      dual var phi assoziated with Equation: MP_PF_Cap
phiLS(n,t)      dual var phi assoziated with Equation: MP_LS

aux_PL(l,t)     aux continuous var to linearize inv_SUB(l) * lam(n,t) term    
;

Binary Variables
*********************************************Master*************************************************  
inv_M(l)

*********************************************Subproblem*********************************************
inv_SUB(l)
;

Equations
*********************************************Master**************************************************

MP_Objective
MP_IB
MP_marketclear
MP_PG    
MP_PF_EX       
MP_PF_PROS
MP_PF_Cap   
MP_LS
Theta_UB
Theta_LB
Theta_ref     
MP_ETA

*********************************************Subproblem*********************************************

SUB_Dual_Objective
SUB_Dual_PG
SUB_Dual_LS

SUB_US_PG
SUB_US_LOAD

SUB_lin1
SUB_lin2
SUB_lin3
SUB_lin4

;


*#############################################Master#################################################

MP_Objective..                                           O_M  =e= sum(l, inv_M(l)* Line_data (n,nn,'I_costs')) + ETA
;

MP_IB..                                                  IB   =g= sum(l, inv_M(l)* Line_data (n,nn,'I_costs'))
;

MP_marketclear(n,t,vv)$(ord(vv) lt (itaux+1))..          Demand_data_fixed(n,t,vv) - PLS_M(n,t,vv)   =e= sum(g, PG_M(g,t,vv))
                                                         
                                                         +  sum(l$MapRes_l(l,n), PL_M(l,t,vv))
                                                         -  sum(l$MapSend_l(l,n), PL_M(l,t,vv))
                                                                        
                                                         +  sum(l$Map_prosp_Send(l,n), PL_M(l,t,vv))
                                                         -  sum(l$Map_prosp_Send(l,n), PL_M(l,t,vv))
;
MP_PG(g,t,vv)$(ord(vv) lt (itaux+1))..                   PG_M(g,t,vv) =l= PG_M_fixed(g,t,vv)
;
MP_PF_EX(l,t,vv)$ex_l(l)$(ord(vv) lt (itaux+1))..        PF_M(l,t,vv) =e= 1/line_data(l,'react') * (sum(l$MapSend_l(l,n),  Theta(n,t,vv)) - sum(l$MapRes_l(l,n),  Theta(n,t,vv)))
;      
MP_PF_PROS(l,t,vv)$pros_l(l)$(ord(vv) lt (itaux+1))..    PF_M(l,t,vv) =e= 1/line_data(l,'react') * (sum(l$Map_prosp_Send(l,n),  Theta(n,t,vv)) - sum(l$Map_prosp_Send(l,n),  Theta(n,t,vv)))
;
MP_PF_Cap(l,t,vv)$(ord(vv) lt (itaux+1))..               PF_M(l,t,vv) =l= line_data(l,'L_cap')
;


MP_LS(n,t,vv)$(ord(vv) lt (itaux+1))..                   PLS_M(n,t,vv) =l=  Demand_data_fixed(n,t,vv)
;


Theta_UB(n,t,vv)$(ord(vv) lt (itaux+1))..                3.1415          =g= Theta(n,t,vv)
;
Theta_LB(n,t,vv)$(ord(vv) lt (itaux+1))..                - 3.1415         =l= Theta(n,t,vv)
;
Theta_ref(n,t,vv)$(ord(vv) lt (itaux+1))..               Theta(n,t,vv)$ref(n)      =e= 0
; 


MP_ETA(vv)$(ord(vv) lt (itaux+1))..                      ETA =e=    sum((g,t), Generator_data (g,'Gen_costs') * PG_M(g,t,vvv))

                                                         + sum((n,t), Demand_data (n,'LS_costs') * Load_shed(n,t,vv))
                                    
;
*#############################################Subproblem#################################################


SUB_Dual_Objective..                                     O_Sub =e= sum((g,t), - phiPG(g,t) * PE(g)) + sum((n,t), -  phiLS(n,t) * Pdem(n,t))
;
SUB_Dual_PG(g,t)..                                       sum(n$Map(g,n), lam(n,t) -  phiPG(g,t)) =l=   Generator_data (g,'Gen_costs')    
;
SUB_Dual_LS(t)..                                         sum(n$Map(g,n), lam(n,t) -  phiLS(n,t)) =l=   3000
;
SUB_US_PG..                                              sum(n,Generator_data (g,Gen_cap) - PE(g)) / sum(n,Generator_data (g,Gen_cap)) =l= Gamma_PG
;
SUB_US_LOAD..                                            sum(n,Pdem(n,t) - Demand_data (n,Need_LB))/sum(n,Demand_data (n,Need_UB)- Demand_data (n,Need_LB)) =l)= Gamma_load
;

SUB_lin1..
;
SUB_lin2..
;
SUB_lin3..
;
SUB_lin4..
;



********************************************Model definition**********************************************

model Master
/
MP_Objective
MP_IB
MP_marketclear(n,t,v)
MP_PG(g,t,v)    
MP_PF_EX(l,t,v)       
MP_PF_PROS(l,t,v)
MP_PF_Cap(l,t,v)    
MP_LS(n,t,v)
Theta_UB
Theta_LB
Theta_ref     
MP_ETA(v)
/
;

model Subproblem
/

SUB_Dual_Objective
SUB_Dual_PG
SUB_Dual_LS
SUB_US_PG
SUB_US_LOAD
SUB_lin1
SUB_lin2
SUB_lin3
SUB_lin4
/
;


