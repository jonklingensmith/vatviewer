function [] = vatviewerSetTissueType()
%
%
%

% access to global variables
vatviewerGlobalVars;

% looks at global variable controlling which type of data to use
% and sets that up in the 3D data set variable

switch WHICH_TYPE
    case 'EAT_3D'
        VOL_3D = EAT_3D;
        disp(sprintf('Set data type to %s','EAT_3D'));
    case 'PAAT_3D'
        VOL_3D = PAAT_3D;
        disp(sprintf('Set data type to %s','PAT_3D'));
    case 'CAT_3D'
        VOL_3D = CAT_3D;
        disp(sprintf('Set data type to %s','CAT_3D'));
    case 'SCAT_3D'
        VOL_3D = SCAT_3D;
        disp(sprintf('Set data type to %s','SCAT_3D'));
    case 'TAT_3D'
        VOL_3D = TAT_3D;
        disp(sprintf('Set data type to %s','TAT_3D'));
    case 'VAT_3D'
        VOL_3D = VAT_3D;
        disp(sprintf('Set data type to %s','VAT_3D'));
    case 'IMAT_3D'
        VOL_3D = IMAT_3D;
        disp(sprintf('Set data type to %s','IMAT_3D'));
    case 'ORGANS_3D'
        VOL_3D = ORGANS_3D;
        disp(sprintf('Set data type to %s','ORGANS_3D'));
    case 'VOIDS_3D'
        VOL_3D = VOIDS_3D;
        disp(sprintf('Set data type to %s','VOIDS_3D'));
    case 'LUNGS_3D'
        VOL_3D = LUNGS_3D;
        disp(sprintf('Set data type to %s','LUNGS_3D'));
    case 'HEART_3D'
        VOL_3D = HEART_3D;
        disp(sprintf('Set data type to %s','HEART_3D'));
    case 'AORTA_3D'
        VOL_3D = AORTA_3D;
        disp(sprintf('Set data type to %s','AORTA_3D'));
    case 'FATONLY_3D'
        VOL_3D = FATONLY_3D;
        disp(sprintf('Set data type to %s','FATONLY_3D'));
    case 'WATERONLY_3D'
        VOL_3D = WATERONLY_3D;
        disp(sprintf('Set data type to %s','WATERONLY_3D'));
    case 'FATFRACTION_3D'
        VOL_3D = FATFRACTION_3D;
        disp(sprintf('Set data type to %s','FATFRACTION_3D'));
    case 'WATERFRACTION_3D'
        VOL_3D = WATERFRACTION_3D;
        disp(sprintf('Set data type to %s','WATERFRACTION_3D'));
    otherwise
        VOL_3D = EAT_3D;
        disp(sprintf('Set data type to %s','EAT_3D'));
end


