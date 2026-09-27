extends Resource
class_name CardData
  
@export var id: String = ""            # unique key used by StoryRule, e.g. "bj_angry"
@export var display_name: String = ""  # shown in tooltips/UI, e.g. "Angry Beetlejuice"
@export var texture: Texture2D         # one of your PNGs
 
