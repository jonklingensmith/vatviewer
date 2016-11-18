function [] = DrawCountours(whichType)
%
%
%
%

% global variables from the workspace to use elsewhere
vatviewerGlobalVars;

hold on;

% set the correct data and reload 
switch whichType
    case 'EAT_3D'
        plot(EAT_TRACED_CONTOURS(:,1),...
            EAT_TRACED_CONTOURS(:,2),'y','LineWidth',2);
    otherwise
end


hold off;