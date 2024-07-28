clear
clc
date = '1108';
for i = 1:3
    path ='D:\正式数据\';
    load('GCconfig.mat')
    switch i
        case 1
            load(strcat(path,date,'\',date,'-b.mat'))
            % Remove baseline part
            data = data1(:,41:440,:);
        case 2
            load(strcat(path,date,'\',date,'-o.mat'))
            % Remove baseline part
            data = data2(:,41:440,:);
        case 3
            load(strcat(path,date,'\',date,'-n.mat'))
            % Remove baseline part
            data = data3(:,41:440,:);
    end
    
    % Transform into required format
    data = permute(data,[2 1 3]);
    
    config.window.length = 500;
    
    % Windows the data.
    data = H_window ( data, config.window );
    
    % Gets the size of the analysis data.
    [ samples, channels, windows, trials ] = size ( data );
    
    % Calculates the window size, the overlapping and the nfft value.
    GC.rawdata = zeros ( channels, channels, windows, trials );
    
    % Calculates the AR models for each vector.
    models = cell ( channels, windows, trials );
    for model = 1: numel ( models )
        models { model } = createModel ( data ( :, model ), config.orderAR );
    end
    
    for trial = 1: trials
        for window = 1: windows
            for ch1 = 1: channels - 1
                for ch2 = ch1 + 1: channels
                    
                    Mx  = models { ch1, window, trial };
                    My  = models { ch2, window, trial };
                    Mxy = [ Mx My ];
                    Myx = [ My Mx ];
                    
                    ey_y  = modelError ( data ( config.orderAR + 1: end, ch2, window, trial ), My,  samples, config.orderAR );
                    ex_x  = modelError ( data ( config.orderAR + 1: end, ch1, window, trial ), Mx,  samples, config.orderAR );
                    ey_xy = modelError ( data ( config.orderAR + 1: end, ch2, window, trial ), Mxy, samples, config.orderAR );
                    ex_xy = modelError ( data ( config.orderAR + 1: end, ch1, window, trial ), Mxy, samples, config.orderAR );
                    
                    GC.rawdata ( ch1, ch2, window, trial ) = log ( var ( ey_y ) / var ( ey_xy ) );
                    GC.rawdata ( ch2, ch1, window, trial ) = log ( var ( ex_x ) / var ( ex_xy ) );
                end
            end
        end
    end
    
    % Averages across trials.
    GC.data  = mean ( GC.rawdata, 4 );
    
    % Removes the trial information.
    GC = rmfield ( GC, 'rawdata' );
    
    switch i
        case 1
            save(strcat(path,date,'/GC-b2.mat'),'GC')
        case 2
            save(strcat(path,date,'/GC-o2.mat'),'GC')
        case 3
            save(strcat(path,date,'/GC-n2.mat'),'GC')
    end
    clearvars data GC Mx My Mxy Myx
end

function E = modelError ( y, model, N, Q )

M1 = ones ( N - Q, 1 );
H = regress ( y, [ M1 model ] );
Y_x = [ M1 model ] * H;
E = y - Y_x;
end

function model = createModel ( X, order )

model = convmtx ( X, order );
model = model ( order: end - order, : );
model = flipdim ( model, 2 );
end