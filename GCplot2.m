clear
clc
path ='D:\正式数据\';
i = 5;
switch i
    case 1
        date = '0313';
        load(strcat(path,date,'/GC-b.mat'),'GC')
    case 2
        load(strcat(path,'Gcb'))
        GC.data = GCs;
        chn1 = [1 3 3 4 4 5 8 11 12 14 22];
        chn2 = [29 4 29 27 30 29 29 16 29 15 29];
    case 3
        load(strcat(path,'Gco'))
        GC.data = GCs;
        chn1 = [1 3 3 5 7 7 8 8 10 11 11 11 12 13 14 14 14 16 17 22 22 24 25];
        chn2 = [29 4 29 29 11 22 27 29 13 16 22 29 29 16 15 16 18 17 19 26 29 29 30];
    case 4
        load(strcat(path,'Gcn'))
        GC.data = GCs;
end

load('GChandles.mat')
Msync = GC.data;
index     = handles.data.indexes { get ( handles.index, 'Value' ) };
threshold = str2double ( get ( handles.threshold, 'String' ) );

% handles.distance.String = '1000';
% Gets the variables refering to the system.
positions = handles.data.position;
layout    = handles.data.layout ( :, [ 1 2 ] );
labels    = handles.data.labels;

% Normalizes the layout.
layout = layout - repmat ( mean ( layout, 1 ), numel ( labels ), 1 );
layout = layout ./ repmat ( max ( abs ( layout ), [], 1 ), numel ( labels ), 1 );

% Gets the distance between sensors.
dist   = squareform ( pdist ( positions ) );
figure1 = figure;
axes1 = axes('Parent',figure1);

% Draws the sensors and prepares the axes.
scatter ( axes1, layout ( :, 1 ), layout ( :, 2 ), 80, [ 0 0 0 ], 'filled');
axis ( [ -1.05 1.05 -1.05 1.05 ] )
hold on
axis off

axes ( axes1 )

% Print channels' numbers, if required.
for channel = 1: size ( layout, 1 )
    text ( layout ( channel, 1 ), layout ( channel, 2 ) + .1, labels { channel }, ...
        'FontSize', 10, 'Color', [ .3 .3 .3 ], 'FontUnits', 'normalized', ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle' )
end

switch index
    case { 'GC','TE','PTE','PSI','DPI','L','DTF','PDC' }, handles.asymetric = 1;
    otherwise,                                      handles.asymetric = 0;
end

MM = max ( abs ( Msync (:) ) );

% Activates the axes to write in.
axes ( axes1 )

i = 1;
for k = 1:length(chn1)
    ch1 = chn1(i);
    ch2 = chn2(i);
    
    switch handles.asymetric
        
        case 0 % Symetric indexes
            if abs ( Msync ( ch1, ch2 ) ) > threshold
                if isnan ( dist ( ch1, ch2 ) ) || dist ( ch1, ch2 ) >= str2double ( get ( handles.distance, 'String' ) )
                    
                    line ( layout ( [ ch1 ch2 ], 1 )', layout ( [ ch1 ch2 ], 2 )', ...
                        'Color', [ .5 1 .5 ] * abs ( Msync ( ch1, ch2 ) / MM ), 'LineWidth', 2 );
                end
            end
            
        case 1 % Asymetric indexes
            % Strength F
            F = max ( Msync ( ch1, ch2 ), Msync ( ch2, ch1 ) ) / MM;
            % Directionality D
            switch index
                case 'DPI'
                    D = Msync ( ch1, ch2 ) / MM;
                case 'PSI'
                    D = -Msync ( ch1, ch2 ) / MM;
                otherwise % if D>0 => Msync(ch1,ch2)>Msync(ch2,ch1) => ch1->ch2
                    D = ( Msync ( ch1, ch2 ) - Msync ( ch2, ch1 ) ) / ( Msync ( ch1, ch2 ) + Msync ( ch2, ch1 ) );
            end
            D ( isnan ( D ) ) = 0;
            
            % Plot the lines and arrows
            if abs ( F ) > threshold
                if isnan ( dist( ch1, ch2 ) ) || dist( ch1, ch2 ) >= str2double ( get( handles.distance, 'String' ) )
                    if D > 0 % ch1 --> ch2
                        line ( layout( [ ch1 ch2 ], 1 ), layout( [ ch1 ch2 ], 2 ), ...
                            'Color', [ 0 .75 1 ] + [ 1 -.75 -1 ] * (abs ( F )-0.8) * 5, 'LineWidth', 2);
                        arrowh ( layout( [ ch1 ch2 ], 1 ), layout( [ ch1 ch2 ], 2 ), ...
                            [ 0 .75 1 ] + [ 1 -.75 -1 ] * (abs ( F )-0.8) * 5, 180 );
                        Rcd(i,1) = ch1;
                        Rcd(i,2) = ch2;
                        Rcd(i,3) = abs(F);
                        i = i+1;
                    else % ch2 --> ch1
                        line ( layout( [ ch1 ch2 ], 1 ), layout( [ ch1 ch2 ], 2 ), ...
                            'Color', [ 0 .75 1 ] + [ 1 -.75 -1 ] * (abs ( F )-0.8) * 5, 'LineWidth', 2);
                        arrowh ( layout( [ ch2 ch1 ], 1 ), layout( [ ch2 ch1 ], 2 ), ...
                            [ 0 .75 1 ] + [ 1 -.75 -1 ] * (abs ( F )-0.8) * 5, 180 );
                        Rcd(i,1) = ch2;
                        Rcd(i,2) = ch1;
                        Rcd(i,3) = abs(F);
                        i = i+1;
                    end
                end
            end
            
    end
end
hold off