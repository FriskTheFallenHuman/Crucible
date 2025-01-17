clear
echo --------------------------------------------------------------------------------
COLUMNS=$(tput cols)
title="CRUCIBLE ENGINE"
printf "%*s\n" $(((${#title}+$COLUMNS)/2)) "$title"
COLUMNS=$(tput cols)
title="Ninja GENERATION FOR x86 - x64"
printf "%*s\n" $(((${#title}+$COLUMNS)/2)) "$title"
COLUMNS=$(tput cols)
title="DEBUG BUILD"
printf "%*s\n" $(((${#title}+$COLUMNS)/2)) "$title"
echo --------------------------------------------------------------------------------
#cd ..
rm -rf buildDb > /dev/null 2>&1
mkdir buildDb > /dev/null 2>&1
cd buildDb
echo Generating files
cmake -G "Ninja" -DCMAKE_BUILD_TYPE=Debug .. > log.txt ||(
echo ERROR Generating files
cd ..
rmdir /Q /S buildDb
#read -rsp $'Press any key to continue...\n' -n1 key
)
#read -rsp $'Press any key to continue...\n' -n1 key
echo Files generated Successfully
