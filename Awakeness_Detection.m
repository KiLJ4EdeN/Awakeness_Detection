function Awakeness_Detection(address)
% Create a cascade detector object.
faceDetector1 = vision.CascadeObjectDetector('LeftEye', 'MinSize', [30 30], 'MaxSize', [50 50], 'ScaleFactor', 1.1);
faceDetector2 = vision.CascadeObjectDetector('RightEye', 'MinSize', [30 30], 'MaxSize', [50 50],  'ScaleFactor', 1.1);
% Read a video frame and run the detector.
videoFileReader = vision.VideoFileReader(address);
i = 0;
bbox1 = [];
bbox2 = [];
videoPlayer = vision.VideoPlayer('Name', 'Awakeness Detection', 'Position', [450 50 1000 500]);
while true
    i = i + 1;
    videoFrame      = step(videoFileReader);
    videoFrame = rgb2gray(videoFrame);
    if not(isempty(bbox1))
    res1 = bbox1;
    end
    if not(isempty(bbox2))
    res2 = bbox2;
    end
    bbox1            = step(faceDetector1, videoFrame);
    bbox2            = step(faceDetector2, videoFrame);
    if (isempty(bbox1)) && (isempty(bbox2))
        fprintf('both eyes closed!\n')
        videoOut = insertObjectAnnotation(videoFrame,'rectangle',res1,'CLOSED!', 'Color', 'Red');
        videoOut = insertObjectAnnotation(videoOut,'rectangle',res2,'CLOSED!', 'Color', 'Red');
        step(videoPlayer, videoOut);
    elseif isempty(bbox1)
        fprintf('left eye closed!\n')
        videoOut = insertObjectAnnotation(videoFrame,'rectangle',res1,'CLOSED!', 'Color', 'Red');
        step(videoPlayer, videoOut);
    elseif isempty(bbox2)
        fprintf('right eye closed!\n')
        videoOut = insertObjectAnnotation(videoFrame,'rectangle',res2,'CLOSED!', 'Color', 'Red');
        step(videoPlayer, videoOut);
    else
        % Draw the returned bounding box around the detected face.
        videoOut = insertObjectAnnotation(videoFrame,'rectangle',bbox1,'Open', 'Color', 'Cyan');
        videoOut = insertObjectAnnotation(videoOut,'rectangle',bbox2,'Open', 'Color', 'Cyan');
        step(videoPlayer, videoOut);
    end
end
end
