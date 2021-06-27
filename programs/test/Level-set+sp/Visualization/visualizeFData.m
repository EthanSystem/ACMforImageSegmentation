function [ f_data_Markup, f_data_history, properties ] = visualizeFData( f_data, f_data_history, f_data01_pixels, f_data02, SuperPixels , arguments, properties )
%VISUALIZEFDATA ���ӻ� F_data
...inputs:
    ...f_data:
    ...f_data_history: �������Ƴ���������ʱ��仯������ͼ����ʱ����
    ...SuperPixels:
    ...arguments:
    ...properties:
    ...outputs:
    ...f_data_Markup: �������������ӻ�����
    ...f_data_history:
    ...properties: ��ͼ�����ľ������������һ����RGBʾ��ʱ����
    
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
                % ������ͼ���зֲ��ĳ����صĴ�С��ʱ��仯�Ĺ���ͼ
                %         subplot(2,1,1);
                
                imagesc(f_data_Markup);
                hold on;
                colormap(hot);
                set(gca,'CLim',[-1 1]);
                set(gca,'Color',[0.8 0.8 0.8]);
                colorbar;
                axis equal;
                %         plot(segments.segOutline);  % ���ϱ���
                
                title(['f\_data show at iteration ',num2str(properties.iteration)]);
                hold off;
                
                %         % ���Ƴ���������С��ʱ��仯������ͼ����ʱ���ã���Ϊ��bug
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

