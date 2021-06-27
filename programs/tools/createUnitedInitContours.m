%% ���
% createUnitedInitContours.m ����ÿһ��ͼ������ͳһ�ĳ�ʼ�������ó�ʼ�����ͻ���ACMandGMM�㷨���ɵĳ�ʼ����һ�¡�
clear all;
close all;
clc;
diary off;
sp=actxserver('SAPI.SpVoice');

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ѡ���ʼ����ʽ��
...��ѡ��
    ...'scribbled_kmeans'  %% ʹ���û����߷�ʽ���ɵ��б������ + EM-GMM �������ɵ�
    ...'scribbled_circle'   %% ʹ�� scribbled ���� GMM ��ʼ�������� circle ���ɳ�ʼ����
    ...'circle'    %% ʹ�� circle ��ʼ������
    ...'kmeans'     %% ʹ�� k-means ��ʼ����ʽ
    ...'circle_kmeans'    %% ʹ�� circle ��Ϊ��ʼ������k-means ��Ϊ��ʼ����
    ...'kmeans_ACMGMM'    %% ���[1] Guowei Gao���˵ķ�������k-means��ʼ�����Լ���ˮƽ���ݻ�
    ...'circle_ACMGMM'    %% ���[1] Guowei Gao���˵ķ���������ˮƽ���ݻ����������ɳ�ʼ����
    
Args.initMethod = 'circle_SDF_ACMGMM' ;


Args.maxIterOfKmeans = 100 ; % �� kmeans ��ʼ����ʱ���������������

Args.folderpath_reourcesDatasets ='.\data\resources\MSRA1K\original resources' ;	% ������Դ�ļ���ԭͼ����ֵͼ�����ͼ���Ļ���·��
% % ������ʼ���ļ������ֳ�ʼ���������ɵ����ʼ������ֵͼ����������ʱ������ȣ��Ļ���·���� Ҳ�Ǵ�����ɽ�����ļ��С�
Args.folderpath_initDatasets ='.\data\resources\MSRA1K\init resources';
Args.folderpath_initResources =fullfile(Args.folderpath_initDatasets, [Args.initMethod]);	
% Args.folderpath_initResources =['.\candidate\init resources\circle_staircase'];

Args.timestep=0.10;  % time step
Args.epsilon = 0.50 ; % papramater that specifies the width of the DiracDelta function. default=0.5 and more at [1].
Args.mu = 1.0;  % coefficeient of the weighted probability term prob(phi).
Args.beta=0.5; % coefficeient of the weighted length term L(phi). default=0.5.
Args.gamma=0.00;  % coefficient of the weighted area term A(phi). default=0.2.
Args.sigma=1.5;     % scale parameter in Gaussian kernel , default is 1.5 .
Args.hsize=5 ;			% ��˹�˲�����ģ���С��default is 15, also means 15 x 15.
Args.circleRadius = 100; % radius of the circle for initializing contour.
Args.numUselessFiles = 0;   % ��ʱ��洢ͼƬ���ļ��г�����ͼ���ļ������п�����ϵͳ�ļ��ᱻ���������Ҫ�ֶ��ų������ļ������������Ǵ˹�����bug��
Args.numOfComponents = 2; % ������ķ�֦��
Args.contoursInitValue = 1; % ��ʼˮƽ��������ֵ
Args.smallNumber=realmin+1E-20;  % ������ӵķ�ֹ�������������С����

% ���²��ܸ�
% Args.isNotVisiualEvolutionAtAll = 'yes' ; % �������й������Ƿ���ȫ�����ӻ��м���̺ͱ����м����ͼ ��Ĭ��'yes'
% Args.isNotWriteDataAtAll = 'yes' ; % �������й����в����Ľ�������Ƿ񱣴棬����ǣ���ô�Ͳ����������ݣ��������յĶ�ֵͼͼ���ǻᱣ��ġ�Ĭ�� 'yes'
% Args.numIteration_inner=1; % ��ѭ��������default = 1
% Args.iteration_inner=1; % ��ѭ����ʼֵ��default = 1
% Args.numIteration_outer=1; % ��ѭ��������default = 1000
% Args.iteration_outer=1; % ��ѭ����ʼֵ��default = 1

Pros=Args


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

EachImage = createEachImageStructure(Pros.folderpath_reourcesDatasets, Pros.folderpath_initResources, Pros.numUselessFiles);

