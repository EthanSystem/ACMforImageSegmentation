function [labelled_markup, properties]=visualizeLabelledSP( labels, SuperPixels, arguments, properties )
%visualizeLabelledSP ���ӻ������ص�ǰ���򱳾��������
... inputs:
    ...labels: ǰ���򱳾��ı��
    ...SuperPixels:
    ...arguments
    ...properties
... outputs:
    ...labelled_markup: labels�Ŀ��ӻ�����
    ...properties: ��ͼ�����ľ������������һ����ʾ��ʱ����
%% visual data
labelled_markup = SP2pixels(labels.foregroundIndicative, SuperPixels, properties);

%% Visualization
if strcmp(arguments.isVisualLabels,'yes')==1;
    if properties.iteration==1
        properties.handle_figure_labels = figure('name','labels show');
        % create folders for save screen shot
        properties.folderpath_visualize_labelledSP = ([properties.folderpath,'\','screen shot','\','labelled SP']);
        sentence015=(['mkdir(''',properties.folderpath_visualize_labelledSP,''');']);
        eval(sentence015);
    end
    
    if mod(properties.iteration , arguments.periodToVisual)==0
        figure(properties.handle_figure_labels);
        imagesc( labelled_markup);
        hold on;
        colormap(flipud(hot));
        handle_colorbar_labelingSP = colorbar;
        set(handle_colorbar_labelingSP,'Ticks',[0 1],'TickLabels',{'background' 'foreground'});
        set(gca,'Clim',[0 1]);
        set(gca,'Color',[0.8 0.8 0.8]);
        
        axis equal;
        
        %         imagesc(segments.segOutline);  % ���ϱ���
        title(['labeling at iteration ',num2str(properties.iteration)]);
        hold off;
        
        %% save screen shot
        folderpath020=([properties.folderpath_visualize_labelledSP,'\','iteration ',num2str(properties.iteration)]);
        saveas(gcf,folderpath020,'jpg');

    end
    
end


end

