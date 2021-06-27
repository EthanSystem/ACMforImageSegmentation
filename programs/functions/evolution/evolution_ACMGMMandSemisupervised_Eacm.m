function [ Pros, phi ] = evolution_ACMGMMandSemisupervised_Eacm( Pros, image_original ,image_processed, seedsIndex1,seedsIndex2 , phi0, Prior0, mu0, Sigma0 )
%EVOLUTION_ACMANDSEMISUPERVISED 基于文献[1][3]的演化模型的改造。。

% input:
% Pros：Pros结构体。
% image_original：要处理的图像对应的原始图像。
% image_processed：要处理的图像。
% phi0: 初始轮廓。
% Prior0: 初始先验。
% mu0: 初始均值。
% Sigma0: 初始协方差。

% output:
% phi：最终的嵌入函数。
% Pros：演化结束后更新的Pros结构体。

% 基于以下的文章下面做出改进。
% Gao, G. and C. Wen, et al. (2017). "Fast and robust image segmentation with active contours and Student's-t mixture model." Pattern Recognition 63: 71-86.
% 加入最基本的生成式方法


%% initialization
numState =2;	% GMM分枝数，在本算法中=2，分支1表示前景，分支2表示背景，在本方法分枝数就是2，否则这个方法就不是这个方法了
[numRow, numCol, numVar] = deal(Pros.sizeOfImage(1),Pros.sizeOfImage(2),Pros.sizeOfImage(3));
numPixels =numRow * numCol;
image_data = double(image_original);
phi = reshape(phi0, [], 1); % 初始化的 嵌入函数。像素数×1.
data = reshape(image_data ,[],numVar);
data=data.'; % 要处理的图像数据。维数×像素数

% 如果初始轮廓是阶跃函数，那么给 phi 设置初始的阶跃值
if 1==strcmp(Pros.initializeType,'staircase')
    phi = phi.*Pros.contoursInitValue;
end

% 分别获取带各个标签的标记，无标签的标记
data_labeled=cell(1,numState);
index_labeled=cell(1,numState);
for k=1:numState
    index_labeled{k}=eval(['seedsIndex' num2str(k)]);
    data_labeled{k}=zeros(3,size(index_labeled{k},1));
    data_labeled{k}=data(:,index_labeled{k});
    num_labeled(k)=size(index_labeled{k},1);
end

