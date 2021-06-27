function [ Pros, phi, heaviside_phi, dirac_phi ] = evolution_CV(Pros, image_original, image_processed, phi0)
% evolution_CV ：彩色空间的CV模型[7]，基于李春明的代码。
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

% ref: 	Chan, T. F. and B. Y. Sandberg, et al. (2000). "Active Contours without Edges for Vector-Valued Images." Journal of Visual Communication and Image Representation 11 (2): 130-141.


%% initialization
[numRow, numCol, numVar] = deal(Pros.sizeOfImage(1),Pros.sizeOfImage(2),Pros.sizeOfImage(3));
numPixels =numRow * numCol ;
phi= - phi0; % 反转phi成为前景小于0，背景大于0，以适应于该方法的原始定义
phi=reshape(phi, [], 1);
data=double(image_original);
data = reshape(data, [], numVar);

% 如果初始轮廓是阶跃函数，那么给 phi 设置初始的阶跃值
if 1==strcmp(Pros.initializeType, 'staircase')
    phi = phi.*Pros.contoursInitValue; 
end

% 初始化停机条件
oldBwData=zeros(numRow, numCol);
oldBwData(phi(:)<=0)=1;
oldBwData = im2bw(oldBwData);
numPixelChanged = numPixels;


% %% （多余的，用于平衡时间差异的）k均值初始化
% % 这个初始化步骤对于CV模型是多余的。此目的在于减少与其他同样初始化的模型的运算时间的差异。
% numState =2;
% temp = data.';
% [Prior, mu,Sigma ]= EM_init_kmeans(temp, numState, Pros.maxIterOfKmeans); % Pi：先验概率。1×分类数；均值：维数×分枝数；协方差：维数×维数×分类数
% clear Prior mu Sigma


%% evolution
% while (Pros.elipsedEachTime<=Pros.numTime)
% while (Pros.iteration_outer<=Pros.numIteration_outer)
while (Pros.iteration_outer<=Pros.numIteration_outer && numPixelChanged>=Pros.numPixelChangedToContinue)
	
	% 开始本次迭代计时
	tic;
	
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
	dirac_phi = diracFunction(phi, Pros.epsilon, Pros.heavisideFunctionType);
	heaviside_phi = heavisideFunction( phi, Pros.epsilon, Pros.heavisideFunctionType );
	
	% 长度项
	edgeTerm = curvature;
	
	% 面积项
	areaTerm = ones(numPixels, 1);
	
	% 规则化项
	sumxxa= repmat(heaviside_phi, 1, numVar).*data;
	numer_1=sum(sumxxa,1);
	denom_1=sum(heaviside_phi(:));
	C1 = numer_1./denom_1;
	sumxxb=(1-repmat(heaviside_phi, 1, numVar)).*data;
	numer_2=sum(sumxxb,1);
	denom_2=sum(1-heaviside_phi);
	C2 = numer_2./denom_2;
	regularTerm = mean(Pros.lambda1.*(data-repmat(C1,numPixels,1)).^2 ,2) - mean(Pros.lambda2.*(data-repmat(C2,numPixels,1)).^2, 2);
	
	
	% 改变量
	L_phi = dirac_phi.*(Pros.gamma.*areaTerm + Pros.beta.*edgeTerm - regularTerm);
	
	% updating the phi function
	phi=phi+Pros.timestep.*L_phi;
	
	
	% 结束本次迭代计时
	elipsedTime010 = toc;
	Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime010;
	
	
	% old
	% 		% updating the phi function
	% 	phi=phi+Pros.timestep*(dirac_phi.*(Pros.nu-Pros.lambda1*(image_data-C1).^2+Pros.lambda2*(image_data-C2).^2));
	
	
	%% visualization
	%     if strcmp(Pros.isNotVisiualEvolutionAtAll,'no')
	%         % 生成\phi 分割得到的二值图数据
	%         bwData=zeros(numPixels,1);
	%         bwData(phi<=0)=1;
	%         bwData = im2bw(bwData);
	%
	%         [Pros]=visualizeContours_CV_fixedTime(Pros, image_original, image_processed, phi, bwData, areaTerm ,regularTerm , edgeTerm, dirac_phi, L_phi);
	%     end
	%% write data
    if (strcmp(Pros.isNotWriteDataAtAll,'no') && mod(Pros.iteration_outer,Pros.periodOfWriteData)==0)
		% 生成二值图数据
		bwData=zeros(numPixels,1);
		bwData(phi(:)<=0)=1;
		bwData = reshape(bwData, numRow, numCol);
		bwData = im2bw(bwData);
		filename_bwData = [Pros.filename_originalImage(1:end-4) '_iter' num2str(Pros.iteration_outer,'%04d') '_time' num2str(Pros.elipsedEachTime,'%.4f') '_' Pros.evolutionMethod '.bmp'];
		filepath_bwData = fullfile(Pros.folderpath_bwData, filename_bwData);
		imwrite(bwData, filepath_bwData, 'bmp');
		if exist(filepath_bwData,'file')
			disp(['已保存分割二值图数据 ' filename_bwData]);
		else
			disp(['未保存分割二值图数据 ' filename_bwData]);
		end
		
		if  strcmp(Pros.isWriteData,'yes')==1
			[Pros ] = writeData_CV_fixedTime(Pros, image_original, image_processed, phi, bwData, Pix, Px, Pxi, P_x_and_i, Pi_vis, Pi, mu, Sigma);
		end
	end
	%%
    bwData=zeros(numRow,numCol);
    bwData(phi(:)<=0)=1;
    bwData = im2bw(bwData);
    pixelChanged = xor(bwData, oldBwData);
    numPixelChanged = sum(pixelChanged(:));
    oldBwData = bwData;
    Pros.iteration_outer = Pros.iteration_outer+1;		% iteration add 1
	
end % end loop

phi=-phi; % 反转 phi 以变成前景大于0，背景小于0，以适应主程序的写数据。


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
