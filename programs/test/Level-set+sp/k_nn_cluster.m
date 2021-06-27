function [SuperPixels] = k_nn_cluster( SuperPixels, SuperPixelsDistance, labels, numNearestNeighbors, properties )
%K_NN_CLUSTER 
% 把k近邻的计算引入前景和背景的标签，区分出 计算前景的k近邻和计算背景的k近邻。
% 对于某个超像素，前景的k近邻就是对标记为前景超像素集合中，选取距离最近的k个前景超像素；
% 同理，背景的k近邻就是对标记为背景超像素集合中，选取距离最近的k个背景超像素。
% input:
% 
% output:


for i=1:1:properties.numSP
    [d,idx]=sort(SuperPixelsDistance(i,:));
    d_foreground=d .* labels.foregroundIndicative;
    d_foreground(d_foreground==0)=[] ;
    idx_foreground=idx .* labels.foregroundIndicative;
    idx_foreground(idx_foreground==0)=[];
    d_background=d .* labels.backgroundIndicative;
    d_background(d_background==0)=[] ;
    idx_background=idx .* labels.backgroundIndicative;
    idx_background(idx_background==0)=[];
%     try
        SuperPixels(i).nearestNeighbors.foreground.data=d_foreground(2:1:2+numNearestNeighbors-1);
        SuperPixels(i).nearestNeighbors.foreground.index=idx_foreground(2:1:2+numNearestNeighbors-1);
        SuperPixels(i).nearestNeighbors.background.data=d_background(2:1:2+numNearestNeighbors-1);
        SuperPixels(i).nearestNeighbors.background.index=idx_background(2:1:2+numNearestNeighbors-1);
%     catch
%         disp('error when computing SuperPixels(i).nearestNeighbors');
%     end
end


end

