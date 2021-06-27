%% 用于分割的主程序

% 对于 ACMGMM，在：
% evolution_ACMandGMMnew_pi2
% evolution_ACMandSemisupervised
% evolution_ACMandSemisupervised_Eacm
% 的方法的代码中，
% Image 取值 0~255
% 和
% Image 取值 0~1
% 比较，肉眼观察哪个分割效果好



%% 注意事项：
% 手动把文件夹“ACM+GMM”设为当前文件夹。手动将里面的文件夹“functions”、“projects”及其子文件添加入路径。


%% 预处理
clear all;
close all;
clc;
diary off;
sp=actxserver('SAPI.SpVoice');
addpath( genpath( '.\functions' ) ); %添加当前路径下的所有文件夹以及子文件夹
addpath( genpath( '.\projects' ) ); %添加当前路径下的所有文件夹以及子文件夹
addpath( genpath( '.\tools' ) ); %添加当前路径下的所有文件夹以及子文件夹

%% segmentation

% 初始全局设置项
initSegmentationArgsFirst;

% 额外的全局设置项
Args.folderpath_ResultsBaseFolder = '.\data\ACMGMMSEMI\MSRA1K\segmentations';



%% semi-supervised segmentation


folderpath_EachImageInitBaseFolder_1{4} = '.\data\ACMGMMSEMI\MSRA1K\init resources\scribbled_kmeans100_1'; % 不推荐
folderpath_EachImageInitBaseFolder_1{5} = '.\data\ACMGMMSEMI\MSRA1K\init resources\scribbled_circle_SDF_kmeans100_1'; % 不推荐
folderpath_EachImageInitBaseFolder_1{6} = '.\data\ACMGMMSEMI\MSRA1K\init resources\scribbled_circle_staircase_kmeans100_1'; % 不推荐
folderpath_EachImageInitBaseFolder_1{7} = '.\data\ACMGMMSEMI\MSRA1K\init resources\scribbled_kmeans100_2';
folderpath_EachImageInitBaseFolder_1{8} = '.\data\ACMGMMSEMI\MSRA1K\init resources\scribbled_circle_SDF_kmeans100_2';
folderpath_EachImageInitBaseFolder_1{9} = '.\data\ACMGMMSEMI\MSRA1K\init resources\scribbled_circle_staircase_kmeans100_2'; % 推荐

Args.markType='scribble';

% Args.timestep=10;  % time step, default = 0.10

%% ACMGMM_semisupervised  在不同停机条件下
Args.evolutionMethod='semiACMGMM';
for endloop=[0.001,0.0001]
    Args.proportionPixelsToEndLoop = endloop;
    for i=folderpath_EachImageInitBaseFolder_1
        if isempty(i{1})
            continue;
        end
        Args.folderpath_EachImageInitBaseFolder=i{1};
        Args.foldername_experiment =['ACMGMMsemi' '_el' num2str(Args.proportionPixelsToEndLoop) '_' datestr(now,'ddHHMMSS')];
        Args=initSegmentationMethod(Args, Args.evolutionMethod);
        Args = setSegmentationMethod(Args, Args.evolutionMethod);
        segmentation_func(Args);
    end
end


%% ACMGMM_semisupervised_Eacm 在不同停机条件下和 Eacm 的权重下
Args.evolutionMethod='semiACMGMM_Eacm';
for endloop=[0.001,0.0001]
    Args.proportionPixelsToEndLoop = endloop;
    for i=folderpath_EachImageInitBaseFolder_1
        if isempty(i{1})
            continue;
        end
        Args.folderpath_EachImageInitBaseFolder=i{1};
        for j=[1,10,100,1000]
            Args.weight_Eacm = j;
            Args.foldername_experiment =['ACMGMMsemiEacm' '_nu' num2str(Args.weight_Eacm) '_el' num2str(Args.proportionPixelsToEndLoop) '_' datestr(now,'ddHHMMSS')];
            Args=initSegmentationMethod(Args, Args.evolutionMethod);