[index_unlabeled]=setdiff([1:1:Pros.numData]',[index_labeled{1}; index_labeled{2}]);
% data_unlabeled=zeros(3,Pros.numData-size(seedsIndex1,1)-size(seedsIndex2,1));
data_unlabeled=data(:,index_unlabeled); %
num_unlabeled=size(data_unlabeled,2);


I_y=zeros(numPixels,1);
I_y(index_labeled{1,1})=1;
I_y(index_labeled{1,2})=-1;


% initialize the definition of Pxi
Pxi = zeros( numPixels,numState)+1E-15; % Pxi：条件概率。图像像素数×分类数。为了防止在后面的计算中出现分母为0的情况，因此将条件概率设为非零的很小的数。下同。
Pxi_unlabeled= zeros( num_unlabeled,numState)+1E-15; % Pxi_unlabeled ：未标签的像素的条件概率。未标签像素数×分类数。
Pix = zeros( numPixels,numState)+1E-15; % Pxi：后验概率。图像像素数×分类数
Pix_unlabeled= zeros( num_unlabeled,numState)+1E-15; % Pxi_unlabeled ：未标签的像素的后验概率。未标签像素数×分类数

% 初始化停机条件
oldBwData=zeros(numPixels,1);
oldBwData(phi>=0)=1;
oldBwData = im2bw(oldBwData);
numPixelChanged = numPixels;



%% 初始化 first iteration
% Prior：先验概率。1×分类数；均值：维数×分枝数；协方差：维数×维数×分类数
mu = mu0;
Sigma = Sigma0;
Prior = Prior0;


%% 如果初始化方式是以下情况：
if (strcmp(Pros.initMethod,'kmeans_ACMGMM')==1 || strcmp(Pros.initMethod,'circle_ACMGMM')==1)
    
    %% 开始本次迭代计时
    tic;
    
    
    %% generate edge indicator function at color image.
    %     G=fspecial('gaussian',Pros.hsize ,Pros.sigma);
    %     image_smooth=imfilter(image_data,G,'same');  % smooth image by Gaussiin convolution
    %     Ix=zeros(numRow,numCol,numVar);
    %     Iy=zeros(numRow,numCol,numVar);
    %     temp_f=zeros(numRow,numCol,numVar);
    %     for k=1:numVar
    %         [Ix(:,:,k),Iy(:,:,k)]=gradient(image_smooth(:,:,k));
    %         temp_f(:,:,k)=Ix(:,:,k).^2+Iy(:,:,k).^2;
    %     end
    %     f=mean(temp_f,3);
    %     g=1./(1+f);  % edge indicator function.
    %     [vx,vy]=gradient(g); % gradient of edge indicator function.
    %     g=reshape(g,[],1);
    %     vx=reshape(vx,[],1);
    %     vy=reshape(vy,[],1);
    
    
    %% generate edge indicator function at gray image.
    image_gray=rgb2gray(image_data);
    G=fspecial('gaussian',Pros.hsize ,Pros.sigma);
    image_smooth=imfilter(image_gray,G,'same');  % smooth image by Gaussiin convolution
    [Ix,Iy]=gradient(image_smooth);
    f=Ix.^2+Iy.^2;
    g=1./(1+f);  % edge indicator function.
    [vx,vy]=gradient(g); % gradient of edge indicator function.
    g=reshape(g,[],1);
    vx=reshape(vx,[],1);
    vy=reshape(vy,[],1);
    
    
    %% 结束本次迭代计时
    elipsedTime010 = toc;
    Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime010;
    
    %% visualization
    if strcmp(Pros.isNotVisiualEvolutionAtAll,'no')
        % 生成二值图数据
        bwData=zeros(numPixels,1);
        bwData(phi>=0)=1;
        bwData = im2bw(bwData);
        L_phi = zeros(Pros.numData,1);
        Px = zeros(Pros.numData,1);
        Pi_vis = zeros(Pros.numData ,2);
        [Pros]=visualizeContours_ACMGMMandSemisupervised(Pros, image_original, image_processed, phi, L_phi, bwData, Pix, Px, Pxi, Pi_vis );
    end
    
    %% write data
    if (strcmp(Pros.isNotWriteDataAtAll,'no') && mod(Pros.iteration_outer,Pros.periodOfWriteData)==0)
        % 生成二值图数据
        bwData=zeros(numPixels,1);
        bwData(phi>=0)=1;
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
            [Pros ] = writeData_ACMGMMandSemisupervised(Pros, image_original, image_processed, phi, bwData, Pix, Px, Pxi, P_x_and_i, Prior, mu, Sigma);
            %% TODO
        end
    end
    
    %%
    bwData=zeros(numPixels,1);
    bwData(phi>=0)=1;
    bwData = im2bw(bwData);
    pixelChanged = xor(bwData, oldBwData);
    numPixelChanged = sum(pixelChanged(:));
    oldBwData = bwData;
    Pros.iteration_outer = Pros.iteration_outer+1;		% iteration add 1
    
    
    %% 如果是其它的初始化情况
else
    
    %% 开始本次迭代计时
    tic;
    
    %% generate edge indicator function at color image.
    %     G=fspecial('gaussian',Pros.hsize ,Pros.sigma);
    %     image_smooth=imfilter(image_data,G,'same');  % smooth image by Gaussiin convolution
    %     Ix=zeros(numRow,numCol,numVar);
    %     Iy=zeros(numRow,numCol,numVar);
    %     temp_f=zeros(numRow,numCol,numVar);
    %     for k=1:numVar
    %         [Ix(:,:,k),Iy(:,:,k)]=gradient(image_smooth(:,:,k));
    %         temp_f(:,:,k)=Ix(:,:,k).^2+Iy(:,:,k).^2;
    %     end
    %     f=mean(temp_f,3);
    %     g=1./(1+f);  % edge indicator function.
    %     [vx,vy]=gradient(g); % gradient of edge indicator function.
    %     g=reshape(g,[],1);
    %     vx=reshape(vx,[],1);
    %     vy=reshape(vy,[],1);
    
    
    %% generate edge indicator function at gray image.
    image_gray=rgb2gray(image_data);
    G=fspecial('gaussian',Pros.hsize ,Pros.sigma);
    image_smooth=imfilter(image_gray,G,'same');  % smooth image by Gaussiin convolution
    [Ix,Iy]=gradient(image_smooth);
    f=Ix.^2+Iy.^2;
    g=1./(1+f);  % edge indicator function.
    [vx,vy]=gradient(g); % gradient of edge indicator function.
    g=reshape(g,[],1);
    vx=reshape(vx,[],1);
    vy=reshape(vy,[],1);
    
    
    
    %% E步：用 Θ_k 计算各个未标记样本和有标记样本的高斯概率 p_k
    for k=1:numState
        Pxi_unlabeled(:,k)= gaussPDF(data(:,index_unlabeled), mu(:,k) , Sigma(:,:,k));
        Pxi(index_unlabeled,k)=Pxi_unlabeled(:,k);
        for kk=1:numState
            if kk==k  % 如果要写入的划分区域和标签相同，则该图像的有标记样本的位置的 Pxi 为一个比 Pxi 所在列的值的最大值还大一些的值。
                Pxi(index_labeled{kk},k)=max(Pxi(:,k)).*Pros.scaleOflabeledProbabilities;
            else % 如果要写入的划分区域和标签不相同，则该图像的有标记样本的位置的 Pxi 为一个比 Pxi 所在列的值的最小值还小一些的值。
                Pxi(index_labeled{kk},k)=min(Pxi(:,k))./Pros.scaleOflabeledProbabilities;
            end
        end
    end
    
    %% E步：用 p_k 和 π_k 计算各个未标记样本的高斯分支的后验期望 z_k 和所有样本的高斯分支的后验期望
    P_x_and_i = repmat(Prior, [numPixels 1]).*Pxi;		% P_x_and_i：同时满足x和i的概率。图像像素数×分类数
    Px = sum(P_x_and_i,2); % Px：高斯概率密度。图像像素数×1
    Pix = P_x_and_i ./ repmat(Px,[1 numState]); % Pix：后验概率。图像像素数×分类数
    for k=1:numState
        Pix(index_labeled{k},k)=1;
    end
    
    %% M步：用 z_k 计算 Θ_(k+1)；
    %     sumPix = sum(Pix);
    for k=1:numState
        % Update the centers
        mu(:,k) = (data_unlabeled*Pxi_unlabeled(:,k)+sum(data_labeled{k},2)) / (sum(Pxi_unlabeled(:,k))+num_labeled(k));
        % Update the covariance matrices
        temp_mu = data_unlabeled - repmat(mu(:,k),1,num_unlabeled);
        Sigma(:,:,k) = (repmat(Pxi_unlabeled(:,k)',numVar, 1) .* temp_mu*temp_mu') / (sum(Pxi_unlabeled(:,k))+num_labeled(k));
        % Add a tiny variance to avoid numerical instability
        Sigma(:,:,k) = Sigma(:,:,k) + 1E-15.*diag(ones(numVar,1));
    end
    
    %         sumPix = sum(Pix);
    %         for i=1:numState
    %             % Update the centers
    %             mu(:,i) = data*Pix(:,i) / sumPix(i);
    %             % Update the covariance matrices
    %             temp_mu = data - repmat(mu(:,i),1,numPixels);
    %             Sigma(:,:,i) = (repmat(Pix(:,i)',numVar, 1) .* temp_mu*temp_mu') / sumPix(i);
    %             % Add a tiny variance to avoid numerical instability
    %             Sigma(:,:,i) = Sigma(:,:,i) + 1E-15.*diag(ones(numVar,1));
    %         end
    
    %% 进行从GMM到ACM的通信：初始代，用式(16)：用z_k 初始化计算嵌入函数 \phi_k
    phi = Pros.epsilon.*g.*log(Pix(:,1)./Pix(:,2));
    
    %% 进行从GMM到ACM的通信：此时之前已经初始化过 \phi_0，则用式(20)：用\phi_k 、p_k 、z_k 计算并更新\phi_(k+1)；
    phi=reshape(phi, numRow, numCol);
    % Neumann 边界条件
    phi=NeumannBoundCond(phi);
    [phi_x,phi_y]=gradient(phi);
    sqrtOfPhi=sqrt(phi_x.^2 + phi_y.^2);
    smallNumber=1E-15;
    nx=phi_x./(sqrtOfPhi+smallNumber); % add a small positive number to avoid division by zero
    ny=phi_y./(sqrtOfPhi+smallNumber);
    [nxx,~]=gradient(nx);
    [~,nyy]=gradient(ny);
    curvature=nxx+nyy;
    curvature=reshape(curvature,[],1);
    nx=reshape(nx,[],1);
    ny=reshape(ny,[],1);
    phi=reshape(phi, [],1);
    L_phi=1./Pros.epsilon*Pix(:,1).*Pix(:,2).*(log(Pxi(:,1)./Pxi(:,2)) + Pros.beta.*(vx.*nx+vy.*ny+g.*curvature) - Pros.gamma.*g + Pros.nu.*(2./Pros.epsilon).*I_y.*Pix(:,1).*Pix(:,2)); % DeltaPhi：嵌入函数的更新值。图像像素数×1
    % update \phi .
    phi=phi + Pros.timestep.*L_phi;
    
    
    
    %% 进行从ACM到GMM的通信：用[1]的式(25)
    % 式(25)，用\phi_k 计算π_(k+1)；
    Prior(1)=mean(1./(1+exp(Pros.gamma.*g - Pros.beta.*(vx.*nx+vy.*ny+g.*curvature) - phi./Pros.epsilon)));
    Prior(2)=1-Prior(1);
    
    
    %% 结束本次迭代计时
    elipsedTime010 = toc;
    Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime010;
    
    
    %% visualization
    if strcmp(Pros.isNotVisiualEvolutionAtAll,'no')
        % 生成二值图数据
        bwData=zeros(numPixels,1);
        bwData(phi>=0)=1;
        bwData = im2bw(bwData);
        Pi_vis(:,1)=1./(1+exp(Pros.gamma-Pros.beta.*g.*curvature-phi./Pros.epsilon));
        Pi_vis(:,2)=1-Pi_vis(:,1);
        
        [ Pros ] = visualizeContours_ACMGMMandSemisupervised_Eacm( Pros, image_original, image_processed, phi, L_phi,  bwData, Pix, Px, Pxi ,Pi_vis);
    end
    
    %% write data
    if (strcmp(Pros.isNotWriteDataAtAll,'no') && mod(Pros.iteration_outer,Pros.periodOfWriteData)==0)
        % 生成二值图数据
        bwData=zeros(numPixels,1);
        bwData(phi>=0)=1;
        bwData = reshape(bwData, numRow, numCol);
        bwData = im2bw(bwData);
        % 	filename_bwData = [Pros.filename_originalImage(1:end-4) '_iter' num2str(Pros.iteration_outer,'%04d') '_time' num2str(Pros.elipsedEachTime,'%.4f') '_' Pros.evolutionMethod '_bwData.bmp'];
        filename_bwData = [Pros.filename_originalImage(1:end-4) '_iter' num2str(Pros.iteration_outer,'%04d') '_time' num2str(Pros.elipsedEachTime,'%.4f') '.bmp'];
        filepath_bwImage = fullfile(Pros.folderpath_bwData, filename_bwData);
        imwrite(bwData, filepath_bwImage, 'bmp');
        if exist(filepath_bwImage,'file')
            disp(['已保存分割二值图 ' filename_bwData]);
        else
            disp(['未保存分割二值图 ' filename_bwData]);
        end
        
        if  strcmp(Pros.isWriteData,'yes')==1
            [Pros ] = writeData_ACMGMMandSemisupervised_Eacm(Pros, image_original, image_processed, phi, bwData, Pix, Px, Pxi, P_x_and_i, Prior, mu, Sigma);
            %% TODO
        end
    end
    
    %%
    bwData=zeros(numPixels,1);
    bwData(phi>=0)=1;
    bwData = im2bw(bwData);
    pixelChanged = xor(bwData, oldBwData);
    numPixelChanged = sum(pixelChanged(:));
    oldBwData = bwData;
    Pros.iteration_outer = Pros.iteration_outer+1;		% iteration add 1
    
end % end if Pros.initMethod

%% rest iteration

% while (Pros.elipsedEachTime<=Pros.numTime) % 比较同一时间的停机条件
% while (Pros.iteration_outer<=Pros.numIteration_outer) % 比较同一代数的停机条件
while (Pros.iteration_outer<=Pros.numIteration_outer) % 给定收敛条件的停机条件
% while (Pros.iteration_outer<=Pros.numIteration_outer &&	numPixelChanged>=Pros.numPixelChangedToContinue) % 给定收敛条件的停机条件
% while ((Pros.iteration_outer<=Pros.numIteration_outer &&	numPixelChanged>=Pros.numPixelChangedToContinue) || Pros.iteration_outer<=Pros.numIteration_inner) % 给定收敛条件的停机条件
    
    %% 开始本次迭代计时
    tic;
    
    %% E步：用 Θ_k 计算各个未标记样本和有标记样本的高斯概率 p_k
    for k=1:numState
        Pxi_unlabeled(:,k)= gaussPDF(data(:,index_unlabeled), mu(:,k) , Sigma(:,:,k));
        Pxi(index_unlabeled,k)=Pxi_unlabeled(:,k);
        for kk=1:numState
            if kk==k  % 如果要写入的划分区域和标签相同，则该图像的有标记样本的位置的 Pxi 为一个比 Pxi 所在列的值的最大值还大一些的值。
                Pxi(index_labeled{kk},k)=max(Pxi(index_unlabeled,k)).*Pros.scaleOflabeledProbabilities;
            else % 如果要写入的划分区域和标签不相同，则该图像的有标记样本的位置的 Pxi 为一个比 Pxi 所在列的值的最小值还小一些的值。
                Pxi(index_labeled{kk},k)=min(Pxi(index_unlabeled,k))./Pros.scaleOflabeledProbabilities;
            end
        end
    end
    
    %% E步：用 p_k 和 π_k 计算各个未标记样本的高斯分支的后验期望 z_k 和所有样本的高斯分支的后验期望
    %     P_x_and_i = repmat(Prior, [num_unlabeled 1]).*Pxi_unlabeled;		% P_x_and_i：同时满足x和i的概率。图像像素数×分类数
    %     Px = sum(P_x_and_i,2); % Px：高斯概率密度。图像像素数×1
    %     Pix_unlabeled = P_x_and_i ./ repmat(Px,[1 numState]); % Pix：后验概率。图像像素数×分类数
    %     Pix(index_unlabeled,:)=Pix_unlabeled;
    
    P_x_and_i = repmat(Prior, [numPixels 1]).*Pxi;		% P_x_and_i：同时满足x和i的概率。图像像素数×分类数
    Px = sum(P_x_and_i,2); % Px：高斯概率密度。图像像素数×1
    Pix = P_x_and_i ./ repmat(Px,[1 numState]); % Pix：后验概率。图像像素数×分类数
    for k=1:numState
        Pix(index_labeled{k},k)=1;
    end
    
    %% M步：用 z_k 计算 Θ_(k+1)；
    %     sumPix = sum(Pix);
    for k=1:numState
        % Update the centers
        mu(:,k) = (data_unlabeled*Pxi_unlabeled(:,k)+sum(data_labeled{k},2)) / (sum(Pxi_unlabeled(:,k))+num_labeled(k));
        % Update the covariance matrices
        temp_mu = data_unlabeled - repmat(mu(:,k),1,num_unlabeled);
        Sigma(:,:,k) = (repmat(Pxi_unlabeled(:,k)',numVar, 1) .* temp_mu*temp_mu') / (sum(Pxi_unlabeled(:,k))+num_labeled(k));
        % Add a tiny variance to avoid numerical instability
        Sigma(:,:,k) = Sigma(:,:,k) + 1E-15.*diag(ones(numVar,1));
    end
    
    %% 进行从GMM到ACM的通信：此时之前已经初始化过 \phi_0，则用式(20)：用\phi_k 、p_k 、z_k 计算并更新\phi_(k+1)；
    phi=reshape(phi, numRow, numCol);
    % Neumann 边界条件
    phi=NeumannBoundCond(phi);
    [phi_x,phi_y]=gradient(phi);
    sqrtOfPhi=sqrt(phi_x.^2 + phi_y.^2);
    smallNumber=1E-15;
    nx=phi_x./(sqrtOfPhi+smallNumber); % add a small positive number to avoid division by zero
    ny=phi_y./(sqrtOfPhi+smallNumber);
    [nxx,~]=gradient(nx);
    [~,nyy]=gradient(ny);
    curvature=nxx+nyy;
    curvature=reshape(curvature,[],1);
    nx=reshape(nx,[],1);
    ny=reshape(ny,[],1);
    phi=reshape(phi, [],1);
    L_phi=1./Pros.epsilon*Pix(:,1).*Pix(:,2).*(log(Pxi(:,1)./Pxi(:,2)) + Pros.beta.*(vx.*nx+vy.*ny+g.*curvature) - Pros.gamma.*g + Pros.nu.*(2./Pros.epsilon).*I_y.*Pix(:,1).*Pix(:,2)); % DeltaPhi：嵌入函数的更新值。图像像素数×1
    % update \phi .
    phi=phi + Pros.timestep.*L_phi;
    
    
    
    %% 进行从ACM到GMM的通信：用[1]的式(25)
    % 式(25)，用\phi_k 计算π_(k+1)；
    Prior(1)=mean(1./(1+exp(Pros.gamma.*g - Pros.beta.*(vx.*nx+vy.*ny+g.*curvature) - phi./Pros.epsilon)));
    Prior(2)=1-Prior(1);
    
    %% 结束本次迭代计时
    elipsedTime020 = toc;
    Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime020;
    
    
    
    %% visualization
    if strcmp(Pros.isNotVisiualEvolutionAtAll,'no')
        % 生成二值图数据
        bwData=zeros(numPixels,1);
        bwData(phi>=0)=1;
        bwData = im2bw(bwData);
        Pi_vis(:,1)=1./(1+exp(Pros.gamma-Pros.beta.*g.*curvature-phi./Pros.epsilon));
        Pi_vis(:,2)=1-Pi_vis(:,1);
        
        [ Pros ] = visualizeContours_ACMGMMandSemisupervised_Eacm( Pros, image_original, image_processed, phi, L_phi,  bwData, Pix, Px, Pxi ,Pi_vis);
    end
    
    %% write data
    if (strcmp(Pros.isNotWriteDataAtAll,'no') && mod(Pros.iteration_outer,Pros.periodOfWriteData)==0)
        % 生成二值图数据
        bwData=zeros(numPixels,1);
        bwData(phi>=0)=1;
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
            [Pros ] = writeData_ACMGMMandSemisupervised_Eacm(Pros, image_original, image_processed, phi, bwData, Pix, Px, Pxi, P_x_and_i, Prior, mu, Sigma);
            %% TODO
        end
    end
    
    %%
    bwData=zeros(numPixels,1);
    bwData(phi>=0)=1;
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

