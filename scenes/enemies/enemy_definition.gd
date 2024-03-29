extends Resource
class_name Enemy

# Metadata
@export_group("MetaData")
@export var name : String = "Good Person"
@export var icon : Image
#@export var scene : PackedScene # Creates a ruccursive error

# Navigation Parameters
@export_group("Navigation")
@export var speed : float = 300
@export var acceleration : float = 2000
@export var navigation_success_distance : float = 15 # you might need to change this:
	#for high speed low acceleration creatures
@export var max_fall_distance : float = 200
@export var can_fly : bool = false

# Player Detection Parameters
@export_group("Player Interaction")
@export var detection_range : float = 200
@export var max_detection_angle : float = PI/4

# Stats
@export_group("Stats")
@export var health_profile : Health_Profile

# Other
@export_group("Other")
@export var edible_data : EdibleData
