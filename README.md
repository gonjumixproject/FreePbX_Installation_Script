# FreePbX_Installation_Script

FreePBX 14-Ubuntu 18.04-Asterisk 13 Installation Script

I created this script to perform quick installation for the new clean servers, it is basicly for my 5$ digiltaocean server. 

Make sure the read below;

This is an Installation Script For ==>>
<pre/>
Server Version : Ubuntu 18.04 
FreePBX Version : FreePBX 14 
Asterisk Version: Asterisk 13.18.3 
</pre>


The script will only work if you are ROOT user </br>
Become ROOT user if you did not already</br>

The script will work for the clean server image without any installation</br>
If you want to reinstall FreePBX, the script will fail


https://wiki.freepbx.org/display/FOP/Installing+FreePBX+14+on+Ubuntu+18.04 page is used


How to Use it :
<pre/>
su -
git clone https://github.com/gonjumixproject/FreePbX_Installation_Script
cd FreePbX_Installation_Script/
./Installation_Script.sh
</pre>

FreePBX 14 to 15 Upgrade:
<pre/>root@gonca:~# fwconsole ma downloadinstall
root@gonca:~# fwconsole versionupgrade --check
root@gonca:~# fwconsole reload
root@gonca:~# fwconsole chown
root@gonca:~# fwconsole versionupgrade --check
root@gonca:~# fwconsole versionupgrade --upgrade
</pre>
