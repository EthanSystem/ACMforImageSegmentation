function [labelled_markup, Pros]=visualizeLabelledSP( labels, SuperPixels,  Pros )
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
labelled_markup = SP2pixels(labels.foregroundIndicative, SuperPixels, Pros);

%% Visualization
if strcmp(Pros.isVisualLabels,'yes')==1
    if Pros.iteration_outer==1
        Pros.handle_figure_labels = figure('name','labels show');
        % create folders for save screen shot
        Pros.folderpath_visualize_labelledSP = ([Pros.folderpath_screenShot,'\','labelled SP']);
        sentence015=(['mkdir(''',Pros.folderpath_visualize_labelledSP,''');']);
        eval(sentence015);
    end
    
    if mod(Pros.iteration_outer , Pros.periodOfVisual)==0
        figure(Pros.handle_figure_labels);
        imagesc( labelled_markup);
        hold on;
        colormap(flipud(hot));
        handle_colorbar_labelingSP = colorbar;
        set(handle_colorbar_labelingSP,'Ticks',[0 1],'TickLabels',{'background' 'foreground'});
        set(gca,'Clim',[0 1]);
        set(gca,'Color',[0.8 0.8 0.8]);
        
        axis equal;
        
        %         imagesc(segments.segOutline);  % ���ϱ���
        title(['labeling at iteration ',num2str(Pros.iteration_outer)]);
        hold off;
        
        %% save screen shot
        folderpath020=([Pros.folderpath_visualize_labelledSP,'\',Pros.filename_originalImage(1:end-4),'_iter',num2str(Pros.iteration_outer)]);
        saveas(gcf,folderpath020,'jpg');
    end
    
end


end

