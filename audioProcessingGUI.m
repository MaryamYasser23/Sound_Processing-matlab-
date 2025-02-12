function soundProcessingGUI
    % Create the GUI
    fig = GUI;

    % Set up callback functions from GUI
    setappdata(fig, 'generateBeepCallback', @generateBeep);
    setappdata(fig, 'generateNoiseCallback', @generateNoise);
    setappdata(fig, 'playAudioFileCallback', @playAudioFile);
    setappdata(fig, 'addNoiseToFileCallback', @addNoiseToFile);
    setappdata(fig, 'recordAudioCallback', @recordAudio);
    setappdata(fig, 'adjustVolumeCallback', @adjustVolume);
    setappdata(fig, 'adjustSpeedCallback', @adjustSpeed);
    setappdata(fig, 'addEchoCallback', @addEcho);
    setappdata(fig, 'removeNoiseCallback', @removeNoise);
    setappdata(fig, 'subtractSignalsCallback', @subtractSignals);
    setappdata(fig, 'multiplySignalsCallback', @multiplySignals);
    setappdata(fig, 'plotSignalCallback', @plotSignal);

    % Callback functions

    function generateBeep(~, ~)
        fs = 44100; % Sampling frequency
        t = 0:1/fs:1; % Time vector for 1 second
        beepSignal = sin(2*pi*1000*t); % Beep signal at 1000 Hz
        plot(subplot1, t, beepSignal);
        title(subplot1, 'Original Signal (Beep)');
        sound(beepSignal, fs);
    end

    function generateNoise(~, ~)
        fs = 44100; % Sampling frequency
        noiseSignal = randn(1, fs); % White noise
        t = (0:length(noiseSignal)-1) / fs; % Time vector
        plot(subplot1, t, noiseSignal);
        title(subplot1, 'Original Signal (White Noise)');
        sound(noiseSignal, fs);
    end

    function playAudioFile(~, ~)
        [filename, path] = uigetfile({'.wav;.mp3'}, 'Select Audio File');
        if filename == 0
            return; % User canceled
        end

        filePath = fullfile(path, filename);
        [audio, fs] = audioread(filePath);

        t = (0:length(audio)-1) / fs; % Time vector
        plot(subplot1, t, audio);
        title(subplot1, 'Original Signal');

        sound(audio, fs);
    end

    function addNoiseToFile(~, ~)
        % Assume you have loaded an audio file previously (similar to playAudioFile)
        [filename, path] = uigetfile({'.wav;.mp3'}, 'Select Audio File');
        if filename == 0
            return; % User canceled
        end

        filePath = fullfile(path, filename);
        [audio, fs] = audioread(filePath);

        % Step 2: Generate white noise
        whiteNoise = 0.1 * randn(size(audio)); % Adjust the amplitude (0.1 in this case)

        % Step 3: Add white noise to the audio file
        noisyAudio = audio + whiteNoise;

        % Step 4: Display and play the signals
        t = (0:length(audio)-1) / fs; % Time vector
        subplot(subplot1);
        plot(t, audio, 'b', t, noisyAudio, 'r');
        title(subplot1, 'Original (Blue) vs Noisy (Red)');

        % Play the original and noisy signals
        sound(audio, fs);
        pause(1); % Pause between sounds
        sound(noisyAudio, fs);
    end

    function recordAudio(~, ~)
        fs = 44100; % Set the sampling frequency
        recorder = audiorecorder(fs, 16, 1); % Create an audio recorder

        disp('Recording... Press stop when done.');
        record(recorder); % Start recording

        % Wait for the user to stop recording
        uiwait(msgbox('Recording... Press OK to stop recording.', 'Recording', 'modal'));
        stop(recorder); % Stop recording

        % Get the recorded audio data
        recordedAudio = getaudiodata(recorder);

        % Display and play the recorded signal
        t = (0:length(recordedAudio)-1) / fs; % Time vector
        subplot(subplot1);
        plot(t, recordedAudio);
        title(subplot1, 'Recorded Signal');

        sound(recordedAudio, fs);
    end

    function adjustVolume(~, ~)
        % Assume you have loaded an audio file previously (similar to playAudioFile)
        [filename, path] = uigetfile({'.wav;.mp3'}, 'Select Audio File');
        if filename == 0
            return; % User canceled
        end

        filePath = fullfile(path, filename);
        [audio, fs] = audioread(filePath);

        % Adjust the volume by scaling the amplitude
        adjustedAudio = 0.5 * audio; % Adjust the scaling factor (0.5 in this case)

        % Display and play the signals
        t = (0:length(audio)-1) / fs; % Time vector
        subplot(subplot1);
        plot(t, audio, 'b', t, adjustedAudio, 'r');
        title(subplot1, 'Original (Blue) vs Adjusted Volume (Red)');

        % Play the original and adjusted volume signals
        sound(audio, fs);
        pause(1); % Pause between sounds
        sound(adjustedAudio, fs);
    end

    function adjustSpeed(~, ~)
    [filename, path] = uigetfile({'.wav;.mp3'}, 'Select Audio File');
    if filename == 0
        return; % User canceled
    end

    filePath = fullfile(path, filename);
    [audio, fs] = audioread(filePath);

    % Adjust the speed by changing the sampling rate
    newFs = fs * 0.5; % Adjust the speed factor (0.5 in this case)

    % Use the interp1 function for resampling
    tOriginal = (0:length(audio)-1) / fs;
    tResampled = (0:1/newFs:tOriginal(end));
    resampledAudio = interp1(tOriginal, audio, tResampled, 'linear', 0);

    % Display and play the signals
    subplot(subplot1);
    plot(tOriginal, audio, 'b', tResampled, resampledAudio, 'r');
    title(subplot1, 'Original (Blue) vs Adjusted Speed (Red)');

    % Play the original and adjusted speed signals
    sound(audio, fs);
    pause(1);
    sound(resampledAudio, round(newFs));
