% set up global variables for use in all UI functions

% the different data types to load - controlled by which radio button
% is pressed in the UI
global EAT_3D;
global PAAT_3D;
global CAT_3D;
global SCAT_3D;
global TAT_3D;
global VAT_3D;
global IMAT_3D;
global ORGANS_3D;
global VOIDS_3D;
global LUNGS_3D;
global HEART_3D;
global AORTA_3D;

% to switch which tissue type to display - use a string
% with the same as the variable name for that type
global WHICH_TYPE; 
global VOL_3D; % to store the volume chosen
global BOOL_LOADED_DATA; % flag for whether data has been loaded

% list of tissue types output by VATsegmentationFull2
global SCAT3d;
global TAT3d;
global VAT3d;
global IMAT3d;
global organs3d;
global voids3d;
global lung3d;
global heart3d;
global aorta3d;
global CAT3d;
global PAAT3d;
global EAT3d;


