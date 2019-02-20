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



%% partID
%partID = inputdlg('Participant ID:','Input',1);
%partID=char(partID{1,1});
partID='RM';


%% runID
runID = menu('Run?', 'UNAMB:Run 01', 'UNAMB:Run 02','UNAMB:Run 03','UNAMB:Run 04','UNAMB:Run 05','LOCALIZER:Run 06');


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


%%
%-------------------------------------------------------------%
%                                                             %
% Do you want to use (1) the EyeLink eyetracking or not (0) ? %
%                                                             %
%-------------------------------------------------------------%
eyetracker = menu('Do you want to use the EyeLink eyetracking?', 'Yes', 'No');
if eyetracker==2
    eyetracker = 0;
end
% What about dummymode?
if eyetracker==1
    % Do you want to use the Eyelink eyetracking in dummymode (1) or not (2) ?
    dummymode = menu('Do you want to use the Eyelink eyetracking in dummymode?', 'Yes', 'No');
    if dummymode==2
        dummymode = 0;
    end
    
end
%------------%
%            %
% Input mode %
%            %
%------------%
% 1 - keyboard | 2 - lumina response box LU400 (A) | 3 or 0 (cancel) - automatically random
keymode = menu('Which response mode do you want to use?', 'Keyboard', 'MR response box', 'Automatic (debug)');
if keymode==0
    keymode = 3;
end

switch keymode
    
    case 0 % random (debug)
        keyAUTO = [49,50];

        
    case 1 % keyboard answer
        % downkeycode = KbName('1');
        downkeycode = 97;
        % inkeycode = KbName('2');
        inkeycode = 98;
         
    case 2 % lumina response box LU400 (A)
        response_box_handle = IOPort('OpenSerialPort','COM3');
        IOPort('Flush',response_box_handle);
        
        downkeycode = 49;
        inkeycode = 50;
end
 

% Turn on (1) or off (0) synchrony with scanner console
syncbox = menu('Do you want to turn on synchrony with scanner?', 'Yes', 'No');
if syncbox==2
    syncbox = 0;
end

%-------%
% PORTS %
%-------%
% Syncbox in MRI
if syncbox
    syncbox_handle = IOPort('OpenSerialPort', 'COM2', 'BaudRate=57600 DataBits=8 Parity=None StopBits=1 FlowControl=None');
    IOPort('Flush',syncbox_handle);
end

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
myStimulusProtocolList(2,:) = [BaselineRawID, na_P, BaselineRawID, C_P, BaselineRawID, P_C, BaselineRawID, P_P, BaselineRawID, na_C, BaselineRawID, C_C, BaselineRawID, C_P, BaselineRawID, C_C, BaselineRawID, na_P, BaselineRawID, P_P, BaselineRawID, na_C, BaselineRawID, P_C, BaselineRawID];
myStimulusProtocolList(3,:) = [BaselineRawID, P_P, BaselineRawID, na_C, BaselineRawID, na_P, BaselineRawID, P_C, BaselineRawID, na_P, BaselineRawID, P_P, BaselineRawID, na_C, BaselineRawID, C_P, BaselineRawID, C_C, BaselineRawID, P_C, BaselineRawID, C_C, BaselineRawID, C_P, BaselineRawID];
myStimulusProtocolList(4,:) = [BaselineRawID, na_C, BaselineRawID, P_C, BaselineRawID, C_C, BaselineRawID, C_P, BaselineRawID, P_P, BaselineRawID, na_C, BaselineRawID, na_P, BaselineRawID, C_C, BaselineRawID, C_P, BaselineRawID, na_P, BaselineRawID, P_C, BaselineRawID, P_P, BaselineRawID];
myStimulusProtocolList(5,:) = [BaselineRawID, P_C, BaselineRawID, na_P, BaselineRawID, C_C, BaselineRawID, P_P, BaselineRawID, C_P, BaselineRawID, na_C, BaselineRawID, P_C, BaselineRawID, C_C, BaselineRawID, na_C, BaselineRawID, P_P, BaselineRawID, C_P, BaselineRawID, na_P, BaselineRawID];

myStimulusProtocolListLoc = [BaselineRawID,Loc_Primitive,Loc_Primitive,Loc_Primitive,Loc_Primitive,Loc_Primitive];


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
if runID>=1 && runID<=5
    myStimulusProtocol=myStimulusProtocolList(runID,:);
    protocol_cycles=size(myStimulusProtocol,2);
