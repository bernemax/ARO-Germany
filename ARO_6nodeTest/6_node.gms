Sets
t /t1*t24/
n /n1*n6/
g /g1*g3/
l /l1*l30/
v / v1*v5/

ex_l(l) /l1*l15/
pros_l(l)/l17*l30/
;
alias (n,nn), (v,vv)
;
******************************************************Data******************************************************
Table Generator_data (g,*)
        Gen_cap     Gen_costs
g1      400         15
g2      400         20
g3      600         22
;
Table Demand_data (n,*)
        Need        LS_costs
n1      80          3000
n2      240         3000
n3      40          3000
n4      160         3000
n5      240         3000
n6      0           3000
;
Table Line_data (l,*)
          react      I_costs     L_cap        
l1       0.40        40          100          
l2       0.38        38          100          
l3       0.60        60          80           
l4       0.20        20          100          
l5       0.68        68          70          
l6       0.20        20          100          
l7       0.40        40          100         
l8       0.31        31          100          
l9       0.30        30          100          
l10      0.59        59          82           
l11      0.20        20          100          
l12      0.48        48          100          
l13      0.63        63          75          
l14      0.30        30          100          
l15      0.61        61          78
l16      0.40        40          100          
l17      0.38        38          100          
l18      0.60        60          80           
l19      0.20        20          100          
l20      0.68        68          70          
l21      0.20        20          100          
l22      0.40        40          100         
l23      0.31        31          100          
l24      0.30        30          100          
l25      0.59        59          82           
l26      0.20        20          100          
l27      0.48        48          100          
l28      0.63        63          75          
l29      0.30        30          100          
l30      0.61        61          78      
;

*******************************************************Mapping**************************************************
Set

MapG (g,n)
/g1.n1,g2.n3,g3.n6/
MapSend_l(l,n)
/ l1.n1, l2.n1,l3.n1,l4.n1,
l5.n1,l6.n2,l7.n2,l8.n2,
l9.n2,l10.n3,l11.n3,l12.n3,
l13.n4,l14.n4,l15.n5/
   
MapRes_l(l,n)
/ l1	.n2,l2.n3,l3.n4,l4.n5,
l5.n6,l6.n3,l7.n4,l8.n5,
l9.n6,l10.n4,l11.n5,l12.n6,
l13.n5,l14.n6,l15.n6/

Map_prosp_Send(l,n)
/l16.n1,l17.n1,l18.n1,l19.n1,
l20.n1,l21.n2,l22.n2,l23.n2,
l24.n2,l25.n3,l26.n3,l27.n3,
l28.n4,l29.n4,l30.n5/

Map_prosp_Res(l,n)
/l16.n2,l17.n3,l18.n4,l19.n5,
l20.n6,l21.n3,l22.n4,l23.n5,
l24.n6,l25.n4,l26.n5,l27.n6,
l28.n5,l29.n6,l30.n6/

ref(n)      /n1/

;

execute_unload "check_data.gdx";
$stop

scalars
Tol         / 1 /
LB          / -1e10 /
UB          / 1e10 /
itaux       / 0 /
IB          / 1000 /
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
lam(n,t)        dual var
phiPG(g,t)      dual var
phiPL(l,t)      dual var
phiLS(n,t)      dual var
    
*z_lam(n,t)      aux continuous var to linearize z(d)*lam(n) term
*z_phiPG(g,t)    aux continuous var to linearize zg(g)*phiPG(g) term



Binary Variables
*********************************************Master*************************************************  
inv_M(l)

*********************************************Subproblem*********************************************
z(n,t)
zg(g)
;

Equations
*********************************************Master**************************************************

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

*********************************************Subproblem*********************************************







;


*#############################################Master#################################################

MP_Objective..                  O_M  =e= sum(l, inv_M(l)* Line_data (n,nn,'I_costs')) + ETA
;

MP_IB..                         IB   =g= sum(l, inv_M(l)* Line_data (n,nn,'I_costs'))
;

MP_marketclear(n,t,vv)$(ord(vv) lt (itaux+1))..         Demand_data_fixed(n,t,vv) - PLS_M(n,t,vv)   =e=  sum(g, PG_M(g,t,vv))
                                                                        +  sum(l$MapRes_l(l,n), PL_M(l,t,vv))
                                                                        -  sum(l$MapSend_l(l,n), PL_M(l,t,vv))
                                                                        
                                                                        +  sum(l$Map_prosp_Send(l,n), PL_M(l,t,vv))
                                                                        -  sum(l$Map_prosp_Send(l,n), PL_M(l,t,vv))
;
MP_PG(g,t,vv)$(ord(vv) lt (itaux+1))..                    PG_M(g,t,vv) =l= PG_M_fixed(g,t,vv)
;
MP_PF_EX(l,t,vv)$ex_l(l)$(ord(vv) lt (itaux+1))..         PF_M(l,t,vv) =e= 1/line_data(l,'react') * (sum(l$MapSend_l(l,n),  Theta(n,t,vv)) - sum(l$MapRes_l(l,n),  Theta(n,t,vv)))
;      
MP_PF_PROS(l,t,vv)$pros_l(l)$(ord(vv) lt (itaux+1))..     PF_M(l,t,vv) =e= 1/line_data(l,'react') * (sum(l$Map_prosp_Send(l,n),  Theta(n,t,vv)) - sum(l$Map_prosp_Send(l,n),  Theta(n,t,vv)))
;
MP_PF_Cap(l,t,vv)$(ord(vv) lt (itaux+1))..                PF_M(l,t,vv) =l= line_data(l,'L_cap')
;


MP_LS(n,t,vv)$(ord(vv) lt (itaux+1))..                    PLS_M(n,t,vv) =l=  Demand_data_fixed(n,t,vv)
;


Theta_UB(n,t,vv)$(ord(vv) lt (itaux+1))..                 3.1415          =g= Theta(n,t,vv)
;
Theta_LB(n,t,vv)$(ord(vv) lt (itaux+1))..                 -3.1415         =l= Theta(n,t,vv)
;
Theta_ref(n,t,vv)$(ord(vv) lt (itaux+1))..                Theta(n,t,vv)$ref(n)      =e= 0
; 


MP_ETA(vv)$(ord(vv) lt (itaux+1))..                    ETA =e=    sum((g,t), Generator_data (g,'Gen_costs') * PG_M(g,t,vvv))
                                                                + sum((n,t), Demand_data (n,'LS_costs') * Load_shed(n,t,vv))
                                    
;
*#############################################Subproblem#################################################




