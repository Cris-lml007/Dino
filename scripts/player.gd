extends CharacterBody2D
class_name Player

@export var speed = 300.0
@export var jumpVelocity = -400.0
@onready var animation = $AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@export var onGravity = true
@export var loopJump = false
var current="Idle"
var finish=false
var movement = false

func _ready():
    pass

func _process(delta):
    var direction = Input.get_axis("ui_left","ui_right")
    if Input.is_action_pressed("ui_select") and (direction == 1 or direction == -1):
        jump()
    elif Input.is_action_pressed("ui_select"):
        jump()
    elif direction == 1:
        right()
    elif direction == -1:
        left()
    else:
        idle()

func _physics_process(delta):
    if onGravity:
        if not is_on_floor():
            current="Jump"
            if not finish or loopJump:
                animation.play("Jump")
            velocity.y += gravity * delta
        else:
            finish=false
    else:
        if Input.is_action_pressed("ui_select"):
            current="Jump"
            if not finish or loopJump:
                animation.play("Jump")
        else:
            finish = false
        velocity.y = move_toward(velocity.y, 0 , -jumpVelocity/2)
    if not movement:
        velocity.x = 0

    move_and_slide()


func idle():
    if onGravity:
        if is_on_floor():
            velocity.x=move_toward(velocity.x,0,speed/8)
            animation.play("Idle")
            current="Idle"
    else:
        animation.play("Idle")
        current="Idle"
    movement = false


func right():
    animation.flip_h=false
    if onGravity:
        if is_on_floor():
            animation.play("Run")
            current="Run"
        else:
            current="Jump"
    else:
        animation.play("Run")
        current="Run"
    velocity.x=1*speed
    movement = true

func left():
    animation.flip_h=true
    if onGravity:
        if is_on_floor():
            animation.play("Run")
            current="Run"
        else:
            current = "Jump"
    else:
        animation.play("Run")
        current = "Run"
    velocity.x=-1*speed
    movement = true

func jump():
    if is_on_floor() or not onGravity:
        velocity.y = jumpVelocity
        current = "Jump"

func _on_animated_sprite_2d_animation_finished():
    if current == "Jump":
        finish=true
