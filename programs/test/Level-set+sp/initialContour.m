function [ initialContour ] = initialContour( image010_contour ,arguments, properties)
%INITIALCONTOUR �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��

% try
    switch arguments.contourType
        case 'BOX'
            %% ����һ����������
            initialContour=arguments.contourIn0*ones(properties.sizeOfImg(1),properties.sizeOfImg(2));
            initialContour(arguments.boxWidth+1:end-arguments.boxWidth, arguments.boxWidth+1:end-arguments.boxWidth)=0;  % zero level set is on the boundary of R.
            initialContour(arguments.boxWidth+2:end-arguments.boxWidth-1, arguments.boxWidth+2: end-arguments.boxWidth-1)=-arguments.contourIn0; % negative constant -c0 inside of R, postive constant c0 outside of R.
            
        case 'USER'
            %% ���������Զ�������
            initialContour=arguments.contourIn0*ones(properties.sizeOfImg(1),properties.sizeOfImg(2));
            initialContour(image010_contour<128)=-arguments.contourIn0;
            
    end
% catch
%     disp('contour type is wrong');
% end

end

