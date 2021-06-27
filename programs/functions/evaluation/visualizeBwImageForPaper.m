function [ output_args ] = visualizeBwImageForPaper( Pros, EachImage, Results, isVisual)
%visualizeBwImageForPaper 可视化论文的图像阵列
%   此处显示详细说明
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

%% 排序方式
num_image = EachImage.num_originalImage;
num_experiment = Results.num_experiments;


switch Pros.displayPaperMode
	case '1'
		% 列举数据里对应的图像（论文用_1）
		figure010 = figure('Name',[num2str(Pros.numImagesShow) ' 张筛选的图像在 ' labelStr ' 指标下的阵列图'],'Position',[20 20 2000 800],'Visible',controlVis);
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
		filename_figure = ['在指标 ' labelStr ' 下 ' num2str(num_image) ' 张图像的原图.jpg'];
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
		filename_figure = ['在指标 ' labelStr ' 下 ' num2str(num_image) ' 张图像的真值图.jpg'];
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
			filename_figure = ['原图、真值图、各方法二值图对比图.jpg'];
			filepath_figure = fullfile(folderpath_visNeedBwImgForPaper, filename_figure);
			saveas(figure010,filepath_figure);
		end
		
	case '2'
		
		%% 列举数据里对应的图像（论文用_2）
		num_fig = 4;
		index_image = 1;
		index_pic=1;
		row=num_image/num_fig;
		col=2+Results.num_experiments;
		for index_fig=1:1:num_fig
			figure010 = figure('Name',[num2str(Pros.numImagesShow) ' 张筛选的图像的阵列图-' num2str(index_fig)],'Position',[20 20 160*col 160*row],'Visible',controlVis);
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
			filename_figure = ['原图、真值图、各方法二值图对比图-' num2str(index_fig) '.jpg'];
			filepath_figure = fullfile(folderpath_visNeedBwImgForPaper, filename_figure);
			saveas(figure010,filepath_figure);
			
		end
		
		
	otherwise
		error('error at choose mode !')
		
end



end