elseif runID==6
    myStimulusProtocol=myStimulusProtocolListLoc;
    protocol_cycles=size(myStimulusProtocol,2);
end
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
    elseif myLoadImagesToTexture==0
        %%  central circle Phantoms: full-screen and partial central square
        myPhantom01 = zeros(res_y,res_x,'uint8')+255;

        for myI=1:size(myPhantom01,1) 
            for myJ=1:size(myPhantom01,2)
                if (myI-ycenter)^2 + (myJ-xcenter)^2 <= (altura/2)^2
                    myPhantom01(myI,myJ)=0;                      
                end
            end
        end
        myPhantom02=myPhantom01(ycenter-altura/2:ycenter+altura/2-1,xcenter-altura/2:xcenter+altura/2-1);

        % indices parte exterior à circunferência
        myIndexesCircle=find(myPhantom01==255);
        myIndexesCircleTemplate=find(myPhantom02==255);    


        %%
        startLine=1;
        endLine=res_y;
        startArrayLine=startLine:distance:endLine;           
        myTemplate=zeros(altura,altura,nLoopFrames ,'uint8');
        myTemplate2=zeros(altura,altura,nLoopFrames ,'uint8');                        
        windowtext=[];
        for j=1:nLoopFrames               
            startArrayLine=floor(startArrayLine);
            myImage02=zeros(res_y,res_x,'uint8')+125;
            for i=1:size(startArrayLine,2)
                myImage02(startArrayLine(i):min(startArrayLine(i)+espessura-1,endLine),1:res_x)=0;
            end


            startLine=startArrayLine(1)+veloc;
            startArrayLine=startLine:distance:endLine;
            startArrayLine=[startLine:-distance:1,startArrayLine(2:end)];


            myImage45=imrotate(myImage02,myAngle,'bicubic','crop');
            myTemp45(1:altura,1:altura)=myImage45(ycenter-altura/2:ycenter+altura/2-1,xcenter-altura/2:xcenter+altura/2-1);
            myIndexTemp45=find(myTemp45<60);
            myTemp45=zeros(altura,altura,'uint8');
            myTemp45(myIndexTemp45)=255;
            myTemp45(myIndexesCircleTemplate)=0;
            myTemplate(1:altura,1:altura,j)=myTemp45;

            myImage_45=imrotate(myImage02,-myAngle,'bicubic','crop');
            myTemp_45(1:altura,1:altura)=myImage_45(ycenter-altura/2:ycenter+altura/2-1,xcenter-altura/2:xcenter+altura/2-1);
            myIndexTemp_45=find(myTemp_45<60);
            myTemp_45=zeros(altura,altura,'uint8');
            myTemp_45(myIndexTemp_45)=255;
            myTemp_45(myIndexesCircleTemplate)=0;
            myTemplate2(1:altura,1:altura,j)=myTemp_45;

            myTempAll=(myImage45+myImage_45)/2;    
            myLineIndexs=find(myTempAll<90);

            myImageAll=zeros(res_y,res_x,'uint8');

            myImageAll(:,:)=myGrayBackgroundCentralWindow;
            myImageAll(myLineIndexs)=myGrayLinePlaids;
            myImageAll(myIndexesCircle)=myGrayBackgroundFullWindow;

            myImageAllFinal(:,:,j)=myImageAll;
            windowtext(j,1) = Screen('MakeTexture', windowID, myImageAllFinal(:,:,j));                                
        end              
    end  







    %---------------------------------------------------------------------
    % Create matrix to save key presses and frame-times
    %---------------------------------------------------------------------
    matpress={};
    numbpress = size(matpress,1);


    frametime = [];

    doublepress = 0; % refers to "double" button
    button1 = 0; % refers to "inward" button
    button2 = 0; % refers to "downward" button
    button3 = 0; % refers to all other buttons

    %-------------------------------%
    %                               %
    %     EYETRACKER PROCEDURES     %
    %                               %
    %-------------------------------%
    
    if eyetracker==1
        
        %-------------------------------------------%
        %  Initiate eyetracking - Defaults EyeLink  %
        %-------------------------------------------%
        
        % Provide Eyelink with details about the graphics environment and perform some initializations
        disp('Start EyeLink procedures')
        % Ensure Eyelink is not already open
        Eyelink('Shutdown');
        % Initiate Eyelink object
        el = EyelinkInitDefaults(windowID);
        
        disp('EyeLink initialized with default parameters')
        
        % Initialization of the connection with the Eyelink Gazetracker
        % if we are not in dummy mode
        if ~EyelinkInit(dummymode, 1)
            fprintf('Eyelink Init aborted.\n');
            cleanup;  % cleanup function
            return
        end
        
        % Filename of eye tracker data
        datastr = datestr(now, 'HHMM');
        str_save = [partID, 'R',num2str(runID), datastr];
        edfFile = [str_save, '.edf'];
        %--------------------------%
        % Open file to record data %
        %--------------------------%
        openOK = Eyelink('Openfile', edfFile);
        if openOK~=0
            fprintf('Cannot create EDF file ''%s'' ', edfFile);
            cleanup;
            return;
        end
        disp('File to record eyetracking data - OK')
        
        % Grab the screen resolution from Psychtoolbox and write that to a DISPLAY_COORDS message
        [width, height] = Screen('WindowSize', screenNumber);
        
        Eyelink('message', 'DISPLAY_COORDS %ld %ld %ld %ld', 0, 0, width-1, height-1);
        
        % Also send a screen_pixel_coords command to the tracker with the same dimensions to ensure that both Data Viewer and the EyeLink use the same resolution
        Eyelink('command','screen_pixel_coords = %ld %ld %ld %ld', 0, 0, width-1, height-1);
        % Data Viewer will not scale the fixation locations when you change the Display Width and Display Height.
        % Fixations will always be drawn at the pixel location of the fixation event in the .edf file.
        % Of course, changing the Display Width and Display Height will cause the fixations to appear in a different place in the window due to the changed window size, but the pixel coordinates of the fixation will not change.
        
        % Set calibration type.
        Eyelink('command', 'calibration_type = HV9');
        
        % Allow to use the big button on the eyelink gamepad to accept the
        % calibration/drift correction target
        Eyelink('command', 'button_function 5 "accept_target_fixation"');
        
        % Make sure we're still connected.
        if Eyelink('IsConnected')~=1 && dummymode == 0
            fprintf('not connected, clean up\n');
            Eyelink( 'Shutdown');
            Screen('CloseAll');
            IOPort('CloseAll');
            pnet('closeall');
            ShowCursor;
            Priority(0);
            return
        end
        
        %-------------------------------------------------%
        %   CALIBRATION, VALIDATION OR DRIFT CORRECTION   %
        %-------------------------------------------------%
        % Calibrate the eye tracker
        % setup the proper calibration foreground and background colors
        el.backgroundcolour = [128 128 128];
        el.calibrationtargetcolour = [0 0 0];
        
        % Parameters are in frequency, volume, and duration
        % Set the second value in each line to 0 to turn off the sound
        el.cal_target_beep = [600 0.5 0.05];
        el.drift_correction_target_beep = [600 0.5 0.05];
        el.calibration_failed_beep = [400 0.5 0.25];
        el.calibration_success_beep = [800 0.5 0.25];
        el.drift_correction_failed_beep = [400 0.5 0.25];
        el.drift_correction_success_beep = [800 0.5 0.25];
        % You must call this function to apply the changes from above
        EyelinkUpdateDefaults(el);
        
        % Do calibration, validation or drift correction
        success = EyelinkDoTrackerSetup(el);

    end    

    %-------------------------------------------------%
    % Position of textures, fixation cross and frames %
    %-------------------------------------------------%



    %
    %
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


    %-------------------------------------------------%
    % READY OR NOT? Manual trigger %
    %-------------------------------------------------%    
    
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
    
    
    
    % Fill screen with white after calibration
    Screen('FillRect', windowID, 0, []);
    % Tamanho das letras em que Ready aparece escrito
    Screen('TextSize', windowID , textsize);
    Screen('DrawText', windowID, 'Ready...', res_x/2.5, res_y/2.2, [200 200 200]);
    
    % Update screen
    Screen('Flip',windowID);    
    
    
    
    %--------------------------%
    % Wait for scanner trigger %
    %--------------------------%
    % To avoid the KbCheck to get the previous key press after "Ready..."
    %WaitSecs(1)
    trigger = 0;
    
    while trigger==0
        
        [keyIsDown, secs, keyCode] = KbCheck;
        
        % The user asked to exit the program
        if keyIsDown==1 && keyCode(escapekeycode)
            
            escapekeypress = 1;
            
            % Close PTB screen and connections
            Screen('CloseAll');
            ShowCursor;
            Priority(0);
            
            % Launch window with warning of early end of program
            warndlg('The task was terminated with ''Esc'' before the end!','Warning','modal')
            
            return % abort program
            
            % The trigger has arrived
        elseif keyIsDown==1 && syncbox==0 && keyCode(keytriggercode)
            
            % Exit while loop and continue program
            break
            
            % Syncbox is 'on' or 'off'?
        elseif syncbox==1
            [gotTrigger, logdata.triggerTimeStamp] = waitForTrigger(syncbox_handle,1,300);
            
            if gotTrigger
                disp('Trigger OK! Starting stimulation...');
                
                % Clean syncbox buffer
                IOPort('Flush', syncbox_handle);
                IOPort('Purge', syncbox_handle);
                IOPort('Close', syncbox_handle);
                
                % Exit while loop and continue program
                break
                
            else
                disp('Absent trigger. Aborting...');
                throw
            end
        end
        
    end
    
    
    %--------------------------%
    % START eyetracker %
    %--------------------------%
    % Start recording eyetracking data
    if eyetracker==1
        
        % Number of trial
        trial_numb = 1;
        
        Eyelink('Message', 'TRIALID %d', trial_numb); % number of the trial. Sending a 'TRIALID' message to mark the start of a trial in Data Viewer.
        
        % This supplies the title at the bottom of the eyetracker display
        Eyelink('command', 'record_status_message "TRIAL %s"', str_save(1:4));
        
        Eyelink('StartRecording');
        Eyelink('Message', 'SYNCTIME');  % Mark zero-plot time in data file
    end
    
    
    
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























        %----------------------------------------------------------------%
        %      Verify key presses, which timestamp and frame             %
        %                          (exit if 'esc')                       %
        %----------------------------------------------------------------%
        
        switch keymode
            %----------------%
            % Random (debug) %
            %----------------%
            case 0
                keyrandom = keyAUTO(randi(2));
                secs = GetSecs;
                
                %-------------------%
                % keyboard pressing %
                %-------------------%
            case 1
                [keyIsDown, secs, keyCode] = KbCheck;
                
                % A key/button was pressed
                if keyIsDown == 1
                    
                    % Check the name (string) of the key that was pressed
                    keystring = KbName(keyCode);
                    
                    if iscell(keystring)
                        
                        % To Escape
                        if keyCode(escapekeycode)
                            
                            escapekeypress = 1;
                            
                            if eyetracker==1 % Stop eyetracking if it was on
                                Eyelink('StopRecording'); % Stop the recording of eye-movements for the current trial
                                Eyelink('Message', 'TRIAL_RESULT 0') % Sending a 'TRIAL_RESULT' message to mark the end of a trial in Data Viewer.
                                Eyelink('CloseFile');
                            end
                            
                            % Close PTB screen and connections
                            Screen('CloseAll');
                            ShowCursor;
                            Priority(0);
                            
                            matpress{end+1, 1} = 'finished-error';
                            matpress{end, 2} = (secs - Starttime);
                            matpress{end, 3} = frame;
                            matpress{end, 4} = myProtocol;
                            matpress{end, 5} = myCycleCounter;
                            
                            
                            %[filename, pathname] = uiputfile(['matpress_' datestr(now, 'ddmm') '_' datestr(now, 'HHMM') '.mat'], pwd);
                            filename=[partID,'_','matpress','_','PlaidDots_Adaptation_Error','_Run',num2str(runID), '---', datestr(now, 'ddmm'), '_', datestr(now, 'HHMM'), '.mat'];
                            pathname=[pwd,'\',partID,'\'];
                            if exist(pathname, 'dir')==0
                                mkdir(pathname)
                            end
                            save([pathname filename], 'matpress');
                            filename=[partID,'_','alldata','_','PlaidDots_Adaptation_Error','_Run',num2str(runID), '---', datestr(now, 'ddmm'), '_', datestr(now, 'HHMM'), '.mat'];
                            pathname=[pwd,'\',partID,'\'];
                            if exist(pathname, 'dir')==0
                                mkdir(pathname)
                            end    
                            save([pathname filename]);                             
                            
                            
                            
                            % Launch window with warning of early end of program
                            warndlg('The task was terminated with ''Esc'' before the end!','Warning','modal')

                            return % abort program
                            
                        end
                        
                        % The participant immediately pressed two buttons
                        % simultaneously
                        if button1 == 0 && button2 == 0
                            
                            numbpress=size(matpress,1);
                            matpress{numbpress+1, 2} = (secs - Startime);
                            matpress{numbpress+1, 1} = 'double';
                            matpress{numbpress+1, 3} = frame;
                            matpress{numbpress+1, 4} = myProtocol;
                            matpress{numbpress+1, 5} = myCycleCounter;
                            matpress{numbpress+1, 6} = '';
                            
                            
                            doublepress = 1;
                            button1 = 1;
                            button2 = 1;
                            
                        elseif keyCode(inkeycode) && button1 == 1 && button2 == 0
                            % There are two buttons pressed and one of them is "inward"
                            % button press - this is a "double" press during
                            % "downward", which we assume is a new "inward" report but
                            % the press in the new "inward" button occurs before the
                            % old "downward" button is released
                            
                            numbpress=size(matpress,1);
                            matpress{numbpress+1, 2} = (secs - Starttime);
                            matpress{numbpress+1, 1} = 'inward';
                            matpress{numbpress+1, 3} = frame;
                            matpress{numbpress+1, 4} = myProtocol;
                            matpress{numbpress+1, 5} = myCycleCounter;
                            matpress{numbpress+1, 6} = '';
                            
                            
                            doublepress = 1;
                            button2 = 1;
                            
                        elseif keyCode(downkeycode) && button1 == 0 && button2 == 1
                            % There are two buttons pressed and one of them is "downward"
                            % button press - this is a "double" press during
                            % "inward", which we assume is a new "downward" report but
                            % the press in the new "downward" button occurs before the
                            % old "inward" button is released
                            
                            numbpress=size(matpress,1);
                            matpress{numbpress+1, 2} = (secs - Starttime);
                            matpress{numbpress+1, 1} = 'down';
                            matpress{numbpress+1, 3} = frame;
                            matpress{numbpress+1, 4} = myProtocol;
                            matpress{numbpress+1, 5} = myCycleCounter;
                            matpress{numbpress+1, 6} = '';
                            
                            
                            doublepress = 1;
                            button1 = 1;
                            
                        elseif button1 == 1 && button2 == 1
                            % There are two buttons pressed, "downward" and "inward",
                            % either the participant forgot to release a key or he
                            % is confused (and for some reason pressing both keys)
                            % this starts a counter 'doublepress' that will be used
                            % to check if it is a reasonable "double" or not. If
                            % doublepress goes for too long it will tell you by
                            % "stopdouble" that a key has finally been released
                            doublepress = doublepress+1;
                        end
                        
                        %--------------------------------------%
                        % There is only one key/button pressed %
                        %--------------------------------------%
                    else
                        
                        % To Escape
                        if keyCode(escapekeycode)
                            
                            escapekeypress = 1;
                            
                            if eyetracker==1 % Stop eyetracking if it was on
                                Eyelink('StopRecording'); % Stop the recording of eye-movements for the current trial
                                Eyelink('Message', 'TRIAL_RESULT 0') % Sending a 'TRIAL_RESULT' message to mark the end of a trial in Data Viewer.
                                Eyelink('CloseFile');
                            end
                            
                            % Close PTB screen and connections
                            Screen('CloseAll');
                            ShowCursor;
                            Priority(0);
                                    
                            matpress{end+1, 1} = 'finished-error';
                            matpress{end, 2} = (secs - Starttime);
                            matpress{end, 3} = frame;
                            matpress{end, 4} = myProtocol;
                            matpress{end, 5} = myCycleCounter;

                            %[filename, pathname] = uiputfile(['matpress_' datestr(now, 'ddmm') '_' datestr(now, 'HHMM') '.mat'], pwd);
                            filename=[partID,'_','matpress','_','PlaidDots_Adaptation_Error','_Run',num2str(runID), '---', datestr(now, 'ddmm'), '_', datestr(now, 'HHMM'), '.mat'];
                            pathname=[pwd,'\',partID,'\'];
                            if exist(pathname, 'dir')==0
                                mkdir(pathname)
                            end
                            save([pathname filename], 'matpress');
                            filename=[partID,'_','alldata','_','PlaidDots_Adaptation_Error','_Run',num2str(runID), '---', datestr(now, 'ddmm'), '_', datestr(now, 'HHMM'), '.mat'];
                            pathname=[pwd,'\',partID,'\'];
                            if exist(pathname, 'dir')==0
                                mkdir(pathname)
                            end    
                            save([pathname filename]);                                
                            
                            % Launch window with warning of early end of program
                            warndlg('The task was terminated with ''Esc'' before the end!','Warning','modal')
                            
                            return % abort program
                            
                        elseif keyCode(downkeycode) && button1 == 0
                            % The participant just pressed 'down'
                            
                            numbpress=size(matpress,1);
                            matpress{numbpress+1, 2} = (secs - Starttime);
                            matpress{numbpress+1, 1} = 'down';
                            matpress{numbpress+1, 3} = frame;
                            matpress{numbpress+1, 4} = myProtocol;
                            matpress{numbpress+1, 5} = myCycleCounter;
                            matpress{numbpress+1, 6} = '';
                            
                            
                            button1 = 1;
                            %time_down = time_down + FlipInterval;
                            
                        elseif keyCode(inkeycode) && button2 == 0
                            % The participant just pressed 'inward'
                            
                            numbpress=size(matpress,1);
                            matpress{numbpress+1, 2} = (secs - Starttime);
                            matpress{numbpress+1, 1} = 'inward';
                            matpress{numbpress+1, 3} = frame;
                            matpress{numbpress+1, 4} = myProtocol;
                            matpress{numbpress+1, 5} = myCycleCounter;
                            matpress{numbpress+1, 6} = '';
                            
                            
                            button2 = 1;
                            %time_in = time_in + FlipInterval;
                            
                        elseif keyCode(inkeycode) && button1 == 1 && button2 == 1  && doublepress < 40
                            % The participant released 'down' while pressing
                            % 'inward' for less than 40 continuous frames. Should
                            % be considered a normal switch
                            
                            numbpress=size(matpress,1);
                            matpress{numbpress+1, 2} = (secs - Starttime);
                            matpress{numbpress+1, 1} = 'stopd';
                            matpress{numbpress+1, 3} = frame;
                            matpress{numbpress+1, 4} = myProtocol;
                            matpress{numbpress+1, 5} = myCycleCounter;
                            matpress{numbpress+1, 6} = '';
                            
                            
                            button1 = 0;
                            button2 = 1;
                            doublepress = 0;
                            %time_down = time_down + FlipInterval;
                            
                        elseif keyCode(downkeycode) && button1 == 1 && button2 == 1  && doublepress < 40
                            % The participant released 'inward' while pressing
                            % 'down' for less than 40 continuous frames. Should
                            % be considered a normal switch
                            
                            numbpress=size(matpress,1);
                            matpress{numbpress+1, 2} = (secs - Starttime);
                            matpress{numbpress+1, 1} = 'stopi';
                            matpress{numbpress+1, 3} = frame;
                            matpress{numbpress+1, 4} = myProtocol;
                            matpress{numbpress+1, 5} = myCycleCounter;
                            matpress{numbpress+1, 6} = '';
                            
                            
                            button1 = 1;
                            button2 = 0;
                            doublepress = 0;
                            %time_in = time_in + FlipInterval;
                            
                        elseif keyCode(inkeycode) && button1 == 1 && button2 == 1  && doublepress > 40
                            % The participant released 'down' while pressing
                            % 'inward' for more than 40 continuous frames. It is
                            % considered a switch condition but indicates the
                            % moment of release as 'stopdouble'
                            
                            numbpress=size(matpress,1);
                            matpress{numbpress+1, 2} = (secs - Starttime);
                            matpress{numbpress+1, 1} = 'stopdouble';
                            matpress{numbpress+1, 3} = frame;
                            matpress{numbpress+1, 4} = myProtocol;
                            matpress{numbpress+1, 5} = myCycleCounter;
                            matpress{numbpress+1, 6} = '';
                                                        
                            button1 = 0;
                            button2 = 1;
                            doublepress = 0;
                            
                        elseif keyCode(downkeycode) && button1 == 1 && button2 == 1  && doublepress > 40
                            % The participant released 'inward' while pressing
                            % 'down' for more than 40 continuous frames. It is
                            % considered a switch condition but indicates the
                            % moment of release as 'stopdouble'
                            
                            numbpress=size(matpress,1);
                            matpress{numbpress+1, 2} = (secs - Starttime);
                            matpress{numbpress+1, 1} = 'stopdouble';
                            matpress{numbpress+1, 3} = frame;
                            matpress{numbpress+1, 4} = myProtocol;
                            matpress{numbpress+1, 5} = myCycleCounter;
                            matpress{numbpress+1, 6} = '';                            
                            
                            button1 = 1;
                            button2 = 0;
                            doublepress = 0;
                                                                                    
                        elseif button1 == 1
                            % increase the duration of "time_down" by 1 flip
                            % interval (around 16.67ms)while key 'down' is being
                            % pressed
                            %time_down = time_down + FlipInterval;
                            
                        elseif button2 == 1
                            % increase the duration of "time_in" by 1 flip
                            % interval (around 16.67ms) while key 'inward' is being
                            % pressed
                            %time_in = time_in + FlipInterval;
                            
                        end
                    end
                    
                elseif keyIsDown == 0 && button1 == 1 && doublepress < 40
                    % The subject has just released key 'down' and hasnt pressed
                    % two keys for more than 40 frames. Should be considered a
                    % regular perceptual switch
                    
                    numbpress=size(matpress,1);
                    matpress{numbpress+1, 2} = (secs - Starttime);
                    matpress{numbpress+1, 1} = 'stopd';
                    matpress{numbpress+1, 3} = frame;
                    matpress{numbpress+1, 4} = myProtocol;
                    matpress{numbpress+1, 5} = myCycleCounter;
                    matpress{numbpress+1, 6} = '';
                    
                    button1 = 0;
                    button2 = 0;
                    
                elseif keyIsDown == 0 && button2 == 1 && doublepress < 40
                    % The subject has just released key 'in' and hasnt pressed
                    % two keys for more than 40 frames. Should be considered a
                    % regular perceptual switch
                    
                    numbpress=size(matpress,1);
                    matpress{numbpress+1, 2} = (secs - Starttime);
                    matpress{numbpress+1, 1} = 'stopi';
                    matpress{numbpress+1, 3} = frame;
                    matpress{numbpress+1, 4} = myProtocol;
                    matpress{numbpress+1, 5} = myCycleCounter;
                    matpress{numbpress+1, 6} = '';
                    
                    button1 = 0;
                    button2 = 0;
                    
                elseif keyIsDown == 0 && doublepress > 40
                    % The subject has just released all or any key after pressing
                    % two keys for longer than 40 frames. Should be considered the
                    % end of a 'double' press
                    
                    numbpress=size(matpress,1);
                    matpress{numbpress+1, 2} = (secs - Starttime);
                    matpress{numbpress+1, 1} = 'stopdouble';
                    matpress{numbpress+1, 3} = frame;
                    matpress{numbpress+1, 4} = myProtocol;
                    matpress{numbpress+1, 5} = myCycleCounter;
                    matpress{numbpress+1, 6} = '';
                    
                    button1 = 0;
                    button2 = 0;
                    doublepress = 0;
                    
                    
                else
                    % If no key is pressed, return "button" values to 0, to allow
                    % for further pressed
                    button1 = 0; % for downkeycode
                    button2 = 0; % for inkeycode
                    button3 = 0; % for other keys related to stimulus editing
                    continue
                    
                end
                
                
                %---------------------%
                % Lumina response box %
                %---------------------%
            case 2
                [keyIsDown, secs, keyCode] = KbCheck;
                
                if keyIsDown==1 && keyCode(escapekeycode)
                    
                    escapekeypress = 1;
                    
                    if eyetracker==1 % Stop eyetracking if it was on
                        Eyelink('StopRecording'); % Stop the recording of eye-movements for the current trial
                        Eyelink('Message', 'TRIAL_RESULT 0') % Sending a 'TRIAL_RESULT' message to mark the end of a trial in Data Viewer.
                        Eyelink('CloseFile');
                    end
                    
                    % Close PTB screen and connections
                    Screen('CloseAll');
                    IOPort('CloseAll');
                    ShowCursor;
                    Priority(0);
                    
                    matpress{end+1, 1} = 'finished-error';
                    matpress{end, 2} = (secs - Starttime);
                    matpress{end, 3} = frame;
                    matpress{end, 4} = myProtocol;
                    matpress{end, 5} = myCycleCounter;
                    
                    %[filename, pathname] = uiputfile(['matpress_' datestr(now, 'ddmm') '_' datestr(now, 'HHMM') '.mat'], pwd);
                    filename=[partID,'_','matpress','_','PlaidDots_Adaptation_Error','_Run',num2str(runID), '---', datestr(now, 'ddmm'), '_', datestr(now, 'HHMM'), '.mat'];
                    pathname=[pwd,'\',partID,'\'];
                    if exist(pathname, 'dir')==0
                        mkdir(pathname)
                    end
                    save([pathname filename], 'matpress');
                    filename=[partID,'_','alldata','_','PlaidDots_Adaptation_Error','_Run',num2str(runID), '---', datestr(now, 'ddmm'), '_', datestr(now, 'HHMM'), '.mat'];
                    pathname=[pwd,'\',partID,'\'];
                    if exist(pathname, 'dir')==0
                        mkdir(pathname)
                    end    
                    save([pathname filename]);                        
                    
                    % Launch window with warning of early end of program
                    warndlg('The task was terminated with ''Esc'' before the end!','Warning','modal')
                    
                    return % abort program
                end
                
                
                
                % Read button press from response box
                [key,timestamp,errmsg] = IOPort('Read',response_box_handle);
                
                if ~isempty(key)
                    IOPort('Flush',response_box_handle);
                    
                    % Save responses in matpress
                    if key==downkeycode
                        
                        numbpress=size(matpress,1);
                        matpress{numbpress+1, 2} = (timestamp - Starttime);
                        matpress{numbpress+1, 1} = 'down';
                        matpress{numbpress+1, 3} = frame;
                        matpress{numbpress+1, 4} = myProtocol;
                        matpress{numbpress+1, 5} = myCycleCounter;
                        matpress{numbpress+1, 6} = '';
                        
                        %time_down = time_down + FlipInterval;
                        
                    elseif key==inkeycode
                        
                        numbpress=size(matpress,1);
                        matpress{numbpress+1, 2} = (timestamp - Starttime);
                        matpress{numbpress+1, 1} = 'inward';
                        matpress{numbpress+1, 3} = frame;
                        matpress{numbpress+1, 4} = myProtocol;
                        matpress{numbpress+1, 5} = myCycleCounter;
                        matpress{numbpress+1, 6} = '';
                        
                        %time_in = time_in + FlipInterval;
                        
                    end
                end
                
                % Clear response box to allow further button presses
                IOPort('Flush',response_box_handle);
        end
        
        % end while cycle
    end
    
    % Stop recording eyetracker data
    if eyetracker==1 % Stop eyetracking if it was on
        Eyelink('StopRecording'); % Stop the recording of eye-movements for the current trial
        Eyelink('Message', 'TRIAL_RESULT 0') % Sending a 'TRIAL_RESULT' message to mark the end of a trial in Data Viewer.
        Eyelink('CloseFile');
        receiveEDF = Eyelink('ReceiveFile');
    end
    
    
    % Close stimulus window
    Screen('Close',windowID);
    
    % Compute the ration of downward/inward duration
    %time_ratio = time_down/time_in;
    
    % Show mouse cursor
    ShowCursor;
    
    matpress{end+1, 1} = 'finished';
    matpress{end, 2} = (secs - Starttime);
    matpress{end, 3} = frame;
    matpress{end, 4} = myProtocol;
    
    %[filename, pathname] = uiputfile(['matpress_' datestr(now, 'ddmm') '_' datestr(now, 'HHMM') '.mat'], pwd);
    filename=[partID,'_','matpress','_','PlaidDots_Adaptation','_Run',num2str(runID), '---', datestr(now, 'ddmm'), '_', datestr(now, 'HHMM'), '.mat'];
    pathname=[pwd,'\',partID,'\'];
    if exist(pathname, 'dir')==0
        mkdir(pathname)
    end
    save([pathname filename], 'matpress');
    filename=[partID,'_','alldata','_','PlaidDots_Adaptation','_Run',num2str(runID), '---', datestr(now, 'ddmm'), '_', datestr(now, 'HHMM'), '.mat'];
    pathname=[pwd,'\',partID,'\'];
    if exist(pathname, 'dir')==0
        mkdir(pathname)
    end    
    save([pathname filename]);
            
    
    
catch me;
    
    % Save variables anyway
    experiment.matpress = matpress;
    experiment.frametime = frametime;
%     experiment.time_down = time_down;
%     experiment.time_in = time_in;
%     experiment.time_ratio = time_ratio;
    
    % Time and date of experiment (run)
    fullDateOfExperiment = datestr(now,'HHMM_ddmmmmyyyy');
    experiment.full_date =  fullDateOfExperiment;
    
    expname = [partID, '_A_'];
    
    % Add information of program 'ERROR' in the filename
    experimentName = [expname, 'ERRORoutput_', experiment.full_date];
    
    % Save experiment
    save(experimentName,'experiment');
    
    % Close PTB Screen and connections
    Screen('CloseAll');
    IOPort('CloseAll');
    
    ShowCursor;
    Priority(0);
    rethrow(me);
    
end

%% Auxiliar functions

% % Cleanup routine:
% function cleanup
%     % Shutdown Eyelink:
%     Eyelink('Shutdown');
%     % Close window:
%     sca;
%     Priority(0);
% 
%     commandwindow;
% end



