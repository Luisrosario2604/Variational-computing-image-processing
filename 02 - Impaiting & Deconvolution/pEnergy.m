function [energy,prior,lambda_fidelity]=pEnergy(u,f,lambda,p)
% Calculates TV(u)+lambda*||u-f||^2
dim = size(u);
Omega = dim(1)*dim(2);
ux       =gradx(u,'forward');
uy       =grady(u,'forward');
modGrad= sqrt(ux.^2+uy.^2 ).^p;
fidelity = (u-f).^2;
prior=(1/p)*sum(modGrad(:))/Omega;
fidelity=0.5*sum(fidelity(:))/Omega;
lambda_fidelity = sum((lambda(:)).*fidelity(:))/Omega;
energy= prior+lambda_fidelity;

end