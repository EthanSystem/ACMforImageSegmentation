function visualizeIndicator(type, Pros, Results ,num_image, num_scribble, num_experiment, isVisual, experementSequence)
%visualizeIndicator 绘制指标图像
%   TODO
if strcmp(isVisual,'yes')==1
	controlVis = 'on';
else
	controlVis = 'off';
end

Precision_all=1./zeros(num_image, num_scribble);
Recall_all=1./zeros(num_image, num_scribble);

switch type
	case 'Jaccard'
		filenameStr='_Jaccard';
		jaccardDistance_all=1./zeros(num_image,num_scribble);
		for index_experiment =experementSequence
			Pros.folderpath_evaluationsData = Results.experiments(index_experiment).folderpath_evaluationData;
			load(fullfile(Pros.folderpath_evaluationsData, 'jaccardDistance.mat'));
			jaccardDistance_all=[jaccardDistance_all jaccardDistance];
		end
		jaccardDistance_all(:,1)=[];
		name_evaluationData = 'jaccardDistance_all';
		% 		labelStr = 'Jaccard Distance';
		labelStr = 'JD';
		
	case 'ModifiedHausdorff'
		filenameStr='_ModiHausdorff';
		modifiedHausdorffDistance_all=1./zeros(num_image, num_scribble);
		for index_experiment =experementSequence
			Pros.folderpath_evaluationsData = Results.experiments(index_experiment).folderpath_evaluationData;
			load(fullfile(Pros.folderpath_evaluationsData, 'modifiedHausdorffDistance.mat'));
			modifiedHausdorffDistance_all=[modifiedHausdorffDistance_all modifiedHausdorffDistance];
		end
		modifiedHausdorffDistance_all(:,1)=[];
		name_evaluationData = 'modifiedHausdorffDistance_all';
		% 		labelStr = 'Modified Hausdorff Distance';
		labelStr = 'MHD';
		
	case 'F1'
		filenameStr='_F1';
		F1_all=1./zeros(num_image, num_scribble);
		for index_experiment =experementSequence
			Pros.folderpath_evaluationsData = Results.experiments(index_experiment).folderpath_evaluationData;
			load(fullfile(Pros.folderpath_evaluationsData, 'F1.mat'));
			F1_all=[F1_all F1];
		end
		F1_all(:,1)=[];
		name_evaluationData = 'F1_all';
		labelStr = 'F1';
		
	case 'macro-F1'
		filenameStr='_macroF1';
		macroF1_all=1./zeros(1, num_scribble);
		for index_experiment =experementSequence
			Pros.folderpath_evaluationsData = Results.experiments(index_experiment).folderpath_evaluationData;
			load(fullfile(Pros.folderpath_evaluationsData, 'macroF1.mat'));
			macroF1_all=[macroF1_all macroF1];
		end
		macroF1_all(:,1)=[];
		name_evaluationData = 'macroF1_all';
		labelStr = 'macro-F1';
		
	case 'time'
		filenameStr='_time';
		time_all=1./zeros(num_image,num_scribble);
		for index_experiment =experementSequence
			Pros.folderpath_evaluationsData = Results.experiments(index_experiment).folderpath_evaluationData;
			load(fullfile(Pros.folderpath_evaluationsData, 'time.mat'));
			time_all=[time_all elipsedEachTime.time];
		end
		time_all(:,1)=[];
		name_evaluationData = 'time_all';
		labelStr = 'Time';
		
	case 'iteration'
		filenameStr='_iteration';
		time_all=1./zeros(num_image,num_scribble);
		for index_experiment =experementSequence
			Pros.folderpath_evaluationsData = Results.experiments(index_experiment).folderpath_evaluationData;
			load(fullfile(Pros.folderpath_evaluationsData, 'time.mat'));
			time_all=[time_all elipsedEachTime.iteration];
		end
		time_all(:,1)=[];
		name_evaluationData = 'time_all';
		labelStr = 'Iteration';
	otherwise
		error('error to choose type');
		
end


%% 绘制每种方法的图像与指标的值的关系图表

