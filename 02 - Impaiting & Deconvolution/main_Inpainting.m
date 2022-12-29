%% -----------------Fundamentos Matematicos - MOVA 2017----------------- %%
%                         Pr�ctica 4  - Inpainting                        %
% I. Ramirez, E. Schiavi                                                  %
% URJC - Madrid 2017                                                      %
%%-----------------------------------------------------------------------%%


%% Cargar datos (im�genes)
clear all, close all, clc
im = imread('./Img/Img1_reduced.jpg'); 
im = imrotate(im, 180);
im = rgb2gray(im);

%im = imread('./Images/im1.jpg');

% Comprobamos el tipo de datos que tenemos (Workspace por ejemplo)
% im es una matriz 512x512 (1 solo canal) de tipo uint8 (enteros sin signo 
% de 8 bits) por tanto el rango de los valores es [0-255], 2^8 = 256 valores.
im = im2double(im);
% im2double transforma los datos en tipo double y en el rango [0,1].
% En general trabajaremos en este rango por simplicidad.
% imshow(im)

% Deterioramos la imagen
Noise_STD   = 0.05; % desviaci�n t�pica del ruido AWGN
noise       = Noise_STD*randn(size(im));
im_blur     = im + noise;

mask = ones(size(im));
%% Selección de región a reconstruir
% mask = double(rand(size(im))>0.95);
% mask = repmat(double(mask(:,:,1)),1,1,3);
close all
imshow(im)
set(gcf,'units','normalized','outerposition',[0 0 1 1])

h = imfreehand;
mask_temp = 1.-h.createMask;
mask_temp = repmat(double(mask_temp(:,:,1)),1,1,3);
mask = mask_temp.*mask;
lambda = mask;

%%
imshow(lambda);

%%
imshow(im_blur)

%% Selecci�n de par�metros p = 2
close all
% Proporcionamos los par�metros para nuestro algoritmo
varin.lambda    =  100*lambda;      % hyperparemetro de fidelidad
varin.Nit       =  855;      % n�mero de iteraciones del algoritmo
varin.dt        =  1e-2;     % tama�o del paso 
varin.f         = im_blur;  % imagen ruidosa
varin.Verbose   = 0;        % Verbose
varin.im_org    = im;       % Imagen original para el c�mputo de la PSNR
varin.p         = 2;

% Ejecutamos el algoritmo
[varout] = pLap(varin);

% Mostramos el resultado
u2 = varout.u;

figure,
subplot(131), imshow(im),       title('Original')
subplot(132), imshow(varin.f),  title('Ruidosa')
subplot(133), imshow(u2),       title('Restaurada')


%% Selecci�n de par�metros p = 1
close all
% Proporcionamos los par�metros para nuestro algoritmo
varin.lambda    =   100 * lambda;      % hyperpar�metro de fidelidad
varin.Nit       =  622;      % n�mero de iteraciones del algoritmo
varin.dt        =  1e-2;     % tama�o del paso 
varin.f         = im_blur;  % imagen ruidosa
varin.Verbose   = 0;        % Verbose
varin.im_org    = im;       % Imagen original para el c�mputo de la PSNR
varin.p         = 1;

% Ejecutamos el algoritmo
[varout] = pLap(varin);

% Mostramos el resultado
u1 = varout.u;

figure,
subplot(121), imshow(im),       title('Original')
subplot(122), imshow(u1),     title('Restaurada')

%% Tests p = 0.75
close all
% Proporcionamos los par�metros para nuestro algoritmo
varin.lambda    =  100*lambda;      % hyperparemetro de fidelidad
varin.Nit       =  500;      % n�mero de iteraciones del algoritmo
varin.dt        =  1e-2;     % tama�o del paso 
varin.f         = im_blur;  % imagen ruidosa
varin.Verbose   = 0;        % Verbose
varin.im_org    = im;       % Imagen original para el c�mputo de la PSNR
varin.p         = 0.75;

% Ejecutamos el algoritmo
[varout] = pLap(varin);

% Mostramos el resultado
u075 = varout.u;

figure,
subplot(121), imshow(im),       title('Original')
subplot(122), imshow(u075),     title('Restaurada')

%%
close all
figure, 
subplot(221), imshow(u2),   title(['p = 2'])
subplot(222), imshow(u1),   title(['p = 1'])
subplot(223), imshow(u075), title(['p = 0.75'])
subplot(224), imshow(im),   title(['Original'])