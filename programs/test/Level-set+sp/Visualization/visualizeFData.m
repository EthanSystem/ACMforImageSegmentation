function [ f_data_Markup, f_data_history, properties ] = visualizeFData( f_data, f_data_history, f_data01_pixels, f_data02, SuperPixels , arguments, properties )
%VISUALIZEFDATA 可视化 F_data
...inputs:
    ...f_data:
    ...f_data_history: 用来绘制超像素力随时间变化的曲线图，暂时不用
    ...SuperPixels:
    ...arguments:
    ...properties:
    ...outputs:
    ...f_data_Markup: 超像素力出可视化数据
    ...f_data_history:
    ...properties: 把图像对象的句柄保存起来下一次显RGB示的时候用
    
%% switch f_data type
switch arguments.fType
    case 'SP'
        f_data=f_data01_pixels;
    case 'DEF'
        f_data=f_data02;
    case 'SP DEF'
        f_data=f_data01_pixels + f_data02 ;
end


%% visual data
        f_data_Markup = SP2pixels(f_data, SuperPixels, properties);
%         f_data_history(properties.iteration,:) = f_data;
        %% Visualization
        if strcmp(arguments.isVisual_f_data ,'yes')==1
            if properties.iteration==1
                properties.handles_figure_f_data = figure('name','f_data show');
                % create folders for save screen shot
                properties.folderpath_visualize_fData = ([properties.folderpath,'\','screen shot','\','f data']);
                sentence015=(['mkdir(''',properties.folderpath_visualize_fData,''');']);
                eval(sentence015);
                
            end
            
            if mod(properties.iteration , arguments.periodToVisual)==0
                figure(properties.handles_figure_f_data);
                % 绘制在图像中分布的超像素的大小随时间变化的光谱图
                %         subplot(2,1,1);
                
                imagesc(f_data_Markup);
                hold on;
                colormap(hot);
                set(gca,'CLim',[-1 1]);
                set(gca,'Color',[0.8 0.8 0.8]);
                colorbar;
                axis equal;
                %         plot(segments.segOutline);  % 附上边线
                
                title(['f\_data show at iteration ',num2str(properties.iteration)]);
                hold off;
                
                %         % 绘制超像素力大小随时间变化的曲线图，暂时不用，因为有bug
                %         subplot(2,1,2);
                %         hold on ;
                %         for i=1:1:properties.numSP
                %             plot(1:1:properties.iteration , f_data_history(1:1:properties.iteration ,i));
                %             set(gca,'Color',[0.8 0.8 0.8]);
                %             set(gca,'YLim',[-1 1]);
                %         end
                %         hold off;
                %     end
                %
                
                %% save screen shot
                folderpath020=([properties.folderpath_visualize_fData,'\','iteration ',num2str(properties.iteration)]);
                saveas(gcf,folderpath020,'jpg');
                
            end
        end

end

