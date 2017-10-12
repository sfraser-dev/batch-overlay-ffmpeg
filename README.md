z44.mp4 is a video with transparency (“green-screened” / “chroma-keyed” with FFmpeg). If you use the Medialooks’ “Sample Live Mixing.exe” with z44.mp4 as the PiP and adjust the alpha transparency, this only adjusts the transparency of the black in the z44.mp4 video, not the red writing.
 
What are the files?
z22.mp4: creating a 1 frame video (made from an image with transparency using GIMP). This works as the PiP when adjusting transparency.
z33.mp4: a one frame 1920x1080 video created by FFmpeg with a black background and red writing. This does NOT work as the PiP when adjusting transparency (the whole video is affected by alpha).
z44.mp4: chroma-keying z33.mp4 to make only the black transparent. This works as the PiP when adjusting transparency.
 
Notes:
1)     Although a video can have transparency, normal players (VLC, Quicktime, etc) will not show this transparency (as there is “nothing else” under the transparency to see).
2)     H264 video doesn’t support transparency, although MP4 containers do.
3)     Medialooks’ Mixing PiP appears to only allow videos as input, hence why 1 frame videos are created above (these videos are played on loop).
4)     Adjusting the size of the PiP to completely overlay the main video is trivial in the “Sample Live Mixing.exe” app (change the PiP size and start location).