end





    function addEcho(~, ~)
    [filename, path] = uigetfile({'.wav;.mp3'}, 'Select Audio File');
    if filename == 0
        return;
    end

    filePath = fullfile(path, filename);
    [audio, fs] = audioread(filePath);

    % Add an echo by combining the original signal with a delayed version
    delay = 0.5;
    numSamplesDelay = round(delay * fs);

    % Ensure that the echo length matches the audio length
    echo = [zeros(numSamplesDelay, size(audio, 2)); audio];

    % Display and play the signals
    t = (0:length(audio) + numSamplesDelay - 1) / fs; % Adjust time vector length
    subplot(subplot1);
    plot(t, echo, 'r'); % Adjust plot
    title(subplot1, 'Echo (Red)');

    % Play the original and echo signals
    sound(audio, fs);
    pause(1);
    sound(echo, fs);
end



    function removeNoise(~, ~)
        % Assume you have loaded an audio file previously (similar to playAudioFile)
        [filename, path] = uigetfile({'.wav;.mp3'}, 'Select Audio File');
        if filename == 0
            return; % User canceled
        end

        filePath = fullfile(path, filename);
        [audio, fs] = audioread(filePath);

        % Implement code to remove noise from the audio file
        % For example, you can use a noise reduction algorithm from the Signal Processing Toolbox

        % Display and play the signals
        t = (0:length(audio)-1) / fs; % Time vector
        subplot(subplot1);
        plot(t, audio, 'b');
        title(subplot1, 'Original Signal');

        % Play the original signal
        sound(audio, fs);
    end

  function subtractSignals(~, ~)
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

    % Determine the minimum length of the two signals
    minLength = min(length(signal1), length(signal2));

    % Take the first 'minLength' samples from each signal
    signal1 = signal1(1:minLength);
    signal2 = signal2(1:minLength);

    % Subtract one signal from another
    subtractedSignal = signal1 - signal2;

    % Display and play the signals
    t = (0:minLength-1) / fs1; % Time vector
    subplot(subplot1);
    plot(t, signal1, 'b', t, signal2, 'g');
    title(subplot1, 'Signal 1 (Blue) vs Signal 2 (Green)');

    subplot(subplot2);
    plot(t, subtractedSignal, 'r');
    title(subplot2, 'Subtracted Signal (Red)');

    % Play the original signals and subtracted signal
    sound(signal1, fs1);
    pause(1); % Pause between sounds
    sound(signal2, fs2);
    pause(1);
    sound(subtractedSignal, fs1);
end


   function multiplySignals(~, ~)
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

    % Display and play the signals
    t = (0:length(multipliedSignal)-1) / fs1; % Time vector
    subplot(subplot1);
    plot(t, signal1, 'b', t, signal2, 'g');
    title(subplot1, 'Signal 1 (Blue) vs Signal 2 (Green)');

    subplot(subplot2);
    plot(t, multipliedSignal, 'm');
    title(subplot2, 'Multiplied Signal (Magenta)');

    % Play the original signals and multiplied signal
    sound(signal1, fs1);
    pause(1); % Pause between sounds
    sound(signal2, fs2);
    pause(1);
    sound(multipliedSignal, fs1);  % Play the multiplied signal
end

    function plotSignal(~, ~)
        % Assume you have loaded an audio file previously (similar to playAudioFile)
        [filename, path] = uigetfile({'.wav;.mp3'}, 'Select Audio File');
        if filename == 0
            return; % User canceled
        end

        filePath = fullfile(path, filename);
        [audio, fs] = audioread(filePath);

        % Plot the audio signal
        t = (0:length(audio)-1) / fs; % Time vector
        subplot(subplot1);
        plot(t, audio);
        title(subplot1, 'Original Signal');
    end
end