function [ probabilityMarkup, Pros] = ...
    visualizeProbability( SuperPixels, foregroundProbability, backgroundProbability, Pros)
% visualizeLabelledSP ʹ�ù�������Ϳɫÿ�������ص���������ʾ������ǰ�������ڱ����ĸ��ʵ����
...inputs:
    ...SuperPixels: 
    ...foregroundProbability: �����ص�ǰ���ĸ���
    ...backgroundProbability: �����صı����ĸ���
    ...arguments
    ...properties
...outputs:
    ...probabilityMarkup: probability �Ŀ��ӻ�����
    ...properties: ��ͼ�����ľ������������һ����ʾ��ʱ����
%


probabilityMarkup.foregroundProbability = SP2pixels(foregroundProbability, SuperPixels, Pros);
probabilityMarkup.backgroundProbability = SP2pixels(backgroundProbability, SuperPixels, Pros);


%% visualization
if strcmp(Pros.isVisualProbability ,'yes')==1
    if Pros.iteration_outer==1
        Pros.handle_figure_probability = figure('name','probability show');
        % create folders for save screen shot 
        Pros.folderpath_visualize_probability = ([Pros.folderpath_screenShot,'\','probability']);
        sentence015=(['mkdir(''',Pros.folderpath_visualize_probability,''');']);
        eval(sentence015);
    end
    
    if mod(Pros.iteration_outer , Pros.periodOfVisual)==0
        figure(Pros.handle_figure_probability);
        % ����ǰ���ĸ��ʷֲ�ͼ
        Pros.handle_axes_probability_foreground = subplot(2,1,1);
        imagesc(probabilityMarkup.foregroundProbability);
        hold(Pros.handle_axes_probability_foreground,'on');
        colormap(hot);
        Pros.handle_axes_probability_foreground.CLim=[0 1];
        Pros.handle_axes_probability_foreground.Color=[0.8 0.8 0.8];
        colorbar;
        axis equal;
        title(['foreground probability at iteration\_outer ',num2str(Pros.iteration_outer)]);
        % ���Ʊ����ĸ��ʷֲ�ͼ
        Pros.handle_axes_probability_background = subplot(2,1,2);
        imagesc(probabilityMarkup.backgroundProbability);
        hold(Pros.handle_axes_probability_background,'on');
        colormap(hot);
        Pros.handle_axes_probability_background.CLim=[0 1];
        Pros.handle_axes_probability_background.Color=[0.8 0.8 0.8];
        colorbar;
        axis equal;
        title(['background probability at iteration\_outer ',num2str(Pros.iteration_outer)]);
        
        hold(Pros.handle_axes_probability_foreground,'off');
        hold(Pros.handle_axes_probability_background,'off');
        
        %% save screen shot
        folderpath020=([Pros.folderpath_visualize_probability,'\',Pros.filename_originalImage(1:end-4),'_iter',num2str(Pros.iteration_outer)]);
        saveas(gcf,folderpath020,'jpg');
        
    end
end






end

