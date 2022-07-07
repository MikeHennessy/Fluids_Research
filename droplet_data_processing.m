% reads the tracking excel files and gathers data from them
% reads the temperature and type of droplet from the file name
% calculates the average diameter, average velocity, and average time for change of state of the droplets
% outputs a row array of these five variables and writes it into an excel file

% Get a list of all xlsx files in the given folder
folderName = 'PCC_Droplet_Tracking_Spreadsheets_Ethanol\';       % folder where the files are stored (modify folder name)
fs = matlab.io.datastore.FileSet(folderName);
fds = fileDatastore(fs, 'ReadFcn', @importdata);
fullFileNames = fds.Files;                                      % gathers the file names from the folder
numFiles = length(fullFileNames);                               % number of files in the folder

% Loop over all files
for k = 1 : numFiles
    fullFileName = fullFileNames{k};                            % extracts the file location
    indexBeforeFileName = strfind(fullFileName,'\');            % extracts the index of the starting position of the file name
    fileName = fullFileName((indexBeforeFileName(end-1)+1):end);% extracts the file name from the location

    output = [""];                                              % creates an empty array to fill with output variables

    file1 = readtable(fileName, "Range",'D1:H7');
    file2 = readtable(fileName, "Range",'D9:G16');
    
    % finding output 1: temperature
    indexBeforeTemp = strfind(fileName,'-dt') + 6;              % extracts the index of the starting position of the temperature
    indexAfterTemp = strfind(fileName,'C') - 1;                 % extracts the index of the ending position of the temperature
    temp = fileName(indexBeforeTemp:indexAfterTemp(end));       % extracts the temperature from the file name
    output(1) = temp;
    
    % finding output 2: type of droplet
    columnName = file1.Properties.VariableNames{3};             % extracts the column name with the type of droplet
    indexBeforeType = strfind(columnName,'__') + 2;             % extracts the index of the starting position of the type
    type = columnName(indexBeforeType:end);                     % extracts the type of droplet from the column name
    output(end+1) = type;
    
    % finding the number of droplets
    S = vartype('numeric');
    file1Numeric = file1{1:6,S};                                % converts file1 to an array of numeric variable types
    file1Numeric(isnan(file1Numeric)) = 0;                      % sets NaN values to 0
    numDrops = 0;
    for i = 1:height(file1Numeric)                              % gets the number of drops dispensed in the file
        if file1Numeric(i,2) ~= 0
            numDrops = numDrops + 1;
        end
    end
    
    % finding the sum of the times to evap / boil / leid
    sumsOfColumns1 = sum(file1Numeric,1);                       % calculates the sum of each column of the array
    sumTime = sumsOfColumns1(4);                                % extracts the sum of the time for change of state of the drops
    
    % finding the sums of the diameters, velocities, and times between drops
    file2Numeric = file2{1:6,S};                                % converts file2 to an array of numeric variable types
    file2Numeric(isnan(file2Numeric)) = 0;                      % sets NaN values to 0
    sumsOfColumns2 = sum(file2Numeric,1);                       % calculates the sum of each column of the array
    sumDiam = sumsOfColumns2(1);                                % extracts the sum of the diameters of the drops
    sumVel = sumsOfColumns2(2);                                 % extracts the sum of the velocities of the drops
    
    % finding outputs 3, 4, and 5: average diameter, average velocity, and average time to evap / boil / leid
    avgDiam = sumDiam / numDrops;
    output(end+1) = num2str(avgDiam);
    avgVel = sumVel / numDrops;
    output(end+1) = num2str(avgVel);
    avgTime = sumTime / numDrops;
    output(end+1) = num2str(avgTime)
    
    range = strcat('A',int2str((k+1)),':','E',int2str((k+1)));
    writematrix(output,'Processed_Data.xlsx', 'Sheet', 1, 'Range', range) % inputs the output array into a row of an excel file (modify the name of the excel file and sheet name if necessary)

end