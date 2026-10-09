extends Node3D

const BOLT_SHADER = preload("res://shaders/lightning.gdshader")
const SEGMENTS := 16

@export_range(0.1, 3.0) var duration: float = 0.65
@export_range(0.02, 0.2) var flicker_interval: float = 0.045
@export_range(0.001, 0.05) var bolt_width: float = 0.028
@export_range(0.0, 0.25) var jaggedness: float = 0.065

var _body: Node3D
var _diamond: Node3D
var _age: float = 0.0
var _until_flicker: float = 0.0
var _flash: float = 1.0
var _rng := RandomNumberGenerator.new()
var _mesh := ImmediateMesh.new()
var _material := ShaderMaterial.new()
var _offsets := PackedVector2Array()
var _branches: Array[PackedVector3Array] = []


func set_connectors(player: Node3D, diamond: Node3D) -> void:
	_body = player
	_diamond = diamond


func _ready() -> void:
	_rng.randomize()
	_material.shader = BOLT_SHADER
	var visual := MeshInstance3D.new()
	visual.name = "Lightning"
	visual.mesh = _mesh
	visual.material_override = _material
	visual.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	add_child(visual)
	_process(0.0)


func _process(delta: float) -> void:
	# A collected diamond can disappear, or a level can restart mid-flash.
	if not is_instance_valid(_body) or not is_instance_valid(_diamond):
		queue_free()
		return
	if not _body.is_inside_tree() or not _diamond.is_inside_tree():
		queue_free()
		return
	_age += delta
	if _age >= duration:
		queue_free()
		return
	_until_flicker -= delta
	if _until_flicker <= 0.0:
		_randomize_bolt()
		_until_flicker = flicker_interval
	var fade := 1.0 - smoothstep(duration * 0.65, duration, _age)
	_material.set_shader_parameter("brightness", _flash * fade)
	_rebuild_mesh()


func _randomize_bolt() -> void:
	_offsets.resize(SEGMENTS + 1)
	_offsets[0] = Vector2.ZERO
	_offsets[SEGMENTS] = Vector2.ZERO
	for i in range(1, SEGMENTS):
		var envelope := sin(PI * float(i) / SEGMENTS)
		_offsets[i] = Vector2(_rng.randf_range(-1.0, 1.0), _rng.randf_range(-1.0, 1.0)) * envelope
	_flash = _rng.randf_range(0.7, 1.25)
	_branches.clear()
	for branch_index in range(2):
		var index := _rng.randi_range(3, SEGMENTS - 4)
		var start := Vector3(float(index) / SEGMENTS, _offsets[index].x, _offsets[index].y)
		var reach := Vector3(_rng.randf_range(0.09, 0.18), _rng.randf_range(-2.8, 2.8), _rng.randf_range(-2.8, 2.8))
		var branch := PackedVector3Array([start])
		for step in range(1, 5):
			var point := start + reach * (float(step) / 4.0)
			point.y += _rng.randf_range(-0.35, 0.35)
			point.z += _rng.randf_range(-0.35, 0.35)
			branch.append(point)
		_branches.append(branch)


func _rebuild_mesh() -> void:
	_mesh.clear_surfaces()
	var start := _body.global_position
	var end := _diamond.global_position
	var distance := start.distance_to(end)
	if distance < 0.001:
		return
	var axis := (end - start) / distance
	var reference := Vector3.UP if absf(axis.dot(Vector3.UP)) < 0.95 else Vector3.RIGHT
	var side := axis.cross(reference).normalized()
	var up := axis.cross(side).normalized()
	var amplitude := minf(distance * jaggedness, 0.12)
	var points := PackedVector3Array()
	for i in range(SEGMENTS + 1):
		points.append(start.lerp(end, float(i) / SEGMENTS) + (side * _offsets[i].x + up * _offsets[i].y) * amplitude)
	_mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLES)
	_add_ribbon(points, bolt_width, false)
	for branch in _branches:
		var branch_points := PackedVector3Array()
		for point in branch:
			branch_points.append(start + axis * point.x * distance + (side * point.y + up * point.z) * amplitude)
		_add_ribbon(branch_points, bolt_width * 0.55, true)
	_mesh.surface_end()


func _add_ribbon(points: PackedVector3Array, width: float, taper: bool) -> void:
	# Camera-facing ribbons stay visible from any viewing angle, without CSG rebuilding.
	var camera := get_viewport().get_camera_3d()
	var edges := PackedVector3Array()
	for i in range(points.size()):
		var before := points[maxi(i - 1, 0)]
		var after := points[mini(i + 1, points.size() - 1)]
		var tangent := (after - before).normalized()
		var view := Vector3.FORWARD
		if camera:
			view = camera.global_basis.z if camera.projection == Camera3D.PROJECTION_ORTHOGONAL else (camera.global_position - points[i]).normalized()
		var across := tangent.cross(view)
		if across.length_squared() < 0.0001:
			var fallback := Vector3.UP if absf(tangent.y) < 0.95 else Vector3.RIGHT
			across = tangent.cross(fallback)
		var factor := lerpf(1.0, 0.05, float(i) / (points.size() - 1)) if taper else 1.0
		edges.append(across.normalized() * width * factor * 0.5)
	for i in range(points.size() - 1):
		var a := points[i] - edges[i]
		var b := points[i] + edges[i]
		var c := points[i + 1] - edges[i + 1]
		var d := points[i + 1] + edges[i + 1]
		_vertex(a, Vector2(0.0, 0.0))
		_vertex(b, Vector2(1.0, 0.0))
		_vertex(c, Vector2(0.0, 1.0))
		_vertex(b, Vector2(1.0, 0.0))
		_vertex(d, Vector2(1.0, 1.0))
		_vertex(c, Vector2(0.0, 1.0))


func _vertex(world_position: Vector3, uv: Vector2) -> void:
	_mesh.surface_set_uv(uv)
	_mesh.surface_add_vertex(to_local(world_position))
