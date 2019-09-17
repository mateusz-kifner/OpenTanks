extends TileMap
class_name Destructive_Enviroment_2D

export var MAX_GRAIN:int = 6
export var MIN_GRAIN:int = 0

export var OFFSET:Vector2 = Vector2(0.2,0.65)
export var STRETCH:Vector2 = Vector2(3.0,0.2)

export var SIZE:Vector2 = Vector2(2000,1000)
onready var MAX_GRAIN_POW2:int = pow(2,MAX_GRAIN)
onready var CWIDTH:int = floor(SIZE.x/MAX_GRAIN_POW2+1)
onready var CHEIGHT:int = floor(SIZE.y/MAX_GRAIN_POW2+1)
onready var GWIDTH:int = CWIDTH*MAX_GRAIN_POW2
onready var GHEIGHT:int = CHEIGHT*MAX_GRAIN_POW2

var grid = []

func _ready():
	for x in range(CWIDTH):
		grid.append([])
		for y in range(CHEIGHT):
			grid[x].append(MAX_GRAIN)
			set_cell(x*MAX_GRAIN_POW2,y*MAX_GRAIN_POW2,MAX_GRAIN)
	fast_crave(0.05,-1,"dist_cos",700)

func fast_circle(posx:int,posy:int,radius:float) -> void:
	var normal_posx:int = floor((posx-radius)/MAX_GRAIN_POW2)*MAX_GRAIN_POW2
	var normal_posy:int = floor((posy-radius)/MAX_GRAIN_POW2)*MAX_GRAIN_POW2
	var normal_size:int = (floor((radius+3)/MAX_GRAIN_POW2)+1)*MAX_GRAIN_POW2*2
	for grain in range(MIN_GRAIN,MAX_GRAIN+1):
		var pow_grain = pow(2,grain)
		for x in range((normal_size/pow_grain)):
			for y in range(normal_size/pow_grain):
				if(get_cell(x*pow_grain + normal_posx,y*pow_grain + normal_posy) == grain):
					recur_divide(x*pow_grain + normal_posx,y*pow_grain + normal_posy,grain,"dist_point",[posx,posy],radius)

func fast_crave( a:float, b:float, distance_function:String , treshold:int = 100 ) -> void:
	for grain in range(MIN_GRAIN,MAX_GRAIN+1):
		var pow_grain = pow(2,grain)
		for x in range(GWIDTH/pow_grain):
			for y in range(GHEIGHT/pow_grain):
				if(get_cell(x*pow_grain,y*pow_grain) == grain):
					recur_divide(x*pow_grain,y*pow_grain,grain,distance_function,[a,b],treshold)

func dist_point(posx:int,posy:int,pos2x:int,pos2y:int)-> float:
	return sqrt((posx-pos2x)*(posx-pos2x) + (posy-pos2y)*(posy-pos2y))
	
func dist_square(posx:int, posy:int, pos2x:int, pos2y:int) -> float:
	return max(abs(posx-pos2x),abs(posy-pos2y))
	
func dist_line(posx:int,posy:int,a:float,b:float) -> float:
	return abs(a*posx + b*posy)/sqrt(a*a+b*b)
	
func dist_cos(posx:int,posy:int,a:float,b:float) -> float:
	return abs(a*posx + b*posy + cos(posx*(PI*2/GWIDTH)*STRETCH.x)*GHEIGHT/4*STRETCH.y)/sqrt(a*a+b*b)

func recur_divide(gridx,gridy,grain,dist_function,dist_args,treshold):
	if(grain<MIN_GRAIN):
		set_cell(gridx,gridy,-1)
	else:
		var pow_grain = pow(2,grain)
		if (self.callv(dist_function,[gridx,gridy,dist_args[0],dist_args[1]]) < treshold
		or self.callv(dist_function,[gridx+pow_grain-1,gridy,dist_args[0],dist_args[1]]) < treshold
		or self.callv(dist_function,[gridx,gridy+pow_grain-1,dist_args[0],dist_args[1]]) < treshold
		or self.callv(dist_function,[gridx+pow_grain-1,gridy+pow_grain-1,dist_args[0],dist_args[1]]) < treshold):
			var pow_grain_minus_1 = pow(2,grain-1)
			recur_divide(gridx,gridy,grain-1,dist_function,dist_args,treshold)
			recur_divide(gridx+pow_grain_minus_1,gridy,grain-1,dist_function,dist_args,treshold)
			recur_divide(gridx,gridy+pow_grain_minus_1,grain-1,dist_function,dist_args,treshold)
			recur_divide(gridx+pow_grain_minus_1,gridy+pow_grain_minus_1,grain-1,dist_function,dist_args,treshold)
		else:
			set_cell(gridx,gridy,grain)
	