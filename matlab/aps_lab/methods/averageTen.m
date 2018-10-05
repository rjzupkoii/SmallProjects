function [result] = averageTen(colNo, data)
    result = mean(data.data(end - 10:end, colNo));
end