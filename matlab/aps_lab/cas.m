% APS Lab Extract, Transform, Load (cas.m)
%
% This file contains CAS specific routines.

function [] = cas(directory)
    global casSheet;
    
    % Set the column headers if this is a new sheet
    if ~size(casSheet, 1)
        casSheet = {'Number', 'TestNo', 'Date'};
        for row = getColumns.'
            casSheet = [casSheet, row{1}];    %#ok
        end
    end
        
    % CAS files are in subdirectories organized by the test number
    contents = dir(directory);
    for ndx = 1 : length(contents)
        if ~contents(ndx).isdir 
            continue
        end
        if any(strcmp(contents(ndx).name, {'.', '..'})) 
            continue
        end
        path = strcat(directory, '\', contents(ndx).name);
        data = process(path, contents(ndx).name);
        casSheet = [casSheet; [size(casSheet, 1), data]]; %#ok
    end
end

function [columns] = getColumns() 
    columns = {'RPM', 'Mean';  % RPM.Timer
               'TorqueAverageRT', 'Mean';
               'CNG_FlowAverageRT', 'Mean';
               'Diesel_FlowAverageRT', 'Mean';
               'MAPAverageRT', 'Mean';
               'Cyl4IMEPRT', 'Mean';
               'Cyl5IMEPRT', 'Mean';
               'Cyl6IMEPRT', 'Mean';
               'Cyl4IMEPRT', 'COV';
               'Cyl5IMEPRT', 'COV';
               'Cyl6IMEPRT', 'COV';
               'Cyl4PeakRT', 'Mean';
               'Cyl5PeakRT', 'Mean';
               'Cyl6PeakRT', 'Mean';
               'Cyl4Peak LocRT', 'Mean';
               'Cyl5Peak LocRT', 'Mean';
               'Cyl6Peak LocRT', 'Mean';
               'Cyl4PMEPRT', 'Mean';
               'Cyl5PMEPRT', 'Mean';
               'Cyl6PMEPRT', 'Mean'};
end

function [results] = process(directory, testNo)
    % Open the datasum.csv file to get the results from
    path = strcat(directory, '\', 'datasum.csv');
    data = readtable(path);
    
    % Extract the relevent results
    results = {testNo, extractDate(directory)};
    for row = getColumns.'
        results = [results, extract(row{1}, data, row{2})]; %#ok
    end
end

function [result] = extract(parameter, table, column)
    ndx = find(not(cellfun('isempty', strfind(table.Parameter, parameter))));
    if isempty(ndx)
        disp(['WARNING: column ', parameter, ' not found']);
        result = -1;
    else        
        result = table.(column)(ndx);
    end
end