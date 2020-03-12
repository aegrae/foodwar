pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
fps=2
fruits = {}
fall_speed=fps
num_fruits = 12
f_types=3

function _init()
 for i=1,num_fruits do
  fruits[i] = {rnd(f_types),rnd(128),0-rnd(64)} 
 end
end

function _update()
  cls()
	 for i,v in pairs(fruits) do
	   p_y = v[2] 
   	if p_y>=127 then 
    	 v[2]=0 
    	 v[1]=rnd(128)
    	 v[0]=rnd(f_types)
   	else 
    	 v[2]=p_y+fall_speed 
   	end
  end
end

function _draw()
  for i,v in pairs(fruits) do 
  	spr(v[0],v[1],v[2])
  end
end
__gfx__
00000b0000ffff000033330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000bb00ffffff00333333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000099bbfff00fff3333333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00099900ff0000ff3333333300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00999900ff0000ff0303303000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09999000fff00fff0003300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
099000000ffffff00003300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9900000000ffff000003300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
baaaaaaaaaaaaaaaaaaaaaa900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0000000000000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0000000000000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0000000000000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0000000000000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0000000000000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0000000000000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0000000000000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0000000000000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0000000000000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0000000000000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0000000000000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0000000000000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0000000000000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0000000000000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0000000000000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0000000000000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0000000000000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0000000000000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0000000000000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0000000000000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0000000000000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
c0000000000000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
b3333333333333333333333e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
0010111111111111120000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0020000000000000220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0020000000000000220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0020000000000000220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0020000000000000220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0020000000000000220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0020000000000000220000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0030313131313131320000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
