ESPRESSO
========
by Jens Dahl Møllerhøj

# What is espresso?
A lightning fast game development engine. It is used to build tiny html5
canvas games in minutes. Espresso is written entirely in coffeescript.

Espresso is influenced by the rails philosophy in the way that it is
oppinionated, emphasizes convention over configuration, is DRY, and supports
agile development.

Its API resamples the way 'Game Maker' by Mark Overmars works.

# Why is iterative design so important?
In classic software, an iterative development process help catch bugs early,
and lets the system be designed as the developer learns. In indie game
development, iterative processes lets the developer design games as
development goes.

It is not only more fun to develop game ideas iteratively. It produces games
that are more original, and more fun.

# Why is it faster to build games with Espresso?

Espresso generates all nesseary files for loading resourceses such as 
sprites and entities from predefined folders. The entites step and draw
methods are automatically called, and can use the espresso API

# Is espresso ready to use?
Espresso is useable, but not very stable. The current release is really early.
I've only spend about a week working on it.

# What needs to be done?
The level editor shall be presented more nice, a documentation for the use of
the API and general accessability. Current tasks that is being worked on it in
the TODO.txt file

Requirements
------------

Coffeescript requires node.js

Install
-------
With homebrew:

$ brew update
$ brew install node

Add /usr/local/lib/node to your NODE_PATH environment variable.
See more at: http://www.blog.bridgeutopiaweb.com/post/how-to-install-coffeescript-on-mac-os-x#sthash.xZZ2Cvg8.dpuf

$ npm install -g coffee-script

# Documentation
Will be written as development goes..

# Level Editor
SPACE:     Show/Hide menu
SHIFT:     Snap to grid
ARROWKEYS: Move camera
0:         Jump to 0,0
LEFT_CLICK Create entity
RIGHT_HOLD Remove entity
