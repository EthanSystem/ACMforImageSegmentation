function [ initialContour ] = initialContour( image010_contour ,Pros)
%INITIALCONTOUR 此处显示有关此函数的摘要
%   此处显示详细说明

% try
    switch Pros.contourType
        case 'BOX'
            %% 轮廓一：方形轮廓
            initialContour=Pros.contoursInitValue*ones(Pros.sizeOfImg(1),Pros.sizeOfImg(2));
            initialContour(Pros.boxWidth+1:end-Pros.boxWidth, Pros.boxWidth+1:end-Pros.boxWidth)=0;  % zero level set is on the boundary of R.
            initialContour(Pros.boxWidth+2:end-Pros.boxWidth-1, Pros.boxWidth+2: end-Pros.boxWidth-1)=-Pros.contoursInitValue; % negative constant -c0 inside of R, postive constant c0 outside of R.
            
        case 'USER'
            %% 轮廓二：自定义轮廓
            initialContour=Pros.contoursInitValue*ones(Pros.sizeOfImg(1),Pros.sizeOfImg(2));
            initialContour(image010_contour<128)=-Pros.contoursInitValue;
            
    end
% catch
%     disp('contour type is wrong');
% end

end

