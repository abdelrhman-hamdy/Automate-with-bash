#!/bin/bash

# this simple script reads the total memory and the  available memory, then check if the available is more than 50% of total or less,then sends an email to the adminstrator on Gmail stating the memory state either OK or ALARAM in case of lack of available memory


# mail configurations 
subject="Monitoring the Memory"
recipient="abdelrhman.hamdy9999@gmail.com"




total_mem=$(grep MemTotal /proc/meminfo |  tr -s ' '  |  cut -d' ' -f2) # greping the total memory of system 
avail_mem=$(grep MemAvailable /proc/meminfo |  tr -s ' '  |  cut -d' ' -f2) # greping available memory of system

mem_state=$(echo "($avail_mem*100) / $total_mem" | bc)  # calculating memory state as percentage of total memory 


if [ $mem_state -gt 50 ];then                            # testing if available memory more than 50% of total 
state='State : OK'

mail="Subject:${subject}\n\n${state}.\n"                 

echo -e $mail | /usr/sbin/sendmail "$recipient"         # sending the email to the admin

echo 'State : OK'

elif [ $mem_state -lt 50 ];then                        # testing if available memory less than 50% of total
state='State : ALARM'      

mail="Subject:${subject}\n\n${state}.\n"

echo -e $mail | /usr/sbin/sendmail "$recipient"       # sending the email to the admin

echo 'State : ALRAM'

else
echo  'There is an Error either in the script or in the system please check it'
fi
