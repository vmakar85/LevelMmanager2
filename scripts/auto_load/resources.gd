extends Node


var enemy_scenes: = {
	"0" :preload("res://game_objects/enemies/enemy_type_1.tscn"),
	"1" :preload("res://game_objects/enemies/enemy_type_2.tscn"),
	"2" :preload("res://game_objects/enemies/enemy_type_3.tscn"),
	"3" :preload("res://game_objects/enemies/enemy_type_4.tscn"),
	"4" :preload("res://game_objects/enemies/enemy_type_5.tscn"),
	"5" :preload("res://game_objects/enemies/enemy_type_6.tscn"),
	"6" :preload("res://game_objects/enemies/enemy_type_7.tscn"),
	"7" :preload("res://game_objects/enemies/enemy_type_8.tscn"),
	"8" :preload("res://game_objects/enemies/enemy_type_9.tscn")
	}

var enemy_ui_pic: = {
	"0" : {"pic" : "res://ui_elements/enemies/enemy_sprites/spaceShips_001_d.png", "name" : "sharp_shot_ship"},
	"1" : {"pic" :"res://ui_elements/enemies/enemy_sprites/spaceShips_002_d.png", "name" : "one_shot_ship"},
	"2" : {"pic" :"res://ui_elements/enemies/enemy_sprites/spaceShips_003_d.png", "name" : "diving_ship"},
	"3" : {"pic" :"res://ui_elements/enemies/enemy_sprites/spaceShips_004_d.png", "name" : "double_shot_ship"},
	"4" : {"pic" :"res://ui_elements/enemies/enemy_sprites/spaceShips_005_d.png", "name" : "wave_shot_ship"},
	"5" : {"pic" :"res://ui_elements/enemies/enemy_sprites/spaceShips_006_d.png", "name" : "fast_diving_ship"},
	"6" : {"pic" :"res://ui_elements/enemies/enemy_sprites/spaceShips_007_d.png", "name" : "knight_ship"},
	"7" : {"pic" :"res://ui_elements/enemies/enemy_sprites/spaceShips_008_d.png", "name" : "naughty_double_barreled_ship"},
	"8" : {"pic" :"res://ui_elements/enemies/enemy_sprites/spaceShips_009_d.png", "name" : "paladin_ship"},
	"*" : {"pic" :"res://ui_elements/crosshair042.png", "name" : "Empty"}
	}
	
var enemy_description:Dictionary = {
	"0" : {"pic" : "res://ui_elements/enemies/enemy_sprites/spaceShips_001_d.png",
	 "name" : "sharp_shot_ship", "sname" : "SharpShot", "base_hp" :  20 , "base_point" : 10},
	"1" : {"pic" :"res://ui_elements/enemies/enemy_sprites/spaceShips_002_d.png",
	 "name" : "one_shot_ship", "sname" : "OneShot", "base_hp" :  10 , "base_point" : 10 },
	"2" : {"pic" :"res://ui_elements/enemies/enemy_sprites/spaceShips_003_d.png",
	 "name" : "diving_ship", "sname" : "Diving", "base_hp" :  10 , "base_point" : 15 },
	"3" : {"pic" :"res://ui_elements/enemies/enemy_sprites/spaceShips_004_d.png",
	 "name" : "double_shot_ship", "sname" : "DoubleShot", "base_hp" :  10 , "base_point" : 10 },
	"4" : {"pic" :"res://ui_elements/enemies/enemy_sprites/spaceShips_005_d.png",
	 "name" : "wave_shot_ship", "sname" : "WaveShot", "base_hp" :  10 , "base_point" : 10 },
	"5" : {"pic" :"res://ui_elements/enemies/enemy_sprites/spaceShips_006_d.png",
	 "name" : "fast_diving_ship","sname" : "FastDiving", "base_hp" :  10 , "base_point" : 10 },
	"6" : {"pic" :"res://ui_elements/enemies/enemy_sprites/spaceShips_007_d.png",
	 "name" : "knight_ship", "sname" : "Knight", "base_hp" :  200 , "base_point" : 50 },
	"7" : {"pic" :"res://ui_elements/enemies/enemy_sprites/spaceShips_008_d.png",
	 "name" : "naughty_double_barreled_ship", "sname" : "Naughty", "base_hp" :  10 , "base_point" : 10 },
	"8" : {"pic" :"res://ui_elements/enemies/enemy_sprites/spaceShips_009_d.png",
	 "name" : "paladin_ship", "sname" : "Paladin", "base_hp" :  150 , "base_point" : 25 },
	}
