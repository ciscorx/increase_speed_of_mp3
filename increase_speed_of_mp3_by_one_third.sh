#!/bin/sh

###############################
##  increase_speed_of_mp3_by_one_third.sh  
###############################
#  Automates xvfb and audacity to increase speed of given mp3, or
#  latest mp3 file in currrent directory, by .33 ...useful for getting
#  through podcasts

#  Requirements: linux, xvfb, xautomation, scrot 0.8-18+,
#  , Imagemagick (for optionally outputting
#  screenshots), gcc (to optionally compile the c programs for marking
#  up screen shots)

#  Tested using Audacity v2.3.3 on ubuntu 20.04 
#  Authors/maintainers: ciscorx@gmail.com
#  License: GNU GPL v3

if [ $# = 0 ]; then
    FILENAME=`ls -t *.mp3|awk 'NR==1'`
else
    if [ $1 = "--help" ] || [ $1 = "-h"]; then
	echo "Increases speed of mp3 by one third.  If no mp3 file is provided as an argument, then the latest mp3 file in the current directory is chosen.  The output seems to end up in /tmp"
	exit 3
    else
	FILENAME=$1
    fi
fi
SPEEDFACTOR="1.33"
DISP=:99
AUDACITY_CACHE_DIR=/tmp/aud
SHORTPAUSE=30000
LONGPAUSE=300000
XLONGPAUSE=3000000
output_screenshots=1
step_temp_dir=/tmp/$0

rm -rf $step_temp_dir
rm -rf $AUDACITY_CACHE_DIR
mkdir -p $AUDACITY_CACHE_DIR
mkdir -p $step_temp_dir
step=0

rnd() {
python -S -c "import random; print random.randrange($1,$2)"
}

rnd_offset() {
python -S -c "import random; print random.randrange($1,$(($1 + $2)))"
}

get_md5 () {
    rm -rf /tmp/targ.ppm
    DISPLAY=$DISP scrot -a $1,$2,$3,$4 /tmp/targ.ppm
    tmpmd5=`md5sum /tmp/targ.ppm | awk '{print $1}'`

    if [ $output_screenshots = 1 ]; then
	cp /tmp/targ.ppm $step_temp_dir/$(printf "%.3d" $step)\ -$tmpmd5.ppm
	rm -rf /tmp/fullscreen.ppm
	DISPLAY=$DISP scrot /tmp/fullscreen.ppm
	cp /tmp/fullscreen.ppm $step_temp_dir/$step\ -\ $1\ $2\ $3\ $4.ppm
	./draw_a_rectangle_in_a_ppm_file.o $step_temp_dir/$step\ -\ $1\ $2\ $3\ $4.ppm $1 $2 $3 $4
	./draw_a_circle_in_a_ppm_file.o $step_temp_dir/$step\ -\ $1\ $2\ $3\ $4.ppm $(($1+$3/2)) $(($2+$4/2)) $3
	convert $step_temp_dir/$step\ -\ $1\ $2\ $3\ $4.ppm  $step_temp_dir/$(printf "%.3d" $step)\ -\ $1\ $2\ $3\ $4.png
	rm $step_temp_dir/$step\ -\ $1\ $2\ $3\ $4.ppm
    fi
    echo $tmpmd5
}


pkill Xvfb
sleep 1
Xvfb $DISP -fbdir /tmp &
DISPLAY=$DISP audacity $FILENAME&

sleep 5 
    

# check some projects can be recovered
md5=$(get_md5 405 380 467 35)
if [ $output_screenshots = 1 ]; then
echo $step - $md5; step=$(($step + 1))  #### step:0
fi

if [ $md5 = "43648852c227719a8caaaeb03a105a90" ] || [ $md5 = "2db79e9317b342331408edeade3ecc93" ]; then

    # check for Discard recoverable project button
    md5=$(get_md5 575 618 110 15)
    if [ $output_screenshots = 1 ]; then
	echo $step - $md5; step=$(($step + 1))  #### step:0
    fi
    
    if [ $md5 = "022bae8783e0994fdfcf81be804a6776" ]; then

	DISPLAY=$DISP xte  'mousemove 620 623' 'usleep 300000' 'mouseclick 1' "usleep $XLONGPAUSE"
	echo clicked discard recoverable projects button

	# check Are you sure you want to discard all recoverable projects?
	md5=$(get_md5 485 455 410 60)
	if [ $output_screenshots = 1 ]; then
	    echo $step - $md5; step=$(($step + 1))  #### step:0
	fi
    
	if [ $md5 = "c0adfce9291683b2d1d599cf77feea9a" ]; then


	    # check for yes im sure button
	    md5=$(get_md5 770 544 25 13)
	    if [ $output_screenshots = 1 ]; then
		echo $step - $md5; step=$(($step + 1))  #### step:0
	    fi
    
	    if [ $md5 = "a07c16bd4878c07c2a8195fcffbd2dbc" ]; then
		DISPLAY=$DISP xte  'mousemove 770 544' 'usleep 300000' 'mouseclick 1' 'usleep 4000000'
		echo clicked the Yes im sure i want to discard all recoverable projects button
	    fi
	fi
    fi
fi



sleep 6



# pause until finished importing file
# check for time remaining message
md5=$(get_md5 550 503 115 44)
if [ $output_screenshots = 1 ]; then
    echo $step - $md5; step=$(($step + 1))  #### step:0
fi

while [ $md5 = 'c4cfb3deee5ad93630fd27693576e659' ]; do
    sleep 10
# check again for time remaining message
    md5=$(get_md5 550 503 115 44)
    if [ $output_screenshots = 1 ]; then
	echo $step - $md5; step=$(($step + 1))  #### step:0
    fi
done


# check Dont show this again at startup message
md5=$(get_md5 395 466 235 13)
if [ $output_screenshots = 1 ]; then
    echo $step - $md5; step=$(($step + 1))  #### step:0
fi

if [ $md5 = "2fca3977526cf90da90275c82e702518" ]; then
    DISPLAY=$DISP xte  'mousemove 403 472' 'mouseclick 1' 'usleep 3000000'
    echo clicked Dont start this again at startup
fi


# check Dont show this again at startup message
md5=$(get_md5 835 463 21 15)
if [ $output_screenshots = 1 ]; then
    echo $step - $md5; step=$(($step + 1))  #### step:0
fi

if [ $md5 = "62359f896f1d75d83461e94e714019ee" ]; then
    DISPLAY=$DISP xte  'mousemove 845 470' 'mouseclick 1' 'usleep 2000000'
    echo clicked ok to tips window
fi

sleep 5

DISPLAY=$DISP xte 'keydown Control_L' "usleep $SHORTPAUSE" 'str a' "usleep $LONGPAUSE" 'keyup Control_L' "usleep $XLONGPAUSE"


# check Effects menu 
md5=$(get_md5 570 168 40 18)
if [ $output_screenshots = 1 ]; then
    echo $step - $md5; step=$(($step + 1))  #### step:0
fi

if [ $md5 = "50fc28cea46a0e0c80933d35e0974bab" ]; then
    DISPLAY=$DISP xte  'mousemove 590 176' 'mouseclick 1' 'usleep 2000000'
    echo clicked Effects menu

    # check for Change speed menu option 
    md5=$(get_md5 595 348 92 14 )
    if [ $output_screenshots = 1 ]; then
	echo $step - $md5; step=$(($step + 1))  #### step:0
    fi
    
    if [ $md5 = "10876ac5b4e9374958f3a273b203fc1f" ]; then
	DISPLAY=$DISP xte  'mousemove 640 355' 'mouseclick 1' 'usleep 2000000'
	echo clicked Change speed

	if [ $md5 = "50fc28cea46a0e0c80933d35e0974bab" ]; then
	    DISPLAY=$DISP xte  'mousemove 590 176' 'mouseclick 1' 'usleep 2000000'
	    echo clicked Effects menu
	    # check for error in not selecting audo 
	    md5=$(get_md5 338 478 605 15 )
	    if [ $output_screenshots = 1 ]; then
		echo $step - $md5; step=$(($step + 1))  #### step:0
	    fi
	    
	    if [ $md5 = "e46ac2c9a244f67ab033b3855c59d480" ]; then
		# check for ok button 
		md5=$(get_md5 890 530 20 15 )
		if [ $output_screenshots = 1 ]; then
		    echo $step - $md5; step=$(($step + 1))  #### step:0
		fi
		if [ $md5 = "d22cc4330b90071b564c23235e111027" ]; then
		    DISPLAY=$DISP xte  'mousemove 900 537' 'mouseclick 1' "usleep $XLONGPAUSE"
		    echo clicked ok to must choose audio first
		fi
	    fi
	fi
    elif [ $md5 = "953b449749f6b1ed5d69fee7d6132d23" ]; then 
	echo The Change Speed menu option is disabled, quitting
    fi
    
fi

# check for Change speed dialog header 
md5=$(get_md5 486 370 308 14)
if [ $output_screenshots = 1 ]; then
    echo $step - $md5; step=$(($step + 1))  #### step:0
fi

if [ $md5 = "47a9844cc33e1614f58ef8d292968a89" ]; then
    # click on speed factor field @ 600 420
    
    # rm -f $FILENAME
    sleep 5
    DISPLAY=$DISP xte 'mousemove 600 420' 'mouseclick 1' 'mouseclick 1' "usleep $XLONGPAUSE" 'keydown Control_L' 'str a' 'keyup Control_L' "usleep $LONGPAUSE" 'key BackSpace' "usleep $XLONGPAUSE" "str $SPEEDFACTOR" "usleep $LONGPAUSE" 'key Return'
fi

sleep 1


# pause until finished applying speed
# check for if applying speed
md5=$(get_md5 553 437 175 14)
if [ $output_screenshots = 1 ]; then
    echo $step - $md5; step=$(($step + 1))  #### step:0
fi

while [ $md5 = 'bf31d7f2cdf946f6039fc98f33481385' ]; do
    sleep 10
# check again if still applying speed
    md5=$(get_md5 553 437 175 14)
    if [ $output_screenshots = 1 ]; then
	echo $step - $md5; step=$(($step + 1))  #### step:0
    fi
done


# check for file menu
md5=$(get_md5 177 170 25 13)
if [ $output_screenshots = 1 ]; then
    echo $step - $md5; step=$(($step + 1))  #### step:0
fi

if [ $md5 = '9a2f013a62d2b7585f7448e100f47a17' ]; then
    sleep 1
    DISPLAY=$DISP xte 'mousemove 187 177' 'mouseclick 1' "usleep $LONGPAUSE"
    echo  clicked File menu option

    
    # check for export menu option
    md5=$(get_md5 200 324 45 13)
    if [ $output_screenshots = 1 ]; then
	echo $step - $md5; step=$(($step + 1))  #### step:0
    fi

    if [ $md5 = 'fbd96807b66fc26eecd45d17e6a868f9' ]; then
	sleep 1
	DISPLAY=$DISP xte 'mousemove 220 330' 'mouseclick 1' "usleep $XLONGPAUSE" 'key Return' "usleep $XLONGPAUSE" 'key Return' "usleep $XLONGPAUSE" 'key Right' "usleep $LONGPAUSE" 'str _fast'  "usleep $LONGPAUSE" 'key Return'
	DISPLAY=$DISP xte "usleep $XLONGPAUSE" 'key Return' 
	echo clicked export menu option
	sleep 3
    fi
    sleep 1

    # pause until finished exporting file
    # check for time remaining message
    md5=$(get_md5 503 430 150 23)
    if [ $output_screenshots = 1 ]; then
	echo $step - $md5; step=$(($step + 1))  #### step:0
    fi

    while [ $md5 = '1e22e42ef5de7f73a2bee5052fe15e10' ]; do
	sleep 10
	# check again for time remaining message
	md5=$(get_md5 503 430 150 23)
	if [ $output_screenshots = 1 ]; then
	    echo $step - $md5; step=$(($step + 1))  #### step:0
	fi
    done

    
    
fi

DISPLAY=$DISP xte 'keydown Control_L' 'str q' 'keyup Control_L' "usleep $LONGPAUSE"
# check Save project before closing? 
md5=$(get_md5 595 462 190 14)
if [ $output_screenshots = 1 ]; then
echo $step - $md5; step=$(($step + 1))  #### step:0
fi

if [ $md5 = "a8ceef9ac34f9c8e343baaec42c64666" ]; then

    # check for No, im not saving project button 
    md5=$(get_md5 512 545 20 13)
    if [ $output_screenshots = 1 ]; then
	echo $step - $md5; step=$(($step + 1))  #### step:0
    fi

    if [ $md5 = "a8ceef9ac34f9c8e343baaec42c64666" ]; then

	DISPLAY=$DISP xte  'mousemove 522 551' 'mouseclick 1' 'usleep 2000000'
	echo clicked No, Im not saving project on closing

    fi

    
fi

sleep 5
pkill Xvfb


# DISPLAY=:99 xte 'keydown Control_L' 'str q' 'keyup Control_L' "usleep 2000000"  'mousemove 522 551' 'mouseclick 1'
