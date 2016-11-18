function [] = AddPointToCountours(whichType,point)
%
%
%
%

% global variables from the workspace to use elsewhere
vatviewerGlobalVars;

% set the correct data and reload 
switch whichType
    case 'EAT_3D'
        numPts = size(EAT_TRACED_CONTOURS,1);
        EAT_TRACED_CONTOURS(numPts+1,1) = int16(point(1,1));
        EAT_TRACED_CONTOURS(numPts+1,2) = int16(point(1,2));
        disp(sprintf('Added %03d, %03d to %s',...
            int16(point(1,1)),int16(point(1,2)),whichType));
    otherwise
end