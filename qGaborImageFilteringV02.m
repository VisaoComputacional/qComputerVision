

% this function receives as input an image, a resolution of the convolution mask, and the
% q value to filter the image.
% input:
% im0: grayscale image (best if it is 256 x 256 in size, but can be
% any resolution;
% step: discretization of the qGabor function to build the required resolution. 
% You can use the ideal step values and the mask size they generate as the following values:
% step / N x N
% 0.6 -> 3 x 3
% 0.5 -> 5 x 5
% 0.3 -> 7 x 7
% 0.25 -> 9 x 9
% 0.19 -> 11 x 11
% 0.155 -> 13 x 13
% 0.139 -> 15 x 15
% 0.12 -> 17 x 17
% 0.11 -> 19 x 19
% 0.1 -> 21 x 21
% Ex: if you choose as step = 0.6, the code will generate a 3 x 3 convolution mask; 
% but if you choose step = 0.19, the code will generate a 11 x 11 convolution mask, and so on ..  
%
% q : non-estensive parameter. Please, use one of the following bellow:
% [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8
%
% output: 
% PSNR_ : signal to noise ratio(as higher better)
% Z : aGabor mask generated and used in the code
% imc : final image as a result of convolution of Z over im0 
%
% Autor: Paulo Sérgio Rodrigues, pslucano@gmail.com,
% www.fei.edu.br/~psesrgio, www.immersivelab.fei.edu.br
% Computer Science Department,
% Centro Universitário FEI,
% San Paul, Brazil
%
% March, 03, 2021 
%
% NOTE: this code was only possible to accomplish due to quarentine during the second and infinite wave of covid19 in Brazil
% % enjoi it! Please, cite us is you use it! you will help this and future developments for free

function [PSNR_, Z, imc] = qGaborImageFilteringV02(im0,step,q)

%close all

f = 100; % sinusiodal frequency

 % compute X and Y initial domain
 X = 0:step:1;
 Y = 0:step:1; 
 
 % qGabor build
 Z = psrqGabor3DV01(q,f,X,Y);
 
 X = [-X(length(X):-1:2) X]; % mirrors X in opposite direction
 Y = [-Y(length(Y):-1:2) Y]; % mirrors Y in opposite direction


% -------filtering-----------%
imc = conv2(im0,Z);
[lin0,col0] = size(im0);
[linc,colc] = size(imc);
difx = (colc - col0)/2;
dify = (linc - lin0)/2;

% normalization in order to further visualization
imc = imc(dify+1:linc-dify,difx+1:colc-difx);
M1=max(max(imc));
imc = 255.*(imc./M1);

% if you wish to plot, please, uncomment the following two lines
%subplot(2,2,1);imshow(im0);title('IMAGE ')
%subplot(2,2,2);imshow(uint8((imc)));title('filtered')

% computing the PSNR performance
PSNR_ = PSNR(double(im0),double(imc));

end


% this function generates a 3D matriz with a discrete qGabor to be a convolutional filter in a grayscale image
% It was build a an non-extensive version of the so called qGabor function,
% inspired in Tsallis non-extensive statistic
%
% input: 
% q : non-estensive parameter. Please, use one of the following bellow:
% [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8
% f : sinusiodal support frequency. After exaustive experimental tests, we
% advise set f = 100
% X and Y, are initial domain range over the qGabor will be build. This
% rande is only positive (e.x: X,Y = [0,..,1]) or for the first quadrant. 
% However, the qGabor 3D function 
% will be genetared centered at 0,0 point, and the around 360 degree values
% will be generates over the four quadrants. 
%
% output:
% Z : aGabor mask generated and used in the code

function  Z = psrqGabor3DV01(q,f,X,Y)

  % parameter of sinusiodal support
  Px = 100;
  Py = 100;
  
  % sinusional support frenquancy, in x and y directions
  fx = f;
  fy = f;
  
  % exponencial of the q-sigmoidal
  qex = 1 / (1-q);
  
  % build a qGabor only in the range of fourth quadrant
  for j=1:length(Y)
   for i=1:length(X)
      % qGaussian
      N = (1 + (1-q) * (X(i).^2 + Y(j).^2)).^qex;
    
      % qSigmoid (envelope)
      D1 = 1 / N;
      
      % sinusional support 
      D2 = sin((fx * X(i) - Px) + (fy * Y(j) - Py));
      
      % qGabor only in the fouth quadrant
      Z4(i,j) = real(D1 * D2);
   end
  end
    
  % now we build the qGabor simetrically in all the four uadrants
  L = length(X);
  Z4 = round(1000*Z4)/1000;
  Z = [Z4(L:-1:2,L:-1:2) Z4(L:-1:2,1:L); Z4(1:L,L:-1:2) Z4]; % einverte e quaduplica o Z

  % normaliza o Z
  M = max(max(Z));
  N = min(min(Z));
  Z = (Z - N) / (M - N);
  
  % enjoi it! Please, cite us is you use it! you will help this and future developments for free
    
end



