$ontext
CEE 6410 - Water Resources Systems Analysis
Problem 7.1 from Bishop Et Al Text (https://digitalcommons.usu.edu/ecstatic_all/76/)

THE SOLUTION:
Uses General Algebraic Modeling System to Solve this Linear Program

Brett Safely, A02275039 a02275039@usu.edu
$offtext

SETS
    src  water supply sources /hd "high dam", ld "low dam", pump "pump"/
    t    seasons /1, 2/;

PARAMETERS
    CapCost(src) capital cost ($ per year)
        /hd 10000, ld 6000, pump 8000/
    OpCost(src) operating cost ($ per ac-ft)
        /hd 0, ld 0, pump 20/
    MaxCapacity(src) maximum capacity of source (ac-ft per year)
        /hd 700, ld 300, pump 803/
    MinUse(src) minimum required use of source (ac-ft per year)
        /hd 0, ld 0, pump 0/
    RiverInflow(t) river inflow (ac-ft)
        /1 600, 2 200/
    IrrigationDemand(t) irrigation demand (ac-ft per year)
        /1 1.0, 2 3.0/
    RevenuePerAcre  revenue per acre irrigated ($ per year) /300/;

VARIABLES
    I(src) binary decision to build source (1=yes and 0=no)
    X(src,t) volume of water provided by source (ac-ft per year)
    TCOST  total capital and operating costs of supply actions ($)
    RevenueGenerated total revenue generated ($)
    AcresIrrigated(t) acres irrigated in season t;

BINARY VARIABLES I;
POSITIVE VARIABLES X, AcresIrrigated;

EQUATIONS
    COST            total cost ($) and objective function value
    MaxCap(src,t)   maximum capacity of source when built (ac-ft per year)
    MinReqUse(src,t) minimum required use of source when built (ac-ft per year)
    MeetDemand(t)   meet irrigation demand (ac-ft per year)
    RevenueEq       calculate total revenue generated ($)
    IrrigatedAcresEq(t) acres irrigated based on water use;

COST..  
    TCOST =E= SUM(src, CapCost(src) * I(src) + SUM(t, OpCost(src) * X(src,t)));

MaxCap(src,t) ..   
    X(src,t) =L= MaxCapacity(src) * I(src);

MinReqUse(src,t) ..  
    X(src,t) =G= MinUse(src) * I(src);

MeetDemand(t) ..   
    SUM(src, X(src,t)) =G= IrrigationDemand(t);

RevenueEq..  
    RevenueGenerated =E= SUM(t, AcresIrrigated(t) * RevenuePerAcre);

IrrigatedAcresEq(t) ..
    AcresIrrigated(t) =E= SUM(src, X(src,t)) / IrrigationDemand(t);

MODEL IrrigationModel /ALL/;

SOLVE IrrigationModel USING MIP MINIMIZING TCOST;

DISPLAY X.L, I.L, TCOST.L, RevenueGenerated.L, AcresIrrigated.L;
