pico-8 cartridge // http://www.pico-8.com
version 8
__lua__
-- bumble bots
-- (c) 2017, erwin bonsma

version="0.2"

col_delta={1,0,-1}
row_delta={0,1,0}
col_delta[0]=0
row_delta[0]=-1

--various 3-color color maps
pallete_mapping={
 {0,5,6},{1,13,12},
 {10,9,4},{2,14,15}
}

map_defs={
 {0,0,8,8}, --level 1
 {8,0,8,8}  --level 2
}

pickups={
 {--level 1
  {2,2}--,{9,2},{2,9},{9,9}
 },
 {--level 2
  {2,2}--,{9,2},{2,9},
 -- {4,4},{8,4},{4,8},{8,8}
 }
}
enemies={
 {{8,3}}, --level 1
 {{5,2},{5,3}}  --level 1
}
player_startpos={
 {4,6}, --level 1
 {5,9}  --level 2
}

--fields
-- sprite index, sprite height,
-- sprite y-delta, sprite repeat,
-- checker,
-- height0, flexibility
tiletypes={}

--basic, normal flexibility
tiletypes[0]={0,3,0,true,true,0,3}

--basic, fixed
tiletypes[1]={0,3,0,0,true,0,0}

--basic, low flexibility
tiletypes[2]={0,3,0,0,true,0,1}

--elevator, up+down
tiletypes[3]={2,3,0,true,false,0,10}

--pillar, moving
tiletypes[4]={4,3,0,true,false,0,2}

--pillar, fixed
tiletypes[5]={4,3,0,true,false,0,0}

--tower1, fixed
tiletypes[6]={6,4,-4,true,false,20,0}

--tower2, fixed
tiletypes[7]={8,4,-1,true,false,15,0}

--bridge, middle
tiletypes[8]={36,3,0,false,false,8,0}

--bridge, top-left
tiletypes[9]={10,3,0,true,false,8,0}

--bridge, bottom-right
tiletypes[10]={12,3,0,true,false,8,0}

--gap, row-dir, front
tiletypes[33]={65,3,-248,true,false,-256,0}

--gap, col-dir, front
tiletypes[34]={64,3,-248,true,false,-256,0}

--gap, back
tiletypes[35]={0,0,-248,false,false,-256,0}

clock=0

-- class inheritance
function extend(clz,baseclz)
 for k,v in pairs(baseclz) do
  clz[k]=v
 end
end

-- manhattan city distance
function distance(unit1,unit2)
 return (
  abs(unit1.col-unit2.col)+
  abs(unit1.row-unit2.row)
 )
end

function smooth_clamp(h)
 local hn=h/12
 local f=hn/sqrt(hn*hn+1)
 return f*12
end

