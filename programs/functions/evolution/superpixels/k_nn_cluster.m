function [SuperPixels] = k_nn_cluster( SuperPixels, SuperPixelsDistance, labels, numNearestNeighbors, Pros )
%K_NN_CLUSTER �˴���ʾ�йش˺�����ժҪ
% ��k���ڵļ�������ǰ���ͱ����ı�ǩ����ô���ֳ� ����ǰ����k���ںͼ��㱳����k���ڡ�
% ����ĳ�������ص�ǰ����k���ھ��ǶԱ��Ϊǰ�������ؼ����У�ѡȡ���������k��ǰ�������أ�
% ͬ��������k���ھ��ǶԱ��Ϊ���������ؼ����У�ѡȡ���������k�����������ء�

for i=1:1:Pros.numSP
    [d,idx]=sort(SuperPixelsDistance(i,:));
    d_foreground=d .* labels.foregroundIndicative;
    d_foreground(d_foreground==0)=[] ;
    idx_foreground=idx .* labels.foregroundIndicative;
    idx_foreground(idx_foreground==0)=[];
    d_background=d .* labels.backgroundIndicative;
    d_background(d_background==0)=[] ;
    idx_background=idx .* labels.backgroundIndicative;
    idx_background(idx_background==0)=[];
    try
        SuperPixels(i).nearestNeighbors.foreground.data=d_foreground(2:1:2+numNearestNeighbors-1);
        SuperPixels(i).nearestNeighbors.foreground.index=idx_foreground(2:1:2+numNearestNeighbors-1);
        SuperPixels(i).nearestNeighbors.background.data=d_background(2:1:2+numNearestNeighbors-1);
        SuperPixels(i).nearestNeighbors.background.index=idx_background(2:1:2+numNearestNeighbors-1);
    catch
        disp('error when computing SuperPixels(i).nearestNeighbors !');
    end
end


end

