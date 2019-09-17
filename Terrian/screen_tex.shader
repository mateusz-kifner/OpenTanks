shader_type canvas_item;

uniform sampler2D image;
uniform bool enable; 

void fragment(){
	if(enable){
		COLOR = texture(image,1.0-SCREEN_UV);
	}else{
		COLOR = texture(TEXTURE,UV);
	}
}