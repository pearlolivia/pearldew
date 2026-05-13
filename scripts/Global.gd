extends Node

enum Tools {
	Hoe = 1,
	Watering_Can = 2
}

const TILE_SIZE = 16 #px
const PORTION_LENGTH = 5

var CROP_DICTIONARY = {
	"strawberry": {
		"frames": 6
	},
	"broccoli": {
		"frames": 5
	},
	"cabbage": {
		"frames": 6
	},
	"onion": {
		"frames": 6
	},
	"spring_onion": {
		"frames": 5
	},
	"cauliflower": {
		"frames": 6
	},
}
