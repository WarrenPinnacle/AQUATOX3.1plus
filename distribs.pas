//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
//


{This file is used if an additional distribution is desired added to
 AQUATOX.  The user must take four steps:

 1.) increment the Const Num_Of_Reg_Distributions, in GLOBAL.PAS
     update the locational constants (ConstLoad_RegDist_Index=64) if necessary
 2.) Add to the Case statement in the function Return_Registered_Dist,
 3.) Add to the Case statement in the function Return_Var_Pointer }

{-----------------------------------------------------------------------}

Function TStates.Return_Registered_Dist(Index: Integer): Registered_Distribution;
Var RD: Registered_Distribution;
Begin
  RD.RDIndex:=Index;
  With RD do Case Index of
    1: begin
         RDType := AllOrgToxs;
         RDName := ': Molecular Weight';
       end;
    2: begin
         RDType := AllOrgToxs;
         RDName := ': Dissasociation Constant (pKa)';
       end;
    3: begin
         RDType := AllOrgToxs;
         RDName := ': Solubility (ppm)';
       end;
    4: begin
         RDType := AllOrgToxs;
         RDName := ': Henry''s Law Const. (atm. m^3/mol)';
       end;
    5: begin
         RDType := AllOrgToxs;
         RDName := ': Vapor Pressure (mm Hg)';
       end;
    6: begin
         RDType := AllOrgToxs;
         RDName := ': Octanol-Water Partition Coeff (Log Kow)';
       end;
    7: begin
         RDType := AllOrgToxs;
         RDName := ': Sed/Detr-Water Partition Coeff (mg/L)';
       end;
    8: begin
         RDType := AllOrgToxs;
         RDName := ': Activation Energy for Temp (cal/mol)';
       end;
    9: begin
         RDType := AllOrgToxs;
         RDName := ': Anaerobic Microbial Degrdn. (L/d)';
       end;
    10: begin
         RDType := AllOrgToxs;
         RDName := ': Aerobic Microbial Degrdn. (L/d)';
       end;
    11: begin
         RDType := AllOrgToxs;
         RDName := ': Uncatalyzed Hydrolysis (L/d)';
       end;
    12: begin
         RDType := AllOrgToxs;
         RDName := ': Acid Catalyzed Hydrolysis (L/d)';
       end;
    13: begin
         RDType := AllOrgToxs;
         RDName := ': Base Catalyzed Hydrolysis (L/d)';
       end;
    14: begin
         RDType := AllOrgToxs;
         RDName := ': Photolysis Rate (L/d)';
       end;
    15: begin
         RDType := AllOrgToxs;
         RDName := ': Oxidation Rate Const (L/mol day)';
       end;
    16: begin
         RDType := AllOrgToxs;
         RDName := ': Weibull Shape Parameter';
       end;
    {ORGTOX PARAMS ABOVE}
    17: begin
         RDType := AnimalTox;
         RDName := ' LC50 (ug/L)';
       end;
    18: begin
         RDType := AnimalTox;
         RDName := ' Elim. Rate Constant (1/d)';
       end;
    19: begin
         RDType := AnimalTox;
         RDName := ' Biotransformation Rate (1/d)';
        end;
    20: begin
        RDType := AnimalTox;
        RDName := ' EC50 Growth (ug/L)';
      end;
    21: begin
        RDType := AnimalTox;
        RDName := ' EC50 Repro (ug/L)';
      end;
    22: begin
        RDType := AnimalTox;
        RDName := ' Drift Threshold (ug/L)';
      end;
    23: begin
        RDType := PlantTox;
         RDName := ' EC50 photo (ug/L)';
       end;
    24: begin
         RDType := PlantTox;
         RDName := ' LC50 (ug/L)';
       end;
    25: begin
         RDType := PlantTox;
         RDName := ' Elim. Rate Constant (1/d)';
       end;
    26: begin
         RDType := PlantTox;
         RDName := ' Biotransformation Rate (1/d)';
        end;


    56: begin
         RDType := AllPlants;
         RDName := ': Saturating Light (Ly/d)';
       end;
    57: begin
         RDType := AllPlants;
         RDName := ': P Half-saturation (mg/L)';
       end;
    58: begin
         RDType := AllPlants;
         RDName := ': N Half-saturation (mg/L)';
       end;
    59: begin
         RDType := AllPlants;
         RDName := ': Inorg. C Half-saturation (mg/L)';
       end;
    60: begin
         RDType := AllPlants;
         RDName := ': Temp Response Slope';
       end;
    61: begin
         RDType := AllPlants;
         RDName := ': Optimal Temperature (deg. C)';
       end;
    62: begin
         RDType := AllPlants;
         RDName := ': Maximum Temperature (deg. C)';
       end;
    63: begin
         RDType := AllPlants;
         RDName := ': Min Adaptation Temperature (deg. C)';
       end;
    64: begin
         RDType := AllPlants;
         RDName := ': Max Photosynthetic Rate (1/d)';
       end;
    65: begin
         RDType := AllPlants;
         RDName := ': Photorespiration Coefficient (1/d)';
       end;
    66: begin
         RDType := AllPlants;
         RDName := ': Mortality Coefficient: (frac / d)';
       end;
    67: begin
         RDType := AllPlants;
         RDName := ': Exponential Mort. Coefficient: (max / d)';
       end;
    68: begin
         RDType := AllPlants;
         RDName := ': P:Organics (ratio)';
       end;
    69: begin
         RDType := AllPlants;
         RDName := ': N:Organics (ratio)';
       end;
    70: begin
         RDType := AllPlants;
         RDName := ': Light Extinction (1/m)';
       end;
    71: Begin
         RDType := SingleVarDist;
         RDName := 'Remin: Max Refr Degrad. Rate: (g / g d)';
        End;
    72: begin
         RDType := AllPhyto;
         RDName := ': Sedimentation Rate (1/d)';
       end;
    73: begin
         RDType := AllPhyto;
         RDName := ': Exp Sedimentation Coeff';
       end;
    74: begin
         RDType := AllPeriMacro;
         RDName := ': Carrying Capacity (g/m2)';
       end;
    75: begin
         RDType := AllPeriMacro;
         RDName := ': Red in Still Water (frac)';
       end;
    76: begin
         RDType := AllPeriMacro;
         RDName := ': VelMax Macrophytes (cm/s)';
       end;
    77: begin
         RDType := AllPeriMacro;
         RDName := ': FCrit, periphyton (newtons)';
       end;
    78: begin
         RDType := AllPlants;
         RDName := ': Pct in Riffle (if stream %)';
       end;
    79: begin
         RDType := AllPlants;
         RDName := ': Pct in Pool (if stream %)';
       end;

    80: begin
         RDType := AllAnimals;
         RDName := ': Half Sat Feeding (mg/L)';
       end;
    81: begin
         RDType := AllAnimals;
         RDName := ': Max Consumption (g / g day)';
       end;
    82: begin
         RDType := AllAnimals;
         RDName := ': Min Prey for Feeding';
       end;
    83: begin
         RDType := AllAnimals;
         RDName := ': Temperature Response Slope';
       end;

    84: begin
         RDType := AllAnimals;
         RDName := ': Optimal Temperature (deg. C)';
       end;
    85: begin
         RDType := AllAnimals;
         RDName := ': Maximum Temperature (deg. C)';
       end;
    86: begin
         RDType := AllAnimals;
         RDName := ': Min Adaptation Temperature (deg. C)';
       end;
    87: begin
         RDType := AllAnimals;
         RDName := ': Respiration Rate: (1 / d)';
       end;
    88: begin
        RDType := AllAnimals;
         RDName := ': Specific Dynamic Action';
       end;
    89: begin
         RDType := AllAnimals;
         RDName := ': Excretion:Respiration (ratio)';
       end;
    90: begin
         RDType := AllAnimals;
         RDName := ': Gametes:Biomass (ratio)';
       end;
    91: begin
         RDType := AllAnimals;
         RDName := ': Gametes Mortality (1/d)';
       end;
    92: begin
         RDType := AllAnimals;
         RDName := ': Mortality Coeff (1/d)';
       end;
    93: begin
         RDType := AllAnimals;
         RDName := ': Carrying Capacity (g/sq.m)';
       end;
    94: begin
         RDType := AllAnimals;
         RDName := ': Average Drift (frac/day)';
       end;
    95: begin
         RDType := AllAnimals;
         RDName := ': VelMax (cm/s)';
       end;
    96: begin
         RDType := AllAnimals;
         RDName := ': Mean Lifespan (days)';
       end;
    97: begin
         RDType := AllAnimals;
         RDName := ': Initial Fraction Lipid (wet wt.)';
       end;
    98: begin
         RDType := AllAnimals;
         RDName := ': Mean Weight (g)';
       end;

    99: begin
         RDType := AllAnimals;
         RDName := ': Pct in Riffle (if stream %)';
       end;
    100: begin
         RDType := AllAnimals;
         RDName := ': Pct in Pool (if stream %)';
       end;

    101: begin
         RDType := AllFish;
         RDName := ': (Allometric) CA';
       end;
    102: begin
         RDType := AllFish;
         RDName := ': (Allometric) CB';
       end;
    103: begin
         RDType := AllFish;
         RDName := ': (Allometric) RA';
       end;
    104: begin
         RDType := AllFish;
         RDName := ': (Allometric) RB';
       end;
    105: begin
         RDType := AllFish;
         RDName := ': (Allometric) ACT';
       end;

    106: begin
         RDType := SingleVarDist;
         RDName := 'Remin: Max Labile Degrad. Rate: (g / g d)';
       end;
    107: begin
         RDType := SingleVarDist;
         RDName := 'Site: Max Length (km)';
       end;

    108: begin
         RDType := SingleVarDist;
         RDName := 'Site: Mean Depth (m)';
       end;
    109: begin
         RDType := SingleVarDist;
         RDName := 'Site: Max Depth (m)';
       end;

    110: begin
         RDType := SingleVarDist;
         RDName := 'Site: Ave. Epilimnetic Temperature (deg C)';
       end;
    111: begin
         RDType := SingleVarDist;
         RDName := 'Site: Epi Temp. Range (deg C)';
       end;
    112: begin
         RDType := SingleVarDist;
         RDName := 'Site: Ave. Hypolimnetic Temperature (deg C)';
       end;
    113: begin
         RDType := SingleVarDist;
         RDName := 'Site: Hyp Temp. Range (deg C)';
       end;

    114: begin
         RDType := SingleVarDist;
         RDName := 'Site: Average Light (Ly/d)';
       end;
    115: begin
         RDType := SingleVarDist;
         RDName := 'Site: Average Light Range (Ly/d)';
       end;
    116: begin
         RDType := SingleVarDist;
         RDName := 'Site: Mean Evap (in./yr)';
       end;
    117: begin
         RDType := SingleVarDist;
         RDName := 'Site: Exctinction Coeff Water (1/m)';
       end;
    118: begin
         RDType := SingleVarDist;
         RDName := 'Stream Only: Slope (m/m)';
       end;
    119: begin
         RDType := SingleVarDist;
         RDName := 'Stream Only: Manning''s Coeff (s/m^1/3)';
       end;
    120: begin
         RDType := SingleVarDist;
         RDName := 'Stream Only: Percent Riffle (Pct.)';
       end;
    121: begin
         RDType := SingleVarDist;
         RDName := 'Stream Only: Percent Pool (Pct.)';
       end;

    122: begin
         RDType := AllStateVars;
         RDName := ': Initial Condition ';
       end;

    123: begin
         RDType := AllStateVars;
         RDName := ': Const Load ';
       end;
    124: begin
         RDType := AllStateVars;
         RDName := ': Multiply Loading by';
       end;

    125: begin
         RDType := SingleVarDist;
         RDName := 'Hypolimn Temp: Multiply Loading by';
       end;
    126: begin
         RDType := AllStateVars;
         RDName := ': Mult. Direct Precip. Load by';
       end;
    127: begin
         RDType := AllStateVars;
         RDName := ': Mult. Point Source Load by';
       end;
    128: begin
         RDType := AllStateVars;
         RDName := ': Mult. Non-Point Source Load by';
       end;

    129: begin
           RDType := SingleVarDist;
           RDName := 'Clay: critical shear stress for scour (kg/m2)';
         end;
    130: begin
           RDType := SingleVarDist;
           RDName := 'Clay: crit. shear stress deposition (kg/m2)';
         end;
    131: begin
           RDType := SingleVarDist;
           RDName := 'Clay: fall velocity (m/s)';
         end;
    132: begin
           RDType := SingleVarDist;
           RDName := 'Silt: critical shear stress for scour (kg/m2)';
         end;
    133: begin
           RDType := SingleVarDist;
           RDName := 'Silt: crit. shear stress deposition (kg/m2)';
         end;
    134: begin
           RDType := SingleVarDist;
           RDName := 'Silt: fall velocity (m/s)';
         end;
    135: begin
        RDType := AnimalTox;
        RDName := ' EC50 Dislodge (ug/L)';
      end;
    136: begin
         RDType := SingleVarDist;
         RDName := 'Site: Total Length for Phytoplankton (km)';
       end;
    137: begin
         RDType := SingleVarDist;
         RDName := 'Site: Extinction Coeff Sediment (1/m)';
       end;
    138: begin
         RDType := SingleVarDist;
         RDName := 'Site: Extinction Coeff DOM (1/m)';
       end;
    139: begin
         RDType := SingleVarDist;
         RDName := 'Site: Extinction Coeff POM (1/m)';
       end;

    140: begin
         RDType := AllAnimals;
         RDName :=' Frac. in Water Col. (unitless)';
       end;
    141: begin
         RDType := AllAnimals;
         RDName :=' Min. Salinity Tolerance, Ingestion (0/00) ';
       end;
    142: begin
         RDType := AllAnimals;
         RDName :=' Max. Salinity Tolerance, Ingestion (0/00) ';
       end;
    143: begin
         RDType := AllAnimals;
         RDName :=' Salinity Coeff1, Ingestion (unitless) ';
       end;
    144: begin
         RDType := AllAnimals;
         RDName :=' Salinity Coeff2, Ingestion (unitless) ';
       end;
    145: begin
         RDType := AllAnimals;
         RDName :=' Min. Salinity Tolerance, Gameteloss (0/00) ';
       end;
    146: begin
         RDType := AllAnimals;
         RDName :=' Max. Salinity Tolerance, Gameteloss (0/00) ';
       end;
    147: begin
         RDType := AllAnimals;
         RDName :=' Salinity Coeff1, Gameteloss (unitless) ';
       end;
    148: begin
         RDType := AllAnimals;
         RDName :=' Salinity Coeff2, Gameteloss (unitless) ';
       end;
    149: begin
         RDType := AllAnimals;
         RDName :=' Min. Salinity Tolerance, Respiration (0/00) ';
       end;
    150: begin
         RDType := AllAnimals;
         RDName :=' Max. Salinity Tolerance, Respiration (0/00) ';
       end;
    151: begin
         RDType := AllAnimals;
         RDName :=' Salinity Coeff1, Respiration (unitless) ';
       end;
    152: begin
         RDType := AllAnimals;
         RDName :=' Salinity Coeff2, Respiration (unitless) ';
       end;
    153: begin
         RDType := AllAnimals;
         RDName :=' Min. Salinity Tolerance, Mortality (0/00) ';
       end;
    154: begin
         RDType := AllAnimals;
         RDName :=' Max. Salinity Tolerance, Mortality (0/00) ';
       end;
    155: begin
         RDType := AllAnimals;
         RDName :=' Salinity Coeff1, Mortality (unitless) ';
       end;
    156: begin
         RDType := AllAnimals;
         RDName :=' Salinity Coeff2, Mortality (unitless) ';
       end;
    157: begin
         RDType := AllAnimals;
         RDName :=' Fishing Fraction (frac/d)';
       end;
    158: begin
         RDType := AllAnimals;
         RDName :=' P to Organics (frac dry)';
       end;
    159: begin
         RDType := AllAnimals;
         RDName :=' N to Organics (frac dry)';
       end;
    160: begin
         RDType := AllAnimals;
         RDName :=' Wet to Dry (ratio)';
       end;
    161: begin
         RDType := AllAnimals;
         RDName :=' Oxygen Lethal Conc (mg/L 24 hr)';
       end;
    162: begin
         RDType := AllAnimals;
         RDName :=' Oxygen Pct. Killed (Percent, 1-99)';
       end;
    163: begin
         RDType := AllAnimals;
         RDName :=' Oxygen EC50 Growth (mg/L 24 hr)';
       end;
    164: begin
         RDType := AllAnimals;
         RDName :=' Oxygen EC50 Repro (mg/L 24 hr)';
       end;
    165: begin
         RDType := AllAnimals;
         RDName :=' Ammonia LC50 (mg/L)';
       end;
    166: begin
         RDType := AllAnimals;
         RDName :=' Sorting, selective feeding (unitless)';
       end;
    167: begin
         RDType := AllAnimals;
         RDName :=' Slope for Sed Response (unitless)';
       end;
    168: begin
         RDType := AllAnimals;
         RDName :=' Intercept for Sed Response (unitless)';
       end;
    169: begin
         RDType := AllAnimals;
         RDName :=' Trigger (dep. rate accel. drift in g/sq.m)';
       end;


    170: begin
         RDType := AllPhyto;
         RDName :=' KSed Temp. (Estuary Only, deg C.)';
       end;
    171: begin
         RDType := AllPhyto;
         RDName :=' KSed Salinity (Estuary Only, o/oo)';
       end;
    172: begin
         RDType := AllPlants;
         RDName :=' Min. Salinity Tolerance, Photo. (0/00) ';
       end;
    173: begin
         RDType := AllPlants;
         RDName :=' Max. Salinity Tolerance, Photo. (0/00) ';
       end;
    174: begin
         RDType := AllPlants;
         RDName :=' Salinity Coeff1, Photo. (unitless) ';
       end;
    175: begin
         RDType := AllPlants;
         RDName :=' Salinity Coeff2, Photo. (unitless) ';
       end;
    176: begin
         RDType := AllPlants;
         RDName :=' Min. Salinity Tolerance, Mortality (0/00) ';
       end;
    177: begin
         RDType := AllPlants;
         RDName :=' Max. Salinity Tolerance, Mortality (0/00) ';
       end;
    178: begin
         RDType := AllPlants;
         RDName :=' Salinity Coeff1, Mortality (unitless) ';
       end;
    179: begin
         RDType := AllPlants;
         RDName :=' Salinity Coeff2, Mortality (unitless) ';
       end;
    180: begin
         RDType := AllPlants;
         RDName :=' Wet to Dry (ratio)';
       end;
    181: begin
         RDType := AllPlants;
         RDName :=' Resp. Rate, 20 deg C (g/g d)';
       end;
    182: begin
         RDType := AllPeriMacro;
         RDName :=' Pct. Lost Slough Event (percent) ';
       end;
    183: begin
         RDType := AllPlants;
         RDName :=' Max. Sat. Light (Ly/d)';
       end;
    184: begin
         RDType := AllPlants;
         RDName :=' Min. Sat. Light (Ly/d)';
       end;

    185: begin
           RDType := SingleVarDist;
           RDName := 'Site: User Entered KReaer (1/d)';
         end;

    186: Begin
         RDType := SingleVarDist;
         RDName := 'Remin: Optimum Temperature (deg.C)';
        End;
    187: Begin
         RDType := SingleVarDist;
         RDName := 'Remin: Maximum Temperature (deg.C)';
        End;

    188: Begin
         RDType := SingleVarDist;
         RDName := 'Remin: Min. pH for degradation';
        End;
    189: Begin
         RDType := SingleVarDist;
         RDName := 'Remin: Max. pH for degradation';
        End;
    190: Begin
         RDType := SingleVarDist;
         RDName := 'Remin: P to Organics, Labile (frac. dry)';
        End;
    191: Begin
         RDType := SingleVarDist;
         RDName := 'Remin: N to Organics, Labile (frac. dry)';
        End;
    192: Begin
         RDType := SingleVarDist;
         RDName := 'Remin: O2:Biomass, Resp. (ratio)';
        End;
    193: Begin
         RDType := SingleVarDist;
         RDName := 'Remin: O2:N, Nitrification (ratio)';
        End;
    194: Begin
         RDType := SingleVarDist;
         RDName := 'Remin: Detrital Sed. Rate (KSed g/m d)';
        End;

    195: Begin
         RDType := SingleVarDist;
         RDName := 'Remin: Temp. of Obs. KSed (deg.C)';
        End;
    196: Begin
         RDType := SingleVarDist;
         RDName := 'Remin: Salinity of Obs. KSed (o/oo)';
        End;
    197: Begin
         RDType := SingleVarDist;
         RDName := 'Remin: P to Organics, Refr. (frac. dry)';
        End;
    198: Begin
         RDType := SingleVarDist;
         RDName := 'Remin: N to Organics, Refr. (frac. dry)';
        End;
    199: Begin
         RDType := SingleVarDist;
         RDName := 'Remin: Wet to Dry, Susp. Labile (ratio)';
        End;
    200: Begin
         RDType := SingleVarDist;
         RDName := 'Remin: Wet to Dry, Susp. Refr. (ratio)';
        End;
    201: Begin
         RDType := SingleVarDist;
         RDName := 'Remin: Wet to Dry, Sed. Labile (ratio)';
        End;
    202: Begin
         RDType := SingleVarDist;
         RDName := 'Remin: Wet to Dry, Sed. Refr. (ratio)';
        End;
    203: Begin
         RDType := SingleVarDist;
         RDName := 'Remin: N to Organics, Diss. Labile (frac.dry)';
        End;
    204: Begin
         RDType := SingleVarDist;
         RDName := 'Remin: P to Organics, Diss. Labile (frac.dry)';
        End;
    205: Begin
         RDType := SingleVarDist;
         RDName := 'Remin: N to Organics, Diss. Refr. (frac.dry)';
        End;
    206: Begin
         RDType := SingleVarDist;
         RDName := 'Remin: P to Organics, Diss. Refr. (frac.dry)';
        End;
    207: Begin
         RDType := SingleVarDist;
         RDName := 'Remin: KD, P to CaCO3 (L/kg)';
        End;
    208: Begin
         RDType := SingleVarDist;
         RDName := 'Susp&Diss Detr: Pct. Partic. Loads, Const.';
        End;
    209: Begin
         RDType := SingleVarDist;
         RDName := 'Susp&Diss Detr: Pct. Refr. Loads, Const.';
        End;
    210: Begin
         RDType := SingleVarDist;
         RDName := 'Susp&Diss Detr: Pct. Particulate, Init. Cond';
        End;
    211: Begin
         RDType := SingleVarDist;
         RDName := 'Susp&Diss Detr: Pct. Refractory, Init. Cond';
        End;
    212: Begin
           RDType := SingleVarDist;
           RDName := 'Site: Baseline Pct. Embeddedness';
         End;
    213: Begin
           RDType := AllAnimals;
           RDName := ' Pct. Embedded Threshold';
         End;
    214: Begin
           RDType := SingleVarDist;
           RDName := 'Remin: CBODu to BOD5 Conv. Factor';
         End;
    215: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.m1 do
             RDName :='Diagenesis: '+symbol+' ('+units+')';
         End;
    216: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.m2 do
             RDName :='Diagenesis: '+symbol+' ('+units+')';
         End;
    217: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.H1 do
             RDName :='Diagenesis: '+symbol+' ('+units+')';
         End;
    218: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.Dd do
             RDName :='Diagenesis: '+symbol+' ('+units+')';
         End;
    219: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.w2 do
             RDName :='Diagenesis: '+symbol+' ('+units+')';
         End;
    220: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.H2 do
             RDName :='Diagenesis: '+symbol+' ('+units+')';
         End;
    221: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.KappaNH3f do
             RDName :='Diagenesis: '+symbol+' ('+units+')';
         End;
    222: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.KappaNH3s do
             RDName :='Diagenesis: '+symbol+' ('+units+')';
         End;
    223: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.KappaNO3_1f do
             RDName :='Diagenesis: '+symbol+' ('+units+')';
         End;
    224: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.KappaNO3_1s do
             RDName :='Diagenesis: '+symbol+' ('+units+')';
         End;
    225: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.KappaNO3_2 do
             RDName :='Diagenesis: '+symbol+' ('+units+')';
         End;
    226: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.KappaCH4 do
             RDName :='Diagenesis: '+symbol+' ('+units+')';
         End;
    227: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.KM_NH3 do
             RDName :='Diagenesis: '+symbol+' ('+units+')';
         End;
    228: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.KM_O2_NH3 do
             RDName :='Diagenesis: '+symbol+' ('+units+')';
         End;
    229: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.KdNH3 do
             RDName :='Diagenesis: '+symbol+' ('+units+')';
         End;
    230: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.KdPO42 do
             RDName :='Diagenesis: '+symbol+' ('+units+')';
         End;
    231: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.dKDPO41f do
             RDName :='Diagenesis: '+symbol+' ('+units+')';
         End;
    232: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.dKDPO41s do
             RDName :='Diagenesis: '+symbol+' ('+units+')';
         End;
    233: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.O2critPO4 do
             RDName :='Diagenesis: '+symbol+' ('+units+')';
         End;
    234: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.ThtaDd do
             RDName :='Diagenesis: '+name;
         End;
    235: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.ThtaNH3 do
             RDName :='Diagenesis: '+name;
         End;
    236: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.ThtaNO3 do
             RDName :='Diagenesis: '+name;
         End;
    237: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.ThtaCH4 do
             RDName :='Diagenesis: '+name;
         End;
    238: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.SALTSW do
             RDName :='Diagenesis: '+symbol+' ('+units+')';
         End;
    239: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.SALTND do
             RDName :='Diagenesis: '+symbol+' ('+units+')';
         End;
    240: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.KappaH2Sd1 do
             RDName :='Diagenesis: '+symbol+' ('+units+')';
         End;
    241: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.KappaH2Sp1 do
             RDName :='Diagenesis: '+symbol+' ('+units+')';
         End;
    242: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.ThtaH2S do
             RDName :='Diagenesis: '+name;
         End;
    243: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.KMHSO2 do
             RDName :='Diagenesis: '+symbol+' ('+units+')';
         End;
    244: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.KdH2S1 do
             RDName :='Diagenesis: '+symbol+' ('+units+')';
         End;
    245: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.KdH2S2 do
             RDName :='Diagenesis: '+symbol+' ('+units+')';
         End;
    246: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.kpon1 do
             RDName :='Diagenesis: '+symbol+' ('+units+')';
         End;
    247: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.kpon2 do
             RDName :='Diagenesis: '+symbol+' ('+units+')';
         End;
    248: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.kpon3 do
             RDName :='Diagenesis: '+symbol+' ('+units+')';
         End;
    249: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.kpoc1 do
             RDName :='Diagenesis: '+symbol+' ('+units+')';
         End;
    250: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.kpoc2 do
             RDName :='Diagenesis: '+symbol+' ('+units+')';
         End;
    251: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.kpoc3 do
             RDName :='Diagenesis: '+symbol+' ('+units+')';
         End;
    252: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.kpop1 do
             RDName :='Diagenesis: '+symbol+' ('+units+')';
         End;
    253: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.kpop2 do
             RDName :='Diagenesis: '+symbol+' ('+units+')';
         End;
    254: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.kpop3 do
             RDName :='Diagenesis: '+symbol+' ('+units+')';
         End;
    255: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.ThtaPON1 do
             RDName :='Diagenesis: '+name;
         End;
    256: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.ThtaPON2 do
             RDName :='Diagenesis: '+name;
         End;
    257: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.ThtaPON3 do
             RDName :='Diagenesis: '+name;
         End;
    258: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.ThtaPOC1 do
             RDName :='Diagenesis: '+name;
         End;
    259: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.ThtaPOC2 do
             RDName :='Diagenesis: '+name;
         End;
    260: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.ThtaPOC3 do
             RDName :='Diagenesis: '+name;
         End;
    261: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.ThtaPOP1 do
             RDName :='Diagenesis: '+name;
         End;
    262: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.ThtaPOP2 do
             RDName :='Diagenesis: '+name;
         End;
    263: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.ThtaPOP3 do
             RDName :='Diagenesis: '+name;
         End;
    264: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.kBEN_STR do
             RDName :='Diagenesis: '+symbol+' ('+units+')';
         End;
    265: Begin
           RDType := SingleVarDist;
           with Diagenesis_Params^.ksi do
             RDName :='Diagenesis: '+symbol+' ('+units+')';
         End;
    266: Begin
           RDType := SingleVarDist;
           RDName :='Const. Frac. Shading: (frac)';
         End;
    267: Begin
           RDType := SingleVarDist;
           RDName :='Setup: N to P Ratio';
         End;
    268: Begin
           RDType := SingleVarDist;
           RDName :='Setup: Relative Err.';
         End;
    269: Begin
           RDType := AllPlants;
           RDName := ' Frac. Lipid (wet wt.)';
         End;
    270: Begin
           RDType := AllOrgToxs;
           RDName := ' K1 Detritus (L/kg d)';
         End;
    271: Begin
           RDType := AllPlants;
           RDName := ' N Half-Sat Internal (gN/gAFDW)';
         End;
    272: Begin
           RDType := AllPlants;
           RDName := ' P Half-Sat Internal (gP/gAFDW)';
         End;
    273: Begin
           RDType := AllPlants;
           RDName := ' NMax Uptake Rate (gN/gAFDW d)';
         End;
    274: Begin
           RDType := AllPlants;
           RDName := ' PMax Uptake Rate (gP/gAFDW d)';
         End;
    275: Begin
           RDType := AllPlants;
           RDName := ' Min N Ratio (gN/gAFDW)';
         End;
    276: Begin
           RDType := AllPlants;
           RDName := ' Min P Ratio (gP/gAFDW)';
         End;
    else Raise EAquatoxError.Create('Invalid Index, Distribution Not Registered');
  end; {case}
  Return_Registered_Dist:=RD;
