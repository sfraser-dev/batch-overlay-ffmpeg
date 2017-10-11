@echo off
REM-- overlay filter can overlay an image/video but requires a full re-encode; so just use video with one frame
REM-- Medialooks Live Mixer (PiP) can solve this issue (create transparent video with FFmpeg chromakey and use as the PiP); use 1 frame video to speed up chromakey filter


REM--
REM-- FFmpeg image with transparency to video
REM-- 
REM-- create a one-frame MP4 video using a PNG image (with transparency, created in GIMP) as input
::ffmpeg -y -loop 1 -i pipetransparent.png -r 1 -vframes 1 -c:v png -pix_fmt rgba z22.mp4


REM--
REM-- FFmpeg Drawtext / Alphamerge / Chromakey
REM-- 
REM-- alphamerge (not working with Medialooks Mixing)
REM-- create video (1 second) with drawtext (FET VisualSoft) on a black background
::ffmpeg -y -f lavfi -i color=c=black:s=1920x1080:d=1 -vf "drawtext=fontfile='C\:\\Windows\\Fonts\\Arial.ttf':fontsize=30:fontcolor=white:x=(w-text_w)/2:y=(h-text_h)/2:text='FET VisualSoft'" z33.mp4
REM--create video (1 frame) with drawtext (FET VisualSoft) on a black background
::ffmpeg -y -f lavfi -i color=c=black:s=1920x1080 -vf "drawtext=fontfile='C\:\\Windows\\Fonts\\Arial.ttf':fontsize=30:fontcolor=white:x=(w-text_w)/2:y=(h-text_h)/2:text='FET VisualSoft'" -frames:v 1 z33.png
REM--"greenscreen" the black background to transparent (re-encodes the video)
::ffmpeg -y -i z33.png -filter_complex "[0]split[m][a];[a]format=yuv420p,geq='if(lt(lum(X,Y),0),0,255)',hue=s=0[al];[m][al]alphamerge,format=rgba" z44.png

REM-- chromakey (WORKING with Medialooks Mixing)
::ffmpeg -y -f lavfi -i color=c=black:s=1920x1080 -vf "drawtext=fontfile='C\:\\Windows\\Fonts\\Arial.ttf':fontsize=230:fontcolor=red:x=(w-text_w)/2:y=(h-text_h)/2:text='FET VisualSoft'" -frames:v 1 z33.mp4
::ffmpeg -y -i z33.mp4 -vf "chromakey=0x0x000000:0.1:0.2" -c copy -c:v png -pix_fmt rgba z44.mp4


REM--
REM-- FFmpeg Subtitles
REM-- 
REM-- Medialooks has: Sample File Playback (has OSD / logos / text / rolling text)
REM-- Medialooks has: Sample Mixer Chromakey
ffmpeg -y -f lavfi -i color=c=black:s=1920x1080:d=7 -vf "drawtext=fontfile='C\:\\Windows\\Fonts\\Arial.ttf':fontsize=230:fontcolor=red:x=(w-text_w)/2:y=(h-text_h)/2:text='FET VisualSoft'" z55.mp4
echo.1> mysubs.srt
echo.00:00:00,000 --^> 00:00:01,500>> mysubs.srt
echo.- Hello>> mysubs.srt
echo.>> mysubs.srt
echo.2>> mysubs.srt
echo.00:00:01,700 --^> 00:00:04,000>> mysubs.srt
echo.- test test test>> mysubs.srt
echo.>> mysubs.srt
echo.3>> mysubs.srt
echo.00:00:04,300 --^> 00:00:07,000>> mysubs.srt
echo.- about to stop. bye!>> mysubs.srt
echo.>> mysubs.srt
ffmpeg -y -i z55.mp4 -f srt -i mysubs.srt -c:v copy -an -c:s mov_text z66.mp4


