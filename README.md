# Modeling of Extreme Weather Events—Towards Resilient Transmission Expansion Planning
### Maximilian Bernecker, Iegor Riepin, Felix Müsgens
We endogenously compute worst-case weather events in a transmission system expansion planning problem using the robust optimization approach.
Mathematically, we formulate a three-level mixed-integer optimization problem, which we convert to a bi-level problem viathe strong duality concept.
We solve the problem using a constraint-and-column generation algorithm. We use cardinality constrained uncertainty sets to model the effects of extreme
weather realizations on supply from renewable generators.
### Keywords: 
Adaptive Robust Optimization, Transmission Expansion Planning, Economic modeling

## Case-Study: Germany and border countries
- Investigation of the impact of weather-related periods of low wind and solar availability - low renewable energy supply capability. 
- Simulated event: Anticyclonic gloom aka "Dunkelflaute"
- Endogenious determination of worst case realization on a time and regional dimension

## Modeled system - 109 nodes & 242 lines
- SCIGRID system clustered to 100 node-Germany, added by single nodal neighboring country representation 
- DC OPF - High voltage grid
- blue lines are expandable corridors

![](https://github.com/bernemax/ARO-Dunkelflaute/blob/main/Pictures%20and%20Results/Clustered%20Germany%20v2.png)

# Results
- Endogenious defined realization of worst-case Dunkelflaute in each country
- Results from runs with different uncertainty Budget A=20, B=50, C=80
- Each unit of uncertainty budget represents one predefined day of "Dunkelflaute" in the respective country
- Color coded map of affected countries
- Maximum number of "Dunkelflaute"-days per country: 10
![](https://github.com/bernemax/ARO-Dunkelflaute/blob/main/Pictures%20and%20Results/Results%20cluster.png)

## Investments in respective cross-border transmission corridors [MM] per Scenario
![](https://github.com/bernemax/ARO-Dunkelflaute/blob/main/Pictures%20and%20Results/Results%20corridors.png)
