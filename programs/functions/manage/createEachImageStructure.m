function [ EachImage ] = createEachImageStructure(resourcesBaseFolder, folderpath_initMethodBase, numUselessFiles)
%createEachImageStructure �����ṹ��EachImage��
%   input:
% numUselessFiles��Ҫ��ȥ�����õ��ļ��������Windowsϵͳ��ͼ���ļ�������ļ���Thumbs.db��
% output:
% EachImage������һ���ṹ��


%% �����ļ��е���Դ resources �ṹ�� EachImage
EachImage.folderpath_originalReources =[ resourcesBaseFolder ];	  % ������Դ�ļ���ԭͼ����ֵͼ�����ͼ���Ļ���·��
EachImage.folderpath_initMethods =[ folderpath_initMethodBase ];	% ������ʼ���ļ������ֳ�ʼ���������ɵ����ʼ������ֵͼ����������ʱ������ȣ��Ļ���·��
% if ~exist(EachImage.folderpath_datasets,'dir')


%% �����ļ��е�ԭʼ��Դ original resources ����

%% �ļ��� original images ����Ϣ
EachImage.folderpath_originalImage = fullfile(EachImage.folderpath_originalReources, 'original images');
if ~exist(EachImage.folderpath_originalImage,'dir')
    mkdir(EachImage.folderpath_originalImage);
end
% ��ȡÿһ�����ļ��е�ԭʼͼ����Ϣ
EachImage.originalImage = dir([EachImage.folderpath_originalImage '\*.jpg']);
EachImage.num_originalImage= numel(EachImage.originalImage)-numUselessFiles;
disp(['�ļ��� original images �� ' num2str(EachImage.num_originalImage) ' ���ļ�'])
if EachImage.num_originalImage ~=0
    for i = 1:EachImage.num_originalImage
        EachImage.originalImage(i).path = fullfile(EachImage.folderpath_originalImage, EachImage.originalImage(i).name);
    end
else
    disp(['�ļ��� ' EachImage.folderpath_originalImage ' û��ԭʼͼ���ļ�...']);
end

%% �ļ��� ground truth bw images ����Ϣ
EachImage.folderpath_groundTruthBwImage = fullfile(EachImage.folderpath_originalReources, 'ground truth bw images');
if ~exist(EachImage.folderpath_groundTruthBwImage,'dir')
    mkdir(EachImage.folderpath_groundTruthBwImage);
end
% ��ȡÿһ�����ļ��еĴ𰸶�ֵͼ��ͼ��Ϣ
EachImage.groundTruthBwImage = dir([EachImage.folderpath_groundTruthBwImage '\*.bmp']);
EachImage.num_groundTruthBwImage= numel(EachImage.groundTruthBwImage)-numUselessFiles;
disp(['�ļ��� ground truth bw images �� ' num2str(EachImage.num_groundTruthBwImage) ' ���ļ�'])
if EachImage.num_groundTruthBwImage ~=0
    for i = 1:EachImage.num_groundTruthBwImage
        EachImage.groundTruthBwImage(i).path = fullfile(EachImage.folderpath_groundTruthBwImage, EachImage.groundTruthBwImage(i).name);
    end
else
    disp(['�ļ��� ' EachImage.folderpath_groundTruthBwImage ' û�д𰸶�ֵͼ��ͼ�ļ�...']);
end

%% �ļ��� scribbled images ����Ϣ
EachImage.folderpath_scribbledImage = fullfile(EachImage.folderpath_originalReources, 'scribbled images');
if ~exist(EachImage.folderpath_scribbledImage,'dir')
    mkdir(EachImage.folderpath_scribbledImage);
end
% ��ȡÿһ�����ļ��еĴ���ǵ�ԭʼͼ���ļ���Ϣ
EachImage.scribbledImage = dir([EachImage.folderpath_scribbledImage '\*.bmp']);
EachImage.num_scribbledImage= numel(EachImage.scribbledImage)-numUselessFiles;
disp(['�ļ��� scribbled images �� ' num2str(EachImage.num_scribbledImage) ' ���ļ�'])
if EachImage.num_scribbledImage ~=0
    for i = 1:EachImage.num_scribbledImage
        EachImage.scribbledImage(i).path = fullfile(EachImage.folderpath_scribbledImage, EachImage.scribbledImage(i).name);
    end
