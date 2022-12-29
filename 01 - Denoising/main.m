%% -----------------Fundamentos Matemáticos - MOVA 2017----------------- %%
%                                Práctica 3                               %
% I. Ramirez, E. Schiavi                                                  %
% URJC - Madrid 2018                                                      %
%%-----------------------------------------------------------------------%%
%
% En esta práctica vamos a implementar un algoritmo de difusión lineal. 
% El objetivo es restaurar una imagen que ha sido deteriorada con ruido
% (denoising).

%% Cargar datos (imágenes)

%im = imread('./Images/im4.jpg'); 
% Comprobamos el tipo de datos que tenemos (Workspace por ejemplo)
% im es una matriz 512x512 (1 solo canal) de tipo uint8 (enteros sin signo 
% de 8 bits) por tanto el rango de los valores es [0-255], 2^8 = 256 valores.
%im = im2double(im);
% im2double transforma los datos en tipo double y en el rango [0,1].
% En general trabajaremos en este rango por simplicidad.
%imshow(im)

im_tram = imread('./Img/Img1_reduced.jpg'); % Buena imagen
im_tram = imrotate(im_tram, 180);
%im_tram = imresize(im_tram, 0.7);
im_tram = im2double(im_tram);

im_pescador = imread('./Img/Img2_reduced.jpg'); 
im_pescador = imrotate(im_pescador, -90);
im_pescador = im2double(im_pescador);

im_lum = imread('./Img/Img3.jpg'); 
im_lum = im2double(im_lum);

im_nieve = imread('./Img/Img4.jpg'); % Buena imagen
im_nieve = im2double(im_nieve);

im_cast = imread('./Img/Img5.jpg'); % Buena imagen
im_cast = im2double(im_cast);

im_final = im_tram; % ELEGIR LA IMAGEN UTILIZADA (3 buenas imagenes posible)

imshow(im_final)


%% Deterioramos la imagen
small_noise = 0.05;
medium_noise = 0.15;
big_noise = 0.3;
very_big_noise = 0.6;

Noise_STD   = big_noise; % desviación típica del ruido AWGN
noise       = Noise_STD*randn(size(im_final));
im_blur     = im_final + noise;

%% Ver la imagen degradada
noisy = rgb2gray(im2uint8(im_blur));
% noisy = im2uint8(im_blur); % usar esta linea en vez de la de enzima si la
%                            imagen ya esta en negro y blanco
est_noise = estimate_noise(noisy);
disp(['Esimate noise : ', num2str(est_noise)]);
imshow(im_blur);

%% Selección de parámetros
close all
% Proporcionamos los parámetros para nuestro algoritmo
varin.lambda    = 0.4;      % hyperparámetro de fidelidad
varin.Nit       = 249;      % número de iteraciones del algoritmo
varin.dt        = 4e-2;     % tamaño del paso 
varin.f         = im_blur;  % imagen ruidosa
varin.Verbose   = 0;        % Verbose
varin.im_org    = im_final;       % Imagen original para el cómputo de la PSNR
% Los parámetros se agrupan en un struct por simplicidad

% Ejecutamos el algoritmo
[varout] = Denoising_Linear_Diffusion(varin); % I changer lineal to linear

% Mostramos el resultado
u = varout.u;

figure,
subplot(131), imshow(im_final), title('Original')
subplot(132), imshow(varin.f),  title('Ruidosa')
subplot(133), imshow(u),        title('Restaurada')