End;



Function TStates.Return_Var_Pointer(Index: Integer; ID:SV_ID; ToxRec: String): PDouble;
{ Returns a pointer to the variable that is being altered in the
  uncertainty analysis.  This variable will be saved, modified, and then
  returned to its original state. }

Var  Ret: PDouble ;
     Point: Pointer;
     FoundTox: Boolean;
     ATR: TAnimalToxRecord;
     PTR: TPlantToxRecord;
     ToxLoop: Integer;

Begin
  ATR:=Nil; PTR:=Nil;

  If ToxRec <>'' then
    Begin
      FoundTox:=False;
      For ToxLoop:=0 to ChemPtrs^[ID.SVType].Anim_Tox.Count-1 do
        If ToxRec = TAnimalToxRecord(ChemPtrs^[ID.SVType].Anim_Tox.At(ToxLoop)).Animal_Name
           then begin
                  FoundTox := True;
                  Atr:=ChemPtrs^[ID.SVType].Anim_Tox.At(ToxLoop);
                end;

      For ToxLoop:=0 to ChemPtrs^[ID.SVType].Plant_Tox.Count-1 do
        If ToxRec = TPlantToxRecord(ChemPtrs^[ID.SVType].Plant_Tox.At(ToxLoop)).Plant_Name
           then begin
                  FoundTox := True;
                  Ptr:=ChemPtrs^[ID.SVType].Plant_Tox.At(ToxLoop);
                end;

      If Not FoundTox then Raise EAquatoxError.Create('Tox Uncertainty Error, ToxRecord '+Toxrec+' Not Found.');
    End;


  Point:=GetStatePointer(ID.NState,ID.SVType,ID.Layer);
  if (Point = nil) and (Index in [56..105]) and (not (Index=71)) then
    Begin
      Raise EAquatoxError.Create('Distribution Return_Var_Pointer Error, State Variable Not Found');
    End;
  Case Index of
    1: Ret := @(ChemPtrs^[AssocToxTyp(ID.NState)].ChemRec.MolWt);
    2: Ret := @(ChemPtrs^[AssocToxTyp(ID.NState)].ChemRec.pKa);
    3: Ret := @(ChemPtrs^[AssocToxTyp(ID.NState)].ChemRec.Solubility);
    4: Ret := @(ChemPtrs^[AssocToxTyp(ID.NState)].ChemRec.Henry);
    5: Ret := @(ChemPtrs^[AssocToxTyp(ID.NState)].ChemRec.VPress);
    6: Ret := @(ChemPtrs^[AssocToxTyp(ID.NState)].ChemRec.LogKow);
    7: Ret := @(ChemPtrs^[AssocToxTyp(ID.NState)].ChemRec.KPSed);
    8: Ret := @(ChemPtrs^[AssocToxTyp(ID.NState)].ChemRec.En);
    9: Ret := @(ChemPtrs^[AssocToxTyp(ID.NState)].ChemRec.KMDegrAnaerobic);
    10: Ret := @(ChemPtrs^[AssocToxTyp(ID.NState)].ChemRec.KMDegrdn);
    11: Ret := @(ChemPtrs^[AssocToxTyp(ID.NState)].ChemRec.KUncat);
    12: Ret := @(ChemPtrs^[AssocToxTyp(ID.NState)].ChemRec.KAcid);
    13: Ret := @(ChemPtrs^[AssocToxTyp(ID.NState)].ChemRec.KBase);
    14: Ret := @(ChemPtrs^[AssocToxTyp(ID.NState)].ChemRec.PhotolysisRate);
    15: Ret := @(ChemPtrs^[AssocToxTyp(ID.NState)].ChemRec.OxRateConst);
    16: Ret := @(ChemPtrs^[AssocToxTyp(ID.NState)].ChemRec.Weibull_Shape);

    17: Ret := @(ATR.LC50);
    18: Ret := @(ATR.Entered_K2);
    19: Ret := @(ATR.Bio_rate_const);
    20: Ret := @(ATR.EC50_growth);
    21: Ret := @(ATR.EC50_repro);
    22: Ret := @(ATR.Drift_Thresh);

    23: Ret := @(PTR.EC50_photo);
    24: Ret := @(PTR.LC50);
    25: Ret := @(PTR.K2);
    26: Ret := @(PTR.Bio_rate_const);

    56: Ret := @(TPlant(Point).PAlgalRec^.EnteredLightSat);
    57: Ret := @(TPlant(Point).PAlgalRec^.KPO4);
    58: Ret := @(TPlant(Point).PAlgalRec^.KN);
    59: Ret := @(TPlant(Point).PAlgalRec^.KCarbon);
    60: Ret := @(TPlant(Point).PAlgalRec^.Q10);
    61: Ret := @(TPlant(Point).PAlgalRec^.TOpt);
    62: Ret := @(TPlant(Point).PAlgalRec^.TMax);
    63: Ret := @(TPlant(Point).PAlgalRec^.TRef);
    64: Ret := @(TPlant(Point).PAlgalRec^.PMax);
    65: Ret := @(TPlant(Point).PAlgalRec^.KResp);
    66: Ret := @(TPlant(Point).PAlgalRec^.KMort);
    67: Ret := @(TPlant(Point).PAlgalRec^.EMort);
    68: Ret := @(TPlant(Point).PAlgalRec^.P2OrgInit);
    69: Ret := @(TPlant(Point).PAlgalRec^.N2OrgInit);
    70: Ret := @(TPlant(Point).PAlgalRec^.ECoeffPhyto);
    71: Ret := @(Location.Remin.DecayMax_Refr);
    72: Ret := @(TPlant(Point).PAlgalRec^.KSed);
    73: Ret := @(TPlant(Point).PAlgalRec^.ESed);
    74: Ret := @(TPlant(Point).PAlgalRec^.CarryCapac);
    75: Ret := @(TPlant(Point).PAlgalRec^.Red_Still_Water);
    76: Ret := @(TPlant(Point).PAlgalRec^.Macro_VelMax);
    77: Ret := @(TPlant(Point).PAlgalRec^.FCrit);
    78: Ret := @(TPlant(Point).PAlgalRec^.PrefRiffle);
    79: Ret := @(TPlant(Point).PAlgalRec^.PrefPool);

    80: Ret := @(TAnimal(Point).PAnimalData^.FHalfSat);
    81: Ret := @(TAnimal(Point).PAnimalData^.CMax);
    82: Ret := @(TAnimal(Point).PAnimalData^.BMin);
    83: Ret := @(TAnimal(Point).PAnimalData^.Q10);
    84: Ret := @(TAnimal(Point).PAnimalData^.TOpt);
    85: Ret := @(TAnimal(Point).PAnimalData^.TMax);
    86: Ret := @(TAnimal(Point).PAnimalData^.TRef);
    87: Ret := @(TAnimal(Point).PAnimalData^.EndogResp);
    88: Ret := @(TAnimal(Point).PAnimalData^.KResp);
    89: Ret := @(TAnimal(Point).PAnimalData^.KExcr);
    90: Ret := @(TAnimal(Point).PAnimalData^.PctGamete);
    91: Ret := @(TAnimal(Point).PAnimalData^.GMort);
    92: Ret := @(TAnimal(Point).PAnimalData^.KMort);
    93: Ret := @(TAnimal(Point).PAnimalData^.KCap);
    94: Ret := @(TAnimal(Point).PAnimalData^.AveDrift);
    95: Ret := @(TAnimal(Point).PAnimalData^.VelMax);
    96: Ret := @(TAnimal(Point).PAnimalData^.LifeSpan);
    97: Ret := @(TAnimal(Point).PAnimalData^.FishFracLipid);
    98: Ret := @(TAnimal(Point).PAnimalData^.MeanWeight);
    99: Ret := @(TAnimal(Point).PAnimalData^.PrefRiffle);
    100: Ret := @(TAnimal(Point).PAnimalData^.PrefPool);
    101: Ret := @(TAnimal(Point).PAnimalData^.CA);
    102: Ret := @(TAnimal(Point).PAnimalData^.CB);
    103: Ret := @(TAnimal(Point).PAnimalData^.RA);
    104: Ret := @(TAnimal(Point).PAnimalData^.RB);
    105: Ret := @(TAnimal(Point).PAnimalData^.ACT);

    106: Ret := @(Location.Remin.DecayMax_Lab);
    107: Ret := @(Location.Locale.SiteLength);
    108: Ret := @(Location.Locale.ICZMean);
    109: Ret := @(Location.Locale.ZMax);
    110: Ret := @(Location.Locale.TempMean[Epilimnion]);
    111: Ret := @(Location.Locale.TempRange[Epilimnion]);
    112: Ret := @(Location.Locale.TempMean[Hypolimnion]);
    113: Ret := @(Location.Locale.TempRange[Hypolimnion]);
    114: Ret := @(Location.Locale.LightMean);
    115: Ret := @(Location.Locale.LightRange);
    116: Ret := @(Location.Locale.MeanEvap);
    117: Ret := @(Location.Locale.ECoeffWater);
    118: Ret := @(Location.Locale.Channel_Slope);
    119: Ret := @(Location.Locale.EnteredManning);
    120: Ret := @(Location.Locale.PctRiffle);
    121: Ret := @(Location.Locale.PctPool);

    122: If (ID.NState=DissRefrDetr) and (ID.SVType=StV)
             then Ret := @(TDissRefrDetr(Point).InputRecord.InitCond)
             else Ret := @(TStateVariable(Point).InitialCond);
    123: Ret := @(TStateVariable(Point).LoadsRec.ConstLoad);
    124: If (ID.NState=DissRefrDetr) and (ID.SVType=StV)
             then Ret := @(TDissRefrDetr(Point).InputRecord.Load.MultLdg)
             else Ret := @(TStateVariable(Point).LoadsRec.MultLdg);
    125: Ret := @(HypoTempLoads.MultLdg);
    126: Ret := @(TStateVariable(Point).LoadsRec.Alt_MultLdg[DirectPrecip]);
    127: If (ID.NState=DissRefrDetr) and (ID.SVType=StV)
             then Ret := @(TDissRefrDetr(Point).InputRecord.Load.Alt_MultLdg[PointSource])
             else Ret := @(TStateVariable(Point).LoadsRec.Alt_MultLdg[PointSource]);
    128: If (ID.NState=DissRefrDetr) and (ID.SVType=StV)
             then Ret := @(TDissRefrDetr(Point).InputRecord.Load.Alt_MultLdg[NonPointSource])
             else Ret := @(TStateVariable(Point).LoadsRec.Alt_MultLdg[NonPointSource]);

    129: Ret := @(Location.Locale.TS_Clay);
    130: Ret := @(Location.Locale.TDep_Clay);
    131: Ret := @(Location.Locale.FallVel_Clay);
    132: Ret := @(Location.Locale.TS_Silt);
    133: Ret := @(Location.Locale.TDep_Silt);
    134: Ret := @(Location.Locale.FallVel_Silt);
    135: Ret := @(ATR.EC50_growth);
    136: Ret := @(Location.Locale.TotalLength);
    137: Ret := @(Location.Locale.ECoeffSed);
    138: Ret := @(Location.Locale.ECoeffDOM);
    139: Ret := @(Location.Locale.ECoeffPOM);

    {Rel 3 addtl animal params}
    140: Ret := @(TAnimal(Point).PAnimalData^.FracInWaterCol);
    141: Ret := @(TAnimal(Point).PAnimalData^.Salmin_Ing);         {minimum salinity tolerance 0/00}
    142: Ret := @(TAnimal(Point).PAnimalData^.SalMax_Ing);         {max salinity tolerance 0/00}
    143: Ret := @(TAnimal(Point).PAnimalData^.Salcoeff1_Ing);
    144: Ret := @(TAnimal(Point).PAnimalData^.Salcoeff2_Ing);
    145: Ret := @(TAnimal(Point).PAnimalData^.Salmin_Gam);         {minimum salinity tolerance 0/00}
    146: Ret := @(TAnimal(Point).PAnimalData^.SalMax_Gam);         {max salinity tolerance 0/00}
    147: Ret := @(TAnimal(Point).PAnimalData^.Salcoeff1_Gam);
    148: Ret := @(TAnimal(Point).PAnimalData^.Salcoeff2_Gam); {unitless}
    149: Ret := @(TAnimal(Point).PAnimalData^.Salmin_Rsp);         {minimum salinity tolerance 0/00}
    150: Ret := @(TAnimal(Point).PAnimalData^.SalMax_Rsp);         {max salinity tolerance 0/00}
    151: Ret := @(TAnimal(Point).PAnimalData^.Salcoeff1_Rsp);
    152: Ret := @(TAnimal(Point).PAnimalData^.Salcoeff2_Rsp); {unitless}
    153: Ret := @(TAnimal(Point).PAnimalData^.Salmin_Mort);         {minimum salinity tolerance 0/00}
    154: Ret := @(TAnimal(Point).PAnimalData^.SalMax_Mort);         {max salinity tolerance 0/00}
    155: Ret := @(TAnimal(Point).PAnimalData^.Salcoeff1_Mort);
    156: Ret := @(TAnimal(Point).PAnimalData^.Salcoeff2_Mort); {unitless}
    157: Ret := @(TAnimal(Point).PAnimalData^.Fishing_Frac); {fraction / day}

    158: Ret := @(TAnimal(Point).PAnimalData^.P2Org);
    159: Ret := @(TAnimal(Point).PAnimalData^.N2Org);
    160: Ret := @(TAnimal(Point).PAnimalData^.Wet2Dry);
    161: Ret := @(TAnimal(Point).PAnimalData^.O2_LethalConc);
    162: Ret := @(TAnimal(Point).PAnimalData^.O2_LethalPct);
    163: Ret := @(TAnimal(Point).PAnimalData^.O2_EC50growth);
    164: Ret := @(TAnimal(Point).PAnimalData^.O2_EC50repro);
    165: Ret := @(TAnimal(Point).PAnimalData^.Ammonia_LC50);
    166: Ret := @(TAnimal(Point).PAnimalData^.Sorting);    {3.46, SABS}
    167: Ret := @(TAnimal(Point).PAnimalData^.SlopeSSFeed);
    168: Ret := @(TAnimal(Point).PAnimalData^.InterceptSSFeed);
    169: Ret := @(TAnimal(Point).PAnimalData^.Trigger);

    {Rel 3 addtl plant params}
    170: Ret := @(TPlant(Point).PAlgalRec^.KSedTemp);
    171: Ret := @(TPlant(Point).PAlgalRec^.KSedSalinity);
    172: Ret := @(TPlant(Point).PAlgalRec^.Salmin_Phot);         {minimum salinity tolerance 0/00}
    173: Ret := @(TPlant(Point).PAlgalRec^.SalMax_Phot);         {max salinity tolerance 0/00}
    174: Ret := @(TPlant(Point).PAlgalRec^.Salcoeff1_Phot);
    175: Ret := @(TPlant(Point).PAlgalRec^.Salcoeff2_Phot); {unitless}
    176: Ret := @(TPlant(Point).PAlgalRec^.Salmin_Mort);         {minimum salinity tolerance 0/00}
    177: Ret := @(TPlant(Point).PAlgalRec^.SalMax_Mort);         {max salinity tolerance 0/00}
    178: Ret := @(TPlant(Point).PAlgalRec^.Salcoeff1_Mort);
    179: Ret := @(TPlant(Point).PAlgalRec^.Salcoeff2_Mort); {unitless}
    180: Ret := @(TPlant(Point).PAlgalRec^.Wet2Dry);
    181: Ret := @(TPlant(Point).PAlgalRec^.Resp20);
    182: Ret := @(TPlant(Point).PAlgalRec^.PctSloughed);
    183: Ret := @(TPlant(Point).PAlgalRec^.MaxLightSat);
    184: Ret := @(TPlant(Point).PAlgalRec^.MinLightSat);

    {Rel 3 addtl site params}
    185: Ret := @(Location.Locale.EnteredKReaer);

    {Rel 3 remin params}

    186: Ret := @(Location.Remin.TOpt);
    187: Ret := @(Location.Remin.TMax);

    188: Ret := @(Location.Remin.pHMin);
    189: Ret := @(Location.Remin.pHMax);
    190: Ret := @(Location.Remin.P2OrgLab);
    191: Ret := @(Location.Remin.N2OrgLab);
    192: Ret := @(Location.Remin.O2Biomass);
    193: Ret := @(Location.Remin.O2N);
    194: Ret := @(Location.Remin.KSed);

    195: Ret := @(Location.Remin.KSedTemp);
    196: Ret := @(Location.Remin.KSedSalinity);
    197: Ret := @(Location.Remin.P2Org_Refr);
    198: Ret := @(Location.Remin.N2Org_Refr);
    199: Ret := @(Location.Remin.Wet2DryPRefr);
    200: Ret := @(Location.Remin.Wet2DryPLab);
    201: Ret := @(Location.Remin.Wet2DrySRefr);
    202: Ret := @(Location.Remin.Wet2DrySLab);
    203: Ret := @(Location.Remin.N2OrgDissLab);
    204: Ret := @(Location.Remin.P2OrgDissLab);
    205: Ret := @(Location.Remin.N2OrgDissRefr);
    206: Ret := @(Location.Remin.P2OrgDissRefr);
    207: Ret := @(Location.Remin.KD_P_Calcite);

