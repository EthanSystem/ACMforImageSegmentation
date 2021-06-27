function [ f_data_pixels ,f_data, SuperPixels, S_sp_c, probability_foreground, probability_background, Pros] = ...
    compute_f_data( SuperPixels, SuperPixelsDistance, indicatorOfClass, phi, Pros)
% CREATE_F_DATA ��������д�� F_data
...input:
    ......SuperPixels: ������
    ......SuperPixelsDistance: �����صľ���
    ......indicatorOfClass: ���Ϊǰ���򱳾��ı�ǩʾ������
    ......Pros: ���Լ���
    ...output:
    ......f_data_pixels: ��Ӧ����ÿ�������ص��F_data
    ......f_data: �����ص�F_data
    ......SuperPixels: ������
    ......S_sp_c: �б�׼��
    ......probability: ÿ�������ط���Ϊǰ���򱳾��ĸ���
    ......Pros:  ���Լ���
    
%% achieve the k - nn cluster
% ���ǽ���������֮��ĳ����ص�ŷ�Ͼ�����Ϊk���ڵ����ݵ㣬��������N�������ؾͻ���C_N^2����������ݵ�
% ��D(.) Ϊmetric ����KNNʵ�֣����ĳ��������sp��k����Ԫ��
% achieve the equation (9) and (10) in this paper .
SuperPixels=k_nn_cluster( SuperPixels, SuperPixelsDistance, indicatorOfClass, Pros.numNearestNeighbors,Pros);

%% ��KDE������Ȼֵ
% achieve the equation (9) and (10) in this paper .
probability_foreground=zeros(1,Pros.numSP);
probability_background=zeros(1,Pros.numSP);

for i=1:1:Pros.numSP
    probability_foreground(i)=1/Pros.numNearestNeighbors .* sum(exp(-((SuperPixels(i).nearestNeighbors.foreground.data.^2)/(2*Pros.Sigma1^2))));
    probability_background(i)=1/Pros.numNearestNeighbors .* sum(exp(-((SuperPixels(i).nearestNeighbors.background.data.^2)/(2*Pros.Sigma1^2))));
end


%% ʵ���б�׼�� S_sp_c
% achieve the equation (7) in this paper .
S_sp_c=zeros(1,Pros.numSP);
for i=1:1:Pros.numSP
    S_sp_c(i)=(probability_foreground(i)-probability_background(i))./(probability_foreground(i)+probability_background(i));
end


%% ���� f_data
% ������ǰ��б�׼����Ϊ�ⲿ���������
% If Sp>0��Ӧ������ǰ���� & ʵ�ʵı�ǩIndicative��ǰ��
% Then F_data = ����ĺ�С��ֵ����ֵӦ����������
% If Sp>0��Ӧ������ǰ���� & ʵ�ʵı�ǩIndicative�ʱ���
% Then F_data = ����Ĵ��ֵ����ֵӦ����������
% If Sp<0 ��Ӧ�����ڱ�����& ʵ�ʵı�ǩIndicative��ǰ��
% Then F_data = ���ڵĴ��ֵ����ֵӦ���Ǹ�����
% If Sp<0 ��Ӧ�����ڱ�����& ʵ�ʵı�ǩIndicative�ʱ���
% Then F_data = ���ڵĺ�С��ֵ����ֵӦ���Ǹ�����
f_data=zeros(1,length(S_sp_c));
for i=1:1:Pros.numSP
    if ( S_sp_c(i)>=0 && indicatorOfClass.foregroundIndicative(i)==1 )
        f_data(i) = 0;
    elseif ( S_sp_c(i)>=0 && indicatorOfClass.backgroundIndicative(i)==1 )
        f_data(i) = -S_sp_c(i);
    elseif ( S_sp_c(i)<0 && indicatorOfClass.foregroundIndicative(i)==1 )
        f_data(i) = -S_sp_c(i);
    elseif ( S_sp_c(i)<0 && indicatorOfClass.backgroundIndicative(i)==1 )
        f_data(i) = 0;
    end
end

% %% ���� f_data
% % ������ǰ��б�׼����Ϊ�ⲿ���������
% % If Sp>0��Ӧ������ǰ���� & ʵ�ʵı�ǩIndicative��ǰ��
% % Then F_data = ����ĺ�С��ֵ����ֵӦ����������
% % If Sp>0��Ӧ������ǰ���� & ʵ�ʵı�ǩIndicative�ʱ���
% % Then F_data = ����Ĵ��ֵ����ֵӦ����������
% % If Sp<0 ��Ӧ�����ڱ�����& ʵ�ʵı�ǩIndicative��ǰ��
% % Then F_data = ���ڵĴ��ֵ����ֵӦ���Ǹ�����
% % If Sp<0 ��Ӧ�����ڱ�����& ʵ�ʵı�ǩIndicative�ʱ���
% % Then F_data = ���ڵĺ�С��ֵ����ֵӦ���Ǹ�����
% f_data=zeros(1,length(S_sp_c));
% for i=1:1:Pros.numSP
%     if ( S_sp_c(i)>=0 & phi>=0 )
%         f_data(i)=0*0.1;
%     elseif ( S_sp_c(i)>=0 & phi<0)
%         f_data(i)=phi.*0.8.*S_sp_c(i);
%     elseif ( S_sp_c(i)<0 & phi>=0)
%         f_data(i)=phi.*0.8.*S_sp_c(i);
%     elseif ( S_sp_c(i)<0 & phi<0 )
%         f_data(i)=0*0.1;
%     end
% end


%% assign each force which at each superpixels to each pixels correspondingly .
f_data_pixels=zeros(Pros.sizeOfImage(1),Pros.sizeOfImage(2));
for i=1:1:Pros.numSP
    for j=1:1:length(SuperPixels(i).pos)
        f_data_pixels(SuperPixels(i).pos(j,1),SuperPixels(i).pos(j,2))=f_data(i);
    end
end

%%




end

