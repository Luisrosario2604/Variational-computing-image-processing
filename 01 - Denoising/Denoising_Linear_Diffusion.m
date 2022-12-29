%% -----------------Fundamentos Matemáticos - MOVA 2018----------------- %%
%                       Denoising - Linear Diffusion                      %
% I. Ramirez, E. Schiavi                                                  %
% URJC - Madrid 2018                                                      %
%%-----------------------------------------------------------------------%%
function [varout]= Denoising_Linear_Diffusion(varin)
%-------------------------------------------------------------------------%
%                             STOP Criteria                               %
%-------------------------------------------------------------------------%
StopCriteria_u = 1e-6;
StopCriteria_e = 1e-6;
%-------------------------------------------------------------------------%
%                            Initializations                              %
%-------------------------------------------------------------------------%
f       = varin.f;
u       = f; % semilla
lambda  = varin.lambda;
Nit     = varin.Nit;
dt      = varin.dt;
im_org  = varin.im_org;
Verbose = varin.Verbose;


if Verbose == 2
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
        case 1
            [en(iter),pr(iter),fi(iter)] = Energy(u,f,lambda);
            psnr(iter) = PSNR(u,im_org);
            disp(['Iter: ',num2str(iter),' PSNR: ', num2str(psnr(iter)), ' Total Energy: ', num2str(en(iter)), ' Prior: ', num2str(pr(iter)), ' Fidelity: ',num2str(fi(iter)) ])
        case 2
            [en(iter),pr(iter),fi(iter)] = Energy(u,f,lambda);
            psnr(iter) = PSNR(u,im_org);
            subplot(131), imshow(u)
            subplot(132), plot(en,'r'), hold on,plot(fi,'b'),plot(pr,'g')
            legend('Total Energy','Fidelity','Prior'), grid on
            subplot(133), plot(psnr,'c'), legend('PSNR (db)'), grid on
            pause(0.01)
    end
%----------------------------- Completar ---------------------------------%

    % Algoritmo
    ux = gradx(u);
    uy = grady(u);
    % Laplaciano   
    lap = div(ux,uy);
    wk = -lap + lambda*(u-f); % completar
    % Descenso
    u  = u - dt * wk; % completar
    
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