{      The constant percent labile specified for initial conditions, and loadings
       The constant percent particulate specified for initial conditions, and loadings  }
    208: Begin
           Point:=GetStatePointer(DissRefrDetr,StV,WaterCol);
           Ret := @(TDissRefrDetr(Point).InputRecord.Percent_Part.ConstLoad );
         End;
    209: Begin
           Point:=GetStatePointer(DissRefrDetr,StV,WaterCol);
           Ret := @(TDissRefrDetr(Point).InputRecord.Percent_Refr.ConstLoad );
         End;
    210: Begin
           Point:=GetStatePointer(DissRefrDetr,StV,WaterCol);
           Ret := @(TDissRefrDetr(Point).InputRecord.Percent_PartIC );
         End;
    211: Begin
           Point:=GetStatePointer(DissRefrDetr,StV,WaterCol);
           Ret := @(TDissRefrDetr(Point).InputRecord.Percent_RefrIC );
         End;

    212: Ret := @(Location.Locale.BasePercentEmbed);
    213: Ret := @(TAnimal(Point).PAnimalData^.PctEmbedThreshold);
    214: Ret := @(Location.Remin.NotUsed);  //FIXME Placeholder for new
    215: Ret := @(Diagenesis_Params^.M1.Val);
    216: Ret := @(Diagenesis_Params^.m2.Val);
    217: Ret := @(Diagenesis_Params^.H1.Val);
    218: Ret := @(Diagenesis_Params^.Dd.Val);
    219: Ret := @(Diagenesis_Params^.w2.Val);
    220: Ret := @(Diagenesis_Params^.H2.Val);
    221: Ret := @(Diagenesis_Params^.KappaNH3f.Val);
    222: Ret := @(Diagenesis_Params^.KappaNH3s.Val);
    223: Ret := @(Diagenesis_Params^.KappaNO3_1f.Val);
    224: Ret := @(Diagenesis_Params^.KappaNO3_1s.Val);
    225: Ret := @(Diagenesis_Params^.KappaNO3_2.Val);
    226: Ret := @(Diagenesis_Params^.KappaCH4.Val);
    227: Ret := @(Diagenesis_Params^.KM_NH3.Val);
    228: Ret := @(Diagenesis_Params^.KM_O2_NH3.Val);
    229: Ret := @(Diagenesis_Params^.KdNH3.Val);
    230: Ret := @(Diagenesis_Params^.KdPO42.Val);
    231: Ret := @(Diagenesis_Params^.dKDPO41f.Val);
    232: Ret := @(Diagenesis_Params^.dKDPO41s.Val);
    233: Ret := @(Diagenesis_Params^.O2critPO4.Val);
    234: Ret := @(Diagenesis_Params^.ThtaDd.Val);
    235: Ret := @(Diagenesis_Params^.ThtaNH3.Val);
    236: Ret := @(Diagenesis_Params^.ThtaNO3.Val);
    237: Ret := @(Diagenesis_Params^.ThtaCH4.Val);
    238: Ret := @(Diagenesis_Params^.SALTSW.Val);
    239: Ret := @(Diagenesis_Params^.SALTND.Val);
    240: Ret := @(Diagenesis_Params^.KappaH2Sd1.Val);
    241: Ret := @(Diagenesis_Params^.KappaH2Sp1.Val);
    242: Ret := @(Diagenesis_Params^.ThtaH2S.Val);
    243: Ret := @(Diagenesis_Params^.KMHSO2.Val);
    244: Ret := @(Diagenesis_Params^.KdH2S1.Val);
    245: Ret := @(Diagenesis_Params^.KdH2S2.Val);
    246: Ret := @(Diagenesis_Params^.kpon1.Val);
    247: Ret := @(Diagenesis_Params^.kpon2.Val);
    248: Ret := @(Diagenesis_Params^.kpon3.Val);
    249: Ret := @(Diagenesis_Params^.kpoc1.Val);
    250: Ret := @(Diagenesis_Params^.kpoc2.Val);
    251: Ret := @(Diagenesis_Params^.kpoc3.Val);
    252: Ret := @(Diagenesis_Params^.kpop1.Val);
    253: Ret := @(Diagenesis_Params^.kpop2.Val);
    254: Ret := @(Diagenesis_Params^.kpop3.Val);
    255: Ret := @(Diagenesis_Params^.ThtaPON1.Val);
    256: Ret := @(Diagenesis_Params^.ThtaPON2.Val);
    257: Ret := @(Diagenesis_Params^.ThtaPON3.Val);
    258: Ret := @(Diagenesis_Params^.ThtaPOC1.Val);
    259: Ret := @(Diagenesis_Params^.ThtaPOC2.Val);
    260: Ret := @(Diagenesis_Params^.ThtaPOC3.Val);
    261: Ret := @(Diagenesis_Params^.ThtaPOP1.Val);
    262: Ret := @(Diagenesis_Params^.ThtaPOP2.Val);
    263: Ret := @(Diagenesis_Params^.ThtaPOP3.Val);
    264: Ret := @(Diagenesis_Params^.kBEN_STR.Val);
    265: Ret := @(Diagenesis_Params^.ksi.Val);

    266: Ret := @(Shade.ConstLoad);

    267: Ret := @(SetupRec.NtoPRatio);
    268: Ret := @(SetupRec.RelativeError);

    269: Ret := @(TPlant(Point).PAlgalRec^.PlantFracLipid);

    270: Ret :=@(ChemPtrs^[AssocToxTyp(ID.NState)].ChemRec.K1Detritus);

    271: Ret := @(TPlant(Point).PAlgalRec^.NHalfSatInternal);
    272: Ret := @(TPlant(Point).PAlgalRec^.PHalfSatInternal);
    273: Ret := @(TPlant(Point).PAlgalRec^.MaxNUptake);
    274: Ret := @(TPlant(Point).PAlgalRec^.MaxPUptake);
    275: Ret := @(TPlant(Point).PAlgalRec^.Min_N_Ratio);
    276: Ret := @(TPlant(Point).PAlgalRec^.Min_P_Ratio);

    else Raise EAquatoxError.Create('Invalid Index, Distribution Not Registered Properly, Can''t Return Pointer');
   End; {Case}
  Return_Var_Pointer:= Ret;
