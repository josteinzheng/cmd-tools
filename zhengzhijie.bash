#!/bin/bash


ANDROID_PROJECT=~/source/android-4.4
export ANDROID_STUDIO=~/android-studio
export ANDROID_HOME=$ANDROID_STUDIO/sdk
source $ANDROID_PROJECT/build/envsetup.sh

function ifind()
{
	find . -name .repo -prune -o -name .git -prune -o -name .svn -prune -o -name "*" -type f | grep -i --color -E "$@"
}

IHOME=~/workspace/android/we_android/finance
function icd()
{
	cd $IHOME
}

function switch () 
{ 
    local PROJECT_PATH cur_path cur_prj_path target_prj_path target_path;
    PROJECT_PATH=/home_backup/home/zhijzheng;
    cur_path=$(pwd);
    cur_prj_path=$(gettop);
    if [ ! "$cur_prj_path" ]; then
        echo "Couldn't locate the top of the tree.  Try setting TOP." 1>&2;
        return;
    fi;
    if [ ! "$1" ]; then
        echo "give me a project name, please!" 1>&2;
        return;
    fi;
    target_prj_path=$PROJECT_PATH/$1;
    target_path=`echo $cur_path | sed "s:$cur_prj_path:$target_prj_path:"`;
    cd $target_path
}

function where()
{
	IFS="${IFS}:"
	flag=0
	for dirname in `echo ${PATH}`
	do
		test -x "${dirname}/$1" && echo "${dirname}/$1"
	done
}

function up()
{
	base='../'
	path='../'
	number=1
	Usage="Usage:\n\tup 2 = cd ../../\n\tup 3 = cd ../../../"

	if [ $# -eq 0 ];then
		cd $path
	elif [ $# -eq 1 ];then
		echo "$1" | grep -e "^[[:digit:]]*$" -q
		result=$?
		if [ $result -eq "0" ];then
	        while [ $number -lt $1 ]
			do
	           path=$path$base
	           let "number=$number+1"
	        done
	        cd $path
	    else
	        echo "Argument must be a number."
	        echo -e $Usage
	    fi  
	else
		    echo -e $Usage
	fi
}

function igrep()
{
	target=""

	if [ "$#" -gt 1 ];then 
	    target=.$1
	    shift
	fi

	find -L . -name .repo -prune -o -name build -prune -o -name .git -prune -o -name .svn -prune -o -type f -name "*$target" -print0 | xargs -0 grep --color -n $@
}

function iroot()
{
    if [ "$(findmakefile)" ]; then 
        DEST=$(echo $(findmakefile) | sed '{s/\/[^\/]*$//}')
        cd $DEST
    else 
        echo "couldn't find a Android.mk file in this module"
    fi   
}

if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi

source ~/.adb-completion

alias l='ls'
alias la='ls -al'
alias b='cd -'
alias ll='ls -l'

export PATH=~/android-studio/sdk/tools:~/android-studio/sdk/platform-tools:~/android-studio/ndk:$PATH
export PATH=~/bin:$PATH

# rails project production env need this
export SECRET_KEY_BASE="4967c5afbda01e65598d0951bedc1ba8e89542a6dc6a2dee956156b2694907a44c7a7ae4c7d57dc1f74d751fa86946325902dd3acf33c90da5c162bced1e8e77"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/jostein/.sdkman"
[[ -s "/Users/jostein/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/jostein/.sdkman/bin/sdkman-init.sh"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export NVM_DIR="$HOME/.nvm"
. "$(brew --prefix nvm)/nvm.sh"
