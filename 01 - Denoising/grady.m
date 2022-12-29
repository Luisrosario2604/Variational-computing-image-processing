%% Esta función calcula el gradiente de una imagen en la dirección y (columnas)
function uy = grady(u)
% Rellenar:---------------------------------------------------------------%
uy = zeros(size(u)); % constante
uy(2:end-1, :, :) = 0.5*u(3:end, :, :)-0.5*u(1:end-2, :, :); % constante

%uy(1:end-1, :, :)=u(2:end,:,:) - u(1:end-1,:,:); % foreward
%uy(2:end,:,:)= u(2:end,:,:) - u(1:end-1,:,:); % backward
% ne pas oublier de changer les files et colomnes (en haut formule de x pas
% de y)
%-------------------------------------------------------------------------%
end