else
    disp(['�ļ��� ' EachImage.folderpath_scribbledImage ' û�д���ǵ�ԭʼͼ���ļ�...']);
end

%% seedsIndex1 �ļ���·��
EachImage.folderpath_seedsIndex1 = fullfile(EachImage.folderpath_originalReources, 'seedsIndex1');
if ~exist(EachImage.folderpath_seedsIndex1,'dir')
    mkdir(EachImage.folderpath_seedsIndex1);
end
% ÿ��seedsIndex1���ƺ�·��
EachImage.seedsIndex1= dir([EachImage.folderpath_seedsIndex1 '\*.mat']);
EachImage.num_seedsIndex1 = numel(EachImage.seedsIndex1)-numUselessFiles;
if EachImage.num_seedsIndex1 ~=0
    for i= 1:EachImage.num_seedsIndex1
        EachImage.seedsIndex1(i).path = fullfile(EachImage.folderpath_seedsIndex1, EachImage.seedsIndex1(i).name);
    end
else
    disp(['�ļ��� ' EachImage.folderpath_seedsIndex1 ' û�� seeds index 1 �ļ�...']);
end

%% seedsIndex2 �ļ���·��
EachImage.folderpath_seedsIndex2 = fullfile(EachImage.folderpath_originalReources, 'seedsIndex2');
if ~exist(EachImage.folderpath_seedsIndex2,'dir')
    mkdir(EachImage.folderpath_seedsIndex2);
end
% ÿ��seedsIndex2���ƺ�·��
EachImage.seedsIndex2= dir([EachImage.folderpath_seedsIndex2 '\*.mat']);
EachImage.num_seedsIndex2 = numel(EachImage.seedsIndex2)-numUselessFiles;
if EachImage.num_seedsIndex2 ~=0
    for i= 1:EachImage.num_seedsIndex2
        EachImage.seedsIndex2(i).path = fullfile(EachImage.folderpath_seedsIndex2, EachImage.seedsIndex2(i).name);
    end
else
    disp(['�ļ��� ' EachImage.folderpath_seedsIndex2 ' û�� seeds index 2 �ļ�...']);
end

%% seeds1 �ļ���·��
EachImage.folderpath_seeds1 = fullfile(EachImage.folderpath_originalReources, 'seeds1');
if ~exist(EachImage.folderpath_seeds1,'dir')
    mkdir(EachImage.folderpath_seeds1);
end
% ÿ��seeds1���ƺ�·��
EachImage.seeds1= dir([EachImage.folderpath_seeds1 '\*.mat']);
EachImage.num_seeds1 = numel(EachImage.seeds1)-numUselessFiles;
if EachImage.num_seeds1 ~=0
    for i= 1:EachImage.num_seeds1
        EachImage.seeds1(i).path = fullfile(EachImage.folderpath_seeds1, EachImage.seeds1(i).name);
    end
else
    disp(['�ļ��� ' EachImage.folderpath_seeds1 ' û�� seeds 1 �ļ�...']);
end

%% seeds2 �ļ���·��
EachImage.folderpath_seeds2 = fullfile(EachImage.folderpath_originalReources, 'seeds2');
if ~exist(EachImage.folderpath_seeds2,'dir')
    mkdir(EachImage.folderpath_seeds2);
end
% ÿ��seeds2���ƺ�·��
EachImage.seeds2= dir([EachImage.folderpath_seeds2 '\*.mat']);
EachImage.num_seeds2 = numel(EachImage.seeds2)-numUselessFiles;
if EachImage.num_seeds2 ~=0
    for i= 1:EachImage.num_seeds2
        EachImage.seeds2(i).path = fullfile(EachImage.folderpath_seeds2, EachImage.seeds2(i).name);
    end
else
    disp(['�ļ��� ' EachImage.folderpath_seeds2 ' û�� seeds 2 �ļ�...']);
end

%% seedsImg1 �ļ���·��
EachImage.folderpath_seedsImg1 = fullfile(EachImage.folderpath_originalReources, 'seedsImg1');
if ~exist(EachImage.folderpath_seedsImg1,'dir')
    mkdir(EachImage.folderpath_seedsImg1);
