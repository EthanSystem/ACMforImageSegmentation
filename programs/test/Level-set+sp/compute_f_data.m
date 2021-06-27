function [ f_data_pixels ,f_data, SuperPixels, S_sp_c, probability, properties] = ...
    compute_f_data( SuperPixels, SuperPixelsDistance, labels, arguments, properties)
% CREATE_F_DATA ��������д�� F_data
...input:�����ء������صľ��롢���Ϊǰ���򱳾��ı�ǩ��arguments��properties
...output:
...f_data_pixels: ��Ӧ����ÿ�������ص��F_data
...f_data: �����ص�F_data
...SuperPixels: ������
...S_sp_c: 
...probability: ÿ�������ط���Ϊǰ���򱳾��ĸ���
...properties: 

%% achieve the k - nn cluster
% ���ǽ���������֮��ĳ����ص�ŷ�Ͼ�����Ϊk���ڵ����ݵ㣬��������N�������ؾͻ���C_N^2����������ݵ�
% ��D(.) Ϊmetric ����KNNʵ�֣����ĳ��������sp��k����Ԫ��
% achieve the equation (9) and (10) in this paper .
SuperPixels=k_nn_cluster( SuperPixels, SuperPixelsDistance, labels, arguments.numNearestNeighbors,properties);



%% ��KDE������Ȼֵ
% achieve the equation (9) and (10) in this paper .
probability.foreground=zeros(1,properties.numSP);
probability.background=zeros(1,properties.numSP);
for i=1:1:properties.numSP
    probability.foreground(i)=1/arguments.numNearestNeighbors .* sum(exp(-(SuperPixels(i).nearestNeighbors.foreground.data.^2/(2*arguments.Sigma1^2))));
    probability.background(i)=1/arguments.numNearestNeighbors .* sum(exp(-(SuperPixels(i).nearestNeighbors.background.data.^2/(2*arguments.Sigma1^2))));
end


%% ʵ���б�׼�� S_sp_c
% achieve the equation (7) in this paper .
S_sp_c=zeros(1,properties.numSP);
for i=1:1:properties.numSP
    S_sp_c(i)=(1-probability.background(i)./probability.foreground(i))./(1+probability.background(i)./probability.foreground(i));
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
for i=1:1:properties.numSP
    if ( S_sp_c(i)>=0 && labels.foregroundIndicative(i)==1 )
        f_data(i)=S_sp_c(i)*0.1;
    elseif ( S_sp_c(i)>=0 && labels.backgroundIndicative(i)==1 )
        f_data(i)=S_sp_c(i);
    elseif ( S_sp_c(i)<0 && labels.foregroundIndicative(i)==1 )
        f_data(i)=S_sp_c(i);
    elseif ( S_sp_c(i)<0 && labels.backgroundIndicative(i)==1 )
        f_data(i)=S_sp_c(i)*0.1;
    end
    
end

%% assign each force which at each superpixels to each pixels correspondingly .
f_data_pixels=zeros(properties.sizeOfImg(1),properties.sizeOfImg(2));
for i=1:1:properties.numSP
    for j=1:1:length(SuperPixels(i).pos)
        f_data_pixels(SuperPixels(i).pos(j,1),SuperPixels(i).pos(j,2))=f_data(i);
    end
end

%%




end

