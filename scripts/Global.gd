extends Node

enum Tools {
	Hoe = 1,
	Watering_Can = 2
}

const TILE_SIZE = 16 #px
const PORTION_LENGTH = 5

var CROP_DICTIONARY = {
	"strawberry": {
		"frames": 6,
		"seed_price": 10,
		"value": 50
	},
	"broccoli": {
		"frames": 5,
		"seed_price": 4,
		"value": 24
	},
	"cabbage": {
		"frames": 6,
		"seed_price": 4,
		"value": 20
	},
	"onion": {
		"frames": 6,
		"seed_price": 3,
		"value": 18
	},
	"spring_onion": {
		"frames": 5,
		"seed_price": 2,
		"value": 10
	},
	"cauliflower": {
		"frames": 6,
		"seed_price": 6,
		"value": 32
	},
}
