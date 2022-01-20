clear all
% Reading data from the link
file = 'http://strega.ldeo.columbia.edu:81/CMIP5/.byScenario/.historical/.atmos/.mon/.tas/.CCSM4/.r1i1p1/dods';
lon = ncread(file,'lon');
lat = ncread(file,'lat');
tas = ncread(file,'tas');
ncdisp(file)
% tas has a size of 288-by-192-by-1872, that is longitude-by-latitude-by-month
% Now calculating annual mean and area mean
% tas is from Jan-1850 to Dec-2005, so 156 years, 12 months per year
% We reshape the size of tas so that it has 4 dimensions, which are longitude-by-latitude-by-12-by-year
tas = reshape(tas,[length(lon) length(lat) 12 156]);
% Averaging the data over 12 months
tas = squeeze(mean(tas,3));
% Calculating area average below
% Step 01: an average over all longitudinal points so that tas now has a size of latitude-by-year
tas = squeeze(mean(tas,1));
% Step 02: Calculating the weighted mean by calculating weighted mean by Cos(lat)
for year = 1:156
tas_mean(year) = sum(squeeze(tas(:,year)).*cosd(lat))/sum(cosd(lat));
% Step 03: converting the temperature from Kelvin to Celsius
tas_mean(year) = tas_mean(year) - 273;
end

% Finally, plotting the global annual mean surface temperature against time
x = 1:1:156;
y = tas_mean(x);
plot(1850:2005,y)
xlabel('Years');
ylabel('Temperature (in Celsius)');
title('Global Annual Mean Surface Air Temperature');
legend('Temp','location','northwest');

% Calcultating the trend using the detrend function
detrend_tas_mean = detrend(tas_mean);
trend = tas_mean - detrend_tas_mean;
hold on
plot(1850:2005,trend,':r')
legend('Temp','Trend','Location','northwest');
hold off

% For calculating the linear trend, firstly we define a new dataset and assign the values to it
dataset1 =[];
for n = 1:137
tas_mean1 = tas_mean(n:n+19);
year = 1850:2005
tas_mean2 = year(n:n+19)
trend1 = polyfit(tas_mean2, tas_mean1, 1)
dataset1 = [dataset1; trend1];
end
% Plotting the slope for the trend of 20 year period average
slope01 = dataset1(:,1);
plot(1850:1986,slope01,':r')
disp(max(trend1));
disp(min(trend1));