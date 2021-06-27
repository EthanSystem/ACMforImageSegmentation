function [C1,C2]= binaryfit(Img,H_phi, numChannels) 
%   [C1,C2]= binaryfit(phi,U,epsilon) computes c1 c2 for optimal binary fitting 
%   input: 
%       Img: input image
%       H_phi: level set function calculated by heaviside function
%       numVar: number of channels
%   output: 
%       C1: a 1-by-numState vector to fit the image U in the region phi>0
%       C2: a 1-by-numState vector to fit the image U in the region phi<0
%  
%   Author: Chunming Li, all right reserved
%   email: li_chunming@hotmail.com
%   URL:   http://www.engr.uconn.edu/~cmli/research/

% modified at 2017/04/07 expanded to vector case . 
% ref: 	Chan, T. F. and B. Y. Sandberg, et al. (2000). "Active Contours without Edges for Vector-Valued Images." Journal of Visual Communication and Image Representation 11 (2): 130-141.
a= repmat(H_phi, 1, numChannels).*Img;
numer_1=sum(a,1); 
denom_1=sum(H_phi(:));
C1 = numer_1./denom_1;

b=(1-repmat(H_phi, 1, numChannels)).*Img;
numer_2=sum(b,1);
c=1-H_phi;
denom_2=sum(c(:));
C2 = numer_2./denom_2;
