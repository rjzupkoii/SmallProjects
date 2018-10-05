% APS Lab Extract, Transform, Load (aps_lab_etl.m)
%
% Scripting support for extacting relevent data from log files.

% Key working settings
WORKING_DIR = 'C:\Users\Robert Zupko\git\SmallProjects\matlab\aps_lab\2018.09.19';

% Start by scanning for the directories that we care about
scanDirectory(WORKING_DIR)

function [] = scanDirectory(directory)
    contents = dir(directory);
    directoryNames = {contents([contents.isdir]).name};
    for name = directoryNames
        path = strcat(directory, '\', name);
        switch name{1}
            case 'Mototune'
                mototune(path{1})
            case 'Horiba'
                disp('Horiba')
            case 'CAS'
                disp('CAS')
            case 'Veristand'
                disp('Veristand')
        end
    end
end