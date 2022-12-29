%% -----------------Fundamentos Matem�ticos - MOVA 2018----------------- %%
%                                                                         %
% I. Ramirez, E. Schiavi                                                  %
% URJC - Madrid 2018                                                      %
%%-----------------------------------------------------------------------%%
function [varout]= pLap_Deconvolution(varin)
%-------------------------------------------------------------------------%
%                             STOP Criteria                               %
%-------------------------------------------------------------------------%
StopCriteria_u = 1e-6;
StopCriteria_e = 1e-6;
%-------------------------------------------------------------------------%
%                            Initializations                              %
%-------------------------------------------------------------------------%


kernel  = varin.kernel;
kernel_F= varin.kernel_F;
R           =@(x) real(ifft2(kernel_F.*fft2(x)));
RT          =@(x) real(ifft2(conj(kernel_F).*fft2(x)));

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
            
        case 1
            if ~mod(iter,100)
                imshow(u),pause(0.01)
            end
            [en(iter),pr(iter),fi(iter)] = pEnergy_R(u,f,lambda,p,R);
            psnr(iter) = PSNR(u,im_org);
            disp(['Iter: ',num2str(iter),' PSNR: ', num2str(psnr(iter)), ' Total Energy: ', num2str(en(iter)), ' Prior: ', num2str(pr(iter)), ' Fidelity: ',num2str(fi(iter)) ])
        case 2
            [en(iter),pr(iter),fi(iter)] = pEnergy_R(u,f,lambda,p,R);
            psnr(iter) = PSNR(u,im_org);
            subplot(131), imshow(u)
            subplot(132), plot(en,'r'), hold on,plot(fi,'b'),plot(pr,'g')
            legend('Total Energy','Fidelity','Prior'), grid on
            subplot(133), plot(psnr,'c'), legend('PSNR (db)'), grid on
            pause(0.01)
    end
%----------------------------- Completar ---------------------------------%

    % Algoritmo
    ux = gradx(u,'forward');
    uy = grady(u,'forward');
    
    b = sqrt(ux.^2 + uy.^2 + epsilon.^2).^(p-2);
    % Laplaciano   
    lap = div(b.*ux, b.*uy);
    % Descenso

    u = u - dt*(-lap + lambda*RT(R(u)-f));
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

