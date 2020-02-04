function discomfiq_score = discomfiq( impath )
    
    global pdf_kernel prs_points;   % sel_chs top_n;
    
    minprs = prs_points(1);
    maxprs = prs_points(end);
    prsres = round(prs_points(2)-prs_points(1),4);
        
    blspath = '/home/subhayanmukherjee/Documents/e2e_mar/tensorflow_compression/examples';
    [~,savename,~] = fileparts(impath);
    
    fileID = fopen('runbls.sh','w');
    fprintf(fileID, "export LD_LIBRARY_PATH=/usr/lib/x86_64-linux-gnu\n");
    fprintf(fileID, "export PYTHONPATH=/home/subhayanmukherjee/Documents/e2e_mar/tensorflow_compression\n");
    fprintf(fileID, strcat( "python ", blspath, "/bls2017.py --num_filters 256 --checkpoint_dir ", blspath, "/train compress ", impath, " ", savename, "\n" ));
    fclose(fileID);
    system('sh runbls.sh');
    system('rm runbls.sh');

    codedIm = load(strcat( savename, '.mat' ));
    codedIm = double( codedIm.y );
    system(strcat("rm ", savename, ".mat"));
    [crows, ccols, ccnt] = size(codedIm);
    fid = fopen('dcq_time.txt', 'a+');
    tic;
    discomfiq_score = 0;
%     for r = 1:crows
%         for c = 1:ccols
%             this_pix = squeeze(codedIm(r,c,:));

            this_pix = reshape(codedIm,crows*ccols*ccnt,1);
            this_pix(this_pix < minprs) = minprs;
            this_pix(this_pix > maxprs) = maxprs;

            % [N,edges] = histcounts(this_pix);
            % this_pix = edges + diff(edges(1:2)) / 2;
            % this_pix(end) = [];
            this_idx = round(this_pix - minprs,4);
            this_mod = mod(this_pix,prsres);
            this_idx = uint32( round(this_idx - this_mod,4)/prsres + 1 );
            % this_x = this_pix - this_mod;
            this_idx = unique(this_idx);
            this_x = prs_points(this_idx);
            
            pd_kernel_t = fitdist( this_pix,'Kernel','Kernel','epanechnikov');
            pdf_kernel_t = pdf(pd_kernel_t,this_x) + eps;                % avoid zero probabilities
            pdf_kernel_t = pdf_kernel_t ./ sum(pdf_kernel_t);       % sum of probabilities = 1
            
            % pdf_kernel_t = N + eps;
            % pdf_kernel_t = pdf_kernel_t ./ sum(pdf_kernel_t);

            pdf_kernel_s = pdf_kernel(this_idx) + eps;
            pdf_kernel_s = pdf_kernel_s ./ sum(pdf_kernel_s);

            discomfiq_score = discomfiq_score + kldiv(this_x, pdf_kernel_t, pdf_kernel_s);
%         end
%     end
%     discomfiq_score = discomfiq_score / (crows*ccols);
    fprintf(fid, '%.4f\n', toc);
    fclose(fid);
end
