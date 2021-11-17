function y = Priortization(Pd,Pb,Pg,EPT,Cg,Eb,Bcap)
y = -1;
SOCbmin = 0.2;SOCbmax = 0.8;
    if(Pd > 0)%Pv production is more than load
                if(Pb < 0 && (Eb-Pb*0.5) >= (SOCbmin*Bcap) && (Eb-Pb*0.5) <= (SOCbmax*Bcap) )    %charging        %Add condition for Energy
                    if(Pd > abs(Pb))
                        Pb2l = 0;
                        Ppv2b = -Pb;        %case-11
                        Pg2b = 0;
                        Pg2l = 0;
                        Pb1 = -Ppv2b - Pg2b;
                         
                    else
                        Pb2l = 0;
                        Ppv2b = Pd;        %case-12
                        Pg2b = -Pb - Pd;
                        Pg2l = 0;
                        Pb1 = -Ppv2b - Pg2b;
                         
                    end
                else %discharge
                    y = -1000;%infeasible             %case-14%case-15
                end
            else
                if(Pb < 0 && (Eb-Pb*0.5) >= (SOCbmin*Bcap) && (Eb-Pb*0.5) <= (SOCbmax*Bcap) ) %charging           %Add condition for Energy
                    if (Pg > abs(Pd))
                        Pb2l = 0;
                        Ppv2b = 0;          %case-7
                        Pg2l = -Pd;
                        Pg2b = Pg + Pd; % or -Pb
                        Pb1 = -Ppv2b - Pg2b;
                         
                    else
                        y = -1000;%infeasible         %case-8
                    end
                        %infeasible         %case-10%case-9
                elseif ((Eb-Pb*0.5) >= (SOCbmin*Bcap) && (Eb-Pb*0.5) <= (SOCbmax*Bcap) )%discharging                   %Add condition for Energy
                    if(EPT <= Cg)
                        if(Pb >= abs(Pd))
                            Pb2l = -Pd;     %case-4
                            Ppv2b = 0;
                            Pg2l = 0;
                            Pg2b = 0;
                            Pb1 = Pb2l;
%                             disp("success"); 
                        else
                            Pb2l = Pb;      %case-5
                            Ppv2b = 0;
                            Pg2l = -Pd-Pb2l;
                            Pg2b = 0;
                            Pb1 = Pb2l;
                             
                        end
                    else
                        if(Pg >= abs(Pd))
                            Pb2l = 0;
                            Ppv2b = 0;      %case-2
                            Pg2l = -Pd;
                            Pg2b = 0;
                            Pb1 = Pb2l;
                             
                        else
                            Ppv2b = 0;      %case-3
                            Pg2l = Pg;
                            Pb2l = -Pd - Pg2l;
                            Pg2b = 0;
                            Pb1 = Pb2l;
                             
                        end
                    end
                    else
                        y = -1000;  %infeasible
                end
    end
    if (y(1) == -1000)
    else
        y(1) = Ppv2b;
        y(2) = Pg2l;
        y(3) = Pb2l;
        y(4) = Pg2b;
        y(5) = Pb1;
        y(6) = Pg;
    end
end

            