input('ȷ���ļ�������ļ������Ƿ���ȷ����ȷ����������������� Ctrl+c ��ֹ����')
% indexOfScribbledImageFolder = findIndexOfFolderName(EachImage, 'scribbled images');
% indexOfOriginalImageFolder = findIndexOfFolderName(EachImage, 'original images');
% indexOfBwImageFolder = findIndexOfFolderName(EachImage, 'bw images');
% indexOfGTFolder = findIndexOfFolderName(EachImage, 'ground truth bw images');
% indexOfEvaluationsFolder = findIndexOfFolderName(EachImage, 'evaluations');

if ~exist(Pros.folderpath_initResources,'dir')
    mkdir(Pros.folderpath_initResources)
end

%% ���� diary ��¼
Pros.folderpath_diary = Pros.folderpath_initResources;
Pros.filepath_diary = fullfile(Pros.folderpath_diary , [ 'ͳһ�ĳ�ʼ��������ز���.txt']);
diary(Pros.filepath_diary);
diary on;
Args % ��ӡ Args

%%
numState = Pros.numOfComponents;
numImage = EachImage.num_originalImage;
for index_image=1:numImage
    %%
    filepath_original = EachImage.originalImage(index_image).path;
    image_original = imread(filepath_original);
    image_processed = image_original;
    Pros.sizeOfImage=[size(image_original)];
    Pros.numData = Pros.sizeOfImage(1).*Pros.sizeOfImage(2);
    [numRow, numCol, numVar] = deal(Pros.sizeOfImage(1),Pros.sizeOfImage(2),Pros.sizeOfImage(3));
    numPixels =numRow * numCol;
    image_data = double(image_original);
    data = reshape(image_data ,[],numVar); % Ҫ�����ͼ�����ݡ���������ά��
    data=data.'; % Ҫ�����ͼ�����ݡ�ά����������
    Pxi = zeros( numPixels,numState); % Pxi���������ʡ�ͼ����������������
    
    %% ���ɳ�ʼ����
    switch Pros.initMethod
        case 'scribbled_kmeans_1'
            %% scribbled_kmeans_1����һ�֣�ʹ���û����߷�ʽ���ɵ��б������ + kmeans �������� GMM ��������ʼ������
            
            % ��ʼ������ֵ����
            Args0.initializeType = 'staircase';
            
            % ��ʼ��ʱ
            Pros.elipsedEachTime=0;
            tic;
            
            
            
            load(EachImage.seedsIndex1(index_image).path);
            load(EachImage.seedsIndex2(index_image).path);
            data_foreground=zeros(3,size(seedsIndex1,1));
            data_foreground=data(:,seedsIndex1(:));
            data_background=zeros(3,size(seedsIndex2,1));
            data_background=data(:,seedsIndex2(:));
            
            [Prior0, mu0,Sigma0 ]= EM_init_kmeans([data_foreground data_background], 2, Pros.maxIterOfKmeans); % Pi��������ʡ�1������������ֵ��ά������֦����Э���ά����ά����������
            
            % create phi0
            for i=1:numState
                %Compute probability p(x|i)
                Pxi(:,i) = gaussPDF(data, mu0(:,i), Sigma0(:,:,i));
            end
            %Compute posterior probability p(i|x)
            Pix_tmp = repmat(Prior0,[numPixels 1]).*Pxi;
            Pix = Pix_tmp ./ repmat(sum(Pix_tmp,2),[1 numState]);
            phi0=Pix(:,1)-Pix(:,2);
            
            
            % ������ʱ
            elipsedTime010=toc;
            Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime010;
            
        case 'scribbled_kmeans_2'
            %% scribbled_kmeans_2���ڶ��֣�ʹ���û����߷�ʽ���ɵ��б������ + kmeans �������� GMM ��������ʼ������
            
            % ��ʼ������ֵ����
            Args0.initializeType = 'staircase';
            
            % ��ʼ��ʱ
            Pros.elipsedEachTime=0;
            tic;
            
            
            load(EachImage.seedsIndex1(index_image).path);
            load(EachImage.seedsIndex2(index_image).path);
            data_foreground=zeros(3,size(seedsIndex1,1));
            data_foreground=data(:,seedsIndex1(:));
            data_background=zeros(3,size(seedsIndex2,1));
            data_background=data(:,seedsIndex2(:));
            
            [~, mu0_foreground,Sigma0_foreground ]= EM_init_kmeans(data_foreground, 1, Pros.maxIterOfKmeans); % Pi��������ʡ�1������������ֵ��ά������֦����Э���ά����ά����������
            [~, mu0_background,Sigma0_background ] = EM_init_kmeans(data_background, 1, Pros.maxIterOfKmeans); % Pi��������ʡ�1������������ֵ��ά������֦����Э���ά����ά����������
            Prior0(1)=size(data_foreground,2)/(size(data_foreground,2)+size(data_background,2));
            Prior0(2)=size(data_background,2)/(size(data_foreground,2)+size(data_background,2));
            mu0=[mu0_foreground mu0_background];
            Sigma0(:,:,1)=Sigma0_foreground+ 1E-15.*diag(ones(numVar,1));
            Sigma0(:,:,2)=Sigma0_background+ 1E-15.*diag(ones(numVar,1));
            
            % create phi0
            for i=1:numState
                %Compute probability p(x|i)
                Pxi(:,i) = gaussPDF(data, mu0(:,i), Sigma0(:,:,i));
            end
            %Compute posterior probability p(i|x)
            Pix_tmp = repmat(Prior0,[numPixels 1]).*Pxi;
            Pix = Pix_tmp ./ repmat(sum(Pix_tmp,2),[1 numState]);
            phi0=Pix(:,1)-Pix(:,2);
            
            
            % ������ʱ
            elipsedTime010=toc;
            Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime010;
            
        case 'scribbled_circle_SDF_1'
            %% scribbled_circle_1 ����һ�֣�ʹ�� scribbled ���� GMM ��ʼ�������� circle ���ɳ�ʼ����
            
            % ��ʼ������ֵ����
            Args0.initializeType = 'SDF';
            
            load(EachImage.seedsIndex1(index_image).path);
            load(EachImage.seedsIndex2(index_image).path);
            data_foreground=zeros(3,size(seedsIndex1,1));
            data_foreground=data(:,seedsIndex1(:));
            data_background=zeros(3,size(seedsIndex2,1));
            data_background=data(:,seedsIndex2(:));
            
            % ��ʼ��ʱ
            Pros.elipsedEachTime=0;
            tic;
            
            [Prior0, mu0,Sigma0 ]= EM_init_kmeans([data_foreground data_background], 2, Pros.maxIterOfKmeans); % Pi��������ʡ�1������������ֵ��ά������֦����Э���ά����ά����������
            
            % create phi0
            Pros.circleCenterX=Pros.sizeOfImage(1)/2;
            Pros.circleCenterY=Pros.sizeOfImage(2)/2;
            phi0 = sdf2circle(Pros.sizeOfImage(1),Pros.sizeOfImage(2), Pros.circleCenterX, Pros.circleCenterY, Pros.circleRadius);
            
            
            % ������ʱ
            elipsedTime010=toc;
            Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime010;
            
        case 'scribbled_circle_SDF_2'
            %% scribbled_circle_2 ���ڶ��֣�ʹ�� scribbled ���� GMM ��ʼ�������� circle ���ɳ�ʼ����
            
            % ��ʼ������ֵ����
            Args0.initializeType = 'SDF';
            
            load(EachImage.seedsIndex1(index_image).path);
            load(EachImage.seedsIndex2(index_image).path);
            data_foreground=zeros(3,size(seedsIndex1,1));
            data_foreground=data(:,seedsIndex1(:));
            data_background=zeros(3,size(seedsIndex2,1));
            data_background=data(:,seedsIndex2(:));
            
            % ��ʼ��ʱ
            Pros.elipsedEachTime=0;
            tic;
            
            [~, mu0_foreground,Sigma0_foreground ]= EM_init_kmeans(data_foreground, 1, Pros.maxIterOfKmeans); % Pi��������ʡ�1������������ֵ��ά������֦����Э���ά����ά����������
            [~, mu0_background,Sigma0_background ] = EM_init_kmeans(data_background, 1, Pros.maxIterOfKmeans); % Pi��������ʡ�1������������ֵ��ά������֦����Э���ά����ά����������
            Prior0(1)=size(data_foreground,2)/(size(data_foreground,2)+size(data_background,2));
            Prior0(2)=size(data_background,2)/(size(data_foreground,2)+size(data_background,2));
            mu0=[mu0_foreground mu0_background];
            Sigma0(:,:,1)=Sigma0_foreground+ 1E-15.*diag(ones(numVar,1));
            Sigma0(:,:,2)=Sigma0_background+ 1E-15.*diag(ones(numVar,1));
            
            % create phi0
            Pros.circleCenterX=Pros.sizeOfImage(1)/2;
            Pros.circleCenterY=Pros.sizeOfImage(2)/2;
            phi0 = sdf2circle(Pros.sizeOfImage(1),Pros.sizeOfImage(2), Pros.circleCenterX, Pros.circleCenterY, Pros.circleRadius);
            
            
            % ������ʱ
            elipsedTime010=toc;
            Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime010;
            
            
        case 'scribbled_circle_staircase_1'
            %% scribbled_circle_staircase_1����һ�֣�ʹ�� scribbled ���� GMM ��ʼ�������� circle ���ɳ�ʼ��������ʼ������״�ý�����
            
            
            % ��ʼ������ֵ����
            Args0.initializeType = 'staircase';
            
            load(EachImage.seedsIndex1(index_image).path);
            load(EachImage.seedsIndex2(index_image).path);
            data_foreground=zeros(3,size(seedsIndex1,1));
            data_foreground=data(:,seedsIndex1(:));
            data_background=zeros(3,size(seedsIndex2,1));
            data_background=data(:,seedsIndex2(:));
            
            % ��ʼ��ʱ
            Pros.elipsedEachTime=0;
            tic;
            
            [Prior0, mu0,Sigma0 ]= EM_init_kmeans([data_foreground data_background], 2, Pros.maxIterOfKmeans); % Pi��������ʡ�1������������ֵ��ά������֦����Э���ά����ά����������
            
            % create phi0
            Pros.circleCenterX=Pros.sizeOfImage(1)/2;
            Pros.circleCenterY=Pros.sizeOfImage(2)/2;
            phi0 = sdf2circle(Pros.sizeOfImage(1),Pros.sizeOfImage(2), Pros.circleCenterX, Pros.circleCenterY, Pros.circleRadius);
            phi0(phi0>=0)=+Pros.contoursInitValue;
            phi0(phi0<0)=-Pros.contoursInitValue;
            
            % ������ʱ
            elipsedTime010=toc;
            Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime010;
            
        case 'scribbled_circle_staircase_2'
            %% scribbled_circle_staircase_2���ڶ��֣�ʹ�� scribbled ���� GMM ��ʼ�������� circle ���ɳ�ʼ��������ʼ������״�ý�����
            
            
            % ��ʼ������ֵ����
            Args0.initializeType = 'staircase';
            
            load(EachImage.seedsIndex1(index_image).path);
            load(EachImage.seedsIndex2(index_image).path);
            data_foreground=zeros(3,size(seedsIndex1,1));
            data_foreground=data(:,seedsIndex1(:));
            data_background=zeros(3,size(seedsIndex2,1));
            data_background=data(:,seedsIndex2(:));
            
            % ��ʼ��ʱ
            Pros.elipsedEachTime=0;
            tic;
            
            [~, mu0_foreground,Sigma0_foreground ]= EM_init_kmeans(data_foreground, 1, Pros.maxIterOfKmeans); % Pi��������ʡ�1������������ֵ��ά������֦����Э���ά����ά����������
            [~, mu0_background,Sigma0_background ] = EM_init_kmeans(data_background, 1, Pros.maxIterOfKmeans); % Pi��������ʡ�1������������ֵ��ά������֦����Э���ά����ά����������
            Prior0(1)=size(data_foreground,2)/(size(data_foreground,2)+size(data_background,2));
            Prior0(2)=size(data_background,2)/(size(data_foreground,2)+size(data_background,2));
            mu0=[mu0_foreground mu0_background];
            Sigma0(:,:,1)=Sigma0_foreground+ 1E-15.*diag(ones(numVar,1));
            Sigma0(:,:,2)=Sigma0_background+ 1E-15.*diag(ones(numVar,1));
            
            % create phi0
            Pros.circleCenterX=Pros.sizeOfImage(1)/2;
            Pros.circleCenterY=Pros.sizeOfImage(2)/2;
            phi0 = sdf2circle(Pros.sizeOfImage(1),Pros.sizeOfImage(2), Pros.circleCenterX, Pros.circleCenterY, Pros.circleRadius);
            phi0(phi0>=0)=+Pros.contoursInitValue;
            phi0(phi0<0)=-Pros.contoursInitValue;
            
            % ������ʱ
            elipsedTime010=toc;
            Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime010;
            
        case 'circle_SDF'
            %% circle_SDF���� circle ���ɳ�ʼ�����ͳ�ʼ������ĸ���������ʼ������״��SDF
            
            
            % ��ʼ������ֵ����
            Args0.initializeType = 'SDF';
            
            
            % ��ʼ��ʱ
            Pros.elipsedEachTime = 0;
            tic;
            
            % create phi0
            Pros.circleCenterX=Pros.sizeOfImage(1)/2;
            Pros.circleCenterY=Pros.sizeOfImage(2)/2;
            phi0 = sdf2circle(Pros.sizeOfImage(1),Pros.sizeOfImage(2), Pros.circleCenterX, Pros.circleCenterY, Pros.circleRadius);
            
            % ����ǰ���ͱ��������ݵ������
            idx_data_foreground=find(phi0>=0);
            idx_data_background = find(phi0<0);
            
            % ���� Prior, mu, Sigma
            Prior0(1) = length(idx_data_foreground)/numPixels;
            Prior0(2) = length(idx_data_background)/numPixels;
            mu0(:,1) = mean(data(:,idx_data_foreground),2);
            mu0(:,2) = mean(data(:,idx_data_background),2);
            Sigma0(:,:,1) = cov([data(:,idx_data_foreground) data(:,idx_data_foreground)]');
            Sigma0(:,:,1) = Sigma0(:,:,1) + 1E-15.*diag(ones(numVar,1));
            Sigma0(:,:,2) = cov([data(:,idx_data_background) data(:,idx_data_background)]');
            Sigma0(:,:,2) = Sigma0(:,:,2) + 1E-15.*diag(ones(numVar,1));
            
            
            
            % ������ʱ
            elipsedTime010 = toc;
            Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime010;
            
        case 'circle_staircase'
            %% circle_staircase���� circle ���ɳ�ʼ�����ͳ�ʼ������ĸ���������ʼ������״�ý�����
            
            
            % ��ʼ������ֵ����
            Args0.initializeType = 'staircase';
            
            
            % ��ʼ��ʱ
            Pros.elipsedEachTime = 0;
            tic;
            
            % create phi0
            Pros.circleCenterX=Pros.sizeOfImage(1)/2;
            Pros.circleCenterY=Pros.sizeOfImage(2)/2;
            phi0 = sdf2circle(Pros.sizeOfImage(1),Pros.sizeOfImage(2), Pros.circleCenterX, Pros.circleCenterY, Pros.circleRadius);
            phi0(phi0>=0)=+Pros.contoursInitValue;
            phi0(phi0<0)=-Pros.contoursInitValue;
            
            % ����ǰ���ͱ��������ݵ������
            idx_data_foreground=find(phi0>=0);
            idx_data_background = find(phi0<0);
            
            % ���� Prior, mu, Sigma
            Prior0(1) = length(idx_data_foreground)/numPixels;
            Prior0(2) = length(idx_data_background)/numPixels;
            mu0(:,1) = mean(data(:,idx_data_foreground),2);
            mu0(:,2) = mean(data(:,idx_data_background),2);
            Sigma0(:,:,1) = cov([data(:,idx_data_foreground) data(:,idx_data_foreground)]');
            Sigma0(:,:,1) = Sigma0(:,:,1) + 1E-15.*diag(ones(numVar,1));
            Sigma0(:,:,2) = cov([data(:,idx_data_background) data(:,idx_data_background)]');
            Sigma0(:,:,2) = Sigma0(:,:,2) + 1E-15.*diag(ones(numVar,1));
            
            
            
            % ������ʱ
            elipsedTime010 = toc;
            Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime010;
            
            
        case 'kmeans'
            %% kmeans��ʹ�� k-means ��ʼ����ʽ���ɳ�ʼ�����ͳ�ʼ������ĸ�����
            
            % ��ʼ������ֵ����
            Args0.initializeType = 'staircase';
            
            
            % ��ʼ��ʱ
            Pros.elipsedEachTime = 0;
            tic;
            
            [Prior0, mu0,Sigma0 ]= EM_init_kmeans(data, numState, Pros.maxIterOfKmeans); % Pi��������ʡ�1������������ֵ��ά������֦����Э���ά����ά����������
            %Compute probability p(x|i)
            for i=1:numState
                Pxi(:,i) = gaussPDF(data, mu0(:,i), Sigma0(:,:,i));
            end
            
            %Compute posterior probability p(i|x)
            Pix_tmp = repmat(Prior0,[numPixels 1]).*Pxi;
            Pix = Pix_tmp ./ repmat(sum(Pix_tmp,2),[1 numState]);
            
            % create phi0
            phi0=Pix(:,1)-Pix(:,2);
            
            % ������ʱ
            elipsedTime010 = toc;
            Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime010;
            
        case 'circle_SDF_kmeans'
            %% circle_SDF_kmeans��ʹ�� circle ��Ϊ��ʼ��������ʼ������״�ý����ͣ�k-means �������ɳ�ʼ������ĸ�����
            
            
            % ��ʼ������ֵ����
            Args0.initializeType = 'SDF';
            
            % ��ʼ��ʱ
            Pros.elipsedEachTime = 0;
            tic;
            
            [Prior0, mu0,Sigma0 ]= EM_init_kmeans(data, numState, Pros.maxIterOfKmeans); % Pi��������ʡ�1������������ֵ��ά������֦����Э���ά����ά����������
            
            % create phi0
            Pros.circleCenterX=Pros.sizeOfImage(1)/2;
            Pros.circleCenterY=Pros.sizeOfImage(2)/2;
            phi0 = sdf2circle(Pros.sizeOfImage(1),Pros.sizeOfImage(2), Pros.circleCenterX, Pros.circleCenterY, Pros.circleRadius);
            
            
            % ������ʱ
            elipsedTime010 = toc;
            Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime010;
            
        case 'circle_staircase_kmeans'
            %% circle_staircase_kmeans��ʹ�� circle ��Ϊ��ʼ��������ʼ������״�ý����ͣ�k-means �������ɳ�ʼ������ĸ�����
            
            
            % ��ʼ������ֵ����
            Args0.initializeType = 'staircase';
            
            % ��ʼ��ʱ
            Pros.elipsedEachTime = 0;
            tic;
            
            [Prior0, mu0,Sigma0 ]= EM_init_kmeans(data, numState, Pros.maxIterOfKmeans); % Pi��������ʡ�1������������ֵ��ά������֦����Э���ά����ά����������
            
            % create phi0
            Pros.circleCenterX=Pros.sizeOfImage(1)/2;
            Pros.circleCenterY=Pros.sizeOfImage(2)/2;
            phi0 = sdf2circle(Pros.sizeOfImage(1),Pros.sizeOfImage(2), Pros.circleCenterX, Pros.circleCenterY, Pros.circleRadius);
            phi0(phi0>=0)=+Pros.contoursInitValue;
            phi0(phi0<0)=-Pros.contoursInitValue;
            
            
            % ������ʱ
            elipsedTime010 = toc;
            Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime010;
            
        case 'kmeans_ACMGMM'
            %% kmeans_ACMGMM�����[1] Guowei Gao���˵ķ�������k-means��ʼ�����Լ���ˮƽ���ݻ�
            %% TODO Ҫ��
            
            % ��ʼ������ֵ����
            Args0.initializeType = 'staircase';
            
            
            %% ��ʼ��ʱ
            Pros.elipsedEachTime = 0;
            tic;
            
            
            %% k-means��ʼ��
            [Prior0, mu0,Sigma0 ]= EM_init_kmeans(data, numState, Pros.maxIterOfKmeans); % Pi��������ʡ�1������������ֵ��ά������֦����Э���ά����ά����������
            
            %% E�����æ�_k �����˹����p_k
            for i=1:numState
                Pxi(:,i)= gaussPDF(data, mu0(:,i) , Sigma0(:,:,i));
            end
            %% E������p_k �ͦ�_k �����˹��֧�ĺ�������z_k
            P_x_and_i = repmat(Prior0, [numPixels 1]).*Pxi;		% P_x_and_i��ͬʱ����x��i�ĸ��ʡ�ͼ����������������
            Px = sum(P_x_and_i,2); % Px����˹�����ܶȡ�ͼ����������1
            Pix = P_x_and_i ./ repmat(Px,[1 numState]); % Pix��������ʡ�ͼ����������������
            %% M������z_k ���㦨_(k+1)��
            sumPix = sum(Pix);
            for i=1:numState
                % Update the centers
                mu0(:,i) = data*Pix(:,i) / sumPix(i);
                % Update the covariance matrices
                temp_mu = data - repmat(mu0(:,i),1,numPixels);
                Sigma0(:,:,i) = (repmat(Pix(:,i)',numVar, 1) .* temp_mu*temp_mu') / sumPix(i);
                % Add a tiny variance to avoid numerical instability
                Sigma0(:,:,i) = Sigma0(:,:,i) + 1E-15.*diag(ones(numVar,1));
            end
            %% ���д�GMM��ACM��ͨ�ţ���ʼ������ʽ(16)����z_k ��ʼ������Ƕ�뺯��\phi_k
            phi0 = Pros.epsilon.*log(Pix(:,1)./Pix(:,2));
            
            
            
            % ������ʱ
            elipsedTime010 = toc;
            Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime010;
            
            
        case 'circle_SDF_ACMGMM'
            %% circle_ACMGMM�����[1] Guowei Gao���˵ķ���������ˮƽ���ݻ����������ɳ�ʼ����
            %% TODO Ҫ��
            % ��ʼ������ֵ����
            Args0.initializeType = 'SDF';
            
            
            % 			%% generate edge indicator functionat gray image.
            % 			image_gray=rgb2gray(image_data);
            % 			G=fspecial('gaussian',Pros.hsize ,Pros.sigma);
            % 			image010_smooth(:,:,1)=conv2(image_gray(:,:),G,'same');  % smooth image by Gaussiin convolution
            % 			[Ix,Iy]=gradient(image010_smooth(:,:,1));
            % 			f=Ix.^2+Iy.^2;
            % 			g=1./(1+f);  % edge indicator function.
            % 			g=reshape(g,[],1);
            % 			data = reshape(image_data ,[],numVar);
            % 			data=data.'; % Ҫ�����ͼ�����ݡ�ά����������
            
            % ��ʼԲȦ�������ɵ�ˮƽ��Ƕ�뺯��
            circleCenterX=Pros.sizeOfImage(1)/2;
            circleCenterY=Pros.sizeOfImage(2)/2;
            phi0 = sdf2circle(Pros.sizeOfImage(1),Pros.sizeOfImage(2), circleCenterX, circleCenterY, Pros.circleRadius);
            phi0 = reshape(phi0, 1,numPixels);
            
            % ����ǰ���ͱ��������ݵ������
            idx_data_foreground=find(phi0>=0);
            idx_data_background = find(phi0<0);
            % ���� Prior, mu, Sigma
            Prior0(1) = length(idx_data_foreground)/numPixels;
            Prior0(2) = length(idx_data_background)/numPixels;
            mu0(:,1) = mean(data(:,idx_data_foreground),2);
            mu0(:,2) = mean(data(:,idx_data_background),2);
            Sigma0(:,:,1) = cov([data(:,idx_data_foreground) data(:,idx_data_foreground)]');
            Sigma0(:,:,1) = Sigma0(:,:,1) + Pros.smallNumber.*diag(ones(numVar,1));
            Sigma0(:,:,2) = cov([data(:,idx_data_background) data(:,idx_data_background)]');
            Sigma0(:,:,2) = Sigma0(:,:,2) + Pros.smallNumber.*diag(ones(numVar,1));
            
            % ��ʼ��ʱ
            Pros.elipsedEachTime = 0;
            tic;
            
            %% E�����æ�_k �����˹����p_k
            for i=1:numState
                Pxi(:,i)= gaussPDF(data, mu0(:,i) , Sigma0(:,:,i), Pros.smallNumber);
            end
            %% E������p_k �ͦ�_k �����˹��֧�ĺ�������z_k
            P_x_and_i = repmat(Prior0, [numPixels 1]).*Pxi;		% P_x_and_i��ͬʱ����x��i�ĸ��ʡ�ͼ����������������
            Px = sum(P_x_and_i,2); % Px����˹�����ܶȡ�ͼ����������1
            Pix = P_x_and_i ./ repmat(Px,[1 numState]); % Pix��������ʡ�ͼ����������������
            %% M������z_k ���㦨_(k+1)��
            sumPix = sum(Pix);
            for i=1:numState
                % Update the centers
                mu0(:,i) = data*Pix(:,i) / sumPix(i);
                % Update the covariance matrices
                temp_mu = data - repmat(mu0(:,i),1,numPixels);
                Sigma0(:,:,i) = (repmat(Pix(:,i)',numVar, 1) .* temp_mu*temp_mu') / sumPix(i);
                % Add a tiny variance to avoid numerical instability
                Sigma0(:,:,i) = Sigma0(:,:,i) + Pros.smallNumber.*diag(ones(numVar,1));
            end
            %% ���д�GMM��ACM��ͨ�ţ���ʼ������ʽ(16)����z_k ��ʼ������Ƕ�뺯��\phi_k
            phi0 = Pros.epsilon.*log(Pix(:,1)./Pix(:,2));
            % ����ǰ���ͱ��������ݵ������
            idx_data_foreground=find(phi0>=0);
            idx_data_background = find(phi0<0);
            % ���� Prior, mu, Sigma
            Prior0(1) = length(idx_data_foreground)/numPixels;
            Prior0(2) = length(idx_data_background)/numPixels;
            mu0(:,1) = mean(data(:,idx_data_foreground),2);
            mu0(:,2) = mean(data(:,idx_data_background),2);
            Sigma0(:,:,1) = cov([data(:,idx_data_foreground) data(:,idx_data_foreground)]');
            Sigma0(:,:,1) = Sigma0(:,:,1) + Pros.smallNumber.*diag(ones(numVar,1));
            Sigma0(:,:,2) = cov([data(:,idx_data_background) data(:,idx_data_background)]');
            Sigma0(:,:,2) = Sigma0(:,:,2) + Pros.smallNumber.*diag(ones(numVar,1));
            
            
            % ������ʱ
            elipsedTime010 = toc;
            Pros.elipsedEachTime = Pros.elipsedEachTime + elipsedTime010;
            
            
        otherwise
            error('error at choose evolution method !');
    end  % end this evolution method
    
    %% ������ز���
    folderpath_contourImage = fullfile(Pros.folderpath_initResources, 'contour images');
    if ~exist(folderpath_contourImage,'dir')
        mkdir(folderpath_contourImage);
    end
    
    % ����������ֵͼ
    filename_contourImage = [EachImage.originalImage(index_image).name(1:end-4) '_contour.bmp']; % ԭʼͼ������;
    filepath_contourImage = fullfile(folderpath_contourImage, filename_contourImage);
    phiData = reshape(phi0,  Pros.sizeOfImage(1), Pros.sizeOfImage(2));
    bwData=zeros(Pros.sizeOfImage(1),Pros.sizeOfImage(2));
    bwData(phiData>=0)=1;
    bwData = im2bw(bwData);
    imwrite(bwData, filepath_contourImage,'bmp');
    
    % ����phi0
    phi0=phiData;
    folderpath_phi = fullfile(Pros.folderpath_initResources, 'phi');
    if ~exist(folderpath_phi,'dir')
        mkdir(folderpath_phi);
    end
    filename_phi = [EachImage.originalImage(index_image).name(1:end-4) '_phi.mat'];
    filepath_phi = fullfile(folderpath_phi, filename_phi);
    save(filepath_phi, 'phi0');
    
    % ����elipsedEachTime
    time0=Pros.elipsedEachTime;
    folderpath_time = fullfile(Pros.folderpath_initResources, 'time');
    if ~exist(folderpath_time,'dir')
        mkdir(folderpath_time);
    end
    filename_time = [EachImage.originalImage(index_image).name(1:end-4) '_time.mat'];
    filepath_time = fullfile(folderpath_time, filename_time);
    save(filepath_time, 'time0');
    
    % ��������Prior
    folderpath_prior = fullfile(Pros.folderpath_initResources, 'prior');
    if ~exist(folderpath_prior,'dir')
        mkdir(folderpath_prior);
    end
    filename_prior = [EachImage.originalImage(index_image).name(1:end-4) '_prior.mat'];
    filepath_prior = fullfile(folderpath_prior, filename_prior);
    save(filepath_prior, 'Prior0');
    
    % �����ֵmu
    folderpath_mu = fullfile(Pros.folderpath_initResources, 'mu');
    if ~exist(folderpath_mu,'dir')
        mkdir(folderpath_mu);
    end
    filename_mu = [EachImage.originalImage(index_image).name(1:end-4) '_mu.mat'];
    filepath_mu = fullfile(folderpath_mu, filename_mu);
    save(filepath_mu,'mu0');
    
    % ����Э����Sigma
    folderpath_Sigma = fullfile(Pros.folderpath_initResources, 'Sigma');
    if ~exist(folderpath_Sigma,'dir')
        mkdir(folderpath_Sigma);
    end
    filename_Sigma = [EachImage.originalImage(index_image).name(1:end-4) '_Sigma.mat'];
    filepath_Sigma = fullfile(folderpath_Sigma, filename_Sigma);
    save(filepath_Sigma, 'Sigma0');
    
    
end

% ����Args
folderpath_Args = fullfile(Pros.folderpath_initResources, 'Args');
if ~exist(folderpath_Args,'dir')
    mkdir(folderpath_Args);
end
filename_Args = 'Args.mat';
filepath_Args = fullfile(folderpath_Args, filename_Args);
save(filepath_Args, 'Args0');


%%
text=['����������ϡ�'];
disp(text)
sp.Speak(text)
%% ֹͣ��¼����������������ݲ�����
diary off;




