function [ Pros, phi, heaviside_phi, dirac_phi ] = evolution_LIF_gray( Pros, image_original, image_processed, phi0 )
%EVOLUTION_LIF  Zhang Kaihua 的 LIF 模型（灰度图版本）
% ref:
% Zhang, K. and L. Zhang, et al. (2010). "Active contours with selective local or global segmentation: A new formulation and level set method." Image and Vision Computing 28 (4): 668-676.

%% initialization
[numRow, numCol, numVar] = deal(Pros.sizeOfImage(1),Pros.sizeOfImage(2),Pros.sizeOfImage(3));
numPixels =numRow * numCol ;
phi=phi0;
data=double(rgb2gray(image_original));

% 停机条件
oldBwData=zeros(numPixels,1);
oldBwData(phi<=0)=1;
oldBwData = im2bw(oldBwData);
numPixelChanged = numPixels;
%% evolution
Ksigma = fspecial('gaussian', Pros.hsize, Pros.sigma);
K_phi = fspecial('gaussian', Pros.hsize_phi, Pros.sigma_phi);

while (Pros.iteration_outer<=Pros.numIteration_outer && numPixelChanged>=Pros.numPixelChangedToContinue)
	phi = NeumannBoundCond(phi);
	
	heaviside_phi = heavisideFunction(phi, Pros.epsilon, Pros.heavisideFunctionType);
	dirac_phi = diracFunction(phi, Pros.epsilon, Pros.heavisideFunctionType);
	
	f1 = conv2(data.*heaviside_phi,Ksigma,'same')./conv2(heaviside_phi,Ksigma,'same');
	f2 = conv2(data.*(1-heaviside_phi),Ksigma,'same')./ conv2(1-heaviside_phi,Ksigma,'same');
	I_LFI =  f1.*heaviside_phi + f2.*(1 - heaviside_phi);
	% 改变量
	phi = phi + Pros.timestep*dirac_phi.*((data - I_LFI).*(f1 - f2));
	phi = conv2(phi,K_phi,'same');

	
	%% visualization
	if strcmp(Pros.isNotVisiualEvolutionAtAll,'no')
		% 生成\phi 分割得到的二值图数据
		bwData=zeros(numPixels,1);
		bwData(phi<=0)=1;
		bwData = im2bw(bwData);
		
		[Pros]=visualizeContours_LIF_gray(Pros, data, image_processed, phi, bwData, areaTerm ,regularTerm , edgeTerm, dirac_phi, L_phi);
	end
	
	%% write data
	if strcmp(Pros.isNotWriteDataAtAll,'no')
		% 生成\phi 分割得到的二值图数据
		bwData=zeros(numPixels,1);
		bwData(phi<=0)=1;
		bwData = im2bw(bwData);
		
		[Pros ] = writeData_LIF_gray(Pros, data, image_processed, phi, bwData, Pix, Px, Pxi, P_x_and_i, Pi_vis, Pi, mu, Sigma);
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

