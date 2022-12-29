%% Esta función calcula las energías: Total, apriori y fidelidad.
function [energy, prior, fidelity]=Energy(u,f,lambda)
% Prior
dim = size(u);
Omega = dim(1)*dim(2);
ux = gradx(u,'forward');   
uy = grady(u,'forward'); 
% modGrad_p = sqrt(ux.^2 + uy.^2 + epzero*epsilon.^2).^p;
modGrad = sqrt( ux.^2 + uy.^2);
prior=sum(modGrad(:))/Omega;
% Fidelity
fidelity=(u-f).^2;
fidelity=sum(fidelity(:))/Omega;
% Total Energy
energy= fidelity + prior ; 
end