function message_box(msg)
 local x=63-#msg*2
 local y=61
 rectfill(x,y-1,x+#msg*4,y+5,0)
 print(msg,x+1,y,10)
end

function print_await_key(action)
 print(
  "press Ž to "..action,
  40-#action*2,120,10
 )
end

function mainscreen_draw()
 cls()
 spr(192,0,32,16,4)
 print(
  "v"..version,84,60,4
 )
 print(
  "a game by eriban",32,78,4
 )
 print_await_key("start")
end

function mainscreen_update()
 if btnp(4) then
  game=new_game()
  _update=game.update
  _draw=game.draw
 end
end

function show_mainscreen()
 _update=mainscreen_update
 _draw=mainscreen_draw
end

map_unit={}

function map_unit:new(_mapmodel,o)
 o=o or {}
 o=setmetatable(o,self)
 self.__index=self

 o.mapmodel=_mapmodel
 o.tiletype=o.tiletype or 0

 local props=
  tiletypes[flr(o.tiletype/8)]
 o.sprite_index=props[1]
 o.sprite_height=props[2]
 o.sprite_ydelta=props[3]
 o.sprite_repeat=props[4]
 o.checker=props[5]
 o.height0=
  props[6]+2*(o.tiletype%8)
 o.flex=props[7]

 o.height=0
 o.movers={}

 return o
end

function map_unit:setwave(wave)
 self.height=
  self.height0+
  self.flex*wave
end

-- adds the mover for drawing
-- purposes. it may not yet
-- have entered the unit
function map_unit:add_mover(mover)
 if (mover.draw_unit!=nil) then
  mover.draw_unit:remove_mover(mover)
 end
 add(self.movers,mover)
 mover.draw_unit=self
end

function map_unit:remove_mover(mover)
 del(self.movers,mover)
end

function map_unit:add_pickup(pickup)
 pickup.unit=self
 self.pickup=pickup
end

function map_unit:remove_pickup(pickup)
 if (self.pickup==pickup) then
  self.pickup=nil
  pickup.unit=nil
 end
end

function map_unit:tostring()
 return "("..self.col..","..self.row..")"
end

function map_unit:neighbour(heading)
 local c=self.col+col_delta[heading]
 local r=self.row+row_delta[heading]
 if (
  c<1 or c>self.mapmodel.ncol or
  r<1 or r>self.mapmodel.nrow
 ) then
  return nil
 else
  return self.mapmodel.units[c][r]
 end
end

dirwave={}
function dirwave:new(angle,o)
 o=o or {}
 o=setmetatable(o,self)
 self.__index=self

 o.dx=cos(angle)
 o.dy=sin(angle)
 o.p=o.p or 90 -- period
 o.a=o.a or 1  -- amplitude
 o.w=o.w or 4  -- wavelength

 return o
end

function dirwave:eval(x,y)
 local d=x*self.dx+y*self.dy
 return sin(
  d/self.w-clock/self.p
 )*self.a
end

shock_wave={}
function shock_wave:new(x0,y0,o)
 o=o or {}
 o=setmetatable(o,self)
 self.__index=self

 o.x0=x0
 o.y0=y0
 o.f=o.f or 1/30 -- frequency
 o.a=o.a or 1 -- amplitude
 o.w=o.w or 4 -- wavelength
 o.clk0=clock

 return o
end

function shock_wave:eval(x,y)
 local dx=x-self.x0
 local dy=y-self.y0
 local dist=sqrt(dx*dx+dy*dy)
 local t=
  (clock-self.clk0)*self.f-
  dist/self.w
 return
  sin(max(0,min(1,t)))*self.a
end

map_model={}

function map_model:new(
 x0,y0,ncol,nrow
)
 local o=setmetatable({},self)
 self.__index=self

 o.ncol=ncol+2
 o.nrow=nrow+2
 o.units={}
 o.functions={}
 o.wave_strength=0
 o.wave_strength_delta=1

 for c=1,o.ncol do
  o.units[c]={}
  for r=1,o.nrow do
   local is_border=(
    c%(o.ncol-1)==1 or
    r%(o.nrow-1)==1
   )
   local unit={}
   unit.col=c
   unit.row=r
   if c==o.ncol then
    unit.tiletype=34*8
   elseif r==o.nrow then
    unit.tiletype=33*8
   elseif c==1 or r==1 then
    unit.tiletype=35*8
   else
    unit.tiletype=
     mget(x0+c-2,y0+r-2)
   end
   o.units[c][r]=map_unit:new(o,unit)
  end
 end

 add(
  o.functions,
  dirwave:new(0.10)
 )

 return o
end

function map_model:unit_at(pos)
 return self.units[pos[1]][pos[2]]
end

function map_model:update()
 self.wave_strength=
  max(0.5,min(1,
   self.wave_strength+
   self.wave_strength_delta/100
  ))

 for c=1,self.ncol do
  for r=1,self.nrow do
   local w=0
   for fun in all(self.functions) do
    w+=fun:eval(c,r)
   end
   self.units[c][r]:setwave(
    smooth_clamp(
     w*self.wave_strength
    )
   )
  end
 end
end

isoline_pair={}

function isoline_pair:new(
 leaf_left,
 leaf_right,
 height_from_right
)
 local o=setmetatable({},self)
 self.__index=self

 if height_from_right then
  o.leaf1=leaf_right
  o.leaf2=leaf_left
 else
  o.leaf1=leaf_left
  o.leaf2=leaf_right
 end

 return o
end

function isoline_pair:height()
 return self.leaf1:height()
end

function isoline_pair:draw()
 if (
  self.leaf1:height()<
  self.leaf2:height()
 ) then
  self.leaf1:draw()
  self.leaf2:draw()
 else
  self.leaf2:draw()
  self.leaf1:draw()
 end
end

isoline_leaf={}

function isoline_leaf:new(
 map_unit
)
 local o=setmetatable({},self)
 self.__index=self

 o.map_unit=map_unit

 return o
end

function isoline_leaf:height()
 return self.map_unit.height
end

function isoline_leaf:draw()
 local unit=self.map_unit
 local x=
  (unit.col-unit.row)*8+56
 local y=
  (unit.col+unit.row)*4
  -unit.height+24

 if (
  unit.checker and
  (unit.col+unit.row)%2==0
 ) then
  c=pallete_mapping[1]
  pal(5,c[1])
  pal(6,c[2])
  pal(7,c[3])
 end

 palt(0,false)
 palt(15,true)
 local dy=unit.sprite_ydelta
 spr(
  unit.sprite_index,
  x,y+dy,
  2,unit.sprite_height
 )

 if unit.sprite_repeat then
  dy+=unit.sprite_height*8
  while (unit.height-dy>-16) do
   spr(
    unit.sprite_index+
    (unit.sprite_height-1)*16,
    x,y+dy,
    2,1
   )
   dy+=8
  end
 end
 pal()

 x+=4
 y-=2

 if unit.pickup!=nil then
  unit.pickup:draw(x,y)
 end

 for mover in all(unit.movers) do
  mover:draw(x,y)
 end
end

function make_isoline_tree(
 unit_array,
 idx_lo,
 idx_hi,
 height_from_right
)
 if idx_lo==idx_hi then
  return isoline_leaf:new(
   unit_array[idx_lo]
  )
 else
  local idx_mid=flr((idx_lo+idx_hi)/2)
  return isoline_pair:new(
   make_isoline_tree(
    unit_array,
    idx_lo,
    idx_mid,
    true
   ),
   make_isoline_tree(
    unit_array,
    idx_mid+1,
    idx_hi,
    false
   ),
   height_from_right
  )
 end
end

function new_mapview(_model)
 local me={}
 local model=_model
 local isolines={}
 local nlines=model.ncol+model.nrow-1

 for i=1,nlines do
  isolines[i]={}
 end
 for c=1,model.ncol do
  for r=1,model.nrow do
   add(
    isolines[c+r-1],
    model.units[c][r]
   )
  end
 end
 for i=1,nlines do
  isolines[i]=make_isoline_tree(
   isolines[i],1,#isolines[i]
  )
 end

 function me.draw()
  cls()
  for i=1,nlines do
   isolines[i]:draw()
  end
 end

 return me
end --new_mapview

mover={}

function mover:new(o)
 o=o or {}
 local o=setmetatable(o,self)
 self.__index=self

 o.rot=0     -- [0..rot_max>
 o.rot_dir=0 -- -1,0,1

 o.mov_dir=0 -- -1,0,1
 o.mov=0     -- <-mov_max,mov_max]
 o.mov_inc=1 -- -1,1

 -- height tolerance
 o.tol=o.tol or 0

 -- rotation speed
 o.rot_del=o.rot_del or 2
 o.rot_turn=5*o.rot_del
 o.rot_max=4*o.rot_turn

 -- move speed
 o.mov_del=o.mov_del or 2
 o.mov_max=8*o.mov_del

 o.drop_speed=1
 o.dazed=0
 o.height=40

 return o
end

function mover:destroy()
 self.draw_unit:remove_mover(self)
end

function mover:turning()
 return self.rot_dir!=0
end

function mover:moving()
 return self.mov_dir!=0
end

function mover:is_dazed()
 return self.dazed>0
end

function mover:freeze()
 self.frozen=true
end

function mover:can_move()
 return (
  self.dazed==0 and
  not self.frozen
 )
end

function mover:heading()
 return flr(self.rot/self.rot_turn)
end

function mover:draw(x,y)
 local r=flr(self.rot/self.rot_del)
 local dx=0
 local dy=0
 if r>9 then
  --invert rear/front lights
  pal(8,10)
  pal(10,8)
 end
 if self:is_dazed() then
  --show animated dazed "bugs"
  local c=band(self.dazed,4)/4
  palt(5+c,true)
  pal(6-c,9)
 else
  --hide dazed "bugs"
  palt(5,true)
  palt(6,true)
 end

 if self:moving() then
  local h=self:heading()
  dx=flr(
   (col_delta[h]-row_delta[h])
   *self.mov/self.mov_del+0.5
  )*self.mov_dir
  dy=flr(
   (col_delta[h]+row_delta[h])
   *self.mov/self.mov_del/2+0.5
  )*self.mov_dir
 end

 dy-=self.height-self.draw_unit.height

 spr(160+r%10,x+dx,y+dy-7,1,2)
 pal()
end --mover:draw()

function mover:update_height()
 local height=self.unit.height

 -- adapt height if needed
 if self.unit2!=nil then
  --on two tiles, follow highest
  height=max(height,self.unit2.height)
 end
 if self.height>height then
  --gradual fall
  height=max(
   height,self.height-self.drop_speed
  )
  self.drop_speed+=0.1
 else
  self.drop_speed=1
 end
 self.height=height
end

function mover:turn_step()
 self.rot+=self.rot_dir+self.rot_max
 self.rot%=self.rot_max
 if self.rot%(5*self.rot_del)==0 then
  -- finished turn
  self.rot_dir=0
 end
end

function mover:move_step()
 self.mov+=self.mov_inc

 local relmov=(
  self.mov+self.mov_max
 )%self.mov_max

 if relmov==2*self.mov_del-1 then
  -- about to enter next unit
  local to_unit=self.unit:neighbour(
   (
    self:heading()+
    self.mov_dir+3
   )%4
  )
  if self:can_enter(to_unit) then
   -- entered destination unit
   self:entering_unit(to_unit)
  else
   -- cannot move, retreat
   self.mov_inc=-1
   self.mov+=self.mov_inc
   self:bump()
  end
 elseif relmov==4*self.mov_del then
  -- halfway crossing
  self:enter_unit()
 elseif relmov==7*self.mov_del then
  -- exited source unit
  self:exited_unit()
 elseif self.mov==0 then
  -- done
  self.mov_dir=0
  self.mov_inc=1
 end
end

function mover:update()
 if self.dazed>0 then
  self.dazed-=1
 end

 if self:can_move() then
  if self:turning() then
   self:turn_step()
  elseif self:moving() then
   self:move_step()
  end
 end

 self:update_height()
end --mover:update()

function mover:bump()
 self.dazed=20
end

function mover:can_enter(unit)
 return unit.height-self.unit.height<=self.tol
end

function mover:entering_unit(to_unit)
 --msg="entering:"..self.unit:tostring().."-"..to_unit:tostring()
 self.unit2=to_unit

 if (
  to_unit.col+to_unit.row >
  self.unit.col+self.unit.row
 ) then
  to_unit:add_mover(self)
  self.mov-=self.mov_max
 end
end

function mover:enter_unit()
 --msg="emter:"..self.unit:tostring().."-"..self.unit2:tostring()
 local unit=self.unit2
 self.unit2=self.unit
 self.unit=unit
end

function mover:exited_unit()
 --msg="exited_unit"
 if (self.draw_unit!=self.unit) then
  self.unit:add_mover(self)
  self.mov-=self.mov_max
 end
 self.unit2=nil
end

player={}
extend(player,mover)

function player:new(o)
 o=mover.new(self,o)
 local o=setmetatable(o,self)
 self.__index=self

 o.nxt_rot_dir=nil

 return o
end

function player:update()
 if btnp(0) then
  self.nxt_rot_dir=-1
 elseif btnp(1) then
  self.nxt_rot_dir=1
 end

 if (
  self:can_move() and
  not self:moving() and
  not self:turning()
 ) then
  if self.nxt_rot_dir!=nil then
   self.rot_dir=self.nxt_rot_dir
   self.nxt_rot_dir=nil
  elseif btn(2) then
   self.mov_dir=1
  elseif btn(3) then
   self.mov_dir=-1
  end
 end

 local unit2=self.unit2
 mover.update(self)
 if (
  unit2!=nil and
  self.unit2==nil
 ) then
  sfx(5)
 end

 if (
  self.unit.pickup!=nil and
  self.height==self.unit.height
 ) then
  self.unit.pickup:pickup(self)
  self.unit.pickup=nil
 end

 if self.height<-50 then
  game.signal_death()
 end
end --update()

function player:bump()
 mover.bump(self)
 sfx(0)
end

enemy={}
extend(enemy,mover)

function enemy:new(target,o)
 o=o or {}
 o.rot_del=o.rot_del or 3
 o=mover.new(self,o)
 local o=setmetatable(o,self)
 self.__index=self
 
 o.target=target

 return o
end

function enemy:draw(x,y)
 pal(12,14)
 pal(1,2)
 mover.draw(self,x,y)
 pal()
end

function enemy:update()
 if self.unit==self.target.unit then
  game:signal_death()
 end

 if self:can_move() then
  if (
   not self:moving() and
   not self:turning()
  )
  then
   --to turn or not to turn?
   local best_rotdir=0
   local best_score=nil
   for rotdir=-1,1 do
    local h=(self:heading()+rotdir+4)%4
    local s=self:heading_score(h)
    if best_score==nil or s>best_score then
     best_rotdir=rotdir
     best_score=s
    end
   end

   self.rot_dir=best_rotdir
  end

  if not self:turning() then
   self.mov_dir=1
  end
 end

 mover.update(self)
end --enemy:update

function enemy:heading_score(h)
 local score=0
 local to_unit=self.unit:neighbour(h)
 local target_unit=self.target.unit

 if to_unit==nil or to_unit.height<-5 then
  return -99
 end

 if (
  distance(to_unit, target_unit) <
  distance(self.unit, target_unit)
 ) then
  --reward getting closer
  score+=4
 end

 if h==self:heading() then
  --prefer moving straight
  score+=1
 end

 if self:can_enter(to_unit) then
  --reward possible movement
  score+=2
 elseif self:is_blocked(to_unit) then
  score-=6
 else
  --penalize climbs
  local hdelta=to_unit.height-self.unit.height-self.tol
  score-=max(0,min(5,hdelta))
 end

 return score
end --enemy:heading_score

function enemy:is_blocked(unit)
 return (
  unit.pickup!=nil or
  self.unit.height-unit.height>10
 )
end

function enemy:can_enter(unit)
 return (
  mover.can_enter(self,unit) and
  not self:is_blocked(unit)
 )
end

function enemy:bump()
 mover.bump(self)
 self.dazed+=flr(rnd(20))-10
end

pickup={}

function pickup:new(o)
 o=o or {}
 local o=setmetatable(o,self)
 self.__index=self

 return o
end

function pickup:draw(x,y)
 spr(128,x,y,1,1)
end

function pickup:pickup(actor)
 self.unit.remove_pickup(self)
 game.signal_pickup(self)
 sfx(3)
end

level={}

function level:new(o)
 o=o or {}
 local o=setmetatable(o,self)
 self.__index=self

 o.pickups={}
 o.movers={}

 return o
end

function level:init_map(map_model)
 self.map_model=map_model
 self.map_view=new_mapview(map_model)
end

function level:add_mover(pos,mover)
 local unit=
  self.map_model:unit_at(pos)
 unit:add_mover(mover)
 mover.unit=unit
 add(self.movers,mover)
end

function level:add_player(pos)
 self.player=player:new()
 self:add_mover(pos,self.player)
end

function level:add_enemy(pos,enemy)
 self:add_mover(pos,enemy)
end

function level:add_pickup(pos,pickup)
 self.map_model:unit_at(pos):add_pickup(
  pickup
 )
 add(self.pickups,pickup)
end

function level:reset()
 for mover in all(self.movers) do
  mover:destroy()
 end
 self.movers={}
 self.player=nil
 self.map_model.wave_strength_delta=1
end

function level:freeze()
 for mover in all(self.movers) do
  mover:freeze()
 end
end

function level:update()
 self.map_model:update()

 for mover in all(self.movers) do
  mover:update()
 end
end

function level:draw()
 self.map_view.draw()
end

leveldef={}
extend(leveldef,level)

function leveldef:new(idx,o)
 o=level.new(self,o)
 local o=setmetatable(o,self)
 self.__index=self

 o.idx=idx
 o.num_enemies=o.num_enemies or 1

 local map_def=map_defs[idx]
 o:init_map(map_model:new(
  map_def[1],
  map_def[2],
  map_def[3],
  map_def[4]
 ))

 for pickup_pos in all(pickups[idx]) do
  o:add_pickup(
   pickup_pos,pickup:new()
  )
 end

 return o
end

function leveldef:reset()
 level.reset(self)
 self:add_player(
  player_startpos[self.idx]
 )

 for enemy_pos in all(enemies[self.idx]) do
  self:add_enemy(
   enemy_pos,
   enemy:new(self.player)
  )
 end
end

function new_game()
 local me={}

 local anim=nil
 local level_num=0
 local lives=3
 local pickups={}
 local level=nil
 local death_signalled

 function me.draw()
  level:draw()
  for i=1,lives do
   spr(164,i*10-8,-6,1,2)
  end
  local x=120
  for pickup in all(pickups) do
   pickup:draw(x,0)
   x-=9
  end
  if anim!=nil then
   anim.draw()
  end
  if msg!=nil then
   print(msg,0,120,7)
  end
 end

 function me.update()
  clock+=1

  if (anim!=nil) then
   anim=anim.update()
  end

  death_signalled=false

  level:update()

  if (anim==nil) then
   if #pickups==#level.pickups then
    level_done()
   elseif death_signalled then
    me:handle_death()
   end
  end
 end

 function me.reset()
  level:reset()
 end

 function me.signal_death()
  death_signalled=true
 end

 function me.handle_death()
  lives-=1
  if lives>0 then
   anim=die_animation(level)
  else
   anim=game_over_animation(level)
  end
 end

 function me.signal_pickup(pickup)
  add(pickups,pickup)
 end

 function level_done()
  anim=level_done_animation(level)
 end

 function me.next_level()
  level_num+=1
  if level_num<=#map_defs then
   pickups={}
   level=leveldef:new(
    level_num
   )
   level:reset()
   return true
  end
 end

 me.next_level()

 return me
end --new_game()

function die_animation(level)
 local me={}

 local clk=0

 function me.update()
  clk+=1

  if clk==1 then
   sfx(1)
  end

  if clk==100 then
   game.reset()
   return nil
  end

  return me
 end

 function me.draw()
  message_box("careful now")
 end

 level.map_model.wave_strength_delta=-1
 level:freeze()

 return me
end --die_animation

function game_over_animation(level)
 local me={}

 local clk=0

 function me.update()
  clk+=1

  if btnp(4) then
   show_mainscreen()
  end

  return me
 end

 function me.draw()
  message_box("game over")
  if clk>100 then
   print_await_key("retry")
  end
 end

 level:freeze()
 sfx(2)

 return me
end --game_over_animation

function level_done_animation(level)
 local me={}

 local clk=0

 function me.update()
  clk+=1

  if clk==20 then
   sfx(6)
  end

  if clk==150 then
   if game.next_level() then
    return nil
   else
    return game_done_animation()
   end
  end

  return me
 end

 function me.draw()
  if clk>=20 then
   message_box("level done!")
  end
 end

 local pu=level.player.unit
 add(
  level.map_model.functions,
  shock_wave:new(pu.col,pu.row)
 )
 level:freeze()

 return me
end --level_done_animation

function game_done_animation()
 local me={}

 local clk=0

 function me.update()
  clk+=1

  if btnp(4) then
   show_mainscreen()
  end

  return me
 end

 function me.draw()
  message_box(
   "end of the line..."
  )
  if clk>100 then
   print_await_key("retry")
  end
 end

 sfx(4)

 return me
end --game_done_animation

show_mainscreen()

--eof
__gfx__
ffffffff7fffffffffffffff7ffffffffffffffffffffffffffffff84ffffffffffffff77fffffffffffffff7fffffffffffffff7fffffff8888888888888888
ffffff77777fffffffffff77777ffffffffff777777fffffffffff8844ffffffffffff75675fffffffffff77777fffffffffff77777fffff8ffffff88ffffff8
ffff777777777fffffff777777777ffffff7777777777ffffffff888444ffffffff77655665775ffffff777777777fffffff777777777fff8ffffff88ffffff8
ff7777777777777fff7777777777777fff777777777777ffffff88884444fffff76556556656657fff7777777777777fff7777777777777f8ffffff88ffffff8
77777777777777777777777777777777ff677777777775fffff8888844444fff7565555996666567777777777777777777777777777777778ffffff88ffffff8
67777777777777556777777777777755ff566777777550ffff888888444444ff6755599999966675677777777777775567777777777777558ffffff88ffffff8
66677777777755556667777777775555ff656656655655fff88888884444444f6657799999977655666777777777555566677777777755558ffffff88ffffff8
66666777775555556666677777555555ff666665565555ff88888888444444446656657997655655666667777755555566666777775555558888888888888888
6666666755555555f6666667555555ffff566666656550ff6888888844444455666665677565565566666667555555ff66666667555555558888888888888888
6666666655555555fff666665555ffffff656656565655ff66688888444455556666656655655555666666665555fffff6666666555555558ffffff88ffffff8
6666666655555555fffff66655ffffffff666665655555ff666668884455555566666666555555556666666655ffffffff666666555555558ffffff88ffffff8
6666666655555555fffffff694ffffffff566666566550ff665666685555505566656666555505556666666600fffffffff66666555555558ffffff88ffffff8
6666666655555555fffffffa94ffffffff656656655655ff665666665555505566656666555505556666665000fffffffff66666555555558ffffff88ffffff8
6666666655555555fffffffa94ffffffff666665565555ff665666665555505566656666555505556666550500ffffffffff6666555555558ffffff88ffffff8
6666666655555555fffffffa94ffffffff566666656550ff665666665555505566656666555505556665555550fffffffffff666555555558ffffff88ffffff8
6666666655555555fffffffa94ffffffff656656565655ff667766665555665566676666555565556665555555fffffffffff666555555558888888888888888
6666666655555555fffffffa94ffffffffffffff7fffffff666677665566555566667666555655556655555555fffffffffff666555555558888888888888888
6666666655555555fffffffa94ffffffffffff77777fffff666666665555555566666666555555556655555555fffffffffff666555555558ffffff88ffffff8
6666666655555555fffffffa94ffffffffff777777777fff666666665555555566666666555555556655555555ffffffffffff66555555558ffffff88ffffff8
6666666655555555fffffffa94ffffffff7777777777777f666666665555555566666666555555556655555555ffffffffffff66555555558ffffff88ffffff8
6666666655555555fffffffa94ffffff7777777777777777666666665555555566666666555555556655555555ffffffffffff66555555558ffffff88ffffff8
6666666655555555fffffffa94ffffff6777777777777755666666665555555566666666555555556655555555ffffffffffff66555555558ffffff88ffffff8
6666666655555555fffffffa94ffffff6667777777775555666666665555555566666666555555556655555555ffffffffffff66555555558ffffff88ffffff8
6666666655555555fffffffa94ffffff6666677777555555666666665555555566666666555555556655555555ffffffffffff66555555558888888888888888
88888888888888888888888888888888f6666667555555ff666666665555555566666666555555558888888888888888ffffff66555555558888888888888888
8ffffff88ffffff88ffffff88ffffff8fff666665555ffff666666665555555566666666555555558ffffff88ffffff8ffffff66555555558ffffff88ffffff8
8ffffff88ffffff88ffffff88ffffff8fffff66655ffffff666666665555555566666666555555558ffffff88ffffff8ffffff66555555558ffffff88ffffff8
8ffffff88ffffff88ffffff88ffffff8fffffff6ffffffff666666665555555566666666555555558ffffff88ffffff8ffffff66555555558ffffff88ffffff8
8ffffff88ffffff88ffffff88ffffff8ffffffffffffffff666666665555555566666666555555558ffffff88ffffff8ffffff66555555558ffffff88ffffff8
8ffffff88ffffff88ffffff88ffffff8ffffffffffffffff666666665555555566666666555555558ffffff88ffffff8ffffff66555555558ffffff88ffffff8
8ffffff88ffffff88ffffff88ffffff8ffffffffffffffff666666665555555566666666555555558ffffff88ffffff8ffffff66555555558ffffff88ffffff8
88888888888888888888888888888888ffffffffffffffff666666665555555566666666555555558888888888888888ffffff66555555558888888888888888
ffffffffffffffff0fffffff88888888f77fffffffffffffffffffff7fffffff0000000000000000000000000000000000000000000000000000000000000000
ffffff00ffffffff000fffff8ffffff8f6677fffffffffffffffff77777fffff0000000000000000000000000000000000000000000000000000000000000000
ffff0000ffffffff00000fff8ffffff86506677fffffffffffff777777777fff0000000000000000000000000000000000000000000000000000000000000000
ff000000ffffffff0000000f8ffffff8650006677fffffffff7777777777777f0000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff000000008ffffff8650b0006677fffff77777777777777770000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff000000008ffffff865000b3006677fff67777777777777550000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff000000008ffffff86503300b0006675f66677777777755550000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff0000000088888888650003000330065f66666777775555550000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff00000000ffffffff650b300b300b065ff6666667555555ff0000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff00000000ffffffff650000300030065ffff666665555ffff0000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff00000000ffffffff67700003b00b065ffffff66655ffffff0000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff00000000fffffffff66770000b00065ffffffff6ffffffff0000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff00000000fffffffffff667700000065fffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff00000000fffffffffffff6677000065fffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff00000000ffffffffffff77766770065fffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff00000000ffffffffff7777765667765fffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff00000000ffffffff7777777657786777ffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff00000000ffffffff6777777777777755ffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff00000000ffffffff6667777777775555ffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff00000000ffffffff6666677777555555ffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff00000000fffffffff6666667555555ffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff00000000fffffffffff666665555ffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff00000000fffffffffffff66655ffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff00000000fffffffffffffff6ffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000000000000000000000000000000000000000000000000000
00999900008888880000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
09a99990006688880000005550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
9aaa9994008856880000066633300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
99a99994885556660000555333330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
99999944555556660005553337333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
49999444555500660005533307733000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
04444440550000000055533005533000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00444400000000000055330005533000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000055330055533000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000055330055330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000077330553330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000007333533300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000007733333000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000073330000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00065000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000650000000000000000000000000000000000000000000000000000000000000000000000000000000000
00605600000000000000000000000000000000000056000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00506500000000000000000000000000000000000000560000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000c00000000c000000000000c00000000c00000000c00000000c000000000000c00000000c0000000000000000000000000000000000000000000000000000
00ccccc000ccccc00cccccc00ccccc000ccccc0000ccccc000ccccc00cccccc00ccccc000ccccc00000000000000000000000000000000000000000000000000
cccccccc0ccccccc0cccccc0ccccccc0cccccccccccccccc0ccccccc0cccccc0ccccccc0cccccccc000000000000000000000000000000000000000000000000
dccccc110dccccc10cccccc0dccccc10ddccccc1dccccc110dccccc10cccccc0dccccc10ddccccc1000000000000000000000000000000000000000000000000
dddc11110ddc11110d1d1d10ddddc110ddddc111dddc11110ddc11110d1d1d10ddddc110ddddc111000000000000000000000000000000000000000000000000
8ddd111a08d1111a01d1d1d08dddd1a08ddd111a8ddd111a08d1111a01d1d1d0adddd180addd1118000000000000000000000000000000000000000000000000
d88d11110d811111081d1da0ddddda10dddd1aa1dddd1aa10da1aaa10aaaaaa0daaada10daad1111000000000000000000000000000000000000000000000000
ddd881110dd8111101d1d1d0dddda110dddaa111dddaa1110dda11110d1d1d10dddda110dddaa111000000000000000000000000000000000000000000000000
0ddd110000d111100d1d1d100dddd10000dd11100ddd110000d1111001d1d1d00dddd10000dd1110000000000000000000000000000000000000000000000000
000d000000010000000000000000d00000001000000d000000010000000000000000d00000001000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000444445000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000444444500000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000444504450000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000c000000000000000000000044450045000000000000000000000000000000000000000000000000000000000000000000e000000000000000
0000000000000ccccc00000000000000000000444500450000000000000000000000000000000000000000000000000000000000000000eeeee0000000000000
00000000000cccc9cccc0000000000000000004445044500000000000000000000000000000000000000000000000000000000000000eeee8eeee00000000000
000000000cccccc5cccccc00000000000000004444445000aa90aa904450000450aaaa900044500000aaaaaa000000000000000000eeeeee5eeeeee000000000
0000000cccccccc5cccccccc000000000000004444445000aa90aa904445004450aa90a90044500000aa90000000000000000000eeeeeeee5eeeeeeee0000000
00000cccccccccc5cccccccccc0000000000004445044500aa90aa904444544450aa90a90044500000aa900000000000000000eeeeeeeeee5eeeeeeeeee00000
0000ccccccccccccccccccccccc000000000004445004450aa90aa904454444450aaaa900044500000aaaaa90000000000000eeeeeeeeeeeeeeeeeeeeeee0000
0000dccccccccccccccccccccc1000000000004445004450aa90aa904450454450aaaaa90044500000aaaaa90000000000000deeeeeeeeeeeeeeeeeeeee20000
0000dddccccccccccccccccc111000000000004445004450aa90aa904450004450aa90aa9044500000aa90000000000000000dddeeeeeeeeeeeeeeeee2220000
0000dddddccccccccccccc11111000000000004445044450aa90aa904450004450aa90aa9044500000aa90000000000000000dddddeeeeeeeeeeeee222220000
0000dddddddccccccccc1111111000000000004444444500aaaaaa904450004450aaaaaa9044444450aaaaaa0000000000000dddddddeeeeeeeee22222220000
00000ddddddddccccc1111111110000000000044444450000aaaa9004450004450aaaaa90044444450aaaaaa0000000000000dddddddddeeeee2222222200000
000008dddddddddc111111111a0000000000000000000000000000000000000000000000000000000000000000000000000000addddddddde222222222800000
0000c8dddddddddd1111111aaa0000000000000000000000000000000000000000000000000000000000000000000000000000aaaddddddd22222222228e0000
0000dcdddddddddd11111aaaacc00000000000000000000044444500000000000000000000000000000000000000000000000eeaaaaddddd2222222222e20000
0000dddddddddddd111aaaacc1100000000000000000000044444450000000000000000000000000000000000000000000000ddeeaaaaddd2222222222220000
0007ddddddddd1ad1aaaacc111100000000000000000000044450445000000000000000000000000000000000000000000000ddddeeaaaad2a12222222227000
000677ddddddd1aaaaacc11111170000000000000000000044450045000000000000000000000000000000000000000000007ddddddeeaaaaa12222222775000
000665dddddddccaacc111111775000000000000000000004445004500000000000000000000000000000000000000000000677ddddddeeaaee2222222655000
000065d500dddddcc1111117755500000000000000000000444504450000000000000000000000000000000000000000000066677ddddddee222220052650000
0000005500dddddd1111177555500000000000000000000044444450000aaaa904444444450aaaa9000000000000000000000666677ddddd2222220055000000
00000055500ddddd111775555000000000000000000000004444445000aa90aa9000445000a9000000000000000000000000000666677ddd2222200555000000
00000050500ddd7d177555500000000000000000000000004445044500aa90aa9000445000a900000000000000000000000000000666677d2722200505000000
0000005550000d67755550000000000000000000000000004445004450aa90aa9000445000aaaaa9000000000000000000000000000666677520000555000000
0000000550000066555000000000000000000000000000004445004450aa90aa90004450000aaaaa900000000000000000000000000006665500000550000000
0000000500000006500000000000000000000000000000004445004450aa90aa90004450000000aa900000000000000000000000000000065000000050000000
0000000000000000000000000000000000000000000000004445044450aa90aa90004450000000aa900000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000004444444500aa90aa9000445000aaaaa9000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000044444450000aaaa90000445000aaaaa9000000000000000000000000000000000000000000000000
__label__
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000444445000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000444444500000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000444504450000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000c000000000000000000000044450045000000000000000000000000000000000000000000000000000000000000000000e000000000000000
0000000000000ccccc00000000000000000000444500450000000000000000000000000000000000000000000000000000000000000000eeeee0000000000000
00000000000cccc9cccc0000000000000000004445044500000000000000000000000000000000000000000000000000000000000000eeee8eeee00000000000
000000000cccccc5cccccc00000000000000004444445000aa90aa904450000450aaaa900044500000aaaaaa900000000000000000eeeeee5eeeeee000000000
0000000cccccccc5cccccccc000000000000004444445000aa90aa904445004450aa90a90044500000aa90000000000000000000eeeeeeee5eeeeeeee0000000
00000cccccccccc5cccccccccc0000000000004445044500aa90aa904444544450aa90a90044500000aa900000000000000000eeeeeeeeee5eeeeeeeeee00000
0000ccccccccccccccccccccccc000000000004445004450aa90aa904454444450aaaa900044500000aaaaa90000000000000eeeeeeeeeeeeeeeeeeeeeee0000
0000dccccccccccccccccccccc1000000000004445004450aa90aa904450454450aaaaa90044500000aaaaa90000000000000deeeeeeeeeeeeeeeeeeeee20000
0000dddccccccccccccccccc111000000000004445004450aa90aa904450004450aa90aa9044500000aa90000000000000000dddeeeeeeeeeeeeeeeee2220000
0000dddddccccccccccccc11111000000000004445044450aa90aa904450004450aa90aa9044500000aa90000000000000000dddddeeeeeeeeeeeee222220000
0000dddddddccccccccc1111111000000000004444444500aaaaaa904450004450aaaaaa9044444450aaaaaa9000000000000dddddddeeeeeeeee22222220000
00000ddddddddccccc1111111110000000000044444450000aaaa9004450004450aaaaa90044444450aaaaaa9000000000000dddddddddeeeee2222222200000
000008dddddddddc111111111a0000000000000000000000000000000000000000000000000000000000000000000000000000addddddddde222222222800000
0000c8dddddddddd1111111aaa0000000000000000000000000000000000000000000000000000000000000000000000000000aaaddddddd22222222228e0000
0000dcdddddddddd11111aaaacc00000000000000000000044444500000000000000000000000000000000000000000000000eeaaaaddddd2222222222e20000
0000dddddddddddd111aaaacc1100000000000000000000044444450000000000000000000000000000000000000000000000ddeeaaaaddd2222222222220000
0007ddddddddd1ad1aaaacc111100000000000000000000044450445000000000000000000000000000000000000000000000ddddeeaaaad2a12222222227000
000677ddddddd1aaaaacc11111170000000000000000000044450045000000000000000000000000000000000000000000007ddddddeeaaaaa12222222775000
000665dddddddccaacc111111775000000000000000000004445004500000000000000000000000000000000000000000000677ddddddeeaaee2222222655000
000065d500dddddcc1111117755500000000000000000000444504450000000000000000000000000000000000000000000066677ddddddee222220052650000
0000005500dddddd1111177555500000000000000000000044444450000aaaa904444444450aaaa9000000000000000000000666677ddddd2222220055000000
00000055500ddddd111775555000000000000000000000004444445000aa90aa9000445000a9000000000000000000000000000666677ddd2222200555000000
00000050500ddd7d177555500000000000000000000000004445044500aa90aa9000445000a900000000000000000000000000000666677d2722200505000000
0000005550000d67755550000000000000000000000000004445004450aa90aa9000445000aaaaa9000000000000000000000000000666677520000555000000
0000000550000066555000000000000000000000000000004445004450aa90aa90004450000aaaaa900000000000000000000000000006665500000550000000
0000000500000006500000000000000000000000000000004445004450aa90aa90004450000000aa900040404440000044000000000000065000000050000000
0000000000000000000000000000000000000000000000004445044450aa90aa90004450000000aa900040404040000004000000000000000000000000000000
0000000000000000000000000000000000000000000000004444444500aa90aa9000445000aaaaa9000040404040000004000000000000000000000000000000
00000000000000000000000000000000000000000000000044444450000aaaa90000445000aaaaa9000044404040000004000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000004004440040044400000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000444000000440444044404440000044404040000044404440444044404440440000000000000000000000000000000000
00000000000000000000000000000000404000004000404044404000000040404040000040004040040040404040404000000000000000000000000000000000
00000000000000000000000000000000444000004000444040404400000044004440000044004400040044004440404000000000000000000000000000000000
00000000000000000000000000000000404000004040404040404000000040400040000040004040040040404040404000000000000000000000000000000000
00000000000000000000000000000000404000004440404040404440000044404440000044404040444044404040404000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000000000000000000aaa0aaa0aaa00aa00aa000000aaaaa000000aaa00aa000000aa0aaa0aaa0aaa0aaa0000000000000000000000000000000
000000000000000000000000000000a0a0a0a0a000a000a0000000aa000aa000000a00a0a00000a0000a00a0a0a0a00a00000000000000000000000000000000
000000000000000000000000000000aaa0aa00aa00aaa0aaa00000aa0a0aa000000a00a0a00000aaa00a00aaa0aa000a00000000000000000000000000000000
000000000000000000000000000000a000a0a0a00000a000a00000aa000aa000000a00a0a0000000a00a00a0a0a0a00a00000000000000000000000000000000
000000000000000000000000000000a000a0a0aaa0aa00aa0000000aaaaa0000000a00aa000000aa000a00a0a0a0a00a00000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
00000000000000001b4b43534b43531b00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000080909090909090900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000008090a0101010a0900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000080901010101010900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000080901010101010900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000080901010101010900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000008090a0101010a0900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000909090909090900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000100001e0501a750000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010a00001d0501d0501c0501c0501805118052180421803218025186000c6000c6000c6000c600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000000505005050040500405000051000520004200042000320003200012000150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010800001005013050150501503515000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010a00001175011750110001175011000117500000015754157501575015755130041100400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010200000b31300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010900000e5500e5501a3041055010550000001355713557135471353713525135150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
001000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344
00 41424344

