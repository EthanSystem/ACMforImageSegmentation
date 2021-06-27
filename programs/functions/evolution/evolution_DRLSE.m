function [ Pros, phi ] = evolution_DRLSE( phi_0, g, Args,Pros )
%evolution_DRLSE 。李春明的DRLSE模型。该算法由于目前未使用，因此其框架接口部分不做跟进。因此还不能在程序中使用。
%   此处显示详细说明
%   [ phi ] = evolution( phi_0,Pix_foreground,Pix_background,Pxi_foreground,Pxi_background,  Args,Pros )%  This Matlab code implements an edge-based active contour model as an
%  application of the Distance Regularized Level Set Evolution (DRLSE) formulation in Li et al's paper:
%  基于以下的文章下面做出改进。
%      C. Li, C. Xu, C. Gui, M. D. Fox, "Distance Regularized Level Set Evolution and Its Application to Image Segmentation",
%        IEEE Trans. Image Processing, vol. 19 (12), pp.3243-3254, 2010.
%


phi=reshape(phi_0,Pros.sizeOfImage(1),Pros.sizeOfImage(2));
[vx, vy]=gradient(g);

Pros.iteration_inner=1;
while Pros.iteration_inner<=Args.numIteration_inner
	phi=NeumannBoundCond(phi);
	[phi_x,phi_y]=gradient(phi);
	s=sqrt(phi_x.^2 + phi_y.^2);
	smallNumber=1E-15;
	Nx=phi_x./(s+smallNumber); % add a small positive number to avoid division by zero
	Ny=phi_y./(s+smallNumber);
	curvature=div(Nx,Ny);
	switch Args.potentialFunction
		case 'single-well'
			distRegTerm = 4*del2(phi)-curvature;  % compute distance regularization term in equation (13) with the single-well potential p1.
		case 'double-well'
			distRegTerm=distReg_p2(phi);  % compute the distance regularization term in eqaution (13) with the double-well potential p2.
		otherwise
			disp('Error: Wrong choice of potential function. Please input the string "single-well" or "double-well" in the drlse_edge function.');
	end
	
	dirac_phi=diracFunction(phi ,Args.epsilon, Args.heavisideFunctionType);
	areaTerm=dirac_phi.*g; % balloon/pressure force
	edgeTerm=dirac_phi.*(vx.*Nx+vy.*Ny) + dirac_phi.*g.*curvature;
	
	deltaPhi=Args.mu.*distRegTerm + Args.lambda.*edgeTerm + Args.alfa.*areaTerm;
	
	% update \phi .
	phi=phi + Args.timestep.*deltaPhi;
	
	
	Pros.iteration_inner=Pros.iteration_inner+1;
end

phi=reshape(phi,[],1);


return;
end

function f = distReg_p2(phi)
% compute the distance regularization term with the double-well potential p2 in eqaution (16)
[phi_x,phi_y]=gradient(phi);
s=sqrt(phi_x.^2 + phi_y.^2);
a=(s>=0) & (s<=1);
b=(s>1);
ps=a.*sin(2*pi*s)/(2*pi)+b.*(s-1);  % compute first order derivative of the double-well potential p2 in eqaution (16)
dps=((ps~=0).*ps+(ps==0))./((s~=0).*s+(s==0));  % compute d_p(s)=p'(s)/s in equation (10). As s-->0, we have d_p(s)-->1 according to equation (18)
f = div(dps.*phi_x - phi_x, dps.*phi_y - phi_y) + 4*del2(phi);
end


function f = div(nx,ny)
[nxx,junk]=gradient(nx);
[junk,nyy]=gradient(ny);
f=nxx+nyy;
end


function g = NeumannBoundCond(f)
% Make a function satisfy Neumann boundary condition
[nrow,ncol] = size(f);
g = f;
g([1 nrow],[1 ncol]) = g([3 nrow-2],[3 ncol-2]);
g([1 nrow],2:end-1) = g([3 nrow-2],2:end-1);
g(2:end-1,[1 ncol]) = g(2:end-1,[3 ncol-2]);
end

