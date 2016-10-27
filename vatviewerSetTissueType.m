function [] = vatviewerSetTissueType()
%
%
%

% access to global variables
vatviewerGlobalVars;

% list of tissue types output by VATsegmentationFull2
% SCAT3d(:,:,i)   = SCAT;
% TAT3d(:,:,i)    = TAT;
% VAT3d(:,:,i)    = VAT;
% IMAT3d(:,:,i)   = IMAT;
% organs3d(:,:,i) = organs;
% voids3d(:,:,i)  = voids;
% lung3d(:,:,i)   = lungs;
% heart3d(:,:,i)  = heart;
% aorta3d(:,:,i)  = aorta;
% CAT3d(:,:,i)    = CAT;
% PAAT3d(:,:,i)   = PAAT;
% EAT3d(:,:,i)    = EAT;

% looks at global variable controlling which type of data to use
% and sets that up in the 3D data set variable

switch WHICH_TYPE
    case 'EAT_3D'
        VOL_3D = EAT3d;
        disp(sprintf('Set data type to %s','EAT_3D'));
    case 'PAAT_3D'
        VOL_3D = PAAT3d;
        disp(sprintf('Set data type to %s','PAT_3D'));
    case 'CAT_3D'
        VOL_3D = CAT3d;
        disp(sprintf('Set data type to %s','CAT_3D'));
    case 'SCAT_3D'
        VOL_3D = SCAT3d;
        disp(sprintf('Set data type to %s','SCAT_3D'));
    case 'TAT_3D'
        VOL_3D = TAT3d;
        disp(sprintf('Set data type to %s','TAT_3D'));
    case 'VAT_3D'
        VOL_3D = VAT3d;
        disp(sprintf('Set data type to %s','VAT_3D'));
    case 'IMAT_3D'
        VOL_3D = IMAT3d;
        disp(sprintf('Set data type to %s','IMAT_3D'));
    case 'ORGANS_3D'
        VOL_3D = organs3d;
        disp(sprintf('Set data type to %s','ORGANS_3D'));
    case 'VOIDS_3D'
        VOL_3D = voids3d;
        disp(sprintf('Set data type to %s','VOIDS_3D'));
    case 'LUNGS_3D'
        VOL_3D = lung3d;
        disp(sprintf('Set data type to %s','LUNGS_3D'));
    case 'HEART_3D'
        VOL_3D = heart3d;
        disp(sprintf('Set data type to %s','HEART_3D'));
    case 'AORTA_3D'
        VOL_3D = aorta3d;
        disp(sprintf('Set data type to %s','AORTA_3D'));
    otherwise
        VOL_3D = EAT3d;
end

% SCAT_3D = SCAT3d;
% TAT_3D = TAT3d;
% VAT_3D = VAT3d;
% IMAT_3D = IMAT3d;
% ORGANS_3D = organs3d;
% VOIDS_3D = voids3d;
% LUNGS_3D = lung3d;
% HEART_3D = heart3d;
% AORTA_3D = aorta3d;
% CAT_3D = CAT3d;
% PAAT_3D = PAAT3d;
% EAT_3D = EAT3d;
