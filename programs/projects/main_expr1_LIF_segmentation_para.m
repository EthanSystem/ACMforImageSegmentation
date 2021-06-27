%% ���ڷָ��������
% ʵ��1��ACMGMM��ʵ��ϵ�У�LIF�����ĵ�������

%% ע�����
% �ֶ����ļ��С�ACM����Ϊ��ǰ�ļ��С��ֶ���������ļ��С�functions������projects���������ļ������·����



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
% Args.timestep=0.10;  % time step, default = 0.10
Args.numIteration_outer = 010000  ;		% ��ѭ��������default = 1000
Args.smallNumber=realmin + 1E-20;  % ������ӵķ�ֹ�������������С����
Args.proportionPixelsToEndLoop = 0.0010 ; % �����ݻ�ѭ��ֹͣ���������������ڵ���֮�䣬ǰ�������������ı������ռ�������������ı���ֵС���趨ֵʱ��ֹͣ��ֵ��[0,1]��Ĭ�� 0.00100 ��
Args.isNotWriteDataAtAll = 'no' ; % �������й����в����Ľ�������Ƿ񱣴棬��� 'yes'����ô�Ͳ����������ݣ��������յĶ�ֵͼͼ���ǻᱣ��ġ�Ĭ�� 'yes'
Args.periodOfWriteData = 100 ; % д���ݵĵ����������ڣ���ÿ����������һ�γ������й����в�������һ�������ݡ�Ĭ�� 10

%% ·��������
Args.folderpath_EachImageResourcesBaseFolder = '.\data\resources\MSRA1K 6 images\original resources';

folderpath_EachImageInitBaseFolder{1} = '.\data\resources\MSRA1K 6 images\init resources\circle_SDF_kmeans100';
% folderpath_EachImageInitBaseFolder{2} = '.\data\resources\MSRA1K 6 images\init resources\circle_staircase_kmeans100';
% folderpath_EachImageInitBaseFolder{3} = '.\data\resources\MSRA1K 6 images\init resources\kmeans100';
% folderpath_EachImageInitBaseFolder{4} = '.\data\resources\MSRA1K 6 images\init resources\circle_SDF_ACMGMM';

Args.folderpath_ResultsBaseFolder = '.\data\test segmentations' ;

Args.markType='contour';




%% %%%%%%%%%%%%%%% ʵ���� %%%%%%%%%%%%%%%%%%%%%%%%

%% ʹ�� LIF ����
Args.evolutionMethod = 'LIF';

%% LIF ��������
% ������1
Args.timestep = 10.0;	% time step . default=0.005.
Args.epsilon =1.0 ;		% papramater that specifies the width of the Heaviside function. default = 1.
Args.beta = 65;		% coefficeient of the weighted length term L(phi). default=0.5 ��or also 0.001*255*255
Args.sigma = 3.0 ;     % scale parameter in Gaussian kernel , default is 3.0 . ��˹�˺���ϵ����Խ�󣬶Գ�ֵ������Խ³�������ָ�Խ����ȷ��
Args.hsize =15 ;			% ��˹�˲�����ģ���С��default=15, also means 15 x 15.
Args.sigma_phi = 0.5 ; % the variance of regularized Gaussian kernel, default > sqrt(timestep). 0.45 - 1.00 .
Args.hsize_phi = 5.0 ; % ��˹�˲�����ģ���С��default=5.
% ���²���Ҫ��
Args.heavisideFunctionType = '2'; % heaviside����������
Args.initializeType = 'SDF' ;
% 'user' ��ʾ���Զ����������ɽ�Ծ����
% 'SDF' ��ʾ�þ�����뺯��

Args.contoursInitValue = 1;    % the value used for initialization contours.

% ���²��ܸ�
Args.isNeedInitializingContourByLSMethod = 'yes';  % �Ƿ���Ҫ��ˮƽ��������ʼ��������'yes'��ʾ��Ҫ��'no'��ʾ����Ҫ��

%% %%%%%%%%%%%%% ʵ���� %%%%%%%%%%%%%%%%%%%%%%%%

%% LIF ���Է���ר�� %%%%%%%%%%%%%%%%%%%%%%%%%%%
i=0;
for initMethod=folderpath_EachImageInitBaseFolder
    i=i+1;
    if isempty(initMethod{1})
        i=i+1;
        continue;
    end
    Args.folderpath_EachImageInitBaseFolder=initMethod{1};
    Args.foldername_experiment =['LIF' '_' datestr(now,'ddHHMMSS')];
    Args = setSegmentationMethod(Args, Args.evolutionMethod);
    segmentation_func(Args);
end

%% LIF �� ��ͬ�����µ�����������1 %%%%%%%%%%%%%%
% i=0;
% for initMethod=folderpath_EachImageInitBaseFolder
%     i=i+1;
%     if isempty(initMethod{1})
%         i=i+1;
%         continue;
%     end
%     Args.folderpath_EachImageInitBaseFolder=initMethod{1};
%     for timestep=[0.00500 0.05000 0.50000]
%         j=j+1;
%         Args.timestep=timestep;
%         for epsilon=[0.1 0.5 2.5]
%             Args.epsilon=epsilon;
%             for beta=[0.5 2.5 65]
%                 Args.beta=beta;
%                 for sigma=[0.3 1 3 10]
%                     Args.sigma=sigma;
%                     for hsize=[5 15]
%                         Args.hsize=hsize;
%                         for sigma_phi=[0.3 1.0 3.0]
%                             Args.sigma_phi=sigma_phi;
%                             for hsize_phi=[5 15]
%                                 Args.hsize_phi=hsize_phi;
%                                 Args.foldername_experiment =[...
%                                     'LIF' ...
%                                     '_time' num2str(Args.timestep) ...
%                                     '_epsilon' num2str(Args.epsilon) ...
%                                     '_beta' num2str(Args.beta) ...
%                                     '_sigma' num2str(Args.sigma) ...
%                                     '_hsize' num2str(Args.hsize) ...
%                                     '_sigmaPhi' num2str(Args.sigma_phi) ...
%                                     '_hsizePhi' num2str(Args.hsize_phi) ...
%                                     ] ;
%                                 Args = setSegmentationMethod(Args, Args.evolutionMethod);
%                                 segmentation_func(Args);
%                             end
%                         end
%                     end
%                 end
%             end
%         end
%     end
% end


%% LIF �� ��ͬ�����µ�����������2 %%%%%%%%%%%%%%
% i=0;
% for initMethod=folderpath_EachImageInitBaseFolder
%     i=i+1;
%     if isempty(initMethod{1})
%         i=i+1;
%         continue;
%     end
%     Args.folderpath_EachImageInitBaseFolder=initMethod{1};
%     for timestep=[0.100 0.050 0.005 0.500]
%         j=j+1;
%         Args.timestep=timestep;
%         for epsilon=[65 0.5 0.1 2.5]
%             Args.epsilon=epsilon;
%             Args.foldername_experiment =[...
%                 'LIF' ...
%                 '_time' num2str(Args.timestep) ...
%                 '_epsilon' num2str(Args.epsilon) ...
%                 ] ;
%             Args = setSegmentationMethod(Args, Args.evolutionMethod);
%             segmentation_func(Args);
%         end
%     end
% end





%% end
% text=['����ȫ��������ϡ�'];
% sp.Speak(text);















