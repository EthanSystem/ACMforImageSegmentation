function [ labels ] = LabelingSP( SuperPixels , contours , Pros)
% LABELINGSP ����contours��ֵ�����߸����û������ǰ�����߱����ı�ǣ���ÿ������������ǰ�����߱����ĵı��
...inputs:
...SuperPixels: 
...contours: ������
...arguments
...properties
...outputs:
...outputs:
...labels: ǰ���򱳾��ı��



pixelsLabeling=contours;
pixelsLabeling(pixelsLabeling<=0)=0;  % contours С����ı��Ϊ����0
pixelsLabeling(pixelsLabeling>0)=1; % % contours ������ı��Ϊǰ��1

labels.foregroundIndicative=zeros(1,Pros.numSP);
labels.backgroundIndicative=zeros(1,Pros.numSP);
labels.foreground=[];
labels.background=[];


% �ж���Щ�����ع���ǰ���򱳾�
for i=1:1:Pros.numSP
    numPixelsInSP=length(SuperPixels(i).pos);
    
    % ͳ��ÿ���������У����ص�����ǰ���ͱ����ĸ���
    count_foreground=0;
    count_background=0;
    for j=1:1:numPixelsInSP
        if (pixelsLabeling(SuperPixels(i).pos(j,1),SuperPixels(i).pos(j,2))==0)
            count_foreground=count_foreground+1;
        elseif (pixelsLabeling(SuperPixels(i).pos(j,1),SuperPixels(i).pos(j,2))==1)
            count_background=count_background+1;
        end
        
    end
    
    
    if count_foreground==numPixelsInSP
        labels.foregroundIndicative(i)=1;
        labels.foreground=[labels.foreground i];
    elseif count_background==numPixelsInSP
        labels.backgroundIndicative(i)=1;
        labels.background=[labels.background i];
    else % �����������������ʱ��ǰ��������������������ػ�Ϊǰ��������Ϊ����
        if count_foreground>=count_background
            labels.foregroundIndicative(i)=1;
            labels.foreground=[labels.foreground i];
        end
    end
    
end

labels.foregroundCount=sum(labels.foregroundIndicative);
labels.backgroundCount=sum(labels.backgroundIndicative);



end

