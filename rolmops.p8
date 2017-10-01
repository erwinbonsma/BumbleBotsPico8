pico-8 cartridge // http://www.pico-8.com
version 8
__lua__
-- bumble bots
-- (c) 2017, erwin bonsma

version="0.3"

col_delta={1,0,-1}
row_delta={0,1,0}
col_delta[0]=0
row_delta[0]=-1

colmaps={
 {80,101,118}, --b&w to dark
 {131,155}, --teleport green
 {129,156}, --teleport blue
 {141,158}, --teleport pink
 {81,109,124}, --b&w to blue
}
colmaps[0]={} --default

--x0,y0,w,h,wave_amplitude
map_defs={
 --level 1
 {0,0,8,8,1,120,"ride the waves"},
 --level 2
 {0,8,8,8,1.5,120,"barsaman"},
 --level 3
 {8,0,8,8,1,180,"gutter and stage"},
 --level 4
 {8,8,8,8,1,120,"telerium"},
 --level 5
 {16,0,8,8,1,120,"mind the gap"}
}

objects={
 {--level 1
  {2,2},{9,2},{2,9},{9,9}
 },
 {--level 2
  {2,2},{6,2},{2,6}
 },
 {--level 3
  {2,2},{9,2},{2,9},
  {4,4},{8,4},{4,8},{8,8}
 },
 {--level 4
  {5,2},{2,5},{7,5},{5,7},
  {9,5},{5,9},
  --teleports(c1,r1,col,c2,r2)
  {2,2,1,6,5},
  {9,2,2,6,6},
  {2,9,3,5,5},
  {9,9,4,5,6}
 },
 {--level 5
  {3,3},{8,3},{3,8},{8,8},
  --gaps(c,r,5[,col])
  {3,4,5},
  {4,3,5},
  {4,4,5},
  {5,3,5}
 }
}

movers={
 {--level 1
  {4,7}, --player
  {8,3} --enemy
 },
 {--level 2
  {9,9}, --player
  {9,2},{2,9} --enemies
 },
 {--level 3
  {5,9}, --player
  {5,2},{5,3} --enemies
 },
 {--level 4
  {7,7}, --player
  {3,3} --enemy
 },
 {--level 5
  {6,6}, --player
  {2,2},
  --boxes
  {4,6,1},
  {4,7,1},
  {6,5,1},
  {8,5,1}
 }
}

--fields
-- sprite index, sprite height,
-- sprite y-delta, sprite repeat,
-- colmap_idx (<0: checker),
-- height0, flexibility
tiletypes={}

--basic, normal flexibility
--
--note: sprite differs with fixed.
--fixed is full width, with few
--pixels that are typically covered
--by neighbouring fixed tiles.
--however, they ensure a clean
--boundary at edge of map. moving
--tiles are actual size, which
--results in less clean map boundary.
tiletypes[0]={14,2,0,true,-1,0,3}

--basic, fixed
tiletypes[1]={0,3,0,false,-1,0,0}

--basic, low flexibility
tiletypes[2]={14,2,0,false,-1,0,1}

--elevator, up+down
tiletypes[3]={2,3,0,true,0,0,10}

--pillar, moving
tiletypes[4]={4,2,1,true,0,0,2}

--pillar, fixed
tiletypes[5]={4,2,1,true,0,0,0}

--tower1, fixed
tiletypes[6]={6,4,-4,true,0,20,0}

--tower2, fixed
tiletypes[7]={8,4,-1,true,0,15,0}

--bridge, middle
tiletypes[8]={36,3,0,false,0,8,0}

--bridge, top-left
tiletypes[9]={10,3,0,true,0,8,0}

--bridge, bottom-right
tiletypes[10]={12,3,0,true,0,8,0}

--basic, fixed, light
tiletypes[11]={0,3,0,false,0,0,0}

--basic, fixed, blue
tiletypes[12]={0,3,0,false,5,0,0}

--basic, fixed, dark
tiletypes[13]={0,3,0,false,1,0,0}

--basic, fixed, blue/dropped
tiletypes[14]={0,3,8,false,5,0,0}

--gap, row-dir, front
tiletypes[33]={65,3,-248,true,0,-256,0}

--gap, col-dir, front
tiletypes[34]={64,3,-248,true,0,-256,0}

--gap, back
tiletypes[35]={0,0,-248,false,0,-256,0}

--global game state
clock=0
game=nil
lvl=nil
score=0
hiscore=0

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

