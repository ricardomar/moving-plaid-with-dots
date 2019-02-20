%
%
% Ricardo Martins
% ICNAS-UC
%
%




% Close (eventually) open connections and PTB screens
IOPort('CloseAll');
Screen('CloseAll'); % equivale a 'sca'
clear all
close all
pack all
clc

% Trick suggested by the PTB authors to avoid synchronization/calibration
% problems
figure(1)
plot(sin(0:0.1:3.14));
% Close figure with sin plot (PTB authors trick for synchronization)
close Figure 1





%%
% Synchronization tests procedure - PTB
% Do you want to skipsync tests (1) or not (0) ?
skipsynctests = 0;
% Size of the text
textsize = 50;

%%

KbName('UnifyKeyNames');

% This variable will become 1 if 'Esc' is pressed
escapekeypress = 0;
% Code to identify "escape" key
escapekeycode = 27;
% Code to identify the key to receive scanner trigger
keytriggercode = 53;


% Keys to control the stimulus while running (thickness, contrast, etc)
xkey = KbName('x');
zkey = KbName('z');
skey = KbName('s');
akey = KbName('a');
wkey = KbName('w');
qkey = KbName('q');
vkey = KbName('v');
bkey = KbName('b');
hkey = KbName('h');
jkey = KbName('j');
kkey = KbName('k');
pkey = KbName('p');
spacekey = KbName('space');




%-------------------%
% Stimuli variables %
%-------------------%

%
% Primitives
%
BaselineRawID=0;

ComponentRawAdaptID=21;
ComponentAltAdaptID=23;
ComponentRawTestID=22;

PatternRawAdaptID=11;
PatternAltAdaptID=13;
PatternRawTestID=12;

AmbiguousAdaptID=55;

%
% 
C_P =  [ComponentRawAdaptID, PatternRawTestID];
P_P =  [PatternRawAdaptID, PatternRawTestID];
na_P = [PatternAltAdaptID,ComponentAltAdaptID,PatternAltAdaptID,ComponentAltAdaptID,PatternAltAdaptID,ComponentAltAdaptID,PatternAltAdaptID,ComponentAltAdaptID, PatternRawTestID];

C_C=[ComponentRawAdaptID,ComponentRawTestID];
P_C=[PatternRawAdaptID,ComponentRawTestID];
na_C=[ComponentAltAdaptID,PatternAltAdaptID,ComponentAltAdaptID,PatternAltAdaptID,ComponentAltAdaptID,PatternAltAdaptID,ComponentAltAdaptID,PatternAltAdaptID, ComponentRawTestID];

Loc_Primitive=[ComponentRawAdaptID,BaselineRawID,PatternRawAdaptID,BaselineRawID,PatternAltAdaptID,ComponentAltAdaptID,PatternAltAdaptID,ComponentAltAdaptID,PatternAltAdaptID,ComponentAltAdaptID,PatternAltAdaptID,ComponentAltAdaptID, BaselineRawID];


%% Protocols
myStimulusProtocolList(1,:) = [BaselineRawID, C_P, BaselineRawID, na_C, BaselineRawID, C_C, BaselineRawID, P_P, BaselineRawID, P_C, BaselineRawID, na_P, BaselineRawID, P_P, BaselineRawID, na_C, BaselineRawID, P_C, BaselineRawID, C_P, BaselineRawID, na_P, BaselineRawID, C_C, BaselineRawID];



% Determine screen resolution
screens = Screen('Screens');
screenNumber = max(screens);
rect = Screen('Rect', screenNumber);


%% determinar propriedades das linhas %%

% MY CODE  
lastFrameBaselineRaw=-10;

lastFrameComponentRawAdapt=-10;
lastFrameComponentAltAdapt=-10;
lastFrameComponentRawTest=-10;

lastFramePatternRawAdapt=-10;
lastFramePatternAltAdapt=-10;
lastFramePatternRawTest=-10;

lastFrameAmbiguousAdapt=-10;

myUpdateMatpress=0;
myEvent='SAMPLE';
myProtocol='SAMPLE';
myWaitResponse=0;
myStarting=struct;
myCycleCounter=1;    

myStimulusProtocol=myStimulusProtocolList(1,:);
protocol_cycles=size(myStimulusProtocol,2);

myAnswer=0;
myStatic=0;
myTextureCounter=1;
myLoadImagesToTexture=1;

