function varargout = OMPS_Window(varargin)
% OMPS_WINDOW MATLAB code for OMPS_Window.fig
%      OMPS_WINDOW, by itself, creates a new OMPS_WINDOW or raises the existing
%      singleton*.
%
%      H = OMPS_WINDOW returns the handle to a new OMPS_WINDOW or the handle to
%      the existing singleton*.
%
%      OMPS_WINDOW('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OMPS_WINDOW.M with the given input arguments.
%
%      OMPS_WINDOW('Property','Value',...) creates a new OMPS_WINDOW or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before OMPS_Window_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to OMPS_Window_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help OMPS_Window

% Last Modified by GUIDE v2.5 28-Jul-2017 22:55:28

% Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @OMPS_Window_OpeningFcn, ...
                       'gui_OutputFcn',  @OMPS_Window_OutputFcn, ...
                       'gui_LayoutFcn',  [] , ...
                       'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end

    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end
    % End initialization code - DO NOT EDIT

% --- Executes just before OMPS_Window is made visible.
function OMPS_Window_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to OMPS_Window (see VARARGIN)

% Choose default command line output for OMPS_Window
    handles.output = hObject;

    % Update handles structure

    % This sets up the initial plot - only do when we are invisible
    % so window can get raised using OMPS_Window.
    if strcmp(get(hObject,'Visible'),'off')
        plot(rand(5));
    end
    
    handles.epoch = datenum('01-01-1958', 'mm-dd-yyyy');
  
    handles.startFileInd = 1; % for use in playback
    
    cla(handles.axes1)
    % UIWAIT makes OMPS_Window wait for user response (see UIRESUME)
    % uiwait(handles.figure1);
    guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = OMPS_Window_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
    varargout{1} = handles.output;

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    dname = uigetdir('Select h5 directory');
 
    d = dir([dname '/**/*.h5']); % get dir info for all subdirs too. specify wildcard to avoid '..' and '.'

    handles.files = sort(fullfile({d.folder},{d.name})); % all filenames with full path. Sorted in time ascending order

    guidata(hObject, handles)

% --------------------------------------------------------------------
function FileMenu_Callback(hObject, eventdata, handles)
% hObject    handle to FileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OpenMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to OpenMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function PrintMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to PrintMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function CloseMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to CloseMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB



% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
         set(hObject,'BackgroundColor','white');
    end

    set(hObject, 'String', {'plot(rand(5))', 'plot(sin(1:0.01:25))', 'bar(1:.5:10)', 'plot(membrane)', 'surf(peaks)'});


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
    updatePannel(handles)

% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end



%Mike Walker

%Get an array of granule data from the h5 file -----
function gran = getGranule( rdrType, granuleID, file)
    str = ['/All_Data/' rdrType '/RawApplicationPackets_' num2str(granuleID)];
    gran = hdf5read(file, str);
  
    
function num = numAPIDs(granule)
% used to get the number of APIDs from the static  header in a granule
    num = swapbytes(typecast(granule(37:40), 'uint32')); % get the number of APIDs in the granule from the static header

    
function [apLst, pktTrk, apStr] = getOffsets(granule)
% Used to get the offsets to find the APID list from the static header, the
% packet tracker list from the APID list, and finally the start of that
% particular APID in the APID storage field from one granule (hdf5 group)
% in an h5 file
        apLst = swapbytes(typecast(granule(41:44), 'uint32')); % get the index of the start of the APID list from the static header
        pktTrk = swapbytes(typecast(granule(45:48), 'uint32')); % get the index of the start of the pktTracker from the static header
        apStr = swapbytes(typecast(granule(49:52), 'uint32')); % get the index of the start of the pktTracker from the static header

    
    
    
%Get an array of a parameter from an rdr file -----
function playBack(handles,files_tmp, rdrType, indexInPacket, parByteSize, APID, numType)

    bitStart = round(8*(mod(indexInPacket, 1))); % start bits
    bitSize = round(8*mod(parByteSize, 1));
    % Extract only the filenames pertaining to the desired telemtry/science. Otherwise h5_getdata will crash when it can't find the specific submodule in the file\

    
    types = struct('d8', 'uint8', 'u8', 'uint8', 's8', 'int8', 'u16', 'uint16', 's16', 'int16', ...
        'u32', 'uint32', 's32', 'int32'); % struct for converting DB types to matlab syntax
    
    numType = types.(numType); % get  the MATLAB syntax fromt the struct
    
    if ismember('TELEMETRY', rdrType)
      type = 'ROLPT';
    else
      type = 'RNSCA';
    end

    files =  regexp(files_tmp, ['.*' type '.*'], 'match'); % match only the needed files

    files = [files{:}]; % coerce into singleton cell array
    
    timeVec = []; % these vectors will be used for plotting. We will cut the beginning off as needed whenn we have sufficient points
    paramVec = [];

    vecInd = 1; % Use this to index the vectors.  Set  the threshold of points on the screen to 50
    
    i = 1; % This is so we can switch telem points mid playback. This initiates to 1
    
    primHdrPlus1 = uint32(7); % size of primary header plus one to account for the pkt length field  having one subtracted from it 

    while i <= length(files)
        file = files{i};
        
        % use h5info to get the number of granules in the hdf5 file. 
        info = h5info(file);
        allData = info.Groups(strcmp({info.Groups.Name}, '/All_Data')); % find the All_data hdf5 group
        maxGran = length(allData.Groups) - 1; % This give the maxx num of granules in the hdf5 group. Subract 1 since they are 0-indexed
        disp 'new file'
        for granNum=0:maxGran
          granule = getGranule(rdrType, granNum, file);

            % get the tracker index, which is the index of the data fiel that contains the index of the start of the APID's first packet 
            % 21 is the offest between the APID list start and the tracker index
            % field in the APID list. Add 1 to account for matlab bein 1 indexed,
            % and the packet is assuming 0 indexed

            [apLstOffst,pktTrackerOffset,apStrgOffst] = getOffsets(granule);

            %disp(['In list: ' num2str(swapbytes(typecast(granule(apLstOffst+17:apLstOffst+20), 'uint32')))])

            %this APID. This index is one based by adding 1 to it.

            numAP = numAPIDs(granule); % total number of APIDs in granule

            APID = uint32(APID) ;% so we can compare it in the loop
            apidFound = 0;
            ind = 0; % index in APID list (zero based)
            apidListElLen = 32; % length in bytes of element in PAID list

            % Use tis loop to find the APID in the APID list, to then find the
            % packets in the AP storage field
            while ~apidFound

                if ind==numAP
                    error(['APID ' num2str(APID) ' not present in packet']); 
                end

                currInd = ind*apidListElLen;
                currAPID = swapbytes(typecast(granule((apLstOffst+17 + currInd):(apLstOffst+20 + currInd)), 'uint32'));
                if currAPID ==  APID
                    apidFound = 1;
                else
                    ind = ind + 1;
                end
            end

            % retrieve the number of pkts recieved of the specific APID in this
            % granule
            numPkts = swapbytes(typecast(granule((apLstOffst+29+currInd):(apLstOffst+32+currInd)), 'uint32'));

            % this value tells us where the data is in the AP storage field
            trackerInd = swapbytes(typecast(granule((apLstOffst+21+currInd):(apLstOffst+24+currInd)), 'uint32')); %The first index in the pktTracker array that will contain an AP of
            % get the index of the start of the packet from the tracker index field
            % pertaining to that specific index
            firstPacketStartInd = swapbytes(typecast(granule((pktTrackerOffset+trackerInd+17):(pktTrackerOffset+trackerInd+20)), 'uint32')) + uint32(1);
            offset = uint32(0); % offset between firt packet and curr packet
            disp 'new gran'
            for j = 1:numPkts
                tic
                packetStartInd = offset + firstPacketStartInd;
                % the 5th and 6th bytes is the packet size in bytes minus  1 (excluding the primary header). Add this to the offset for the next packet
                currInd = apStrgOffst + packetStartInd;
                nextPktSize = swapbytes(typecast(granule((currInd + 4):(currInd+5)), 'uint16')) ;
                offset = offset + uint32(nextPktSize) + primHdrPlus1 ;  % Add five to account for the primary header minus 1

        %         firstByte = swapbytes(typecast(granule(currInd), 'uint8'));% fist bytes contains the flag for if there is a secondary hdr
        %         bits = de2bi(first2bytes, 'left-msb');
        %         APID_found = bi2de(bits(end-10:end),  'left-msb');

        
                if vecInd == 50
                   paramVec = paramVec(2:end); % lop off the beginning to keep the newest points
                   timeVec = timeVec(2:end); 
                end
        
        
                timeVec(end+1) = double(swapbytes(typecast(granule((currInd + 6):(currInd+7)), 'uint16'))) ... % days
                    + double(swapbytes(typecast(granule((currInd + 8):(currInd+11)), 'uint32')))/86400000 ...% millis
                    + double(swapbytes(typecast(granule((currInd + 12):(currInd+13)), 'uint16')))/86400000000 ...% micros
                    + handles.epoch ; % NASA epoch
                
                datestr(timeVec(end), 'HH:MM:SS mm-dd-yyyy') % add 
                
                paramInd = currInd + indexInPacket;
                
                paramVec(end+1) = swapbytes(typecast(granule((paramInd):(paramInd + parByteSize - 1)) , numType));
                
                
                plot(handles.axes1, timeVec, paramVec);
                min(timeVec)
                
                % set the axis limits so that the newest point is not
                % touching the right wall of the axis window
                axis(handles.axes1, [min(timeVec) (max(timeVec)+800/86400) (min(paramVec)-1) (max(paramVec)+1)])
                
                set(handles.axes1, 'XTickLabelRotation', 45) % rotate the x axis
                datetick(handles.axes1, 'x', 'HH:MM:SS', 'keeplimits', 'keepticks') % make the x axis show date strings 
                
                guidata(handles.axes1, handles); % allows guifunction to update the graphics
                toc
                
                pause(0.1);
                
                

            end % end for


        end % end  for
        
        i = i + 1;
        
    end % end outer while
    
    
    % now coerce into matlab vector
    timeVec = cell(timeVec.toArray);
    timeVec = [timeVec{:}];
    timeVec = timeVec(:); % now it is a column vec
    
    paramVec = cell(paramVec.toArray);
    paramVec = [paramVec{:}];
    paramVec = paramVec(:); % now it is a column vec    
        


        


 


  %  axis(ax, [times(1) 5*times(end)/4 min(data)-1 max(data)+1]) % allow for gap between end of pannel and newest data point  


%Launch plots for Power -----
function t1 = versionPlot( epoch, file, ax)

  %Specify first bytes of a packet
  headera = [10;49];
    
  number_grans = 0;
  rdrType = 'OMPS-NPSCIENCE-RDR_All';
  t=getTimes(file, rdrType , number_grans, 6, headera) + epoch;
  y1=getParam(file, rdrType, number_grans, 16, 2, headera);
  plotVsTime( t, y1, 'OMPS-Science Data Grab Test', 'Version number of the RDR', ax);
  t1 = t(end);
  
function t1 = contPlot(epoch, file, ax)

  % Specify first bytes of a packet
  headera = [10;49];

  number_grans = 0;
  rdrType = 'OMPS-NPSCIENCE-RDR_All';
  t=getTimes(file, rdrType, number_grans, 6, headera) + epoch;
  y1=getParam(file, rdrType, number_grans, 25, 1, headera);
  plotVsTime( t, y1, 'OMPS-Science Data Grab Test', 'Version number of the RDR', ax)
  t1 = t(end);
  
%Launch plots for Power ----- APID 
function t1 = powerPlot1(handles, epoch, file, ax )
   
  rdrType = 'OMPS-TELEMETRY-RDR_All';
  playBack(handles, file, rdrType, 193, 1, 544, 'd8');
  
  t1 = t(end);

function t1 = powerPlot2( epoch, file , ax)
  
  header = [10; 32];

  number_grans = 0;
  rdrType = 'OMPS-TELEMETRY-RDR_All';
  t = getTimes(file, rdrType, number_grans, 7, header) + epoch;
  y2 = getParam(file, rdrType, number_grans, 301, 1, header, 'd8');
  plotVsTime( t, y2, 'Limb CCD Power Status', 'Power', ax)
  t1 = t(end);
  
  
  
function updatePannel(handles)
    switch get(handles.popupmenu2, 'value')
        case 1, t=mechPlot1(handles.epoch, handles.files, handles.axes1);
        case 2, t=mechPlot2(handles.epoch, handles.files, handles.axes1);
        case 3, t=mechPlot3(handles.epoch, handles.files, handles.axes1);
        case 4, t=mechPlot4(handles.epoch, handles.files, handles.axes1);
        case 5, t=mechPlot5(handles.epoch, handles.files, handles.axes1);
        case 6, t=mechPlot6(handles.epoch, handles.files, handles.axes1);
        case 7, t=powerPlot1(handles, handles.epoch, handles.files, handles.axes1);
        case 8, t=powerPlot2(handles.epoch, handles.files, handles.axes1);
        case 9, t=currentPlot1(handles.epoch, handles.files, handles.axes1);
        case 10, t=currentPlot2(handles.epoch, handles.files, handles.axes1);
        case 11, t=currentPlot3(handles.epoch, handles.files, handles.axes1);
        case 12, t=currentPlot4(handles.epoch, handles.files, handles.axes1);
    end
        


% --- Executes on button press in pushbutton3. Playback Button
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
