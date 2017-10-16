@echo off
REM overlay filter can overlay an image/video but requires a full re-encode; so just use video with one frame
REM Medialooks Live Mixer (PiP) can solve this issue (create transparent video with FFmpeg chromakey and use as the PiP); use 1 frame video to speed up chromakey filter

REM
REM Create a 50 second "main" video
REM
ffmpeg -y -i 20170905094204905^@DVR-01_Ch1.mp4 -ss 00:00:00 -t 50 z11.mp4

REM
REM FFmpeg image with transparency to video
REM 
REM create a one-frame MP4 video using a PNG image (with transparency, created in GIMP) as input
::ffmpeg -y -loop 1 -i pipetransparent.png -r 30 -vframes 150 -c:v png -pix_fmt rgba z22.mp4


REM
REM FFmpeg Drawtext / Alphamerge / Chromakey
REM 
REM alphamerge (not working with Medialooks Mixing)
REM create video (1 second) with drawtext (FET VisualSoft) on a black background
::ffmpeg -y -f lavfi -i color=c=black:s=1920x1080:d=1 -vf "drawtext=fontfile='C\:\\Windows\\Fonts\\Arial.ttf':fontsize=30:fontcolor=white:x=(w-text_w)/2:y=(h-text_h)/2:text='FET VisualSoft'" z33.mp4
REM create video (1 frame) with drawtext (FET VisualSoft) on a black background
::ffmpeg -y -f lavfi -i color=c=black:s=1920x1080 -vf "drawtext=fontfile='C\:\\Windows\\Fonts\\Arial.ttf':fontsize=30:fontcolor=white:x=(w-text_w)/2:y=(h-text_h)/2:text='FET VisualSoft'" -frames:v 1 z33.png
REM "greenscreen" the black background to transparent (re-encodes the video)
::ffmpeg -y -i z33.png -filter_complex "[0]split[m][a];[a]format=yuv420p,geq='if(lt(lum(X,Y),0),0,255)',hue=s=0[al];[m][al]alphamerge,format=rgba" z44.png

REM drawtext video with chromakey (WORKING with Medialooks Mixing)
ffmpeg -y -f lavfi -i color=c=black:s=1920x1080 -vf "drawtext=fontfile='C\:\\Windows\\Fonts\\Arial.ttf':fontsize=230:fontcolor=red:x=(w-text_w)/2:y=(h-text_h)/2:text='FET VisualSoft'" -r 30 -frames:v 1500 z33.mp4
ffmpeg -y -i z33.mp4 -vf "chromakey=0x0x000000:0.1:0.2" -c copy -c:v png -pix_fmt rgba z44.mp4


REM
REM FFmpeg Subtitles
REM 
REM Medialooks has: Sample File Playback (has OSD / logos / text / rolling text)
REM Medialooks has: Sample Mixer Chromakey
::ffmpeg -y -f lavfi -i color=c=black:s=1920x1080:d=60 -vf "drawtext=fontfile='C\:\\Windows\\Fonts\\Arial.ttf':fontsize=230:fontcolor=red:x=(w-text_w)/2:y=(h-text_h)/2:text='FET VisualSoft'" z55.mp4
echo.> mysubs.srt
echo.1>> mysubs.srt
echo.00:00:00,000 --^> 00:00:10,000>> mysubs.srt
echo.- Hello, welcome>> mysubs.srt
echo. >> mysubs.srt
echo.2>> mysubs.srt
echo.00:00:11,000 --^> 00:00:20,000>> mysubs.srt
echo.- VisualSoft subtitles>> mysubs.srt
echo.>> mysubs.srt
echo.3>> mysubs.srt
echo.00:00:21,000 --^> 00:00:30,000>> mysubs.srt
echo.- Part of Forum Energy Technologies>> mysubs.srt
echo.>> mysubs.srt
echo.4>> mysubs.srt
echo.00:00:31,000 --^> 00:00:40,000>> mysubs.srt
echo.- Everything remotely possible>> mysubs.srt
echo.>> mysubs.srt
echo.5>> mysubs.srt
echo.00:00:41,000 --^> 00:00:49,800>> mysubs.srt
echo.- Subsea Inspection>> mysubs.srt
echo.>> mysubs.srt

::echo.1> mysubs.srt
::echo.00:00:00,300 --^> 00:00:01,500>> mysubs.srt
::echo.- Hello, welcome>> mysubs.srt
::echo.>> mysubs.srt
::echo.2>> mysubs.srt
::echo.00:00:01,700 --^> 00:00:03,000>> mysubs.srt
::echo.- VisualSoft subtitles 111>> mysubs.srt
::echo.>> mysubs.srt
::echo.3>> mysubs.srt
::echo.00:00:03,300 --^> 00:00:04,000>> mysubs.srt
::echo.- VisualSoft subtitles 222>> mysubs.srt
::echo.>> mysubs.srt
::echo.4>> mysubs.srt
::echo.00:00:04,200 --^> 00:00:04,900>> mysubs.srt
::echo.- VisualSoft subtitles 333>> mysubs.srt
::echo.>> mysubs.srt
::ffmpeg -y -i z44.mp4 -f srt -i mysubs.srt -c:v copy -an -c:s mov_text z55.mp4

REM 
REM Print info to screen 
REM 
echo.
echo.number of frames in z11.mp4:
mediainfo --Output=Video^;%%FrameCount%% z11.mp4
echo.
echo.
echo.number of frames in z33.mp4:
mediainfo --Output=Video^;%%FrameCount%% z33.mp4
echo.
echo.
echo.number of frames in z44.mp4:
mediainfo --Output=Video^;%%FrameCount%% z44.mp4
echo.

REM
REM Create container with transparent video first and underlying video second
REM
::ffmpeg -y -i z44.mp4 -i z11.mp4 -i mysubs.srt -map 0:v -c:v copy -an -map 1:v -c:v copy -an -map 2:s -c:s mov_text z55.mp4
ffmpeg -y -i z44.mp4 -i z11.mp4 -i mysubs.srt -map 0:v -c:v copy -an -map 1:v -c:v copy -an z55.mp4

