#!/bin/bash

export ANDROID_STUDIO=~/android-dev-tools
export ANDROID_HOME=$ANDROID_STUDIO/sdk

function ifind()
{
	find . -name .idea -prune -o -name .repo -prune -o -name .git -prune -o -name .svn -prune -o -name "*" -type f | grep -i --color -E "$@"
}

function vimifind()
{
	fileFind=`ifind $1`
	size=`echo $fileFind|wc -w`
	if [$size -eq 0 ]; then
		echo "nothing found"
	elif [ $size -eq 1 ];then
		vim $fileFind
	else
		select file in $(ifind $1);
		do
			vim $file
			break
		done
	fi
}

WORKSPACE=~/workspace
IHOME=~/workspace/mrstore

function mod()
{
	if [ $# -eq 1 ];then
		let ans=$1%256
		echo $ans
	elif [ $# -eq 2 ];then
		let ans=$2%$1
		echo $ans
	else
		echo Usage: mod num1 num2, return num2%num1
	fi
}

function icd()
{
	local target_prj_path;
	if [ "$#" -gt 0 ]; then
		cd $IHOME/$1
	else
		cd $IHOME
	fi
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

	find -L . -name target -prune -o -name .idea -prune -o -name node_modules -prune -o -name .repo -prune -o -name dist -prune -o -name build -prune -o -name .git -prune -o -name .svn -prune -o -type f -name "*$target" -print0 | xargs -0 grep --color -n $@
}

function jsgrep()
{
		find . -name .repo -prune -o -name .git -prune -o -name dist -prune -o -name node_modules -prune -o -name build -prune -o -type f -name "*\.js" -print0 | xargs -0 grep --color -n "$@"
}

function jgrep()
{
		find . -name .repo -prune -o -name .git -prune -o -name dist -prune -o -name build -prune -o -type f -name "*\.java" -print0 | xargs -0 grep --color -n "$@"
}

function cgrep()
{
	find . -name .repo -prune -o -name .git -prune -o -type f \( -name '*.c' -o -name '*.cc' -o -name '*.cpp' -o -name '*.h' \) -print0 | xargs -0 grep --color -n "$@" 
}

function resgrep()
{
	for dir in `find . -name .repo -prune -o -name node_modules -prune -o -name build -prune -o -name .git -prune -o -name res -type d -print`; do find $dir -type f -name '*\.xml' -print0 | xargs -0 grep --color -n "$@"; done;
}

function xmlgrep()
{
	find . -name target -prune -o -name .idea -prune -o -name .repo -prune -o -name .git -prune -o -name dist -prune -o -name build -prune -o -name target -prune -o -type f -name "*\.xml" -print0 | xargs -0 grep --color -n "$@"
}

function finddotgitdir()
{
    TARGET_DIR=.git;
    local HERE=$PWD;
    T=;
    while [ $PWD != "/" ]; do
        T=`PWD= /bin/pwd`;
        if [ -d "$T/$TARGET_DIR" ]; then
            echo $T;
            \cd $HERE;
            return;
        fi;
        \cd ..;
    done;
    \cd $HERE
}

function iroot()
{
    if [ "$(finddotgitdir)" ]; then
        DEST=$(echo $(finddotgitdir))
        cd $DEST
    else
        echo "couldn't find a .git in this repo"
    fi
}

function ts()
{
	if [ ${#1} -gt 10 ]
	then
		let seconds=$1/1000
	else
		let seconds=$1
	fi
  date -r $seconds "+%Y-%m-%d %H:%M:%S"
}

TOOLSDIR=~/workspace/tools/unix_env
source $TOOLSDIR/adb-completion.bash
source $TOOLSDIR/npm-completion.bash
source $TOOLSDIR/git-completion.bash
source $TOOLSDIR/kubectl-completion.bash
ln -fs $TOOLSDIR/configs/.gitconfig ~/.gitconfig
ln -fs $TOOLSDIR/configs/.vimrc ~/.vimrc
export PATH=$TOOLSDIR/bin:$PATH
export PATH=/opt/go/bin:$PATH
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_261.jdk/Contents/Home/

alias l='ls'
alias la='ls -al'
alias b='cd -'
alias ll='ls -l'
alias mvninstall='mvn clean install -DskipTests'
alias mvnpackage='mvn clean package -DskipTests -U'
alias gollum='gollum --live-preview --adapter rugged'

export PATH=$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_STUDIO/ndk:$PATH

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="/Users/jostein/.sdkman"
[[ -s "/Users/jostein/.sdkman/bin/sdkman-init.sh" ]] && source "/Users/jostein/.sdkman/bin/sdkman-init.sh"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

export NVM_DIR="$HOME/.nvm"
if test "Linux" != $(uname);then
  . "$(brew --prefix nvm)/nvm.sh"
fi

[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