%% 各种分割算法的分开图，这里每种算法的所有的图像的指标的值按照图像序列排列。
if (strcmp(type,'Jaccard')==1 || strcmp(type,'ModifiedHausdorff')==1 || strcmp(type,'F1')==1 || strcmp(type,'time')==1 || strcmp(type,'iteration')==1)
	X=1:1:num_image;
	for index_experiment=1:num_experiment
		
		filename_figure020=[Results.experiments(index_experiment).name filenameStr '_series.png'];
		filepath_figure020=fullfile(Pros.folderpath_experiment, filename_figure020);
		
		titleStr020=strrep(Results.experiments(experementSequence(index_experiment)).name,'_','\_');
		eval(['Y=' name_evaluationData '(:,' num2str(index_experiment) ');']);
		figure('Name',filename_figure020,'Position',[20 20  Pros.figSize(1) Pros.figSize(2)],'Color',[1 1 1],'Visible',controlVis);
		plot(X,Y,'.-','LineWidth',Pros.lineWidth,'MarkerSize',Pros.markerSize);
		hold on;
		str_text=cellstr(num2str(Y));
		xlabel('Image Series','FontSize',8,'FontWeight','bold');
		ylabel([labelStr],'FontSize',8,'FontWeight','bold');
		%         title([' ' titleStr020 ' 在处理图像的 ' labelStr ' 评价指标折线图'],'FontSize',14,'FontWeight','bold');
		saveas(gcf,filepath_figure020);
	end
	
	%% 各种分割算法的分开图，这里每种算法的所有的图像的指标的值是按照指标的值从小到大排列。
	X=1:1:num_image;
	for index_experiment=1:num_experiment
		
		filename_figure020=[Results.experiments(index_experiment).name filenameStr '_sort.png'];
		filepath_figure020=fullfile(Pros.folderpath_experiment, filename_figure020);
		
		titleStr020=strrep(Results.experiments(experementSequence(index_experiment)).name,'_','\_');
		eval(['Y=sort(' name_evaluationData '(:,' num2str(index_experiment) '));']);
		figure('Name',filename_figure020,'Position',[20 20  Pros.figSize(1) Pros.figSize(2)],'Color',[1 1 1],'Visible',controlVis);
		plot(X,Y,'.-','LineWidth',Pros.lineWidth,'MarkerSize',Pros.markerSize);
		hold on;
		str_text=cellstr(num2str(Y));
		% 			text(X,Y,str_text,'HorizontalAlignment','center');
		xlabel('Image Series Sorted By Evaluation Value','FontSize',8,'FontWeight','bold');
		ylabel([labelStr],'FontSize',8,'FontWeight','bold');
		%         title([' ' titleStr020 ' 在处理图像的 ' labelStr ' 评价指标排序折线图'],'FontSize',14,'FontWeight','bold');
		saveas(gcf,filepath_figure020);
	end
	
	
	%% 合并图，这里每种算法的所有的图像的指标的值按照图像序列排列。
	legendTag=cell(1,num_experiment);
	X=1:1:num_image;
	figure1 = figure('Name',['figure of overlay figure of ' labelStr],'Position',[20 20  Pros.figSize(1) Pros.figSize(2)],'Color',[1 1 1],'Visible',controlVis);
	k=1;
	YY=zeros(num_image, num_experiment);
	for index_experiment=1:num_experiment
		eval(['YY(:,' num2str(index_experiment) ')=' name_evaluationData '(:,' num2str(index_experiment) ');']);
		titleStr020=strrep(Results.experiments(experementSequence(index_experiment)).name,'_','\_');
		legendTag(k)= {[titleStr020]};
		k=k+1;
	end
	filename_figure020=['overlay' filenameStr '_series'];
	filepath_figure020=fullfile(Pros.folderpath_experiment, filename_figure020);
	axes1 = axes('Parent',figure1,'Position',[0.12 0.12 0.82 0.82]);
	hold(axes1,'on');
	
	% 		xlabel('Image Series','FontSize',8,'FontWeight','bold');
	ylabel([labelStr],'FontSize',16,'FontWeight','bold');
	xlim(axes1,[1 num_image])
	set(axes1,'YColor',[0 0 0],'FontSize',16,'XTick',(1:1:num_image));
	plot(X,YY,'.-','LineWidth',Pros.lineWidth,'MarkerSize',Pros.markerSize,'Parent',axes1);
	
	handle_legend=legend(legendTag);
	set(handle_legend,'Location','best');
	%     title(['所有方法在处理图像的 ' labelStr ' 评价指标折线图的合并效果图'],'FontSize',14,'FontWeight','bold');
	saveas(gcf,[filepath_figure020 '.png']);
	saveas(gcf,[filepath_figure020 '.fig']);
	
	%% 合并图，这里每种算法的所有的图像的指标的值是按照指标的值从小到大排列。
	legendTag=cell(1,num_experiment);
	X=1:1:num_image;
	figure('Name',['figure of overlay figure of ' labelStr],'Position',[20 20  Pros.figSize(1) Pros.figSize(2)],'Color',[1 1 1],'Visible',controlVis);
	k=1;
	for index_experiment=experementSequence
		filename_figure020=['overlay' filenameStr '_sort.png'];
		filepath_figure020=fullfile(Pros.folderpath_experiment, filename_figure020);
		titleStr020=strrep(Results.experiments(experementSequence(index_experiment)).name,'_','\_');
		eval(['Y=sort(' name_evaluationData '(:,' num2str(index_experiment) '));']);
		plot(X,Y,'.-','LineWidth',Pros.lineWidth,'MarkerSize',Pros.markerSize);
		hold on;
		legendTag(k)= {[titleStr020]};
		k=k+1;
	end
	
	xlabel('Image Series Sorted By Evaluation Value','FontSize',8,'FontWeight','bold');
	ylabel([labelStr],'FontSize',8,'FontWeight','bold');
	handle_legend=legend(legendTag);
	set(handle_legend,'Location','best');
	%     title(['所有方法在处理图像的 ' labelStr ' 评价指标各自排序折线图的合并效果图'],'FontSize',14,'FontWeight','bold');
	saveas(gcf,filepath_figure020);
	
	
