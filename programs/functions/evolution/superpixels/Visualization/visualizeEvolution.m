function [ Pros] = visualizeEvolution( SuperPixels, image010, contours, f_data01, segmentsValue, Pros )
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
f_data_Markup = SP2pixels(f_data01, SuperPixels, Pros);

%% Visualization
if strcmp(Pros.isVisualEvolution,'yes')==1;
    if Pros.iteration_outer==1
        Pros.handle_figure_evolution = figure('name','evolution show');
        Pros.handle_axes_evolutionContours = subplot(2,1,1);
        Pros.handle_axes_evolutionFData =  subplot(2,1,2);
        % create folders for save screen shot 
        Pros.folderpath_visualize_evolution = ([Pros.folderpath_screenShot,'\','evolution']);
        sentence015=(['mkdir(''',Pros.folderpath_visualize_evolution,''');']);
        eval(sentence015);
    end
    
    if mod(Pros.iteration_outer,Pros.periodOfVisual)==0
        figure(Pros.handle_figure_evolution);
        
        %% draw the subplot 1
        subplot(Pros.handle_axes_evolutionContours);
        evolutionMarkup=imagesc(image010);
        hold(Pros.handle_axes_evolutionContours ,'on');
        set(gca,'Color',[0.8 0.8 0.8]);
        axis equal;
        
        title([num2str(Pros.iteration_outer), ' iteration\_outers']);
        
        % used for flash effection
        for j=1:1:3
            [~,~] = contour(contours,[0 0],'y');
            pause(0.1);
            [~,~] = contour(contours,[0 0],'m');
            pause(0.2);
            [~,~] = contour(contours,[0 0],'y');
            pause(0.1);
        end
        hold(Pros.handle_axes_evolutionContours ,'off');
        
        %% draw the subplot 2
        subplot(Pros.handle_axes_evolutionFData);
        imagesc(f_data_Markup);
        hold(Pros.handle_axes_evolutionFData,'on');
        colormap(jet);
        set(gca,'CLim',[-1 1]);
        set(gca,'Color',[0.8 0.8 0.8]);
        colorbar;
        axis equal;
        % 附上超像素边线
        [ segMarkup ] = addBorder( f_data_Markup, segmentsValue, [0.5 0.5 0.5] );
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
        
        title([num2str(Pros.iteration_outer), ' iteration\_outers']);
        hold(Pros.handle_axes_evolutionFData,'off');
        
        %% save screen shot 
        folderpath020=([Pros.folderpath_visualize_evolution,'\',Pros.filename_originalImage(1:end-4),'_iter',num2str(Pros.iteration_outer)]);
        saveas(gcf,folderpath020,'jpg');
        
    end
end


end