End;


{----------------------------------------------------------------------}
{-            Below Code Is Designed to be General                    -}
{----------------------------------------------------------------------}

Procedure TStates.Update_Distributions;
Var Index,FoundIndex : Integer;
    RD    : Registered_Distribution;
    PDist : TDistribution;
    Dists : TDistributionList;
    LowIndex,HighIndex,WriteIndex, LoopIndex: AllVariables;
    TypeLoop,HighTypeIndex,LowTypeIndex: T_SVType;
    ToxLoop: Integer;
    MeanVal: Double;
    StatePoint: Pointer;
    NameStr: String;
    AddTheDist, FoundTox: Boolean;
    ATR: TAnimalToxRecord;
    PTR: TPlantToxRecord;

    Function IsGlobal: Boolean;
    {global distributions are global to an entire multi-linked system.  They are
     stored in the template segment.}
    {local distributions are unique to a particular segment.  They are stored in
     individual segments.}
    Begin
      IsGlobal := not (RD.RDIndex in [71,106..134,136..139,185..212]) and  // List of parameters unique to a single segment.  Updated 4/27/2012
                  not ((RD.RDIndex > 213) and (RD.RDIndex<267))
    End;

Var PosRDetr,PosStr: Integer;
Begin
Dists:=Distributions;

{Delete Distributions which are extraneous}
If Dists.Count>0 then
  For Index:= Dists.Count-1 downto 0 do
    begin
      PDist:=Dists.At(Index);

      If PDist.ToxRec <>'' then
        Begin
          FoundTox:=False;

          If PDist.SVID.SVType=StV then PDist.SVID.SVType:=FirstOrgTxTyp;  {upgrade old studies}

          If ChemPtrs^[PDist.SVID.SVType]<>nil then
            Begin
              For ToxLoop:=0 to ChemPtrs^[PDist.SVID.SVType].Anim_Tox.Count-1 do
                  begin
                    ATR := ChemPtrs^[PDist.SVID.SVType].Anim_Tox.At(ToxLoop);
                    If PDist.ToxRec = ATR.Animal_Name then FoundTox := True;
                  end;

              For ToxLoop:=0 to ChemPtrs^[PDist.SVID.SVType].Plant_Tox.Count-1 do
                  begin
                    PTR := ChemPtrs^[PDist.SVID.SVType].Plant_Tox.At(ToxLoop);
                    If PDist.ToxRec = PTR.Plant_Name then FoundTox := True;
                  end;
            End;

          If (GetStatePointer(AssocToxSV(PDist.SVID.SVType),StV,WaterCol)=nil) or (Not FoundTox) or (Not (PDist.UseDist or PDist.UseForSens)) then Dists.AtFree(Index);
        End
      Else If (PDist.SVID.NState<>nullstatevar) and
              (GetStatePointer(PDist.SVID.NState,PDist.SVID.SVType,PDist.SVID.Layer)=nil)
             Then Dists.AtFree(Index)
               Else If Not (PDist.UseDist or PDist.UseForSens) then Dists.AtFree(Index);
    end;

 For Index:=1 to Num_Of_Reg_Distributions do
  If ((Index<27) or (Index>55)) then
   Begin
    RD:=Return_Registered_Dist(Index);

    Case RD.RDType of
      AllOrgToxs:    begin
                       LowIndex := FirstOrgTox;
                       HighIndex:= LastOrgTox;
                       LowTypeIndex:=StV;
                       HighTypeIndex:=StV;
                     end;
      AllAnimals, AllFish:
                     begin
                       LowIndex := FirstAnimal;
                       HighIndex:= LastAnimal;
                       LowTypeIndex:=StV;
                       HighTypeIndex:=StV;
                     end;
      AllPlants,AllPhyto,AllPeriMacro:
                     begin
                       LowIndex := FirstPlant;
                       HighIndex:= LastPlant;
                       LowTypeIndex:=StV;
                       HighTypeIndex:=StV;
                     end;
      AllStateVars:  begin
                       LowIndex := FirstState;
                       HighIndex:= Pred(LastState);
                       LowTypeIndex:=StV;
                       HighTypeIndex:=LastOrgTxTyp;
                     end
      else {single}
                     begin
                       LowIndex := NullStateVar;
                       HighIndex:= NullStateVar;
                       LowTypeIndex:=StV;
                       HighTypeIndex:=StV;
                     end;
    end; {case}

    If (RD.RDType<AnimalTox) or (RD.RDType in [AllOrgToxs..AllFish]) then
     For TypeLoop := HighTypeIndex downto LowTypeIndex do
      For LoopIndex:=HighIndex downto LowIndex do
       begin
        {EVALUATE ADDTHEDIST, Does a new dist need to be added?}
        StatePoint :=GetStatePointer(LoopIndex,TypeLoop,WaterCol);
        AddTheDist:= ((LoopIndex=NullStateVar) or (not (StatePoint=nil))) and
                     (not (Dists.FindDistrib(Index,GetID(LoopIndex,TypeLoop,WaterCol),'',FoundIndex)));
        If (AddTheDist) and (RD.RDType=AllPhyto) and (TPlant(StatePoint).PAlgalRec^.PlantType <> 'Phytoplankton')
            then AddTheDist := False;
        If (AddTheDist) and (RD.RDType=AllPeriMacro) and (TPlant(StatePoint).PAlgalRec^.PlantType = 'Phytoplankton')
            then AddTheDist := False;
        If (AddTheDist) and (RD.RDType=AllFish) and (TAnimal(StatePoint).PAnimalData^.Animal_Type <> 'Fish')
            then AddTheDist := False;

        If AddTheDist and (Index in [DP_RegDist_Index,NPS_RegDist_Index,PS_RegDist_Index])
            and ((not Has_Alt_Loadings(LoopIndex,TypeLoop,WaterCol)) or (LoopIndex in [temperature..ph])) or
                ((loopindex=DissRefrDetr) and (Index=DP_RegDist_Index))
            then AddTheDist:=False;
        If AddTheDist and (RD.RDType=AllOrgToxs) and (GetStatePointer(LoopIndex,StV,WaterCol)=nil)
            then AddTheDist:=False;
        If (AddTheDist) and (Index=ConstLoad_RegDist_Index) and (loopindex=DissRefrDetr)
            then AddTheDist := False;
        if (AddTheDist) and (Index=128) and (loopIndex=Volume) and not (EstuarySegment)
            then AddTheDist := False;

        If LINKEDMODE and AddTheDist and (IsGlobal <> (PStatesTemplate=Self))
            then AddTheDist:=False;

        If AddTheDist then
           begin
             MeanVal:=Double(Return_Var_Pointer(Index,GetID(LoopIndex,TypeLoop,WaterCol),'')^);
             If (LoopIndex<>NullStateVar) then NameStr:=OutputText(LoopIndex,TypeLoop,WaterCol,uniquename(LoopIndex),False,False,0)+RD.RDName
                                          else NameStr:=RD.RDName;

             PosRDetr := Pos('R detr diss',Namestr);
             If PosRDetr > 0 then
               Begin
                 System.Delete(NameStr,PosRDetr,11);
                 System.Insert('Susp&Diss Detr',NameStr,PosRDetr)
               End;

               if (LoopIndex = Volume) and (not EstuarySegment) then
                  Begin
                    PosStr := Pos('Point Source',NameStr);
                    if PosStr > 0 then
                      Begin
                        System.Delete(NameStr,PosStr,12);
                        System.Insert('Inflow',NameStr,PosStr)
                      End;
                    PosStr := Pos('Direct Precip.',NameStr);
                    if PosStr > 0 then
                      Begin
                        System.Delete(NameStr,PosStr,14);
                        System.Insert('Discharge',NameStr,PosStr)
                      End;
                  End;


             {Add units if necessary}
             If Index = InitialCond_RegDist_Index then
                NameStr:=NameStr+'('+TStateVariable(GetStatePointer(LoopIndex,TypeLoop,WaterCol)).StateUnit+')';
             If Index = ConstLoad_RegDist_Index then
                NameStr:=NameStr+'('+TStateVariable(GetStatePointer(LoopIndex,TypeLoop,WaterCol)).LoadingUnit+')';
             {Remove units if necessary}
             If LoopIndex in [H2OTox1..H2OTox9]   then Delete(NameStr,3,4);
             If LoopIndex in [H2OTox10..H2OTox20] then Delete(NameStr,4,4);

             WriteIndex := LoopIndex;
             if (LoopIndex = NullStateVar) and (Index in [208..211]) then
               WriteIndex := DissRefrDetr;

             PDist:=TDistribution.Init(NameStr,Index,GetID(WriteIndex,TypeLoop,WaterCol),MeanVal);
             Dists.Insert(PDist);
           end;
       end
     Else {AnimalTox or PlantTox}
      If not LINKEDMODE or (PStatesTemplate=Self) then
      For TypeLoop := LastOrgTxTyp downto FirstOrgTxTyp do
       If (GetStatePointer(AssocToxSV(TypeLoop),StV,WaterCol)<>nil) then
        begin
         If RD.RDType=AnimalTox then
           For ToxLoop:=ChemPtrs^[TypeLoop].Anim_Tox.Count-1 downto 0 do
             begin
               ATR := ChemPtrs^[TypeLoop].Anim_Tox.At(ToxLoop);
               {EVALUATE ADDTHEDIST, Does a new dist need to be added?}
               If ATR.Animal_Name=''
                 then AddTheDist := False
                 else AddTheDist := (not (Dists.FindDistrib(Index,GetID(nullstatevar,TypeLoop,WaterCol),ATR.Animal_Name,FoundIndex)));
               If AddTheDist then
                 begin
                   MeanVal:=Double(Return_Var_Pointer(Index,GetID(nullstatevar,TypeLoop,WaterCol),ATR.Animal_Name)^);

                   NameStr:=OutputText(AssocToxSV(TypeLoop),StV,WaterCol,'',False,False,0)+': '+ATR.Animal_Name+RD.RDName;
                   If (TypeLoop>OrgTox9) then Delete(NameStr,4,4)
                                         else Delete(NameStr,3,4); {Remove Tox Units}

                   PDist:=TDistribution.Init(NameStr,Index,GetID(nullstatevar,TypeLoop,WaterCol),MeanVal);
                   PDist.ToxRec:=ATR.Animal_Name;

                   Dists.Insert(PDist);
                 end;
             end;

          If RD.RDType=PlantTox then
           For ToxLoop:=ChemPtrs^[TypeLoop].Plant_Tox.Count-1 downto 0 do
             begin
               PTR := ChemPtrs^[TypeLoop].Plant_Tox.At(ToxLoop);
               {EVALUATE ADDTHEDIST, Does a new dist need to be added?}
               If PTR.Plant_Name=''
                 then AddTheDist := False
                 else AddTheDist:= (not (Dists.FindDistrib(Index,GetID(nullstatevar,TypeLoop,WaterCol),PTR.Plant_Name,FoundIndex)));

               If AddTheDist then
                 begin
                   MeanVal:=Double(Return_Var_Pointer(Index,GetID(nullstatevar,TypeLoop,WaterCol),PTR.Plant_Name)^);
                   NameStr:=OutputText(AssocToxSV(TypeLoop),StV,WaterCol,'',False,False,0)+': '+PTR.Plant_Name + RD.RDName;
                   If (TypeLoop>OrgTox9) then Delete(NameStr,4,4)
                                         else Delete(NameStr,3,4); {Remove Tox Units}

                   PDist:=TDistribution.Init(NameStr,Index,GetID(nullStateVar,TypeLoop,WaterCol),MeanVal);
                   PDist.ToxRec:=PTR.Plant_Name;

                   Dists.Insert(PDist);
                 end;
             end;

        end

  End;
End;


