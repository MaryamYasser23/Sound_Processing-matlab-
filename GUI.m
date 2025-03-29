function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 21-Dec-2023 09:21:03

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
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


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function plyaud_btn_Callback(hObject, eventdata, handles)
    % Allow the user to select an audio file
    [filename, path] = uigetfile({'.wav;.mp3'}, 'Select Audio File');
    % Check if the user canceled the file selection
    if filename == 0
        return; % User canceled
    end
    % Build the full file path
    filePath = fullfile(path, filename);
    % Read the audio file
    [audio, fs] = audioread(filePath);
    %fs = Sampling Frequency
    % Create a time vector
    t = (0:length(audio)-1) / fs;
    % Plot the audio signal on the specified axes
    plot(handles.axes1, t, audio);
    plot(handles.axes2, t, audio);
    % Play the audio
    sound(audio, fs);

    % Store audio data in handles structure
    handles.audio = audio;
    handles.fs = fs;
    % Update handles structure
    guidata(hObject, handles);

function recaud_btn_Callback(hObject, eventdata, handles)
        % Set the sampling frequency
        fs = 44100;

        % Create an audio recorder with specified parameters
        %recorder = audiorecorder(Fs, nBits, nChannels)
        recorder = audiorecorder(fs, 16, 1);
    
        % Display a message indicating the start of recording
        disp('Recording... Press stop when done.');

        % Start recording
        record(recorder);

        % Wait for the user to stop recording
        uiwait(msgbox('Recording... Press OK to stop recording.', 'Recording', 'modal'));

        % Stop recording
        stop(recorder);

        % Get the recorded audio data
        recordedAudio = getaudiodata(recorder);

        % Time vector for the recorded signal
        % t -> s
        t = (0:length(recordedAudio)-1) / fs;

        % Display the recorded signal on two axes (assumed to be handles.axes1 and handles.axes2)
        plot(handles.axes1, t, recordedAudio);
        plot(handles.axes2, t, recordedAudio);

        % Play the recorded signal
        sound(recordedAudio, fs);

function revnois_btn_Callback(hObject, eventdata, handles)
    % Assume you have loaded an audio file previously (similar to playAudioFile)
    [filename, path] = uigetfile({'.wav;.mp3'}, 'Select Audio File');
    if filename == 0
        return; % User canceled
    end

    filePath = fullfile(path, filename);
    [audio, fs] = audioread(filePath);
    % Apply a simple moving average filter for noise reduction
    window_size = 100; % Window size for moving average
    denoisedAudio = movmean(audio, window_size);
    % Display and play the signals
    t = (0:length(audio)-1) / fs; % Time vector
    plot(handles.axes1, t, audio);
    plot(handles.axes2, t, denoisedAudio);
    % Create audioplayer objects
    playerOriginal = audioplayer(audio, fs);
    playerDenoised = audioplayer(denoisedAudio, fs);
    % Play the original and denoised signals sequentially
    playblocking(playerOriginal);
    playblocking(playerDenoised);
    % Store audio data in handles structure
    handles.audio = denoisedAudio;
    handles.fs = fs;
    % Update handles structure
    guidata(hObject, handles);

function pltsig_btn_Callback(hObject, eventdata, handles)
        % Assume you have loaded an audio file previously (similar to playAudioFile)
        [filename, path] = uigetfile({'.wav;.mp3'}, 'Select Audio File');
        if filename == 0
            return; % User canceled
        end

        filePath = fullfile(path, filename);
        [audio, fs] = audioread(filePath);

        % Plot the audio signal
        t = (0:length(audio)-1) / fs; % Time vector
        %subplot(subplot1);
        plot(handles.axes1, t, audio);
        plot(handles.axes2, t, audio);

