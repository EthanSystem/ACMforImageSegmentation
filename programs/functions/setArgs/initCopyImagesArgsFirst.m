%% ���
% ��ȡָ���ļ��е�������ԭͼ��ص�ͼ����ص���ֵͼ���������ָ�����Ķ�ֵͼ����ͬһ���ļ���������һ��ɸѡ��

%% ���
% collectImagesForExtractByHuman.m ʵ����ȡ����������ͼ���Լ���ֵͼ��ָ���ļ����Ա����˹�ɸѡ
% ģʽ1 ��ȡ��Ӧͼ��������һ��ɸѡ��
% ģʽ2 ��ȡ��Ӧͼ��������Ϊ��һ��ͼ��ָ�ͷ�����ͼ�񼯺ϡ�
% ģʽ3 ��ȡ��Ӧͼ��������Ϊ��һ�����µĳ�ʼ���������зָ�ͷ�����ͼ�񼯺ϡ�

%% �û������ʼ���� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Args.mode = '2' ;
Args.folderpath_EachImageResourcesBaseFolder = '.\data\ACMGMMSEMI\MSRA1K\original resources' ; % ������Դ�ļ���ԭͼ����ֵͼ�����ͼ���Ļ���·��
Args.folderpath_EachImageInitBaseFolder='.\data\ACMGMMSEMI\MSRA1K\init resources'; % ������ʼ���ļ������ֳ�ʼ���������ɵ����ʼ������ֵͼ����������ʱ������ȣ��Ļ���·��
Args.folderpath_ResultsBaseFolder = '.\data\ACMGMMSEMI\MSRA1K\segmentations' ; % ������ȡ�ļ��Ľṹ�� Results �Ļ���·����
Args.folderpath_extractedImageBaseFolder = '.\data\ACMGMMSEMI\ɸ1\original resources' ; % ����ȡ���ļ���ͼ������·����
% for mode = '1' or '2' :
Args.folderpath_output_ResourcesBaseFolder = '.\data\ACMGMMSEMI\ɸ1\original resources' ; % ����� resources ͼ���·��
Args.folderpath_output_InitBaseFolder = '.\data\ACMGMMSEMI\ɸ1\init resources' ; % ����� resources ͼ���·��
% for mode = '2' :
Args.folderpath_ouput_segmentations = '.\data\ACMGMMSEMI\ɸ1\segmentations' ; % ����� evaluation ͼ���·��
Args.isVisual = 'no' ;  % ���ƹ��̲����ӻ���������������в鿴����� 'yes'��ʾ���ƹ����п��ӻ� ��'no'��ʾ���ƹ����в����ӻ���Ĭ��'no'
Args.numUselessFiles = 0; % Ҫ�ų���ͼ����������ʱ��洢ͼƬ���ļ��г�����ͼ���ļ������п�����ϵͳ�ļ��ᱻ���������Ҫ�ֶ��ų���
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
