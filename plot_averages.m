% plots the averages from the specified excel sheet

sheet = '220C'                                                                       % modify this variable based on which sheet is desired
data = readtable('Spray_Pattern_Averages.xlsx', 'Sheet', sheet, 'Range', 'A:K'); % modify file name based on which data set is desired
S = vartype('numeric');
averages = data{1:height(data), S};                                                 % converts data to an array of numeric variable types

for i = 2:6
    scatter(averages(:,1),averages(:,i))                                            % plots each column in the data set
    hold on
end

% labeling the plot
legend('Left Thermocouple', 'Top Thermocouple', 'Center Thermocouple', 'Right Thermocouple', 'Bottom Thermocouple')
title(strcat('Scatterplot of Full Cooldown at ', sheet))
xlabel('Time Elapsed (Seconds)')
ylabel('Temperature (Centigrade)')
hold off
