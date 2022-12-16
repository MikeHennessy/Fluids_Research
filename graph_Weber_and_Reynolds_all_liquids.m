% graphs the theta temperature vs log(Weber) or log(Reynolds numbers) for all liquids in the data set
% shape of the data points are based on the type of liquid (ethanol = circle, isopropanol = plus, isobutanol = diamond)
% color of the data points are based on the change of state of the droplet (evap = red, boil = blue, leidenfrost = green)
% theta = (temperature of surface - room temperature) / (saturation temperature - room temperature)


data = readtable('Processed_Data_All_Liquids.xlsx');                                          % modify file name based on which data set is desired

% initialize temperature constants (centigrade)
room_temp = 21;
saturation_temp_ethanol = 78.37;
saturation_temp_isopropanol = 82.5;
saturation_temp_isobutanol = 108;

% create 9 different empty data sets to be plotted
ethanol_evap = zeros(0,2);
ethanol_boil = zeros(0,2);
ethanol_leid = zeros(0,2);
ethanol_tran = zeros(0,2);
isopropanol_evap = zeros(0,2);
isopropanol_boil = zeros(0,2);
isopropanol_leid = zeros(0,2);
isobutanol_evap = zeros(0,2);
isobutanol_boil = zeros(0,2);
isobutanol_leid = zeros(0,2);

% append each plot to a data set
for i = 2:height(data)
    liquid_type = string(table2cell(data(i,6)));                                              % find the type of liquid from the data set
    type_of_change_of_state = string(table2cell(data(i,2)));                                  % find the type of state change from the data set
    if liquid_type == "Ethanol" & type_of_change_of_state == "Evap"                           % check for the liquid type and the type of change of state
        theta = (table2array(data(i,1)) - room_temp)/(saturation_temp_ethanol - room_temp);   % calculate theta based on the surface temperature
        ethanol_evap(end+1,1) = theta;                                                        % add the corresponding theta to the corresponding data set
        ethanol_evap(end,2) = table2array(data(i,7));                                         % add the corresponding Reynolds Number to the corresponding data set
        ethanol_evap(end,3) = table2array(data(i,8));                                         % add the corresponding Weber Number to the corresponding data set
    elseif liquid_type == "Ethanol" & type_of_change_of_state == "Boil"
        theta = (table2array(data(i,1)) - room_temp)/(saturation_temp_ethanol - room_temp);
        ethanol_boil(end+1,1) = theta;
        ethanol_boil(end,2) = table2array(data(i,7));
        ethanol_boil(end,3) = table2array(data(i,8));
    elseif liquid_type == "Ethanol" & type_of_change_of_state == "Leidenfrost"
        theta = (table2array(data(i,1)) - room_temp)/(saturation_temp_ethanol - room_temp);
        ethanol_leid(end+1,:) = theta;
        ethanol_leid(end,2) = table2array(data(i,7));
        ethanol_leid(end,3) = table2array(data(i,8));
    elseif liquid_type == "Ethanol" & type_of_change_of_state == "TransitionBoil"
        theta = (table2array(data(i,1)) - room_temp)/(saturation_temp_ethanol - room_temp);
        ethanol_tran(end+1,:) = theta;
        ethanol_tran(end,2) = table2array(data(i,7));
        ethanol_tran(end,3) = table2array(data(i,8));
    elseif liquid_type == "Isopropanol" & type_of_change_of_state == "Evap"
        theta = (table2array(data(i,1)) - room_temp)/(saturation_temp_isopropanol - room_temp);
        isopropanol_evap(end+1,:) = theta;
        isopropanol_evap(end,2) = table2array(data(i,7));
        isopropanol_evap(end,3) = table2array(data(i,8));
    elseif liquid_type == "Isopropanol" & type_of_change_of_state == "Boil"
        theta = (table2array(data(i,1)) - room_temp)/(saturation_temp_isopropanol - room_temp);
        isopropanol_boil(end+1,:) = theta;
        isopropanol_boil(end,2) = table2array(data(i,7));
        isopropanol_boil(end,3) = table2array(data(i,8));
    elseif liquid_type == "Isopropanol" & type_of_change_of_state == "Leidenfrost"
        theta = (table2array(data(i,1)) - room_temp)/(saturation_temp_isopropanol - room_temp);
        isopropanol_leid(end+1,:) = theta;
        isopropanol_leid(end,2) = table2array(data(i,7));
        isopropanol_leid(end,3) = table2array(data(i,8));
    elseif liquid_type == "Isobutanol" & type_of_change_of_state == "Evap"
        theta = (table2array(data(i,1)) - room_temp)/(saturation_temp_isobutanol - room_temp);
        isobutanol_evap(end+1,:) = theta;
        isobutanol_evap(end,2) = table2array(data(i,7));
        isobutanol_evap(end,3) = table2array(data(i,8));
    elseif liquid_type == "Isobutanol" & type_of_change_of_state == "Boil"
        theta = (table2array(data(i,1)) - room_temp)/(saturation_temp_isobutanol - room_temp);
        isobutanol_boil(end+1,:) = theta;
        isobutanol_boil(end,2) = table2array(data(i,7));
        isobutanol_boil(end,3) = table2array(data(i,8));
    elseif liquid_type == "Isobutanol" & type_of_change_of_state == "Leidenfrost"
        theta = (table2array(data(i,1)) - room_temp)/(saturation_temp_isobutanol - room_temp);
        isobutanol_leid(end+1,:) = theta;
        isobutanol_leid(end,2) = table2array(data(i,7));
        isobutanol_leid(end,3) = table2array(data(i,8));
    end
end

% plots each data set on the same graph
scatter(log10(ethanol_evap(:,2)),ethanol_evap(:,1),"r","o")                                          % switch from the 2nd column (Reynolds Number) to 3rd column (Weber Number)
hold on
scatter(log10(ethanol_boil(:,2)),ethanol_boil(:,1),"b","o")
hold on
scatter(log10(ethanol_leid(:,2)),ethanol_leid(:,1),"g","o")
hold on
scatter(log10(ethanol_tran(:,2)),ethanol_tran(:,1),"m","o")
hold on
scatter(log10(isopropanol_evap(:,2)),isopropanol_evap(:,1),"r","+")
hold on
scatter(log10(isopropanol_boil(:,2)),isopropanol_boil(:,1),"b","+")
hold on
scatter(log10(isopropanol_leid(:,2)),isopropanol_leid(:,1),"g","+")
hold on
scatter(log10(isobutanol_evap(:,2)),isobutanol_evap(:,1),"r","d")
hold on
scatter(log10(isobutanol_boil(:,2)),isobutanol_boil(:,1),"b","d")
hold on
scatter(log10(isobutanol_leid(:,2)),isobutanol_leid(:,1),"g","d")
hold on

% labeling the plot
legend('Evaporate', 'Boil', 'Leidenfrost', 'Transition Boil')
title(strcat('\theta vs. log_{10}(Reynolds Number) All Liquids'))                                          % switch between "Reynolds Number" and "Weber Number"
xlabel('log_{10}(Reynolds Number)')                                                                        % switch between "Reynolds Number" and "Weber Number"
ylabel('\theta = (T_{surface}-T_{\infty})/(T_{saturation}-T_{\infty})')
grid on
hold off