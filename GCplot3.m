clear
clc
path ='D:\正式数据\';
mode = 1;
i = 2;
switch i
    case 1
        load(strcat(path,'Gcb'))
        G1 = GCs;
        load(strcat(path,'Gcn'))
        G2 = GCs;
        GC.data = G1-G2;
    case 2
        load(strcat(path,'Gco'))
        G1 = GCs;
        load(strcat(path,'Gcn'))
        G2 = GCs;
        GC1_n = G1 / max ( abs ( G1 (:) ) );
        GC2_n = G2 / max ( abs ( G2 (:) ) );
        switch mode
            case 1
                GC.data = G1-G2;
            case 2
                GC.data = GC1_n-GC2_n;
        end
    case 3
        load(strcat(path,'Gco'))
        G1 = GCs;
        load(strcat(path,'Gcb'))
        G2 = GCs;
        GC.data = G1-G2;
end

load('GChandles.mat')
Msync = GC.data;
Msync_base = GCs;
index     = handles.data.indexes { get ( handles.index, 'Value' ) };
threshold = str2double ( get ( handles.threshold, 'String' ) );
threshold = 0.6;
% threshold = 0.95;
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
for ch1 = 1: handles.data.project.channels
    for ch2 = ch1 + 1: handles.data.project.channels
        
        switch handles.asymetric
            case 1 % Asymetric indexes
                
                % Directionality D
                switch index
                    case 'DPI'
                        D = Msync ( ch1, ch2 ) / MM;
                    case 'PSI'
                        D = -Msync ( ch1, ch2 ) / MM;
                    otherwise % if D>0 => Msync(ch1,ch2)>Msync(ch2,ch1) => ch1->ch2
                        D = ( Msync_base ( ch1, ch2 ) - Msync_base ( ch2, ch1 ) ) / ( Msync_base ( ch1, ch2 ) + Msync_base ( ch2, ch1 ) );
                end
                
                D ( isnan ( D ) ) = 0;
                
                % Strength F
                switch mode
                    case 1
                        if D > 0 % ch1 --> ch2
                            F = Msync ( ch1, ch2 ) / MM;
                        else
                            F = Msync ( ch2, ch1 ) / MM;
                        end
                    case 2
                        if D > 0 % ch1 --> ch2
                            F = Msync ( ch1, ch2 ) ;
                        else
                            F = Msync ( ch2, ch1 ) ;
                        end
                end
                % Plot the lines and arrows
                if abs ( F ) > threshold
                    if isnan ( dist( ch1, ch2 ) ) || dist( ch1, ch2 ) >= str2double ( get( handles.distance, 'String' ) )
                        if D > 0 % ch1 --> ch2
                            line ( layout( [ ch1 ch2 ], 1 ), layout( [ ch1 ch2 ], 2 ), ...
                                'Color', [ 0 .75 1 ] + [ 1 -.75 -1 ] * ( F + 1 ) * 0.5, 'LineWidth', 2);
                            arrowh ( layout( [ ch1 ch2 ], 1 ), layout( [ ch1 ch2 ], 2 ), ...
                                [ 0 .75 1 ] + [ 1 -.75 -1 ] * ( F + 1 ) * 0.5, 180 );
                            Rcd(i,1) = ch1;
                            Rcd(i,2) = ch2;
                            Rcd(i,3) = F;
                            i = i+1;
                        else % ch2 --> ch1
                            line ( layout( [ ch1 ch2 ], 1 ), layout( [ ch1 ch2 ], 2 ), ...
                                'Color', [ 0 .75 1 ] + [ 1 -.75 -1 ] * ( F + 1 ) * 0.5, 'LineWidth', 2);
                            arrowh ( layout( [ ch2 ch1 ], 1 ), layout( [ ch2 ch1 ], 2 ), ...
                                [ 0 .75 1 ] + [ 1 -.75 -1 ] * ( F + 1 ) * 0.5, 180 );
                            Rcd(i,1) = ch2;
                            Rcd(i,2) = ch1;
                            Rcd(i,3) = F;
                            i = i+1;
                        end
                    end
                end
                
        end
    end
end

hold off