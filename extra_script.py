Import('env')
env.Replace(FUSESCMD="avrdude -U -e -Ulfuse:w:0xe2:m")