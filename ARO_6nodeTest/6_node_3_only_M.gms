Sets
t /t1*t24/
n /n1*n6/
g /g1*g5/
l /l1*l9/
v / v1/

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
/g1.n1,g2.n2,g3.n3,g4.n5,g5.n6/
MapSend_l(l,n)
/ l1.n1, l2.n1,l3.n4/
   
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

O_M                 Objective var of Master Problem
Theta(n,t,v)        Angle of each node associated with DC power flow equations
PF_M(l,t,v)         power flows derived from DC load flow equation
 
;
Positive Variables
*********************************************MASTER*************************************************

ETA                 aux var to reconstruct obj. function of the ARO problem
PG_M(g,t,v)         power generation level of a generator
PLS_M(n,t,v)        load shedding
;

Binary Variables
*********************************************Master*************************************************

inv_M(l)            decision variable regarding investment in a prospective line
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



;
*#####################################################################################Master####################################################################################

MP_Objective(vv)..                                                  O_M  =e= sum(l, inv_M(l)* Line_data (l,'I_costs')) + 365 *( sum((g,t), Generator_data (g,'Gen_costs') * PG_M(g,t,vv))

                                                                    + sum((n,t), Demand_data (n,'LS_costs') * PLS_M(n,t,vv)))
;

MP_IB(vv)..                                                         IB   =g= sum(l, inv_M(l)* Line_data (l,'I_costs'))
;

MP_marketclear(n,t,vv)..                                            Demand_data (n,'Need_LB') - PLS_M(n,t,vv)  =e= sum(g$MapG (g,n), PG_M(g,t,vv))
*Demand_data_fixed(n,t,vv)                                                         
                                                                    +  sum(l$(MapRes_l(l,n) and ex_l(l)), PF_M(l,t,vv))
                                                                    -  sum(l$(MapSend_l(l,n) and ex_l(l)), PF_M(l,t,vv))
                                                                        
                                                                    +  sum(l$Map_prosp_Res(l,n), PF_M(l,t,vv))
                                                                    -  sum(l$Map_prosp_Send(l,n), PF_M(l,t,vv))
;
MP_PG(g,t,vv)..                                                     PG_M(g,t,vv) =l= Generator_data (g,'Gen_cap_UB')
* PG_M_fixed(g,t,vv)
;


MP_PF_EX(l,t,vv)$ex_l(l)..                                          PF_M(l,t,vv) =e= 1/line_data(l,'react') * (sum(n$MapSend_l(l,n),  Theta(n,t,vv)) - sum(n$MapRes_l(l,n),  Theta(n,t,vv)))
;      
MP_PF_EX_Cap_UB(l,t,vv)$ex_l(l)..                                   PF_M(l,t,vv) =l= line_data(l,'L_cap')
;
MP_PF_EX_Cap_LB(l,t,vv)$ex_l(l)..                                   PF_M(l,t,vv) =g= - line_data(l,'L_cap')  
;


MP_PF_PROS_Cap_UB(l,t,vv)$pros_l(l)..                               PF_M(l,t,vv) =l= line_data(l,'L_cap') * inv_M(l)
;
MP_PF_PROS_Cap_LB(l,t,vv)$pros_l(l)..                               PF_M(l,t,vv) =g= - line_data(l,'L_cap') * inv_M(l)
;
MP_PF_PROS_LIN_UB(l,t,vv)$pros_l(l)..                               (1-inv_M(l)) *M   =g= PF_M(l,t,vv) - (1/line_data(l,'react') * (sum(n$Map_prosp_Send(l,n),  Theta(n,t,vv)) - sum(n$Map_prosp_Res(l,n),  Theta(n,t,vv))))
;
MP_PF_PROS_LIN_LB(l,t,vv)$pros_l(l)..                               -(1-inv_M(l)) *M  =l= PF_M(l,t,vv) - (1/line_data(l,'react') * (sum(n$Map_prosp_Send(l,n),  Theta(n,t,vv)) - sum(n$Map_prosp_Res(l,n),  Theta(n,t,vv))))
;


MP_LS(n,t,vv)..                                                     PLS_M(n,t,vv) =l= Demand_data (n,'Need_LB')
*Demand_data_fixed(n,t,vv)
;


Theta_UB(n,t,vv)..                                                  3.1415          =g= Theta(n,t,vv)
;
Theta_LB(n,t,vv)..                                                  - 3.1415       =l= Theta(n,t,vv)
;
Theta_ref(n,t,vv)..                                                 Theta(n,t,vv)$ref(n)      =e= 0
; 


MP_ETA(vv)..                                                        ETA =e=    sum((g,t), Generator_data (g,'Gen_costs') * PG_M(g,t,vv))

                                                                    + sum((n,t), Demand_data (n,'LS_costs') * PLS_M(n,t,vv))                                    
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

solve Master using MIP minimizing O_M;
execute_unload "check_only_Master.gdx";