
$ontext
CEE 6410 - Water Resources Systems Analysis
Problem 2.3 from Bishop Et Al Text (https://digitalcommons.usu.edu/ecstatic_all/76/) 

THE PROBLEM:

An irrigated farm can be planted in two crops:  hay and grain.  Data is as fol-lows:

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
SETS plnt crops growing /Hay, Grain/
     res resources /JuneWater, JulyWater, AugustWater, Land/;

* 2. DEFINE input data
PARAMETERS
   c(plnt) Objective function coefficients ($ per plant)
         /Hay 100,
         Grain 120/
   b(res) Right hand constraint values (per resource)
          /JuneWater 14000,
           JulyWater 18000,
           AugustWater 6000
           Land 10000/;

TABLE A(plnt,res) Left hand side constraint coefficients
                JuneWater   JulyWater   AugustWater Land  
 Hay            2           1           1           1
 Grain          1           2           0           1;

* 3. DEFINE the variables
VARIABLES X(plnt) plants planted (Number)
          VPROFIT  total profit ($);

* Non-negativity constraints
POSITIVE VARIABLES X;

* 4. COMBINE variables and data in equations
EQUATIONS
   PROFIT Total profit ($) and objective function value
   RES_CONSTRAIN(res) Resource Constraints;

PROFIT..                 VPROFIT =E= SUM(plnt,c(plnt)*X(plnt));
RES_CONSTRAIN(res) ..    SUM(plnt,A(plnt,res)*X(plnt)) =L= b(res);

* 5. DEFINE the MODEL from the EQUATIONS
MODEL PLANTING /PROFIT, RES_CONSTRAIN/;
*Altnerative way to write (include all previously defined equations)
*MODEL PLANTING /ALL/;

* 6. SOLVE the MODEL
* Solve the PLANTING model using a Linear Programming Solver (see File=>Options=>Solvers)
*     to maximize VPROFIT
SOLVE PLANTING USING LP MAXIMIZING VPROFIT;

* 6. CLick File menu => RUN (F9) or Solve icon and examine solution report in .LST file