function [ Pros, phi ] = evolution( phi_0,Pix_foreground,Pix_background,Pxi_foreground,Pxi_background,  Args,Pros )
%evolution 新的分割算法。但是该算法由于目前未使用，因此其框架接口部分不做跟进。因此还不能在程序中使用。
%   此处显示详细说明
%   [ phi ] = evolution( phi_0,Pix_foreground,Pix_background,Pxi_foreground,Pxi_background,  Args,Pros )%  This Matlab code implements an edge-based active contour model as an
%  application of the Distance Regularized Level Set Evolution (DRLSE) formulation in Li et al's paper:
%  基于以下的文章下面做出改进。
%      C. Li, C. Xu, C. Gui, M. D. Fox, "Distance Regularized Level Set Evolution and Its Application to Image Segmentation",
%        IEEE Trans. Image Processing, vol. 19 (12), pp.3243-3254, 2010.
%


phi=reshape(phi_0,Pros.sizeOfImage(1),Pros.sizeOfImage(2));
Pix_foreground=reshape(Pix_foreground,Pros.sizeOfImage(1),Pros.sizeOfImage(2));
Pix_background=reshape(Pix_background,Pros.sizeOfImage(1),Pros.sizeOfImage(2));
Pxi_foreground=reshape(Pxi_foreground,Pros.sizeOfImage(1),Pros.sizeOfImage(2));
Pxi_background=reshape(Pxi_background,Pros.sizeOfImage(1),Pros.sizeOfImage(2));

Pros.iteration_inner=1;
while Pros.iteration_inner<=Args.numIteration_inner
    phi=NeumannBoundCond(phi);
    [phi_x,phi_y]=gradient(phi);
    sqrtOfPhi=sqrt(phi_x.^2 + phi_y.^2);
    smallNumber=1e-10;
    nx=phi_x./(sqrtOfPhi+smallNumber); % add a small positive number to avoid division by zero
    ny=phi_y./(sqrtOfPhi+smallNumber);
    [nxx,~]=gradient(nx);
    [~,nyy]=gradient(ny);
    curvature=nxx+nyy;
    deltaPhi=1./Args.epsilon*Pix_foreground.*Pix_background.*(log(Pxi_foreground./Pxi_background) + Args.beta.*curvature - Args.gamma);
    %     deltaPhi=mapminmax(deltaPhi,0,1);
    % update \phi .
    phi=phi + Args.timestep.*deltaPhi;
    
    
    Pros.iteration_inner=Pros.iteration_inner+1;
end
phi=reshape(phi,[],1);



end





function g = NeumannBoundCond(f)
% Make a function satisfy Neumann boundary condition
[nrow,ncol] = size(f);
g = f;
g([1 nrow],[1 ncol]) = g([3 nrow-2],[3 ncol-2]);
g([1 nrow],2:end-1) = g([3 nrow-2],2:end-1);
g(2:end-1,[1 ncol]) = g(2:end-1,[3 ncol-2]);
end

