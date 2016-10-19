//AQUATOX SOURCE CODE Copyright (c) 2005-2014 Eco Modeling and Warren Pinnacle Consulting, Inc.
//Code Use and Redistribution is Subject to Licensing, SEE AQUATOX_License.txt
// 
unit WizGlobal;

interface

uses global;

Const NumberOfSteps=19;
Type TWizStatus = Array [1..NumberOfSteps] of Word;
Type WizOutput = (WzNoOutcome, WzNext, WzBack, WzCancel, WzFinished, WzJump);

Const W4_NumFields=6;        {Number of fields verified entered}
      W5_NumFields = 26;
      W5_NumLabels = 12;
      W7_NumLabels = 16;
      W7_NumFields = 16;
      W8_NumFields = 12;
      W10_NumFields = 5;
      W11_NumFields = 2;
      W12_NumFields = 3;
      W13_NumFields = 1;
      W14_NumFields = 13;
      W15_NumFields = 100;


Var W1_Choice: Word; {0: no choice, 1: from scratch or Modification, 2: default or modification}
    W1_Screen: Word; {0: first screen, 1: name & type, 2: Load Default}
    W1_DefChosen: Boolean;
    W2_StartEdited, W2_EndEdited: Boolean;
    W3_FieldEdited: Array[1..5] of Boolean;
    W4_FieldEdited: Array[1..W4_NumFields] of Boolean;
    W4_Screen: Word; {0: Sediment Bed, 1: Water Column}
    W5_NumScreens: Integer;
    W5_FieldEdited: Array [1..W5_NumFields] of Boolean;
    W5_Screen: Word;
    W5_PType : String;
    W5_BeginIndex, W5_EndIndex: AllVariables;
    W5_ICFields: Array [1..W5_NumFields] of AllVariables;
    W5_NumICs: Integer;
    W7_Screen: Integer;
    W7_NumICs: Array[1..2] of Integer;
    W7_FishArray: Array[1..50] of AllVariables;
    W7_FieldEdited: Array [1..2,1..W7_NumFields] of Boolean;
    W7_ICFields: Array [1..W7_NumFields] of AllVariables;
    W8_FieldEdited: Array[1..W8_NumFields] of Boolean;
    W8_Screen: Word;
    W9_VolMethChosen: Boolean;
    W9_Screen: Word;
    W9_FieldEdited: Boolean;
    W10_TempMethChosen: Boolean;
    W10_Screen: Word;
    W10_FieldEdited: Array[1..W10_NumFields] of Boolean;
    W11_WindMethChosen: Boolean;
    W11_Screen: Word;
    W11_FieldEdited: Array[1..W11_NumFields] of Boolean;
    W12_LightMethChosen: Boolean;
    W12_Screen: Word;
    W12_FieldEdited: Array[1..W12_NumFields] of Boolean;
    W13_pHMethChosen: Boolean;
    W13_Screen: Word;
    W13_FieldEdited: Array[1..W13_NumFields] of Boolean;
    W14_TSSMethChosen: Boolean;
    W14_SSSMethChosen: Boolean;
    W14_YesNoClick: Boolean;
    W14_Screen: Word;
    W14_FieldEdited: Array[1..W14_NumFields] of Boolean;
    W15_DataChanged: Boolean;
    W15_Screen: Word;
    W15_ChemsInStudy: Array [1..20] of AllVariables;
    W15_InitConds : Array[1..W15_NumFields] of AllVariables;
    W15_NumICs: Integer;
    W15_NumChems: Integer;
    W16_DataChanged: Boolean;
    W16_ListWritten: Boolean;
    W17_DataChanged: Boolean;
    W17_ListWritten: Boolean;
    W18_DataChanged: Boolean;
    W18_ListWritten: Boolean;
    W19_DataChanged: Boolean;
    W19_ListWritten: Boolean;

implementation

end.
