%% Esta función calcula las energías: Total, apriori y fidelidad.
function [energy, prior, fidelity]=Energy(u,f,lambda)

ux = gradx(u);
uy = grady(u);

% Prior
dim = size(u);
dim_total = dim(1)*dim(2);

m_gradient = sqrt(ux.^2 + uy.^2);
prior = sum(m_gradient(:).^2) / dim_total * 0.5; %rend un vecteur au lieu de la matrice

fi = (u-f).^2;
fidelity = sum(lambda(:).*fi(:) / dim_total) * 0.5;


%p = 1; % in p p 
%decenso_grad_u = sqrt(ux + uy); % Point for applicate ² at all values
%decenso_grad_u = sqrt(ux.^2 + uy.^2); % Point for applicate ² at all values
%u_minus_f = u - f;

%Tikhonov = (1/2 * dim_total * decenso_grad_u.^2) + (lambda / 2 * dim_total * (u_minus_f.^2));
%energy = (dim_total * decenso_grad_u) + (lambda / 2 * dim_total * (u_minus_f.^2));
%p_Laplacian_energy = (1/p * dim_total * decenso_grad_u.^p) + (lambda / 2 * dim_total * (u_minus_f.^2));

%prior= (1/(2*dim_total)) * sum((u_grad).^2);
% Fidelity
%fidelity= (1/(2*dim_total))*sum(lambda.*((u_grad-f).^2));

% Total Energy
energy= prior + fidelity; 
end