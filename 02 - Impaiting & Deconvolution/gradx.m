%% Esta función calcula el gradiente de una imagen en la dirección x (filas)
function ux = gradx(u,type)
% Rellenar:---------------------------------------------------------------%
switch type
    case 'central'
        ux=zeros(size(u));
        ux(:,2:end-1, :)=0.5*u(:,3:end,:)-0.5*u(:,1:end-2,:);
    case 'forward'
        ux=zeros(size(u));
        ux(:,1:end-1, :)=u(:,2:end,:) - u(:,1:end-1,:);
    case 'backward'
        ux=zeros(size(u));
        ux(:,2:end, :)= u(:,2:end,:) - u(:,1:end-1,:);
%-------------------------------------------------------------------------%
end