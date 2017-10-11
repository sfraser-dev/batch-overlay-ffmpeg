@echo off

:: create a one-frame MP4 video using a PNG image (with transparency, created in GIMP) as input
::ffmpeg -y -loop 1 -i pipetransparent.png -r 1 -vframes 1 -c:v png -pix_fmt rgba z22.mp4

:: create video (1 second) with drawtext (FET VisualSoft) on a black background
::ffmpeg -y -f lavfi -i color=c=black:s=1920x1080:d=1 -vf "drawtext=fontfile='C\:\\Windows\\Fonts\\Arial.ttf':fontsize=30:fontcolor=white:x=(w-text_w)/2:y=(h-text_h)/2:text='FET VisualSoft'" z33.mp4
:: create video (1 frame) with drawtext (FET VisualSoft) on a black background
::ffmpeg -y -f lavfi -i color=c=black:s=1920x1080 -vf "drawtext=fontfile='C\:\\Windows\\Fonts\\Arial.ttf':fontsize=30:fontcolor=white:x=(w-text_w)/2:y=(h-text_h)/2:text='FET VisualSoft'" -frames:v 1 z33.png
:: "greenscreen" the black background to transparent (re-encodes the video)
::ffmpeg -y -i z33.png -filter_complex "[0]split[m][a];[a]format=yuv420p,geq='if(lt(lum(X,Y),0),0,255)',hue=s=0[al];[m][al]alphamerge,format=rgba" z44.png

ffmpeg -y -f lavfi -i color=c=black:s=1920x1080 -vf "drawtext=fontfile='C\:\\Windows\\Fonts\\Arial.ttf':fontsize=230:fontcolor=red:x=(w-text_w)/2:y=(h-text_h)/2:text='FET VisualSoft'" -frames:v 1 z33.mp4
ffmpeg -y -i z33.mp4 -vf "chromakey=0x0x000000:0.1:0.2" -c copy -c:v png -pix_fmt rgba z44.mp4