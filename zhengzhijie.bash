#!/bin/bash

export ANDROID_STUDIO=~/android-dev-tools
export ANDROID_HOME=$ANDROID_STUDIO/sdk

function ifind()
{
	find . -name .repo -prune -o -name .git -prune -o -name .svn -prune -o -name "*" -type f | grep -i --color -E "$@"
}

WORKSPACE=~/workspace
IHOME=~/workspace/android/rrd-finance/finance

function icd()
{
	local target_prj_path;
    if [ ! "$1" ]; then
		cd $IHOME
        return;
    fi;
    target_prj_path=$WORKSPACE/$1;
    cd $target_prj_path
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

	find -L . -name .idea -prune -o -name .repo -prune -o -name build -prune -o -name .git -prune -o -name .svn -prune -o -type f -name "*$target" -print0 | xargs -0 grep --color -n $@
}

function jsgrep()
{
		find . -name .repo -prune -o -name .git -prune -o -type f -name "*\.js" -print0 | xargs -0 grep --color -n "$@"
}

function jgrep()
{
		find . -name .repo -prune -o -name .git -prune -o -type f -name "*\.java" -print0 | xargs -0 grep --color -n "$@"
}

function cgrep()
{
	find . -name .repo -prune -o -name .git -prune -o -type f \( -name '*.c' -o -name '*.cc' -o -name '*.cpp' -o -name '*.h' \) -print0 | xargs -0 grep --color -n "$@" 
}

function resgrep()
{
	for dir in `find . -name .repo -prune -o -name .git -prune -o -name res -type d`; do find $dir -type f -name '*\.xml' -print0 | xargs -0 grep --color -n "$@"; done;
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
TOOLSDIR=~/workspace/tools/unix_env
source $TOOLSDIR/adb-completion.bash
source $TOOLSDIR/npm-completion.bash
source $TOOLSDIR/git-completion.bash
ln -fs $TOOLSDIR/configs/.gitconfig ~/.gitconfig
ln -fs $TOOLSDIR/configs/.vimrc ~/.vimrc

alias l='ls'
alias la='ls -al'
alias b='cd -'
alias ll='ls -l'

export PATH=$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$ANDROID_HOME/ndk-bundle:$PATH
export PATH=~/bin:$PATH
export PATH=$ANDROID_STUDIO/android-studio/jre/bin:$PATH

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
