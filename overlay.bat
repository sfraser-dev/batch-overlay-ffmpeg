@echo off

if NOT EXIST "%1" (
    goto MAIN
)
goto ERROR1

:MAIN
::--------------------
:: 5 second video
::--------------------
echo overlay transparent FET logo to 5secs.mp4, re-encodes whole video (out1.mp4)
echo %time%
ffmpegLocal -y -i vidin5secs.mp4 -i fetlogo.png -filter_complex "[0:v][1:v] overlay=600:25" -pix_fmt yuv420p -c:a copy out1.mp4 2> nul
echo %time%
echo.

:: GIMP transparent image: http://www.wikihow.com/Make-a-Transparent-Image-Using-Gimp
echo overlay transparent GIMP image to 5secs.mp4, re-encodes whole video (out2.mp4)
echo %time%
ffmpegLocal -y -i vidin5secs.mp4 -i pipetransparent.png -filter_complex "[0:v][1:v] overlay=300:300" -pix_fmt yuv420p -c:a copy out2.mp4 2> nul
echo %time%
echo.

::--------------------
:: 17 second video
::--------------------
echo overlay transparent FET logo to 17sec.mp4, re-encodes whole video (out3.mp4)
echo %time%
ffmpegLocal -y -i vidin17secs.mp4 -i fetlogo.png -filter_complex "[0:v][1:v] overlay=600:25" -pix_fmt yuv420p -c:a copy out3.mp4 2> nul
echo %time%
echo.

echo overlay transparent FET logo to 17sec.mp4 for only 3 seconds, but still re-encodes the whole video (out4.mp4)
echo %time%
ffmpegLocal -y -i vidin17secs.mp4 -i fetlogo.png -filter_complex "[0:v][1:v] overlay=600:25:enable='between(t,0,3)'" -pix_fmt yuv420p -c:a copy out4.mp4 2> nul
echo %time%
echo.

echo convert 17secs.mp4 to 17secs.yuv
echo %time%
ffmpegLocal -y -i vidin17secs.mp4 -c:v rawvideo -pix_fmt yuv420p -an vidin17secs.yuv 2> nul
echo %time%
echo.

echo overlay transparent FET logo to 17sec.yuv (out5.mp4)
echo %time%
ffmpegLocal -y -f rawvideo -c:v rawvideo -s 1920x1080 -r 30 -pix_fmt yuv420p -i vidin17secs.yuv -i fetlogo.png -filter_complex "[0:v][1:v] overlay=300:300" -pix_fmt yuv420p -c:a copy out5.yuv 2> nul
echo %time%
echo.

::--------------------
:: 30 minute video
:: not feasible, 1920*1080*3/2*25*60*60/1000000000 = 279.936GB for a 30 minute 1920x1080 YUV420 video file
::--------------------
::echo convert 30min.mp4 to 30min.yuv
::echo %time%
::ffmpegLocal -y -i vidin30min.mp4 -c:v rawvideo -pix_fmt yuv420p -an vidin30min.yuv 2> nul
::echo %time%
::echo.
::echo overlay transparent FET logo to 30min.yuv (out5.mp4)
::echo %time%
::ffmpegLocal -y -f rawvideo -c:v rawvideo -s 1920x1080 -r 25 -pix_fmt yuv420p -i vidin30min.yuv -i fetlogo.png -filter_complex "[0:v][1:v] overlay=300:300" -pix_fmt yuv420p -c:a copy out999.yuv 2> nul
::echo %time%
::echo.

goto END

:ERROR1
echo ERROR: "no input arguments expected"
goto END

:END
