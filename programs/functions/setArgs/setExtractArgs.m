function [Args] = setExtractArgs( Args )
% setExtractImagesArgs ����������ȡͼ�����Ĳ���
%   �˴���ʾ��ϸ˵��
%% ���
% collectImagesForExtractByOtherIndicator.m ʵ����ȡ����������ͼ���Լ���ֵͼ��ָ���ļ����Ա����˹�ɸѡ
% ��ȡָ�����ļ����ļ��е�ģʽ���������֣�
% ģʽ1 ��ʾ�ڴ��н�ǿ������ָ������������µĵ�һ��ɸѡ�£���ȡ��Ӧͼ��
% ģʽ2 ��ʾ�ڴ��н���������ָ������������µĵ�һ��ɸѡ�£���ȡ��Ӧͼ��
% ģʽ3 ��ʾ��ɸѡ������£���ȡ��Ӧͼ��
% ע���������ʱ����ʾҪ������ʵ���飡

%% �û������ʼ���� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Args.mode = Args.mode ; % ��ȡָ�����ļ����ļ��е�ģʽ������������
Args.folderpath_reourcesDatasets = Args.folderpath_reourcesDatasets;    % ������Դ�ļ���ԭͼ����ֵͼ�����ͼ���Ļ���·��
Args.folderpath_initDatasets = Args.folderpath_initDatasets;    % ������ʼ���ļ������ֳ�ʼ���������ɵ����ʼ������ֵͼ����������ʱ������ȣ��Ļ���·��
Args.folderpath_ResultsBaseFolder = Args.folderpath_ResultsBaseFolder; % ������ȡ�ļ��Ľṹ�� Results �Ļ���·����
% Args.folderpath_finalResultsBaseFolder = '.\data\evaluation\circleACMGMM 5-28������\Ҫ��kmeans+AMCGMM�����\end0.001'; % ������ȡ�ļ��Ľṹ�� Results �Ļ���·����
Args.folderpath_outputBase = Args.folderpath_outputBase; % ��ȡ�ļ���Ŀ���ļ���

Args.outputMode =Args.outputMode  ;	 % ָ��������ʵ����ļ��е��ļ�������ʾ���͡���ѡ 'datatime' 'index'��'datatime' ��ʾʵ���ļ�������������ʱ�䣻'index'��ʾʵ���ļ��������Ǳ�š�Ĭ�� 'datatime'���Ƽ���Ĭ��ֵ��
Args.num_scribble = Args.num_scribble ; % ���д������ͼ��ı������������Ŀǰ��ʱ�����ǲ�ͬ��ǶԷָ�Ч����Ӱ�죬��������һ��ͼ��һ�ֱ�ǣ����Ŀǰ�ֶ�����Ϊ1��
Args.isVisual = Args.isVisual ;  % ���ƹ��̲����ӻ���������������в鿴����� 'yes'��ʾ���ƹ����п��ӻ� ��'no'��ʾ���ƹ����в����ӻ���Ĭ��'no'
Args.numUselessFiles = Args.numUselessFiles; % Ҫ�ų���ͼ����������ʱ��洢ͼƬ���ļ��г�����ͼ���ļ������п�����ϵͳ�ļ��ᱻ���������Ҫ�ֶ��ų���
Args.ratioOfGood = Args.ratioOfGood; % ����õ�ͼ�����ռ��ָ���ֵ�ı�����ֵ��ֵ��[0,1]��Ĭ�� 0.85
Args.ratioOfBad =Args.ratioOfBad  ; % ������ͼ�����ռ��ָ���ֵ�ı�����ֵ��ֵ��[0,1]��Ĭ�� 0.65
Args.ratioOfBetter = Args.ratioOfBetter; % ���ַ����Ƚ�ʱ������AҪ�ȷ���B��ָ���ֵ�ı���Ҫ���ڵ��ڸ�ֵ������Ϊ���Ժá�ֵ��[0,1]��Ĭ�� 0.3
Args.ratioOfBetterAtBothGood =Args.ratioOfBetterAtBothGood; % ���ַ����Ƚ�ʱ�����ַ������õ�����£�����AҪ�ȷ���B��ָ���ֵ�ı���Ҫ���ڵ��ڸ�ֵ������Ϊ���Ժá�ֵ��[0,1]��Ĭ��0.1
Args.ratioOfRegion = Args.ratioOfRegion; % ʵ����Ͷ�����Ƚ�ʱ��ʵ����Ч���ȶ�����Ч�����õ�ͼ������ ռ ʵ����Ч���ȶ�����Ч���õ�ͼ������ �ı�����
Args.ratioOfRand =Args.ratioOfRand ; % ����ʵ����Ͷ�����Ƚ�ʱ��ʵ����Ч���õ�ͼ������ռ��ͼ�������ı����������Χ��
Args.numImagesShow = Args.numImagesShow ; % Ҫ��ȡ��ͼ����������������



end

