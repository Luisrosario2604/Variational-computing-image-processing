%% -----------------Fundamentos Matem�ticos - MOVA 2018----------------- %%
%                                                                         %
% I. Ramirez, E. Schiavi                                                  %
% URJC - Madrid 2018                                                      %
%%-----------------------------------------------------------------------%%
function [varout]= pLap(varin)
%-------------------------------------------------------------------------%
%                             STOP Criteria                               %
%-------------------------------------------------------------------------%
StopCriteria_u = 1e-6;
StopCriteria_e = 1e-6;
%-------------------------------------------------------------------------%
%                            Initializations                              %
%-------------------------------------------------------------------------%

p       = varin.p;
f       = varin.f;
u       = f;
lambda  = varin.lambda;
Nit     = varin.Nit;
dt      = varin.dt;
im_org  = varin.im_org;
Verbose = varin.Verbose;

epsilon = 1e-6;
switch Verbose
    case 0

    case 1

    case 2
        figure,
        set(gcf, 'Units', 'Normalized', 'OuterPosition', [0.15, 0.3, 0.7, 0.4]);
end


%-------------------------------------------------------------------------%
%                               Algorithm                                 %
%-------------------------------------------------------------------------%
for iter=1:Nit
    % Verbose
    switch Verbose
        case 0
            disp(['Iter: ',num2str(iter)])
            if ~mod(iter,100)
                imshow(u),pause(0.01)
            end
        case 1
            if ~mod(iter,100)
                imshow(u),pause(0.01)
            end
            [en(iter),pr(iter),fi(iter)] = pEnergy(u,f,lambda,p);
            psnr(iter) = PSNR(u,im_org);
            disp(['Iter: ',num2str(iter),' PSNR: ', num2str(psnr(iter)), ' Total Energy: ', num2str(en(iter)), ' Prior: ', num2str(pr(iter)), ' Fidelity: ',num2str(fi(iter)) ])
        case 2
            [en(iter),pr(iter),fi(iter)] = pEnergy(u,f,lambda,p);
            psnr(iter) = PSNR(u,im_org);
            subplot(131), imshow(u)
            subplot(132), plot(en,'r'), hold on,plot(fi,'b'),plot(pr,'g')
            legend('Total Energy','Fidelity','Prior'), grid on
            subplot(133), plot(psnr,'c'), legend('PSNR (db)'), grid on
            pause(0.01)
    end% Los par�metros se agrupan en un struct por simplicidad

%----------------------------- Completar ---------------------------------%

    % Algoritmo
    ux = gradx(u,'central');
    uy = grady(u,'central');
    
    b = sqrt(ux.^2 + uy.^2 + epsilon.^2).^(p-2);
    % Laplaciano   
    lap = gradx(b.*ux, 'central') + grady(b.*uy, 'central');
    % Descenso

    u  = u - dt*(-lap + lambda.*(u-f));
%----------------------------- Completar ---------------------------------%
end
% Variables de salida
if Verbose == 0
    varout.u        = u;
else
    varout.u        = u;
    varout.en       = en;
    varout.pr       = pr;
    varout.fi       = fi;
    varout.psnr     = psnr;
end
end