end
% ÿ��seedsImg1���ƺ�·��
EachImage.seedsImg1= dir([EachImage.folderpath_seedsImg1 '\*.bmp']);
EachImage.num_seedsImg1 = numel(EachImage.seedsImg1)-numUselessFiles;
if EachImage.num_seedsImg1 ~=0
    for i= 1:EachImage.num_seedsImg1
        EachImage.seedsImg1(i).path = fullfile(EachImage.folderpath_seedsImg1, EachImage.seedsImg1(i).name);
    end
else
    disp(['�ļ��� ' EachImage.folderpath_seedsImg1 ' û�� seeds image 1 �ļ�...']);
end

%% seedsImg2 �ļ���·��
EachImage.folderpath_seedsImg2 = fullfile(EachImage.folderpath_originalReources, 'seedsImg2');
if ~exist(EachImage.folderpath_seedsImg2,'dir')
    mkdir(EachImage.folderpath_seedsImg2);
end
% ÿ��seedsImg2���ƺ�·��
EachImage.seedsImg2= dir([EachImage.folderpath_seedsImg2 '\*.bmp']);
EachImage.num_seedsImg2 = numel(EachImage.seedsImg2)-numUselessFiles;
if EachImage.num_seedsImg2 ~=0
    for i= 1:EachImage.num_seedsImg2
        EachImage.seedsImg2(i).path = fullfile(EachImage.folderpath_seedsImg2, EachImage.seedsImg2(i).name);
    end
else
    disp(['�ļ��� ' EachImage.folderpath_seedsImg2 ' û�� seeds image 2 �ļ�...']);
end


%% �����ļ��еĸ�����ʼ�������ĳ�ʼ��Դ init resources ����

EachImage.folderpath_initMethodBase = [ folderpath_initMethodBase ];
EachImage.initMethods=dir(EachImage.folderpath_initMethodBase); % ÿ�ֳ�ʼ���������ļ����б�
EachImage.initMethods(1:2,:)=[];
EachImage.num_initMethods=numel(EachImage.initMethods);

