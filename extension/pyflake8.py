#!/usr/bin/env python

import commands
import re
import sys


def make_re(*msgs):
    return re.compile('(%s)' % '|'.join(msgs))

pyflakes_ignore = make_re('unable to detect undefined names')
pyflakes_warning = make_re(
    'imported but unused',
    'is assigned to but never used',
    'redefinition of unused',
    'too many blank lines',
    'blank line contains whitespace',
)
pep8_ignore = ['E501']
pep8_warning = make_re('.')


def run(cmd, ignore_re, warning_re):
    output = commands.getoutput(cmd)
    for line in output.splitlines():
        if ignore_re and ignore_re.search(line):
            continue
        elif ': ' in line and warning_re.search(line):
            line = '%s: WARNING %s' % tuple(line.split(': ', 1))
        print line

options = "--max-line-length=120"
run('flake8 %s %s' % (options, sys.argv[1]), pyflakes_ignore, pyflakes_warning)
print '## pyflakes above, pep8 below ##'
