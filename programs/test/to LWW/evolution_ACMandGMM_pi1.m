function [Pros, phi] = evolution_ACMandGMM_pi1( Pros, image_original ,image_processed)
% evolution_ACMandGMM 基于文献[1]的演化模型的改造。用的先验信息是式(23)。
%   input:
% Pros：Pros结构体
% image_original：要处理的图像对应的原始图像。
% image_processed：要处理的图像。
% output:
% phi：最终的嵌入函数
% Pros：演化结束后更新的Pros结构体。

%  基于以下的文章下面做出改进。
% Gao, G. and C. Wen, et al. (2017). "Fast and robust image segmentation with active contours and Student's-t mixture model." Pattern Recognition 63: 71-86.
%

%% initialization
numState =2;	% GMM分枝数，在本算法中=2，分支1表示前景，分支2表示背景，在本方法分枝数就是2，否则这个方法就不是这个方法了
[numRow, numCol, numVar] = deal(Pros.sizeOfImage(1),Pros.sizeOfImage(2),Pros.sizeOfImage(3));
numPixels =numRow * numCol;
image_data = double(image_original);
data = reshape(image_data ,[],numVar);
data=data.'; % 要处理的图像数据。维数×像素数
Pxi = zeros( numPixels,numState); % Pxi：条件概率。图像像素数×分类数
phi = zeros(numPixels, 1); % 初始化的 嵌入函数。像素数×1.

% 停机条件
oldBwData=zeros(numPixels,1);
oldBwData(phi<=0)=1;
oldBwData = im2bw(oldBwData);
numPixelChanged = numPixels;
%% evolution

%% k均值初始化
[Prior, mu,Sigma ]= EM_init_kmeans(data, numState, Pros.maxIterOfKmeans); % Pi：先验概率。1×分类数；均值：维数×分枝数；协方差：维数×维数×分类数

while (Pros.iteration_outer<=Pros.numIteration_outer && numPixelChanged>=Pros.numPixelChangedToContinue)
	
	%% E步：用Θ_k 计算高斯概率p_k
	for i=1:numState
		Pxi(:,i)= gaussPDF(data, mu(:,i) , Sigma(:,:,i));
	end
	
	%% E步：用p_k 和π_k 计算高斯分支的后验期望z_k
	P_x_and_i = repmat(Prior, [numPixels 1]).*Pxi;		% P_x_and_i：同时满足x和i的概率。图像像素数×分类数
	Px = sum(P_x_and_i,2); % Px：高斯概率密度。图像像素数×1
	Pix = P_x_and_i ./ repmat(Px,[1 numState]); % Pix：后验概率。图像像素数×分类数
	
	
	%% M步：用z_k 计算Θ_(k+1)；
	sumPix = sum(Pix);
	for i=1:numState
		% Update the centers
		mu(:,i) = data*Pix(:,i) / sumPix(i);
		% Update the covariance matrices
		temp_mu = data - repmat(mu(:,i),1,numPixels);
		Sigma(:,:,i) = (repmat(Pix(:,i)',numVar, 1) .* temp_mu*temp_mu') / sumPix(i);
		% Add a tiny variance to avoid numerical instability
		Sigma(:,:,i) = Sigma(:,:,i) + 1E-15.*diag(ones(numVar,1));
	end
	
	%% 进行从GMM到ACM的通信：初始代，用式(16)：用z_k 初始化计算嵌入函数\phi_k
	if Pros.iteration_outer ==1
		phi = Pros.epsilon.*log(Pix(:,1)./Pix(:,2));
	end
	
	%% 进行从ACM到GMM的通信：用[1]的式(23)
	% 式(23)，用\phi_k 和p_k 计算π_(k+1)；
	Pi_vis(:,1)=1./(1+exp(log(Pix(:,1)./Pix(:,2))-phi./Pros.epsilon)); % Pi_vis：被分摊到每个像素点上的先验概率，用于可视化。图像像素数×分类数
	Pi_vis(:,2)=1-Pi_vis(:,1);
	Prior(1) = mean(Pi_vis(:,1)); % Pi：先验概率。1×分类数
	Prior(2) = 1-Prior(1);
	
	%% 进行从GMM到ACM的通信：此时之前已经初始化过 \phi_0，则用式(20)：用\phi_k 、p_k 、z_k 计算并更新\phi_(k+1)；
	phi=reshape(phi, numRow, numCol);	% reshape \phi
	phi=NeumannBoundCond(phi);
	[phi_x,phi_y]=gradient(phi);
	sqrtOfPhi=sqrt(phi_x.^2 + phi_y.^2);
	smallNumber=1E-15;
	nx=phi_x./(sqrtOfPhi+smallNumber); % add a small positive number to avoid division by zero
	ny=phi_y./(sqrtOfPhi+smallNumber);
	[nxx,~]=gradient(nx);
	[~,nyy]=gradient(ny);
	curvature=nxx+nyy;
	curvature=reshape(curvature,[],1);	% reshape curvature
	phi =reshape(phi, [],1);	% reshape \phi
	L_phi=1./Pros.epsilon*Pix(:,1).*Pix(:,2).*(log(Pxi(:,1)./Pxi(:,2)) + Pros.beta.*curvature - Pros.gamma); % DeltaPhi：嵌入函数的更新值。图像像素数×1
	
	% update \phi .
	phi=phi + Pros.timestep.*L_phi;
	
	
	
	
	
	
	%% visualization
	if strcmp(Pros.isNotVisiualEvolutionAtAll,'no')
		% 生成二值图数据
		bwData=zeros(numPixels,1);
		bwData(phi<=0)=1;
		bwData = im2bw(bwData);
		
		[Pros]=visualizeContours_ACMandGMM(Pros, image_original, image_processed, phi, bwData, Pix, Px, Pxi, Pi_vis );
	end
	%% write data
	if strcmp(Pros.isNotWriteDataAtAll,'no')
		% 生成二值图数据
		bwData=zeros(numPixels,1);
		bwData(phi<=0)=1;
		bwData = im2bw(bwData);
		
		[Pros ] = writeData_ACMandGMM(Pros, image_original, image_processed, phi, bwData, Pix, Px, Pxi, P_x_and_i, Pi_vis, Prior, mu, Sigma);
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

return ;
end

function g = NeumannBoundCond(f)
% Make a function satisfy Neumann boundary condition
[nrow,ncol] = size(f);
g = f;
g([1 nrow],[1 ncol]) = g([3 nrow-2],[3 ncol-2]);
g([1 nrow],2:end-1) = g([3 nrow-2],2:end-1);
g(2:end-1,[1 ncol]) = g(2:end-1,[3 ncol-2]);
end

