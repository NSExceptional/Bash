import lldb
import commands
import optparse
import shlex
import os

def bet(debugger, command, result, internal_dict):
    """An alias for `b objc_exception_throw`"""
    debugger.HandleCommand("b objc_exception_throw")

def ios(debugger, command, result, internal_dict):
    """Selects `remote-ios` platform and connects to $IPHONEIP:12345` for debugging"""
    debugger.HandleCommand("b objc_exception_throw")
    ip = os.environ['IPHONEIP']
    debugger.HandleCommand("platform select remote-ios")

    print 'Connecting to ' + ip + '...'
    debugger.HandleCommand("process connect connect://" + ip + ":12345")

def ios2(debugger, command, result, internal_dict):
    """Selects `remote-ios` platform and connects to $IPHONEIP:12345` for debugging"""
    ip = os.environ['IPHONEIP']
    debugger.HandleCommand("platform select remote-ios")

    print 'Connecting to ' + ip + '...'
    debugger.HandleCommand("process connect connect://" + ip + ":12345")

def __lldb_init_module(debugger, dict):
    def add_cmd(command):
        debugger.HandleCommand('command script add -f tblldb.' + command + ' ' + command)

    add_cmd('bet')
    add_cmd('ios')
    add_cmd('ios2')
