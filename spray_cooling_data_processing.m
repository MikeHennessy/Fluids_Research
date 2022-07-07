% reads and interprets the cooldown data

clear all; clc; close all;

folderName = 'ExcelFilesSprayPattern\';                                                            % folder where the files are stored (modify folder name when necessary)
fs = matlab.io.datastore.FileSet(folderName);
fds = fileDatastore(fs, 'ReadFcn', @importdata);
fullFileNames = fds.Files;                                                                            % gathers the file names from the folder
numFiles = length(fullFileNames);                                                                     % number of files in the folder

for n = 1:numFiles
    % finding the right naming conventions and counts for the excel file
    sheetNames = sheetnames(fullFileNames{n});                                                        % creates an array of the sheet names in the excel file
    numTrials = length(sheetNames);                                                                   % counts the number of sheets in the excel file
    
    fullFileName = fullFileNames{n};                                                                  % extracts the file location
    indexBeforeFileName = strfind(fullFileName,'\');                                                  % extracts the index of the starting position of the file name
    fileName = fullFileName((indexBeforeFileName(end-1)+1):end);                                      % extracts the file name from the location
    

    allCompressedData = cell(1,numTrials);                                                            % creates an empty cell array to be filled with data from each sheet
    for i = 1:numTrials                                                                               % loops through each of the three sheets (if more sheets, change accordingly)
        % extracts the data set
        sheet = strcat('Sheet',int2str(i));
        data = readtable(fileName, 'Sheet', sheet, 'Range', 'A:K');                                   % extracts data from excel sheet; change title of excel file accordingly
    
        S = vartype('numeric');
        numericData = data{1:height(data), S};                                                        % converts data to an array of numeric variable types
        numericData(isnan(numericData)) = 0;                                                          % sets NaN values to 0
    
    
        % find the start time
        trial = zeros(height(data),3);                                                                % creates an array of zeros to be filled with data necessary to find slopes
        trial(:,1) = numericData(:,3);                                                                % fills the time value in column 1
        trial(:,2) = numericData(:,7);                                                                % fills the center thermocouple temperature in column 2
    
        for j = 1:(length(trial)-1)
            trial(j,3) = (trial(j+1,2) - trial(j,2))/(trial(j+1,1) - trial(j,1));                     % slopes are relative to the center thermocouple and assumed to be proportional to the other thermocouples
        end
    
        maxSlope = max(abs(trial(:,3)));                                                              % find max of column three, which is the maximum slope
        point_maxSlope = find(abs(trial(:,3)) == maxSlope);                                           % finds what row number contains the max slope, which correlates to the start time
        
    
        % creates new array with all necessary values for trial 1
        numPoints = (length(trial)-(point_maxSlope - 1));                                             % finds the number of points in the dataset after the point of max slope
        compressedData = zeros(numPoints,6);                                                          % creates an array of zeros to be filled with all necessary data for the trial
        compressedData(:,1) = numericData(point_maxSlope:end,3) - numericData(point_maxSlope,3);      % fills column 1 with the times starting at 0
        for k = 2:6
            compressedData(:,k) = numericData(point_maxSlope:end,(k+3));                              % fills columns with the temperatures of the corresponding thermocouples
        end
    
        allCompressedData{i} = compressedData;                                                        % adds the data to the cell array
    end
    
    
    % makes the data sets equal length
    minRows = length(allCompressedData{1});
    for i = 2:numTrials
        if length(allCompressedData{i}) < minRows
            minRows = length(allCompressedData{i});                                                   % finds the minimum number of rows of the trials
        end
    end
    
    for i = 1:numTrials
        allCompressedData{i} = allCompressedData{i}(1:minRows,:);                                     % updates the data sets to have the minimum number of rows
    end
    

    % interpolates the data
    interpolatedData = cell(1,numTrials);                                                             % creates an empty cell array to be filled with the interpolated data
    interpolatedData{1} = allCompressedData{1};                                                       % adds the first trial data set to the interpolated cell array
    for i = 2:numTrials
        tempData = zeros(minRows,6);                                                                  % creates an array of zeros to be filled with the interpolated data set
        tempData(:,1) = interpolatedData{1}(:,1);
        for j = 2:6
            tempData(:,j) = interp1(allCompressedData{i}(:,1),allCompressedData{i}(:,j),interpolatedData{1}(:,1)); % interpolates the data
        end
        interpolatedData{i} = tempData;                                                               % adds the interpolated data to the cell array
    end
    
    for i = 2:numTrials
        for j = 1:minRows
            for k = 2:6
                if isnan(interpolatedData{i}(j,k)) && (j <= minRows)                                  % checks for cases where the interpolation could not be done
                    minsRows = j;
                end
            end
        end
    end
    minRows = (minRows-1);
    
    for i = 1:numTrials
        interpolatedData{i} = interpolatedData{i}(1:minRows,:);                                       % updates the data sets to have the minimum number of rows
    end
    

    % finds the averages of the trials
    averages = zeros(minRows,6);                                                                      % creates an array of zeros to be filled with the averages of the trial data sets
    averages(:,1) = interpolatedData{1}(:,1);                                                         % adds the times to the final data set (the times are constant between trials in the interpolated data set)
    for j = 2:6
        for i = 1:minRows
            sum = 0;                                                                                  % resets the sum to 0
            for k = 1:numTrials                                                                       % loops through the columns, rows, and trials
                sum = sum + interpolatedData{k}(i,j);                                                 % sums the numbers from each trial
            end
            averages(i,j) = (sum / numTrials);                                                        % adds the average value into the final data set
        end
    end
    

    % finding the temperature from the naming convention
    indexBeforeTemp = strfind(fileName,'ff_') + 3;                                                    % extracts the index of the starting position of the temperature in the file name (modify for differing naming conventions)
    indexAfterTemp = strfind(fileName, '.xl') - 1;
    temp = fileName(indexBeforeTemp:indexAfterTemp);                                                  % extracts the temperature from the file name


    output = array2table(averages);                                                                   % converts the array to a table
    output.Properties.VariableNames = {'Time', 'Left', 'Top', 'Center', 'Right', 'Bottom'};           % adds column headers to the table


    writetable(output,'Spray_Pattern_Averages.xlsx', 'Sheet', temp)                                   % inputs the averages into a sheet of an excel file (modify the name of the excel file if necessary)
end