function sub_Callback(hObject, eventdata, handles)
    % Assume you have loaded two audio files previously
    [filename1, path1] = uigetfile({'.wav;.mp3'}, 'Select Audio File 1');
    if filename1 == 0
        return; % User canceled
    end

    [filename2, path2] = uigetfile({'.wav;.mp3'}, 'Select Audio File 2');
    if filename2 == 0
        return; % User canceled
    end

    filePath1 = fullfile(path1, filename1);
    filePath2 = fullfile(path2, filename2);

    [signal1, fs1] = audioread(filePath1);
    [signal2, fs2] = audioread(filePath2);

    % Ensure both signals have the same length
    minLength = min(length(signal1), length(signal2));
    signal1 = signal1(1:minLength);
    signal2 = signal2(1:minLength);

    % Subtract signal2 from signal1
    subtractedSignal = signal1 - signal2;

    % Clear the axes and hold on for subsequent plots
    cla(handles.axes1);
    cla(handles.axes2);
    hold(handles.axes1, 'on');
    hold(handles.axes2, 'on');

    % Display and play the original signals on axes1
    t = (0:minLength-1) / fs1; % Time vector
    plot(handles.axes1, t, signal1, 'b');
    plot(handles.axes1, t, signal2, 'g');
    % Display and play the subtracted signal on axes2
    plot(handles.axes2, t, subtractedSignal, 'r');
    % Turn off hold to prevent further overlay
    hold(handles.axes1, 'off');
    hold(handles.axes2, 'off');

    % Play the original signals and subtracted signal
    playerSignal1 = audioplayer(signal1, fs1);
    playerSignal2 = audioplayer(signal2, fs2);
    playerSubtracted = audioplayer(subtractedSignal, fs1);
    playblocking(playerSignal1);
    playblocking(playerSignal2);
    playblocking(playerSubtracted);
    % Store audio data in handles structure
    handles.audio = subtractedSignal;
    handles.fs = fs;
    % Update handles structure
    guidata(hObject, handles);

function mul_Callback(hObject, eventdata, handles)
        % Assume you have loaded two audio files previously
        [filename1, path1] = uigetfile({'.wav;.mp3'}, 'Select Audio File 1');
        if filename1 == 0
            return; % User canceled
        end

        [filename2, path2] = uigetfile({'.wav;.mp3'}, 'Select Audio File 2');
        if filename2 == 0
            return; % User canceled
        end

        filePath1 = fullfile(path1, filename1);
        filePath2 = fullfile(path2, filename2);
        [signal1, fs1] = audioread(filePath1);
        [signal2, fs2] = audioread(filePath2);
        % Ensure signals have the same length
        minLength = min(length(signal1), length(signal2));
        signal1 = signal1(1:minLength);
        signal2 = signal2(1:minLength);
        % Multiply one signal by another
        multipliedSignal = signal1 .* signal2;
        % Clear the axes and hold on for subsequent plots
        cla(handles.axes1);
        cla(handles.axes2);
        hold(handles.axes1, 'on');
        hold(handles.axes2, 'on');
        % Display and play the signals on axes1
        t = (0:minLength-1) / fs1; % Time vector
        plot(handles.axes1, t, signal1, 'b', t, signal2, 'g');
        % Display and play the multiplied signal on axes2
        plot(handles.axes2, t, multipliedSignal, 'm');
        % Turn off hold to prevent further overlay
        hold(handles.axes1, 'off');
        hold(handles.axes2, 'off');
        % Play the original signals and multiplied signal
        playerSignal1 = audioplayer(signal1, fs1);
        playerSignal2 = audioplayer(signal2, fs2);
        playerMultiplied = audioplayer(multipliedSignal, fs1);
        playblocking(playerSignal1);
        playblocking(playerSignal2);
        playblocking(playerMultiplied);
        % Store audio data in handles structure
        handles.audio = multipliedSignal;
        handles.fs = fs;
        % Update handles structure
        guidata(hObject, handles);

