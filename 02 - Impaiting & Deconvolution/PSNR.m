function psnr=PSNR(I1, I2)
% function psnr=PSNR(I1, I2)
% Funcion que calcula la Relaci?n Se?al a Ruido de Pico entre dos imagenes

if (size(I1)~=size(I2))
    error('Las im?genes tienen que tener el mismo tama?o');
end

maximo=max(max(I1(:)),max(I2(:)));
maximo = min(1,maximo);
N=size(I1,1);
M=size(I1,2);
P=size(I1,3);

if (P==1)
    MSE=(1/(M*N))*sum(sum((I1-I2).^2));
else
    MSE=(1/(M*N*P))*sum(sum(sum((I1-I2).^2)));
end
psnr=20*log10(maximo/sqrt(MSE));
end