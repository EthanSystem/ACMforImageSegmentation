function [ output_args ] = visualizeBwImageForPaper( Pros, EachImage, Results, isVisual)
%visualizeBwImageForPaper ���ӻ����ĵ�ͼ������
%   �˴���ʾ��ϸ˵��
if strcmp(isVisual,'yes')==1
	controlVis = 'on';
else
	controlVis = 'off';
end

%%
foldername_visNeedBwImgForPaper = 'visBwImgForPaper';
folderpath_visNeedBwImgForPaper = fullfile(Pros.folderpath_experiment,foldername_visNeedBwImgForPaper);
if ~exist(folderpath_visNeedBwImgForPaper,'dir')
	mkdir(folderpath_visNeedBwImgForPaper);
end

%% ����ʽ
num_image = EachImage.num_originalImage;
num_experiment = Results.num_experiments;


switch Pros.displayPaperMode
	case '1'
		% �о��������Ӧ��ͼ��������_1��
		figure010 = figure('Name',[num2str(Pros.numImagesShow) ' ��ɸѡ��ͼ���� ' labelStr ' ָ���µ�����ͼ'],'Position',[20 20 2000 800],'Visible',controlVis);
		row=4;
		col=10;
		% original image
		for index_image=1:num_image
			subplot(row,col,index_image);
			image010 = imread(EachImage.originalImage(index_image).path);
			imshow(image010);
			axis equal;
			axis off;
			title(strrep(EachImage.originalImage(index_image).name,'_','\_'));
		end
		% save figure
		filename_figure = ['��ָ�� ' labelStr ' �� ' num2str(num_image) ' ��ͼ���ԭͼ.jpg'];
		filepath_figure = fullfile(folderpath_visNeedBwImgForPaper, filename_figure);
		saveas(figure010,filepath_figure);
		
		% bw image of ground truth
		for index_image=1:num_image
			subplot(row,col,index_image);
			image010 = imread(EachImage.groundTruthBwImage(index_image).path);
			imshow(image010);
			axis equal;
			axis off;
			title(strrep(EachImage.originalImage(index_image).name,'_','\_'));
		end
		% save figure
		filename_figure = ['��ָ�� ' labelStr ' �� ' num2str(num_image) ' ��ͼ�����ֵͼ.jpg'];
		filepath_figure = fullfile(folderpath_visNeedBwImgForPaper, filename_figure);
		saveas(figure010,filepath_figure);
		
		% bw image of each method
		for index_experiment = 1:Results.num_experiments
			for index_image=1:num_image
				subplot(row,col,index_image);
				image010 = imread(Results.experiments(index_experiment).bwImages(index_image).path);
				imshow(image010);
				axis equal;
				axis off;
				title(strrep(EachImage.groundTruthBwImage(index_image).name,'_','\_'));
			end
			% save figure
			filename_figure = ['ԭͼ����ֵͼ����������ֵͼ�Ա�ͼ.jpg'];
			filepath_figure = fullfile(folderpath_visNeedBwImgForPaper, filename_figure);
			saveas(figure010,filepath_figure);
		end
		
	case '2'
		
		%% �о��������Ӧ��ͼ��������_2��
		num_fig = 4;
		index_image = 1;
		index_pic=1;
		row=num_image/num_fig;
		col=2+Results.num_experiments;
		for index_fig=1:1:num_fig
			figure010 = figure('Name',[num2str(Pros.numImagesShow) ' ��ɸѡ��ͼ�������ͼ-' num2str(index_fig)],'Position',[20 20 160*col 160*row],'Visible',controlVis);
			index_pic=1;
			for index_image=1+row*(index_fig-1):1:row*index_fig
				% original image
				subplot(row,col,index_pic);
				image010 = imread(EachImage.originalImage(index_image).path);
				imshow(image010);
				axis equal;
				axis off;
				title(strrep(EachImage.originalImage(index_image).name(1:end-4),'_','\_'));
				index_pic=index_pic+1;
				% bw image of ground truth
				subplot(row,col,index_pic);
				image010 = imread(EachImage.groundTruthBwImage(index_image).path);
				imshow(image010);
				axis equal;
				axis off;
				title('gt');
				index_pic=index_pic+1;
				% bw image of each method
				for index_experiment = 1:1:num_experiment
					subplot(row,col,index_pic);
					image010 = imread(Results.experiments(index_experiment).bwImages(index_image).path);
					imshow(image010);
					axis equal;
					axis off;
					title(Results.experiments(index_experiment).name);
					index_pic=index_pic+1;
				end
			end
			% save figure
			filename_figure = ['ԭͼ����ֵͼ����������ֵͼ�Ա�ͼ-' num2str(index_fig) '.jpg'];
			filepath_figure = fullfile(folderpath_visNeedBwImgForPaper, filename_figure);
			saveas(figure010,filepath_figure);
			
		end
		
		
	otherwise
		error('error at choose mode !')
		
end



end

