#! /usr/bin/expect

set TERMSERV $env(host)
set TERMPORT $env(port)
set TERMUSER $env(username)

set timeout 3

# 登录跳转机
spawn ssh $TERMUSER@$TERMSERV -p $TERMPORT
expect {
	"yes/no" {send "yes\r"; exp_continue; }	
	"Opt" {send -- "$env(searchStr)\r"}
}

if { "p" ne "$env(searchStr)" } {
	expect {
		"www@*" {
			send "cd `dirname /data/logs/**/*.log.info`\r"
			send "tail -f *.log.info *.log.wf"
		}
		"*Host" {
		}
	}
}



interact
