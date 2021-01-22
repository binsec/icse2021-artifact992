#!/usr/bin/python

kerror   = [ 'failure', 'unsupported' ]
kwarning = [ 'cc' ]
kissue = [ 'token-read', 'token-write', \
           'register-read', 'register-write', \
           'memory-read', 'memory-write', \
           'unicity' ]
kwrite = [ 'cc', 'token-write', 'register-write', 'memory-write' ]
kread = [ 'token-read', 'register-read', 'memory-read' ]

def percent(x):
    return '{:.0%}'.format(x)
def rate(x, y):
    if y == 0:
        return '--'
    else:
        return percent(float(x)/y)

import sys
import pandas as pd
import numpy as np
from tabulate import tabulate

if len(sys.argv) != 2:
    print('Usage: {script} file.csv')
    exit -1

# read data from input file
df = pd.read_csv(sys.argv[1])


has_project = 'project' in df
if not has_project:
    df['project'] = ''

initial = pd.concat([ df['project'], df['id'], \
                      df['kind'].isin(kwarning), \
                      df['kind'].isin(kissue), \
                      df['kind'].isin(kerror) ], \
                    axis=1, \
                    keys=[ 'project', 'chunk',
                           'has_warning',
                           'has_issue',
                           'has_error' ])
patched = pd.concat([ df['project'], df['id'], \
                      df['kind'].isin(kwarning) & (df['patch'] == '0'), \
                      df['kind'].isin(kissue) & (df['patch'] == '0'), \
                      df['kind'].isin(kerror) ], \
                    axis=1, \
                    keys=[ 'project', 'chunk',
                           'has_warning',
                           'has_issue',
                           'has_error' ])

def table(initial, patched):
    tt = len(initial)
    ic = len(initial[~initial['has_warning'] & ~initial['has_issue']])
    pc = len(patched[~patched['has_warning'] & ~patched['has_issue']])
    iw = len(initial[initial['has_warning'] & ~initial['has_issue']])
    pw = len(patched[patched['has_warning'] & ~patched['has_issue']])
    ii = len(initial[initial['has_issue'] == True])
    pi = len(patched[patched['has_issue'] == True])
    return \
        [
            [ '- fully compliant', ic, rate(ic, tt), pc, rate(pc, tt) ],
            [ '- only benign issues', iw, rate(iw, tt), pw, rate(pw, tt) ],
            [ '- serious issues', ii, rate(ii, tt), pi, rate(pi, tt) ]
        ]

# start to build general statistics about projects
if has_project:
    view = initial.groupby('project').max()
    print("Package considered " + str(len(view)))
    print(tabulate(table(view, patched.groupby('project').max()), \
                   headers=['Packages', 'Initial', '', 'Patched', '']))
    print

# start to build general statistics about chunks
view = initial.groupby(['project', 'chunk']).max()
print("Assembly chunks " + str(len(view)))
view = view[~view['has_error']]
print("Relevant chunks " + str(len(view)))
view2 = patched[~patched['has_error']].groupby(['project', 'chunk']).max()
print(tabulate(table(view, view2), \
               headers=['Chunks', 'Initial', '', 'Patched', '']))
print


def line(label,filter,initial,patched):
    a = len(initial)
    b = len(initial[initial['kind'].isin(filter)])
    x = len(patched)
    y = len(patched[patched['kind'].isin(filter)])
    return \
        [
            [ label, b, rate(b, a), y, rate(y, x) ]
        ]


# enumerate issues
def describe(initial,patched):
    return \
        line('Found issues', kissue + kwarning, initial, patched) + \
        line('> serious issues', kissue, initial, patched) + \
        [ [] ] + \
        line('frame-write', kwrite, initial, patched) + \
        line('- flag register clobbered', ['cc'], initial, patched) + \
        line('- read-only clobbered', ['token-write'], initial, patched) + \
        line('- register clobbered', ['register-write'], initial, patched) + \
        line('- unbound memory access', ['memory-write'], initial, patched) + \
        [ [] ] + \
        line('frame-read', kread, initial, patched) + \
        line('- non initialized output', ['token-read'], initial, patched) + \
        line('- unbound register read', ['register-read'], initial, patched) + \
        line('- unbound memory access', ['memory-read'], initial, patched) + \
        [ [] ] + \
        line('unicity', ['unicity'], initial, patched)

initial = df[df['kind'].isin(kissue) | df['kind'].isin(kwarning)]
patched = df[(df['kind'].isin(kissue) | df['kind'].isin(kwarning)) \
          & (df['patch'] == '0')]
print(tabulate(describe(initial, patched), \
               headers=['', 'Initial', '', 'Patched', '']))


exit()
