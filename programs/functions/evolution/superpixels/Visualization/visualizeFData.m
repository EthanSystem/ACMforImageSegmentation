function [ f_data_Markup, f_data_history, Pros ] = visualizeFData( f_data, f_data_history, f_data01_pixels, f_data02, SuperPixels , Pros )
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
switch Pros.forceType
    case 'SP'
        f_data=f_data01_pixels;
    case 'DEF'
        f_data=f_data02;
    case 'SP DEF'
        f_data=f_data01_pixels + f_data02 ;
end


%% visual data
        f_data_Markup = SP2pixels(f_data, SuperPixels, Pros);
%         f_data_history(properties.iteration,:) = f_data;
        %% Visualization
        if strcmp(Pros.isVisual_f_data ,'yes')==1
            if Pros.iteration_outer==1
                Pros.handles_figure_f_data = figure('name','f_data show');
                % create folders for save screen shot
                Pros.folderpath_visualize_fData=([Pros.folderpath_screenShot,'\','f data']);
                sentence015=(['mkdir(''',Pros.folderpath_visualize_fData,''');']);
                eval(sentence015);
                
            end
            
            if mod(Pros.iteration_outer , Pros.periodOfVisual)==0
                figure(Pros.handles_figure_f_data);
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
                
                title(['f\_data show at iteration\_outer ',num2str(Pros.iteration_outer)]);
                hold off;
                
                %         % ���Ƴ���������С��ʱ��仯������ͼ����ʱ���ã���Ϊ��bug
                %         subplot(2,1,2);
                %         hold on ;
                %         for i=1:1:properties.numSP
                %             plot(1:1:properties.iteration_outer , f_data_history(1:1:properties.iteration_outer ,i));
                %             set(gca,'Color',[0.8 0.8 0.8]);
                %             set(gca,'YLim',[-1 1]);
                %         end
                %         hold off;
                %     end
                %
                
                %% save screen shot
                folderpath020=([Pros.folderpath_visualize_fData,'\',Pros.filename_originalImage(1:end-4),'_iter',num2str(Pros.iteration_outer)]);
                saveas(gcf,folderpath020,'jpg');
                
            end
        end

end

