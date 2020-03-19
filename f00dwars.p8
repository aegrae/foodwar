pico-8 cartridge // http://www.pico-8.com
version 18
__lua__
-- f00dwars
-- by davis, ashlae, ifenna

--constants
g = -0.3
move_speed = 2
x_min = 1
x_max = 127 - 8
y_min = 1
y_max = 127 - 8
jump_vel = 5
max_health = 5
invuln_frames = 60
heal_frames = 300
health_gui_x = 2
health_gui_y = 2
health_gui_size = 2
num_start_fruits = 12
fruit_types = 4
max_fruit_speed = 2
fruit_spawn_frames = 90

left = 0
right = 1
up = 2
down = 3

--globals
player = {}
fruits = {}

g_dir = up

frames_alive = 0
game_over = false


function _init()
 music(0)
 restart()
end

function _update()
 if game_over then
  wait_for_key(5)
 else
  movement_input()
  apply_gravity()
  fruits_fall()
  check_collisions()
  remove_eaten_fruits()
  update_timers()
 end
end

function _draw()
 cls()
 if game_over then
  score = flr(frames_alive / 30)
  print("you survived "..score.." seconds")
  print("press x to restart")
 else
  draw_border()
  draw_health()
  draw_center_arrow()
  draw_fruits()
  draw_player()
 end
end

function wait_for_key(key)
 if btn(key) then
  restart()
 end
end

function restart()
 initialize_globals()
 initialize_player()
 initialize_fruits()
end

function initialize_globals()
 frames_alive = 0
 fruits = {}
 g_dir = 3
 game_over = false
end

function initialize_player()
 player.x = x_max / 2
 player.y = y_max
 player.x_vel = 0
 player.y_vel = 0
 player.health = max_health
 player.jumping = true
 player.invuln_timer = 0
 player.heal_timer = 0
end

function initialize_fruits()
 for i=1,num_start_fruits do
  spawn_fruit()
 end
end

