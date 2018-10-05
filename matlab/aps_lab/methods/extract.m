function [result] = extract(colName, method, data)
    % Scan for the column name
    for ndx = 1 : length(data.colheaders)
        if strcmp(colName, data.colheaders(ndx))           
            result = method(ndx, data);
            return
        end
    end
    
    % Note a warning
    disp(['WARNING: column ', colName, ' not found'])
    result = -1;
end