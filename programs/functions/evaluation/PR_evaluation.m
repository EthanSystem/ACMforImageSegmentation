function [ Precision , Recall, F_beta,ME] = PR_evaluation( A, B, beta )
%PR_EVALUATION ����F1ָ�ꡣ
%   input:
% A����׼��ֵͼ��һ��ͼ�����ݡ�
% B�����ǵĶ�ֵͼ��һ��ͼ�����ݡ�
% output:
% Precision����׼�ʡ���ֵ0~1��
% Recall����ȫ�ʡ���ֵ0~1��
% F1��F1ָ�ꡣ0~1��
A=im2bw(A);
B=im2bw(B);

A=double(A);
B=double(B);
p=zeros(2,2);
p=double(p);
[B1,B2]=size(A);
Asize = size(A);
Bsize = size(B);
% Check if the points have the same dimensions
if Asize(2) ~= Bsize(2)
    error('The dimensions of points in the two sets are not equal');
end

% ������������������,
% ���У�p1==p(1,1)==TN		p3==p(1,2)==FP
%		p2==p(2,1)==FN  	p4==p(2,2)==TP
for x=1:B1
    for y=1:B2
        p(A(x,y)+1,B(x,y)+1)=p(A(x,y)+1,B(x,y)+1)+1;
    end
end

ME=1-(p(1)+p(4))/(B1*B2);	% �����ʣ�ԭ���
Ao=sum(A(:));	% ��ȫ�� R �ķ�ĸ TP+FN
At=sum(B(:));	% ��׼�� P �ķ�ĸ TP+FP

if beta==1
    F_beta=2.*p(2,2)./(sum(p(:))+p(2,2)-p(1,1));
else
    F_beta=0;
    if p(2,2)~=0
        F_beta=(1+beta^2).*Precision.*Recall./((beta^2)*Precision+Recall);
        %     disp(['����F1��ֵΪ��' num2str(F1)]);
    end
end

Precision=p(2,2)./At;
Recall=p(2,2)./Ao;

% if (Ao>At)
% 	RAE=(Ao-At)/Ao; % ���� RAE = (FN-FP)/(TP+FN)
% else
% 	RAE=(At-Ao)/At; % ���� RAE = (FP-FN)/(TP+FP)
% end

end

