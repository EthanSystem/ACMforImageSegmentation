function [ indicatorOfClass ] = LabelingSP( SuperPixels , phi , Pros)
% LABELINGSP ����contours��ֵ�����߸����û������ǰ�����߱����ı�ǣ���ÿ������������ǰ�����߱����ĵı��
...inputs:
...SuperPixels: 
...contours: ������
...arguments
...properties
...outputs:
...outputs:
...labels: ǰ���򱳾��ı��



pixelsLabeling=phi;
pixelsLabeling(pixelsLabeling>=0)=1;  % phi ������ı��Ϊǰ��=1
pixelsLabeling(pixelsLabeling<0)=0; % % phi С����ı��Ϊ����=0

indicatorOfClass.foregroundIndicative=zeros(1,Pros.numSP);
indicatorOfClass.backgroundIndicative=zeros(1,Pros.numSP);
indicatorOfClass.foreground=[];
indicatorOfClass.background=[];


% �ж���Щ�����ع���ǰ���򱳾�
for i=1:1:Pros.numSP
    numPixelsInSP=length(SuperPixels(i).pos);
    
    % ͳ��ÿ���������У����ص�����ǰ���ͱ����ĸ���
    count_foreground=0;
    count_background=0;
    for j=1:1:numPixelsInSP
        if (pixelsLabeling(SuperPixels(i).pos(j,1),SuperPixels(i).pos(j,2))==1)
            count_foreground=count_foreground+1;
        elseif (pixelsLabeling(SuperPixels(i).pos(j,1),SuperPixels(i).pos(j,2))==0)
            count_background=count_background+1;
        end
        
    end
    
    
    if count_foreground==numPixelsInSP
        indicatorOfClass.foregroundIndicative(i)=1;
        indicatorOfClass.foreground=[indicatorOfClass.foreground i];
    elseif count_background==numPixelsInSP
        indicatorOfClass.backgroundIndicative(i)=1;
        indicatorOfClass.background=[indicatorOfClass.background i];
    else % �����������������ʱ��ǰ��������������������ػ�Ϊǰ��������Ϊ����
        if count_foreground>=count_background
            indicatorOfClass.foregroundIndicative(i)=1;
            indicatorOfClass.foreground=[indicatorOfClass.foreground i];
        end
    end
    
end

indicatorOfClass.foregroundCount=sum(indicatorOfClass.foregroundIndicative);
indicatorOfClass.backgroundCount=sum(indicatorOfClass.backgroundIndicative);



end

