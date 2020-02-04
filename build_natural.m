clear all;
do_fit = true;

blspath = '/home/subhayanmukherjee/Documents/e2e_mar/tensorflow_compression/examples';

num_ch = 256;    % for bitrate 12

if do_fit
    
%     figure;
%     title('Natural Models');
%     hold on;
    
    load('agg_hec');
    prsres = 1e-4;
    
    % agg_hec{cidx} = ( agg_hec{cidx} - mean(agg_hec{cidx}) ) / std(agg_hec{cidx},1);
    
    pd_kernel = fitdist( agg_hec,'Kernel','Kernel','epanechnikov');
    prs_points = min(agg_hec):prsres:max(agg_hec);
    prs_points = union(prs_points,max(agg_hec));
    pdf_kernel = pdf(pd_kernel,prs_points);
    
%     hold off;
    
    save('pd_kernel','pd_kernel','-v7.3');
    save('pdf_kernel','pdf_kernel','-v7.3');
    save('prs_points','prs_points','-v7.3');
%     save('sel_chs','sel_chs');

else
    
    % dir_list = dir('model_imgs/*.png');
    dir_list = dir('train_imgs/*.png');
    fileNames = {dir_list.name};
    % << NA if using *.png >> fileNames(1:2)=[];              % skip the entries for current (.) and parent (..) directory
    
    filecnt = length(fileNames);
    agg_hec = [];
    for fdx = 1:filecnt

        filen = fileNames{fdx};
        fname = convertCharsToStrings(filen);
        [~,savename,ext] = fileparts(fname);
        
        fileID = fopen('runbls.sh','w');
        fprintf(fileID, "export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu\n");
        fprintf(fileID, 'export PYTHONPATH="/home/subhayanmukherjee/Documents/e2e_mar/tensorflow_compression"\n');
        fprintf(fileID, strcat("python ", blspath, "/bls2017.py --num_filters 256 compress ", blspath, "/train_imgs/", fname, " ", savename, "\n"));
        fclose(fileID);
        system('sh runbls.sh');
        
        codedIm = load(strcat(savename, ".mat"));
        codedIm = codedIm.y;
        system(strcat("rm ", savename, ".mat"));
        
        [crows, ccols, ccnt] = size(codedIm);
        agg_hec = [agg_hec; reshape(codedIm,crows*ccols*ccnt,1)];
        
        fprintf('Completed execution for %s\n',fname);
        
        if fdx == filecnt
            agg_hec = sort(agg_hec);
        end
        if mod(fdx,40) == 0 || fdx == filecnt
            save('agg_hec','agg_hec','-v7.3');
            fprintf('Saved progress to agg_hec.mat');
        end
    end
    
end