function spawn_fruit()
 fruit = {}
 fruit.eaten = false
 fruit.type = flr(rnd(fruit_types))
 fruit.fall_speed = rnd(max_fruit_speed)
 fruit.fall_angle = rnd()

 if g_dir == left then
  entrances = {right, up, down}
 end
 if g_dir == right then
  entrances = {left, up, down}
 end
 if g_dir == up then
  entrances = {left, right, down}
 end
 if g_dir == down then
  entrances = {left, right, up}
 end
 entrance = entrances[flr(rnd(#entrances)) + 1]

 if entrance == left then
  fruit.x = 0
  fruit.y = rnd(y_max)
  fruit.fall_angle = rnd(0.5) - 0.25
 end
 if entrance == right then
  fruit.x = x_max
  fruit.y = rnd(y_max)
  fruit.fall_angle = rnd(0.5) + 0.25
 end
 if entrance == up then
  fruit.x = rnd(x_max)
  fruit.y = 0
  fruit.fall_angle = rnd(0.5)
 end
 if entrance == down then
  fruit.x = rnd(x_max)
  fruit.y = y_max
  fruit.fall_angle = rnd(0.5) + 0.5
 end

 fruits[#fruits + 1] = fruit
end

function heal()
 player.health = player.health + 1
 player.heal_timer = 0
end

function update_timers()
 frames_alive = frames_alive + 1
 if frames_alive % fruit_spawn_frames == 0 then
  spawn_fruit()
 end
 if player.invuln_timer > 0 then
  player.invuln_timer = player.invuln_timer - 1
 end
 if player.health < max_health then
  player.heal_timer = player.heal_timer + 1
  if player.heal_timer == heal_frames then
   heal()
  end
 end
end

function draw_border()
 line(0, 0, 0, 127, 9)
 line(0, 127, 127, 127, 8)
 line(127, 127, 127, 0, 15)
 line(127, 0, 0, 0, 3)
end

function draw_health()
 health_x = health_gui_x
 for i=1,player.health do
  rectfill(health_x, health_gui_y,
           health_x + health_gui_size - 1,
           health_gui_y + health_gui_size - 1, 8)
  health_x = health_x + health_gui_size + 1
 end
end

function draw_center_arrow()
 if g_dir == left then
  spr(32, 64, 64)
 end
 if g_dir == right then
  spr(34, 64, 64)
 end
 if g_dir == up then
  spr(17, 64, 64)
 end
 if g_dir == down then
  spr(49, 64, 64)
 end
end

function draw_fruits()
 for i,v in pairs(fruits) do
  if not v.eaten then
   spr(v.type, v.x, v.y)
  end
 end
end

function draw_player()
 player_sprite = 51 + flr(player.heal_timer / heal_frames * 9)
 if player.invuln_timer > 0 then
  if flr(player.invuln_timer / 2) % 2 == 0 then
   spr(player_sprite, player.x, player.y)
  end
 else
  spr(player_sprite, player.x, player.y)
 end
end

function movement_input()
 g_up_down = (g_dir == up) or (g_dir == down)
 if btn(left) and g_up_down then
  player.x_vel = 0
  player.x = player.x - move_speed
 end
 if btn(right) and g_up_down then
  player.x_vel = 0
  player.x = player.x + move_speed
 end
 if btn(up) and not g_up_down then
  player.y_vel = 0
  player.y = player.y - move_speed
 end
 if btn(down) and not g_up_down then
  player.y_vel = 0
  player.y = player.y + move_speed
 end
 if btnp(4) and not player.jumping then
  jump(jump_vel)
 end
end

function jump(vel)
 player.jumping = true
 if g_dir == left then
  player.x_vel = vel
 end
 if g_dir == right then
  player.x_vel = -vel
 end
 if g_dir == up then
  player.y_vel = vel
 end
 if g_dir == down then
  player.y_vel = -vel
 end 
end

function apply_gravity()
 if g_dir == left then
  player.x_vel = player.x_vel + g
 end
 if g_dir == right then
  player.x_vel = player.x_vel - g
 end
 if g_dir == up then
  player.y_vel = player.y_vel + g
 end
 if g_dir == down then
  player.y_vel = player.y_vel - g
 end
 
 player.x = player.x + player.x_vel
 player.y = player.y + player.y_vel
 
 if player.x < x_min then
  player.x = x_min
  player.x_vel = 0
  if g_dir == left then
   player.jumping = false
  end
 end
 if player.x > x_max then
  player.x = x_max
  player.x_vel = 0
  if g_dir == right then
   player.jumping = false
  end
 end
 if player.y < y_min then
  player.y = y_min
  player.y_vel = 0
  if g_dir == up then
   player.jumping = false
  end
 end
 if player.y > y_max then
  player.y = y_max
  player.y_vel = 0
  if g_dir == down then
   player.jumping = false
  end
 end
end

function fruits_fall()
 for i,v in pairs(fruits) do
  oob = v.y > y_max or v.y < 0 or v.x > x_max or v.x < 0
  if oob then
   v.eaten = true
   spawn_fruit()
  else
   v.x = v.x + v.fall_speed * cos(v.fall_angle)
   -- y is inverted since it counts from the top
   v.y = v.y - v.fall_speed * sin(v.fall_angle)
  end
 end
end

function hurt_player()
 if player.invuln_timer == 0 then
  player.health = player.health - 1
  if player.health == 0 then
   die()
  end
  player.invuln_timer = invuln_frames
 end
end

function die()
 game_over = true
end

function check_collisions()
 for i,v in pairs(fruits) do
  if player.invuln_timer == 0 then
   if not v.eaten and collide_with_player(v.x, v.y) then
    eat_fruit(v)
   end
  end
 end
end

function eat_fruit(fruit)
 hurt_player()
 fruit.eaten = true
 if fruit.type <= down then
  g_dir = fruit.type
 end
end

function remove_eaten_fruits()
 new_fruits = {}
 for i,v in pairs(fruits) do
  if not v.eaten then
   new_fruits[#new_fruits + 1] = v
  end
 end
 fruits = new_fruits
end

function intersect(min1, max1, min2, max2)
  return max(min1,max1) > min(min2,max2) and
         min(min1,max1) < max(min2,max2)
end

function collide_with_player(x, y)
 x_intersect = intersect(player.x, player.x+8, x, x+8)
 y_intersect = intersect(player.y, player.y+8, y, y+8)
 return x_intersect and y_intersect
end

__gfx__
00000b0000ffff000033330000bbbb00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000bb00ffffff00333333008888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000099bbfff00fff3333333388888888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00099900ff0000ff3333333388888888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00999900ff0000ff0303303088888888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09999000fff00fff0003300088888888000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
099000000ffffff00003300008888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9900000000ffff000003300000888800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000005550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000055555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000cccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000cccccccc0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00050000ccaccacc0000500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00550000cccccccc0000550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
05555555ccaccacc5555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00550000ccaaaacc0000550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00050000cccccccc0000500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000cccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000050000000000000cccccc00cccccc008ccccc0088cccc00888ccc008888cc0088888c0088888800888888000000000000000000000000000000000
000000000005000000000000cccccccc8ccccccc88cccccc888ccccc8888cccc88888ccc888888cc8888888c8888888800000000000000000000000000000000
000000000005000000000000ccaccacc8caccacc88accacc88accacc88a8cacc88a88acc88a88acc88a88a8c88a88a8800000000000000000000000000000000
000000000005000000000000cccccccc8ccccccc88cccccc888ccccc8888cccc88888ccc888888cc8888888c8888888800000000000000000000000000000000
000000000555550000000000ccaccacc8caccacc88accacc88accacc88a8cacc88a88acc88a88acc88a88a8c88a88a8800000000000000000000000000000000
000000000055500000000000ccaaaacc8caaaacc88aaaacc88aaaacc88aaaacc88aaaacc88aaaacc88aaaa8c88aaaa8800000000000000000000000000000000
000000000005000000000000cccccccc8ccccccc88cccccc888ccccc8888cccc88888ccc888888cc8888888c8888888800000000000000000000000000000000
0000000000000000000000000cccccc00cccccc008ccccc0088cccc00888ccc008888cc0088888c0088888800888888000000000000000000000000000000000
__label__
333333333333333333333333333333333333bbbb333333333333333333333333333333333333333333333333333333333333333333ffff333333333333333333
90000000000000000ffff000000000000008888880000000000000000000000000000000000000000000000000000000000000000ffffff0000000000000000f
908808808808ffffffffff00000000000088888888b0000003333000000000000000000000000000000000000000000000000000fff00fff000000000000000f
90880880880fffffff00fff0000000000088888888bb000033333300000000000000000000000000000000000000000000000000ff0000bbbb0000000000000f
9000033330fff00fff000ff00000000000888888889bb00bbbb33330000000000000000000000000000000000000000000000000ff000888888000000000000f
9000333333ff000fff000ff0000000000088888888900088888833300000000000000333300000000000000000000000b0000000fff08888888800003333000f
9003333333ff000fff00fff0000000000008888333300888888883330000000000003333330000000000000000000000bb0000000fff8888888800033333300f
9003333333fff00fffffff000000000000008833333308888888833300000000000333333330000000000000000000099bb0000000ff8888888800333333330f
90003033030ffffffffff00000000000000003333333388888888f3000000000000333333330000000000000000000999000000000008888888800333333330f
900000330000ffff0000000000000000000003333333388888888ff0000000000b0030330300000000000000000009999000000000000888888000030330300f
90000033000000000000000000000000000033333333008888883ff0000000000bb000330000000000000000000099990000000000000988880000000330000f
900000330000000000000000000000000000333333330008888ffff00000000099bb00330000000000000000b00099000000000000009990000000000330000f
9000000000000000000bbbb000000000000003033330000ffffffff000000009990000330000000000000000bb09900000000000000bbbbbbb0000000330000f
900000000000000000888888000000000000000333000008ffffffff000000999900000000000000000000099bb000000000000000888888888000000000000f
900000033330000008888888800000333300000330000008fffff8ff00000999900000000000000000000099900000003333000008888888888800000000000f
900000333333000008888888800003333330000330000008ff8888ff0000099000000000000000000000099990000003333330000888888888880000bbbb000f
900003333333300008888888800033333333000000000008fff88fff00009900000000000000000000009999000000333333330008888888888800088888800f
9000033333333000088888888000333333330000000000008ffffff000000000000000000000000000009900000000333333330008888888888800888888880f
90000030330300000088888800000303303000000000000008ffff0000000000000000000000000000099000000000030330300000888888888000888888880f
9000000033000000000888800000000330000000000000000000000000000000000000000000000000000000000000000330000000088888880000888888880f
9000000033000000000000000000000330000000000000000000000000000000000000000000000000000000000000000330000000000000000000888888880f
9000000033000000000000000000000330000000000000000000000000000000000000000000000000000000000000000330000000000000000000088888800f
9000000000000000000000000000000bbbb0000000000000000000000000000000000000000000000000000000000ffff000000000000000000000008888000f
900ffff0000000000003333000000088888800000000000000000000000000000000000ffff0000000ffff000000ffffff00000000000000000000000000000f
90ffffffbbbb0000003333330000088888888000000000000000000000000000000000ffffff00000ffffff0000fff00fff000000000000000000000ffff000f
9fff00fff8888000033333333000088888888000000ffff0000000000000000000000fff00fff000fff00fff000ff0000ff00000000000000000000ffffff00f
9ff0008ff88888f003333333300008888888800000ffffff000000000000000000000ff0000ff000ff0000ff000ff0033ff00000000000000000b0fff00fff0f
9ff0008ff88888ff0030330300000888888880000fff00fff00000000000000000000ff0000ff000ff0000ff000fff33fff30000000000000000bbff0000ff0f
9fff00fff88888fff000330000000088888800000ff0000ff00000000000000000000fff00fff000fff00fff0bbbffffff3330000000000000099bbf0000ff0f
90ffffff8888880ff000330000000008888000000ff000033330000000000000000000ffffff00000ffffff088888ffff333300000000000009990fff00fff0f
900ffff88888b00ff00933b000000000000000000fff003333330000000000000000000ffff0000000ffff088888888033030333300000333999900ffffff00f
900000008888bbfff0999000000000000000000000fff333333330000000000000000000000000000000000888888880330033333300033399990000ffff000f
9000000000f99bbf099990000000000000000000000ff3333333300000000000000000000000000000000008888888803303333333303333993300000000000f
9000000000999ff0999900000000000000000000000000303303000000000000000000000000000000000008888888803303333333303339933300000000000f
9000000009999000990000000000000000000000000000003300000000000000000000000000000000000000888888000000303303000303303000000000000f
9000000099990009900000000000000000000000000000003300000000000000000000000000000000000000088880000000003300000003300000000000000f
9000000099333300000000000000000000000000000000003300000000000000000000000000000000000000000000000000003300000003300000000000000f
9000000993333330000000000000000000000000000000000000000000000000000000000000000000000000000000000000003300000003300000000000000f
9000000033333333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000f
90000000333333330000000000000000000000000000000000000ffff0000000000000000000000000000000000000000000000000000000000000000000000f
9000ffff03033030000000000000000000000000000000000000ffffff000000000000000000000000000000000000000000000000000000000000000000000f
900ffffff033330000000000000000000000000000000000000fff00fff0000000000000000000000000000000000000000000000000000000000000ffff000f
90fff00ff333333033330000000000000000000000000000000ff0000ff000000000000000000000000000000000000000000000000000000000000ffffff00f
90ff00003333333333333000000000000000000000000000000ff0000ff00000000000000000000000000000000000000000000000000000000000fff00fff0f
90ff00003333333333333300000000000000000000000000000fff00fff00000000000000000000000000000000000000000000000000000000000ff0000ff0f
90fff00ff303303333333300000000000000000b000000000000ffffff000000000000000000000000000000000000000000000000000000000000ff0000ff0f
900ffffffff3300303303000000000000000000bb000000000000ffff0000000000000000000000000000000000000000000000000000000000000fff00fff0f
9000fffffff33f00033000000000000000000099bb00000000000000000000000000000000000000000000000000000000000000000000000000000ffffff00f
9000000fff033ff00330000000000000000009990000000000000000000000000000ffff00000000000000000000000000000000000ffff000000000ffff000f
9000000ff0000ff0033000000000000000009999b00000000000000000000000000ffffff000000000000000000000000000000000fffbff000000000000000f
9000000ff0000ff000000000000b000000099990bb00000000000000000bbbb000fff00fff00000000000000000000000000000b0fff0bbff00000000000000f
9000000fff00fff000000000000bb000000990099bb00000000000000088888800ff0000ff00000000000000000000000000000bbff099bbf00000000000000f
90000000ffffff00000000000099bb000099009990000000000000000888888880ff0000ff000000000000000000000000000099bbf9990ff00000000000000f
900000000ffff00000000000099900000000099990000000000000000888888880fff00fff00000000000000ffff0000000009990f9999fff00000000000000f
9000000000000000000000009999000000009999000000000000000008888888800ffffff00000000000000ffffff0000000999909999fff000000000000000f
90000000000000000000000999900000000099000000000000000000088888888000ffff00000000000000fff00fff0000099990099ffff0000000000000000f
90000000000000000000000990000000000990000000000000000000008888880000000000000000000000ff0000ff00000990009900000000000000bbbb000f
900000000000000000000099000000000000000000000000b0000000000888800000000000000000000000ff0000ff000099000000000000000000088888800f
900000000000000000000000b00000000000000000000000bb000000000000000000000000000000000000fff00fff000000000000000000000000888888880f
9000000b0000000000000000bb00000000000000000000099bb0ffff0000000000000000003333000000000ffffff0000000ffff00000000000000888888880f
9000000bb0000000000000099bb000000000000000000099900ffffff00000000000000bbbb3333000000000ffff0000000ffffff0000000000000888888880f
90000099bb0000000000009990000000000000000000099990fff00fff0000000000008888883333000000000000000000fffbbfff000000000000888888880f
90000999000000000000099990000000000000000000999900ff0000ff0000000000088888888333000000000000000000ff9000ff0000000000000b8888800f
90009999000000000000999988000000000000000000990000ff0000ff0000000000088888888030000000000000000009ff9000ff0000000000000bb888000f
90099990000000000008998888800000000000000009900000fff00fff0000000000088888888000000000000000000099fff00fff00000000000099bb00000f
90099000bbbb000000099888888000000000000000000000000ffffff000000000000888888880000000000000000000990ffffff0000000000009990000000f
9099000888888000000888888880000000000000000000000000ffff00000000000050888888300000000000000000099000ffff00000000000099990000000f
900000888888880000088888888000000ffff000000000000000000000000000000055088880000000000000000000000000000000000000000999900000000f
90000088888888000000888888000000ffffff00000000000000000000b00000555555500000000000000000000000000000000000000000000bbbb00000000f
90000088888bbbb0000008888000000fff00fff0000000000000000000bb0000000055000000000000000000000000000000000000000000008888880000000f
9000008888888888000000000000000ff0000ff00000000000000000099bb000000050000000000000000000000000000000000000000000088888888000000f
9000000888888888800000000000000ff0000ff0000000000000000099900000000000000000000000000000000000000000000000000000088888888000000f
9000000088888888800000000000000fff00fff0000000000000000999900000000000000000000000000000000000000000000000000000088888888000000f
90000000088888888000000000000000ffffff00000000000000009999000000000000000000000000000000000000000000000000000000088888888000000f
900000000888888880000000000000000ffff000000000000000009900000000000000000000000000000000000000000000000000000000008888880000000f
90000000008888880000000000000000000000000000000000000990000000000000000000000000000000000ffff0000000000000000000000888800000000f
9000000000088880000000000000000000000000000000000000000000000000000000000000000000000000ffffff000000000000000000000000000000000f
900000000000000000000000000000000000000000000000000000000000000000000000000000000000000fff00fff00000000000000000000000000000000f
900000000000000000000000000000000000000003333000000000000000000000000000000000000000000ff0000ff00000000000000000000000000000000f
900000000000000000000000000000000000000033333300000000000000000000000000000000000000000ff0000ff00000000000000000000000000000000f
90000000000bbbb000000000000000000000000333333330000000000000000000000000000000000000000fff00fff00000000000000000000000000000000f
9000000000888888000000000000000000000003333333300000000000000000000000000000000000000000ffffff000000000000000000000000000000000f
90000000088888888000000000000000000000003033030000000000000000000000000000000000000000000ffff0000000000000000000000000000000000f
9000000008888888800000000000000000000000003300000000000000000000000000000000000033330000000000000000000000000000000000000000000f
9000000008888888830000000000000000000000003300000000000000000000000000000000000333333000000000000000000000000000000000000000000f
9000000008888888833000000000000000000000003300000000000000000000000000000000003333333300000000000000000000000000000000000000000f
9000000000888888333000000000000000000000000000000000000000000000000000000000003333333300000000000000000000000000000000000000000f
9000000000088883030000000000000000000000000000000000000000000000000000000000099303303000000000000000000000000000000000000000000f
900000b000000033000000000000000000000000000000000000000000000000000000000000999903300000000000000000000000000000000000000000000f
900000bb00000033000000000000000000000000000000000000000000000000000000000009999003300000000333300000000000000000000000000000000f
900009ffff000033000000000000000000000000000000000000000000000000000000000009900003300000003333330000000000000000000000000000000f
90009ffffff00000000000000000000000000000000000000000000000000000000000000099000000000000033333333000000000000000000000000000000f
9009fff00fff000000000000000000000000000000000000000000000000000000000000000000000000000003333333300000000000000b000000000000000f
9099ff0000ff0000000000000000000000000b000000000000000000ffff000000000000000000000000000000303303000000000000000bb00000000000000f
9099ffb000ff0000000000000000000000000bb0000000000000000ffffff0000000000000000000000000000000330000000000b0000099bb0000000000000f
9990fffb0fff00000000000000000000000099bb00000000000000fff00fff000000000000000000000000000000330000000000bb000999000000000000000f
90099ffffff000000000000000000000000999bb00000000000000ff0000ff0000000000000000000000000000003300000000099bb09999000000000000000f
909999ffff00000000bbbb33000000000099999bb0000000000000ff0000ff00000000000000000000000000000000000000009990099990000000000000000f
999990000000ffff08888883300000000999999000000000000000fff00fff00000000000000000000000000000000000000099990099000000000000000000f
99900000000fffff88888888330000000999999b000000000000000ffffff000000000000000000000000000000000000000999fff990000000000000000000f
99ffff0000fff00f88888888330000009999990bb000000000000000ffff000000000000000000000000000000000000000099fbbbbf0000000000000000000f
9ffffff000ff0000888888883000000000990099bb00000000000000000000000000000000000000000000000000000000099f888888f000000000000000000f
fff00fff00ff0000888888880000000009900999000000000000000000000000000000000000000000000000000000000000088888888000000000000000000f
ff0000ff00fff00ff8888880000000000000999900000000000000000000000000333300000000000000000000000000000bb88888888000000000000000000f
ff0000ff000ffffff08888b00000000000099990000000000000000000000000033333300000000000000000000000000088888888888000000000333300000f
fff00fff0000ffff000099bb0000000000099000000000000000000000000000333333330000000000000000000000000888888888888000000003333330000f
9ffffff000000000000999000000000000990000000000000000000000000000333333330000000000000000000000000888888888880000000033bbbb33000f
90ffff0000000000009999000000000000000000000000000000000000000000030330300000000000000000000000000888888888800000000038888883000f
9000000000000000099990000000000000000000000000000000000000000000000330000000000000000000000000000888888880000000000088888888000f
9000000000000000099000000000000000000000000000000000000000000000000330000000000000000000000000000088888800000000000088888888000f
90000000000000009900000000000000000000000000000000000000000000000003300000000000000000000ffff0000008888000000000000088888888000f
9000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffff00000bb00000000000000088888888000f
900000000000000000000000000000000000000000000000000000000000000000000000000000000000000fff00fff00099bffff00000000000f8888880000f
900000000000000000000000000000000000000000000000000000000000000000000000000000000000000fbbbb0ff00999ffffff000000000fff888800000f
900000000000000000000000000000000000000000000000000000000000000000000000000000000000000888888ff0999fff00fff00bbbb0fff00fff00000f
9000000000000000000000000000000000000000000000000000000000000000000000000000000bbbb00088888888f9999ff0000ff0888888ff0000ff00000f
90000000000000000000000000000000000000000000b000000000000000000000000000000000888888008888888809900ff0000ff88888888f0000ff00000f
9000000000ffff000000000000000000000003333000bb00000000000000b000000ffff0000008888888808888888899000fff00fff88888888ff00fff00000f
900000000ffffff000000000000000000bbb333333099bb0000000000bbbbb0000ffffff0000088888888088888888000000ffffff088888888ffffff000000f
90000000fff00fff0000000000000000888333333339900000000000888888b00fff00fff0000888888880088888800000000ffff00888888880ffffcccccc0f
90000000ff0000ff0000000000000008888333333339900000000008888888800ff0000ff00008888888800088880000000000000000888888000008cccccccf
90000000ff0000ff0000000000000008888838339399000000000008888888800ff0000ff00000888888000000000000000000000000088880000008caccaccf
90000000fff00fff0000000000000008888888339900000000000008888888800fff00fff00000088880000000000000000000000000000000000008cccccccf
900000000ffffff000000000000000088888883390000000000000088888888000ffffff000000000000000000000000000000000000000000000008caccaccf
9000000000ffff00000000000000000088888833000000000000000988888800000ffff0000000000000000000000000000000000000000000000008caaaaccf
900000000000000000000000000000000888800000000000000000000888800000000000000000000000000000000000000000000000000000000008cccccccf
900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000cccccc0f
8888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888f

__sfx__
011000000c32010310133400c32010310143400c3201031014340133301434013320143301333010320133300c32010310133400c32010310143400c32010310183300c331243300c33100000183300000018330
011000000c32010310133400c32010310143400c3201031014340133301434013320143301333010320133300c32010310133400c32010310143400c32010310183300c33124300243300c33118300303300c331
011000000c32010310133400c32010310143400c3201031014340133301434013320143301333010320133300c32010310133400c32010310143400c3201031024430184300c4301843024430184310c43100400
01100000245501855000000185502255022500185502055020500185501f5501e5001f5501d5501b5501955018552185521855218552185521855218552185520000000000000000000030052300523005230052
01100000245501855000000185502255022500185502055020500185501f5501e5001f5501d5501b5501955018552185521855218552185521855218552185520c5501b5501e5502155025550300003000030000
011000200c053216033c10024603246350c0033c700000030c053000030000324600246350000300003000030c053000030000300003246350000300003000030c05300003000030000324635000030000300003
011000200c0530c7003c1253c015246350c0033c125000030c053000033c1253c015246350000300003000030c053000033c1003c000246350000300003000030c05300003000030000324635000033c1003c000
011000000c7500d7510e7510f751107511175112751137511475115751167511775118751197511a7511b7511c7511d7511e7511f751207512175122751237512475125751267512775128751297512a7512b751
__music__
01 00424305
00 01424305
00 00424305
00 02424305
00 03424306
00 03424306
00 03474306
02 04474306

