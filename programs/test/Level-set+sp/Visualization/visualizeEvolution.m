function [ properties] = visualizeEvolution( SuperPixels, image010, contours, f_data01, segments, arguments, properties )
%VISUALIZEEVOLUTION 显示轮廓在迭代中的演化情况
% inputs:
...SuperPixels:
...image010: 原始图像
...contours: 轮廓
...f_data: 超像素数据力
...segments: 分割轮廓
...arguments:
...properties: 

...outputs:
...properties:


%% visual data
f_data_Markup = SP2pixels(f_data01, SuperPixels, properties);

%% Visualization
if strcmp(arguments.isVisualEvolution,'yes')==1;
    if properties.iteration==1
        properties.handle_figure_evolution = figure('name','evolution show');
        properties.handle_axes_evolutionContours = subplot(2,1,1);
        properties.handle_axes_evolutionFData =  subplot(2,1,2);
        % create folders for save screen shot 
        properties.folderpath_visualize_evolution = ([properties.folderpath,'\','screen shot','\','evolution']);
        sentence015=(['mkdir(''',properties.folderpath_visualize_evolution,''');']);
        eval(sentence015);
    end
    
    if mod(properties.iteration,arguments.periodToVisual)==0
        figure(properties.handle_figure_evolution);
        
        %% draw the subplot 1
        subplot(properties.handle_axes_evolutionContours);
        evolutionMarkup=imagesc(image010);
        hold(properties.handle_axes_evolutionContours ,'on');
        set(gca,'Color',[0.8 0.8 0.8]);
        axis equal;
        
        title([num2str(properties.iteration), ' iterations']);
        
        % used for flash effection
        for j=1:1:3
            [~,~] = contour(contours,[0 0],'y');
            pause(0.1);
            [~,~] = contour(contours,[0 0],'m');
            pause(0.2);
            [~,~] = contour(contours,[0 0],'y');
            pause(0.1);
        end
        hold(properties.handle_axes_evolutionContours ,'off');
        
        %% draw the subplot 2
        subplot(properties.handle_axes_evolutionFData);
        imagesc(f_data_Markup);
        hold(properties.handle_axes_evolutionFData,'on');
        colormap(jet);
        set(gca,'CLim',[-1 1]);
        set(gca,'Color',[0.8 0.8 0.8]);
        colorbar;
        axis equal;
        % 附上超像素边线
        [ segMarkup ] = addBorder( f_data_Markup, segments.value, [0.5 0.5 0.5] );
        [ segMarkup ] = addBorder( f_data_Markup, segments.value, [0.5 0.5 0.5] );
        imagesc(segMarkup);
        % 附上轮廓边线
%         caxis([0 0])
        for j=1:1:3
            [~,~] = contour(contours,[0 0],'y');
            pause(0.1);
            [~,~] = contour(contours,[0 0],'m');
            pause(0.2);
            [~,~] = contour(contours,[0 0],'y');
            pause(0.1);
        end
        
        title([num2str(properties.iteration), ' iterations']);
        hold(properties.handle_axes_evolutionFData,'off');
        
        %% save screen shot 
        folderpath020=([properties.folderpath_visualize_evolution,'\','iteration ',num2str(properties.iteration)]);
        saveas(gcf,folderpath020,'jpg');
        
    end
end


end

