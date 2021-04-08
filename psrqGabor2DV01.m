

% This function is a implementation of a qGabor 2D function, a
% non-extensive version of the well known Gabor fucntion. The qGabor
% function is based on non-extsneive Tsallis Statistics, a generalization
% of extensive Boltzman-Gibbs-Shannon statistics. Our function was created
% to be used generally in diverse applicartions, but we have only applied
% it in Neural Networks as activation functions;
%
% input: 
% q : non-estensive parameter. Please, use one of the following bellow:
% [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8,1.9]
%
% f : sinusiodal support frequency. After exaustive experimental tests, we
% advise set f = 100
% X is the initial domain range over the qGabor will be build. This
% range is only positive (e.x: X = [0,..,1]) or for the first quadrant. 
% However, the qGabor 2D function will be genetared centered at 0 point, 
% and the around 180 degree values will be generates over the two (mirroled) quadrant. 
%
% output:
% Z : aGabor function generated
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
% enjoi it! Please, cite us is you use it! you will help this and future developments for free
%

function  Z = psrqGabor2DV01(q,f,X)

  % q power 
  ex = 1 / (1-q);
  
  % qGaussian
  D1 = (1 + (1-q) * X.^2).^ex;
  
  % qSigmoid
  D1 = 1 ./ D1;
      
  % sinusiodal envelop
  D2 = sin(f*X-30);
  
  % 2D qGabor
  Z = D1 .* D2;
 
  Z1 = Z(length(Z):-1:1); % inverte o Z
  Z = [Z1 Z(2:length(Z))] + 1; % replica o Z
  
  % normaliza o Z
  M = max(Z);
  N = min(Z);  
  Z = (Z - N) / (M - N);
  
end

