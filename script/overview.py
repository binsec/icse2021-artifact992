#!/usr/bin/python

kerror   = [ 'failure', 'unsupported' ]
kwarning = [ 'cc' ]
kissue = [ 'token-read', 'token-write', \
           'register-read', 'register-write', \
           'memory-read', 'memory-write', \
           'unicity' ]
kwrite = [ 'cc', 'token-write', 'register-write', 'memory-write' ]
kread = [ 'token-read', 'register-read', 'memory-read' ]

import sys
import pandas as pd
import numpy as np

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
                      df['kind'].isin(kwarning) & (df['patch'] == 0), \
                      df['kind'].isin(kissue) & (df['patch'] == 0), \
                      df['kind'].isin(kerror) ], \
                    axis=1, \
                    keys=[ 'project', 'chunk',
                           'has_warning',
                           'has_issue',
                           'has_error' ])

def describe(view):
    n = len(view[~view['has_warning'] & ~view['has_issue']])
    print("  fully compliant " + str(n))
    n = len(view[view['has_warning'] & ~view['has_issue']])
    print("  only benign issues " + str(n))
    n = len(view[view['has_issue'] == True])
    print("  serious issues " + str(n))


# start to build general statistics about projects
if has_project:
    view = initial.groupby('project').max()
    print("Package considered " + str(len(view)))
    print("Initial:")
    describe(view)
    view = patched.groupby('project').max()
    print("Patched:")
    describe(view)
    print

# start to build general statistics about chunks
view = initial.groupby(['project', 'chunk']).max()
print("Assembly chunks " + str(len(view)))
view = view[~view['has_error']]
print("Relevant chunks " + str(len(view)))
print("Initial:")
describe(view)
view = patched[~patched['has_error']].groupby(['project', 'chunk']).max()
print("Patched:")
describe(view)
print


# enumerate issues
def describe(view):
    print("Found issues " + str(len(view)))
    n = len(view[view['kind'].isin(kissue)])
    print("  significant issues " + str(n))
    n = len(view[view['kind'].isin(kwrite)])
    print("Frame-write " + str(n))
    n = len(view[view['kind'] == 'cc'])
    print("  flag register clobbered " + str(n))
    n = len(view[view['kind'] == 'token-write'])
    print("  read-only input clobbered " + str(n))
    n = len(view[view['kind'] == 'register-write'])
    print("  unbound register clobbered " + str(n))
    n = len(view[view['kind'] == 'memory-write'])
    print("  unbound memory clobbered " + str(n))
    n = len(view[view['kind'].isin(kread)])
    print("Frame-read " + str(n))
    n = len(view[view['kind'] == 'token-read'])
    print("  non written write-only output " + str(n))
    n = len(view[view['kind'] == 'register-read'])
    print("  unbound register read " + str(n))
    n = len(view[view['kind'] == 'memory-read'])
    print("  unbound memory access " + str(n))
    n = len(view[view['kind'] == 'unicity'])
    print("Unicity " + str(n))

print("Initial:")
view = df[df['kind'].isin(kissue) | df['kind'].isin(kwarning)]
describe(view)
print

print("Patched:")
view = df[(df['kind'].isin(kissue) | df['kind'].isin(kwarning)) \
          & (df['patch'] == 0)]
describe(view)


exit()
