function compute_mfcc( mainDir, prefix, wav_file, startInd, endInd )
%Computes Mel Frequency Cepstral Coefficients
close all

    %% Initialization
    load('mel_filters.mat')
    s_in = wavread(strcat(mainDir,'/', wav_file));
    s_of = s_in-mean(s_in);
    
    f_s = 16000;
    frame_len = 400;
    frame_shift = 160;
    
    %Remove beginning and end of sentence silence
    s_of = s_of(startInd:endInd);
    frame_num = ceil((length(s_of)-frame_len+frame_shift)/frame_shift);
    pad_len = ((frame_num-1)*frame_shift+frame_len)-length(s_of);
    t = (1:length(s_of)+pad_len)/f_s;
    
    %Remove DC offset and pad signal
    s_of = [s_of;zeros(pad_len,1)];g
    
    log_energy = logE(s_of, frame_len, frame_shift, frame_num)';
    spectrum = filterSignal(s_of, frame_len, frame_shift, frame_num);
    MFCC = calc_mfcc(spectrum, frame_num);
    
    %Subtract mean from each MFCC column
    MFCC = MFCC- (ones(size(MFCC,1),1)*mean(MFCC,1));
    feat = [log_energy,MFCC];
     
    %Calculate MFCC derivatives
    feat_plus = feat(2:size(feat,1),:);
    feat_minus = feat(1:size(feat,1)-1,:);
    feat_deriv = (feat_plus-feat_minus)/(frame_len/f_s);
    feat_deriv = vertcat(zeros(1,14),feat_deriv);
    feat = horzcat(feat,feat_deriv);
    save(strcat('mfcc_data/mat/', mainDir, '/', prefix,'_feat_vect.mat'), 'feat');
    
   
%    x = corrcoef(feat);
%   
%     h = figure;
%     plot(feat(:,1:14));
%     title('MFCC Values Per Frame');
%     xlabel('Frame Column');
%     ylabel('Value');
%     legend('LogE','MFCC1','MFCC2','MFCC3','MFCC4','MFCC5','MFCC6','MFCC7','MFCC8','MFCC9', 'MFCC10', 'MFCC11', 'MFCC12','MFCC13');
%     saveas(h,strcat('mfcc_data/plots/',prefix,'_mfcc.jpeg'))
%     
%     h = figure;
%     plot(feat(:,15:28));
%     title('MFCC Derivative Values Per Frame');
%     xlabel('Frame Column');
%     ylabel('Value');
%     legend('LogE','MFCC1','MFCC2','MFCC3','MFCC4','MFCC5','MFCC6','MFCC7','MFCC8','MFCC9', 'MFCC10', 'MFCC11', 'MFCC12','MFCC13');
%     saveas(h,strcat('mfcc_data/plots/',prefix,'_mfcc_deriv.jpeg'))
%     
%     h = figure;
%     imagesc(x);
%     title('MFCC Correlations');
%     xlabel('MFCC');
%     ylabel('MFCC');
%     colorbar();
%     saveas(h,strcat('mfcc_data/plots/',prefix,'_mfcc_corr.jpeg'))
end
    
%% Compute logE
function  log_energy = logE(s_of, frame_len, frame_shift, frame_num)
    
    log_energy = zeros(1,frame_num);
    
    for j = 0:frame_num-1
        frame_data = s_of((j*frame_shift+1):(j*frame_shift+frame_len));
        log_energy(j+1) = max(-50, log(sum(frame_data.^2)));
    end
end

%% Pre_Emphasis Filter 

function spectrum = filterSignal(s_of, frame_len, frame_shift, frame_num)
    num = [1, -0.97];
    denom = 1;
    
    %Filter signal
    s_pe = filter(num,denom,s_of);
    
    %Compute spectrum of filtered signal
    NFFT = 512;
    spectrum = zeros(frame_num,NFFT/2+1);
    
    for i=1:frame_num
        spect = fft(s_pe((i-1)*frame_shift+(1:frame_len)).*hamming(frame_len),NFFT);
        spectrum(i,:) = spect(1:NFFT/2+1);
    end
end

%% Compute MFCC

function MFCC = calc_mfcc(spectrum, frame_num)
    
    load('mel_filters.mat');
    
    % Compute energy in mel_filter bands 
    NFFT = 512;
    energy_mel = zeros(frame_num, size(mel_filters,2));
    
    for i=1:frame_num
        energy_mel(i,:) = abs(spectrum(i,1:NFFT/2+1))*mel_filters;
    end
    
    % Compute MFCC
    MFSC = max(-50, log(energy_mel));
    MFCC = zeros(frame_num,13);

    for k=1:frame_num
        for i=1:size(MFCC,2)
            j = 1:23;
            dct = cos(pi*(i-1)/23*(j-.5))';
            MFCC(k,i) = MFSC(k,:)*dct;
        end 
    end
    
end