function timestr(time_in_sec)
 if time_in_sec<0 then
  return "0:00"
 end
 local mn=flr(time_in_sec/60)
 local sc="0"..flr(time_in_sec-60*mn)
 return ""..mn..":"..sub(sc,#sc-1)
end

-- multiple pal() map changes
function multipal(palmap)
 for v in all(palmap) do
  pal(shr(v,4),band(v,15))
 end
end

function smooth_clamp(h)
 local hn=h/12
 local f=hn/sqrt(hn*hn+1)
 return f*12
end

function sprite_address(idx)
 local c=idx%16
 return c*4+(idx-c)*32
end

function message_box(msgs)
 local maxlen=0
 foreach(
  msgs,
  function(msg)
   maxlen=max(#msg,maxlen)
  end
 )

 local y=63-#msgs*3
 rectfill(
  63-maxlen*2,y,
  63+maxlen*2,y+#msgs*6,0
 )

 for msg in all(msgs) do
  print(
   msg,64-#msg*2,y+1,10
  )
  y+=6
 end
end

function center_print(
 msg,y,col
)
 print(
  msg,64-#msg*2,y,col
 )
end

function print_await_key(action)
 center_print(
  "press Ž to "..action,120,10
 )
end

function draw_3d_title()
 for i=0,25 do
  for j=23,0,-1 do
   --read pixels of sprite 6
   if band(
    shr(
     --5145=sprite_address(166)+1
     peek(5145+i/2+j*64),4*(i%2)
    ),
    15
   )==7 then
    spr(198,22+i*4,20+j*2+i*2)
   end
  end
 end
end

function mainscreen_draw()
 cls()

 -- draw bots
 pal(15,5)
 spr(160,0,52,6,6)
 multipal({206,29,210,86,101})
 spr(160,80,8,6,6,true)
 pal()

 draw_3d_title()

 print("eriban presents",33,0,4)
 print("wip",116,100,4)
 print(version,116,106,4)

 print_await_key("start")
end

function mainscreen_update()
 if btnp(4) then
  show_levelmenu()
 end
end

function show_mainscreen()
 _update=mainscreen_update
 _draw=mainscreen_draw
 menuitem(1)
end

function show_levelmenu()
 local levelmenu=new_levelmenu()
 _update=levelmenu.update
 _draw=levelmenu.draw
end

function start_game(start_level)
 game=new_game(start_level)
 _update=game.update
 _draw=game.draw
end

map_unit={}

function map_unit:new(_mapmodel,o)
 o=o or {}
 o=setmetatable(o,self)
 self.__index=self

 o.mapmodel=_mapmodel
 o:settype(o.tiletype or 0)

 o.height=0
 o.movers={}

 return o
end

function map_unit:settype(tiletype)
 self.tiletype=tiletype

 local props=
  tiletypes[flr(tiletype/8)]
 self.sprite_index=props[1]
 self.sprite_height=props[2]
 self.sprite_ydelta=props[3]
 self.sprite_repeat=props[4]
 self.colmap_idx=props[5]
 self.height0=
  props[6]+2*(tiletype%8)
 self.flex=props[7]
end

function map_unit:setwave(wave)
 self.prev_height=self.height
 self.height=
  self.height0+
  self.flex*wave
end

-- adds the mover for drawing
-- purposes. it may not yet
-- have entered the unit
function map_unit:add_mover(mover)
 if mover.draw_unit then
  mover.draw_unit:remove_mover(mover)
 end
 add(self.movers,mover)
 mover.draw_unit=self
end

function map_unit:remove_mover(mover)
 del(self.movers,mover)
end

--returns box at unit, if any
function map_unit:box()
 for k,mover in pairs(self.movers) do
  if mover.is_box then
   return mover
  end
 end
end

function map_unit:add_object(object)
 object.unit=self
 self.object=object
end

function map_unit:remove_object(object)
 if (self.object==object) then
  self.object=nil
  object.unit=nil
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
   local unit={}
   unit.col=c
   unit.row=r
   if c==o.ncol then
    if r==o.nrow then
     unit.tiletype=35*8
    else
     unit.tiletype=34*8
    end
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

 if unit.colmap_idx>0 then
  multipal(colmaps[unit.colmap_idx])
 elseif (
  unit.colmap_idx<0 and
  (unit.col+unit.row)%2==0
 ) then
  multipal(colmaps[-unit.colmap_idx])
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

 if unit.object then
  unit.object:draw(x,y)
 end

 if #unit.movers>0 then
  local movers=unit.movers
  local min_idx=1
  --find mover that is furthest
  --back. draw this one first.
  for i=2,#movers do
   if (
    movers[i].dy<
    movers[min_idx].dy
   ) then
    min_idx=i
   end
  end
  for i=1,#movers do
   movers[
    1+(i+min_idx-2)%#movers
   ]:draw(x,y)
  end
 end

 if (
  unit.object and
  unit.object.draw2
 ) then
  unit.object:draw2(x,y)
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

function mover:freeze()
 self.frozen=true
end

--true iff mover can move or
--turn during update
function mover:can_move()
 return not self.frozen
end

--true iff mover can initiate
--a new move or turn during
--update
function mover:can_start_move()
 return (
  self:can_move() and
  not self:moving() and
  not self:turning() and (
   --mover must touch ground.
   --check previous height, as
   --unit height has already
   --been updated, but mover
   --height not yet
   self.height==self.unit.prev_height
  )
 )
end

--direction that mover is facing
function mover:heading()
 return flr(self.rot/self.rot_turn)
end

function mover:set_heading(h)
 self.rot=h*self.rot_turn
end

--direction of move
function mover:move_heading()
 return (
  self:heading()+
  self.mov_dir+3
 )%4
end

function mover:update_height()
 local height=self.unit.height

 -- adapt height if needed
 if self.unit2 then
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

function mover:update_dx_dy()
 if self:moving() then
  local h=self:heading()
  self.dx=flr(
   (col_delta[h]-row_delta[h])
   *self.mov/self.mov_del+0.5
  )*self.mov_dir
  self.dy=flr(
   (col_delta[h]+row_delta[h])
   *self.mov/self.mov_del/2
  )*self.mov_dir+0.5
 else
  self.dx=0
  self.dy=0
 end

 self.dh=self.height-self.draw_unit.height
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
   self:move_heading()
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
 if self:can_move() then
  if self:turning() then
   self:turn_step()
  elseif self:moving() then
   self:move_step()
  end
 end

 self:update_height()
 self:update_dx_dy()

 if (
  self.unit.object and
  self.height==self.unit.height
 ) then
  self.unit.object:visit(self)
 end
end --mover:update()

function mover:can_enter(unit)
 return (
  unit and
  unit.height-self.unit.height<=self.tol
 )
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
 --msg="enter:"..self.unit:tostring().."-"..self.unit2:tostring()
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

bot={}
extend(bot,mover)

function bot:new(o)
 o=mover.new(self,o)
 local o=setmetatable(o,self)
 self.__index=self

 o.dazed=0

 return o
end

function bot:bump()
 self.dazed=20
end

function bot:is_dazed()
 return self.dazed>0
end

function bot:can_move()
 return (
  self.dazed==0 and
  mover.can_move(self)
 )
end

function bot:update()
 if self.dazed>0 then
  self.dazed-=1
 end

 mover.update(self)
end

function bot:draw(x,y)
 local r=flr(self.rot/self.rot_del)
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

 spr(
  128+r%10,
  x+self.dx+1,
  y+self.dy-self.dh-7,1,2
 )

 pal()
end --bot:draw()

player={}
extend(player,bot)

function player:new(o)
 o=bot.new(self,o)
 local o=setmetatable(o,self)
 self.__index=self

 o.is_player=true
 o.nxt_rot_dir=nil

 return o
end

function player:can_enter(unit)
 local box=unit:box()
 return (
  (
   not box or
   box:can_enter(
    unit:neighbour(
     self:move_heading()
    )
   )
  ) and
  mover.can_enter(self,unit)
 )
end

function player:entering_unit(to_unit)
 mover.entering_unit(self,to_unit)
 local box=to_unit:box()
 if box then
  box:set_heading(
   self:move_heading()
  )
  box.mov_dir=1
 end
end

function player:update()
 if btnp(0) then
  self.nxt_rot_dir=-1
 elseif btnp(1) then
  self.nxt_rot_dir=1
 end

 if self:can_start_move() then
  if self.nxt_rot_dir then
   self.rot_dir=self.nxt_rot_dir
   self.nxt_rot_dir=nil
  elseif btn(2) then
   self.mov_dir=1
  elseif btn(3) then
   self.mov_dir=-1
  end
 end

 local unit2=self.unit2
 bot.update(self)
 if (
  unit2 and not self.unit2
 ) then
  sfx(5)
 end

 if self.height<-50 then
  game.signal_death(
   "watch your step"
  )
 end
end --player:update

function player:update_dx_dy()
 bot.update_dx_dy(self)

 if self.drop then
  self.drop+=1
  if self.drop==20 then
   game.signal_death(
    "stuck!"
   )
  end
  self.dh-=min(5,self.drop/4)
 end
end

function player:bump()
 bot.bump(self)
 sfx(0)
end

enemy={}
extend(enemy,bot)

function enemy:new(target,o)
 o=o or {}
 o.rot_del=o.rot_del or 3
 o=bot.new(self,o)
 local o=setmetatable(o,self)
 self.__index=self
 
 o.target=target

 return o
end

function enemy:draw(x,y)
 pal(12,14)
 pal(1,2)
 bot.draw(self,x,y)
 pal()
end

function enemy:update()
 if self.unit==self.target.unit then
  game.signal_death(
   "caught!"
  )
 end

 if self:can_start_move() then
  --to turn or not to turn?
  local best_score=nil
  local best_rotdir
  for rotdir=-1,1 do
   local h=(self:heading()+rotdir+4)%4
   local s=self:heading_score(h)
   if not best_score or s>best_score then
    best_rotdir=rotdir
    best_score=s
   end
  end

  self.rot_dir=best_rotdir

  if not self:turning() then
   self.mov_dir=1
  end
 end

 bot.update(self)
end --enemy:update

function enemy:heading_score(h)
 local score=0
 local to_unit=self.unit:neighbour(h)
 local target_unit=self.target.unit

 if not to_unit or to_unit.height<-5 then
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

--true iff enemy is not expected
--to be able to move to unit
--soon
function enemy:is_blocked(unit)
 return (
  (
   unit.object and
   unit.object.is_pickup
  ) or
  self.unit.height-unit.height>10 or
  unit:box()
 )
end

function enemy:can_enter(unit)
 if (
  self:is_blocked(unit) or
  not mover.can_enter(self,unit)
 ) then
  return false
 end
 --do not move in case there's
 --another mover that is not the
 --target
 for mover in all(unit.movers) do
  if mover!=self.target then
   return false
  end
 end
 return true
end

function enemy:bump()
 bot.bump(self)
 self.dazed+=flr(rnd(20))-10
end

box={}
extend(box,mover)

function box:new(o)
 o=o or {}
 o=mover.new(self,o)
 local o=setmetatable(o,self)
 self.__index=self

 o.is_box=true

 return o
end

function box:can_enter(unit)
 return (
  --move check is done at start
  --of move. once moving, assume
  --its okay.
  self:moving() or (
   #unit.movers==0 and
   not self.dropping and
   mover.can_enter(self,unit)
  )
 )
end

function box:update_dx_dy()
 mover.update_dx_dy(self)
 if self.drop then
  self.drop+=1
  if self.drop==20 then
   self.unit.object.filled=true
   self:destroy()
  end
  self.dh-=min(5,self.drop/4)
 end
end

function box:draw(x,y)
 spr(
  156,
  x+self.dx,
  y+self.dy-self.dh-1,
  2,2
 )
end

pickup={}

function pickup:new(o)
 o=o or {}
 local o=setmetatable(o,self)
 self.__index=self

 o.is_pickup=true

 return o
end

function pickup:draw(x,y)
 spr(138,x,y,1,1)
end

function pickup:visit(mover)
 self.unit:remove_object(self)
 lvl:pickup_collected(self)
 sfx(3)
end

teleport={}

function teleport:new(
 colmap_idx,dst_pos,o
)
 o=o or {}
 local o=setmetatable(o,self)
 self.__index=self

 o.dst_pos=dst_pos
 o.colmap_idx=colmap_idx

 o:reset()

 return o
end

function teleport:reset()
 self.cooldown_cnt=0
end

function teleport:draw(x,y)
 multipal(
  colmaps[self.colmap_idx]
 )
 spr(139,x,y+1,2,1)
 if self.cooldown_cnt>0 then
  self.cooldown_cnt-=1
  spr(
   143-flr(self.cooldown_cnt/8),
   x,y,1,1
  )
 end
 pal()
end

function teleport:visit(mover)
 if mover:moving() then
  mover.teleport_block=nil
 elseif not mover.teleport_block then
  local dst_unit=
   mover.unit.mapmodel:unit_at(
    self.dst_pos
   )
  dst_unit:add_mover(mover)
  mover.unit=dst_unit
  mover.height=dst_unit.height+16
  mover.teleport_block=true
  self.cooldown_cnt=24
  sfx(7)
 end
end

gap={}

function gap:new(colmap_idx,o)
 o=o or {}
 local o=setmetatable(o,self)
 self.__index=self

 o.colmap_idx=colmap_idx

 return o
end

function gap:reset()
 self.filling=nil
 self.filled=nil
end

function gap:visit(mover)
 if (
  not self.filling and
  not mover:moving()
 ) then
  mover:freeze()
  -- initiate drop
  mover.drop=0
  self.filling=true
  sfx(9)
 end
end

function gap:draw(x,y)
 if self.filled then
  multipal({90,106})
 else
  if self.colmap_idx then
   multipal(
    colmaps[self.colmap_idx]
   )
  end
 end
 spr(154,x,y+4,2,1)
 pal()
end

--draw function called after
--drawing of movers. it re-draws
--front of tile which was drawn
--over by dropping mover
function gap:draw2(x,y)
 if self.filling then
  multipal(colmaps[self.colmap_idx])
  spr(170,x,y+4,2,1)
  pal()
 end
end

matrix_print={}

function matrix_print:new(
 address0,col
)
 local o=setmetatable({},self)
 self.__index=self

 o.address0=address0
 o.col=col or 0

 return o
end

function matrix_print:draw(x,y)
 color(self.col)

 for i=0,4 do
  for j=0,4 do
   local v=band(
    shr(
     peek(self.address0+i/2+j*64),
     4*(i%2)
    ),
    15
   )
   if v>0 then
    local x0=x+i*2-j*2+3
    local y0=y+i+j+2
    pset(x0-1,y0)
    pset(x0,y0)
    pset(x0+1,y0)
    if v==7 or v==8 then
     pset(x0,y0+1)
    end
    if v==6 or v==8 then
     pset(x0,y0-1)
    end
   end
  end
 end
end

function matrix_print:visit()
 --void
end

level={}

function level:new(o)
 o=o or {}
 local o=setmetatable(o,self)
 self.__index=self

 o.collected_pickups={}
 o.num_pickups=0

 --invoke abstract init_map()
 o.map_model=o:init_map()
 o.map_view=new_mapview(o.map_model)

 o:reset()

 return o
end

function level:init_camera(
 player_pos
)
 self.camera_pos=
  self:target_camera_pos(player_pos)
end

function level:add_mover(pos,mover)
 local unit=
  self.map_model:unit_at(pos)
 unit:add_mover(mover)
 mover.unit=unit
 add(self.movers,mover)
end

function level:add_object(pos,object)
 self.map_model:unit_at(pos):add_object(
  object
 )
 add(self.objects,object)
end

function level:reset()
 --destroy movers
 for mover in all(self.movers) do
  mover:destroy()
 end
 self.movers={}
 self.player=nil

 --reset objects
 for object in all(self.objects) do
  if object.reset then
   object:reset()
  end
 end

 if self.map_model then
  self.map_model.wave_strength_delta=1
 end

 self:set_target_camera_pos(
  5,5,true
 )
end

function level:freeze()
 for mover in all(self.movers) do
  mover:freeze()
 end
end

function level:pickup_collected(
 pickup
)
 add(
  self.collected_pickups,
  pickup
 )
 score+=10

 if (
  #self.collected_pickups==
  self.num_pickups
 ) then
  game.level_done()
 end
end

function level:update()
 self.map_model:update()

 for mover in all(self.movers) do
  mover:update()
 end
end

function level:set_target_camera_pos(
 c,r,update_pos
)
 c=max(
  5,min(
   c,self.map_model.ncol-5
  )
 )
 r=max(
  5,min(
   r,self.map_model.nrow-5
  )
 )
 self.camera_tx=(c-r)*8
 self.camera_ty=(c+r)*4-32

 if update_pos then
  self.camera_x=self.camera_tx
  self.camera_y=self.camera_ty
 end
end

function level:draw()
 if self.player then
  self:set_target_camera_pos(
   self.player.unit.col,
   self.player.unit.row    
  )
  self.camera_x=
   0.8*self.camera_x+
   0.2*self.camera_tx
  self.camera_y=
   0.8*self.camera_y+
   0.2*self.camera_ty
 end

 camera(
  flr(self.camera_x+0.5),
  flr(self.camera_y+0.5)
 )
 self.map_view.draw()
 camera()
end

leveldef={}
extend(leveldef,level)

function leveldef:new(idx,o)
 o=o or {}
 o.idx=idx

 level.new(self,o)
 local o=setmetatable(o,self)
 self.__index=self

 for object_specs in all(objects[idx]) do
  o:add_object_from_specs(
   object_specs
  )
 end

 return o
end

function leveldef:init_map()
 local map_def=map_defs[self.idx]
 local map_model=map_model:new(
  map_def[1],
  map_def[2],
  map_def[3],
  map_def[4]
 )
 add(
  map_model.functions,
  dirwave:new(
   0.10,{a=map_def[5]}
  )
 )
 self.time_left=map_def[6]*30
 self.name=map_def[7]

 return map_model
end

--create new object and add it
function leveldef:add_object_from_specs(
 specs
)
 local object_type=specs[3]
 if not object_type then
  local pickup=pickup:new()
  self:add_object(specs,pickup)
  self.num_pickups+=1
 elseif object_type<=4 then
  --teleport
  local pos2={specs[4],specs[5]}
  local tp=teleport:new(
   object_type,pos2
  )
  self:add_object(specs,tp)
  --also add its twin
  tp=teleport:new(
   object_type,specs
  )
  self:add_object(pos2,tp)
 elseif object_type==5 then
  local gap=gap:new(
   specs[4]
  )
  self:add_object(specs,gap)
 end
end

function leveldef:add_mover_from_specs(
 specs
)
 if not self.player then
  self.player=player:new()
  self:add_mover(specs,self.player)
 else
  local mover_type=specs[3]
  if not mover_type then
   local enemy=enemy:new(
    self.player
   )
   self:add_mover(specs,enemy)
  elseif mover_type==1 then
   local box=box:new()
   self:add_mover(specs,box)
  end
 end
end

function leveldef:reset()
 level.reset(self)

 self:set_target_camera_pos(
  movers[self.idx][1]
 )
end

function leveldef:start()
 for mover_specs in all(movers[self.idx]) do
  self:add_mover_from_specs(
   mover_specs
  )
 end

 self.playing=true
end

function leveldef:freeze()
 level.freeze(self)

 self.playing=false
end

function leveldef:update()
 if self.playing then
  self.time_left-=1

  if self.time_left<0 then
   game.signal_death(
    "timed out"
   )
  end
 end

 level.update(self)
end

function leveldef:draw()
 level.draw(self)

 print(
  timestr(self.time_left/30),
  56,2,
  8+min(3,flr(self.time_left/300))
 )
end

levelmenu={}
extend(levelmenu,level)

function levelmenu:new(o)
 o=level.new(self,o)
 local o=setmetatable(o,self)
 self.__index=self

 return o
end

function levelmenu:level_at(pos)
 local c=pos[1]-3
 local r=pos[2]-3
 if (
  c>=0 and
  c<=self.map_model.ncol-5 and
  r>=0 and
  r<=self.map_model.nrow-5
 ) then
  c=flr(c/2)
  r=flr(r/2)
  return 9-c-3*r
 end
end

function levelmenu:init_map()
 local map_model=map_model:new(
  0,0,8,8
 )
 self.map_model=map_model

 local a0=sprite_address(230)
 for c=2,map_model.ncol-1 do
  for r=2,map_model.nrow-1 do
   local pos={c,r}
   local unit=map_model:unit_at(
    pos
   )
   local l=self:level_at(pos)
   if l then
    if l<=#map_defs then
     unit:settype(88+(l%2)*16)
    else
     unit:settype(90+(l%2)*16)
    end

    local digit=flr(
     l/(1+9*(c%2))
    )%10
    self:add_object(
     pos,
     matrix_print:new(
      a0+digit*2+((r+1)%2)*256,
      6-(l%2)
     )
    )
   else
    unit:settype(114)
   end
  end
 end

 return map_model
end

function levelmenu:start()
 self.player=player:new()
 self:add_mover(
  {8,8},
  self.player
 )
end

function new_levelmenu()
 local me={}

 function level_idx()
  local unit=lvl.player.unit
  return lvl:level_at(
   {unit.col,unit.row}
  )
 end

 function me.draw()
  lvl:draw()

  rectfill(20,7,108,22,1)

  local idx=level_idx()
  local name=map_defs[idx][7]
  center_print(
   "destination:",9,12
  )
  center_print(name,16,7)

  print_await_key("start")
 end

 function me.update()
  clock+=1
  lvl:update()

  if btnp(4) then
   start_game(level_idx()-1)
  end
 end

 lvl=levelmenu:new()
 lvl:start()
 lvl:update()

 return me
end

function new_game(level_num)
 local me={}

 local anim=nil
 local level_num=level_num or 0
 local lives=3
 local death_cause

 score=0

 function me.draw()
  lvl:draw()
  for i=1,lives do
   spr(132,i*10-8,-6,1,2)
  end

  local s
  if score>=max(1,hiscore) then
   s="hs: "..score
  else
   s="s: "..score
  end
  print(s,128-4*#s,2,6)

  if anim then
   anim.draw()
  end

  if msg then
   print(msg,0,120,11)
  end
 end

 function me.update()
  clock+=1

  if anim then
   anim=anim.update()
  end

  death_cause=nil

  lvl:update()

  if not anim then
   if death_cause then
    me.handle_death()
   end
  end
 end

 function me.reset()
  if lvl.time_left<=0 then
   --hard reset on time-out:
   --reset all pick-ups
   lvl=leveldef:new(
    level_num
   )
  end
  lvl:reset()
 end

 function me.signal_death(cause)
  death_cause=cause
 end

 function me.handle_death()
  lives-=1
  anim=die_animation(death_cause)
 end

 function me.game_over()
  return lives==0
 end

 function me.level_done()
  anim=level_done_animation()
 end

 function me.next_level()
  level_num+=1
  if level_num<=#map_defs then
   lvl=leveldef:new(level_num)
   return true
  end
 end

 menuitem(
  1,"restart",show_mainscreen
 )
 me.next_level()
 anim=level_start_animation()

 return me
end --new_game()

function die_animation(cause)
 local me={}
 local msg={cause}

 local clk=0

 function me.update()
  clk+=1

  if clk==1 then
   sfx(1)
  end

  if clk==100 then
   if game.game_over() then
    return game_done_animation()
   else
    game.reset()
    return level_start_animation()
   end
  end

  return me
 end

 function me.draw()
  message_box(msg)
 end

 lvl.map_model.wave_strength_delta=-1
 lvl:freeze()

 return me
end --die_animation

function level_start_animation()
 local me={}

 local clk=0
 local msg={
  "level "..lvl.idx,
  lvl.name
 }

 function me.update()
  clk+=1

  if clk==50 then
   msg={
    "ready to",
    "bumble?!"
   }
  end

  if clk==100 then
   lvl:start()
   return nil
  end

  return me
 end

 function me.draw()
  message_box(msg)
 end

 return me
end --level_start_animation


function level_done_animation()
 local me={}

 local clk=0

 function me.update()
  clk+=1

  if clk==20 then
   sfx(6)
  end

  if clk>60 then
   if lvl.time_left>0 then
    lvl.time_left-=30
    score+=1
    sfx(8)
    clk=60
   end
  end

  if clk==100 then
   if game.next_level() then
    return level_start_animation()
   else
    return game_done_animation()
   end
  end

  return me
 end

 function me.draw()
  if clk>=20 then
   message_box({
    "level done",
    "bumble on!"
   })
  end
 end

 local pu=lvl.player.unit
 add(
  lvl.map_model.functions,
  shock_wave:new(pu.col,pu.row)
 )
 lvl:freeze()

 return me
end --level_done_animation

function game_done_animation()
 local me={}

 local clk=0
 local msg

 function me.update()
  clk+=1

  if btnp(4) then
   show_mainscreen()
  end

  if clk==60 then
   msg={
    "score: "..score,
    "",
    "hiscore: "..hiscore
   }
  end

  return me
 end

 function me.draw()
  message_box(msg)

  if clk>100 then
   print_await_key("retry")
  end
 end

 hiscore=max(hiscore,score)
 lvl:freeze()
 if game.game_over() then
  msg={"game over"}
  sfx(2)
 else
  msg={"end of the line!"}
  sfx(4)
 end

 return me
end --game_done_animation

show_mainscreen()

--eof
__gfx__
ffffffff7fffffffffffffff7ffffffffffffffffffffffffffffff84ffffffffffffff77fffffffffffffff7fffffffffffffff7fffffffffffffff7fffffff
ffffff77777fffffffffff77777ffffffffff7777777ffffffffff8844ffffffffffff75675fffffffffff77777fffffffffff77777fffffffffff77777fffff
ffff777777777fffffff777777777ffffff77777777777fffffff888444ffffffff77655665775ffffff777777777fffffff777777777fffffff777777777fff
ff7777777777777fff7777777777777fff7777777777777fffff88884444fffff76556556656657fff7777777777777fff7777777777777fff7777777777777f
7777777777777777f777777777777777ff6777777777775ffff8888844444fff7565555996666567f777777777777777f777777777777777f777777777777777
6777777777777755f667777777777755ff5667777777550fff888888444444ff6755599999966675f667777777777755f667777777777755f667777777777755
6667777777775555f666677777775555ff6566565655655ff88888884444444f6657799999977655f666677777775555f666677777775555f666677777775555
6666677777555555f666666777555555ff6666656565555f88888888444444446656657997655655f666666777555555f666666777555555f666666777555555
6666666755555555fff66666655555ffff5666665656550f68888888444444556666656775655655f6666666655555ffff66666665555555f666666665555555
6666666655555555fffff6666555ffffff6566566565655f66688888444455556666656655655555f66666666555fffffff6666665555555f666666665555555
6666666655555555fffffff665ffffffff6666655655555f66666888445555556666666655555555f666666665ffffffffff666665555555f666666665555555
6666666655555555fffffffa94ffffffff5666666566550f66566668555550556665666655550555f666660060fffffffffff66665555555f666666665555555
6666666655555555fffffffa94ffffffff6566565655655f66566666555550556665666655550555f666500000fffffffffff66665555555f666666665555555
6666666655555555fffffffa94ffffffff6666656565555f66566666555550556665666655550555f666555500ffffffffffff6665555555f666666665555555
6666666655555555fffffffa94ffffffff5666665656550f66566666555550556665666655550555f665555550ffffffffffff6665555555f666666665555555
6666666655555555fffffffa94ffffffff6566566565655f66776666555566556667666655556555f665555555fffffffffffff665555555f666666665555555
6666666655555555fffffffa94ffffffffffffff7fffffff66667766556655556666766655565555f665555555fffffffffffff6655555558888888888888888
6666666655555555fffffffa94ffffffffffff77777fffff66666666555555556666666655555555f665555555fffffffffffff6655555558ffffff88ffffff8
6666666655555555fffffffa94ffffffffff777777777fff66666666555555556666666655555555f665555555fffffffffffff6655555558ffffff88ffffff8
6666666655555555fffffffa94ffffffff7777777777777f66666666555555556666666655555555f665555555fffffffffffff6655555558ffffff88ffffff8
6666666655555555fffffffa94fffffff77777777777777766666666555555556666666655555555f665555555fffffffffffff6655555558ffffff88ffffff8
6666666655555555fffffffa94fffffff66777777777775566666666555555556666666655555555f665555555fffffffffffff6655555558ffffff88ffffff8
6666666655555555fffffffa94fffffff66667777777555566666666555555556666666655555555f665555555fffffffffffff6655555558ffffff88ffffff8
6666666655555555fffffffa94fffffff66666677755555566666666555555556666666655555555f665555555fffffffffffff6655555558888888888888888
88888888888888888888888888888888fff66666655555ff666666665555555566666666555555558888888888888888fffffff6655555558888888888888888
8ffffff88ffffff88ffffff88ffffff8fffff6666555ffff666666665555555566666666555555558ffffff88ffffff8fffffff6655555558ffffff88ffffff8
8ffffff88ffffff88ffffff88ffffff8fffffff665ffffff666666665555555566666666555555558ffffff88ffffff8fffffff6655555558ffffff88ffffff8
8ffffff88ffffff88ffffff88ffffff8ffffffffffffffff666666665555555566666666555555558ffffff88ffffff8fffffff6655555558ffffff88ffffff8
8ffffff88ffffff88ffffff88ffffff8ffffffffffffffff666666665555555566666666555555558ffffff88ffffff8fffffff6655555558ffffff88ffffff8
8ffffff88ffffff88ffffff88ffffff8ffffffffffffffff666666665555555566666666555555558ffffff88ffffff8fffffff6655555558ffffff88ffffff8
8ffffff88ffffff88ffffff88ffffff8ffffffffffffffff666666665555555566666666555555558ffffff88ffffff8fffffff6655555558ffffff88ffffff8
88888888888888888888888888888888ffffffffffffffff666666665555555566666666555555558888888888888888fffffff6655555558888888888888888
ffffffffffffffff0fffffff88888888f77fffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffff00ffffffff000fffff8ffffff8f6677fffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000
ffff0000ffffffff00000fff8ffffff86506677fffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000
ff000000ffffffff0000000f8ffffff8650006677fffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff000000008ffffff8650b0006677fffff00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff000000008ffffff865000b3006677fff00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff000000008ffffff86503300b0006675f00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff0000000088888888650003000330065f00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff00000000ffffffff650b300b300b065f00000000000000008888888888888888888888888888888888888888000000000000000000000000
00000000ffffffff00000000ffffffff650000300030065f0000000000000000888f888f888f888fffffffffffffffffffffffff000000000000000000000000
00000000ffffffff00000000ffffffff67700003b00b065f00000000000000008f8f8f8f8f8f8f8f888f888f888f88ff888f888f000000000000000000000000
00000000ffffffff00000000fffffffff66770000b00065f0000000000000000888f888f888f888f8f8f8f8f8f8ff8ff8f8fff8f000000000000000000000000
00000000ffffffff00000000fffffffffff667700000065f00000000000000008f8f8f8f8f8fff8f888f8f8f888ff8ff888f8fff000000000000000000000000
00000000ffffffff00000000fffffffffffff6677000065f0000000000000000888f888f888f888fff8f888fff8f888fff8f888f000000000000000000000000
00000000ffffffff00000000ffffffffffff77766770065f0000000000000000ffffffffffffffffffffffffffffffffffffffff000000000000000000000000
00000000ffffffff00000000ffffffffff7777765667765f00000000000000008888888888888888888888888888888888888888000000000000000000000000
00000000ffffffff00000000ffffffff777777765778677700000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff00000000ffffffff677777777777775500000000000000008880808000000000888080000000000088808880000000000000000000000000
00000000ffffffff00000000ffffffff666777777777555500000000000000008080808000000000808080000000000080808080000000000000000000000000
00000000ffffffff00000000ffffffff666667777755555500000000000000008080888000000000808088800000000080808880000000000000000000000000
00000000ffffffff00000000fffffffff6666667555555ff00000000000000008080008000000000808080800000000080808080000000000000000000000000
00000000ffffffff00000000fffffffffff666665555ffff00000000000000008880008000000000888088800000000088808880000000000000000000000000
00000000ffffffff00000000fffffffffffff66655ffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000ffffffff00000000fffffffffffffff6ffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000
ffffffffffffffffffffffffffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000009999000000000000000000000080000000000000000000
0006500000000000000000000000000000000000000000000000000000000000000000000000000009a999900000000000000000000000000000900000000000
000000000000000000000000000000000000000000006500000000000000000000000000000000009aaa9994000000000000000000800080000909000000a000
0060560000000000000000000000000000000000005600000000000000000000000000000000000099a999940000800000000000000000000000900000000000
00506500000000000000000000000000000000000000560000000000000000000000000000000000999999440088988000000000000080000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000049999444889aaa9880000000000000000000000000000000
0000c00000000c000000000000c00000000c00000000c00000000c000000000000c00000000c0000044444400088988000000000000000000000000000000000
00ccccc000ccccc00cccccc00ccccc000ccccc0000ccccc000ccccc00cccccc00ccccc000ccccc00004444000000800000000000000000000000000000000000
cccccccc0ccccccc0cccccc0ccccccc0cccccccccccccccc0ccccccc0cccccc0ccccccc0cccccccc0005560000000000000aaa00000000000000000000888888
dccccc110dccccc10cccccc0dccccc10ddccccc1dccccc110dccccc10cccccc0dccccc10ddccccc105555666000000000aaaaaaa000000000000000000668888
dddc11110ddc11110d1d1d10ddddc110ddddc111dddc11110ddc11110d1d1d10ddddc110ddddc1115555566660000000aaaaaaaaa00000000000000000885688
8ddd111a08d1111a01d1d1d08dddd1a08ddd111a8ddd111a08d1111a01d1d1d0adddd180addd1118005556600000000099aaaaa4400000000000000088555666
d88d11110d811111081d1da0ddddda10dddd1aa1dddd1aa10da1aaa10aaaaaa0daaada10daad111100005000000000009999a444400000000000000055555666
ddd881110dd8111101d1d1d0dddda110dddaa111dddaa1110dda11110d1d1d10dddda110dddaa111000000000000000099999444400000000000000055550066
0ddd110000d111100d1d1d100dddd10000dd11100ddd110000d1111001d1d1d00dddd10000dd1110000000000000000099999444400000000000000055000000
000d000000010000000000000000d00000001000000d000000010000000000000000d00000001000000000000000000099999444400000000000000000000000
00000000000000000000c00000000000000000000000000000000070707000700000700077700000000000000000000000999440000000000000000000000000
000000000000000000ccccc000000000000000000000000000000070707000700000700077700000000000000000000000009000000000000000000000000000
0000000000000000ccccccccc0000000000000000000000000770070707707707700700070000000000000000000000000000000000000000000000090000000
00000000000000ccccccccccccc00000000000000000000000777070707777707770700070000000770000077000000000000000000000000000005549900000
000000000000ccccccccccccccccc000000000000000000000707070707777707070700077000000077707770000000000000000000000000000554494499000
0000000000cccccccccccbccccccccc0000000000000000000707070707070707070700077000000000777000000000000000000000000000055445549944900
00000000cccccccccccccfccccccccccc00000000000000000770070707000707700700070000000000000000000000000000000000000000094554494495500
000000cccccccccccccccfccccccccccccc000000000000000770070707000707700700070000000000000000000000000000000000000000049945529554400
0000cccccccccccccccccfccccccccccccccc0000000000000707077707000707070777077700000000000000000000000000000000000000094499255445500
00cccccccccccccccccccfccccccccccccccccc00000000000707007707000707070777077700000000000000000000000000000000000000049944944554400
00dccccccccccccccccccccccccccccccccccccc0000000000777000000000007770000000000000000000000000000000000000000000000094499455445500
00dddccccccccccccccccccccccccccccccccc110000000000770000000000007700000000000000000000000000000000000000000000000009944944550000
00dddddccccccccccccccccccccccccccccc11110000000000000000000000000000000000000000000000000000000000000000000000000000099455000000
00dddddddccccccccccccccccccccccccc1111110000000000000000770007000000077000000000000000000000000000000000000000000000000900000000
00dddddddddccccccccccccccccccccc111111110000000000000000777077700000777000000000000000000000000000000000000000000000000000000000
00dddddddddddccccccccccccccccc11111111110000000000000000707070707770700000000000000000000000000000000000000000000000000000000000
00dddddddddddddccccccccccccc1111111111110000000000990000707070707770700000000000000000000000000000000000000000000000000000000000
00dddddddddddddddccccccccc111111111111110000000099999900770070700700777000000000000000000000000000000000000000000000000000000000
0008dddddddddddddddccccc11111111111111110000000049999920770070700700777000000000000000000000000000000000000000000000000000000000
000888dddddddddddddddc1111111111111111100000000044492220707070700700007000000000000000000000000000000000000000000000000000000000
000888dddddddddddddddd111111111111111aa00000000004442200707070700700007000000000000000000000000000000000000000000000000000000000
000888dddddddddddddddd1111111111111aaaa00000000000040000777077700700777000000000000000000000000000000000000000000000000000000000
00cc88dddddddddddddddd11111111111aaaaaa00000000000000000770007000700770000000000000000000000000000000000000000000000000000000000
00ddccdddddddddddddddd111111111aaaaaaaac0000000000000000000000000700000000000000000000000000000000000000000000000000000000000000
00dddddddddddddddddddd1111111aaaaaaaacc10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00dddddddddddddddddddd11111aaaaaaaacc1110000000007770070077707770707077707000777077707770000000000000000000000000000000000000000
07dddddddddddddddd1ddd111aaaaaaaacc111110000000007070780070707070707070007000007070707070000000000000000000000000000000000000000
77dddddddddddddddd1aad1aaaaaaaacc11111110000000007070070000700070707070007000007070707070000000000000000000000000000000000000000
777ddddddddddddddd1aaaaaaaaaacc1111111110000000007070070007600770777077707770076077707770000000000000000000000000000000000000000
67777ddddddddddddd1aaaaaaaacc111111111117000000007070070076000070007000707070070070700070000000000000000000000000000000000000000
666777ddddddddddddcaaaaaacc11111111111177700000007070070070007070007007607070070070700070000000000000000000000000000000000000000
666665ddf000dddddddccaacc1111111111117777500000007770777077707770007076007770070077700070000000000000000000000000000000000000000
666665dfff00dddddddddcc111111111111777755500000000000000000000000000000000000000000000000000000000000000000000000000000000000000
066665ffff000ddddddddd1111111111177775555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000665fffff00ddddddddd1111111117777555555500000007770070077707770707077707000777077707770000000000000000000000000000000000000000
000000fffff000dddddddd1111111777755555555000000007070780000700070707070007000007070707070000000000000000000000000000000000000000
000000ff0fff00dddd7ddd1111177775555555500000000007070070077600770777077707770007077707770000000000000000000000000000000000000000
000000ff00ff00dddd677d1117777555555550000000000007070070070000070007000707070007070700070000000000000000000000000000000000000000
0000000ff0ff00dddd67777777755555555000000000000007770777077707770007077607770007077700070000000000000000000000000000000000000000
0000000fffff00dddd66677775555555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000ffff00000d66666555555550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000fff000000066666555555000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000f0000000006666555500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000066550000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
00000000000000000000000000000000044404440444044404440440000004440444044400440444044004440044000000000000000000000000000000000000
00000000000000000000000000000000040004040040040404040404000004040404040004000400040400400400000000000000000000000000000000000000
00000000000000000000000000000000044004400040044004440404000004440440044004440440040400400444000000000000000000000000000000000000
00000000000000000000000000000000040004040040040404040404000004000404040000040400040400400004000000000000000000000000000000000000
00000000000000000000000000000000044404040444044404040404000004000404044404400444040400400440000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e00000000000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000eeeee000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000eeeeeeeee0000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000eeeeeeeeeeeee00000000000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000eeeeeeeeeeeeeeeee000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000eeeeeeeeebeeeeeeeeeee0000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000eeeeeeeeeee5eeeeeeeeeeeee00000000
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000eeeeeeeeeeeee5eeeeeeeeeeeeeee000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000eeeeeeeeeeeeeee5eeeeeeeeeeeeeeeee0000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000eeeeeeeeeeeeeeeee5eeeeeeeeeeeeeeeeeee00
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee200
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee22200
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ddddeeeeeeeeeeeeeeeeeeeeeeeeeeeee2222200
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ddddddeeeeeeeeeeeeeeeeeeeeeeeee222222200
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ddddddddeeeeeeeeeeeeeeeeeeeee22222222200
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ddddddddddeeeeeeeeeeeeeeeee2222222222200
0000000000000000000000009900000000000000000000000000000000000000000000000000000000000000ddddddddddddeeeeeeeeeeeee222222222222200
0000000000000000000000999999000000000000000000000000000000000000000000000000000000000000ddddddddddddddeeeeeeeee22222222222222200
0000000000000000000000499999990000000000000000000000000000000000000000000000000000000000ddddddddddddddddeeeee2222222222222228000
00000000000000000000004449999999000000000000000000000000000000000000000000000000000000000ddddddddddddddddde222222222222222888000
00000000000000000000004444499999200000009900000000000000000000000000000000000000000000000aaddddddddddddddd2222222222222222888000
00000000000000000000004444444922200000999999000000000000000000000000000000000000000000000aaaaddddddddddddd2222222222222222888000
00000000000000000000004444444422990000499999200000000000000000000000000000000000000000000aaaaaaddddddddddd222222222222222288ee00
0000000000000000000000444444449999990044492220000000000000000000000000000000000000000000eaaaaaaaaddddddddd2222222222222222ee2200
0000000000000000000000444424444999992044442220009900000000000000000000000000000000000000deeaaaaaaaaddddddd2222222222222222222200
0000000000000000000000444422244449222044442220999999000000000000000000000000000000000000dddeeaaaaaaaaddddd2222222222222222222200
0000000000000000000000444422994444222044442220499999200000000000000000000000000000000000dddddeeaaaaaaaaddd222d222222222222222270
0000000000000000000000444499994444222044442220444922200000000000000000000000000000000000dddddddeeaaaaaaaad2aad222222222222222277
0000000000000000000000444449994444222044442220444422200099000000000000000000000000000000dddddddddeeaaaaaaaaaad222222222222222777
0000000000000000000000444444494444222044442220444422209999990000000000000000000000000007dddddddddddeeaaaaaaaad222222222222277775
00000000000000000000004444444424442200444422204444222049999920000000000000000000000000777ddddddddddddeeaaaaaae222222222222777555
0000000000000000000000444444442224000044442220444422204449222000000000000000000000000067777ddddddddddddeeaaee2222222000522655555
000000000000000000000044442444229900004444222044442220444422200000000000000000000000006667777ddddddddddddee222222222005552655555
00000000000000000000004444222499999900444422204444222044442220000000000000000000000000666667777ddddddddddd2222222220005555655550
0000000000000000000000444422994999992044442220444422204444229900000000000000000000000066666667777ddddddddd2222222220055555655000
000000000000000000000044449999444922204444222044442220444499999900000000000000000000000666666667777ddddddd2222222200055555000000
00000000000000000000004444499944442220444422204444222044444999992000000099000000000000000666666667777ddddd2227222200555055000000
0000000000000000000000444444494444222044442220444422204444444922200000999999000000000000000666666667777ddd2775222200550055000000
00000000000000000000000444444444442220444422994444222044444444229900994999992000000000000000066666666777777775222200550550000000
00000000000000000000000004444444442220444499994444222044444444999999994449222000000000000000000666666667777555222200555550000000
00000000000000000000000000044424442200044449994444222044444444499949994444222000000000000000000006666666655555200000555500000000
00000000000000000000000000000400040000000444494444222044444444444944494444222000000000000000000000066666655555000000055500000000
00000000000000000000000000000000000000000044444444222044442444444444444444222000000000000000000000000666655550000000005000000000
00000000000000000000000000000000000000000044444444222044442224444444444444222000000000000000000000000006655000000000000000000000
00000000000000000000c00000000000000000000004444444222044442220444444444444222000990000000000000000000000000000000000000000000000
000000000000000000ccccc000000000000000000000044444222044442220444444444444222099999900000000000000000000000000000000000000000000
0000000000000000ccccccccc0000000000000000000000444220044442220044424444444222049999999000000000000000000000000000000000000000000
00000000000000ccccccccccccc00000000000000000000004000044442220000400044444222044499999990000000000000000000000000000000000000000
000000000000ccccccccccccccccc000000000000000000000000044442220000000004444222044444999992000000099000000000000000000000000000000
0000000000cccccccccccbccccccccc0000000000000000000000044442220000000004444222044444449222000009999990000000000000000000000000000
00000000ccccccccccccc5ccccccccccc00000000000000099000004442200000000004444222044444444229900004999992000000000000000000000000000
000000ccccccccccccccc5ccccccccccccc000000000009999990000040000000000004444222044444444999999004449222000000000000000000000000000
0000ccccccccccccccccc5ccccccccccccccc0000000004999999900000000000000004444222044442444499999204444222000000000000000000000000000
00ccccccccccccccccccc5ccccccccccccccccc00000004449999999000000000000004444222044442224444922204444222000000000000000000000000000
00dccccccccccccccccccccccccccccccccccccc0000004444499999200000000000004444222044442299444422204444222000000000000000000000000000
00dddccccccccccccccccccccccccccccccccc110000004444444922200000000000004444222044449999444422204444222000000000000000000000000000
00dddddccccccccccccccccccccccccccccc11110000004444444422990000000000004444222044444999444422204444222000000000009900000000000000
00dddddddccccccccccccccccccccccccc1111110000004444444499999900000000004444222044444449444422204444222000000000999999000000000000
00dddddddddccccccccccccccccccccc111111110000004444244449999920000000000444220044444444244422004444222000000000499999990000000000
00dddddddddddccccccccccccccccc11111111110000004444222444492220000000000004000044444444222400004444222000000000444999999900000000
00dddddddddddddccccccccccccc1111111111110000004444229944442220009900990000000044442444229900004444222000000000444449999999000000
00dddddddddddddddccccccccc111111111111110000004444999944442220999999999900000044442224999999004444222000000000444444499999990000
0008dddddddddddddddccccc11111111111111110000004444499944442220499949999920000044442299499999204444222000000000444444444999992000
000888dddddddddddddddc1111111111111111100000004444444944442220444944492220000044449999444922204444222000000000444444444449222000
000888dddddddddddddddd111111111111111aa00000004444444424442200444444442299000044444999444422204444222000000000444424444444222000
000888dddddddddddddddd1111111111111aaaa00000004444444422240000444444449999990044444449444422204444222000000000444422244444222000
00cc88dddddddddddddddd11111111111aaaaaa00000004444244422990000444424444999992004444444444422204444229900000000444422990444220000
00ddccdddddddddddddddd111111111aaaaaaaac0000004444222499999900444422244449222000044444444422204444999999000000444499999904000000
00dddddddddddddddddddd1111111aaaaaaaacc10000004444229949999920444422204444222000000444244422004444499999990000444449999920000000
00dddddddddddddddddddd11111aaaaaaaacc1110000004444999944492220444422204444222000000004000400004444444999999900444444492220000000
07dddddddddddddddd1ddd111aaaaaaaacc111110000004444499944442220444422204444222000990000000000000444444449999920444444442220000000
77dddddddddddddddd1aad1aaaaaaaacc11111110000004444444944442220444422204444222099999900000000000004444444492220444444442220000000
777ddddddddddddddd1aaaaaaaaaacc1111111110000000444444444442220444422204444222049999999000000000000044444442220444424442200000000
67777ddddddddddddd1aaaaaaaacc111111111117000000004444444442220444422204444222044499999990000000000000444442220444422240000000000
666777ddddddddddddcaaaaaacc11111111111177700000000044424442200444422204444222044444999999900000000000004442200444422990000000000
666665dd5000dddddddccaacc1111111111117777500000000000400040000444422204444222044444449999999000000000000040000444499999900000000
666665d55500dddddddddcc111111111111777755500000000000000000000444422994444222004444444499999200099009900000000444449999999000000
0666655555000ddddddddd1111111111177775555500000000000000000000444499994444222000044444444922209999999999000000444444499999990000
0006655555500ddddddddd1111111117777555555500000000000000000000044449994444222000004444444422204999499999990000044444444999992000
00000055555000dddddddd1111111777755555555000000000000000000000000444494444222000004444444422204449444999999900000444444449222000
00000055055500dddd7ddd1111177775555555500000000000000000000000000044444444222000004444244422004444444449999920000004444444222000
00000055005500dddd677d1117777555555550000000000000000000000000000044444444222000004444222400004444444444492220000000044444222000
00000005505500dddd67777777755555555000000000000000000000000000000004442444220000004444222000004444244444442220000000000444220000
00000005555500dddd66677775555555500000000000000000000000000000000000040004000000004444222000004444222444442220000000000004000000
00000000555500000d66666555555550000000000000000000000000000000000000000000000000004444222000004444229904442200000000000000000000
00000000555000000066666555555000000000000000000000000000000000000000000000000000004444222000004444999999040000000000000000000000
00000000050000000006666555500000000000000000000000000000000000000000000000000000004444222000004444499999990000000000000000000000
00000000000000000000066550000000000000000000000000000000000000000000000000000000004444222000004444444999999900000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000004444222000000444444449999920000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000004444222000000004444444492220000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000004444222000000099044444442220000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000004444222000009999990444442220000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000444220000004999999944442220000000404044404440
00000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000004449999944442220000000404004004040
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004444499944442220000000404004004440
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004444444944442220000000444004004000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000444444444442220000000444044404000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004444444442220000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044424442200000000444000004440
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400040000000000404000000040
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000404000000440
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000404000000040
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000444004004440
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

__gff__
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__map__
00000000000000001b4b43534b43531b60606060606060600000080808080838000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000809090909090909605a5a5a5a6c5a600000080808080808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000008090a0101010a09605a5a5a5a6c5a600000080808080808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000809010101010109606c5a5a5a5a5a600000080808080808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000809010101010109605a5a5a5a6c5a600808081808080808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000809010101010109605a5a5a5a6c5a600808080808080808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000008090a0101010a09605a6c6c5a5a5a600808080808080808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000909090909090960606060606060600808080808080808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2f2625232e2423225c5c5c5b5a5a5a5a08080808080808080808080808080808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22232422252323225c5c5c5c5a5a5a5a08080808080808080808080808080808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
24252523252223215c5c5c5c5a5a5a5a08080808080808080808080808080808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
25222422242322215b5c5c5c5a595a5908080808080808080808080808080808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2e222422212121215a5a5a5a5858585808080808080808080808080808080808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
23222423212020205a5a5a595858585808080808080808080808080808080808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22222222212020205a5a5a5a5858585808080808080808080808080808080808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
21232221212020205a5a5a595858585830080808080808080808080808080838000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000008080808080808080808080808080808000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000000000000000030080808080808080808080808080838000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
01080000347232b700307003472300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010100001d05000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c0000137141271111711107110f7110e7110d7110c7110c1130460313100131011210112100121001210011100111001110011100101001010010100101000f1000f1000f1000f1000e1000e1000e1000e100
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

