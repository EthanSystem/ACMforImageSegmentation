function [ initialContour ] = initialContour( image010_contour ,arguments, properties)
%INITIALCONTOUR 此处显示有关此函数的摘要
%   此处显示详细说明

% try
    switch arguments.contourType
        case 'BOX'
            %% 轮廓一：方形轮廓
            initialContour=arguments.contourIn0*ones(properties.sizeOfImg(1),properties.sizeOfImg(2));
            initialContour(arguments.boxWidth+1:end-arguments.boxWidth, arguments.boxWidth+1:end-arguments.boxWidth)=0;  % zero level set is on the boundary of R.
            initialContour(arguments.boxWidth+2:end-arguments.boxWidth-1, arguments.boxWidth+2: end-arguments.boxWidth-1)=-arguments.contourIn0; % negative constant -c0 inside of R, postive constant c0 outside of R.
            
        case 'USER'
            %% 轮廓二：自定义轮廓
            initialContour=arguments.contourIn0*ones(properties.sizeOfImg(1),properties.sizeOfImg(2));
            initialContour(image010_contour<128)=-arguments.contourIn0;
            
    end
% catch
%     disp('contour type is wrong');
% end

end

