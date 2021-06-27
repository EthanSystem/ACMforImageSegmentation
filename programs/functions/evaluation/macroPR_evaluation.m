function [ macroPrecision, macroRecall, macroF1 ] = macroPR_evaluation( Precision, Recall, F1 )
%MACROPR_EVALUATION ����modified hausdorff distanceָ�ꡣ
%   input:
% Precision����׼�ʡ�һ��ͼ������
% Recall����ȫ�ʡ�һ��ͼ������
% F1��F1ָ�ꡣһ��ͼ������
% output:
% macroPrecision�����׼�ʡ���ֵ0~1
% macroRecall�����ȫ�ʡ���ֵ0~1
% macroF1����F1ָ�ꡣ��ֵ0~1
macroPrecision = mean(Precision,1);
macroRecall = mean(Recall,1);
macroF1 = mean(F1,1);

end

