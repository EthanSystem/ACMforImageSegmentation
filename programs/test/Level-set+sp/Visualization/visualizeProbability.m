function [ probabilityMarkup, properties] = ...
    visualizeProbability( SuperPixels, foregroundProbability, backgroundProbability, arguments, properties)
% visualizeLabelledSP 使用光谱序列涂色每个超像素的区域以显示其属于前景和属于背景的概率的情况
...inputs:
    ...SuperPixels: 
    ...foregroundProbability: 超像素的前景的概率
    ...backgroundProbability: 超像素的背景的概率
    ...arguments
    ...properties
...outputs:
    ...probabilityMarkup: probability 的可视化数据
    ...properties: 把图像对象的句柄保存起来下一次显示的时候用
%


probabilityMarkup.foregroundProbability = SP2pixels(foregroundProbability, SuperPixels, properties);
probabilityMarkup.backgroundProbability = SP2pixels(backgroundProbability, SuperPixels, properties);


%% visualization
if strcmp(arguments.isVisualProbability ,'yes')==1
    if properties.iteration==1
        properties.handle_figure_probability = figure('name','probability show');
        % create folders for save screen shot 
        properties.folderpath_visualize_probability = ([properties.folderpath,'\','screen shot','\','probability']);
        sentence015=(['mkdir(''',properties.folderpath_visualize_probability,''');']);
        eval(sentence015);
    end
    
    if mod(properties.iteration , arguments.periodToVisual)==0
        figure(properties.handle_figure_probability);
        % 绘制前景的概率分布图
        properties.handle_axes_probability_foreground = subplot(2,1,1);
        imagesc(probabilityMarkup.foregroundProbability);
        hold(properties.handle_axes_probability_foreground,'on');
        colormap(hot);
        properties.handle_axes_probability_foreground.CLim=[0 1];
        properties.handle_axes_probability_foreground.Color=[0.8 0.8 0.8];
        colorbar;
        axis equal;
        title(['foreground probability at iteration ',num2str(properties.iteration)]);
        % 绘制背景的概率分布图
        properties.handle_axes_probability_background = subplot(2,1,2);
        imagesc(probabilityMarkup.backgroundProbability);
        hold(properties.handle_axes_probability_background,'on');
        colormap(hot);
        properties.handle_axes_probability_background.CLim=[0 1];
        properties.handle_axes_probability_background.Color=[0.8 0.8 0.8];
        colorbar;
        axis equal;
        title(['background probability at iteration ',num2str(properties.iteration)]);
        
        hold(properties.handle_axes_probability_foreground,'off');
        hold(properties.handle_axes_probability_background,'off');
        
        %% save screen shot
        folderpath020=([properties.folderpath_visualize_probability,'\','iteration ',num2str(properties.iteration)]);
        saveas(gcf,folderpath020,'jpg');
        
    end
end






end

