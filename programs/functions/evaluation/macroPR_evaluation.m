function [ macroPrecision, macroRecall, macroF1 ] = macroPR_evaluation( Precision, Recall, F1 )
%MACROPR_EVALUATION 计算modified hausdorff distance指标。
%   input:
% Precision：查准率。一张图像数据
% Recall：查全率。一张图像数据
% F1：F1指标。一张图像数据
% output:
% macroPrecision：宏查准率。数值0~1
% macroRecall：宏查全率。数值0~1
% macroF1：宏F1指标。数值0~1
macroPrecision = mean(Precision,1);
macroRecall = mean(Recall,1);
macroF1 = mean(F1,1);

end

