function [ EachImage ] = createEachImageStructureForVisualization(resourcesBaseFolder, initBaseFolder, numUselessFiles)
%createEachImageStructure �����ṹ��EachImage��
%   input:
% numUselessFiles��Ҫ��ȥ�����õ��ļ��������Windowsϵͳ��ͼ���ļ�������ļ���Thumbs.db��
% output:
% EachImage������һ���ṹ��


%% �����ļ��е���Դresources �ṹ��EachImage
EachImage.folderpath_originalReources =[ resourcesBaseFolder ];	  % ������Դ�ļ���ԭͼ����ֵͼ�����ͼ���Ļ���·��
EachImage.folderpath_initResources =[ initBaseFolder ];	% ������ʼ���ļ������ֳ�ʼ���������ɵ����ʼ������ֵͼ����������ʱ������ȣ��Ļ���·��
% if ~exist(EachImage.folderpath_datasets,'dir')
%     mkdir(EachImage.folderpath_datasets);
% end



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
    for index_groundTruthBwImage = 1:EachImage.num_groundTruthBwImage
        EachImage.groundTruthBwImage(index_groundTruthBwImage).path = fullfile(EachImage.folderpath_groundTruthBwImage, EachImage.groundTruthBwImage(index_groundTruthBwImage).name);
    end
else
    disp(['�ļ��� ' EachImage.folderpath_groundTruthBwImage ' û�д𰸶�ֵͼ��ͼ�ļ�...']);
end

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
    for index_originalImage = 1:EachImage.num_originalImage
        EachImage.originalImage(index_originalImage).path = fullfile(EachImage.folderpath_originalImage, EachImage.originalImage(index_originalImage).name);
    end
else
    disp(['�ļ��� ' EachImage.folderpath_originalImage ' û��ԭʼͼ���ļ�...']);
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
    for index_scribbledImage = 1:EachImage.num_scribbledImage
        EachImage.scribbledImage(index_scribbledImage).path = fullfile(EachImage.folderpath_scribbledImage, EachImage.scribbledImage(index_scribbledImage).name);
    end
else
    disp(['�ļ��� ' EachImage.folderpath_scribbledImage ' û�д���ǵ�ԭʼͼ���ļ�...']);
end

%% seedsIndex1 �ļ���·��
% EachImage.folderpath_seedsIndex1 = fullfile(EachImage.folderpath_originalReources, 'seedsIndex1');
% if ~exist(EachImage.folderpath_seedsIndex1,'dir')
%     mkdir(EachImage.folderpath_seedsIndex1);
% end
% % ÿ��seedsIndex1���ƺ�·��
% EachImage.seedsIndex1= dir([EachImage.folderpath_seedsIndex1 '\*.mat']);
% EachImage.num_seedsIndex1 = numel(EachImage.seedsIndex1)-numUselessFiles;
% if EachImage.num_seedsIndex1 ~=0
%     for i= 1:EachImage.num_seedsIndex1
%         EachImage.seedsIndex1(i).path = fullfile(EachImage.folderpath_seedsIndex1, EachImage.seedsIndex1(i).name);
%     end
% end

%% seedsIndex2 �ļ���·��
% EachImage.folderpath_seedsIndex2 = fullfile(EachImage.folderpath_originalReources, 'seedsIndex2');
% if ~exist(EachImage.folderpath_seedsIndex2,'dir')
%     mkdir(EachImage.folderpath_seedsIndex2);
% end
% % ÿ��seedsIndex2���ƺ�·��
% EachImage.seedsIndex2= dir([EachImage.folderpath_seedsIndex2 '\*.mat']);
% EachImage.num_seedsIndex2 = numel(EachImage.seedsIndex2)-numUselessFiles;
% if EachImage.num_seedsIndex2 ~=0
%     for i= 1:EachImage.num_seedsIndex2
%         EachImage.seedsIndex2(i).path = fullfile(EachImage.folderpath_seedsIndex2, EachImage.seedsIndex2(i).name);
%     end
% end

%% seeds1 �ļ���·��
% EachImage.folderpath_seeds1 = fullfile(EachImage.folderpath_originalReources, 'seeds1');
% if ~exist(EachImage.folderpath_seeds1,'dir')
%     mkdir(EachImage.folderpath_seeds1);
% end
% % ÿ��seeds1���ƺ�·��
% EachImage.seeds1= dir([EachImage.folderpath_seeds1 '\*.mat']);
% EachImage.num_seeds1 = numel(EachImage.seeds1)-numUselessFiles;
% if EachImage.num_seeds1 ~=0
%     for i= 1:EachImage.num_seeds1
%         EachImage.seeds1(i).path = fullfile(EachImage.folderpath_seeds1, EachImage.seeds1(i).name);
%     end
% end

