function [ distance ] = distanceMetric( feature01,feature02,metricType )
%DISTANCEMETRIC ������ʾŷ������ľ��������ʽ��
%   ��ʽ�� 
metricType='euclidean';

%  �����������ŷʽ����ʱ��
distance = (feature01 - feature02)*(feature01 -feature02)';


end

