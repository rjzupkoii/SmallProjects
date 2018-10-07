% APS Lab Extract, Transform, Load (aps_lab_etl.m)
%
% Scripting support for extacting relevent data from log files.

% Key working settings
clearvars -global;
WORKING_DIR = 'C:\Users\Robert Zupko\git\SmallProjects\matlab\aps_lab\';

% Setup the environment
addpath('./methods');
warning('OFF', 'MATLAB:mkdir:DirectoryExists');
warning('OFF', 'MATLAB:table:ModifiedAndSavedVarnames')
warning('OFF', 'MATLAB:xlswrite:AddSheet' ) ;

% Make sure our output exists
mkdir('out');

% Start by scanning for the directories that we care about
process(WORKING_DIR)

function [] = process(directory) 
    % Prepare the worksheet variables
    global casSheet horibaSheet mototuneSheet veristandSheet;
    
    % Scan the directory provided, process subdirectories that have data
    for name = getSubDirectories(directory)
        result = regexp(name, '\d{4}\.\d{2}\.\d{2}');
        if result{1}
            path = strcat(directory, '\', name);
            scanSubDirectory(path{1});
        end
    end
    
    % Write the worksheets to the s
	xlswrite('out\asp_lab.xlsx', casSheet, 'CAS');
    xlswrite('out\asp_lab.xlsx', horibaSheet, 'Horiba');
    xlswrite('out\asp_lab.xlsx', mototuneSheet, 'Mototune');
    xlswrite('out\asp_lab.xlsx', veristandSheet, 'Veristand');
end

function [] = scanSubDirectory(directory)
    % Find the sub directories to work with
    contents = dir(directory);
    directoryNames = {contents([contents.isdir]).name};
    directoryNames = setxor(directoryNames, {'.', '..'});
    for name = directoryNames        
        % Process the data
        path = strcat(directory, '\', name);
        switch name{1}
            case 'Mototune'
                mototune(path{1});
            case 'Horiba'
                horiba(path{1});
            case 'CAS'
                cas(path{1});
            case 'Veristand'
                veristand(path{1});
        end
    end
end