function [ SuperPixelsDistance ] = computeSPDistance( SuperPixels , Pros )
%COMPUTESPDISTANCE 此处显示有关此函数的摘要
% 计算基于欧式的距离的公式
%% 方法1
for i=1:1:Pros.numSP
    for j=1:1:Pros.numSP
        SuperPixelsDistance(i,j) = norm(...
            sum(SuperPixels(i).histogram_channel1 - SuperPixels(j).histogram_channel1) ...
            + sum(SuperPixels(i).histogram_channel2 - SuperPixels(j).histogram_channel2) ...
            + sum(SuperPixels(i).histogram_channel3 - SuperPixels(j).histogram_channel3) ...
            );
    end
end


%% 方法2
% for i=1:1:properties.numSP
%     for j=1:1:properties.numSP
%         SuperPixelsDistance(i,j) = distanceMetric(SuperPixels(i).histogram_channel1,SuperPixels(j).histogram_channel1);
%     end
% end

%% Visualization
if strcmp(Pros.isVisualSPDistanceMat ,'yes')==1
    if Pros.iteration_outer==1
        Pros.handle_figure_SPDistanceMat = figure('name','所有的超像素的相互距离矩阵');
        colormap('jet');
        imagesc(SuperPixelsDistance);
        title('所有的超像素的相互距离矩阵');
%         title(['iteration ',num2str(properties.iteration)]);
        colorbar;

    end
%     暂时不用，如果以后考虑超像素形状随着时间可变的情况下再说
%     if mod(properties.iteration ,arguments.periodToVisual)==0
%         figure(properties.handle_figure_SPDistanceMat);
%         imagesc(SuperPixelsDistance);
%         colorbar;
%         title(['iteration ',num2str(properties.iteration)]);
%     end

end
end

