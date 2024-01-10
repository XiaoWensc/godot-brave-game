extends Enemy

enum State {
	WALK,
	HIDE,
	DEAD,
}

# 待处理的伤害
var pending_damage: Damage

# 攻击力度
const KNOCHBACK_AMOUNT := 250.0
@onready var wall_checker: RayCast2D = $Graphics/WallChecker
@onready var player_checker: RayCast2D = $Graphics/PlayerChecker
@onready var floor_checker: RayCast2D = $Graphics/FloorChecker
@onready var can_walk_timer: Timer = $CanWalkTimer

## 是否看到了玩家
func can_see_player() -> bool:
	if not player_checker.is_colliding():
		return false
	return player_checker.get_collider() is Player

func get_next_state(state: State) -> int:
	if stats.health == 0:
		return StateMachine.KEEP_CURRENT if state == State.DEAD else State.DEAD
	if pending_damage:
		return State.DEAD
	match state:
		State.WALK:
			if can_see_player():
				return State.HIDE
		State.HIDE:
			if not can_see_player() and can_walk_timer.is_stopped():
				return State.WALK
		State.DEAD:
			if not animation_player.is_playing():
				return State.HIDE
				
	return StateMachine.KEEP_CURRENT
	

func transition_state(from: State, to: State) -> void:
	match to:
		State.WALK:
			animation_player.play("walk")
		State.HIDE:
			animation_player.play("hide")
		State.DEAD:
			animation_player.play("dead")
			stats.health -= pending_damage.amount
			
			var dir := pending_damage.source.global_position.direction_to(global_position)
			velocity = dir * KNOCHBACK_AMOUNT
			
			if dir.x > 0:
				direction = Direction.LEFT
			else:
				direction = Direction.RIGHT
			
			pending_damage = null

func tick_physics(state: State, delta: float) -> void:
	match state:
		State.WALK:
			if wall_checker.is_colliding() or not floor_checker.is_colliding():
				direction *= -1
			move(max_speed, delta)
		State.HIDE:
			move(0.0, delta)
			if can_see_player():
				can_walk_timer.start()
		State.DEAD:
			move(0.0, delta)

func _on_hurtbox_hurt(hitbox: Hitbox) -> void:
	pending_damage = Damage.new()
	pending_damage.amount = 1
	pending_damage.source = hitbox.owner