%% seeds2 �ļ���·��
% EachImage.folderpath_seeds2 = fullfile(EachImage.folderpath_originalReources, 'seeds2');
% if ~exist(EachImage.folderpath_seeds2,'dir')
%     mkdir(EachImage.folderpath_seeds2);
% end
% % ÿ��seeds2���ƺ�·��
% EachImage.seeds2= dir([EachImage.folderpath_seeds2 '\*.mat']);
% EachImage.num_seeds2 = numel(EachImage.seeds2)-numUselessFiles;
% if EachImage.num_seeds2 ~=0
%     for i= 1:EachImage.num_seeds2
%         EachImage.seeds2(i).path = fullfile(EachImage.folderpath_seeds2, EachImage.seeds2(i).name);
%     end
% end

%% seedsImg1 �ļ���·��
% EachImage.folderpath_seedsImg1 = fullfile(EachImage.folderpath_originalReources, 'seedsImg1');
% if ~exist(EachImage.folderpath_seedsImg1,'dir')
%     mkdir(EachImage.folderpath_seedsImg1);
% end
% % ÿ��seedsImg1���ƺ�·��
% EachImage.seedsImg1= dir([EachImage.folderpath_seedsImg1 '\*.bmp']);
% EachImage.num_seedsImg1 = numel(EachImage.seedsImg1)-numUselessFiles;
% if EachImage.num_seedsImg1 ~=0
%     for i= 1:EachImage.num_seedsImg1
%         EachImage.seedsImg1(i).path = fullfile(EachImage.folderpath_seedsImg1, EachImage.seedsImg1(i).name);
%     end
% end

%% seedsImg2 �ļ���·��
% EachImage.folderpath_seedsImg2 = fullfile(EachImage.folderpath_originalReources, 'seedsImg2');
% if ~exist(EachImage.folderpath_seedsImg2,'dir')
%     mkdir(EachImage.folderpath_seedsImg2);
% end
% % ÿ��seedsImg2���ƺ�·��
% EachImage.seedsImg2= dir([EachImage.folderpath_seedsImg2 '\*.bmp']);
% EachImage.num_seedsImg2 = numel(EachImage.seedsImg2)-numUselessFiles;
% if EachImage.num_seedsImg2 ~=0
%     for i= 1:EachImage.num_seedsImg2
%         EachImage.seedsImg2(i).path = fullfile(EachImage.folderpath_seedsImg2, EachImage.seedsImg2(i).name);
%     end
% end







%% �ļ��� contour images ����Ϣ
% EachImage.folderpath_contourImage = fullfile(EachImage.folderpath_initResources, 'contour images');
% if ~exist(EachImage.folderpath_contourImage,'dir')
%     mkdir(EachImage.folderpath_contourImage);
% end
% % ��ȡÿһ�����ļ��еĳ�ʼ����������ֵͼ��Ϣ
% EachImage.contourImage = dir([EachImage.folderpath_contourImage '\*.bmp']);
% EachImage.num_contourImage= numel(EachImage.contourImage)-numUselessFiles;
% disp(['�ļ��� contour images �� ' num2str(EachImage.num_contourImage) ' ���ļ�'])
% if EachImage.num_contourImage ~=0
%     for index_contourImage = 1:EachImage.num_contourImage
%         EachImage.contourImage(index_contourImage).path = fullfile(EachImage.folderpath_contourImage, EachImage.contourImage(index_contourImage).name);
%     end
% else
%     disp(['�ļ��� ' EachImage.folderpath_contourImage ' û�г�ʼ������ֵͼ��ͼ�ļ�...']);
% end

%% �ļ��г�ʼ phi ����Ϣ
% EachImage.folderpath_phi = fullfile(EachImage.folderpath_initResources, 'phi');
% if ~exist(EachImage.folderpath_phi,'dir')
%     mkdir(EachImage.folderpath_phi);
% end
% % ��ȡÿһ�����ļ��еĳ�ʼ����Э������Ϣ
% EachImage.phi = dir([EachImage.folderpath_phi '\*.mat']);
% EachImage.num_phi= numel(EachImage.phi)-numUselessFiles;
% disp(['�ļ��� phi �� ' num2str(EachImage.num_phi) ' ���ļ�'])
% if EachImage.num_phi~=0
%     for index_phi= 1:EachImage.num_phi
%         EachImage.phi(index_phi).path = fullfile(EachImage.folderpath_phi, EachImage.phi(index_phi).name);
%     end
% else
%     disp(['�ļ��� ' EachImage.folderpath_phi ' û�г�ʼˮƽ��Ƕ�뺯���ļ�...']);
% end

