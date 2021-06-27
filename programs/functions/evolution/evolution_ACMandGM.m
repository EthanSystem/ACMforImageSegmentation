function [ Pros, phi] = evolution_ACMandGM( Pros, image_original ,image_processed, phi0)
% evolution_ACMandGM 基于[5].Chapter2 的思路
%   input:
% Pros：Pros结构体
% image_original：要处理的图像对应的原始图像。
% image_processed：要处理的图像。
% phi0：初始化嵌入函数
% output:
% phi：最终的嵌入函数
% Pros：演化结束后更新的Pros结构体。
%
%


%% initialization
numState = Pros.numOfComponents;	% 分枝数==1等价于 GM 模型。
[numRow, numCol, numVar] = deal(Pros.sizeOfImage(1),Pros.sizeOfImage(2),Pros.sizeOfImage(3));
numPixels =numRow * numCol ;
image_data = double(image_original);
data = reshape(image_data ,[] ,numVar);
data=data.'; % 要处理的图像数据。维数×像素数

%% evolution

%% 初始化轮廓（嵌入函数）phi
% 初始化轮廓。
phi = phi0;
% 停机条件
oldBwData=zeros(numPixels,1);
oldBwData(phi<=0)=1;
oldBwData = im2bw(oldBwData);
numPixelChanged = numPixels;
%% evolution
while (Pros.iteration_outer<=Pros.numIteration_outer && numPixelChanged>=Pros.numPixelChangedToContinue)
	
	%% 基于 phi 更新前景和背景 GM 的参数值Θ_i^(k=0)（Θ_i^k 可以简写为Θ_^k ）；
	% 前景、背景 GM 模型。均值：维数；协方差：维数×维数
	
	% [~, mu_foreground, Sigma_foreground ] = EM_init_kmeans(data, numState);
	% [~, mu_background, Sigma_background ] = EM_init_kmeans(data, numState);
	
	data_foreground = data(:,phi<=0);	% data_foreground：属于前景的数据的集合。维数×前景像素数。背景同下。
	data_background = data(:,phi>0);
	sumX1 = sum(data_foreground,2);		% sumX1： 属于前景的所有的像素点分别对各维度求和。维数×1.
	sumX2 = sum(data_background,2);
	N1=size(data_foreground, 2); % N1 ：属于前景的像素点的个数
	N2=numPixels - N1;
	mu_foreground = sumX1./N1; % mu_foreground：前景GM模型的均值。维数×1
	mu_background = sumX2./N2;
	sumXX1 = data_foreground-repmat(mu_foreground, 1, N1); % 前景GM模型的协方差的(x-mu)部分。维数×维数
	sumXX2 = data_background-repmat(mu_background, 1, N2);
	Sigma_foreground = (sumXX1*sumXX1')./N1 ; % 前景GM模型的协方差。维数×维数
	Sigma_background  = (sumXX2*sumXX2')./N2 ;
	
	
	
	
	
	%% Step 1 水平集函数演化，见(14)和（11）。
	% 把水平集\phi 代入计算狄拉克函数(12)
	dirac_phi = diracFunction(phi, Pros.epsilon, Pros.heavisideFunctionType);
	dirac_phi = reshape(dirac_phi, [],1);
	
	% 根据参数值计算以下两个概率：
	% Px_foreground，为该点在前景模型中的密度
	Px_foreground = gaussPDF(data, mu_foreground , Sigma_foreground);
	% Px_background ，为该点在背景模型中的密度
	Px_background = gaussPDF(data, mu_background , Sigma_background);
	
	% 概率项
	probabilityTerm = log(Px_foreground./Px_background);
	
	% 其它能量项计算
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
	% 长度项
	edgeTerm=curvature;
	
	% 面积项
	areaTerm=repmat(-1,numPixels,1);
	
	
	% [5](11)改变量。这里我们去掉面积项
	L_phi = dirac_phi.*(Pros.mu.*probabilityTerm + Pros.beta.*edgeTerm - Pros.gamma.*areaTerm);
	
	% update \phi . (14)
	phi=phi + Pros.timestep.*L_phi;
	
	
	
	
	%% visualization
	if strcmp(Pros.isNotVisiualEvolutionAtAll,'no')
		% 生成\phi 分割得到的二值图数据
		bwData=zeros(numPixels,1);
		bwData(phi<=0)=1;
		bwData = im2bw(bwData);
		
		[Pros]=visualizeContours_ACMandGM(Pros, image_original, image_processed, phi, bwData, Px_foreground, Px_background ,probabilityTerm, edgeTerm, dirac_phi, L_phi);
	end
	%% write data
	if strcmp(Pros.isNotWriteDataAtAll,'no')
		% 生成\phi 分割得到的二值图数据
		bwData=zeros(numPixels,1);
		bwData(phi<=0)=1;
		bwData = im2bw(bwData);
		
		[Pros ] = writeData_ACMandGM(Pros, image_original, image_processed, phi, bwData, Pix, Px, Pxi, P_x_and_i, Pi, mu, Sigma);
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



