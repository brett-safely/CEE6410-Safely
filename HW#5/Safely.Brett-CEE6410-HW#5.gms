*** Reservoir Mass balance for HW#5. General case and implementation in GAMS
*** Brett Safely
*** October 9, 2024
*** a02275039@usu.edu

* 1. DEFINE the SETS
SETS
   t  time periods (months) /1*6/
   res resources /Inflow, Hydropower, Irrigation, Spill, Storage/;

* 2. DEFINE input data
TABLE data(t,*)  Reservoir Data
          inflow   hydro_benefit  irr_benefit
   1         2          1.6           1.0
   2         2          1.7           1.2
   3         3          1.8           1.9
   4         4          1.9           2.0
   5         3          2.0           2.2
   6         2          2.0           2.2;

* Separate these into distinct parameters
PARAMETERS
   inflow(t)           Inflow per month
   hydro_benefit(t)    Hydropower benefit per unit ($)
   irr_benefit(t)      Irrigation benefit per unit ($);

* Assign values from the table to the parameters
inflow(t)         = data(t,'inflow');
hydro_benefit(t)  = data(t,'hydro_benefit');
irr_benefit(t)    = data(t,'irr_benefit');

SCALARS
   initial_storage /5/
   max_storage /9/
   min_FlowA /1/
   turbine_capacity /4/;

* 3. DEFINE the variables
VARIABLES
   VPROFIT  total economic benefit ($)
   hydro(t)  hydropower release (units)
   irrig(t)  irrigation release (units)
   storage(t) reservoir storage (units at the end of each period)
   spill(t) spill water (units);

POSITIVE VARIABLES
    hydro(t)
    irrig(t)
    storage(t)
    spill(t);

* 4. COMBINE variables and data in equations
EQUATIONS
   ResBalance(t) Reservoir mass balance
   FlowA(t) Minimum river flow
   HydroCapacity(t) Turbine capacity limit
   PROFIT Equation for total profit
   MaxStorage Maximum storage level in reservoir
   FinalStorage Adds constraint that end storage = initial storage;

* Objective function for total profit
PROFIT.. VPROFIT =E= SUM(t, hydro_benefit(t)*hydro(t) + irr_benefit(t)*irrig(t));

* Reservoir mass balance (Approach 1: Storage at the end of period t)
ResBalance(t).. storage(t) =E= storage(t-1)$(ord(t) gt 1) + inflow(t) - hydro(t) - irrig(t) - spill(t)
   + initial_storage$(ord(t) eq 1);

* Minimum river flow requirement
FlowA(t).. hydro(t) + spill(t) -irrig(t) =G= min_FlowA;

* Turbine capacity constraint
HydroCapacity(t).. hydro(t) =L= turbine_capacity;

* Max storage in reservoir constraint equation
MaxStorage(t).. storage(t) =L= max_storage;

* Final Storage constraint equation
FinalStorage.. storage('6') =G= initial_storage;

* 5. DEFINE the MODEL from the EQUATIONS
MODEL ReservoirOperation /PROFIT, ResBalance, FlowA, HydroCapacity, MaxStorage, FinalStorage/;

* 6. SOLVE the MODEL
SOLVE ReservoirOperation USING LP MAXIMIZING VPROFIT;

* 7. Click File menu => RUN (F9) or Solve icon and examine solution report in .LST file