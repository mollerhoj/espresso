class EntityMenu extends ParentEntityMenu
  
  constructor:->
    super
    space_between_buttons = 2 #TODO overwrite variables?
    for key, value of AppData.entities
      b = new EntityButton
      b.text = key
      b = @add_button(b)
