function [ EachImage ] = createInitializedResourceStructure( resourcesBaseFolder, numUselessFiles )
%CREATE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
% createInitializedResourceStructure �����ṹ��EachImage��
%   input:
% numUselessFiles��Ҫ��ȥ�����õ��ļ��������Windowsϵͳ��ͼ���ļ�������ļ���Thumbs.db��
% output:
% EachImage������һ���ṹ��


%% �����ļ��е���Դresources �ṹ��EachImage
EachImage.folderpath_reourcesDatasets =[ resourcesBaseFolder ];	  % ������Դ�ļ���ԭͼ����ֵͼ�����ͼ���Ļ���·��


%% �ļ��� contour images ����Ϣ
EachImage.folderpath_contourImage = fullfile(EachImage.folderpath_initDatasets, 'contour images');
if ~exist(EachImage.folderpath_contourImage,'dir')
    mkdir(EachImage.folderpath_contourImage);
end
% ��ȡÿһ�����ļ��еĳ�ʼ����������ֵͼ��Ϣ
EachImage.contourImage = dir([EachImage.folderpath_contourImage '\*.bmp']);
EachImage.num_contourImage= numel(EachImage.contourImage)-numUselessFiles;
disp(['�ļ��� contour images �� ' num2str(EachImage.num_contourImage) ' ���ļ�'])
if EachImage.num_contourImage ~=0
    for index_contourImage = 1:EachImage.num_contourImage
        EachImage.contourImage(index_contourImage).path = fullfile(EachImage.folderpath_contourImage, EachImage.contourImage(index_contourImage).name);
    end
else
    disp(['�ļ��� ' EachImage.folderpath_contourImage ' û�г�ʼ������ֵͼ��ͼ�ļ�...']);
end

%% �ļ��г�ʼ phi ����Ϣ
EachImage.folderpath_phi = fullfile(EachImage.folderpath_initDatasets, 'phi');
if ~exist(EachImage.folderpath_phi,'dir')
    mkdir(EachImage.folderpath_phi);
end
% ��ȡÿһ�����ļ��еĳ�ʼ����Э������Ϣ
EachImage.phi = dir([EachImage.folderpath_phi '\*.mat']);
EachImage.num_phi= numel(EachImage.phi)-numUselessFiles;
disp(['�ļ��� phi �� ' num2str(EachImage.num_phi) ' ���ļ�'])
if EachImage.num_phi~=0
    for index_phi= 1:EachImage.num_phi
        EachImage.phi(index_phi).path = fullfile(EachImage.folderpath_phi, EachImage.phi(index_phi).name);
    end
else
    disp(['�ļ��� ' EachImage.folderpath_phi ' û�г�ʼˮƽ��Ƕ�뺯���ļ�...']);
end

%% �ļ��г�ʼ time ����Ϣ
EachImage.folderpath_time = fullfile(EachImage.folderpath_initDatasets, 'time');
if ~exist(EachImage.folderpath_time,'dir')
    mkdir(EachImage.folderpath_time);
end
% ��ȡÿһ�����ļ��еĳ�ʼ����Э������Ϣ
EachImage.time = dir([EachImage.folderpath_time '\*.mat']);
EachImage.num_time= numel(EachImage.time)-numUselessFiles;
disp(['�ļ��� time �� ' num2str(EachImage.num_time) ' ���ļ�'])
if EachImage.num_time ~=0
    for index_time = 1:EachImage.num_time
        EachImage.time(index_time).path = fullfile(EachImage.folderpath_time, EachImage.time(index_time).name);
    end
else
    disp(['�ļ��� ' EachImage.folderpath_time ' û�г�ʼ�ķ�ʱ���ļ�...']);
end

%% �ļ��� prior ����Ϣ
EachImage.folderpath_prior = fullfile(EachImage.folderpath_initDatasets, 'prior');
if ~exist(EachImage.folderpath_prior,'dir')
    mkdir(EachImage.folderpath_prior);
end
% ��ȡÿһ�����ļ��еĳ�ʼ��������ֵ��Ϣ
EachImage.prior = dir([EachImage.folderpath_prior '\*.mat']);
EachImage.num_prior= numel(EachImage.prior)-numUselessFiles;
disp(['�ļ��� prior �� ' num2str(EachImage.num_prior) ' ���ļ�'])
if EachImage.num_prior ~=0
    for index_prior = 1:EachImage.num_prior
        EachImage.prior(index_prior).path = fullfile(EachImage.folderpath_prior, EachImage.prior(index_prior).name);
    end
else
    disp(['�ļ��� ' EachImage.folderpath_prior ' û�г�ʼ��������ֵ�ļ�...']);
end

%% �ļ��� mu ����Ϣ
EachImage.folderpath_mu = fullfile(EachImage.folderpath_initDatasets, 'mu');
if ~exist(EachImage.folderpath_mu,'dir')
    mkdir(EachImage.folderpath_mu);
end
% ��ȡÿһ�����ļ��еĳ�ʼ������ֵ��Ϣ
EachImage.mu = dir([EachImage.folderpath_mu '\*.mat']);
EachImage.num_mu= numel(EachImage.mu)-numUselessFiles;
disp(['�ļ��� mu �� ' num2str(EachImage.num_mu) ' ���ļ�'])
if EachImage.num_mu ~=0
    for index_mu = 1:EachImage.num_mu
        EachImage.mu(index_mu).path = fullfile(EachImage.folderpath_mu, EachImage.mu(index_mu).name);
    end
else
    disp(['�ļ��� ' EachImage.folderpath_mu ' û�г�ʼ������ֵ�ļ�...']);
end

%% �ļ��� Sigma ����Ϣ
EachImage.folderpath_Sigma = fullfile(EachImage.folderpath_initDatasets, 'Sigma');
if ~exist(EachImage.folderpath_Sigma,'dir')
    mkdir(EachImage.folderpath_Sigma);
end
% ��ȡÿһ�����ļ��еĳ�ʼ����Э������Ϣ
EachImage.Sigma = dir([EachImage.folderpath_Sigma '\*.mat']);
EachImage.num_Sigma= numel(EachImage.Sigma)-numUselessFiles;
disp(['�ļ��� Sigma �� ' num2str(EachImage.num_Sigma) ' ���ļ�'])
if EachImage.num_Sigma ~=0
    for index_Sigma = 1:EachImage.num_Sigma
        EachImage.Sigma(index_Sigma).path = fullfile(EachImage.folderpath_Sigma, EachImage.Sigma(index_Sigma).name);
    end
else
    disp(['�ļ��� ' EachImage.folderpath_Sigma ' û�г�ʼ����Э�����ļ�...']);
end







end

