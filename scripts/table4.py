#!/usr/bin/python

kerror   = [ 'failure', 'unsupported' ]
kwarning = [ 'cc' ]
kissue = [ 'token-read', 'token-write', \
           'register-read', 'register-write', \
           'memory-read', 'memory-write', \
           'unicity' ]
kwrite = [ 'cc', 'token-write', 'register-write', 'memory-write' ]
kread = [ 'token-read', 'register-read', 'memory-read' ]
kunicity = [ 'unicity' ]

import sys
import pandas as pd
import numpy as np
from tabulate import tabulate

if len(sys.argv) != 3:
    print('Usage: {script} file1.csv file2.csv')
    exit -1

# read data from input file
df1 = pd.read_csv(sys.argv[1])
df2 = pd.read_csv(sys.argv[2])

def signed(x):
    return '{:+}'.format(x)

def percent(x):
    return '{:+.0%}'.format(x)

def rate(x, y):
    if y == 0:
        return '--'
    else:
        return percent(float(x - y) / y)

def line(label, filter, view1, view2):
    view1 = view1[view1['kind'].isin(filter)]
    view2 = view2[view2['kind'].isin(filter)]
    x = len(view1)
    y = len(view2)
    a = len(view1[view1['kind'].isin(kissue)])
    b = len(view2[view2['kind'].isin(kissue)])
    return \
        [
            [ label, x, signed(y - x), rate(y, x) ],
            [ '> significant', a, signed(b - a), rate(b, a) ]
        ]

def diff(view1, view2):
    return \
        line('Total', kissue + kwarning, view1, view2) + \
        [ [] ] + \
        line('frame-read', kread, view1, view2) + \
        [ [] ] + \
        line('frame-write', kwrite, view1, view2) + \
        [ [] ] + \
        line('unicity', kunicity, view1, view2)

view1 = df1[df1['kind'].isin(kissue) | df1['kind'].isin(kwarning)]
view2 = df2[df2['kind'].isin(kissue) | df2['kind'].isin(kwarning)]
print(tabulate(diff(view2, view1), \
               headers=['Compliance issues', 'RUSTInA', 'Basic', 'rate']))

exit()
