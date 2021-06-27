function [ distance ] = distanceMetric( feature01,feature02,metricType )
%DISTANCEMETRIC 函数表示欧拉距离的距离度量方式：
%   公式是 
metricType='euclidean';

%  当测度类型是欧式距离时：
distance = (feature01 - feature02)*(feature01 -feature02)';


end

