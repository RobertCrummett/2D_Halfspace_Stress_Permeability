function video_file = Create_Video_File(Frames, file_name, video_file_frame_rate)
% Creates an MP4 video file from frames
% Saves video to current directory.
%
% Inputs:
% Frames - Output of Plot_Stress_Feild() function.
% file_name - String to title the file with.
%
% Optional Inputs:
% video_file_frame_rate = Frame rate fo the video file.
%                                                Default is 10.
%
% Output:
% video_file - An MP4 video file.

if ~exist("video_file_frame_rate","var")
    video_file_frame_rate = 10;
end

video_file = VideoWriter(file_name,"MPEG-4");
video_file.FrameRate = video_file_frame_rate;
open(video_file)
writeVideo(video_file, Frames);
close(video_file)

end