function mV_Callback(hObject, eventdata, handles)
        [filename, path] = uigetfile({'.wav;.mp3'}, 'Select Audio File');
        if filename == 0
            return; % User canceled
        end

        filePath = fullfile(path, filename);
        [audio, fs] = audioread(filePath);
        % Adjust the volume by scaling the amplitude
        volumeFactor = 0.5; % Adjust the scaling factor (2.0 for doubling the volume)
        mAudio = volumeFactor * audio;
        % Display the signals
        t = (0:length(audio)-1) / fs; % Time vector
        plot(handles.axes1, t, audio);
        plot(handles.axes2, t, mAudio);
        % Create audioplayer objects
        playerOriginal = audioplayer(audio, fs);
        playerLoud = audioplayer(mAudio, fs);
        % Play the original and increased volume signals sequentially
        playblocking(playerOriginal);
        playblocking(playerLoud);
        % Store audio data in handles structure
        handles.audio = mAudio;
        handles.fs = fs;
        % Update handles structure
        guidata(hObject, handles);

function pV_Callback(hObject, eventdata, handles)
     [filename, path] = uigetfile({'.wav;.mp3'}, 'Select Audio File');
        if filename == 0
            return; % User canceled
        end

        filePath = fullfile(path, filename);
        [audio, fs] = audioread(filePath);
        % Adjust the volume by scaling the amplitude
        volumeFactor = 2.0; % Adjust the scaling factor (2.0 for doubling the volume)
        pvAudio = volumeFactor * audio;
        % Display the signals
        t = (0:length(audio)-1) / fs; % Time vector
        plot(handles.axes1, t, audio);
        plot(handles.axes2, t, pvAudio);
        % Create audioplayer objects
        playerOriginal = audioplayer(audio, fs);
        playerpv = audioplayer(pvAudio, fs);
        % Play the original and increased volume signals sequentially
        playblocking(playerOriginal);
        playblocking(playerpv);
        % Store audio data in handles structure
        handles.audio = pvAudio;
        handles.fs = fs;
        % Update handles structure
        guidata(hObject, handles);

function mS_Callback(hObject, eventdata, handles)
        [filename, path] = uigetfile({'.wav;.mp3'}, 'Select Audio File');
        if filename == 0
            return; % User canceled
        end

        filePath = fullfile(path, filename);
        [audio, fs] = audioread(filePath);
        speedFactor = 0.5;
        audioOut = stretchAudio(audio, speedFactor);
        t = (0:length(audio)-1) / fs;  
        tResampled = (0:length(audioOut)-1) / (speedFactor * fs);
        plot(handles.axes1, t, audio);
        plot(handles.axes2, tResampled, audioOut);
        % Create audioplayer objects
        playerOriginal = audioplayer(audio, fs);
        playerLoud = audioplayer(audioOut, fs);
        % Play the original and increased volume signals sequentially
        playblocking(playerOriginal);
        playblocking(playerLoud);
        % Store audio data in handles structure
        handles.audio = audioOut;
        handles.fs = fs;
        % Update handles structure
        guidata(hObject, handles);

function pS_Callback(hObject, eventdata, handles)
 [filename, path] = uigetfile({'.wav;.mp3'}, 'Select Audio File');
    if filename == 0
        return; % User canceled
    end

    filePath = fullfile(path, filename);
    [audio, fs] = audioread(filePath);
    speedupFactor = 2;
    audioOut = stretchAudio(audio, speedupFactor);   
    t = (0:length(audio)-1) / fs;  
    tResampled = (0:length(audioOut)-1) / (speedupFactor * fs);
    plot(handles.axes1, t, audio);
    plot(handles.axes2, tResampled, audioOut);
    % Create audioplayer objects
    playerOriginal = audioplayer(audio, fs);
    playerLoud = audioplayer(audioOut, fs);
    % Play the original and increased volume signals sequentially
    playblocking(playerOriginal);
    playblocking(playerLoud);
    % Store audio data in handles structure
    handles.audio = audioOut;
    handles.fs = fs;
    % Update handles structure
    guidata(hObject, handles);

