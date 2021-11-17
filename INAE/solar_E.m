function E = solar_E()
    In = xlsread('Direct-solar.csv');
    Id = xlsread('Diffuse-solar.csv');
    Tair = xlsread('Tair.csv','F1:S12');
    Z = xlsread('Elevation.csv');
    Sun_h = xlsread('Sun-hours.csv');
    PVn = 0.21;     %Solar PV efficiency = 15%
    PVsys = 0.85;     %Efficiency of system used for storage and distribution = 85%
    NOCT = 48;          %Normal Operating Cell Temperature, average can be taken as 48 C
    N = 1:31:360;       %One day is chosen from each month to calculate declination angle
    thetai = zeros(12,14);
    for i = 1:12
        thetai(i,:) = incident(N(i));
    end
    thetaz = 90-Z;
    B = 20;
    albedo = 0.2;
    sz = size(Z);
    %Calculating total solar radiance using diffuse and direct radiation and various angles
    It = In.*cosd(thetai(:,1:sz(2))) + Id.*(1 + cosd(B))/2 + albedo*(In.*cosd(thetaz) +Id)*(1-cosd(B))/2;  
    
    
    Esol = 277.8*It.*Sun_h;     %Converting Esol in MJ to watt hours using conversion factor 277.8 and sunshine hours
    disp(Esol);
    disp(sum(sum(Esol)));
    %Calculating temperature of PV panel using temperature of air
    Tpanel = Tair + ((NOCT-20)/800)*277.7*It;
    %Calculating Solar power that can be generated from the panels
    %Also accounting for various efficiences and temperature variations
    Epv = Esol.*PVn*PVsys.*(1-0.5.*(Tpanel-25)/100);
    
    csvwrite('Epv_perm2.csv',Epv);
    disp(sum(sum(Epv)));
end