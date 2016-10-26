function [] = vatviewerLoadTissueData()
% load the tissue data and set up global variables
% uses variable names from VATsegmentationFull2 and copies
% to global variable names

% access to global vars
vatviewerGlobalVars;

% set all the global variables to correct data
SCAT_3D = SCAT3d;
clear SCAT3d;
TAT_3D = TAT3d;
clear TAT3d;
VAT_3D = VAT3d;
clear VAT3d;
IMAT_3D = IMAT3d;
clear IMAT3d;
ORGANS_3D = organs3d;
clear organs3d;
VOIDS_3D = voids3d;
clear voids3d;
LUNGS_3D = lung3d;
clear lung3d;
HEART_3D = heart3d;
clear heart3d;
AORTA_3D = aorta3d;
clear aorta3d;
CAT_3D = CAT3d;
clear CAT3d;
PAAT_3D = PAAT3d;
clear PAAT3d;
EAT_3D = EAT3d;
clear EAT3d;
