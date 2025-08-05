@tool
@icon("./placer_icon.png")
class_name ObjectString
extends Node3D


## Item to plce
@export var item: PackedScene:
	set(value):
		item = value
		spawn_objects()
	get:
		return item
## Distance between items, meters
@export var item_distance: float = 10.0:
	set(value):
		item_distance = value
		spawn_objects()
	get:
		return item_distance
## Start position along curve (meters)
@export var from_dist: float = 0.0:
	set(value):
		from_dist = max(0, value)
		spawn_objects()
	get:
		return from_dist
## End position along curve (meters)
@export var to_dist: float = -1.0:
	set(value):
		to_dist = value
		spawn_objects()
	get:
		return to_dist	
@export var left: bool = true:
	set(value):
		left = value
		spawn_objects()
	get:
		return left
@export var right: bool = true:
	set(value):
		right = value
		spawn_objects()
	get:
		return right
@export var distance_from_center: float = 3.0:
	set(value):
		distance_from_center = value
		spawn_objects()
	get:
		return distance_from_center
## Vertical offset from curve
@export var distance_up: float = 0.0:
	set(value):
		distance_up = value
		spawn_objects()
	get:
		return distance_up
## Rotation around vertical axis (degrees)
@export var obj_rotation: float = 0.0:
	set(value):
		obj_rotation = value
		spawn_objects()
	get:
		return obj_rotation
@export var absolute_up: bool = false:
	set(value):
		absolute_up = value
		spawn_objects()
	get:
		return absolute_up
		
@export_tool_button("Refresh", "Reload") var refresh_action = spawn_objects

var spawned: = []
var connected

func spawn_objects():	
	var parent = get_parent()
	if parent == null:
		return
	if not parent is Path3D:
		printerr("Parent should be Path3D!")
		return
	if item == null:
		return
	
	var curve = (parent as Path3D).curve
	var path_length: float = curve.get_baked_length()

	if parent != connected:		
		parent.curve_changed.connect(spawn_objects)
		connected = parent
	
	# Handle to_dist default value (-1 means full length)
	var effective_to_dist = to_dist if to_dist >= 0 else path_length
	effective_to_dist = min(effective_to_dist, path_length)
	
	# Calculate starting offset and count based on from_dist/to_dist
	var usable_length = effective_to_dist - from_dist
	if usable_length <= 0:
		return
		
	var count = floor(usable_length / item_distance)
	var offset = from_dist + item_distance/2.0

	# Clear existing objects
	for prev_item in spawned:
		remove_child(prev_item)
		prev_item.queue_free()
	spawned.clear()

	for i in range(0, count):
		var curve_distance = offset + item_distance * i
		if curve_distance > effective_to_dist:
			continue
			
		var position = curve.sample_baked(curve_distance, true)
		var up = curve.sample_baked_up_vector(curve_distance, true) if not absolute_up else Vector3.UP
		var forward = position.direction_to(curve.sample_baked(curve_distance + 0.1, true))

		# Apply vertical offset
		position += up * distance_up
		
		# Create basis with rotation
		var basis = Basis()
		basis.y = up
		basis.x = forward.cross(up).normalized()
		basis.z = -forward
		
		# Apply object rotation around vertical axis
		#if obj_rotation != 0:
		#	basis = basis.rotated(up, deg_to_rad(obj_rotation))
		
		var transform = Transform3D(basis, position)
		
		if left:
			var inst = item.instantiate()			
			inst.set_global_transform(transform.translated_local(Vector3.LEFT * distance_from_center).rotated_local(Vector3.UP, deg_to_rad(obj_rotation)))
			add_child(inst)
			spawned.append(inst)
			
		if right:
			var inst = item.instantiate()			
			inst.set_global_transform(transform.translated_local(Vector3.RIGHT * distance_from_center).rotated_local(Vector3.UP, PI-deg_to_rad(obj_rotation)))
			add_child(inst)
			spawned.append(inst)	

# Called when the node enters the scene tree for the first time.
func _ready():
	if spawned.is_empty():
		spawn_objects()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
