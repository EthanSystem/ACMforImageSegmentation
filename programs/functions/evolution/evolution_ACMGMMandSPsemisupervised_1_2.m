function [ Pros, phi, F_sp ] = evolution_ACMGMMandSPsemisupervised_1_2( Pros, image_original ,image_processed, seedsIndex1,seedsIndex2 , phi0, Prior0, mu0, Sigma0 )
%EVOLUTION_ACMANDSEMISUPERVISED 基于文献[1][3]的演化模型的改造。。

% input:
% Pros：Pros结构体。
% image_original：要处理的图像对应的原始图像。
% image_processed：要处理的图像。
% seedsIndex1: 种子标记1
% seedsIndex2: 种子标记2
% phi0: 初始轮廓。
% Prior0: 初始先验。
% mu0: 初始均值。
% Sigma0: 初始协方差。

% output:
% phi：最终的嵌入函数。
% Pros：演化结束后更新的Pros结构体。

% 基于以下的文章下面做出改进。
% Gao, G. and C. Wen, et al. (2017). "Fast and robust image segmentation with active contours and Student's-t mixture model." Pattern Recognition 63: 71-86.
% 加入最基本的生成式方法，初步引入超像素力。


%% initialization
numState = 2;	% GMM分枝数，在本算法中=2，分支1表示前景，分支2表示背景，在本方法分枝数就是2，否则这个方法就不是这个方法了
[numRow, numCol, numVar] = deal(Pros.sizeOfImage(1),Pros.sizeOfImage(2),Pros.sizeOfImage(3));
numPixels = numRow * numCol;

phi = phi0; % 初始化的 嵌入函数。图像宽度×高度。
% 如果初始轮廓是阶跃函数，那么给 phi 设置初始的阶跃值
if 1==strcmp(Pros.initializeType , 'staircase')
    phi = phi.*Pros.contoursInitValue;
end

%% 初始化停机条件
oldBwData=zeros(numRow, numCol);
oldBwData(phi(:)>=0)=1;
oldBwData = imbinarize(oldBwData);
numPixelChanged = numPixels;

%% 选取颜色空间,
% TODO 以后单独列为函数
try
    switch Pros.colorspace
        case 'LAB'
            image_data=double(uint8(rgb2lab(image_original).*255));
        case 'HSV'
            image_data=double(uint8(rgb2hsv(image_original).*255));
        case 'RGB'
            image_data=double(image_original);
    end
catch
    disp('colorspace is wrong');
end
image_data_reshaped = (reshape(image_data ,[],numVar)).';   % 要处理的图像数据。维数×像素数
image_data_RGB = im2single(image_original);


%% 初始化待估参数
% Prior：先验概率。1×分类数；均值：维数×分枝数；协方差：维数×维数×分类数
mu = mu0;
Sigma = Sigma0;
Prior = Prior0;


%% 计时开始 %%%%%%%%%%%%
tic;


%% 分别获取带各个标签的标记，无标签的标记
data_labeled=cell(1,numState);
index_labeled=cell(1,numState);
for k=1:numState
    index_labeled{k}=eval(['seedsIndex' num2str(k)]);
    data_labeled{k}=zeros(3,size(index_labeled{k},1));
    data_labeled{k}=image_data_reshaped(:,index_labeled{k});
    num_labeled(k)=size(index_labeled{k},1);
end

