#extends TileMap
#
#export var MAX_GRAIN:int = 6
#export var MIN_GRAIN:int = 0
#export var OFFSET:Vector2 = Vector2(0.2,0.65)
#export var STRETCH:Vector2 = Vector2(3.0,0.3)
#
#export var SIZE:Vector2 = Vector2(2000,800)
#
#
#onready var GHEIGHT:int = floor(SIZE.y/128+1)*128
#onready var GWIDTH:int = floor(SIZE.x/128+1)*128
#
#onready var grid = []
#
#func _ready():
#	pass
#
#func fill_tiles():
#	grid = []
#	for x in range(GWIDTH):
#		grid.append([])
#		for y in range(GHEIGHT):
#			if(y>400):
#				grid[x].append(MAX_GRAIN)
#			else:
#				grid[x].append(-1)
#
#func divide_tiles(treshold):
#	for grain in range(MIN_GRAIN,MAX_GRAIN+1):
#		var pow_grain = pow(2,grain)
#		for x in range(GWIDTH/pow_grain):
#			for y in range(GHEIGHT/pow_grain):
#				var offset_x = x*pow_grain
#				if (dist_point(offset_x, offset_y(offset_x,pow_grain) ,x*pow_grain,y*pow_grain) < treshold or
#					dist_point(offset_x+pow_grain-1, offset_y(offset_x+pow_grain-1,pow_grain) ,(x*pow_grain)+pow_grain-1,y*pow_grain) < treshold or
#					dist_point(offset_x, offset_y(offset_x,pow_grain)+pow_grain-1,x*pow_grain,y*pow_grain+pow_grain-1) < treshold or
#					dist_point(offset_x+pow_grain-1, offset_y(offset_x+pow_grain-1,pow_grain)+pow_grain-1,x*pow_grain+pow_grain-1,y*pow_grain+pow_grain-1) < treshold):
#					for lx in range(pow_grain):
#						for ly in range(pow_grain):
#							grid[x*pow_grain+lx][y*pow_grain+ly] -=1
#
#func draw_tiles():
#	for grain in range(MIN_GRAIN,MAX_GRAIN+1):
#		var pow_grain = pow(2,grain)
#		for x in range(GWIDTH/pow_grain):
#			for y in range(GHEIGHT/pow_grain):
#				if grid[x*pow_grain][y*pow_grain] == grain :
#					set_cell(x*pow_grain,y*pow_grain,grain)
#
#func fast_circle(posx:int,posy:int,radius:float) -> void:
#	var pow_grain_max:int = pow(2,MAX_GRAIN)
#	var normal_posx:int = floor((posx-radius)/pow_grain_max)*pow_grain_max
#	var normal_posy:int = floor((posy-radius)/pow_grain_max)*pow_grain_max
#	var normal_size:int = (floor((radius+3)/pow_grain_max)+1)*pow_grain_max*2
#	for grain in range(MIN_GRAIN,MAX_GRAIN+1):
#		var pow_grain = pow(2,grain)
#		for x in range((normal_size/pow_grain)):
#			for y in range(normal_size/pow_grain):
#				if(get_cell(x*pow_grain + normal_posx,y*pow_grain + normal_posy) == grain):
#					recur_divide(x*pow_grain + normal_posx,y*pow_grain + normal_posy,grain,"dist_point",[posx,posy],radius)
#
#func dist_point(posx:int,posy:int,pos2x:int,pos2y:int)-> float:
#	return sqrt((posx-pos2x)*(posx-pos2x) + (posy-pos2y)*(posy-pos2y))
#
#func offset_y( offset_x , pow_grain):
#	return floor(cos(offset_x/(GWIDTH)*PI*2*STRETCH.x+PI*2*OFFSET.x)*STRETCH.y*100.0)
#
#func recur_divide(gridx,gridy,grain,dist_function,dist_args,treshold):
#	if(grain<0):
#		set_cell(gridx,gridy,-1)
#	else:
#		var pow_grain = pow(2,grain)
#		if (self.callv(dist_function,[gridx,gridy,dist_args[0],dist_args[1]]) < treshold
#		or self.callv(dist_function,[gridx+pow_grain-1,gridy,dist_args[0],dist_args[1]]) < treshold
#		or self.callv(dist_function,[gridx,gridy+pow_grain-1,dist_args[0],dist_args[1]]) < treshold
#		or self.callv(dist_function,[gridx+pow_grain-1,gridy+pow_grain-1,dist_args[0],dist_args[1]]) < treshold):
#			var pow_grain_minus_1 = pow(2,grain-1)
#			recur_divide(gridx,gridy,grain-1,dist_function,dist_args,treshold)
#			recur_divide(gridx+pow_grain_minus_1,gridy,grain-1,dist_function,dist_args,treshold)
#			recur_divide(gridx,gridy+pow_grain_minus_1,grain-1,dist_function,dist_args,treshold)
#			recur_divide(gridx+pow_grain_minus_1,gridy+pow_grain_minus_1,grain-1,dist_function,dist_args,treshold)
#		else:
#			set_cell(gridx,gridy,grain)