%             Args.timestep=1;
            Args = setSegmentationMethod(Args, Args.evolutionMethod);
            segmentation_func(Args);
        end
    end
end




%% ACMGMM_semisupervised_Eacm 在不同 Eacm 的权重下
% Args.evolutionMethod='ACMGMM_semisupervised_Eacm';
% for i=folderpath_EachImageInitBaseFolder_1
%     if isempty(i{1})
%         continue;
%     end
%     Args.folderpath_EachImageInitBaseFolder=i{1};
%     for j=[1,10,100,1000]
%         Args.weight_Eacm = j;
%         Args.foldername_experiment =[Args.evolutionMethod '_weightEacm_' num2str(Args.weight_Eacm) '_' datestr(now,'ddHHMMSS')];
%         Args=initSegmentationMethod(Args, Args.evolutionMethod);
% %         Args.timestep=1;
%         Args = setSegmentationMethod(Args, Args.evolutionMethod);
%         segmentation_func(Args);
%     end
% end



%% ACM_semisupervised_HuangTan 在不同 Eacm 的权重下
% for i=folderpath_EachImageInitBaseFolder_1
%     if isempty(i{1})
%         continue;
%     end
%     Args.folderpath_EachImageInitBaseFolder=i{1};
%     Args.evolutionMethod='ACM_semisupervised_HuangTan';
%     for j=[1,10,50,200,500,2000,5000]
%         Args.weight_Eacm = j;
%         Args.foldername_experiment =[Args.evolutionMethod '_weightEacm_' num2str(Args.weight_Eacm) '_' datestr(now,'ddHHMMSS')];
%         Args=initSegmentationMethod(Args, Args.evolutionMethod);
%         Args.timestep=1;
%         Args = setSegmentationMethod(Args, Args.evolutionMethod);
%         segmentation_func(Args);
%     end
% end





%% unsupervised segmentation

% ACM and unsupervised

folderpath_EachImageInitBaseFolder_2{1} = '.\data\ACMGMMSEMI\MSRA1K\init resources\kmeans100';
folderpath_EachImageInitBaseFolder_2{2} = '.\data\ACMGMMSEMI\MSRA1K\init resources\circle_SDF_kmeans100'; % 不推荐
folderpath_EachImageInitBaseFolder_2{3} = '.\data\ACMGMMSEMI\MSRA1K\init resources\circle_staircase_kmeans100'; % 推荐


Args.markType='contour';


%% ACMGMM 在不同停机条件下
Args.evolutionMethod='ACMGMM';
for endloop=[0.001,0.0001]
    Args.proportionPixelsToEndLoop = endloop;
    for i=folderpath_EachImageInitBaseFolder_2
        if isempty(i{1})
            continue;
        end
        Args.folderpath_EachImageInitBaseFolder=i{1};
        Args.foldername_experiment =['ACMGMM' '_el' num2str(Args.proportionPixelsToEndLoop) '_' datestr(now,'ddHHMMSS')];
        Args=initSegmentationMethod(Args, Args.evolutionMethod);
        Args = setSegmentationMethod(Args, Args.evolutionMethod);
        segmentation_func(Args);
    end
end


%% LIF 在不同停机条件下
% for endloop=[0.001,0.0003,0.0001]
%     Args.proportionPixelsToEndLoop = endloop;
%     for i=folderpath_EachImageInitBaseFolder_2
%         if isempty(i{1})
%             continue;
%         end
%         Args.folderpath_EachImageInitBaseFolder=i{1};
%         Args.evolutionMethod='LIF';
%         Args.foldername_experiment =[Args.evolutionMethod '_EndLoop' num2str(Args.proportionPixelsToEndLoop) '_' datestr(now,'ddHHMMSS')];
%         Args=initSegmentationMethod(Args, Args.evolutionMethod);
%         Args = setSegmentationMethod(Args, Args.evolutionMethod);
%         segmentation_func(Args);
%     end
% end







%% end
text=['程序全部运行完毕。'];
sp.Speak(text);





