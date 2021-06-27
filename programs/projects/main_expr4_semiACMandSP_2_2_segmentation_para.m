%% ���ڷָ��������

% ʵ��4���ںϳ��������İ�ලACMGMM��ʵ��ϵ��

%% ע�����
% �ֶ����ļ��С�ACM+GMM����Ϊ��ǰ�ļ��С��ֶ���������ļ��С�functions������projects���������ļ������·����

%%

% ÿ������MATLAB��ֻ��Ҫ����һ�Ρ�
VLROOTS='';
run('C:\Softwares\VLFeat\toolbox\vl_setup');
% vl_version verbose
% addpath of vl-feat. the pathname may be different in different PC.


%% Ԥ����
clear all;
close all;
clc;
diary off;
sp=actxserver('SAPI.SpVoice');
addpath( genpath( '.\functions' ) ); %��ӵ�ǰ·���µ������ļ����Լ����ļ���
addpath( genpath( '.\projects' ) ); %��ӵ�ǰ·���µ������ļ����Լ����ļ���
addpath( genpath( '.\tools' ) ); %��ӵ�ǰ·���µ������ļ����Լ����ļ���



%% %%%% ��ʼȫ�������� %%%%%%
initSegmentationArgsFirst;
Args.numIteration_outer = 1000  ;		% ��ѭ��������default = 1000
Args.smallNumber=realmin + 1E-20;  % ������ӵķ�ֹ�������������С����
Args.proportionPixelsToEndLoop = 0.00100 ; % �����ݻ�ѭ��ֹͣ���������������ڵ���֮�䣬ǰ�������������ı������ռ�������������ı���ֵС���趨ֵʱ��ֹͣ��ֵ��[0,1]��Ĭ�� 0.00100 ��
Args.isNotWriteDataAtAll = 'yes' ; % �������й����в����Ľ�������Ƿ񱣴棬��� 'yes'����ô�Ͳ����������ݣ��������յĶ�ֵͼͼ���ǻᱣ��ġ�Ĭ�� 'yes'
Args.periodOfWriteData = 1 ; % д���ݵĵ����������ڣ���ÿ����������һ�γ������й����в�������һ�������ݡ�Ĭ�� 10


%% ·������
Args.folderpath_EachImageResourcesBaseFolder = '.\data\resources\MSRA1K 4 images\original resources';

folderpath_EachImageInitBaseFolder{1} = '.\data\resources\MSRA1K 4 images\init resources\scribbled_circle_SDF_kmeans100_2';

Args.folderpath_ResultsBaseFolder = '.\data\expr4_semiACMGMMSP_2_2_para_2' ;

Args.markType='scribble';


%% %%%%%%%%%%%%%%% ʵ���� %%%%%%%%%%%%%%%%%%%%%%%%

%% ʹ�� ACMGMMandSPsemisupervised_2 ����
Args.evolutionMethod = 'semiACMGMMSP_2_2';

%% ACMGMMandSPsemisupervised_2 ��������
% probability term
Args.timestep = 0.1 ;  % time step, default = 0.10
Args.epsilon = 0.5 ; % papramater that specifies the width of the DiracDelta function. default=0.05 and more at ref [1].
Args.beta = 0.5 ; % coefficeient of the weighted length term L(phi). default=0.5. also 0.001*255*255.
Args.gamma = 0.0 ;  % coefficient of the weighted area term A(phi). default=0.2.
Args.lambda = 1.0 ;  % coefficient of the weighted superpixels force term F_sp(phi). default=1.0.
Args.sigma= 1.5 ;     % scale parameter in Gaussian kernel , default is 1.5 .
Args.hsize= 5 ;			% ��˹�˲�����ģ���С��default is 15, also means 15 x 15.

% ���ֵĳ����صı߳�
Args.SuperPixels_lengthOfSide = 8 ;

% ���ֵĳ����صĹ����
Args.SuperPixels_regulation = 0.9 ;

