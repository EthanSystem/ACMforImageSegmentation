function [ SuperPixelsDistance ] = computeSPDistance( SuperPixels , Pros )
%COMPUTESPDISTANCE �˴���ʾ�йش˺�����ժҪ
% �������ŷʽ�ľ���Ĺ�ʽ
%% ����1
for i=1:1:Pros.numSP
    for j=1:1:Pros.numSP
        SuperPixelsDistance(i,j) = norm(...
            sum(SuperPixels(i).histogram_channel1 - SuperPixels(j).histogram_channel1) ...
            + sum(SuperPixels(i).histogram_channel2 - SuperPixels(j).histogram_channel2) ...
            + sum(SuperPixels(i).histogram_channel3 - SuperPixels(j).histogram_channel3) ...
            );
    end
end


%% ����2
% for i=1:1:properties.numSP
%     for j=1:1:properties.numSP
%         SuperPixelsDistance(i,j) = distanceMetric(SuperPixels(i).histogram_channel1,SuperPixels(j).histogram_channel1);
%     end
% end

%% Visualization
if strcmp(Pros.isVisualSPDistanceMat ,'yes')==1
    if Pros.iteration_outer==1
        Pros.handle_figure_SPDistanceMat = figure('name','���еĳ����ص��໥�������');
        colormap('jet');
        imagesc(SuperPixelsDistance);
        title('���еĳ����ص��໥�������');
%         title(['iteration ',num2str(properties.iteration)]);
        colorbar;

    end
%     ��ʱ���ã�����Ժ��ǳ�������״����ʱ��ɱ���������˵
%     if mod(properties.iteration ,arguments.periodToVisual)==0
%         figure(properties.handle_figure_SPDistanceMat);
%         imagesc(SuperPixelsDistance);
%         colorbar;
%         title(['iteration ',num2str(properties.iteration)]);
%     end

end
end

