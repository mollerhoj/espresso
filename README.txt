ESPRESSO by Jens Dahl Møllerhøj

-- What is espresso?
A lightning fast game development engine. It is used to build tiny html5
canvas games in minutes.

-- What is the idea?
Useing coffeescript with a API that resamples the way Game Maker by Mark
Overmars works.

-- Why is it faster to build games with Espresso?
The Cakefile generates a AppData classes that the application uses to load
sprites and entities from predefined folders. The entites step and draw
methods are automatically called, and can use the espresso API

-- Is espresso ready to use?
Espresso is useable, but not very stable. The current release is really early.
I've only spend about a week working on it.

-- What needs to be done?
The level editor shall be presented more nice, a documentation for the use of
the API and general accessability. Current tasks that is being worked on it in
the TODO.txt file

Documentation
Will be written as development goes..

Level Editor
Controls:
SPACE:     Show/Hide menu
SHIFT:     Snap to grid
ARROWKEYS: Move camera
0:         Jump to 0,0
LEFT_CLICK Create entity
RIGHT_HOLD Remove entity