% ��ɫ�����ӺͿռ������ӵ�Ȩ��
Args.weight_feature = 1;  % Ȩ��ֵ ��ʾ��ɫ�����ӵ�Ȩ��ֵ��(1-Ȩ��ֵ) ��ʾ�ռ������ӵ�Ȩ��ֵ

% number of nearest neighbors . ���鲻Ҫ��ֵ̫��Ŀǰ�ĳ���û�иĽ����������ױ���
Args.numNearestNeighbors = 10;


% ��ɫ�ռ�
% ��ѡֵ�� 'RGB' 'LAB' 'HSV' ����֮һ
Args.colorspace='RGB';
% �������������ͣ�'SP'��'DEF'��'SP DEF'����ѡһ
Args.forceType= 'SP DEF';
% ѡ����㳬���������ķ���������ѡ���У� '1' ~ '5'
Args.SPFeatureMethod = '3' ;

% ���²���Ҫ��
Args.mu = 1;  % coefficeient of the weighted probability term prob(phi).
Args.heavisideFunctionType = '1'; % ѡ��heaviside���������ͣ�default = '1'
Args.piType='2';   % pi�����͡�'2' ��ʾʽ��(25)�����ġ�
Args.initializeType = 'SDF' ; % ѡ��Ƕ�뺯����ʼ����ʽ�� 'user' ��ʾ���Զ����������ɽ�Ծ������'SDF' ��ʾ�þ�����뺯��
Args.contoursInitValue =1 ;    % the value used for initialization contours.
Args.scaleOflabeledProbabilities = 2.0;  % ͼ����б�������ĸ���ֵ��δ��������ĸ���ֵ�����ֵ����Сֵ����Ҫ��С���ı���ֵ��Ĭ������ 2.0 ����
Args.numIteration_SP = 1 ;  % �����ؼ����ݻ�ѭ��������Ĭ��Ϊ 3

% ���²��ܸ�
Args.isNeedInitializingContourByLSMethod = 'no';  % �Ƿ���Ҫ��ˮƽ��������ʼ��������'yes'��ʾ��Ҫ��'no'��ʾ����Ҫ��

% % �Ƿ���ӻ��Ŀ���
Args.isVisualEvolution='no';
Args.isVisualSegoutput='no';
Args.isVisualSPDistanceMat='no';
Args.isVisualProbability='no';
Args.isVisualSspc='no';

Args.isVisual_f_data='no';
Args.isVisualLabels='no';



%% ACMGMMandSPsemisupervised_2 ���Է���ר�� %%%%%%%%%%%%%%%%%%%%%%%%%%%
% i=0;
% for initMethod=folderpath_EachImageInitBaseFolder
%     i=i+1;
%     if isempty(initMethod{1})
%         i=i+1;
%         continue;
%     end
%     Args.folderpath_EachImageInitBaseFolder=initMethod{1};
%     Args.foldername_experiment =['semiACMGMMSP_2' '_SPfeature' Args.SPFeatureMethod datestr(now,'ddHHMMSS')];
%     Args = setSegmentationMethod(Args, Args.evolutionMethod);
%     segmentation_func(Args);
% end