function add_n_Callback(hObject, eventdata, handles)
    % Assume you have loaded an audio file previously (similar to playAudioFile)
    [filename, path] = uigetfile({'.wav;.mp3'}, 'Select Audio File');
    if filename == 0
        return; % User canceled
    end

    filePath = fullfile(path, filename);
    [audio, fs] = audioread(filePath);
    % Generate white noise
    whiteNoise = 0.1 * randn(size(audio)); % Adjust the amplitude (0.1 in this case)
    % 0.1 reduces the amplitude of the random numbers
    % Add white noise to the audio file
    noisyAudio = audio + whiteNoise;
    % Display and play the signals
    t = (0:length(audio)-1) / fs; % Time vector
    plot(handles.axes1, t, audio);
    plot(handles.axes2, t, noisyAudio);
    % Play the original and noisy signals
    % Create audioplayer objects
    playerOriginal = audioplayer(audio, fs);
    playernoisyAudio = audioplayer(noisyAudio, fs);
    % Play the original and sped up signals sequentially
    playblocking(playerOriginal);
    playblocking(playernoisyAudio);
    % Store audio data in handles structure
    handles.audio = noisyAudio;
    handles.fs = fs;
    % Update handles structure
    guidata(hObject, handles);

function add_e_Callback(hObject, eventdata, handles)
    % Prompt user to select an audio file
    [filename, path] = uigetfile({'.wav;.mp3'}, 'Select Audio File');
    if filename == 0
        return;
    end

    % Read the selected audio file
    filePath = fullfile(path, filename);
    [audio, fs] = audioread(filePath);
    playerOriginal = audioplayer(audio, fs);
    playblocking(playerOriginal);
    
    sound(audio, fs);
    % Display the original signal
    t_original = (0:length(audio) - 1) / fs;
    cla(handles.axes1);
    plot(handles.axes1, t_original, audio);
    % Add an echo by combining the original signal with a delayed version
    delay = 0.5;
    % Calculates the number of samples to delay 
    numSamplesDelay = round(delay * fs);
    % Ensure that the echo length matches the audio length
    echo = [zeros(numSamplesDelay, size(audio, 2)); audio(1:end-numSamplesDelay, :)];
    % Play the echoed audio
    sound(echo, fs);
    % Display the echoed signal
    t_echo = (0:length(echo) - 1) / fs;
    cla(handles.axes2);
    plot(handles.axes2, t_echo, echo);
    % Store audio data in handles structure
    handles.audio = echo;
    handles.fs = fs;
    % Update handles structure
    guidata(hObject, handles);

function G_beep_Callback(hObject, eventdata, handles)
    fs = 44100; % Sampling frequency
    t = 0:1/fs:1; % Time vector for 1 second
    beepSignal = sin(2*pi*1000*t); % Beep signal at 1000 Hz
    plot(handles.axes1, t, beepSignal);
    plot(handles.axes2, t, beepSignal);
    sound(beepSignal, fs);
    % Store audio data in handles structure
    handles.audio = beepSignal;
    handles.fs = fs;
    % Update handles structure
    guidata(hObject, handles);

function G_wn_Callback(hObject, eventdata, handles)
    fs = 44100; % Sampling frequency
    noiseSignal = randn(1, fs); % White noise
    t = (0:length(noiseSignal)-1) / fs; % Time vector
    plot(handles.axes1, t, noiseSignal);
    plot(handles.axes2, t, noiseSignal);
    sound(noiseSignal, fs);
    % Store audio data in handles structure
    handles.audio = noiseSignal;
    handles.fs = fs;
    % Update handles structure
    guidata(hObject, handles);

function uipanel3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in svout_btn.
function svout_btn_Callback(hObject, eventdata, handles)
    % Check if audio data is available
    if isempty(handles.audio)
        msgbox('No audio data available.', 'Error', 'error');
        return;
    end

    % Prompt the user to select a location for saving the output audio
    [filename, path] = uiputfile({'*.wav', 'Waveform Audio File Format (*.wav)'; '*.mp3', 'MPEG-1 Audio Layer III (*.mp3)'}, 'Save Output Audio');

    % Check if the user canceled the operation
    if isequal(filename, 0)
        return;
    end

    % Construct the full output file path
    outputFilePath = fullfile(path, filename);

    % Write the audio to the selected file
    try
        audiowrite(outputFilePath, handles.audio, handles.fs);
        msgbox('Audio saved successfully!', 'Success', 'help');
    catch
        msgbox('Error saving audio. Please try again.', 'Error', 'error');
    end


% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
