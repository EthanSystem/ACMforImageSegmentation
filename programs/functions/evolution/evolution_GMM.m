function [ Pros, phi ] = evolution_GMM( Pros, image_original, image_processed, Prior0, mu0, Sigma0)
%EVOLUTION_GMM 演化模型，用全局图像数据作为前背景
%   此处显示详细说明



%% initialization
numState = Pros.numOfComponents;	% GMM分枝数，在本算法中=2，分支1表示前景，分支2表示背景。
[numRow, numCol, numVar] = deal(Pros.sizeOfImage(1),Pros.sizeOfImage(2),Pros.sizeOfImage(3));
numPixels =numRow * numCol ;
data = double(image_original);
data = reshape(data ,[] ,numVar);
data=data.'; % 要处理的图像数据。维数×像素数


%% k均值初始化
% Prior：先验概率。1×分类数；均值：维数×分枝数；协方差：维数×维数×分类数
mu = mu0;
Sigma = Sigma0;
Prior = Prior0;

% [Prior0, mu0,Sigma0 ]= EM_init_kmeans(data, numState, Pros.maxIterOfKmeans); % Pi：先验概率。1×分类数；均值：维数×分枝数；协方差：维数×维数×分类数

%% Initialization of the parameters


% 初始化停机条件
oldBwData=zeros(numPixels,1);
oldBwData = im2bw(oldBwData);
numPixelChanged = numPixels;

% while (Pros.elipsedEachTime<=Pros.numTime) % 比较同一时间的停机条件
% while (Pros.iteration_outer<=Pros.numIteration_outer) % 比较同一代数的停机条件
while (Pros.iteration_outer<=Pros.numIteration_outer && numPixelChanged>=Pros.numPixelChangedToContinue) % 给定收敛条件的停机条件
	
	% 开始本次迭代计时
	tic;
	
	%% E-step
	for i=1:numState
		%Compute probability p(x|i)
		Pxi(:,i) = gaussPDF(data, mu(:,i), Sigma(:,:,i), Pros.smallNumber);
	end
	%Compute posterior probability p(i|x)
	Pix_tmp = repmat(Prior,[numPixels 1]).*Pxi;
	Pix = Pix_tmp ./ repmat(sum(Pix_tmp,2),[1 numState]);
	%Compute cumulated posterior probability
	EE = sum(Pix);
	
	%% M-step
	for i=1:numState
		%Update the priors
		Prior(i) = EE(i) / numPixels;
		%Update the centers
		mu(:,i) = data*Pix(:,i) / EE(i);
		%Update the covariance matrices
		Data_tmp1 = data - repmat(mu(:,i),1,numPixels);
		Sigma(:,:,i) = (repmat(Pix(:,i)',numVar, 1) .* Data_tmp1*Data_tmp1') / EE(i);
		% Add a tiny variance to avoid numerical instability
		Sigma(:,:,i) = Sigma(:,:,i) + 1E-15.*diag(ones(numVar,1));
	end
	
	%% 计算概率
	% 	for i=1:numState
	% 		Pxi(:,i) = gaussPDF(data, mu(:,i), Sigma(:,:,i));
	% 	end
	
	
	% 结束本次迭代计时
	elipsedTime010 = toc;
	Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime010;
	
	
	%% visualization
	%     if strcmp(Pros.isNotVisiualEvolutionAtAll,'no')
	%         % 生成\phi 分割得到的二值图数据
	%         bwData=zeros(numPixels,1);
	%         bwData(phi<=0)=1;
	%         bwData = im2bw(bwData);
	%
	%         [Pros]=visualizeContours_GMM_fixedTime(Pros, image_original, image_processed, phi, bwData, areaTerm ,regularTerm , edgeTerm, dirac_phi, L_phi);
	%     end
	%% write data
    if (strcmp(Pros.isNotWriteDataAtAll,'no') && mod(Pros.iteration_outer,Pros.periodOfWriteData)==0)
		% 生成二值图数据
		bwData=zeros(numPixels,1);
		bwData(Pix(:,1)-Pix(:,2)>=0)=1;
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
			[Pros ] = writeData_GMM_fixedTime(Pros, image_original, image_processed, phi, bwData, Pix, Px, Pxi, P_x_and_i, Pi_vis, Pi, mu, Sigma);
		end
	end
	%%
	bwData=zeros(numPixels,1);
	bwData(Pix(:,1)-Pix(:,2)>=0)=1;
	bwData = im2bw(bwData);
	pixelChanged = xor(bwData, oldBwData);
	numPixelChanged = sum(pixelChanged(:));
	oldBwData = bwData;
	Pros.iteration_outer = Pros.iteration_outer+1;		% iteration add 1
	
end % end loop

% 计算 \phi
phi =Pix(:,1)-Pix(:,2);  % 这个 phi 不是指水平集里的嵌入函数，是指两个分支的条件概率的差值。仅仅是为了方便主程序的变量名称统一而已。


return;

end