[index_unlabeled]=setdiff([1:1:Pros.numData]',[index_labeled{1}; index_labeled{2}]);
% data_unlabeled=zeros(3,Pros.numData-size(seedsIndex1,1)-size(seedsIndex2,1));
data_unlabeled=image_data_reshaped(:,index_unlabeled); %
num_unlabeled=size(data_unlabeled,2);



%% 计时暂停 %%%%%%%%%%%%%%%%%
elipsedTime = toc;
Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime;



%% initialize the definition of P_x_k
P_x_k = zeros( numPixels, numState)+Pros.smallNumber; % P_x_k：条件概率。图像像素数×分类数。为了防止在后面的计算中出现分母为0的情况，因此将条件概率设为非零的很小的数。下同。
P_x_k_unlabeled= zeros( num_unlabeled, numState)+Pros.smallNumber; % P_x_k_unlabeled ：未标签的像素的条件概率。未标签像素数×分类数。
P_k_x = zeros( numPixels, numState)+Pros.smallNumber; % P_x_k：后验概率。图像像素数×分类数



% %% 计时开始 %%%%%%%%%%%%
% tic;


%% 用 vl-feat 包的函数生成超像素。
% segmentsValue 存储的是每个像素被划分的超像素的标签值
SuperPixels_labelsMap=vl_slic(image_data_RGB, Pros.SuperPixels_lengthOfSide, Pros.SuperPixels_regulation);

%% find the number of SP.
numSP=max(SuperPixels_labelsMap(:))+1;


%% 把对应于划分出来的超像素的 segments 作为标记该超像素的记号，对 segments
% 遍历，找到对应该超像素的记号，对应图像的HSV值，用 imhist() 生成直方图，用 histcounts() 作为提取直方图的数据方法。
% 结果保存在 SuperPixels(i).histogram 的三个通道值当中。

for i=1:numSP
    [row,col,~]=find(SuperPixels_labelsMap==i-1);
    [index]=find(SuperPixels_labelsMap==i-1);
    SuperPixels_position{i}=[row col];
    SuperPixels_index{i}=index;
    SuperPixels_color{i}=image_data(row,col,:);
end

% 去掉那些空的标签值
for i=numSP:-1:1
    if isempty(SuperPixels_position{i})
        SuperPixels_position(i)=[];
        SuperPixels_index(i)=[];
        SuperPixels_color(i)=[];
    end
end

clear numSP;
numSP=size(SuperPixels_index,2);




% %% 计时暂停 %%%%%%%%%%%%%%%%%
% elipsedTime = toc;
% Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime;



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
    
    
    %% 计时暂停 %%%%%%%%%%%%%%%%%
    elipsedTime = toc;
    Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime;
    
    %% visualization
    if strcmp(Pros.isNotVisiualEvolutionAtAll,'no')
        % 生成二值图数据
        bwData=zeros(numRow, numCol);
        bwData(phi(:)>=0)=1;
        bwData = imbinarize(bwData);
        L_phi = zeros(Pros.numData,1);
        P_x = zeros(Pros.numData,1);
        Pi_vis = zeros(Pros.numData ,2);
        [Pros]=visualizeContours_ACMGMMandSemisupervised(Pros, image_original, image_processed, phi, L_phi, bwData, P_k_x, P_x, P_x_k, Pi_vis );
    end
    
    %% write data
    if (strcmp(Pros.isNotWriteDataAtAll,'no') && mod(Pros.iteration_outer,Pros.periodOfWriteData)==0)
        % 生成二值图数据
        bwData=zeros(numRow, numCol);
        bwData(phi(:)>=0)=1;
        bwData = reshape(bwData, numRow, numCol);
        bwData = imbinarize(bwData);
        filename_bwData = [Pros.filename_originalImage(1:end-4) '_iter' num2str(Pros.iteration_outer,'%04d') '_time' num2str(Pros.elipsedEachTime,'%.4f') '_' Pros.evolutionMethod '.bmp'];
        filepath_bwData = fullfile(Pros.folderpath_bwData, filename_bwData);
        imwrite(bwData, filepath_bwData, 'bmp');
        if exist(filepath_bwData,'file')
            disp(['已保存分割二值图数据 ' filename_bwData]);
        else
            disp(['未保存分割二值图数据 ' filename_bwData]);
        end
        
        if  strcmp(Pros.isWriteData,'yes')==1
            [Pros ] = writeData_ACMGMMandSPsemisupervised_1(Pros, image_original, image_processed, phi, bwData, P_k_x, P_x, P_x_k, P_x_and_k, Prior, mu, Sigma);
        end
    end
    
    %%
    bwData=zeros(numRow, numCol);
    bwData(phi(:)>=0)=1;
    bwData = imbinarize(bwData);
    pixelChanged = xor(bwData, oldBwData);
    numPixelChanged = sum(pixelChanged(:));
    oldBwData = bwData;
    Pros.iteration_outer = Pros.iteration_outer+1;		% iteration add 1
    
    
    %% 如果是其它的初始化情况
else
    
    %% 计时开始 %%%%%%%%%%%%
    tic;
    
    %% generate edge indicator function at gray image.
    image_gray=double(uint8(rgb2gray(image_data_RGB).*256));
    G=fspecial('gaussian',Pros.hsize ,Pros.sigma);
    image_smooth=imfilter(image_gray,G,'same');  % smooth image by Gaussiin convolution
    [Ix,Iy]=gradient(image_smooth);
    f=Ix.^2+Iy.^2;
    g=1./(1+f);  % edge indicator function.
    [vx,vy]=gradient(g); % gradient of edge indicator function.
    
    
    
    %% E步：用 Θ_k 计算各个未标记样本和有标记样本的高斯概率 p_k
    for k=1:numState
        P_x_k_unlabeled(:,k)= gaussPDF(image_data_reshaped(:,index_unlabeled), mu(:,k) , Sigma(:,:,k), Pros.smallNumber);
        P_x_k(index_unlabeled,k)=P_x_k_unlabeled(:,k);
        for kk=1:numState
            if kk==k  % 如果要写入的划分区域和标签相同，则该图像的有标记样本的位置的 P_x_k 为一个比 P_x_k 所在列的值的最大值还大一些的值。
                P_x_k(index_labeled{kk},k)=min(max(P_x_k(index_unlabeled,k)).*Pros.scaleOflabeledProbabilities,1.0);
            else % 如果要写入的划分区域和标签不相同，则该图像的有标记样本的位置的 P_x_k 为一个比 P_x_k 所在列的值的最小值还小一些的值。
                P_x_k(index_labeled{kk},k)=max(min(P_x_k(index_unlabeled,k))./Pros.scaleOflabeledProbabilities,0.0);
            end
        end
    end
    
    %% E步：用 p_k 和 π_k 计算各个未标记样本的高斯分支的后验期望 z_k 和所有样本的高斯分支的后验期望
    P_x_and_k = repmat(Prior, [numPixels 1]).*P_x_k;		% P_x_and_k：同时满足x和i的概率。图像像素数×分类数
    P_x = sum(P_x_and_k,2); % P_x：高斯概率密度。图像像素数×1
    P_k_x = P_x_and_k ./ repmat(P_x,[1 numState]); % P_k_x：后验概率。图像像素数×分类数
    for k=1:numState
        P_k_x(index_labeled{k},k)=1;
    end
    
    %% M步：用 z_k 计算 Θ_(t+1)；
    %     sumPix = sum(P_k_x);
    for k=1:numState
        % Update the centers
        mu(:,k) = (data_unlabeled*P_x_k_unlabeled(:,k) + sum(data_labeled{k},2)) / (sum(P_x_k_unlabeled(:,k)) + num_labeled(k));
        % Update the covariance matrices
        temp_data_unlabeled = data_unlabeled - repmat(mu(:,k),1,num_unlabeled);
        temp_data_labeled = data_labeled{k} - repmat(mu(:,k),1,num_labeled(k));
        Sigma(:,:,k) = ((repmat(P_x_k_unlabeled(:,k)',numVar, 1) .* temp_data_unlabeled*temp_data_unlabeled') + temp_data_labeled*temp_data_labeled')...
            / (sum(P_x_k_unlabeled(:,k)) + num_labeled(k));
        % Add a tiny variance to avoid numerical instability
        Sigma(:,:,k) = Sigma(:,:,k) + Pros.smallNumber.*diag(ones(numVar,1));
    end
    
    %% 计算每个超像素的后验概率 z_t 并分配到对应的各个像素
    P_k_sp=zeros(numSP,numState);
    for k=1:numState
        for i=1:numSP
            P_k_sp(i , k)=mean(P_x_k(SuperPixels_index{i} ,k));
            P_x_k(SuperPixels_index{i},k)=P_k_sp( i, k);
        end
    end
    
    
    %% 判别准则和超像素力
    %     S_ps_c = (P_k_sp(:,1) - P_k_sp(:,2)) ./ (P_k_sp(:,1) + P_k_sp(:,2));
    S_ps_c = log(P_k_sp(:,1) ./ P_k_sp(:,2));
    F_sp = zeros(1,numPixels);
    for i=1:numSP
        F_sp(SuperPixels_index{i}) = S_ps_c(i);
    end
    
    %% 计时暂停 %%%%%%%%%%%%%%%%%
    elipsedTime = toc;
    Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime;
    
    %% reshape
    F_sp=reshape(F_sp, numRow, numCol);
    P_x_k=reshape(P_x_k, numRow, numCol, numState);
    P_k_x=reshape(P_k_x, numRow, numCol, numState);
    
    %% 计时开始 %%%%%%%%%%%%%
    tic;
    
    %% 进行从GMM到ACM的通信：初始代，用式(16)：用z_k 初始化计算嵌入函数 \phi_k
    phi = Pros.epsilon.*g.*log(P_k_x(:,:,1)./P_k_x(:,:,2));
    
    %% 进行从GMM到ACM的通信：此时之前已经初始化过 \phi_0，则用式(20)：用\phi_k 、p_k 、z_k 计算并更新\phi_(t+1)；
    % Neumann 边界条件
    phi=NeumannBoundCond(phi);
    [phi_x,phi_y]=gradient(phi);
    sqrtOfGradientPhi=sqrt(phi_x.^2 + phi_y.^2);
    Pros.smallNumber=Pros.smallNumber;
    nx=phi_x./(sqrtOfGradientPhi+Pros.smallNumber); % add a small positive number to avoid division by zero
    ny=phi_y./(sqrtOfGradientPhi+Pros.smallNumber);
    [nxx,~]=gradient(nx);
    [~,nyy]=gradient(ny);
    curvature=nxx+nyy;
    L_phi=1./Pros.epsilon*P_k_x(:,:,1).*P_k_x(:,:,2).*( log(P_x_k(:,:,1)./P_x_k(:,:,2)) + Pros.beta.*(vx.*nx+vy.*ny+g.*curvature) - Pros.gamma.*g) ...
        + Pros.lambda .*F_sp .* sqrtOfGradientPhi; % DeltaPhi：嵌入函数的更新值。图像像素数×1
    % update \phi .
    phi=phi + Pros.timestep.*L_phi;
    
    %% 计时暂停 %%%%%%%%%%%%%%%%%
    elipsedTime = toc;
    Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime;
    
    %% 用两种计算 pi_t+1 的方式之一
    if '2' == Pros.piType
        
        %% 计时开始 %%%%%%%%%%%%%
        tic;
        %% 进行从ACM到GMM的通信：用[1]的式(25)
        % 式(25)，用\phi_k 计算π_(t+1)；
        Prior(1)=mean(mean((1./(1+ ...
            exp(Pros.epsilon .* Pros.lambda .* F_sp .* sqrtOfGradientPhi ./ P_k_x(:,:,1) ./ P_k_x(:,:,2) - ...
            Pros.gamma.*g - Pros.beta.*(vx.*nx+vy.*ny+g.*curvature) - phi./Pros.epsilon)))));
        Prior(2)=1-Prior(1);
        
        %% 计时暂停 %%%%%%%%%%%%%%%%%
        elipsedTime = toc;
        Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime;
        
    elseif '1' == Pros.piType
        %% 计时开始 %%%%%%%%%%%%%
        tic;
        
        %% 进行从ACM到GMM的通信：用[1]的式(23)
        % 式(23)，用\phi_k 和p_k 计算π_(k+1)；
        Pi_vis(:,:,1) = 1 ./ (1 + exp(log(P_x_k(:,:,1) ./ P_x_k(:,:,2)) - phi./Pros.epsilon)); % Pi_vis：被分摊到每个像素点上的先验概率，用于可视化。图像像素数×分类数
        Pi_vis(:,:,2)=1 - Pi_vis(:,:,1);
        Prior(1) = mean(mean((Pi_vis(:,:,1)))); % Pi：先验概率。1×分类数
        Prior(2) = 1-Prior(1);
        
        %% 计时暂停 %%%%%%%%%%%%%%%%%
        elipsedTime = toc;
        Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime;
        
    end
    
    
    
    
    %% visualization
    if strcmp(Pros.isNotVisiualEvolutionAtAll,'no')
        % 生成二值图数据
        bwData=zeros(numRow, numCol);
        bwData(phi(:)>=0)=1;
        bwData = imbinarize(bwData);
        Pi_vis(:,1)=1./(1+exp(Pros.gamma-Pros.beta.*g.*curvature-phi./Pros.epsilon));
        Pi_vis(:,2)=1-Pi_vis(:,1);
        
        [ Pros ] = visualizeContours_ACMGMMandSemisupervised( Pros, image_original, image_processed, phi, L_phi,  bwData, P_k_x, P_x, P_x_k ,Pi_vis);
    end
    
    %% write data
    if (strcmp(Pros.isNotWriteDataAtAll,'no') && mod(Pros.iteration_outer,Pros.periodOfWriteData)==0)
        % 生成二值图数据
        bwData=zeros(numRow, numCol);
        bwData(phi(:)>=0)=1;
        bwData = reshape(bwData, numRow, numCol);
        bwData = imbinarize(bwData);
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
            [Pros ] = writeData_ACMGMMandSPsemisupervised_1(Pros, image_original, image_processed, phi, bwData, P_k_x, P_x, P_x_k, P_x_and_k, Prior, mu, Sigma);
        end
    end
    
    %%
    bwData=zeros(numRow, numCol);
    bwData(phi(:)>=0)=1;
    bwData = imbinarize(bwData);
    pixelChanged = xor(bwData, oldBwData);
    numPixelChanged = sum(pixelChanged(:));
    oldBwData = bwData;
    Pros.iteration_outer = Pros.iteration_outer+1;		% iteration add 1
    
end % end if Pros.initMethod

%% rest iteration

% while (Pros.elipsedEachTime<=Pros.numTime) % 比较同一时间的停机条件
% while (Pros.iteration_outer<=Pros.numIte  ration_outer) % 比较同一代数的停机条件
% while (Pros.iteration_outer<=Pros.numIteration_outer) % 给定收敛条件的停机条件
while (Pros.iteration_outer<=Pros.numIteration_outer &&	numPixelChanged>=Pros.numPixelChangedToContinue) % 给定收敛条件的停机条件
    
    %% reshape
    P_x_k=reshape(P_x_k, [], 2);
    
    %% 计时开始 %%%%%%%%%%%%
    tic;
    
    %% E步：用 Θ_t 计算各个未标记样本和有标记样本的高斯概率 p_t
    for k=1:numState
        P_x_k_unlabeled(:,k)= gaussPDF(image_data_reshaped(:,index_unlabeled), mu(:,k) , Sigma(:,:,k), Pros.smallNumber);
        P_x_k(index_unlabeled,k)=P_x_k_unlabeled(:,k);
        for kk=1:numState
            if kk==k  % 如果要写入的划分区域和标签相同，则该图像的有标记样本的位置的 P_x_k 为一个比 P_x_k 所在列的值的最大值还大一些的值。
                P_x_k(index_labeled{kk},k)=min(max(P_x_k(index_unlabeled,k)).*Pros.scaleOflabeledProbabilities);
            else % 如果要写入的划分区域和标签不相同，则该图像的有标记样本的位置的 P_x_k 为一个比 P_x_k 所在列的值的最小值还小一些的值。
                P_x_k(index_labeled{kk},k)=max(min(P_x_k(index_unlabeled,k))./Pros.scaleOflabeledProbabilities);
            end
        end
    end
    
    %% E步：用 p_t 和 π_t 计算各个未标记样本的高斯分支的后验期望 z_t 和所有样本的高斯分支的后验期望
    
    P_x_and_k = repmat(Prior, [numPixels 1]).*P_x_k;		% P_x_and_k：同时满足x和i的概率。图像像素数×分类数
    P_x = sum(P_x_and_k,2); % P_x：高斯概率密度。图像像素数×1
    P_k_x = P_x_and_k ./ repmat(P_x,[1 numState]); % P_k_x：后验概率。图像像素数×分类数
    for k=1:numState
        P_k_x(index_labeled{k},k)=1;
    end
    
    %% M步：用 z_t 计算 Θ_(t+1)；
    %     sumPix = sum(P_k_x);
    for k=1:numState
        % Update the centers
        mu(:,k) = (data_unlabeled*P_x_k_unlabeled(:,k)+sum(data_labeled{k},2)) / (sum(P_x_k_unlabeled(:,k))+num_labeled(k));
        % Update the covariance matrices
        temp_mu = data_unlabeled - repmat(mu(:,k),1,num_unlabeled);
        Sigma(:,:,k) = (repmat(P_x_k_unlabeled(:,k)',numVar, 1) .* temp_mu*temp_mu') / (sum(P_x_k_unlabeled(:,k))+num_labeled(k));
        % Add a tiny variance to avoid numerical instability
        Sigma(:,:,k) = Sigma(:,:,k) + Pros.smallNumber.*diag(ones(numVar,1));
    end
    
    
    
    %% 计算每个超像素的后验概率 z_t 并分配到对应的各个像素
    for k=1:numState
        for i=1:numSP
            P_k_sp(i , k)=mean(P_x_k(SuperPixels_index{i} ,k));
            P_x_k(SuperPixels_index{i},k)=P_k_sp( i, k);
        end
    end
    
    
    %% 判别准则和超像素力
    %     S_ps_c = (P_k_sp(:,1) - P_k_sp(:,2)) ./ (P_k_sp(:,1) + P_k_sp(:,2));
    S_ps_c = log(P_k_sp(:,1) ./ P_k_sp(:,2));
    for i=1:numSP
        F_sp(SuperPixels_index{i}) = S_ps_c(i);
    end
    
    %% 计时暂停 %%%%%%%%%%%%%%%%%
    elipsedTime = toc;
    Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime;
    
    %% reshape
    F_sp=reshape(F_sp, numRow, numCol);
    P_x_k=reshape(P_x_k, numRow, numCol, 2);
    P_k_x=reshape(P_k_x, numRow, numCol, 2);
    
    %% 计时开始 %%%%%%%%%%%%%
    tic;
    
    
    %% 进行从GMM到ACM的通信：此时之前已经初始化过 \phi_0，则用式(20)：用\phi_t 、p_t 、z_t 计算并更新\phi_(t+1)；
    % Neumann 边界条件
    phi=NeumannBoundCond(phi);
    [phi_x,phi_y]=gradient(phi);
    sqrtOfGradientPhi=sqrt(phi_x.^2 + phi_y.^2);
    Pros.smallNumber=Pros.smallNumber;
    nx=phi_x./(sqrtOfGradientPhi+Pros.smallNumber); % add a small positive number to avoid division by zero
    ny=phi_y./(sqrtOfGradientPhi+Pros.smallNumber);
    [nxx,~]=gradient(nx);
    [~,nyy]=gradient(ny);
    curvature=nxx+nyy;
    L_phi=1./Pros.epsilon*P_k_x(:,:,1).*P_k_x(:,:,2).*(log(P_x_k(:,:,1)./P_x_k(:,:,2)) + Pros.beta.*(vx.*nx+vy.*ny+g.*curvature) - Pros.gamma.*g) ...
        + Pros.lambda .*F_sp .* sqrtOfGradientPhi; % DeltaPhi：嵌入函数的更新值。图像像素数×1
    % update \phi .
    phi=phi + Pros.timestep.*L_phi;
    
    %% 计时暂停 %%%%%%%%%%%%%%%%%
    elipsedTime = toc;
    Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime;
    
    %% 用两种计算 pi_t+1 的方式之一
    if '2' == Pros.piType
        
        %% 计时开始 %%%%%%%%%%%%%
        tic;
        %% 进行从ACM到GMM的通信：用[1]的式(25)
        % 式(25)，用\phi_k 计算π_(t+1)；
        Prior(1)=mean(mean((1./(1+ ...
            exp(Pros.epsilon .* Pros.lambda .* F_sp .* sqrtOfGradientPhi ./ P_k_x(:,:,1) ./ P_k_x(:,:,2) - ...
            Pros.gamma.*g - Pros.beta.*(vx.*nx+vy.*ny+g.*curvature) - phi./Pros.epsilon)))));
        Prior(2)=1-Prior(1);
        
        %% 计时暂停 %%%%%%%%%%%%%%%%%
        elipsedTime = toc;
        Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime;
        
    elseif '1' == Pros.piType
        %% 计时开始 %%%%%%%%%%%%%
        tic;
        
        %% 进行从ACM到GMM的通信：用[1]的式(23)
        % 式(23)，用\phi_t 和p_t 计算π_(t+1)；
        Pi_vis(:,:,1) = 1 ./ (1 + exp(log(P_x_k(:,:,1) ./ P_x_k(:,:,2)) - phi./Pros.epsilon)); % Pi_vis：被分摊到每个像素点上的先验概率，用于可视化。图像像素数×分类数
        Pi_vis(:,:,2)=1 - Pi_vis(:,:,1);
        Prior(1) = mean(mean((Pi_vis(:,:,1)))); % Pi：先验概率。1×分类数
        Prior(2) = 1-Prior(1);
        
        %% 计时暂停 %%%%%%%%%%%%%%%%%
        elipsedTime = toc;
        Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime;
        
    end
    
    
    %% visualization
    if strcmp(Pros.isNotVisiualEvolutionAtAll,'no')
        % 生成二值图数据
        bwData=zeros(numPixels,1);
        bwData(reshape(phi, [], 1)>=0)=1;
        bwData = imbinarize(bwData);
        Pi_vis(:,1)=1./(1+exp(Pros.gamma-Pros.beta.*g.*curvature-phi./Pros.epsilon));
        Pi_vis(:,2)=1-Pi_vis(:,1);
        
        [ Pros ] = visualizeContours_ACMGMMandSemisupervised( Pros, image_original, image_processed, phi, L_phi,  bwData, P_k_x, P_x, P_x_k ,Pi_vis);
    end
    
    %% write data
    if (strcmp(Pros.isNotWriteDataAtAll,'no') && mod(Pros.iteration_outer,Pros.periodOfWriteData)==0)
        % 生成二值图数据
        bwData=zeros(numPixels,1);
        bwData(reshape(phi, [], 1)>=0)=1;
        bwData = reshape(bwData, numRow, numCol);
        bwData = imbinarize(bwData);
        filename_bwData = [Pros.filename_originalImage(1:end-4) '_iter' num2str(Pros.iteration_outer,'%04d') '_time' num2str(Pros.elipsedEachTime,'%.4f') '_' Pros.evolutionMethod '.bmp'];
        filepath_bwData = fullfile(Pros.folderpath_bwData, filename_bwData);
        imwrite(bwData, filepath_bwData, 'bmp');
        if exist(filepath_bwData,'file')
            disp(['已保存分割二值图数据 ' filename_bwData]);
        else
            disp(['未保存分割二值图数据 ' filename_bwData]);
        end
        
        if  strcmp(Pros.isWriteData,'yes')==1
            [Pros ] = writeData_ACMGMMandSPsemisupervised_1(Pros, image_original, image_processed, phi, bwData, P_k_x, P_x, P_x_k, P_x_and_k, Prior, mu, Sigma);
        end
    end
    
    %%
    bwData(phi>=0)=1;
%     bwData = imbinarize(bwData);
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


