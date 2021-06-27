function [jaccardIndexOur, jaccardDistanceOur] = Jacard_evaluation(A, B)

% JaccardTest.m
% Compute the Jaccard similarity coefficient (index) of two images. 
% Also how to find the Jaccard distance.
%
% Kawahara (2013).
 
% A value of "1" = the line object (foreground).
% A value of "0" = the background.




% filepath_groundTruth = dir('.\resources\datasets\ground truth images');
% filepath_bwImage = dir('.\results\favorite export data\bw image');
%     fprintf('testing: %d/%d/%s\n', i, length(ims),ims(i).name);
%     fprintf('testing: %d/%d/%s\n', i, length(ims2),ims2(i).name);
%     A = imread(filepath_groundTruth);
%     B = imread(filepath_bwImage);

%     % Let's see their two drawings.
%     figure; 
%     subplot(1,2,1); imagesc(A); axis image; colormap gray; 
%     title('A');
% 
%     subplot(1,2,2); imagesc(B); axis image; colormap gray; 
%     title('B'); 

    % How similar are Alice's and Bob's drawing of a line? 
    % An intuitive way to measure this is to compare each of the white "line" 
    % pixels (a value of "1") to each other and see how many white pixels 
    % overlap compared to the total number of white line pixels.

    A=im2bw(A);
    B=im2bw(B);
    
    % We compute the intersection of the two lines using the "AND" operator "&".
    intersectImg = A & B; 
%     figure; imagesc(intersectImg); axis image; colormap gray; title('intersection');

    % We compute the union of the two lines using the "OR" operator "|".
    unionImg = A | B;
%     figure; imagesc(unionImg); axis image; colormap gray; title('union');

    % There is only one pixel that overlaps (intersects) 
    numerator = sum(intersectImg(:));

    % There are 5 pixels that are unioned.
    denomenator = sum(unionImg(:));

    % So intuitively we might expect that a similarity of 1/5 would 
    % be a good indication. This is exactly what Jaccard's does.

    jaccardIndexOur = numerator/denomenator;
    % jaccardIndex =
    %     0.2000

    % Jaccard distance shows how dis-similar the two line drawings are.
    jaccardDistanceOur = 1 - jaccardIndexOur;
    % jaccardDistance =
    %     0.8000
%     close all

% 
% X=[1:49]; 
% % figure, plot(X,jaccardIndexOur,'r-','markersize',20);hold on;
% % plot(X,jaccardIndexOneCut,'g.','markersize',20);hold on;
% % plot(X,jaccardIndexGeoGC,'b.','markersize',20);hold on;
% % plot(X,jaccardIndexSSNCuts,'m.','markersize',20);hold on;
% % plot(X,jaccardIndexTRC,'c.','markersize',20);hold on;
% % plot(X,jaccardIndexOur,'-.r',...
% %     X,jaccardIndexOneCut,'g',X,jaccardIndexGeoGC,'b',...
% %     X,jaccardIndexSSNCuts,':m',...
% %     X,jaccardIndexTRC,'--c','LineWidth',1);
% plot(X,jaccardIndexOur,'-.r','LineWidth',1);
% 
% % plot(X,jaccardIndexOur,'c',X,jaccardIndexGeoGC,'m','LineWidth',1);
% xlabel('Image Number','FontSize',12,'FontWeight','bold');
% ylabel('Evaluation(JaccardIndex)','FontSize',12,'FontWeight','bold');
% %title('Comparison with OneCut');
% hleg=legend({'Ours'});
% set(hleg,'Location','SouthEast');
% saveas(gcf,'jaccardIndex','png');
% 
% % figure, plot(X,jaccardDistanceOur,'r.','markersize',20);hold on;
% % plot(X,jaccardDistanceOneCut,'g.','markersize',20);hold on;
% % plot(X,jaccardDistanceGeoGC,'b.','markersize',20);hold on;
% % plot(X,jaccardDistanceSSNCuts,'m.','markersize',20);hold on;
% % plot(X,jaccardDistanceTRC,'c.','markersize',20);hold on;
% % plot(X,jaccardDistanceOur,'-.r',...
% %     X,jaccardDistanceOneCut,'g',X,jaccardDistanceGeoGC,'b',...
% %     X,jaccardDistanceSSNCuts,':m',...
% %     X,jaccardDistanceTRC,'--c','LineWidth',1);
% % % plot(X,jaccardDistanceOur,'c',X,jaccardDistanceGeoGC,'y','LineWidth',1);
% % xlabel('Image Number','FontSize',12,'FontWeight','bold');
% % ylabel('Evaluation(JaccardDistance)','FontSize',12,'FontWeight','bold');
% % %title('Comparison with OneCut');
% % hleg=legend({'Ours','OneCut','GeoGC','SSNCuts','TRC'});
% % set(hleg,'Location','NorthEast');
% % saveas(gcf,'jaccardDistance','png');
% 
% 
% fid = fopen('jaccardIndexOurs.txt','w');
% fprintf(fid,'%g\t',jaccardIndexOur);
% fclose(fid);
% % 
% % fid = fopen('jaccardIndexOneCut.txt','w');
% % fprintf(fid,'%g\t',jaccardIndexOneCut);
% % fclose(fid);
% % 
% % fid = fopen('jaccardIndexGeoGC.txt','w');
% % fprintf(fid,'%g\t',jaccardIndexGeoGC);
% % fclose(fid);
% % 
% % fid = fopen('jaccardIndexSSNCuts.txt','w');
% % fprintf(fid,'%g\t',jaccardIndexSSNCuts);
% % fclose(fid);
% % 
% % fid = fopen('jaccardIndexTRC.txt','w');
% % fprintf(fid,'%g\t',jaccardIndexTRC);
% % fclose(fid);
% % 
% % fid = fopen('jaccardDistanceOurs.txt','w');
% % fprintf(fid,'%g\t',jaccardDistanceOur);
% % fclose(fid);
% % 
% % fid = fopen('jaccardDistanceOneCut.txt','w');
% % fprintf(fid,'%g\t',jaccardDistanceOneCut);
% % fclose(fid);
% % 
% % fid = fopen('jaccardDistanceGeoGC.txt','w');
% % fprintf(fid,'%g\t',jaccardDistanceGeoGC);
% % fclose(fid);
% % 
% % fid = fopen('jaccardDistanceSSNCuts.txt','w');
% % fprintf(fid,'%g\t',jaccardDistanceSSNCuts);
% % fclose(fid);
% % 
% % fid = fopen('jaccardDistanceTRC.txt','w');
% % fprintf(fid,'%g\t',jaccardDistanceTRC);
% % fclose(fid);




end
