class Settings
  # In development mode we have a level editor.
  @mode: 'Development'
  # The size of the canvas
  @width: 640
  @height: 480
  # The global zoom level
  @scale: 1
  # The default background image
  @background: 'Background'
  # The grid for the level editor. TODO: This should be moved to EditorData
  @grid:
    offset_x: 0
    offset_y: 0
    cell_width: 32
    cell_height: 32