end


switch type
	case 'macro-F1'
		% 平均图1
		filename_figure020=[ 'average' filenameStr '.png'];
		filepath_figure020=fullfile(Pros.folderpath_experiment, filename_figure020);
		eval(['Y=' name_evaluationData ';']);
		figure('Name',['figure of average image of ' labelStr],'Position',[20 20 Pros.figSize(1) Pros.figSize(2)],'Color',[1 1 1],'Visible',controlVis);
		bar(Y);
		hold on;
		% 		set(gca,'XLim',[1 num_image]);
		str_text=cellstr(num2str(Y'));
		%         set('');
		xlabel('Method','FontSize',8,'FontWeight','bold');
		ylabel([labelStr],'FontSize',8,'FontWeight','bold');
		for i=1:num_experiment
			titleStr020=strrep(Results.experiments(experementSequence(i)).name,'_','\_');
			xTickLabel(i)= {[titleStr020]};
		end
		set(gca,'XTickLabel',xTickLabel(:));
		%         title(['所有方法在处理图像的 ' labelStr ' 指标柱状图'],'FontSize',14,'FontWeight','bold');
		saveas(gcf,filepath_figure020);
		
	otherwise
		X=1:1:num_image;
		filename_figure020=[ 'average' filenameStr '.png'];
		filepath_figure020=fullfile(Pros.folderpath_experiment, filename_figure020);
		eval(['Y=mean(' name_evaluationData ',2);']);
		figure('Name',['figure of average image of ' labelStr],'Position',[100 100 1000 500],'Color',[1 1 1],'Visible',controlVis);
		plot(X,Y,'.-r','LineWidth',Pros.lineWidth,'MarkerSize',Pros.markerSize);
		hold on;
		% 		set(gca,'XLim',[1 num_image]);
		str_text=cellstr(num2str(Y));
		% 		text(X,Y,str_text,'HorizontalAlignment','center');
		xlabel('Image Series','FontSize',8,'FontWeight','bold');
		ylabel([labelStr],'FontSize',8,'FontWeight','bold');
		%         title(['所有方法在处理图像的 ' labelStr ' 评价指标平均折线图'],'FontSize',14,'FontWeight','bold');
		saveas(gcf,filepath_figure020);
end



end









