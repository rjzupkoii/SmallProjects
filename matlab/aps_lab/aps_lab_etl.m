% APS Lab Extract, Transform, Load (aps_lab_etl.m)
%
% Scripting support for extacting relevent data from log files.

% Key working settings
WORKING_DIR = 'C:\Users\Robert Zupko\git\SmallProjects\matlab\aps_lab\2018.09.19';

% Setup the environment
addpath('./methods');
warning('OFF', 'MATLAB:mkdir:DirectoryExists');
warning('OFF', 'MATLAB:table:ModifiedAndSavedVarnames')

% Make sure our output exists
mkdir('out');

% Start by scanning for the directories that we care about
scanDirectory(WORKING_DIR)

function [] = scanDirectory(directory)
    % Find the directories to work with
    contents = dir(directory);
    directoryNames = {contents([contents.isdir]).name};
    directoryNames = setxor(directoryNames, {'.', '..'});
    for name = directoryNames        
        % Process the data
        sheet = [];
        path = strcat(directory, '\', name);
        switch name{1}
            case 'Mototune'
                sheet = mototune(path{1});
            case 'Horiba'
                sheet = horiba(path{1});
            case 'CAS'
                sheet = cas(path{1});
            case 'Veristand'
                sheet = veristand(path{1});
        end
        
        % Write the data to a worksheet
        file = strcat('out\', name, '.xlsx');
        xlswrite(file{1}, sheet)
    end
end