try
    % Maximum priority for code to execute
    Priority(2);

    %------------------------------------------------------------%
    %                                                            %
    % Control monitor and perform synchronization tests (if set) %
    %                                                            %
    %------------------------------------------------------------%

    % Perform PTB synchrony tests
    if skipsynctests==1
        Screen('Preference','Verbosity',0);
        Screen('Preference','SkipSyncTests',1);
        Screen('Preference','VisualDebugLevel',0);
    end

    % Start Display
    screens = Screen('Screens');
    screenNumber = max(screens);

    [windowID rect] = Screen('OpenWindow', screenNumber, 0, []);

    %     [windowID rect] = Screen('OpenWindow', screenNumber, 0, [500 100 1500 1000]);
    Screen('BlendFunction', windowID, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);

    % Monitor resolution
    res_x = rect(3);
    res_y = rect(4);


    xcenter = res_x/2;
    ycenter = res_y/2;


    HideCursor

    %--------------------------------&
    %                                %
    % Compute stimuli and properties %
    %                                %
    %--------------------------------%

    distance=120;       
    veloc=2;
    nLoopFrames=floor(distance/veloc);
    espessura=30;
    myAngle=65;
    altura=700;
    myGrayBackgroundCentralWindow=126;
    myGrayLinePlaids=186;
    myGrayBackgroundFullWindow=0; 


    myXcenter=res_x/2;
    myYcenter = res_y/2;            

    espessura_cross=14;
    FixCross = [myXcenter-(sqrt(espessura_cross)),myYcenter-(2*sqrt(espessura_cross)),myXcenter+(sqrt(espessura_cross)),myYcenter+(2*sqrt(espessura_cross));myXcenter-(2*sqrt(espessura_cross)),myYcenter-(sqrt(espessura_cross)),myXcenter+(2*sqrt(espessura_cross)),myYcenter+(sqrt(espessura_cross))]; % Draw Central Cross      

    

    if myLoadImagesToTexture==1
        load('.\img-out\myImageAllFinal_1920_1080.mat');            
        for j=1:nLoopFrames 
            windowtext(j,1) = Screen('MakeTexture', windowID, myImageAllFinal(:,:,j)); 
        end      
    end  







    matpress={};
    numbpress = size(matpress,1);


    frametime = [];








    % Plaid + Points Rendering
    myPlaidIntercept=0; % 0: funde -- 1: separa

    %Point
    myPointLife=5;
    myPointLifeJump=5;


    n_dots_plaid=2800;        
    dots_veloc45_down=4; 
    dots_veloc45_in=3;
    dots_size45=3;
    plaid_border45=1.5;
    dots_xy45=rand(n_dots_plaid,3)*(altura-1);
    dots_xy45(:,3)=round(rand(n_dots_plaid,1)*(myPointLife-1));
    dots_xy45=round(dots_xy45+1);
    dots_square45=zeros(altura,altura,'uint8');
    dots_xy45_perm=randperm(n_dots_plaid);



    dots_veloc_45_down=4;
    dots_veloc_45_in=3;
    dots_size_45=3;
    plaid_border_45=1.5;
    dots_xy_45=rand(n_dots_plaid,3)*(altura-1);
    dots_xy_45(:,3)=round(rand(n_dots_plaid,1)*(myPointLife-1));
    dots_xy_45=round(dots_xy_45+1);
    dots_square_45=zeros(altura,altura,'uint8');
    dots_xy_45_perm=randperm(n_dots_plaid);



    
    % Start recording for frame times
    %frame = 1;
    %numbpress = 0;
    %     tic
    
    % Fill screen with white after calibration
    Screen('FillRect', windowID, 0, []);
    % Tamanho das letras em que Ready aparece escrito
    Screen('TextSize', windowID , textsize);
    Screen('DrawText', windowID, 'Ready...', res_x/2.5, res_y/2.2, [255 0 0]);
    
    % Update screen
    Screen('Flip',windowID);
    
    KbWait;    

    
    

   
    
    
    
    %--------------------------%
    % START time %
    %--------------------------%
    % Start recording for frame times
    frame = 0;  
    myTextureCounter=1;        
    Starttime = GetSecs;

    % Start experiment
    init_time = GetSecs; % initial time of a condition
    current_time = init_time;
    change_time=9999999999;
    
    
    
    %--------------------------%
    % START experiment %
    %--------------------------%    
    % Run while the current time is less than the experiment total time
    while myCycleCounter <= protocol_cycles

        % If current time is higher than the end time of this period, it
        % should change for the next period in the protocol
        if current_time > init_time + change_time
            
            myCycleCounter=myCycleCounter+1;
            % tem de ser antes, dado que na primeira interação (lá no cimo) não adiciono mais +1
            % Restart the initial time for the next period in the protocol
            current_time = GetSecs;
            init_time=current_time;
            
            
            
        end



        if myCycleCounter > protocol_cycles
            break;
        end

        
        if myStimulusProtocol(myCycleCounter)==BaselineRawID
            n_dots_plaid_down=n_dots_plaid;
            dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),4)=1;
            dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),4)=2;
            dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),4)=1;
            dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),4)=2;
            
            if myCycleCounter==1 || myCycleCounter==size(myStimulusProtocol,2)
                change_time=9.0;
            else
                change_time=18.0;
            end
                

            if frame-lastFrameBaselineRaw > 1
                myEvent = 'switch';
                myProtocol = 'baseline-raw';
                myUpdateMatpress=1;
            end
            lastFrameBaselineRaw=frame;



            % textura Plaid e abertura 
            %myTextureCounter=myTextureCounter+1;
            if myTextureCounter > nLoopFrames
                myTextureCounter=1;
            end
            Screen('DrawTextures', windowID, windowtext(myTextureCounter,1) );



            dots_in45=[];
            dots_in_45=[];
            if myPlaidIntercept==0
                for z=1:size(dots_xy45,1)
                    if (myTemplate(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)==255 && myTemplate(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)==255 && myTemplate(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)==255 && myTemplate(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)==255 )
                        dots_in45=[dots_in45,z];
                    end
                    if (myTemplate2(min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,2)),altura),min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,1)),altura),myTextureCounter)==255 && myTemplate2(max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,2)),1),max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,1)),1),myTextureCounter)==255 && myTemplate2(max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,2)),1),min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,1)),altura),myTextureCounter)==255 && myTemplate2(min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,2)),altura),max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,1)),1),myTextureCounter)==255)
                        dots_in_45=[dots_in_45,z];
                    end
                end
            elseif myPlaidIntercept==1
                for z=1:size(dots_xy45,1)
                    if (myTemplate(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)==255 && myTemplate(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)==255 && myTemplate(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)==255 && myTemplate(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)==255 ) && (myTemplate2(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)~=255 && myTemplate2(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)~=255 && myTemplate2(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)~=255 && myTemplate2(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)~=255 ) 
                        dots_in45=[dots_in45,z];
                    end
                    if (myTemplate2(min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,2)),altura),min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,1)),altura),myTextureCounter)==255 && myTemplate2(max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,2)),1),max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,1)),1),myTextureCounter)==255 && myTemplate2(max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,2)),1),min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,1)),altura),myTextureCounter)==255 && myTemplate2(min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,2)),altura),max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,1)),1),myTextureCounter)==255)
                        dots_in_45=[dots_in_45,z];
                    end
                end            
            end            
            Screen('DrawDots', windowID, [xcenter-altura/2+dots_xy45(dots_in45,1)';ycenter-altura/2+dots_xy45(dots_in45,2)'] ,dots_size45 ,[45 45 45]);
            Screen('DrawDots', windowID, [xcenter-altura/2+dots_xy_45(dots_in_45,1)';ycenter-altura/2+dots_xy_45(dots_in_45,2)'] ,dots_size_45 ,[45 45 45]);

            dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),1)=dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),1)+0;
            dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),2)=dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),2)+0;
            dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),3)=dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),3)+1;

            dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),1)=dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),1)+0;
            dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),2)=dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),2)+0;
            dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),3)=dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),3)+1;




            dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),1)=dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),1)-0;
            dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),2)=dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),2)+0;
            dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),3)=dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),3)+1;


            dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),1)=dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),1)-0;
            dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),2)=dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),2)+0;
            dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),3)=dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),3)+1;        


            %
            % bordos
            %
            dots_out45=find((dots_xy45(:,1)<=0 | dots_xy45(:,1)>altura) | (dots_xy45(:,2)<=0 | dots_xy45(:,2)>altura));    
            if ~isempty(dots_out45)
                dots_out45_down=find(dots_xy45(dots_out45,4)==1);
                if ~isempty(dots_out45_down)
                    dots_xy45(dots_out45(dots_out45_down),1)=round(rand(length(dots_out45_down),1)*(altura-1))+1;
                    dots_xy45(dots_out45(dots_out45_down),2)=1;
                    dots_xy45(dots_out45(dots_out45_down),3)=1;
                end
                dots_out45_in=find(dots_xy45(dots_out45,4)==2);
                if ~isempty(dots_out45_in)
                    dots_xy45(dots_out45(dots_out45_in),1)=1;
                    dots_xy45(dots_out45(dots_out45_in),2)=round(rand(length(dots_out45_in),1)*(altura-1))+1;
                    dots_xy45(dots_out45(dots_out45_in),3)=1;
                end
            end

            dots_out_45=find((dots_xy_45(:,1)<=0 | dots_xy_45(:,1)>altura) | (dots_xy_45(:,2)<=0 | dots_xy_45(:,2)>altura));    
            if ~isempty(dots_out_45)
                dots_out_45_down=find(dots_xy_45(dots_out_45,4)==1);
                if ~isempty(dots_out_45_down)
                    dots_xy_45(dots_out_45(dots_out_45_down),1)=round(rand(length(dots_out_45_down),1)*(altura-1))+1;
                    dots_xy_45(dots_out_45(dots_out_45_down),2)=1;
                    dots_xy_45(dots_out_45(dots_out_45_down),3)=1;
                end
                dots_out_45_in=find(dots_xy_45(dots_out_45,4)==2);
                if ~isempty(dots_out_45_in)
                    dots_xy_45(dots_out_45(dots_out_45_in),1)=altura;
                    dots_xy_45(dots_out_45(dots_out_45_in),2)=round(rand(length(dots_out_45_in),1)*(altura-1))+1;
                    dots_xy_45(dots_out_45(dots_out_45_in),3)=1;
                end            
            end



            % Draw central cross
            Screen('FillRect', windowID, [0 0 255], FixCross');                                

            % add one more frame
            frame = frame + 1;
            % get frame time
            frametime(frame) = Screen('Flip',windowID);
            % Get current time
            current_time = frametime(frame);

            if myUpdateMatpress==1
                numbpress=size(matpress,1);
                matpress{numbpress+1, 2} = (frametime(frame) - Starttime);
                matpress{numbpress+1, 1} = myEvent;
                matpress{numbpress+1, 3} = frame;
                matpress{numbpress+1, 4} = myProtocol;
                matpress{numbpress+1, 5} = myCycleCounter;
                matpress{numbpress+1, 6} = '';
                matpress{numbpress+1, 7} = '';
                matpress{numbpress+1, 8} = '';
                matpress{numbpress+1, 9} = '';
                matpress{numbpress+1, 10} = '';
                myUpdateMatpress=0;
            end


        elseif myStimulusProtocol(myCycleCounter)==ComponentRawAdaptID
            n_dots_plaid_down=0;
            dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),4)=1;
            dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),4)=2;
            dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),4)=1;
            dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),4)=2;

            change_time=15.0;

            if frame-lastFrameComponentRawAdapt > 1
                myEvent = 'switch';
                myProtocol = 'component-raw-adapt';
                myUpdateMatpress=1;
            end
            lastFrameComponentRawAdapt=frame;



            % textura Plaid e abertura 
            myTextureCounter=myTextureCounter+1;
            if myTextureCounter > nLoopFrames
                myTextureCounter=1;
            end
            Screen('DrawTextures', windowID, windowtext(myTextureCounter,1) );



            dots_in45=[];
            dots_in_45=[];
            if myPlaidIntercept==0
                for z=1:size(dots_xy45,1)
                    if (myTemplate(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)==255 && myTemplate(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)==255 && myTemplate(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)==255 && myTemplate(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)==255 )
                        dots_in45=[dots_in45,z];
                    end
                    if (myTemplate2(min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,2)),altura),min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,1)),altura),myTextureCounter)==255 && myTemplate2(max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,2)),1),max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,1)),1),myTextureCounter)==255 && myTemplate2(max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,2)),1),min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,1)),altura),myTextureCounter)==255 && myTemplate2(min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,2)),altura),max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,1)),1),myTextureCounter)==255)
                        dots_in_45=[dots_in_45,z];
                    end
                end
            elseif myPlaidIntercept==1
                for z=1:size(dots_xy45,1)
                    if (myTemplate(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)==255 && myTemplate(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)==255 && myTemplate(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)==255 && myTemplate(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)==255 ) && (myTemplate2(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)~=255 && myTemplate2(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)~=255 && myTemplate2(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)~=255 && myTemplate2(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)~=255 ) 
                        dots_in45=[dots_in45,z];
                    end
                    if (myTemplate2(min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,2)),altura),min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,1)),altura),myTextureCounter)==255 && myTemplate2(max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,2)),1),max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,1)),1),myTextureCounter)==255 && myTemplate2(max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,2)),1),min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,1)),altura),myTextureCounter)==255 && myTemplate2(min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,2)),altura),max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,1)),1),myTextureCounter)==255)
                        dots_in_45=[dots_in_45,z];
                    end
                end            
            end            
            Screen('DrawDots', windowID, [xcenter-altura/2+dots_xy45(dots_in45,1)';ycenter-altura/2+dots_xy45(dots_in45,2)'] ,dots_size45 ,[45 45 45]);
            Screen('DrawDots', windowID, [xcenter-altura/2+dots_xy_45(dots_in_45,1)';ycenter-altura/2+dots_xy_45(dots_in_45,2)'] ,dots_size_45 ,[45 45 45]);

            dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),1)=dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),1)+0;
            dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),2)=dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),2)+dots_veloc45_down;
            dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),3)=dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),3)+1;

            dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),1)=dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),1)+dots_veloc45_in;
            dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),2)=dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),2)+0;
            dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),3)=dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),3)+1;




            dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),1)=dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),1)-0;
            dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),2)=dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),2)+dots_veloc_45_down;
            dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),3)=dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),3)+1;


            dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),1)=dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),1)-dots_veloc_45_in;
            dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),2)=dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),2)+0;
            dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),3)=dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),3)+1;        



            %
            % tempo de vida
            %
            dots_out45=find(dots_xy45(:,3)>myPointLife);
            if ~isempty(dots_out45)
                dots_out45_down=find(dots_xy45(dots_out45,4)==1);
                if ~isempty(dots_out45_down)
                    dots_xy45(dots_out45(dots_out45_down),2)=dots_xy45(dots_out45(dots_out45_down),2)+myPointLifeJump*rand(length(dots_out45(dots_out45_down)),1)*dots_veloc45_down;
                    dots_xy45(dots_out45(dots_out45_down),3)=1;
                end
                dots_out45_in=find(dots_xy45(dots_out45,4)==2);
                if ~isempty(dots_out45_in)
                    dots_xy45(dots_out45(dots_out45_in),1)=dots_xy45(dots_out45(dots_out45_in),1)+myPointLifeJump*rand(length(dots_out45(dots_out45_in)),1)*dots_veloc45_in;
                    dots_xy45(dots_out45(dots_out45_in),3)=1;
                end
            end


            dots_out_45=find(dots_xy_45(:,3)>myPointLife);
            if ~isempty(dots_out_45)
                dots_out_45_down=find(dots_xy_45(dots_out_45,4)==1);
                if ~isempty(dots_out_45_down)
                    dots_xy_45(dots_out_45(dots_out_45_down),2)=dots_xy_45(dots_out_45(dots_out_45_down),2)+myPointLifeJump*rand(length(dots_out_45(dots_out_45_down)),1)*dots_veloc_45_down;
                    dots_xy_45(dots_out_45(dots_out_45_down),3)=1;
                end
                dots_out_45_in=find(dots_xy_45(dots_out_45,4)==2);
                if ~isempty(dots_out_45_in)
                    dots_xy_45(dots_out_45(dots_out_45_in),1)=dots_xy_45(dots_out_45(dots_out_45_in),1)-myPointLifeJump*rand(length(dots_out_45(dots_out_45_in)),1)*dots_veloc_45_in;
                    dots_xy_45(dots_out_45(dots_out_45_in),3)=1;
                end            
            end               



            %
            % bordos
            %
            dots_out45=find((dots_xy45(:,1)<=0 | dots_xy45(:,1)>altura) | (dots_xy45(:,2)<=0 | dots_xy45(:,2)>altura));    
            if ~isempty(dots_out45)
                dots_out45_down=find(dots_xy45(dots_out45,4)==1);
                if ~isempty(dots_out45_down)
                    dots_xy45(dots_out45(dots_out45_down),1)=round(rand(length(dots_out45_down),1)*(altura-1))+1;
                    dots_xy45(dots_out45(dots_out45_down),2)=1;
                    dots_xy45(dots_out45(dots_out45_down),3)=1;
                end
                dots_out45_in=find(dots_xy45(dots_out45,4)==2);
                if ~isempty(dots_out45_in)
                    dots_xy45(dots_out45(dots_out45_in),1)=1;
                    dots_xy45(dots_out45(dots_out45_in),2)=round(rand(length(dots_out45_in),1)*(altura-1))+1;
                    dots_xy45(dots_out45(dots_out45_in),3)=1;
                end
            end

            dots_out_45=find((dots_xy_45(:,1)<=0 | dots_xy_45(:,1)>altura) | (dots_xy_45(:,2)<=0 | dots_xy_45(:,2)>altura));    
            if ~isempty(dots_out_45)
                dots_out_45_down=find(dots_xy_45(dots_out_45,4)==1);
                if ~isempty(dots_out_45_down)
                    dots_xy_45(dots_out_45(dots_out_45_down),1)=round(rand(length(dots_out_45_down),1)*(altura-1))+1;
                    dots_xy_45(dots_out_45(dots_out_45_down),2)=1;
                    dots_xy_45(dots_out_45(dots_out_45_down),3)=1;
                end
                dots_out_45_in=find(dots_xy_45(dots_out_45,4)==2);
                if ~isempty(dots_out_45_in)
                    dots_xy_45(dots_out_45(dots_out_45_in),1)=altura;
                    dots_xy_45(dots_out_45(dots_out_45_in),2)=round(rand(length(dots_out_45_in),1)*(altura-1))+1;
                    dots_xy_45(dots_out_45(dots_out_45_in),3)=1;
                end            
            end




            % Draw central cross
            Screen('FillRect', windowID, [255 0 0], FixCross');                                

            % add one more frame
            frame = frame + 1;
            % get frame time
            frametime(frame) = Screen('Flip',windowID);
            % Get current time
            current_time = frametime(frame);

            if myUpdateMatpress==1
                numbpress=size(matpress,1);
                matpress{numbpress+1, 2} = (frametime(frame) - Starttime);
                matpress{numbpress+1, 1} = myEvent;
                matpress{numbpress+1, 3} = frame;
                matpress{numbpress+1, 4} = myProtocol;
                matpress{numbpress+1, 5} = myCycleCounter;
                matpress{numbpress+1, 6} = '';
                matpress{numbpress+1, 7} = '';
                matpress{numbpress+1, 8} = '';
                matpress{numbpress+1, 9} = '';
                matpress{numbpress+1, 10} = '';

                myUpdateMatpress=0;
            end

        elseif myStimulusProtocol(myCycleCounter)==ComponentRawTestID
            n_dots_plaid_down=0;
            dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),4)=1;
            dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),4)=2;
            dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),4)=1;
            dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),4)=2;

            change_time=15.0;

            if frame-lastFrameComponentRawTest > 1
                myEvent = 'switch';
                myProtocol = 'component-raw-test';
                myUpdateMatpress=1;
            end
            lastFrameComponentRawTest=frame;


            % textura Plaid e abertura 
            myTextureCounter=myTextureCounter+1;
            if myTextureCounter > nLoopFrames
                myTextureCounter=1;
            end
            Screen('DrawTextures', windowID, windowtext(myTextureCounter,1) );



            dots_in45=[];
            dots_in_45=[];
            if myPlaidIntercept==0
                for z=1:size(dots_xy45,1)
                    if (myTemplate(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)==255 && myTemplate(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)==255 && myTemplate(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)==255 && myTemplate(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)==255 )
                        dots_in45=[dots_in45,z];
                    end
                    if (myTemplate2(min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,2)),altura),min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,1)),altura),myTextureCounter)==255 && myTemplate2(max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,2)),1),max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,1)),1),myTextureCounter)==255 && myTemplate2(max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,2)),1),min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,1)),altura),myTextureCounter)==255 && myTemplate2(min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,2)),altura),max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,1)),1),myTextureCounter)==255)
                        dots_in_45=[dots_in_45,z];
                    end
                end
            elseif myPlaidIntercept==1
                for z=1:size(dots_xy45,1)
                    if (myTemplate(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)==255 && myTemplate(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)==255 && myTemplate(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)==255 && myTemplate(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)==255 ) && (myTemplate2(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)~=255 && myTemplate2(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)~=255 && myTemplate2(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)~=255 && myTemplate2(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)~=255 ) 
                        dots_in45=[dots_in45,z];
                    end
                    if (myTemplate2(min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,2)),altura),min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,1)),altura),myTextureCounter)==255 && myTemplate2(max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,2)),1),max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,1)),1),myTextureCounter)==255 && myTemplate2(max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,2)),1),min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,1)),altura),myTextureCounter)==255 && myTemplate2(min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,2)),altura),max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,1)),1),myTextureCounter)==255)
                        dots_in_45=[dots_in_45,z];
                    end
                end            
            end            
            Screen('DrawDots', windowID, [xcenter-altura/2+dots_xy45(dots_in45,1)';ycenter-altura/2+dots_xy45(dots_in45,2)'] ,dots_size45 ,[45 45 45]);
            Screen('DrawDots', windowID, [xcenter-altura/2+dots_xy_45(dots_in_45,1)';ycenter-altura/2+dots_xy_45(dots_in_45,2)'] ,dots_size_45 ,[45 45 45]);

            dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),1)=dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),1)+0;
            dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),2)=dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),2)+dots_veloc45_down;
            dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),3)=dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),3)+1;

            dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),1)=dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),1)+dots_veloc45_in;
            dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),2)=dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),2)+0;
            dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),3)=dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),3)+1;




            dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),1)=dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),1)-0;
            dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),2)=dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),2)+dots_veloc_45_down;
            dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),3)=dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),3)+1;


            dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),1)=dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),1)-dots_veloc_45_in;
            dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),2)=dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),2)+0;
            dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),3)=dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),3)+1;        



            %
            % tempo de vida
            %
            dots_out45=find(dots_xy45(:,3)>myPointLife);
            if ~isempty(dots_out45)
                dots_out45_down=find(dots_xy45(dots_out45,4)==1);
                if ~isempty(dots_out45_down)
                    dots_xy45(dots_out45(dots_out45_down),2)=dots_xy45(dots_out45(dots_out45_down),2)+myPointLifeJump*rand(length(dots_out45(dots_out45_down)),1)*dots_veloc45_down;
                    dots_xy45(dots_out45(dots_out45_down),3)=1;
                end
                dots_out45_in=find(dots_xy45(dots_out45,4)==2);
                if ~isempty(dots_out45_in)
                    dots_xy45(dots_out45(dots_out45_in),1)=dots_xy45(dots_out45(dots_out45_in),1)+myPointLifeJump*rand(length(dots_out45(dots_out45_in)),1)*dots_veloc45_in;
                    dots_xy45(dots_out45(dots_out45_in),3)=1;
                end
            end


            dots_out_45=find(dots_xy_45(:,3)>myPointLife);
            if ~isempty(dots_out_45)
                dots_out_45_down=find(dots_xy_45(dots_out_45,4)==1);
                if ~isempty(dots_out_45_down)
                    dots_xy_45(dots_out_45(dots_out_45_down),2)=dots_xy_45(dots_out_45(dots_out_45_down),2)+myPointLifeJump*rand(length(dots_out_45(dots_out_45_down)),1)*dots_veloc_45_down;
                    dots_xy_45(dots_out_45(dots_out_45_down),3)=1;
                end
                dots_out_45_in=find(dots_xy_45(dots_out_45,4)==2);
                if ~isempty(dots_out_45_in)
                    dots_xy_45(dots_out_45(dots_out_45_in),1)=dots_xy_45(dots_out_45(dots_out_45_in),1)-myPointLifeJump*rand(length(dots_out_45(dots_out_45_in)),1)*dots_veloc_45_in;
                    dots_xy_45(dots_out_45(dots_out_45_in),3)=1;
                end            
            end               



            %
            % bordos
            %
            dots_out45=find((dots_xy45(:,1)<=0 | dots_xy45(:,1)>altura) | (dots_xy45(:,2)<=0 | dots_xy45(:,2)>altura));    
            if ~isempty(dots_out45)
                dots_out45_down=find(dots_xy45(dots_out45,4)==1);
                if ~isempty(dots_out45_down)
                    dots_xy45(dots_out45(dots_out45_down),1)=round(rand(length(dots_out45_down),1)*(altura-1))+1;
                    dots_xy45(dots_out45(dots_out45_down),2)=1;
                    dots_xy45(dots_out45(dots_out45_down),3)=1;
                end
                dots_out45_in=find(dots_xy45(dots_out45,4)==2);
                if ~isempty(dots_out45_in)
                    dots_xy45(dots_out45(dots_out45_in),1)=1;
                    dots_xy45(dots_out45(dots_out45_in),2)=round(rand(length(dots_out45_in),1)*(altura-1))+1;
                    dots_xy45(dots_out45(dots_out45_in),3)=1;
                end
            end

            dots_out_45=find((dots_xy_45(:,1)<=0 | dots_xy_45(:,1)>altura) | (dots_xy_45(:,2)<=0 | dots_xy_45(:,2)>altura));    
            if ~isempty(dots_out_45)
                dots_out_45_down=find(dots_xy_45(dots_out_45,4)==1);
                if ~isempty(dots_out_45_down)
                    dots_xy_45(dots_out_45(dots_out_45_down),1)=round(rand(length(dots_out_45_down),1)*(altura-1))+1;
                    dots_xy_45(dots_out_45(dots_out_45_down),2)=1;
                    dots_xy_45(dots_out_45(dots_out_45_down),3)=1;
                end
                dots_out_45_in=find(dots_xy_45(dots_out_45,4)==2);
                if ~isempty(dots_out_45_in)
                    dots_xy_45(dots_out_45(dots_out_45_in),1)=altura;
                    dots_xy_45(dots_out_45(dots_out_45_in),2)=round(rand(length(dots_out_45_in),1)*(altura-1))+1;
                    dots_xy_45(dots_out_45(dots_out_45_in),3)=1;
                end            
            end



            % Draw central cross
            Screen('FillRect', windowID, [0 255 0], FixCross');                                

            % add one more frame
            frame = frame + 1;
            % get frame time
            frametime(frame) = Screen('Flip',windowID);
            % Get current time
            current_time = frametime(frame);

            if myUpdateMatpress==1
                numbpress=size(matpress,1);
                matpress{numbpress+1, 2} = (frametime(frame) - Starttime);
                matpress{numbpress+1, 1} = myEvent;
                matpress{numbpress+1, 3} = frame;
                matpress{numbpress+1, 4} = myProtocol;
                matpress{numbpress+1, 5} = myCycleCounter;
                matpress{numbpress+1, 6} = '';
                matpress{numbpress+1, 7} = '';
                matpress{numbpress+1, 8} = '';
                matpress{numbpress+1, 9} = '';
                matpress{numbpress+1, 10} = '';

                myUpdateMatpress=0;
            end  
        elseif myStimulusProtocol(myCycleCounter)==ComponentAltAdaptID
            n_dots_plaid_down=0;
            dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),4)=1;
            dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),4)=2;
            dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),4)=1;
            dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),4)=2;

            change_time=1.875;

            if frame-lastFrameComponentAltAdapt > 1
                myEvent = 'switch';
                myProtocol = 'component-alt-adapt';
                myUpdateMatpress=1;
            end
            lastFrameComponentAltAdapt=frame;



            % textura Plaid e abertura 
            myTextureCounter=myTextureCounter+1;
            if myTextureCounter > nLoopFrames
                myTextureCounter=1;
            end
            Screen('DrawTextures', windowID, windowtext(myTextureCounter,1) );



            dots_in45=[];
            dots_in_45=[];
            if myPlaidIntercept==0
                for z=1:size(dots_xy45,1)
                    if (myTemplate(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)==255 && myTemplate(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)==255 && myTemplate(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)==255 && myTemplate(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)==255 )
                        dots_in45=[dots_in45,z];
                    end
                    if (myTemplate2(min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,2)),altura),min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,1)),altura),myTextureCounter)==255 && myTemplate2(max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,2)),1),max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,1)),1),myTextureCounter)==255 && myTemplate2(max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,2)),1),min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,1)),altura),myTextureCounter)==255 && myTemplate2(min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,2)),altura),max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,1)),1),myTextureCounter)==255)
                        dots_in_45=[dots_in_45,z];
                    end
                end
            elseif myPlaidIntercept==1
                for z=1:size(dots_xy45,1)
                    if (myTemplate(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)==255 && myTemplate(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)==255 && myTemplate(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)==255 && myTemplate(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)==255 ) && (myTemplate2(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)~=255 && myTemplate2(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)~=255 && myTemplate2(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)~=255 && myTemplate2(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)~=255 ) 
                        dots_in45=[dots_in45,z];
                    end
                    if (myTemplate2(min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,2)),altura),min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,1)),altura),myTextureCounter)==255 && myTemplate2(max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,2)),1),max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,1)),1),myTextureCounter)==255 && myTemplate2(max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,2)),1),min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,1)),altura),myTextureCounter)==255 && myTemplate2(min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,2)),altura),max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,1)),1),myTextureCounter)==255)
                        dots_in_45=[dots_in_45,z];
                    end
                end            
            end            
            Screen('DrawDots', windowID, [xcenter-altura/2+dots_xy45(dots_in45,1)';ycenter-altura/2+dots_xy45(dots_in45,2)'] ,dots_size45 ,[45 45 45]);
            Screen('DrawDots', windowID, [xcenter-altura/2+dots_xy_45(dots_in_45,1)';ycenter-altura/2+dots_xy_45(dots_in_45,2)'] ,dots_size_45 ,[45 45 45]);

            dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),1)=dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),1)+0;
            dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),2)=dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),2)+dots_veloc45_down;
            dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),3)=dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),3)+1;

            dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),1)=dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),1)+dots_veloc45_in;
            dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),2)=dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),2)+0;
            dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),3)=dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),3)+1;




            dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),1)=dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),1)-0;
            dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),2)=dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),2)+dots_veloc_45_down;
            dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),3)=dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),3)+1;


            dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),1)=dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),1)-dots_veloc_45_in;
            dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),2)=dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),2)+0;
            dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),3)=dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),3)+1;        



            %
            % tempo de vida
            %
            dots_out45=find(dots_xy45(:,3)>myPointLife);
            if ~isempty(dots_out45)
                dots_out45_down=find(dots_xy45(dots_out45,4)==1);
                if ~isempty(dots_out45_down)
                    dots_xy45(dots_out45(dots_out45_down),2)=dots_xy45(dots_out45(dots_out45_down),2)+myPointLifeJump*rand(length(dots_out45(dots_out45_down)),1)*dots_veloc45_down;
                    dots_xy45(dots_out45(dots_out45_down),3)=1;
                end
                dots_out45_in=find(dots_xy45(dots_out45,4)==2);
                if ~isempty(dots_out45_in)
                    dots_xy45(dots_out45(dots_out45_in),1)=dots_xy45(dots_out45(dots_out45_in),1)+myPointLifeJump*rand(length(dots_out45(dots_out45_in)),1)*dots_veloc45_in;
                    dots_xy45(dots_out45(dots_out45_in),3)=1;
                end
            end


            dots_out_45=find(dots_xy_45(:,3)>myPointLife);
            if ~isempty(dots_out_45)
                dots_out_45_down=find(dots_xy_45(dots_out_45,4)==1);
                if ~isempty(dots_out_45_down)
                    dots_xy_45(dots_out_45(dots_out_45_down),2)=dots_xy_45(dots_out_45(dots_out_45_down),2)+myPointLifeJump*rand(length(dots_out_45(dots_out_45_down)),1)*dots_veloc_45_down;
                    dots_xy_45(dots_out_45(dots_out_45_down),3)=1;
                end
                dots_out_45_in=find(dots_xy_45(dots_out_45,4)==2);
                if ~isempty(dots_out_45_in)
                    dots_xy_45(dots_out_45(dots_out_45_in),1)=dots_xy_45(dots_out_45(dots_out_45_in),1)-myPointLifeJump*rand(length(dots_out_45(dots_out_45_in)),1)*dots_veloc_45_in;
                    dots_xy_45(dots_out_45(dots_out_45_in),3)=1;
                end            
            end               



            %
            % bordos
            %
            dots_out45=find((dots_xy45(:,1)<=0 | dots_xy45(:,1)>altura) | (dots_xy45(:,2)<=0 | dots_xy45(:,2)>altura));    
            if ~isempty(dots_out45)
                dots_out45_down=find(dots_xy45(dots_out45,4)==1);
                if ~isempty(dots_out45_down)
                    dots_xy45(dots_out45(dots_out45_down),1)=round(rand(length(dots_out45_down),1)*(altura-1))+1;
                    dots_xy45(dots_out45(dots_out45_down),2)=1;
                    dots_xy45(dots_out45(dots_out45_down),3)=1;
                end
                dots_out45_in=find(dots_xy45(dots_out45,4)==2);
                if ~isempty(dots_out45_in)
                    dots_xy45(dots_out45(dots_out45_in),1)=1;
                    dots_xy45(dots_out45(dots_out45_in),2)=round(rand(length(dots_out45_in),1)*(altura-1))+1;
                    dots_xy45(dots_out45(dots_out45_in),3)=1;
                end
            end

            dots_out_45=find((dots_xy_45(:,1)<=0 | dots_xy_45(:,1)>altura) | (dots_xy_45(:,2)<=0 | dots_xy_45(:,2)>altura));    
            if ~isempty(dots_out_45)
                dots_out_45_down=find(dots_xy_45(dots_out_45,4)==1);
                if ~isempty(dots_out_45_down)
                    dots_xy_45(dots_out_45(dots_out_45_down),1)=round(rand(length(dots_out_45_down),1)*(altura-1))+1;
                    dots_xy_45(dots_out_45(dots_out_45_down),2)=1;
                    dots_xy_45(dots_out_45(dots_out_45_down),3)=1;
                end
                dots_out_45_in=find(dots_xy_45(dots_out_45,4)==2);
                if ~isempty(dots_out_45_in)
                    dots_xy_45(dots_out_45(dots_out_45_in),1)=altura;
                    dots_xy_45(dots_out_45(dots_out_45_in),2)=round(rand(length(dots_out_45_in),1)*(altura-1))+1;
                    dots_xy_45(dots_out_45(dots_out_45_in),3)=1;
                end            
            end





            % Draw central cross
            Screen('FillRect', windowID, [255 0 0], FixCross');                                

            % add one more frame
            frame = frame + 1;
            % get frame time
            frametime(frame) = Screen('Flip',windowID);
            % Get current time
            current_time = frametime(frame);

            if myUpdateMatpress==1
                numbpress=size(matpress,1);
                matpress{numbpress+1, 2} = (frametime(frame) - Starttime);
                matpress{numbpress+1, 1} = myEvent;
                matpress{numbpress+1, 3} = frame;
                matpress{numbpress+1, 4} = myProtocol;
                matpress{numbpress+1, 5} = myCycleCounter;
                matpress{numbpress+1, 6} = '';
                matpress{numbpress+1, 7} = '';
                matpress{numbpress+1, 8} = '';
                matpress{numbpress+1, 9} = '';
                matpress{numbpress+1, 10} = '';

                myUpdateMatpress=0;
            end                 


        elseif myStimulusProtocol(myCycleCounter)==PatternRawAdaptID
            n_dots_plaid_down=n_dots_plaid;
            dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),4)=1;
            dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),4)=2;
            dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),4)=1;
            dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),4)=2;

            change_time=15.0;

            if frame-lastFramePatternRawAdapt > 1
                myEvent = 'switch';
                myProtocol = 'pattern-raw-adapt';
                myUpdateMatpress=1;
            end
            lastFramePatternRawAdapt=frame;


            % textura Plaid e abertura 
            myTextureCounter=myTextureCounter+1;
            if myTextureCounter > nLoopFrames
                myTextureCounter=1;
            end
            Screen('DrawTextures', windowID, windowtext(myTextureCounter,1) );



            dots_in45=[];
            dots_in_45=[];
            if myPlaidIntercept==0
                for z=1:size(dots_xy45,1)
                    if (myTemplate(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)==255 && myTemplate(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)==255 && myTemplate(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)==255 && myTemplate(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)==255 )
                        dots_in45=[dots_in45,z];
                    end
                    if (myTemplate2(min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,2)),altura),min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,1)),altura),myTextureCounter)==255 && myTemplate2(max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,2)),1),max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,1)),1),myTextureCounter)==255 && myTemplate2(max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,2)),1),min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,1)),altura),myTextureCounter)==255 && myTemplate2(min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,2)),altura),max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,1)),1),myTextureCounter)==255)
                        dots_in_45=[dots_in_45,z];
                    end
                end
            elseif myPlaidIntercept==1
                for z=1:size(dots_xy45,1)
                    if (myTemplate(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)==255 && myTemplate(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)==255 && myTemplate(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)==255 && myTemplate(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)==255 ) && (myTemplate2(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)~=255 && myTemplate2(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)~=255 && myTemplate2(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)~=255 && myTemplate2(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)~=255 ) 
                        dots_in45=[dots_in45,z];
                    end
                    if (myTemplate2(min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,2)),altura),min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,1)),altura),myTextureCounter)==255 && myTemplate2(max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,2)),1),max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,1)),1),myTextureCounter)==255 && myTemplate2(max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,2)),1),min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,1)),altura),myTextureCounter)==255 && myTemplate2(min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,2)),altura),max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,1)),1),myTextureCounter)==255)
                        dots_in_45=[dots_in_45,z];
                    end
                end            
            end            
            Screen('DrawDots', windowID, [xcenter-altura/2+dots_xy45(dots_in45,1)';ycenter-altura/2+dots_xy45(dots_in45,2)'] ,dots_size45 ,[45 45 45]);
            Screen('DrawDots', windowID, [xcenter-altura/2+dots_xy_45(dots_in_45,1)';ycenter-altura/2+dots_xy_45(dots_in_45,2)'] ,dots_size_45 ,[45 45 45]);

            dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),1)=dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),1)+0;
            dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),2)=dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),2)+dots_veloc45_down;
            dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),3)=dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),3)+1;

            dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),1)=dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),1)+dots_veloc45_in;
            dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),2)=dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),2)+0;
            dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),3)=dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),3)+1;




            dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),1)=dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),1)-0;
            dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),2)=dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),2)+dots_veloc_45_down;
            dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),3)=dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),3)+1;


            dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),1)=dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),1)-dots_veloc_45_in;
            dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),2)=dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),2)+0;
            dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),3)=dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),3)+1;        



            %
            % tempo de vida
            %
            dots_out45=find(dots_xy45(:,3)>myPointLife);
            if ~isempty(dots_out45)
                dots_out45_down=find(dots_xy45(dots_out45,4)==1);
                if ~isempty(dots_out45_down)
                    dots_xy45(dots_out45(dots_out45_down),2)=dots_xy45(dots_out45(dots_out45_down),2)+myPointLifeJump*rand(length(dots_out45(dots_out45_down)),1)*dots_veloc45_down;
                    dots_xy45(dots_out45(dots_out45_down),3)=1;
                end
                dots_out45_in=find(dots_xy45(dots_out45,4)==2);
                if ~isempty(dots_out45_in)
                    dots_xy45(dots_out45(dots_out45_in),1)=dots_xy45(dots_out45(dots_out45_in),1)+myPointLifeJump*rand(length(dots_out45(dots_out45_in)),1)*dots_veloc45_in;
                    dots_xy45(dots_out45(dots_out45_in),3)=1;
                end
            end


            dots_out_45=find(dots_xy_45(:,3)>myPointLife);
            if ~isempty(dots_out_45)
                dots_out_45_down=find(dots_xy_45(dots_out_45,4)==1);
                if ~isempty(dots_out_45_down)
                    dots_xy_45(dots_out_45(dots_out_45_down),2)=dots_xy_45(dots_out_45(dots_out_45_down),2)+myPointLifeJump*rand(length(dots_out_45(dots_out_45_down)),1)*dots_veloc_45_down;
                    dots_xy_45(dots_out_45(dots_out_45_down),3)=1;
                end
                dots_out_45_in=find(dots_xy_45(dots_out_45,4)==2);
                if ~isempty(dots_out_45_in)
                    dots_xy_45(dots_out_45(dots_out_45_in),1)=dots_xy_45(dots_out_45(dots_out_45_in),1)-myPointLifeJump*rand(length(dots_out_45(dots_out_45_in)),1)*dots_veloc_45_in;
                    dots_xy_45(dots_out_45(dots_out_45_in),3)=1;
                end            
            end               



            %
            % bordos
            %
            dots_out45=find((dots_xy45(:,1)<=0 | dots_xy45(:,1)>altura) | (dots_xy45(:,2)<=0 | dots_xy45(:,2)>altura));    
            if ~isempty(dots_out45)
                dots_out45_down=find(dots_xy45(dots_out45,4)==1);
                if ~isempty(dots_out45_down)
                    dots_xy45(dots_out45(dots_out45_down),1)=round(rand(length(dots_out45_down),1)*(altura-1))+1;
                    dots_xy45(dots_out45(dots_out45_down),2)=1;
                    dots_xy45(dots_out45(dots_out45_down),3)=1;
                end
                dots_out45_in=find(dots_xy45(dots_out45,4)==2);
                if ~isempty(dots_out45_in)
                    dots_xy45(dots_out45(dots_out45_in),1)=1;
                    dots_xy45(dots_out45(dots_out45_in),2)=round(rand(length(dots_out45_in),1)*(altura-1))+1;
                    dots_xy45(dots_out45(dots_out45_in),3)=1;
                end
            end

            dots_out_45=find((dots_xy_45(:,1)<=0 | dots_xy_45(:,1)>altura) | (dots_xy_45(:,2)<=0 | dots_xy_45(:,2)>altura));    
            if ~isempty(dots_out_45)
                dots_out_45_down=find(dots_xy_45(dots_out_45,4)==1);
                if ~isempty(dots_out_45_down)
                    dots_xy_45(dots_out_45(dots_out_45_down),1)=round(rand(length(dots_out_45_down),1)*(altura-1))+1;
                    dots_xy_45(dots_out_45(dots_out_45_down),2)=1;
                    dots_xy_45(dots_out_45(dots_out_45_down),3)=1;
                end
                dots_out_45_in=find(dots_xy_45(dots_out_45,4)==2);
                if ~isempty(dots_out_45_in)
                    dots_xy_45(dots_out_45(dots_out_45_in),1)=altura;
                    dots_xy_45(dots_out_45(dots_out_45_in),2)=round(rand(length(dots_out_45_in),1)*(altura-1))+1;
                    dots_xy_45(dots_out_45(dots_out_45_in),3)=1;
                end            
            end                




            % Draw central cross
            Screen('FillRect', windowID, [255 0 0], FixCross');                                

            % add one more frame
            frame = frame + 1;
            % get frame time
            frametime(frame) = Screen('Flip',windowID);
            % Get current time
            current_time = frametime(frame);

            if myUpdateMatpress==1
                numbpress=size(matpress,1);
                matpress{numbpress+1, 2} = (frametime(frame) - Starttime);
                matpress{numbpress+1, 1} = myEvent;
                matpress{numbpress+1, 3} = frame;
                matpress{numbpress+1, 4} = myProtocol;
                matpress{numbpress+1, 5} = myCycleCounter;
                matpress{numbpress+1, 6} = '';
                matpress{numbpress+1, 7} = '';
                matpress{numbpress+1, 8} = '';
                matpress{numbpress+1, 9} = '';
                matpress{numbpress+1, 10} = '';

                myUpdateMatpress=0;
            end                 

        elseif myStimulusProtocol(myCycleCounter)==PatternRawTestID
            n_dots_plaid_down=n_dots_plaid;
            dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),4)=1;
            dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),4)=2;
            dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),4)=1;
            dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),4)=2;

            change_time=15.0;

            if frame-lastFramePatternRawTest > 1
                myEvent = 'switch';
                myProtocol = 'pattern-raw-test';
                myUpdateMatpress=1;
            end
            lastFramePatternRawTest=frame;

            % textura Plaid e abertura 
            myTextureCounter=myTextureCounter+1;
            if myTextureCounter > nLoopFrames
                myTextureCounter=1;
            end
            Screen('DrawTextures', windowID, windowtext(myTextureCounter,1) );



            dots_in45=[];
            dots_in_45=[];
            if myPlaidIntercept==0
                for z=1:size(dots_xy45,1)
                    if (myTemplate(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)==255 && myTemplate(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)==255 && myTemplate(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)==255 && myTemplate(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)==255 )
                        dots_in45=[dots_in45,z];
                    end
                    if (myTemplate2(min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,2)),altura),min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,1)),altura),myTextureCounter)==255 && myTemplate2(max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,2)),1),max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,1)),1),myTextureCounter)==255 && myTemplate2(max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,2)),1),min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,1)),altura),myTextureCounter)==255 && myTemplate2(min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,2)),altura),max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,1)),1),myTextureCounter)==255)
                        dots_in_45=[dots_in_45,z];
                    end
                end
            elseif myPlaidIntercept==1
                for z=1:size(dots_xy45,1)
                    if (myTemplate(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)==255 && myTemplate(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)==255 && myTemplate(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)==255 && myTemplate(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)==255 ) && (myTemplate2(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)~=255 && myTemplate2(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)~=255 && myTemplate2(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)~=255 && myTemplate2(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)~=255 ) 
                        dots_in45=[dots_in45,z];
                    end
                    if (myTemplate2(min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,2)),altura),min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,1)),altura),myTextureCounter)==255 && myTemplate2(max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,2)),1),max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,1)),1),myTextureCounter)==255 && myTemplate2(max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,2)),1),min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,1)),altura),myTextureCounter)==255 && myTemplate2(min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,2)),altura),max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,1)),1),myTextureCounter)==255)
                        dots_in_45=[dots_in_45,z];
                    end
                end            
            end            
            Screen('DrawDots', windowID, [xcenter-altura/2+dots_xy45(dots_in45,1)';ycenter-altura/2+dots_xy45(dots_in45,2)'] ,dots_size45 ,[45 45 45]);
            Screen('DrawDots', windowID, [xcenter-altura/2+dots_xy_45(dots_in_45,1)';ycenter-altura/2+dots_xy_45(dots_in_45,2)'] ,dots_size_45 ,[45 45 45]);

            dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),1)=dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),1)+0;
            dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),2)=dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),2)+dots_veloc45_down;
            dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),3)=dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),3)+1;

            dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),1)=dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),1)+dots_veloc45_in;
            dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),2)=dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),2)+0;
            dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),3)=dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),3)+1;




            dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),1)=dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),1)-0;
            dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),2)=dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),2)+dots_veloc_45_down;
            dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),3)=dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),3)+1;


            dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),1)=dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),1)-dots_veloc_45_in;
            dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),2)=dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),2)+0;
            dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),3)=dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),3)+1;        



            %
            % tempo de vida
            %
            dots_out45=find(dots_xy45(:,3)>myPointLife);
            if ~isempty(dots_out45)
                dots_out45_down=find(dots_xy45(dots_out45,4)==1);
                if ~isempty(dots_out45_down)
                    dots_xy45(dots_out45(dots_out45_down),2)=dots_xy45(dots_out45(dots_out45_down),2)+myPointLifeJump*rand(length(dots_out45(dots_out45_down)),1)*dots_veloc45_down;
                    dots_xy45(dots_out45(dots_out45_down),3)=1;
                end
                dots_out45_in=find(dots_xy45(dots_out45,4)==2);
                if ~isempty(dots_out45_in)
                    dots_xy45(dots_out45(dots_out45_in),1)=dots_xy45(dots_out45(dots_out45_in),1)+myPointLifeJump*rand(length(dots_out45(dots_out45_in)),1)*dots_veloc45_in;
                    dots_xy45(dots_out45(dots_out45_in),3)=1;
                end
            end


            dots_out_45=find(dots_xy_45(:,3)>myPointLife);
            if ~isempty(dots_out_45)
                dots_out_45_down=find(dots_xy_45(dots_out_45,4)==1);
                if ~isempty(dots_out_45_down)
                    dots_xy_45(dots_out_45(dots_out_45_down),2)=dots_xy_45(dots_out_45(dots_out_45_down),2)+myPointLifeJump*rand(length(dots_out_45(dots_out_45_down)),1)*dots_veloc_45_down;
                    dots_xy_45(dots_out_45(dots_out_45_down),3)=1;
                end
                dots_out_45_in=find(dots_xy_45(dots_out_45,4)==2);
                if ~isempty(dots_out_45_in)
                    dots_xy_45(dots_out_45(dots_out_45_in),1)=dots_xy_45(dots_out_45(dots_out_45_in),1)-myPointLifeJump*rand(length(dots_out_45(dots_out_45_in)),1)*dots_veloc_45_in;
                    dots_xy_45(dots_out_45(dots_out_45_in),3)=1;
                end            
            end               



            %
            % bordos
            %
            dots_out45=find((dots_xy45(:,1)<=0 | dots_xy45(:,1)>altura) | (dots_xy45(:,2)<=0 | dots_xy45(:,2)>altura));    
            if ~isempty(dots_out45)
                dots_out45_down=find(dots_xy45(dots_out45,4)==1);
                if ~isempty(dots_out45_down)
                    dots_xy45(dots_out45(dots_out45_down),1)=round(rand(length(dots_out45_down),1)*(altura-1))+1;
                    dots_xy45(dots_out45(dots_out45_down),2)=1;
                    dots_xy45(dots_out45(dots_out45_down),3)=1;
                end
                dots_out45_in=find(dots_xy45(dots_out45,4)==2);
                if ~isempty(dots_out45_in)
                    dots_xy45(dots_out45(dots_out45_in),1)=1;
                    dots_xy45(dots_out45(dots_out45_in),2)=round(rand(length(dots_out45_in),1)*(altura-1))+1;
                    dots_xy45(dots_out45(dots_out45_in),3)=1;
                end
            end

            dots_out_45=find((dots_xy_45(:,1)<=0 | dots_xy_45(:,1)>altura) | (dots_xy_45(:,2)<=0 | dots_xy_45(:,2)>altura));    
            if ~isempty(dots_out_45)
                dots_out_45_down=find(dots_xy_45(dots_out_45,4)==1);
                if ~isempty(dots_out_45_down)
                    dots_xy_45(dots_out_45(dots_out_45_down),1)=round(rand(length(dots_out_45_down),1)*(altura-1))+1;
                    dots_xy_45(dots_out_45(dots_out_45_down),2)=1;
                    dots_xy_45(dots_out_45(dots_out_45_down),3)=1;
                end
                dots_out_45_in=find(dots_xy_45(dots_out_45,4)==2);
                if ~isempty(dots_out_45_in)
                    dots_xy_45(dots_out_45(dots_out_45_in),1)=altura;
                    dots_xy_45(dots_out_45(dots_out_45_in),2)=round(rand(length(dots_out_45_in),1)*(altura-1))+1;
                    dots_xy_45(dots_out_45(dots_out_45_in),3)=1;
                end            
            end                


            % Draw central cross
            Screen('FillRect', windowID, [0 255 0], FixCross');                                

            % add one more frame
            frame = frame + 1;
            % get frame time
            frametime(frame) = Screen('Flip',windowID);
            % Get current time
            current_time = frametime(frame);

            if myUpdateMatpress==1
                numbpress=size(matpress,1);
                matpress{numbpress+1, 2} = (frametime(frame) - Starttime);
                matpress{numbpress+1, 1} = myEvent;
                matpress{numbpress+1, 3} = frame;
                matpress{numbpress+1, 4} = myProtocol;
                matpress{numbpress+1, 5} = myCycleCounter;
                matpress{numbpress+1, 6} = '';
                matpress{numbpress+1, 7} = '';
                matpress{numbpress+1, 8} = '';
                matpress{numbpress+1, 9} = '';
                matpress{numbpress+1, 10} = '';

                myUpdateMatpress=0;
            end   

        elseif myStimulusProtocol(myCycleCounter)==PatternAltAdaptID
            n_dots_plaid_down=n_dots_plaid;
            dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),4)=1;
            dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),4)=2;
            dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),4)=1;
            dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),4)=2;

            change_time=1.875;

            if frame-lastFramePatternAltAdapt > 1
                myEvent = 'switch';
                myProtocol = 'pattern-alt-adapt';
                myUpdateMatpress=1;
            end
            lastFramePatternAltAdapt=frame;

            % textura Plaid e abertura 
            myTextureCounter=myTextureCounter+1;
            if myTextureCounter > nLoopFrames
                myTextureCounter=1;
            end
            Screen('DrawTextures', windowID, windowtext(myTextureCounter,1) );



            dots_in45=[];
            dots_in_45=[];
            if myPlaidIntercept==0
                for z=1:size(dots_xy45,1)
                    if (myTemplate(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)==255 && myTemplate(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)==255 && myTemplate(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)==255 && myTemplate(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)==255 )
                        dots_in45=[dots_in45,z];
                    end
                    if (myTemplate2(min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,2)),altura),min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,1)),altura),myTextureCounter)==255 && myTemplate2(max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,2)),1),max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,1)),1),myTextureCounter)==255 && myTemplate2(max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,2)),1),min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,1)),altura),myTextureCounter)==255 && myTemplate2(min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,2)),altura),max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,1)),1),myTextureCounter)==255)
                        dots_in_45=[dots_in_45,z];
                    end
                end
            elseif myPlaidIntercept==1
                for z=1:size(dots_xy45,1)
                    if (myTemplate(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)==255 && myTemplate(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)==255 && myTemplate(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)==255 && myTemplate(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)==255 ) && (myTemplate2(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)~=255 && myTemplate2(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)~=255 && myTemplate2(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)~=255 && myTemplate2(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)~=255 ) 
                        dots_in45=[dots_in45,z];
                    end
                    if (myTemplate2(min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,2)),altura),min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,1)),altura),myTextureCounter)==255 && myTemplate2(max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,2)),1),max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,1)),1),myTextureCounter)==255 && myTemplate2(max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,2)),1),min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,1)),altura),myTextureCounter)==255 && myTemplate2(min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,2)),altura),max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,1)),1),myTextureCounter)==255)
                        dots_in_45=[dots_in_45,z];
                    end
                end            
            end            
            Screen('DrawDots', windowID, [xcenter-altura/2+dots_xy45(dots_in45,1)';ycenter-altura/2+dots_xy45(dots_in45,2)'] ,dots_size45 ,[45 45 45]);
            Screen('DrawDots', windowID, [xcenter-altura/2+dots_xy_45(dots_in_45,1)';ycenter-altura/2+dots_xy_45(dots_in_45,2)'] ,dots_size_45 ,[45 45 45]);

            dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),1)=dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),1)+0;
            dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),2)=dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),2)+dots_veloc45_down;
            dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),3)=dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),3)+1;

            dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),1)=dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),1)+dots_veloc45_in;
            dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),2)=dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),2)+0;
            dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),3)=dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),3)+1;




            dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),1)=dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),1)-0;
            dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),2)=dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),2)+dots_veloc_45_down;
            dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),3)=dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),3)+1;


            dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),1)=dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),1)-dots_veloc_45_in;
            dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),2)=dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),2)+0;
            dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),3)=dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),3)+1;        



            %
            % tempo de vida
            %
            dots_out45=find(dots_xy45(:,3)>myPointLife);
            if ~isempty(dots_out45)
                dots_out45_down=find(dots_xy45(dots_out45,4)==1);
                if ~isempty(dots_out45_down)
                    dots_xy45(dots_out45(dots_out45_down),2)=dots_xy45(dots_out45(dots_out45_down),2)+myPointLifeJump*rand(length(dots_out45(dots_out45_down)),1)*dots_veloc45_down;
                    dots_xy45(dots_out45(dots_out45_down),3)=1;
                end
                dots_out45_in=find(dots_xy45(dots_out45,4)==2);
                if ~isempty(dots_out45_in)
                    dots_xy45(dots_out45(dots_out45_in),1)=dots_xy45(dots_out45(dots_out45_in),1)+myPointLifeJump*rand(length(dots_out45(dots_out45_in)),1)*dots_veloc45_in;
                    dots_xy45(dots_out45(dots_out45_in),3)=1;
                end
            end


            dots_out_45=find(dots_xy_45(:,3)>myPointLife);
            if ~isempty(dots_out_45)
                dots_out_45_down=find(dots_xy_45(dots_out_45,4)==1);
                if ~isempty(dots_out_45_down)
                    dots_xy_45(dots_out_45(dots_out_45_down),2)=dots_xy_45(dots_out_45(dots_out_45_down),2)+myPointLifeJump*rand(length(dots_out_45(dots_out_45_down)),1)*dots_veloc_45_down;
                    dots_xy_45(dots_out_45(dots_out_45_down),3)=1;
                end
                dots_out_45_in=find(dots_xy_45(dots_out_45,4)==2);
                if ~isempty(dots_out_45_in)
                    dots_xy_45(dots_out_45(dots_out_45_in),1)=dots_xy_45(dots_out_45(dots_out_45_in),1)-myPointLifeJump*rand(length(dots_out_45(dots_out_45_in)),1)*dots_veloc_45_in;
                    dots_xy_45(dots_out_45(dots_out_45_in),3)=1;
                end            
            end               



            %
            % bordos
            %
            dots_out45=find((dots_xy45(:,1)<=0 | dots_xy45(:,1)>altura) | (dots_xy45(:,2)<=0 | dots_xy45(:,2)>altura));    
            if ~isempty(dots_out45)
                dots_out45_down=find(dots_xy45(dots_out45,4)==1);
                if ~isempty(dots_out45_down)
                    dots_xy45(dots_out45(dots_out45_down),1)=round(rand(length(dots_out45_down),1)*(altura-1))+1;
                    dots_xy45(dots_out45(dots_out45_down),2)=1;
                    dots_xy45(dots_out45(dots_out45_down),3)=1;
                end
                dots_out45_in=find(dots_xy45(dots_out45,4)==2);
                if ~isempty(dots_out45_in)
                    dots_xy45(dots_out45(dots_out45_in),1)=1;
                    dots_xy45(dots_out45(dots_out45_in),2)=round(rand(length(dots_out45_in),1)*(altura-1))+1;
                    dots_xy45(dots_out45(dots_out45_in),3)=1;
                end
            end

            dots_out_45=find((dots_xy_45(:,1)<=0 | dots_xy_45(:,1)>altura) | (dots_xy_45(:,2)<=0 | dots_xy_45(:,2)>altura));    
            if ~isempty(dots_out_45)
                dots_out_45_down=find(dots_xy_45(dots_out_45,4)==1);
                if ~isempty(dots_out_45_down)
                    dots_xy_45(dots_out_45(dots_out_45_down),1)=round(rand(length(dots_out_45_down),1)*(altura-1))+1;
                    dots_xy_45(dots_out_45(dots_out_45_down),2)=1;
                    dots_xy_45(dots_out_45(dots_out_45_down),3)=1;
                end
                dots_out_45_in=find(dots_xy_45(dots_out_45,4)==2);
                if ~isempty(dots_out_45_in)
                    dots_xy_45(dots_out_45(dots_out_45_in),1)=altura;
                    dots_xy_45(dots_out_45(dots_out_45_in),2)=round(rand(length(dots_out_45_in),1)*(altura-1))+1;
                    dots_xy_45(dots_out_45(dots_out_45_in),3)=1;
                end            
            end                



            % Draw central cross
            Screen('FillRect', windowID, [255 0 0], FixCross');                                

            % add one more frame
            frame = frame + 1;
            % get frame time
            frametime(frame) = Screen('Flip',windowID);
            % Get current time
            current_time = frametime(frame);

            if myUpdateMatpress==1
                numbpress=size(matpress,1);
                matpress{numbpress+1, 2} = (frametime(frame) - Starttime);
                matpress{numbpress+1, 1} = myEvent;
                matpress{numbpress+1, 3} = frame;
                matpress{numbpress+1, 4} = myProtocol;
                matpress{numbpress+1, 5} = myCycleCounter;
                matpress{numbpress+1, 6} = '';
                matpress{numbpress+1, 7} = '';
                matpress{numbpress+1, 8} = '';
                matpress{numbpress+1, 9} = '';
                matpress{numbpress+1, 10} = '';

                myUpdateMatpress=0;
            end   



        elseif myStimulusProtocol(myCycleCounter)==AmbiguousAdaptID
            n_dots_plaid_down=1400;
            dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),4)=1;
            dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),4)=2;
            dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),4)=1;
            dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),4)=2;

            change_time=15.0;

            if frame-lastFrameAmbiguousAdapt > 1
                myEvent = 'switch';
                myProtocol = 'ambiguous-adapt';
                myUpdateMatpress=1;
            end
            lastFrameAmbiguousAdapt=frame;

            % textura Plaid e abertura 
            myTextureCounter=myTextureCounter+1;
            if myTextureCounter > nLoopFrames
                myTextureCounter=1;
            end
            Screen('DrawTextures', windowID, windowtext(myTextureCounter,1) );



            dots_in45=[];
            dots_in_45=[];
            if myPlaidIntercept==0
                for z=1:size(dots_xy45,1)
                    if (myTemplate(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)==255 && myTemplate(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)==255 && myTemplate(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)==255 && myTemplate(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)==255 )
                        dots_in45=[dots_in45,z];
                    end
                    if (myTemplate2(min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,2)),altura),min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,1)),altura),myTextureCounter)==255 && myTemplate2(max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,2)),1),max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,1)),1),myTextureCounter)==255 && myTemplate2(max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,2)),1),min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,1)),altura),myTextureCounter)==255 && myTemplate2(min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,2)),altura),max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,1)),1),myTextureCounter)==255)
                        dots_in_45=[dots_in_45,z];
                    end
                end
            elseif myPlaidIntercept==1
                for z=1:size(dots_xy45,1)
                    if (myTemplate(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)==255 && myTemplate(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)==255 && myTemplate(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)==255 && myTemplate(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)==255 ) && (myTemplate2(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)~=255 && myTemplate2(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)~=255 && myTemplate2(max(round(-plaid_border45*dots_size45 + dots_xy45(z,2)),1),min(round(plaid_border45*dots_size45 + dots_xy45(z,1)),altura),myTextureCounter)~=255 && myTemplate2(min(round(plaid_border45*dots_size45 + dots_xy45(z,2)),altura),max(round(-plaid_border45*dots_size45 + dots_xy45(z,1)),1),myTextureCounter)~=255 ) 
                        dots_in45=[dots_in45,z];
                    end
                    if (myTemplate2(min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,2)),altura),min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,1)),altura),myTextureCounter)==255 && myTemplate2(max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,2)),1),max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,1)),1),myTextureCounter)==255 && myTemplate2(max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,2)),1),min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,1)),altura),myTextureCounter)==255 && myTemplate2(min(round(plaid_border_45*dots_size_45 + dots_xy_45(z,2)),altura),max(round(-plaid_border_45*dots_size_45 + dots_xy_45(z,1)),1),myTextureCounter)==255)
                        dots_in_45=[dots_in_45,z];
                    end
                end            
            end            
            Screen('DrawDots', windowID, [xcenter-altura/2+dots_xy45(dots_in45,1)';ycenter-altura/2+dots_xy45(dots_in45,2)'] ,dots_size45 ,[45 45 45]);
            Screen('DrawDots', windowID, [xcenter-altura/2+dots_xy_45(dots_in_45,1)';ycenter-altura/2+dots_xy_45(dots_in_45,2)'] ,dots_size_45 ,[45 45 45]);

            dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),1)=dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),1)+0;
            dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),2)=dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),2)+dots_veloc45_down;
            dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),3)=dots_xy45(dots_xy45_perm(1,1:n_dots_plaid_down),3)+1;

            dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),1)=dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),1)+dots_veloc45_in;
            dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),2)=dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),2)+0;
            dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),3)=dots_xy45(dots_xy45_perm(1,n_dots_plaid_down+1:n_dots_plaid),3)+1;




            dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),1)=dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),1)-0;
            dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),2)=dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),2)+dots_veloc_45_down;
            dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),3)=dots_xy_45(dots_xy_45_perm(1,1:n_dots_plaid_down),3)+1;


            dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),1)=dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),1)-dots_veloc_45_in;
            dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),2)=dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),2)+0;
            dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),3)=dots_xy_45(dots_xy_45_perm(1,n_dots_plaid_down+1:n_dots_plaid),3)+1;        



            %
            % tempo de vida
            %
            dots_out45=find(dots_xy45(:,3)>myPointLife);
            if ~isempty(dots_out45)
                dots_out45_down=find(dots_xy45(dots_out45,4)==1);
                if ~isempty(dots_out45_down)
                    dots_xy45(dots_out45(dots_out45_down),2)=dots_xy45(dots_out45(dots_out45_down),2)+myPointLifeJump*rand(length(dots_out45(dots_out45_down)),1)*dots_veloc45_down;
                    dots_xy45(dots_out45(dots_out45_down),3)=1;
                end
                dots_out45_in=find(dots_xy45(dots_out45,4)==2);
                if ~isempty(dots_out45_in)
                    dots_xy45(dots_out45(dots_out45_in),1)=dots_xy45(dots_out45(dots_out45_in),1)+myPointLifeJump*rand(length(dots_out45(dots_out45_in)),1)*dots_veloc45_in;
                    dots_xy45(dots_out45(dots_out45_in),3)=1;
                end
            end


            dots_out_45=find(dots_xy_45(:,3)>myPointLife);
            if ~isempty(dots_out_45)
                dots_out_45_down=find(dots_xy_45(dots_out_45,4)==1);
                if ~isempty(dots_out_45_down)
                    dots_xy_45(dots_out_45(dots_out_45_down),2)=dots_xy_45(dots_out_45(dots_out_45_down),2)+myPointLifeJump*rand(length(dots_out_45(dots_out_45_down)),1)*dots_veloc_45_down;
                    dots_xy_45(dots_out_45(dots_out_45_down),3)=1;
                end
                dots_out_45_in=find(dots_xy_45(dots_out_45,4)==2);
                if ~isempty(dots_out_45_in)
                    dots_xy_45(dots_out_45(dots_out_45_in),1)=dots_xy_45(dots_out_45(dots_out_45_in),1)-myPointLifeJump*rand(length(dots_out_45(dots_out_45_in)),1)*dots_veloc_45_in;
                    dots_xy_45(dots_out_45(dots_out_45_in),3)=1;
                end            
            end               



            %
            % bordos
            %
            dots_out45=find((dots_xy45(:,1)<=0 | dots_xy45(:,1)>altura) | (dots_xy45(:,2)<=0 | dots_xy45(:,2)>altura));    
            if ~isempty(dots_out45)
                dots_out45_down=find(dots_xy45(dots_out45,4)==1);
                if ~isempty(dots_out45_down)
                    dots_xy45(dots_out45(dots_out45_down),1)=round(rand(length(dots_out45_down),1)*(altura-1))+1;
                    dots_xy45(dots_out45(dots_out45_down),2)=1;
                    dots_xy45(dots_out45(dots_out45_down),3)=1;
                end
                dots_out45_in=find(dots_xy45(dots_out45,4)==2);
                if ~isempty(dots_out45_in)
                    dots_xy45(dots_out45(dots_out45_in),1)=1;
                    dots_xy45(dots_out45(dots_out45_in),2)=round(rand(length(dots_out45_in),1)*(altura-1))+1;
                    dots_xy45(dots_out45(dots_out45_in),3)=1;
                end
            end

            dots_out_45=find((dots_xy_45(:,1)<=0 | dots_xy_45(:,1)>altura) | (dots_xy_45(:,2)<=0 | dots_xy_45(:,2)>altura));    
            if ~isempty(dots_out_45)
                dots_out_45_down=find(dots_xy_45(dots_out_45,4)==1);
                if ~isempty(dots_out_45_down)
                    dots_xy_45(dots_out_45(dots_out_45_down),1)=round(rand(length(dots_out_45_down),1)*(altura-1))+1;
                    dots_xy_45(dots_out_45(dots_out_45_down),2)=1;
                    dots_xy_45(dots_out_45(dots_out_45_down),3)=1;
                end
                dots_out_45_in=find(dots_xy_45(dots_out_45,4)==2);
                if ~isempty(dots_out_45_in)
                    dots_xy_45(dots_out_45(dots_out_45_in),1)=altura;
                    dots_xy_45(dots_out_45(dots_out_45_in),2)=round(rand(length(dots_out_45_in),1)*(altura-1))+1;
                    dots_xy_45(dots_out_45(dots_out_45_in),3)=1;
                end            
            end                



            % Draw central cross
            Screen('FillRect', windowID, [255 0 0], FixCross');                                

            % add one more frame
            frame = frame + 1;
            % get frame time
            frametime(frame) = Screen('Flip',windowID);
            % Get current time
            current_time = frametime(frame);

            if myUpdateMatpress==1
                numbpress=size(matpress,1);
                matpress{numbpress+1, 2} = (frametime(frame) - Starttime);
                matpress{numbpress+1, 1} = myEvent;
                matpress{numbpress+1, 3} = frame;
                matpress{numbpress+1, 4} = myProtocol;
                matpress{numbpress+1, 5} = myCycleCounter;
                matpress{numbpress+1, 6} = '';
                matpress{numbpress+1, 7} = '';
                matpress{numbpress+1, 8} = '';
                matpress{numbpress+1, 9} = '';
                matpress{numbpress+1, 10} = '';

                myUpdateMatpress=0;
            end   

        end
                
        [keyIsDown, secs, keyCode] = KbCheck;

        if keyIsDown == 1 && keyCode(escapekeycode)    

            escapekeypress = 1;
            Screen('CloseAll');
            ShowCursor;
            Priority(0);
            warndlg('The task was terminated with ''Esc'' before the end!','Warning','modal')          
            return; % abort program                            

        end 
    end

    
    
    % Close stimulus window
    Screen('Close',windowID);
   
    
    % Show mouse cursor
    ShowCursor;
    

            
    
    
catch me;

    % Close PTB Screen and connections
    Screen('CloseAll');
    
    ShowCursor;
    Priority(0);
    rethrow(me);    
end


