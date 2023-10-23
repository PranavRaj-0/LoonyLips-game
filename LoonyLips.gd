extends Control

var player_words = []

var current_Story = {}

@onready var PlayerText = $VBoxContainer/HBoxContainer/PlayerText
@onready var DisplayText = $VBoxContainer/DisplayText

func _ready():
	set_current_story()
	DisplayText.text = "Welcome to LOONY LIPS, an interactive text based game. Enjoy! \n"
	PlayerText.grab_focus()
	check_player_words_length()


func set_current_story():
#	var stories = get_from_json("StoryBook.json")
	randomize()
#	current_Story = stories[randi() % stories.size()]
	var stories = $StoryBook.get_child_count()   #No.of stories/ Children of StoryBook node
	var selected_story =randi() % stories
	current_Story.prompts = $StoryBook.get_child(selected_story).prompts
	current_Story.story = $StoryBook.get_child(selected_story).story

func get_from_json(filename):
	var file = FileAccess.open(filename, FileAccess.READ)
	var text = file.get_as_text()
	var data = JSON.parse_string(text)
	file.close()
	return data

func _on_player_text_text_submitted(_new_text):
	add_to_player_words()

func _on_texture_button_pressed():
	if is_story_done():
		get_tree().reload_current_scene()
	else:
		add_to_player_words()

func add_to_player_words():
	player_words.append(PlayerText.text)
	DisplayText.text = ""
	PlayerText.clear()
	check_player_words_length()

func is_story_done():
	return player_words.size() == current_Story.prompts.size()

func tell_story():
	DisplayText.text = current_Story.story % player_words

func end_game():
	PlayerText.queue_free()
	$VBoxContainer/HBoxContainer/Label.text = "Restart?"
	tell_story()

func prompt_player():
	DisplayText.text += "May I have " + current_Story.prompts[player_words.size()] + " please."
	
func check_player_words_length():
	if is_story_done():
		end_game()
	else:
		prompt_player()



