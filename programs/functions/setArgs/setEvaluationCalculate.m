function [Args]=setEvaluationCalculate(Args)
%% �����������㺯����Ҫ�Ĳ���
%% �û������ʼ���� %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Args.folderpath_resourcesBaseFolder = Args.folderpath_resourcesBaseFolder; % ���ڼ����ļ��Ľṹ�� EachImage �Ļ���·��
Args.folderpath_initBaseFolder =Args.folderpath_initBaseFolder; % ���ڼ����ļ��Ľṹ�� EachImage �Ļ���·��
Args.folderpath_ResultsBaseFolder = Args.folderpath_ResultsBaseFolder; % ���ڼ����ļ��Ľṹ�� Results �Ļ���·����
Args.beta =Args.beta; % the F_1 ָ���� F-beta ָ���� beta =1 ʱ��������
Args.num_scribble=Args.num_scribble; % ���д������ͼ��ı������������Ŀǰ��ʱ�����ǲ�ͬ��ǶԷָ�Ч����Ӱ�죬��������һ��ͼ��һ�ֱ�ǣ����Ŀǰ�ֶ�����Ϊ1��
Args.numUselessFiles = Args.numUselessFiles; % Ҫ�����ͼ����������ʱ��洢ͼƬ���ļ��г�����ͼ���ļ������п�����ϵͳ�ļ����ᱻ���������Ҫ�ֶ��ų�
Args.mode = Args.mode ; % ��'1' ��ʾ����תͼ��'2' ��ʾ���ݼ���ָ��ͬʱ�ж��Ƿ�תͼ��'3' ��ʾ���� ��׼��P ָ���ж��Ƿ�תͼ��

end