%% evolution_ACMGMMandSPsemisupervised_2 �� ��ͬ�����µ�����������1 %%%%%%%%%%%%%
% i=0;
% j=0;
% for initMethod=folderpath_EachImageInitBaseFolder
%     i=i+1;
%     if isempty(initMethod{1})
%         i=i+1;
%         continue;
%     end
%     Args.folderpath_EachImageInitBaseFolder=initMethod{1};
%     for el=[0.00100 0.00030 0.00010]
%         Args.proportionPixelsToEndLoop=el;
%         j=j+1;
%         for colorspace={'RGB' 'LAB' 'HSV'}
%             Args.colorspace=colorspace{1};
%             for SuperPixels_lengthOfSide=[5 10 15]
%                 Args.SuperPixels_lengthOfSide=SuperPixels_lengthOfSide;
%                 for epsilon=[1.00 0.50 0.20 0.10 0.05]
%                     Args.epsilon=epsilon;
%                     for lambda=[010.0 001.0 000.1 000.0]
%                         Args.lambda=lambda;
%                         Args.foldername_experiment =[...
%                             'semiSP_1' ...
%                             '_el' num2str(j) ...
%                             '_color' Args.colorspace ...
%                             '_SPsize' num2str(Args.SuperPixels_lengthOfSide) ...
%                             '_step' num2str(Args.timestep) ...
%                             '_epsilon' num2str(Args.epsilon) ...
%                             '_lambda' num2str(Args.lambda)];
%                         Args = setSegmentationMethod(Args, Args.evolutionMethod);
%                         segmentation_func(Args);
%                     end
%                 end
%             end
%         end
%     end
% end
%

%% evolution_ACMGMMandSPsemisupervised_2 �� ��ͬ�����µ�����������1 %%%%%%%%%%%%%
% i=0;
% j=0;
% for initMethod=folderpath_EachImageInitBaseFolder
%     i=i+1;
%     if isempty(initMethod{1})
%         i=i+1;
%         continue;
%     end
%     Args.folderpath_EachImageInitBaseFolder=initMethod{1};
%     for el=[0.00100 0.00030 0.00010]
%         Args.proportionPixelsToEndLoop=el;
%         j=j+1;
%         for timestep=[0.1 0.3 0.03]
%             Args.timestep=timestep;
%             for colorspace={'RGB' 'LAB' 'HSV'}
%                 Args.colorspace=colorspace{1};
%                 for SuperPixels_lengthOfSide=[6 12]
%                     Args.SuperPixels_lengthOfSide=SuperPixels_lengthOfSide;
%                     for epsilon=[1.00 0.50 0.20 0.10 0.05]
%                         Args.epsilon=epsilon;
%                         for lambda=[010.0 001.0 000.1 000.0]
%                             Args.lambda=lambda;
%                             Args.foldername_experiment =[...
%                                 Args.evolutionMethod ...
%                                 '_el' num2str(j) ...
%                                 '_step' num2str(Args.timestep) ...
%                                 '_color' Args.colorspace ...
%                                 '_SPsize' num2str(Args.SuperPixels_lengthOfSide) ...
%                                 '_epsilon' num2str(Args.epsilon) ...
%                                 '_lambda' num2str(Args.lambda)];
%                             Args = setSegmentationMethod(Args, Args.evolutionMethod);
%                             segmentation_func(Args);
%                         end
%                     end
%                 end
%             end
%         end
%     end
% end


%% evolution_ACMGMMandSPsemisupervised_2 �� ��ͬ�����µ�����������2 %%%%%%%%%%%%%
i=0;
j=0;
for initMethod=folderpath_EachImageInitBaseFolder
    i=i+1;
    if isempty(initMethod{1})
        i=i+1;
        continue;
    end
    Args.folderpath_EachImageInitBaseFolder=initMethod{1};
    for el=[0.00100 0.00030 0.00010]
        Args.proportionPixelsToEndLoop=el;
        j=j+1;
        for SPFeatureMethod={'2' '3'}
            Args.SPFeatureMethod = SPFeatureMethod{1};
            for epsilon=[10 3 1 0.5 0.2]
                Args.epsilon=epsilon;
                for lambda=[1 3 10 30]
                    Args.lambda=lambda;
                    Args.foldername_experiment =[...
                        Args.evolutionMethod ...
                        '_el' num2str(j) ...
                        '_step' num2str(Args.timestep) ...
                        '_epsilon' num2str(Args.epsilon) ...
                        '_lambda' num2str(Args.lambda)];
                    Args = setSegmentationMethod(Args, Args.evolutionMethod);
                    segmentation_func(Args);
                end
            end
        end
    end
end









%% end
% text=['����ȫ��������ϡ�'];
% sp.Speak(text);















