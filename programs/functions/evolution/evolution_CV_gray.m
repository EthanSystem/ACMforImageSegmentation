function [ Pros, phi, heaviside_phi, dirac_phi ] = evolution_CV_gray(Pros, image_original, image_processed, phi0)
% evolution_CV ：CV模型[4]，基于李春明的代码。
%   This function updates the level set function according to the CV model
%   input:
%       I: input image
%       phi0: level set function to be updated
%       mu: weight for length term
%       nu: weight for area term, default value 0
%       lambda1:  weight for c1 fitting term
%       lambda2:  weight for c2 fitting term
%       muP: weight for level set regularization term
%       timestep: time step
%       epsilon: parameter for computing smooth Heaviside and dirac function
%       numIter: number of iterations
%   output:
%       phi: updated level set function
%
%   created on 04/26/2004
%   Author: Chunming Li, all right reserved
%   email: li_chunming@hotmail.com
%   URL:   http://www.engr.uconn.edu/~cmli/research/


%% initialization
[numRow, numCol, ~] = deal(Pros.sizeOfImage(1),Pros.sizeOfImage(2),Pros.sizeOfImage(3));
numVar = 1;
numPixels =numRow * numCol ;
phi= phi0;
data=256.*double(rgb2gray(image_original));

% 停机条件
oldBwData=zeros(numPixels,1);
oldBwData(phi<=0)=1;
oldBwData = im2bw(oldBwData);
numPixelChanged = numPixels;
%% evolution
while (Pros.iteration_outer<=Pros.numIteration_outer && numPixelChanged>=Pros.numPixelChangedToContinue)
	phi=reshape(phi, numRow, numCol);	% reshape \phi
	phi=NeumannBoundCond(phi);
	curvature = CURVATURE(phi,'cc');
	dirac_phi = diracFunction(phi, Pros.epsilon, Pros.heavisideFunctionType);
	heaviside_phi = heavisideFunction( phi, Pros.epsilon, Pros.heavisideFunctionType );
	
	% 规则化项
	sumxxa= heaviside_phi.*data;
	numer_1=sum(sumxxa(:));
	denom_1=sum(heaviside_phi(:));
	C1 = numer_1./denom_1;
	sumxxb=(1-heaviside_phi).*data;
	numer_2=sum(sumxxb(:));
	inverseHeaviside_phi=1-heaviside_phi;
	denom_2=sum(inverseHeaviside_phi(:));
	C2 = numer_2./denom_2;
	regularTerm = Pros.lambda1*(data-C1).^2 - Pros.lambda2*(data-C2).^2;
	
	% 长度项
	edgeTerm = curvature;
	
	
	% 面积项
	areaTerm = ones(numRow, numCol);
	
	% 改变量
	L_phi = dirac_phi.*(Pros.gamma.*areaTerm + Pros.beta.*edgeTerm - regularTerm);
	
	% updating the phi function
	phi=phi+Pros.timestep.*L_phi;
	
	
	
	
	
	
	% old
	% 		% updating the phi function
	% 	phi=phi+Pros.timestep*(dirac_phi.*(Pros.nu-Pros.lambda1*(data-C1).^2+Pros.lambda2*(data-C2).^2));
	
	
	%% visualization
	if strcmp(Pros.isNotVisiualEvolutionAtAll,'no')
		% 生成\phi 分割得到的二值图数据
		bwData=zeros(numPixels,1);
		bwData(phi<=0)=1;
		bwData = im2bw(bwData);
		
		[Pros]=visualizeContours_CV(Pros, image_original, image_processed, phi, bwData, areaTerm ,regularTerm , edgeTerm, dirac_phi, L_phi);
	end
	%% write data
	if strcmp(Pros.isNotWriteDataAtAll,'no')
		% 生成\phi 分割得到的二值图数据
		bwData=zeros(numPixels,1);
		bwData(phi<=0)=1;
		bwData = im2bw(bwData);
		
		[Pros ] = writeData_CV(Pros, image_original, image_processed, phi, bwData, Pix, Px, Pxi, P_x_and_i, Pi_vis, Pi, mu, Sigma);
	end
	
	%%
	bwData=zeros(numPixels,1);
	bwData(phi<=0)=1;
	bwData = im2bw(bwData);
	pixelChanged = xor(bwData, oldBwData);
	numPixelChanged = sum(pixelChanged(:));
	oldBwData = bwData;
	Pros.iteration_outer = Pros.iteration_outer+1;		% iteration add 1
end % end loop




return;
end




function g = NeumannBoundCond(f)
% Make a function satisfy Neumann boundary condition
[nrow,ncol] = size(f);
g = f;
g([1 nrow],[1 ncol]) = g([3 nrow-2],[3 ncol-2]);
g([1 nrow],2:end-1) = g([3 nrow-2],2:end-1);
g(2:end-1,[1 ncol]) = g(2:end-1,[3 ncol-2]);
end
