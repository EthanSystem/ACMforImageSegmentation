function [Pros, phi] = evolution_ACMGMMandSPsemisupervised_2_2( Pros, image_original ,image_processed , seedsIndex1, seedsIndex2, phi0, Prior0, mu0, Sigma0 )
% evolution_ACMGMMandSPsemisupervised_2 ����1 �ǻ�������[1]���ݻ�ģ�͵ĸ��졣�õ�������Ϣ��ʽ(25�������������ʼ�����İ�ල��Ϣ�����볬��������

% input:
% Pros��Pros�ṹ�塣
% image_original��Ҫ�����ͼ���Ӧ��ԭʼͼ��
% image_processed��Ҫ�����ͼ��
% seedsIndex1: ���ӱ��1
% seedsIndex2: ���ӱ��2
% phi0: ��ʼ������
% Prior0: ��ʼ���顣
% mu0: ��ʼ��ֵ��
% Sigma0: ��ʼЭ���

% output:
% phi�����յ�Ƕ�뺯����
% Pros���ݻ���������µ�Pros�ṹ�塣

%  �������µ��������������Ľ���
% Gao, G. and C. Wen, et al. (2017). "Fast and robust image segmentation with active contours and Student's-t mixture model." Pattern Recognition 63: 71-86.
% ���������������ʽ���������볬���������������ػ���

%% initialization
numState = 2;	% GMM��֦�����ڱ��㷨��=2����֧1��ʾǰ������֧2��ʾ�������ڱ�������֦������2��������������Ͳ������������
[numRow, numCol, numVar] = deal(Pros.sizeOfImage(1),Pros.sizeOfImage(2),Pros.sizeOfImage(3));
numPixels = numRow * numCol;

phi = phi0; % ��ʼ���� Ƕ�뺯�������������� .
% �����ʼ�����ǽ�Ծ��������ô�� phi ���ó�ʼ�Ľ�Ծֵ
if strcmp(Pros.initializeType, 'staircase')==1
    phi = phi.*Pros.contoursInitValue;
end

%% ��ʼ��ͣ������
oldBwData=zeros(numRow, numCol);
oldBwData(phi(:)>=0)=1;
oldBwData = im2bw(oldBwData);
numPixelChanged = numPixels;

%% ѡȡ��ɫ�ռ�,
% TODO �Ժ󵥶���Ϊ����
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
image_data_reshaped = (reshape(image_data ,[],numVar)).';   % Ҫ�����ͼ�����ݡ�ά����������
image_data_RGB = im2single(image_original);


%% ��ʼ����������
% Prior��������ʡ�1������������ֵ��ά������֦����Э���ά����ά����������
mu = mu0;
Sigma = Sigma0;
Prior = Prior0;


%% ��ʱ��ʼ %%%%%%%%%%%%
tic;


%% �ֱ��ȡ��������ǩ�ı�ǣ��ޱ�ǩ�ı��
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


%% ��ʱ��ͣ %%%%%%%%%%%%%%%%%
elipsedTime = toc;
Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime;


%% initialize the definition of P_x_k
P_x_k = zeros( numPixels, numState)+Pros.smallNumber; % P_x_k�����ص��������ʡ�ͼ������������������Ϊ�˷�ֹ�ں���ļ����г��ַ�ĸΪ0���������˽�����������Ϊ����ĺ�С��������ͬ��
P_k_x = zeros( numPixels, numState)+Pros.smallNumber; % P_x_k�����صĺ�����ʡ�ͼ����������������



% %% ��ʱ��ʼ %%%%%%%%%%%%
% tic;



%% �� vl-feat ���ĺ������ɳ����ء�
% segmentsValue �洢����ÿ�����ر����ֵĳ����صı�ǩֵ
SuperPixels_labelsMap=vl_slic(image_data_RGB, Pros.SuperPixels_lengthOfSide, Pros.SuperPixels_regulation);

%% find the number of SP.
numSP=max(SuperPixels_labelsMap(:))+1;


%% �Ѷ�Ӧ�ڻ��ֳ����ĳ����ص� segments ��Ϊ��Ǹó����صļǺţ��� segments
% �������ҵ���Ӧ�ó����صļǺţ���Ӧͼ���HSVֵ���� imhist() ����ֱ��ͼ���� histcounts() ��Ϊ��ȡֱ��ͼ�����ݷ�����
% ��������� SuperPixels(i).histogram ������ͨ��ֵ���С�

for i=1:numSP
    [row,col,~]=find(single(SuperPixels_labelsMap)==i-1);
    [index]=find(single(SuperPixels_labelsMap)==i-1);
    SuperPixels_position{i}=[row col];
    SuperPixels_index{i}=index;
    SuperPixels_color{i}=image_data(row,col,:);
end

% ȥ����Щ�յı�ǩֵ
for i=numSP:-1:1
    if isempty(SuperPixels_position{i})
        SuperPixels_position(i)=[];
        SuperPixels_index(i)=[];
        SuperPixels_color(i)=[];
    end
end

clear numSP;
numSP=size(SuperPixels_index,2);



%% ������ɫ��ֵ
SP_color=zeros(numSP,3);
for i=1:numSP
    SP_color(i,1) = mean(mean(SuperPixels_color{i}(:,:,1)));
    SP_color(i,2) = mean(mean(SuperPixels_color{i}(:,:,2)));
    SP_color(i,3) = mean(mean(SuperPixels_color{i}(:,:,3)));
end

%% ���㳬���ؿռ�λ�õ����� .
SP_center_position=zeros(numSP,2);
for i=1:1:numSP
    SP_center_position(i,1)=mean(SuperPixels_position{i}(:,1),1);
    SP_center_position(i,2)=mean(SuperPixels_position{i}(:,2),1);
end

%% ��seeds�л�ȡ����ǵĳ�����
SP_mask_labeled=zeros(numSP,numState+1);
for k=1:numState
    for i=1:numSP
        if intersect(SuperPixels_index{i} , index_labeled{k})
            SP_mask_labeled(i,k)=1;
        end
    end
end
SP_mask_labeled(xor(ones(numSP,1),or(SP_mask_labeled(:,1),SP_mask_labeled(:,2))),end)=1;
for k=1:numState
    numSP_labeled(k)=sum(SP_mask_labeled(:,k));
end
numSP_labeled(k+1)=sum(SP_mask_labeled(:,end));

%% �����ۺ�����
SP_feature = computeSPFeature( SP_color, SP_center_position, numSP, Pros);


% %% ��ʱ��ͣ %%%%%%%%%%%%%%%%%
% elipsedTime = toc;
% Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime;

%% ���峬���ص��������ʺͺ������
P_sp_k =zeros( numSP, numState)+Pros.smallNumber; % P_sp_k�������ص��������ʡ�ͼ������������������Ϊ�˷�ֹ�ں���ļ����г��ַ�ĸΪ0���������˽�����������Ϊ����ĺ�С��������ͬ��
P_k_sp =zeros( numSP, numState)+Pros.smallNumber; % P_k_sp�������صĺ�����ʡ�ͼ������������������

%% ���㡢���ӻ���ʾ�ָ�����
if strcmp(Pros.isVisualSegoutput ,'yes')==1
    [segments_outline, segments_imgMarkup,segments_RGBImgMarkup]=fun_visual_SpSegmentations...
        ( image_processed, image_original, SuperPixels_labelsMap, SP_center_position, numSP, Pros);
    Pros.segOutline=segments_outline;
end


%% �����ʼ����ʽ�����������
if (strcmp(Pros.initMethod,'kmeans_ACMGMM')==1 || strcmp(Pros.initMethod,'circle_ACMGMM')==1)
    
    
    %% ��ʱ��ʼ %%%%%%%%%%%%
    tic;
    
    
    %% generate edge indicator function at gray image.
    image_gray=rgb2gray(image_data);
    G=fspecial('gaussian',Pros.hsize ,Pros.sigma);
    image_smooth=imfilter(image_gray,G,'same');  % smooth image by Gaussiin convolution
    [Ix,Iy]=gradient(image_smooth);
    f=Ix.^2+Iy.^2;
    g=1./(1+f);  % edge indicator function.
    [vx,vy]=gradient(g); % gradient of edge indicator function.
    
    
    %% ��ʱ��ͣ %%%%%%%%%%%%%%%%%
    elipsedTime = toc;
    Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime;
    
    
    %% visualization
    if strcmp(Pros.isNotVisiualEvolutionAtAll,'no')
        % ���ɶ�ֵͼ����
        bwData=zeros(numPixels,1);
        bwData(phi>=0)=1;
        bwData = im2bw(bwData);
        L_phi = zeros(Pros.numData,1);
        Px = zeros(Pros.numData,1);
        
        [Pros]=visualizeContours_ACMandGMM_new_fixedTime(Pros, image_original, image_processed, phi, L_phi, bwData, P_k_x, Px, P_x_k, Pi_vis );
    end
    %% write data
    if (strcmp(Pros.isNotWriteDataAtAll,'no') && mod(Pros.iteration_outer,Pros.periodOfWriteData)==0)
        % ���ɶ�ֵͼ����
        bwData=zeros(numPixels,1);
        bwData(phi>=0)=1;
        bwData = reshape(bwData, numRow, numCol);
        bwData = im2bw(bwData);
        filename_bwData = [Pros.filename_originalImage(1:end-4) '_iter' num2str(Pros.iteration_outer,'%04d') '_time' num2str(Pros.elipsedEachTime,'%.4f') '_' Pros.evolutionMethod '.bmp'];
        filepath_bwData = fullfile(Pros.folderpath_bwData, filename_bwData);
        imwrite(bwData, filepath_bwData, 'bmp');
        if exist(filepath_bwData,'file')
            disp(['�ѱ���ָ��ֵͼ���� ' filename_bwData]);
        else
            disp(['δ����ָ��ֵͼ���� ' filename_bwData]);
        end
        
        if  strcmp(Pros.isWriteData,'yes')==1
            [Pros ] = writeData_ACMandGMM_new_fixedTime(Pros, image_original, image_processed, phi, bwData, P_i_x, Px, P_x_k, P_sp_and_k, Pi_vis, Pi, mu, Sigma);
        end
    end
    
    %%
    bwData=zeros(numRow, numCol);
    bwData(phi>=0)=1;
    bwData = im2bw(bwData);
    pixelChanged = xor(bwData, oldBwData);
    numPixelChanged = sum(pixelChanged(:));
    oldBwData = bwData;
    Pros.iteration_outer = Pros.iteration_outer+1;		% iteration add 1
    
    
    %% ����������ĳ�ʼ�����
else
    
    
    %% ��ʱ��ʼ %%%%%%%%%%%%
    tic;
    
    
    %% generate edge indicator function at gray image.
    image_gray=rgb2gray(image_data);
    G=fspecial('gaussian',Pros.hsize ,Pros.sigma);
    image_smooth=imfilter(image_gray,G,'same');  % smooth image by Gaussiin convolution
    [Ix,Iy]=gradient(image_smooth);
    f=Ix.^2+Iy.^2;
    g=1./(1+f);  % edge indicator function.
    [vx,vy]=gradient(g); % gradient of edge indicator function.
    
    
    
    
    %% E�����æ�_k �����˹����p_k
    for k=1:numState
        P_sp_k(SP_mask_labeled(:,end)==1,k) = gaussPDF(SP_feature(:,SP_mask_labeled(:,end)==1), mu(:,k) , Sigma(:,:,k) , Pros.smallNumber);
        % ���Ҫд��Ļ�������ͱ�ǩ��ͬ�����ͼ����б��������λ�õ� P_sp_k Ϊһ���� P_sp_k �����е�ֵ�����ֵ����һЩ��ֵ��
        P_sp_k(SP_mask_labeled(:,k)==1,k) = min(max(P_sp_k(SP_mask_labeled(:,end)==1,k)).*Pros.scaleOflabeledProbabilities,1.0);
        % ���Ҫд��Ļ�������ͱ�ǩ����ͬ�����ͼ����б��������λ�õ� P_sp_k Ϊһ���� P_sp_k �����е�ֵ����Сֵ��СһЩ��ֵ��
        P_sp_k(SP_mask_labeled(:,setdiff(1:numState,k))==1,k) = max(min(P_sp_k(SP_mask_labeled(:,end)==1,k))./Pros.scaleOflabeledProbabilities,0.0);
        %         for kk=1:numState
        %             if kk==k  % ���Ҫд��Ļ�������ͱ�ǩ��ͬ�����ͼ����б��������λ�õ� P_sp_k Ϊһ���� P_sp_k �����е�ֵ�����ֵ����һЩ��ֵ��
        %                 P_sp_k(SP_mask_labeled(:,kk)==0,k)=min(max(P_sp_k(SP_mask_labeled(:,k),k)).*Pros.scaleOflabeledProbabilities,1.0);
        %             else % ���Ҫд��Ļ�������ͱ�ǩ����ͬ�����ͼ����б��������λ�õ� P_sp_k Ϊһ���� P_sp_k �����е�ֵ����Сֵ��СһЩ��ֵ��
        %                 P_sp_k(SP_mask_labeled(:,kk)==0,k)=max(min(P_sp_k(SP_mask_labeled(:,k),k))./Pros.scaleOflabeledProbabilities,0.0);
        %             end
        %         end
    end
    
    %% E������p_k �ͦ�_k �����˹��֧�ĺ�������z_k
    P_sp_and_k = repmat(Prior, [numSP 1]).*P_sp_k;		% P_x_and_i��ͬʱ����x��i�ĸ��ʡ�ͼ����������������
    P_sp = sum(P_sp_and_k,2); % P_sp����˹�����ܶȡ�ͼ����������1
    P_k_sp = P_sp_and_k ./ repmat(P_sp,[1 numState]); % P_i_x��������ʡ�ͼ����������������
    for k=1:numState
        P_k_sp(SP_mask_labeled(:,k)==1,k)=1;
    end
    
    %% M������z_k ���㦨_(k+1)��
    for k=1:numState
        % Update the centers
        sum_P_k_sp = sum(P_k_sp(SP_mask_labeled(:,k)==1));
        mu(:,k) = (SP_feature(:,SP_mask_labeled(:,end)==1)*P_k_sp(SP_mask_labeled(:,end)==1,k) + sum(SP_feature(:,SP_mask_labeled(:,k)==1),2))...
            / (sum_P_k_sp + numSP_labeled(k));
        % Update the covariance matrices
        temp_SP_unlabeled = SP_feature(:,SP_mask_labeled(:,end)==1) - repmat(mu(:,k),1,numSP_labeled(end));
        temp_SP_labeled = SP_feature(:,SP_mask_labeled(:,k)==1) - repmat(mu(:,k),1,numSP_labeled(k));
        Sigma(:,:,k) = ((repmat(P_k_sp(SP_mask_labeled(:,end)==1,k)',[numVar, 1]) .* temp_SP_unlabeled*temp_SP_unlabeled') + (temp_SP_labeled*temp_SP_labeled'))...
            / (sum_P_k_sp + numSP_labeled(k));
        % Add a tiny variance to avoid numerical instability
        Sigma(:,:,k) = Sigma(:,:,k) + Pros.smallNumber.*diag(ones(numVar,1));
    end
    
    
    %% �б�׼��ͳ�������
    % �����б�׼��
%     S_ps_c = (P_k_sp(:,1) - P_k_sp(:,2)) ./ (P_k_sp(:,1) + P_k_sp(:,2)) ;
    S_ps_c = log(P_k_sp(:,1) ./ P_k_sp(:,2)) ;
    % ���峬������
    F_sp = S_ps_c;
    F_SP = zeros(1,numPixels);
    % ����ÿ�������صĳ�������ֵ��ÿ������
    for i=1:numSP
        F_SP(SuperPixels_index{i}) = F_sp(i);
    end
    
    %% ��ʱ��ͣ %%%%%%%%%%%%%%%%%
    elipsedTime = toc;
    Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime;
    
    %% ����ÿ�������أ������������ֵ��ÿ��������
    for k=1:numState
        for i=1:numSP
            P_x_k(SuperPixels_index{i}, k) = P_sp_k(i,k);
            P_k_x(SuperPixels_index{i}, k) = P_k_sp(i,k);
        end
    end
    
    %% reshape
    F_SP=reshape(F_SP, [numRow, numCol]);
    P_x_k=reshape(P_x_k, [numRow, numCol, numState]);
    P_k_x=reshape(P_k_x, [numRow, numCol, numState]);
    
    %% ��ʱ��ʼ %%%%%%%%%%%%%
    tic;
    
    %% ���д�GMM��ACM��ͨ�ţ���ʼ������ʽ(16)����z_k ��ʼ������Ƕ�뺯��\phi_0
    phi = Pros.epsilon.*g.*log(P_k_x(:,:,1)./P_k_x(:,:,2));
    
    %% ���д�GMM��ACM��ͨ�ţ���ʱ֮ǰ�Ѿ���ʼ���� \phi_0������ʽ(20)����\phi_k ��p_k ��z_k ���㲢����\phi_(k+1)��
    %     phi=reshape(phi, numRow, numCol);
    % Neumann �߽�����
    phi=NeumannBoundCond(phi);
    [phi_x,phi_y]=gradient(phi);
    sqrtOfGradientPhi=sqrt(phi_x.^2 + phi_y.^2);
    smallNumber=Pros.smallNumber;
    nx=phi_x./(sqrtOfGradientPhi+smallNumber); % add a small positive number to avoid division by zero
    ny=phi_y./(sqrtOfGradientPhi+smallNumber);
    [nxx,~]=gradient(nx);
    [~,nyy]=gradient(ny);
    curvature=nxx+nyy;
    %     curvature=reshape(curvature,[],1);
    %     nx=reshape(nx,[],1);
    %     ny=reshape(ny,[],1);
    %     phi=reshape(phi, [],1);
    L_phi=1./Pros.epsilon*P_k_x(:,:,1).*P_k_x(:,:,2).*(log(P_x_k(:,:,1)./P_x_k(:,:,2)) + Pros.beta.*(vx.*nx+vy.*ny+g.*curvature) - Pros.gamma.*g)...
        + Pros.lambda .*F_SP .* sqrtOfGradientPhi; % DeltaPhi��Ƕ�뺯���ĸ���ֵ��ͼ����������1
    % update \phi .
    phi=phi + Pros.timestep.*L_phi;
    
    
    
    %% ���д�ACM��GMM��ͨ�ţ���[1]��ʽ(25)
    % ʽ(25)����\phi_k ����\pi_(k+1)��
    Prior(1)=mean(mean(1./(1+exp(Pros.gamma.*g - Pros.beta.*(vx.*nx+vy.*ny+g.*curvature) - phi./Pros.epsilon))));
    Prior(2)=1-Prior(1);
    
    
    %% ��ʱ��ͣ %%%%%%%%%%%%%%%%%
    elipsedTime = toc;
    Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime;
    
    
    %% visualization
    if strcmp(Pros.isNotVisiualEvolutionAtAll,'no')
        % ���ɶ�ֵͼ����
        bwData=zeros(numPixels,1);
        bwData(phi>=0)=1;
        bwData = im2bw(bwData);
        Pi_vis=zeros(Pros.numData, 2);
        
        [Pros]=visualizeContours_ACMandGMM_new_fixedTime(Pros, image_original, image_processed, phi, L_phi, bwData, P_i_x, Px, P_x_k, Pi_vis );
    end
    %% write data
    if (strcmp(Pros.isNotWriteDataAtAll,'no') && mod(Pros.iteration_outer,Pros.periodOfWriteData)==0)
        % ���ɶ�ֵͼ����
        bwData=zeros(numPixels,1);
        bwData(phi>=0)=1;
        bwData = reshape(bwData, numRow, numCol);
        bwData = im2bw(bwData);
        % 	filename_bwData = [Pros.filename_originalImage(1:end-4) '_iter' num2str(Pros.iteration_outer,'%04d') '_time' num2str(Pros.elipsedEachTime,'%.4f') '_' Pros.evolutionMethod '_bwData.bmp'];
        filename_bwData = [Pros.filename_originalImage(1:end-4) '_iter' num2str(Pros.iteration_outer,'%04d') '_time' num2str(Pros.elipsedEachTime,'%.4f') '.bmp'];
        filepath_bwImage = fullfile(Pros.folderpath_bwData, filename_bwData);
        imwrite(bwData, filepath_bwImage, 'bmp');
        if exist(filepath_bwImage,'file')
            disp(['�ѱ���ָ��ֵͼ ' filename_bwData]);
        else
            disp(['δ����ָ��ֵͼ ' filename_bwData]);
        end
        
        if  strcmp(Pros.isWriteData,'yes')==1
            [Pros ] = writeData_ACMandGMM_new_fixedTime(Pros, image_original, image_processed, phi, bwData, P_i_x, Px, P_x_k, P_sp_and_k, Prior, mu, Sigma);
        end
    end
    
    %%
    bwData=zeros(numRow, numCol);
    oldBwData(phi(:)>=0)=1;
    bwData = im2bw(bwData);
    pixelChanged = xor(bwData, oldBwData);
    numPixelChanged = sum(pixelChanged(:));
    oldBwData = bwData;
    Pros.iteration_outer = Pros.iteration_outer+1;		% iteration add 1
    
    
    
end % end if Pros.initMethod

%% �ڶ��׶Σ��ڳ����ؼ����ݻ�

% while (Pros.elipsedEachTime<=Pros.numTime) % �Ƚ�ͬһʱ���ͣ������
% while (Pros.iteration_outer<=Pros.numIteration_SP) % �Ƚ�ͬһ������ͣ������
while (Pros.iteration_outer<=Pros.numIteration_SP) % ��������������ͣ������
    
    %% reshape
    F_SP=reshape(F_SP, [1, numPixels]);
    P_x_k=reshape(P_x_k, [numPixels, numState]);
    P_k_x=reshape(P_k_x, [numPixels, numState]);
    
    
    %% ��ʱ��ʼ %%%%%%%%%%%%
    tic;
    
    %% E�����æ�_k �����˹����p_k
    %     P_sp_k=zeros(numSP,2);
    for k=1:numState
        P_sp_k(SP_mask_labeled(:,end)==1,k) = gaussPDF(SP_feature(:,SP_mask_labeled(:,end)==1), mu(:,k) , Sigma(:,:,k) , Pros.smallNumber);
        % ���Ҫд��Ļ�������ͱ�ǩ��ͬ�����ͼ����б��������λ�õ� P_sp_k Ϊһ���� P_sp_k �����е�ֵ�����ֵ����һЩ��ֵ��
        P_sp_k(SP_mask_labeled(:,k)==1,k) = min(max(P_sp_k(SP_mask_labeled(:,end)==1,k)).*Pros.scaleOflabeledProbabilities,1.0);
        % ���Ҫд��Ļ�������ͱ�ǩ����ͬ�����ͼ����б��������λ�õ� P_sp_k Ϊһ���� P_sp_k �����е�ֵ����Сֵ��СһЩ��ֵ��
        P_sp_k(SP_mask_labeled(:,setdiff(1:numState,k))==1,k) = max(min(P_sp_k(SP_mask_labeled(:,end)==1,k))./Pros.scaleOflabeledProbabilities,0.0);
        %         for kk=1:numState
        %             if kk==k  % ���Ҫд��Ļ�������ͱ�ǩ��ͬ�����ͼ����б��������λ�õ� P_sp_k Ϊһ���� P_sp_k �����е�ֵ�����ֵ����һЩ��ֵ��
        %                 P_sp_k(SP_mask_labeled(:,kk)==0,k)=min(max(P_sp_k(SP_mask_labeled(:,k),k)).*Pros.scaleOflabeledProbabilities,1.0);
        %             else % ���Ҫд��Ļ�������ͱ�ǩ����ͬ�����ͼ����б��������λ�õ� P_sp_k Ϊһ���� P_sp_k �����е�ֵ����Сֵ��СһЩ��ֵ��
        %                 P_sp_k(SP_mask_labeled(:,kk)==0,k)=max(min(P_sp_k(SP_mask_labeled(:,k),k))./Pros.scaleOflabeledProbabilities,0.0);
        %             end
        %         end
    end
    
    %% E������p_k �ͦ�_k �����˹��֧�ĺ�������z_k
    P_sp_and_k = repmat(Prior, [numSP 1]).*P_sp_k;		% P_x_and_i��ͬʱ����x��i�ĸ��ʡ�ͼ����������������
    P_sp = sum(P_sp_and_k,2); % P_sp����˹�����ܶȡ�ͼ����������1
    P_k_sp = P_sp_and_k ./ repmat(P_sp,[1 numState]); % P_i_x��������ʡ�ͼ����������������
    for k=1:numState
        P_k_sp(SP_mask_labeled(:,k)==1,k)=1;
    end
    
    %% M������z_k ���㦨_(k+1)��
    for k=1:numState
        % Update the centers
        sum_P_k_sp = sum(P_k_sp(SP_mask_labeled(:,k)==1));
        mu(:,k) = (SP_feature(:,SP_mask_labeled(:,end)==1)*P_k_sp(SP_mask_labeled(:,end)==1,k) + sum(SP_feature(:,SP_mask_labeled(:,k)==1),2)) / (sum_P_k_sp + numSP_labeled(k));
        % Update the covariance matrices
        temp_SP_unlabeled = SP_feature(:,SP_mask_labeled(:,end)==1) - repmat(mu(:,k),1,numSP_labeled(end));
        temp_SP_labeled = SP_feature(:,SP_mask_labeled(:,k)==1) - repmat(mu(:,k),1,numSP_labeled(k));
        Sigma(:,:,k) = ((repmat(P_k_sp(SP_mask_labeled(:,end)==1,k)',[numVar, 1]) .* temp_SP_unlabeled*temp_SP_unlabeled') + (temp_SP_labeled*temp_SP_labeled'))...
            / (sum_P_k_sp + numSP_labeled(k));
        % Add a tiny variance to avoid numerical instability
        Sigma(:,:,k) = Sigma(:,:,k) + Pros.smallNumber.*diag(ones(numVar,1));
    end
    
    
    %% �б�׼��ͳ�������
%     % �����б�׼��
% %     S_ps_c = (P_k_sp(:,1) - P_k_sp(:,2)) ./ (P_k_sp(:,1) + P_k_sp(:,2)) ;
%     S_ps_c = log(P_k_sp(:,1) ./ P_k_sp(:,2)) ;
%     % ���峬������
%     F_sp = S_ps_c;
%     F_SP = zeros(1,numPixels);
%     % ����ÿ�������صĳ�������ֵ��ÿ������
%     for i=1:numSP
%         F_SP(SuperPixels_index{i}) = F_sp(i);
%     end
    
    %% ��ʱ��ͣ %%%%%%%%%%%%%%%%%
    elipsedTime = toc;
    Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime;
    
    
    %% ����ÿ�������أ������������ֵ��ÿ��������
    for k=1:numState
        for i=1:numSP
            P_x_k(SuperPixels_index{i}, k) = P_sp_k(i,k);
            P_k_x(SuperPixels_index{i}, k) = P_k_sp(i,k);
        end
    end
    
    %% reshape
    F_SP=reshape(F_SP, [numRow, numCol]);
    P_x_k=reshape(P_x_k, [numRow, numCol, numState]);
    P_k_x=reshape(P_k_x, [numRow, numCol, numState]);
    
    %% ��ʱ��ʼ %%%%%%%%%%%%%
    tic;
    
    
    %% ���д�GMM��ACM��ͨ�ţ���ʱ֮ǰ�Ѿ���ʼ���� \phi_0������ʽ(20)����\phi_k ��p_k ��z_k ���㲢����\phi_(k+1)��
    %     phi=reshape(phi, numRow, numCol);
    % Neumann �߽�����
    phi=NeumannBoundCond(phi);
    [phi_x,phi_y]=gradient(phi);
    sqrtOfGradientPhi=sqrt(phi_x.^2 + phi_y.^2);
    smallNumber=Pros.smallNumber;
    nx=phi_x./(sqrtOfGradientPhi+smallNumber); % add a small positive number to avoid division by zero
    ny=phi_y./(sqrtOfGradientPhi+smallNumber);
    [nxx,~]=gradient(nx);
    [~,nyy]=gradient(ny);
    curvature=nxx+nyy;
    %     curvature=reshape(curvature,[],1);
    %     nx=reshape(nx,[],1);
    %     ny=reshape(ny,[],1);
    %     phi=reshape(phi, [],1);
    L_phi=1./Pros.epsilon*P_k_x(:,:,1).*P_k_x(:,:,2).*(log(P_x_k(:,:,1)./P_x_k(:,:,2)) + Pros.beta.*(vx.*nx+vy.*ny+g.*curvature) - Pros.gamma.*g)...
        + Pros.lambda .*F_SP .* sqrtOfGradientPhi; % DeltaPhi��Ƕ�뺯���ĸ���ֵ��ͼ����������1
    % update \phi .
    phi=phi + Pros.timestep.*L_phi;
    
    
    
    %% ���д�ACM��GMM��ͨ�ţ���[1]��ʽ(25)
    % ʽ(25)����\phi_k �����_(k+1)��
    Prior(1)=mean(mean(1./(1+exp(Pros.gamma.*g - Pros.beta.*(vx.*nx+vy.*ny+g.*curvature) - phi./Pros.epsilon))));
    Prior(2)=1-Prior(1);
    
    
    
    
    
    %% ��ʱ��ͣ %%%%%%%%%%%%%%%%%
    elipsedTime = toc;
    Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime;
    
    
    
    %% visualization
    if strcmp(Pros.isNotVisiualEvolutionAtAll,'no')
        % ���ɶ�ֵͼ����
        bwData=zeros(numPixels,1);
        bwData(phi>=0)=1;
        bwData = im2bw(bwData);
        Pi_vis(:,1)=1./(1+exp(Pros.gamma-Pros.beta.*g.*curvature-phi./Pros.epsilon));
        Pi_vis(:,2)=1-Pi_vis(:,1);
        
        [Pros]=visualizeContours_ACMandGMM_new_fixedTime(Pros, image_original, image_processed, phi, L_phi, bwData, P_i_x, Px, P_x_k, Pi_vis );
    end
    
    %% write data
    if (strcmp(Pros.isNotWriteDataAtAll,'no') && mod(Pros.iteration_outer,Pros.periodOfWriteData)==0)
        % ���ɶ�ֵͼ����
        bwData=zeros(numPixels,1);
        bwData(phi>=0)=1;
        bwData = reshape(bwData, numRow, numCol);
        bwData = im2bw(bwData);
        filename_bwData = [Pros.filename_originalImage(1:end-4) '_iter' num2str(Pros.iteration_outer,'%04d') '_time' num2str(Pros.elipsedEachTime,'%.4f') '_' Pros.evolutionMethod '.bmp'];
        filepath_bwData = fullfile(Pros.folderpath_bwData, filename_bwData);
        imwrite(bwData, filepath_bwData, 'bmp');
        if exist(filepath_bwData,'file')
            disp(['�ѱ���ָ��ֵͼ���� ' filename_bwData]);
        else
            disp(['δ����ָ��ֵͼ���� ' filename_bwData]);
        end
        
        if  strcmp(Pros.isWriteData,'yes')==1
            [Pros ] = writeData_ACMandGMM_new_fixedTime(Pros, image_original, image_processed, phi, bwData, P_i_x, Px, P_x_k, P_sp_and_k, Pi_vis, Pi, mu, Sigma);
        end
    end
    
    %%
    bwData=zeros(numRow, numCol);
    oldBwData(phi(:)>=0)=1;
    bwData = im2bw(bwData);
    pixelChanged = xor(bwData, oldBwData);
    numPixelChanged = sum(pixelChanged(:));
    oldBwData = bwData;
    Pros.iteration_outer = Pros.iteration_outer+1;		% iteration add 1
    
end % end loop



%% �����׶Σ������ؼ����ݻ�

% while (Pros.elipsedEachTime<=Pros.numTime) % �Ƚ�ͬһʱ���ͣ������
% while (Pros.iteration_outer<=Pros.numIte  ration_outer) % �Ƚ�ͬһ������ͣ������
% while (Pros.iteration_outer<=Pros.numIteration_outer) % ��������������ͣ������
while (Pros.iteration_outer<=Pros.numIteration_outer &&	numPixelChanged>=Pros.numPixelChangedToContinue) % ��������������ͣ������
    
    %% initialize the definition of P_x_k
    P_x_k = zeros( numPixels, numState)+Pros.smallNumber; % P_x_k���������ʡ�ͼ������������������Ϊ�˷�ֹ�ں���ļ����г��ַ�ĸΪ0���������˽�����������Ϊ����ĺ�С��������ͬ��
    P_x_k_unlabeled= zeros( num_unlabeled, numState)+Pros.smallNumber; % P_x_k_unlabeled ��δ��ǩ�����ص��������ʡ�δ��ǩ����������������
%     P_k_x = zeros( numPixels, numState)+Pros.smallNumber; % P_x_k��������ʡ�ͼ����������������

    %% reshape
    P_x_k=reshape(P_x_k, [], 2);
    
    %% ��ʱ��ʼ %%%%%%%%%%%%
    tic;
    
    %% E������ ��_t �������δ����������б�������ĸ�˹���� p_t
    for k=1:numState
        P_x_k_unlabeled(:,k)= gaussPDF(image_data_reshaped(:,index_unlabeled), mu(:,k) , Sigma(:,:,k), Pros.smallNumber);
        P_x_k(index_unlabeled,k)=P_x_k_unlabeled(:,k);
        for kk=1:numState
            if kk==k  % ���Ҫд��Ļ�������ͱ�ǩ��ͬ�����ͼ����б��������λ�õ� P_x_k Ϊһ���� P_x_k �����е�ֵ�����ֵ����һЩ��ֵ��
                P_x_k(index_labeled{kk},k)=min(max(P_x_k(index_unlabeled,k)).*Pros.scaleOflabeledProbabilities);
            else % ���Ҫд��Ļ�������ͱ�ǩ����ͬ�����ͼ����б��������λ�õ� P_x_k Ϊһ���� P_x_k �����е�ֵ����Сֵ��СһЩ��ֵ��
                P_x_k(index_labeled{kk},k)=max(min(P_x_k(index_unlabeled,k))./Pros.scaleOflabeledProbabilities);
            end
        end
    end
    
    %% E������ p_t �� ��_t �������δ��������ĸ�˹��֧�ĺ������� z_t �����������ĸ�˹��֧�ĺ�������
    
    P_x_and_k = repmat(Prior, [numPixels 1]).*P_x_k;		% P_x_and_k��ͬʱ����x��i�ĸ��ʡ�ͼ����������������
    P_x = sum(P_x_and_k,2); % P_x����˹�����ܶȡ�ͼ����������1
    P_k_x = P_x_and_k ./ repmat(P_x,[1 numState]); % P_k_x��������ʡ�ͼ����������������
    for k=1:numState
        P_k_x(index_labeled{k},k)=1;
    end
    
    %% M������ z_t ���� ��_(t+1)��
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
    
    
    
    %% ����ÿ�������صĺ������ z_t �����䵽��Ӧ�ĸ�������
    P_k_sp=zeros(numSP,numState);
    for k=1:numState
        for i=1:numSP
            P_k_sp(i , k)=mean(P_x_k(SuperPixels_index{i} ,k));
            %   P_k_sp(i , k)=mean(P_x_k(SuperPixels_position{i} ,k));
            P_x_k(SuperPixels_index{i},k)=P_k_sp( i, k);
        end
    end
    
    
    %% �б�׼��ͳ�������
    %     S_ps_c = (P_k_sp(:,1) - P_k_sp(:,2)) ./ (P_k_sp(:,1) + P_k_sp(:,2)) ;
    S_ps_c = log(P_k_sp(:,1) ./ P_k_sp(:,2)) ;
    F_sp = zeros(1,numPixels);
    for i=1:numSP
        F_sp(SuperPixels_index{i}) = S_ps_c(i);
    end
    
    %% ��ʱ��ͣ %%%%%%%%%%%%%%%%%
    elipsedTime = toc;
    Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime;
    
    %% reshape
    F_sp=reshape(F_sp, numRow, numCol);
    P_x_k=reshape(P_x_k, numRow, numCol, 2);
    P_k_x=reshape(P_k_x, numRow, numCol, 2);
    
    %% ��ʱ��ʼ %%%%%%%%%%%%%
    tic;
    
    
    %% ���д�GMM��ACM��ͨ�ţ���ʱ֮ǰ�Ѿ���ʼ���� \phi_0������ʽ(20)����\phi_t ��p_t ��z_t ���㲢����\phi_(t+1)��
    % Neumann �߽�����
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
        + Pros.lambda .*F_sp .* sqrtOfGradientPhi; % DeltaPhi��Ƕ�뺯���ĸ���ֵ��ͼ����������1
    % update \phi .
    phi=phi + Pros.timestep.*L_phi;
    
    %% ��ʱ��ͣ %%%%%%%%%%%%%%%%%
    elipsedTime = toc;
    Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime;
    
    %% �����ּ��� pi_t+1 �ķ�ʽ֮һ
    if '2' == Pros.piType
        
        %% ��ʱ��ʼ %%%%%%%%%%%%%
        tic;
        %% ���д�ACM��GMM��ͨ�ţ���[1]��ʽ(25)
        % ʽ(25)����\phi_k �����_(t+1)��
        Prior(1)=mean(mean((1./(1+ ...
            exp(Pros.epsilon .* Pros.lambda .* F_sp .* sqrtOfGradientPhi ./ P_k_x(:,:,1) ./ P_k_x(:,:,2) - ...
            Pros.gamma.*g - Pros.beta.*(vx.*nx+vy.*ny+g.*curvature) - phi./Pros.epsilon)))));
        Prior(2)=1-Prior(1);
        
        %% ��ʱ��ͣ %%%%%%%%%%%%%%%%%
        elipsedTime = toc;
        Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime;
        
    elseif '1' == Pros.piType
        %% ��ʱ��ʼ %%%%%%%%%%%%%
        tic;
        
        %% ���д�ACM��GMM��ͨ�ţ���[1]��ʽ(23)
        % ʽ(23)����\phi_t ��p_t �����_(t+1)��
        Pi_vis(:,:,1) = 1 ./ (1 + exp(log(P_x_k(:,:,1) ./ P_x_k(:,:,2)) - phi./Pros.epsilon)); % Pi_vis������̯��ÿ�����ص��ϵ�������ʣ����ڿ��ӻ���ͼ����������������
        Pi_vis(:,:,2)=1 - Pi_vis(:,:,1);
        Prior(1) = mean(mean((Pi_vis(:,:,1)))); % Pi��������ʡ�1��������
        Prior(2) = 1-Prior(1);
        
        %% ��ʱ��ͣ %%%%%%%%%%%%%%%%%
        elipsedTime = toc;
        Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime;
        
    end
    
    
    %% visualization
    if strcmp(Pros.isNotVisiualEvolutionAtAll,'no')
        % ���ɶ�ֵͼ����
        bwData=zeros(numPixels,1);
        bwData(reshape(phi, [], 1)>=0)=1;
        bwData = im2bw(bwData);
        Pi_vis(:,1)=1./(1+exp(Pros.gamma-Pros.beta.*g.*curvature-phi./Pros.epsilon));
        Pi_vis(:,2)=1-Pi_vis(:,1);
        
        [ Pros ] = visualizeContours_ACMGMMandSemisupervised( Pros, image_original, image_processed, phi, L_phi,  bwData, P_k_x, P_x, P_x_k ,Pi_vis);
    end
    
    %% write data
    if (strcmp(Pros.isNotWriteDataAtAll,'no') && mod(Pros.iteration_outer,Pros.periodOfWriteData)==0)
        % ���ɶ�ֵͼ����
        bwData=zeros(numPixels,1);
        bwData(reshape(phi, [], 1)>=0)=1;
        bwData = reshape(bwData, numRow, numCol);
        bwData = im2bw(bwData);
        filename_bwData = [Pros.filename_originalImage(1:end-4) '_iter' num2str(Pros.iteration_outer,'%04d') '_time' num2str(Pros.elipsedEachTime,'%.4f') '_' Pros.evolutionMethod '.bmp'];
        filepath_bwData = fullfile(Pros.folderpath_bwData, filename_bwData);
        imwrite(bwData, filepath_bwData, 'bmp');
        if exist(filepath_bwData,'file')
            disp(['�ѱ���ָ��ֵͼ���� ' filename_bwData]);
        else
            disp(['δ����ָ��ֵͼ���� ' filename_bwData]);
        end
        
        if  strcmp(Pros.isWriteData,'yes')==1
            [Pros ] = writeData_ACMGMMandSPsemisupervised_1(Pros, image_original, image_processed, phi, bwData, P_k_x, P_x, P_x_k, P_x_and_k, Prior, mu, Sigma);
        end
    end
    
    %%
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


function [ SP_feature ] = computeSPFeature( SP_color, SP_center_position , numSP, Pros)
% COMPUTESPDISTANCE �˴���ʾ�йش˺�����ժҪ
% �������ŷʽ�ľ���Ĺ�ʽ

%% ����1 ŷʽ�ռ� ��ɫ������ & xy�ռ�������
switch Pros.SPFeatureMethod
    case '1'
        SuperPixelsDistance_color = zeros(numSP,numSP);
        SuperPixelsDistance_space = zeros(numSP,numSP);
        
        for i=1:1:numSP
            for j=1:1:numSP
                SuperPixelsDistance_color(i,j) = ...
                    norm(...
                    [(SuperPixels(i).histogram_channel1 - SuperPixels(j).histogram_channel1); ...
                    (SuperPixels(i).histogram_channel2 - SuperPixels(j).histogram_channel2);...
                    (SuperPixels(i).histogram_channel3 - SuperPixels(j).histogram_channel3)] ...
                    ,2);
                SuperPixelsDistance_space(i,j) = ...
                    norm(...
                    [(SuperPixels(i).centerPointPosition_1 - SuperPixels(j).centerPointPosition_1);...
                    (SuperPixels(i).centerPointPosition_2 - SuperPixels(j).centerPointPosition_2)] ...
                    ,2);
            end
        end
        SP_feature = Pros.weight_feature .* reshape(mapminmax(reshape(SuperPixelsDistance_color,1,numSP*numSP),0.01,0.99),numSP,numSP) + ...
            (1-Pros.weight_feature) .* reshape(mapminmax(reshape(SuperPixelsDistance_space,1,numSP*numSP),0.01,0.99),numSP,numSP) ;
        
        
    case '2'
        SP_feature = zeros(3, numSP);
        SP_feature_pos = zeros( numSP, 1);
        for i=1:numSP
            SP_feature_pos(i) = norm([SP_center_position(numSP,:)]);
        end
        SP_feature(1,:) = mapminmax( Pros.weight_feature .* SP_color(:,1) + (1-Pros.weight_feature) .* mapminmax(SP_feature_pos , 0.01, 0.09) ) ;
        SP_feature(2,:) = mapminmax( Pros.weight_feature .* SP_color(:,2) + (1-Pros.weight_feature) .* mapminmax(SP_feature_pos , 0.01, 0.09) );
        SP_feature(3,:) = mapminmax( Pros.weight_feature .* SP_color(:,3) + (1-Pros.weight_feature) .* mapminmax(SP_feature_pos , 0.01, 0.09) );
        
    case '3'
        % ���������㷽��Ч���ã��Ϳ���ɾ������ķ������༴���� computeSPFeature ������ֱ����ǰ��� SP_color ���� SP_feature
        SP_feature = double(uint8(SP_color.'));
        
    case '4' % useless
        SP_feature = zeros(5, numSP);
        SP_feature(1,:) = Pros.weight_feature .* SP_color(:,1) ;
        SP_feature(2,:) = Pros.weight_feature .* SP_color(:,2) ;
        SP_feature(3,:) = Pros.weight_feature .* SP_color(:,3) ;
        SP_feature(4,:) = (1 - Pros.weight_feature) .* mapminmax(SP_center_position(:,1), 0.1, 0.9) ;
        SP_feature(5,:) = (1 - Pros.weight_feature) .* mapminmax(SP_center_position(:,2), 0.1, 0.9) ;
        
    case '5'
        % TODO
        
    otherwise
        disp(error('choose the error method !'))
end



end
