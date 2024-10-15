$ontext
CEE 6410 - Water Resources Systems Analysis
Problem 2.3 from Bishop Et Al Text (https://digitalcommons.usu.edu/ecstatic_all/76/)

THE PROBLEM:

An irrigated farm can be planted in two crops: hay and grain. Data is as follows:

Seasonal Resource
Inputs or Profit        Crops        Resource
Availability
                Hay     Grain
June Water      2       1
July Water      1       2
August Water    1       0

                Determine the optimal planting for the two crops.

THE SOLUTION:
Uses General Algebraic Modeling System to Solve this Linear Program

Brett Safely, A02275039. a02275039@usu.edu
$offtext

* 1. DEFINE the SETS
SETS res resources /JuneWater, JulyWater, AugustWater, Land/
     plnt crops growing /Hay, Grain/;

* 2. DEFINE input data
PARAMETERS
   b(res) Right hand constraint values (per resource)
          /JuneWater 14000,
           JulyWater 18000,
           AugustWater 6000,
           Land 10000/
   c(plnt) Objective function coefficients ($ per plant)
         /Hay 100,
          Grain 120/;

TABLE A(plnt,res) Left hand side constraint coefficients
                JuneWater   JulyWater   AugustWater Land  
 Hay            2           1           1           1
 Grain          1           2           0           1;

* 3. DEFINE the variables
VARIABLES Y(res) shadow prices of resources ($ per unit)
          VCOST  total cost of resources ($);

* Non-negativity constraints
POSITIVE VARIABLES Y;

* 4. COMBINE variables and data in equations
EQUATIONS
   COST Total cost ($) and objective function value
   PROFIT_CONSTRAIN(plnt) Profit Constraints;

COST..                   VCOST =E= SUM(res,b(res)*Y(res));
PROFIT_CONSTRAIN(plnt).. SUM(res,A(plnt,res)*Y(res)) =G= c(plnt);

* 5. DEFINE the MODEL from the EQUATIONS
MODEL DUAL_PLANTING /COST, PROFIT_CONSTRAIN/;

* 6. SOLVE the MODEL
* Solve the DUAL_PLANTING model using a Linear Programming Solver (see File=>Options=>Solvers)
*     to minimize VCOST
SOLVE DUAL_PLANTING USING LP MINIMIZING VCOST;

* 6. Click File menu => RUN (F9) or Solve icon and examine solution report in .LST file