if EachImage.num_initMethods~=0
    for index_initMethod = 1:EachImage.num_initMethods
        %% ָ������ʼ���������ļ���
        EachImage.initMethods(index_initMethod).folderpath = fullfile(EachImage.folderpath_initMethodBase, EachImage.initMethods(index_initMethod).name) ;
        
        %% �ļ��� contour images ����Ϣ
        EachImage.initMethods(index_initMethod).folderpath_contourImage = fullfile(EachImage.initMethods(index_initMethod).folderpath, 'contour images');
        if ~exist(EachImage.initMethods(index_initMethod).folderpath_contourImage,'dir')
            mkdir(EachImage.initMethods(index_initMethod).folderpath_contourImage);
        end
        % ��ȡÿһ�����ļ��еĳ�ʼ����������ֵͼ��Ϣ
        EachImage.initMethods(index_initMethod).contourImage = dir([EachImage.initMethods(index_initMethod).folderpath_contourImage '\*.bmp']);
        EachImage.initMethods(index_initMethod).num_contourImage= numel(EachImage.initMethods(index_initMethod).contourImage)-numUselessFiles;
        disp(['��ʼ�������ļ��� ' EachImage.initMethods(index_initMethod).name ' �� ' num2str(EachImage.initMethods(index_initMethod).num_contourImage) ' ����ʼ����������ֵͼ�ļ�'])
        if EachImage.initMethods(index_initMethod).num_contourImage ~=0
            for index_contourImage = 1:EachImage.initMethods(index_initMethod).num_contourImage
                EachImage.initMethods(index_initMethod).contourImage(index_contourImage).path = fullfile(EachImage.initMethods(index_initMethod).folderpath_contourImage, EachImage.initMethods(index_initMethod).contourImage(index_contourImage).name);
            end
        else
            disp(['�ļ��� ' EachImage.initMethods(index_initMethod).folderpath_contourImage ' û�г�ʼ������ֵͼ��ͼ�ļ�...']);
        end
        
        %% �ļ��г�ʼ phi ����Ϣ
        EachImage.initMethods(index_initMethod).folderpath_phi = fullfile(EachImage.initMethods(index_initMethod).folderpath, 'phi');
        if ~exist(EachImage.initMethods(index_initMethod).folderpath_phi,'dir')
            mkdir(EachImage.initMethods(index_initMethod).folderpath_phi);
        end
        % ��ȡÿһ�����ļ��еĳ�ʼ phi ��Ϣ
        EachImage.initMethods(index_initMethod).phi = dir([EachImage.initMethods(index_initMethod).folderpath_phi '\*.mat']);
        EachImage.initMethods(index_initMethod).num_phi= numel(EachImage.initMethods(index_initMethod).phi)-numUselessFiles;
        disp(['��ʼ�������ļ��� ' EachImage.initMethods(index_initMethod).name ' �� ' num2str(EachImage.initMethods(index_initMethod).num_phi) ' ����ʼ phi �ļ�'])
        if EachImage.initMethods(index_initMethod).num_phi~=0
            for index_phi= 1:EachImage.initMethods(index_initMethod).num_phi
                EachImage.initMethods(index_initMethod).phi(index_phi).path = fullfile(EachImage.initMethods(index_initMethod).folderpath_phi, EachImage.initMethods(index_initMethod).phi(index_phi).name);
            end
        else
            disp(['�ļ��� ' EachImage.initMethods(index_initMethod).folderpath_phi ' û�г�ʼ phi �ļ�...']);
        end
        
        %% �ļ��г�ʼ time ����Ϣ
        EachImage.initMethods(index_initMethod).folderpath_time = fullfile(EachImage.initMethods(index_initMethod).folderpath, 'time');
        if ~exist(EachImage.initMethods(index_initMethod).folderpath_time,'dir')
            mkdir(EachImage.initMethods(index_initMethod).folderpath_time);
        end
        % ��ȡÿһ�����ļ��еĳ�ʼ����Э������Ϣ
        EachImage.initMethods(index_initMethod).time = dir([EachImage.initMethods(index_initMethod).folderpath_time '\*.mat']);
        EachImage.initMethods(index_initMethod).num_time= numel(EachImage.initMethods(index_initMethod).time)-numUselessFiles;
        disp(['��ʼ�������ļ��� ' EachImage.initMethods(index_initMethod).name ' �� ' num2str(EachImage.initMethods(index_initMethod).num_time) ' ����ʼ�ķ�ʱ���ļ�'])
        if EachImage.initMethods(index_initMethod).num_time ~=0
            for index_time = 1:EachImage.initMethods(index_initMethod).num_time
                EachImage.initMethods(index_initMethod).time(index_time).path = fullfile(EachImage.initMethods(index_initMethod).folderpath_time, EachImage.initMethods(index_initMethod).time(index_time).name);
            end
        else
            disp(['�ļ��� ' EachImage.initMethods(index_initMethod).folderpath_time ' û�г�ʼ�ķ�ʱ���ļ�...']);
        end
        
        %% �ļ��� prior ����Ϣ
        EachImage.initMethods(index_initMethod).folderpath_prior = fullfile(EachImage.initMethods(index_initMethod).folderpath, 'prior');
        if ~exist(EachImage.initMethods(index_initMethod).folderpath_prior,'dir')
            mkdir(EachImage.initMethods(index_initMethod).folderpath_prior);
        end
        % ��ȡÿһ�����ļ��еĳ�ʼ��������ֵ��Ϣ
        EachImage.initMethods(index_initMethod).prior = dir([EachImage.initMethods(index_initMethod).folderpath_prior '\*.mat']);
        EachImage.initMethods(index_initMethod).num_prior= numel(EachImage.initMethods(index_initMethod).prior)-numUselessFiles;
        disp(['��ʼ�������ļ��� ' EachImage.initMethods(index_initMethod).name ' �� ' num2str(EachImage.initMethods(index_initMethod).num_prior) ' ����ʼ��������ֵ�ļ�'])
        if EachImage.initMethods(index_initMethod).num_prior ~=0
            for index_prior = 1:EachImage.initMethods(index_initMethod).num_prior
                EachImage.initMethods(index_initMethod).prior(index_prior).path = fullfile(EachImage.initMethods(index_initMethod).folderpath_prior, EachImage.initMethods(index_initMethod).prior(index_prior).name);
            end
        else
            disp(['�ļ��� ' EachImage.initMethods(index_initMethod).folderpath_prior ' û�г�ʼ��������ֵ�ļ�...']);
        end
        
        %% �ļ��� mu ����Ϣ
        EachImage.initMethods(index_initMethod).folderpath_mu = fullfile(EachImage.initMethods(index_initMethod).folderpath, 'mu');
        if ~exist(EachImage.initMethods(index_initMethod).folderpath_mu,'dir')
            mkdir(EachImage.initMethods(index_initMethod).folderpath_mu);
        end
        % ��ȡÿһ�����ļ��еĳ�ʼ������ֵ��Ϣ
        EachImage.initMethods(index_initMethod).mu = dir([EachImage.initMethods(index_initMethod).folderpath_mu '\*.mat']);
        EachImage.initMethods(index_initMethod).num_mu= numel(EachImage.initMethods(index_initMethod).mu)-numUselessFiles;
        disp(['��ʼ�������ļ��� ' EachImage.initMethods(index_initMethod).name ' �� ' num2str(EachImage.initMethods(index_initMethod).num_mu) ' ����ʼ������ֵ�ļ�'])
        if EachImage.initMethods(index_initMethod).num_mu ~=0
            for index_mu = 1:EachImage.initMethods(index_initMethod).num_mu
                EachImage.initMethods(index_initMethod).mu(index_mu).path = fullfile(EachImage.initMethods(index_initMethod).folderpath_mu, EachImage.initMethods(index_initMethod).mu(index_mu).name);
            end
        else
            disp(['�ļ��� ' EachImage.initMethods(index_initMethod).folderpath_mu ' û�г�ʼ������ֵ�ļ�...']);
        end
        
        %% �ļ��� Sigma ����Ϣ
        EachImage.initMethods(index_initMethod).folderpath_Sigma = fullfile(EachImage.initMethods(index_initMethod).folderpath, 'Sigma');
        if ~exist(EachImage.initMethods(index_initMethod).folderpath_Sigma,'dir')
            mkdir(EachImage.initMethods(index_initMethod).folderpath_Sigma);
        end
        % ��ȡÿһ�����ļ��еĳ�ʼ����Э������Ϣ
        EachImage.initMethods(index_initMethod).Sigma = dir([EachImage.initMethods(index_initMethod).folderpath_Sigma '\*.mat']);
        EachImage.initMethods(index_initMethod).num_Sigma= numel(EachImage.initMethods(index_initMethod).Sigma)-numUselessFiles;
        disp(['��ʼ�������ļ��� ' EachImage.initMethods(index_initMethod).name ' �� ' num2str(EachImage.initMethods(index_initMethod).num_Sigma) ' ����ʼ����Э�����ļ�'])
        if EachImage.initMethods(index_initMethod).num_Sigma ~=0
            for index_Sigma = 1:EachImage.initMethods(index_initMethod).num_Sigma
                EachImage.initMethods(index_initMethod).Sigma(index_Sigma).path = fullfile(EachImage.initMethods(index_initMethod).folderpath_Sigma, EachImage.initMethods(index_initMethod).Sigma(index_Sigma).name);
            end
        else
            disp(['�ļ��� ' EachImage.initMethods(index_initMethod).folderpath_Sigma ' û�г�ʼ����Э�����ļ�...']);
        end
        
        %% �ļ��г�ʼ Args ����Ϣ
        EachImage.initMethods(index_initMethod).folderpath_Args = fullfile(EachImage.initMethods(index_initMethod).folderpath, 'Args');
        if ~exist(EachImage.initMethods(index_initMethod).folderpath_Args,'dir')
            mkdir(EachImage.initMethods(index_initMethod).folderpath_Args);
        end
        % ��ȡÿһ�����ļ��еĳ�ʼ���� Args ��Ϣ
        EachImage.initMethods(index_initMethod).Args = dir([EachImage.initMethods(index_initMethod).folderpath_Args '\*.mat']);
        EachImage.initMethods(index_initMethod).num_Args= numel(EachImage.initMethods(index_initMethod).Args)-numUselessFiles;
        disp(['��ʼ�������ļ��� ' EachImage.initMethods(index_initMethod).name ' �� ' num2str(EachImage.initMethods(index_initMethod).num_Args) ' �� Args �ļ�'])
        if EachImage.initMethods(index_initMethod).num_Args~=0
            for index_Args= 1:EachImage.initMethods(index_initMethod).num_Args
                EachImage.initMethods(index_initMethod).Args(index_Args).path = fullfile(EachImage.initMethods(index_initMethod).folderpath_Args, EachImage.initMethods(index_initMethod).Args(index_Args).name);
            end
        else
            disp(['�ļ��� ' EachImage.initMethods(index_initMethod).folderpath_Args ' û�� Args �ļ�...']);
        end
        
        
        
        
    end   % end init methods loop
end % end if



end

