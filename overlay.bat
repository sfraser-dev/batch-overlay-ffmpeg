@echo off

if NOT EXIST "%1" (
    goto MAIN
)
goto ERROR1

:MAIN
::--------------------
:: 5 second video
::--------------------
echo overlay transparent FET logo to 5secs.mp4, re-encodes video (out1.mp4)
echo %time%
ffmpeg -y -i vidin5secs.mp4 -i fetlogo.png -filter_complex "[0:v][1:v] overlay=600:25:enable='between(t,0,20)'" -pix_fmt yuv420p -c:a copy out1.mp4 2> nul
echo %time%
echo.

:: GIMP transparent image: http://www.wikihow.com/Make-a-Transparent-Image-Using-Gimp
echo overlay transparent GIMP image to 5secs.mp4, re-encodes video (out2.mp4)
echo %time%
ffmpeg -y -i vidin5secs.mp4 -i pipetran.png -filter_complex "[0:v][1:v] overlay=300:300:enable='between(t,0,20)'" -pix_fmt yuv420p -c:a copy out2.mp4 2> nul
echo %time%
echo.

::--------------------
:: 17 second video
::--------------------
echo overlay logo to 17sec.mp4, re-encodes video (out3.mp4)
echo %time%
ffmpeg -y -i vidin17secs.mp4 -i fetlogo.png -filter_complex "[0:v][1:v] overlay=600:25:enable='between(t,0,20)'" -pix_fmt yuv420p -c:a copy out3.mp4 2> nul
echo %time%
echo.

echo convert 17secs.mp4 to 17secs.yuv
echo %time%
ffmpeg -y -i vidin17secs.mp4 -c:v rawvideo -pix_fmt yuv420p -an vidin17secs.yuv 2> nul
echo %time%
echo.

:: using raw video as input, it is much quicker to overlay a logo
echo overlay logo to 17sec.yuv
echo %time%
ffmpeg -y -f rawvideo -c:v rawvideo -s 1920x1080 -r 30 -pix_fmt yuv420p -i vidin17secs.yuv -i fetlogo.png -filter_complex "[0:v][1:v] overlay=300:300:enable='between(t,0,20)'" -pix_fmt yuv420p -c:a copy out4.yuv 2> nul
echo %time%
echo.

goto END


:ERROR1
echo ERROR: "no input arguments expected"
goto END


:END
