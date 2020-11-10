#!/usr/bin/env python3 
# -*- coding: utf-8 -*-
from inary.actionsapi import autotools
from inary.actionsapi import inarytools
from inary.actionsapi import get
def setup():
  autotools.configure()

def build():
  autotools.make()

def install():
  autotools.rawInstall("DESTDIR={}".format(get.installDIR()))
