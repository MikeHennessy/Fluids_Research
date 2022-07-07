% graphs the theta value versus time of all of the temperatures

fileName = 'Continuous_Spray_Averages.xlsx';                                       % modify file name if necessary
sheetNames = sheetnames(fileName)                                                  % creates an array of the sheet names in the excel file
numSheets = length(sheetNames);                                                    % counts the number of sheets in the excel file
legendLabels = strings(1,numSheets);                                               % creates an empty legend to be filled with the names of each sheet and added to the plot

for i = 2:numSheets                                                                % loops through all the sheets in the file (assuming the first sheet is empty; change the '2' to '1' if not)
    sheetName = convertStringsToChars(sheetNames(i));                              % gets the sheet name, which corresponds to the surface temperature
    file = readtable(fileName, 'Sheet',sheetName);                                 % extracts the data from the sheet
    legendLabels(1,(i-1)) = sheetName;                                             % adds the sheet name to the legend

    S = vartype('numeric');
    data = file{1:height(file), S};                                                % converts data to an array of numeric variable types
    
    initialSurfaceTemp = str2num(sheetName(1:(end-1)));                            % extracts the surface temperature from the file name
    ambientTemp = 22;                                                              % change this based on the temperature of the room where the data is taken
    
    thetas = zeros(length(data),1);                                                % creates an array of zeros to be filled with theta values
    for i = 1:length(data)
        temp = (data(i,2) + data(i,3) + data(i,4) + data(i,5) + data(i,6)) / 5;    % gets the average temperature of the 5 thermocouples
        thetas(i,1) = ((temp - ambientTemp)/(initialSurfaceTemp - ambientTemp));   % calculates the theta value based on the current temperature and adds it to the array of theta values    
    end
    
    scatter(data(:,1),thetas)                                                      % plots the data for the sheet
    hold on
end

% labeling the plot
legend(legendLabels)
title('\theta vs. Time at Various Surface Temperatures')
xlabel('Time Elapsed (Seconds)')
ylabel('\theta')
hold off
