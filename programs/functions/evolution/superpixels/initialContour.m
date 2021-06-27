function [ initialContour ] = initialContour( image010_contour ,Pros)
%INITIALCONTOUR �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

% try
    switch Pros.contourType
        case 'BOX'
            %% ����һ����������
            initialContour=Pros.contoursInitValue*ones(Pros.sizeOfImg(1),Pros.sizeOfImg(2));
            initialContour(Pros.boxWidth+1:end-Pros.boxWidth, Pros.boxWidth+1:end-Pros.boxWidth)=0;  % zero level set is on the boundary of R.
            initialContour(Pros.boxWidth+2:end-Pros.boxWidth-1, Pros.boxWidth+2: end-Pros.boxWidth-1)=-Pros.contoursInitValue; % negative constant -c0 inside of R, postive constant c0 outside of R.
            
        case 'USER'
            %% ���������Զ�������
            initialContour=Pros.contoursInitValue*ones(Pros.sizeOfImg(1),Pros.sizeOfImg(2));
            initialContour(image010_contour<128)=-Pros.contoursInitValue;
            
    end
% catch
%     disp('contour type is wrong');
% end

end

