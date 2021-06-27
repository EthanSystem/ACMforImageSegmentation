

folderpath_inputBase = ['.\resources\datasets'];

filename_image = dir(fullfile(Args.folderpath_inputBase,'images'));

folderpath_images = fullfile(folderpath_inputBase, 'input images');

numImageFiles = length(filename_image)-2;
index_filename_image=1;
for index_filename_image =1: numImageFiles
	%% input data paths
	folderpath_image = fullfile(folderpath_images, filename_image(index_filename_image).name, 'original image');
	folderpath_scribble = fullfile(folderpath_images, filename_image(index_filename_image).name, 'marked image');
	mkdir(folderpath_scribble);
end
