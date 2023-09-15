rmdir /s /q darwin 
rmdir /s /q linux 
rmdir /s /q win32 
rmdir /s /q win64 

mkdir darwin 2> NUL
mkdir linux 2> NUL
mkdir win32 2> NUL
mkdir win64 2> NUL

xcopy resources darwin\resources\ /e
xcopy resources linux\resources\ /e
xcopy resources win32\resources\ /e
xcopy resources win64\resources\ /e

xcopy ..\..\binaries\darwin\ darwin\ /b
xcopy ..\..\binaries\linux\ linux\ /b
xcopy ..\..\binaries\win32\ win32\ /b
xcopy ..\..\binaries\win64\ win64\ /b

echo DONE