%% -----------------Fundamentos Matem�ticos - MOVA 2018----------------- %%
%                        Pr�ctica 2  - Deconvolution                      %
% I. Ramirez, E. Schiavi                                                  %
% URJC - Madrid 2018                                                      %
%%-----------------------------------------------------------------------%%


%% Cargar datos (im�genes)
clear all, close all, clc
im = imread('./Img/Img1_reduced.jpg'); 
%im = imread('./Images/im4.jpg'); 
im = imrotate(im, 180);
im = rgb2gray(im);

% Comprobamos el tipo de datos que tenemos (Workspace por ejemplo)
% im es una matriz 512x512 (1 solo canal) de tipo uint8 (enteros sin signo 
% de 8 bits) por tanto el rango de los valores es [0-255], 2^8 = 256 valores.
im = im2double(im);

% im2double transforma los datos en tipo double y en el rango [0,1].
% En general trabajaremos en este rango por simplicidad.
% imshow(im)

%% Deterioramos la imagen
Noise_STD = 0.1;
% LOAD MOTION KERNEL
dim = size(im);
load kernels.mat;
kernel = kernel4;
kernel_F = psf2otf(kernel,[dim(1),dim(2)]);
% TRANSFORMATION KERNEL + NOISE
R           =@(x) ifft2(kernel_F.*fft2(x));
RT          =@(x) ifft2(conj(kernel_F).*fft2(x));
im_blur = R(im);
im_blur = im_blur + Noise_STD*randn(size(im));

%%
imshow(im_blur)


%% Selecci�n de par�metros p = 2
close all
% Proporcionamos los par�metros para nuestro algoritmo
varin.lambda    = 2;      % hyperpar�metro de fidelidad
varin.Nit       = 615;      % n�mero de iteraciones del algoritmo
varin.dt        = 5e-2;     % tama�o del paso 
varin.f         = im_blur;  % imagen ruidosa
varin.Verbose   = 0;        % Verbose
varin.im_org    = im;       % Imagen original para el c�mputo de la PSNR
varin.p         = 2;
varin.kernel    = kernel;
varin.kernel_F  = kernel_F;

% Ejecutamos el algoritmo
[varout] = pLap_Deconvolution(varin);

% Mostramos el resultado
u2 = varout.u;

figure,
subplot(131), imshow(im),       title('Original')
subplot(132), imshow(varin.f),  title('Ruidosa')
subplot(133), imshow(u2),       title('Restaurada')
%%
disp(['p=2: ',num2str(PSNR(im,u2)),' db'])

%% Selecci�n de par�metros p = 1
close all
% Proporcionamos los par�metros para nuestro algoritmo
varin.lambda    = 50;      % hyperpar�metro de fidelidad
varin.Nit       = 197;      % n�mero de iteraciones del algoritmo
varin.dt        = 5e-3;     % tama�o del paso 
varin.f         = im_blur;  % imagen ruidosa
varin.Verbose   = 0;        % Verbose
varin.im_org    = im;       % Imagen original para el c�mputo de la PSNR
varin.p         = 1;
varin.kernel    = kernel;
varin.kernel_F  = kernel_F;

% Ejecutamos el algoritmo
[varout] = pLap_Deconvolution(varin);

% Mostramos el resultado
u1 = varout.u;

figure,
subplot(131), imshow(im),       title('Original')
subplot(132), imshow(varin.f),  title('Ruidosa')
subplot(133), imshow(u1),       title('Restaurada')
%%
disp(['p=1: ',num2str(PSNR(im,u1)),' db'])

%% Comparación con métodos de matlab
close all
[u_matlab, LAGRA] = deconvreg(im_blur, kernel,[],2);

figure, 
subplot(221), imshow(u_matlab), title(['Deconvreg-L2: ',num2str(PSNR(im,u_matlab)),' db'])
subplot(222), imshow(u2),       title(['p=2: ',num2str(PSNR(im,u2)),' db'])
subplot(223), imshow(u1),       title(['p=1: ',num2str(PSNR(im,u1)),' db'])
subplot(224), imshow(im_blur),  title(['Degradada: ',num2str(PSNR(im,im_blur)),' db'])