%% �ļ��г�ʼ time ����Ϣ
% EachImage.folderpath_time = fullfile(EachImage.folderpath_initResources, 'time');
% if ~exist(EachImage.folderpath_time,'dir')
%     mkdir(EachImage.folderpath_time);
% end
% % ��ȡÿһ�����ļ��еĳ�ʼ����Э������Ϣ
% EachImage.time = dir([EachImage.folderpath_time '\*.mat']);
% EachImage.num_time= numel(EachImage.time)-numUselessFiles;
% disp(['�ļ��� time �� ' num2str(EachImage.num_time) ' ���ļ�'])
% if EachImage.num_time ~=0
%     for index_time = 1:EachImage.num_time
%         EachImage.time(index_time).path = fullfile(EachImage.folderpath_time, EachImage.time(index_time).name);
%     end
% else
%     disp(['�ļ��� ' EachImage.folderpath_time ' û�г�ʼ�ķ�ʱ���ļ�...']);
% end

%% �ļ��� prior ����Ϣ
% EachImage.folderpath_prior = fullfile(EachImage.folderpath_initResources, 'prior');
% if ~exist(EachImage.folderpath_prior,'dir')
%     mkdir(EachImage.folderpath_prior);
% end
% % ��ȡÿһ�����ļ��еĳ�ʼ��������ֵ��Ϣ
% EachImage.prior = dir([EachImage.folderpath_prior '\*.mat']);
% EachImage.num_prior= numel(EachImage.prior)-numUselessFiles;
% disp(['�ļ��� prior �� ' num2str(EachImage.num_prior) ' ���ļ�'])
% if EachImage.num_prior ~=0
%     for index_prior = 1:EachImage.num_prior
%         EachImage.prior(index_prior).path = fullfile(EachImage.folderpath_prior, EachImage.prior(index_prior).name);
%     end
% else
%     disp(['�ļ��� ' EachImage.folderpath_prior ' û�г�ʼ��������ֵ�ļ�...']);
% end

%% �ļ��� mu ����Ϣ
% EachImage.folderpath_mu = fullfile(EachImage.folderpath_initResources, 'mu');
% if ~exist(EachImage.folderpath_mu,'dir')
%     mkdir(EachImage.folderpath_mu);
% end
% % ��ȡÿһ�����ļ��еĳ�ʼ������ֵ��Ϣ
% EachImage.mu = dir([EachImage.folderpath_mu '\*.mat']);
% EachImage.num_mu= numel(EachImage.mu)-numUselessFiles;
% disp(['�ļ��� mu �� ' num2str(EachImage.num_mu) ' ���ļ�'])
% if EachImage.num_mu ~=0
%     for index_mu = 1:EachImage.num_mu
%         EachImage.mu(index_mu).path = fullfile(EachImage.folderpath_mu, EachImage.mu(index_mu).name);
%     end
% else
%     disp(['�ļ��� ' EachImage.folderpath_mu ' û�г�ʼ������ֵ�ļ�...']);
% end

%% �ļ��� Sigma ����Ϣ
% EachImage.folderpath_Sigma = fullfile(EachImage.folderpath_initResources, 'Sigma');
% if ~exist(EachImage.folderpath_Sigma,'dir')
%     mkdir(EachImage.folderpath_Sigma);
% end
% % ��ȡÿһ�����ļ��еĳ�ʼ����Э������Ϣ
% EachImage.Sigma = dir([EachImage.folderpath_Sigma '\*.mat']);
% EachImage.num_Sigma= numel(EachImage.Sigma)-numUselessFiles;
% disp(['�ļ��� Sigma �� ' num2str(EachImage.num_Sigma) ' ���ļ�'])
% if EachImage.num_Sigma ~=0
%     for index_Sigma = 1:EachImage.num_Sigma
%         EachImage.Sigma(index_Sigma).path = fullfile(EachImage.folderpath_Sigma, EachImage.Sigma(index_Sigma).name);
%     end
% else
%     disp(['�ļ��� ' EachImage.folderpath_Sigma ' û�г�ʼ����Э�����ļ�...']);
% end

%% �ļ��г�ʼ Args ����Ϣ
% EachImage.folderpath_Args = fullfile(EachImage.folderpath_initResources, 'Args');
% if ~exist(EachImage.folderpath_Args,'dir')
%     mkdir(EachImage.folderpath_Args);
% end
% % ��ȡÿһ�����ļ��еĳ�ʼ���� Args ��Ϣ
% EachImage.Args = dir([EachImage.folderpath_Args '\*.mat']);
% EachImage.num_Args= numel(EachImage.Args)-numUselessFiles;
% disp(['�ļ��� Args �� ' num2str(EachImage.num_Args) ' ���ļ�'])
% if EachImage.num_Args~=0
%     for index_Args= 1:EachImage.num_Args
%         EachImage.Args(index_Args).path = fullfile(EachImage.folderpath_Args, EachImage.Args(index_Args).name);
%     end
% else
%     disp(['�ļ��� ' EachImage.folderpath_Args ' û�� Args �ļ�...']);
% end




end

