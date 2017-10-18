pico-8 cartridge // http://www.pico-8.com
version 10
__lua__
-- bumble bots
-- (c) 2017, erwin bonsma

version="0.6"

col_delta={1,0,-1}
row_delta={0,1,0}
col_delta[0]=0
row_delta[0]=-1

--map_def: {x0,y0,w,h,wave_amp,
--          time}
--objects: {[object]}
--  object={c,r[,type,...]}
--  - teleport={c,r,1-5,c2,r2}
--  - gap={c,r,6[,col]}
--movers: {player,[mover]*}
--  mover={c,r[,type,...]}
--  - box={c,r,1-2}

level_defs={
 {
  name="going down",
  map_def={24,16,8,8,0,60},
  objects={
   {9,2},{4,3},{9,4},{2,9},
   {9,6},{4,7},{9,8},{4,9},
   {2,2},{2,4},{4,5},{2,5},
   {2,7}
  },
  movers={{3,3}}
 },{
  name="ride the waves",
  packed="map_def={0,0,8,8,1,120},objects={{2,2},{9,2},{2,9},{9,9}},movers={{4,7},{8,3}}"
 },{
  name="barsaman",
  packed="map_def={0,8,8,8,1.5,120},objects={{2,2},{6,2},{2,6}},movers={{9,9},{9,2},{2,9}}"
 },{
  name="gutter and stage",
  packed="map_def={8,0,8,8,1,180},objects={{2,2},{9,2},{2,9},{4,4},{8,4},{4,8},{8,8}},movers={{5,9},{5,2},{5,3}}"
 },{
  name="telerium",
  packed="map_def={8,8,8,8,1,120},objects={{5,2},{2,5},{7,5},{5,7},{9,5},{5,9},{2,2,1,6,5},{9,2,2,6,6},{2,9,3,5,5},{9,9,4,5,6}},movers={{7,7},{3,3}}"
 },{
  name="the race",
  packed="map_def={0,0,8,8,1,-35},objects={{2,2},{9,2},{2,9},{9,9},{5,3},{8,5},{6,8},{3,6}},movers={{5,5}}"
 },{
  name="mind the gap",
  packed="map_def={16,0,8,8,1,120},objects={{3,3},{8,3},{3,8},{8,8},{3,4,6},{4,3,6},{4,4,6},{5,3,6}},movers={{6,6},{2,2},{4,6,1},{4,7,1},{6,5,1},{8,5,1}}"
 },{
  name="beam me up",
  packed="map_def={16,8,7,5,1,120},objects={{2,2},{2,3,1,8,2},{4,3,2,6,4},{6,3,3,4,4},{6,2,4,8,3},{4,2,6,1}},movers={{5,6},{5,5,1}}"
 },{
  name="tea party",
  packed="map_def={24,8,8,8,1,-240},objects={{9,2},{9,3,6,10},{9,4,6,10},{8,4,6,10},{9,7,1,9,9}},movers={{2,9},{2,2},{3,2},{2,8,1},{3,8,1},{4,8,1},{5,8,1},{6,8,1},{7,8,1},{8,8,1},{9,8,1}}"
 },{
  name="besieged",
  packed="map_def={24,0,8,8,1,-180},objects={{2,9},{7,9},{3,9,6},{4,9,6},{5,9,6},{6,9,6}},movers={{4,3},{8,7},{9,7},{8,8},{9,8},{8,9},{9,9},{2,5,1},{3,5,1},{4,5,1},{5,5,1},{6,5,1},{7,5,1},{7,4,1},{7,3,1},{7,2,1}}"
 },{
  name="down the river",
  packed="map_def={0,16,8,8,1,-180},objects={{3,2},{9,5},{2,5},{4,6},{6,6},{8,6},{4,8},{6,8},{8,8},{8,2,1,9,2},{2,2,3,2,3},{9,7,4,9,9},},movers={{5,3},{9,4},{3,5},{4,5},{5,5},{2,6},{4,4,1},{6,4,1}}"
 },{
  name="boxing day",
  packed="map_def={8,16,6,6,1,-120},objects={{3,2,6},{4,2,6},{7,4,6},{5,7,6}},movers={{7,2},{2,2,2},{3,4,2},{4,5,2},{6,4,2},{7,7,2},{3,5,1},{3,6,1},{5,3,1},{6,7,1}}"
 },{
  name="ic trouble",
  packed="map_def={16,16,8,8,1,-180},objects={{4,3},{8,4},{7,8},{3,7},{3,3,1,4,5},{8,3,5,6,4},{3,8,3,5,7},{8,8,4,7,6}},movers={{9,9},{2,2},{9,2},{6,2,2},{2,5,2},{9,6,2},{5,9,2}}",
 },
 --[[
 {
  name="wip",
  map_def={0,24,8,8,1,-180},
  objects={
   {3,2,6},{4,2,6},{5,2,6},
   {6,2,6},{7,2,6},{8,2,6},
   {3,9,6},{4,9,6},{5,9,6},
   {6,9,6},{7,9,6},{8,9,6},
   {2,3,6},{2,4,6},{2,5,6},
   {2,6,6},{2,7,6},{2,8,6},
   {9,3,6},{9,4,6},{9,5,6},
   {9,6,6},{9,7,6},{9,8,6},
  },
  movers={
   {7,5},
   {2,2,2},{9,2,2},{2,9,2},{9,9,2},
   {3,3,2},{6,4,2},{4,6,2},{5,7,2},
   {5,3,1},{3,5,1},{4,5,1},{5,5,1},
   {6,6,1},{3,8,1},{7,8,1},
   {8,4,1},{8,5,1},{8,6,1},{8,7,1}
  }
 },
 {
  name="test",
  map_def={8,24,8,8,1,180},
  objects={
   {9,2},
   {4,4,6},{5,4,6},
   {7,9,6}
  },
  movers={
   {9,9},{8,3},{8,4},{8,5},
   {4,5,1},{5,5,1},
   {3,2,1},{3,3,2},{3,4,1},
   {3,5,2},{3,6,2},
   {8,9,1}
  }
 }
 ]]
}

function unpack(s)
 local a={}
 local key,val,c,auto,ob
 local i=1
 local l=0
 s=s..","  auto=1
 while i<=#s do
  c=sub(s,i,i)
  if c=="{" then
   l=i
   ob=1
   while ob>0 do
    i+=1
    c=sub(s,i,i)
    if c=="}" then ob-=1
    elseif c=="{" then ob+=1 end
   end
   val=unpack(sub(s,l+1,i-1))
   if not key then
    key=auto
    auto+=1
   end
   a[key]=val
   key=false
   i+=1 --skip comma
   l=i
  elseif c=="=" then
   key=sub(s,l+1,i-1)
   l=i
  elseif c=="," and l~=i-1 then
   val=sub(s,l+1,i-1)
   local valc=sub(val,#val,#val)
   if valc>="0" and valc<="9" then
    val=val*1
    --cover for a bug in string conversion
    val=shl(shr(val,1),1)
   elseif val=="true" then
    val=true
   elseif val=="false" then
    val=false
   end
   l=i
   if not key then
    key=auto
    auto+=1
   end
   a[key]=val
   key=false
  end
  i+=1
 end
 return a
end

--[[
color maps:
 1=b&w to dark
 2=teleport, green
 3=teleport, blue
 4=teleport, pink
 5=teleport, brown
 6=white to dark-blue
 7=white to dark-green
 8=title screen bot
 9=gap filled by box
10=b&w to blue
]]
colmaps=unpack("{80,101,118},{131,155},{129,156},{141,158},{132},{113},{115},{206,29,210,86,101},{86,102},{81,109,124}")
colmaps[0]={} --default

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
tiletypes[0]=unpack("14,2,0,true,-1,0,3")

--basic, fixed
tiletypes[1]=unpack("0,3,0,true,-1,0,0")

--basic, low flexibility
tiletypes[2]=unpack("14,2,0,false,-1,0,1")

--elevator, up+down
tiletypes[3]=unpack("2,3,0,true,0,0,10")

--pillar, moving
tiletypes[4]=unpack("4,2,1,true,0,0,2")

--pillar, fixed
tiletypes[5]=unpack("4,2,1,true,0,0,0")

--tower1, fixed
tiletypes[6]=unpack("6,4,-4,true,0,20,0")

--tower2, fixed
tiletypes[7]=unpack("8,4,-1,true,0,15,0")

--bridge, middle
tiletypes[8]=unpack("36,2,0,false,0,8,0")

--bridge, top-left
tiletypes[9]=unpack("10,3,0,true,0,8,0")

--bridge, bottom-right
tiletypes[10]=unpack("12,3,0,true,0,8,0")

--basic, fixed, light
tiletypes[11]=unpack("0,3,0,true,0,0,0")

--basic, fixed, blue
tiletypes[12]=unpack("0,3,0,false,10,0,0")

--basic, fixed, dark
tiletypes[13]=unpack("0,3,0,false,1,0,0")

--grass
tiletypes[14]=unpack("67,3,0,false,0,0,0")

--tree
tiletypes[15]=unpack("69,3,5,true,0,12,0")

--castle wall
tiletypes[16]=unpack("71,3,0,true,0,20,0,0")

--x-max tree
tiletypes[17]=unpack("73,3,6,true,0,12,0")

--ic
tiletypes[18]=unpack("75,2,2,false,0,4,0")

--capacitor
tiletypes[19]=unpack("107,2,1,false,0,7,0")

--circuit board
tiletypes[20]=unpack("77,2,0,false,0,0,0")

--circuit board, col-tracks
tiletypes[21]=unpack("109,2,0,false,0,0,0")

--circuit board, row-tracks
tiletypes[22]=unpack("46,2,0,false,0,0,0")

--gap, row-dir, front
tiletypes[33]=unpack("65,3,-248,true,0,-256,0")

--gap, col-dir, front
tiletypes[34]=unpack("64,3,-248,true,0,-256,0")

--gap, back
tiletypes[35]=unpack("0,0,-248,false,0,-256,0")

--basic, fixed, blue (top-only)
tiletypes[36]=unpack("0,3,0,false,6,0,0")

--basic, fixed, green (top-only)
tiletypes[37]=unpack("0,3,0,false,7,0,0")

--global game state
clock=0
game=nil
lvl=nil
hiscore=0
score=0
maxlevel=1

--class inheritance
function extend(clz,baseclz)
 for k,v in pairs(baseclz) do
  clz[k]=v
 end
end

--manhattan city distance
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

--multiple pal() map changes
function multipal(colmap_idx)
 for v in all(colmaps[colmap_idx]
 ) do
  pal(shr(v,4),band(v,15))
 end
end

function smooth_clamp(h)
 local hn=h/12
 local f=hn/sqrt(hn*hn+1)
 return f*12
end

--note: this is a simple
--approximation that is
--incorrect for x=<-1,0].
--this is no problem where it
--is used.
function sign(x)
 return abs(x+1)-abs(x)
end

function sprite_address(idx)
 local c=idx%16
 return c*4+(idx-c)*32
end

function debug(msg)
 printh(msg,"debug.txt")
end

function new_msg_box(_msgs)
 local me={}

 local msgs=_msgs
 local cursor_idx=0

 me.append=function(
  new_msgs
 )
  --always add empty line
  add(msgs,"")
  for msg in all(new_msgs) do
   add(msgs,msg)
  end
 end

 me.draw=function()
  rect(30,38,98,90,5)
  rect(30,38,97,89,7)
  rect(31,39,97,89,6)
  rectfill(32,40,96,88,0)

  local y=41
  local rem_chars=flr(
   cursor_idx/2
  )+1
  for msg in all(msgs) do
   if rem_chars>0 then
    local l=min(#msg,rem_chars)
    print(
     sub(msg,1,l),33,y,11
    )
    rem_chars-=l
    if rem_chars==0 then
     cursor_idx+=1
     if (
      cursor_idx%2 and l<16
     ) then
      print("_",33+l*4,y,11)
     end
     l=rem_chars
    end
    y+=6
   end
  end
 end

 return me
end --new_msg_box()

function center_print(
 msg,y,col
)
 print(
  msg,64-#msg*2,y,col
 )
end

function print_await_key(action)
 center_print(
  "press � to "..action,120,10
 )
end

function draw_3d_title()
 for i=0,25 do
  for j=23,0,-1 do
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

 --draw bots
 pal(15,5)
 spr(160,0,52,6,6)
 multipal(8)
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

function endscreen_draw()
 cls()

 color(7)
 print("hiscore: "..hiscore,
  0,0)
 for i=1,#level_defs do
  local ts=dget(3+i)
  print(
   "level "..i..": "..ts..
   " => "..flr(0.5+ts/30),
   0,i*6
  )
 end

 print_await_key("continue")
end

function endscreen_update()
 if btnp(4) then
  show_mainscreen()
 end
end

function show_mainscreen()
 _update=mainscreen_update
 _draw=mainscreen_draw
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

function show_endscreen()
 _update=endscreen_update
 _draw=endscreen_draw
end

function new_cartdata_mgr()
 local me={}
 local vmajor=1
 local vminor=0

 --init
 cartdata("eriban_bumblebots")
 if (
  dget(0)==vmajor and
  dget(1)>=vminor
 ) then
  --read compatible cartdata
  hiscore=dget(2)
  maxlevel=dget(3)+1
 else
  --reset incompatible data
  for i=2,#level_defs+2 do
   dset(i,0)
  end
 end

 dset(0,vmajor)
 dset(1,vminor)

 me.level_done=function(
  level,time_spent
 )
  local old=dget(3+level)
  if old==0 or time_spent<old then
   dset(3+level,time_spent)
  end
 end

 me.game_done=function()
  dset(2,hiscore)
  --minus one so default=1
  dset(3,maxlevel-1)
 end

 return me
end

cartdata_mgr=new_cartdata_mgr()


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

--add the mover for drawing
--purposes. it may not yet
--have entered the unit
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
function map_unit:box(exclude)
 for k,mover in pairs(self.movers) do
  if (
   mover.is_box and
   mover!=exclude
  ) then
   return mover
  end
 end
end

--returns enemy at unit, if any
function map_unit:enemy(exclude)
 --iterate all movers instead of
 --movers at this unit, as the
 --latter is based on drawing
 --logic
 for k,mover in pairs(lvl.movers) do
  if (
   mover.is_enemy and
   mover.unit==self and
   mover!=exclude
  ) then
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
 o.p=o.p or 90 --period
 o.a=o.a or 1  --amplitude
 o.w=o.w or 4  --wavelength

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
 o.f=o.f or 1/30 --frequency
 o.a=o.a or 1 --amplitude
 o.w=o.w or 4 --wavelength
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
     unit.tiletype=280 --35*8
    else
     unit.tiletype=272 --34*8
    end
   elseif r==o.nrow then
    unit.tiletype=264 --33*8
   elseif c==1 or r==1 then
    unit.tiletype=280 --35*8
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
 leaf_right
)
 local o=setmetatable({},self)
 self.__index=self

 o.leafs={}
 o.leafs[true]=leaf_left
 o.leafs[false]=leaf_right

 return o
end

--if left==true returns height
--at left-end of this isoline
--part, otherwise returns
--height at right-end
function isoline_pair:height(
 left
)
 return self.leafs[left]:height(left)
end

function isoline_pair:draw()
 local leafs=self.leafs
 local left_low=
  leafs[true]:height(false)<
  leafs[false]:height(true)

 leafs[left_low]:draw()
 leafs[not left_low]:draw()
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
  multipal(unit.colmap_idx)
 elseif (
  unit.colmap_idx<0 and
  (unit.col+unit.row)%2==0
 ) then
  multipal(-unit.colmap_idx)
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
end

function make_isoline_tree(
 unit_array,
 idx_lo,
 idx_hi
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
    idx_mid
   ),
   make_isoline_tree(
    unit_array,
    idx_mid+1,
    idx_hi
   )
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

--checks if going from one
--height to the other will
--start a fall. a falling mover
--can destroy other movers.
function is_fall(h_from,h_to)
 return h_from>h_to+6
end

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

 --height tolerance
 o.tol=o.tol or 0

 --rotation speed
 o.rot_del=o.rot_del or 2
 o.rot_turn=5*o.rot_del
 o.rot_max=4*o.rot_turn

 --move speed
 o.mov_del=o.mov_del or 2
 o.mov_max=8*o.mov_del

 o.drop_speed=1
 o.height=40

 return o
end

function mover:destroy()
 self.draw_unit:remove_mover(self)
 del(lvl.movers,self)
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
  self.mov_dir+
  self.mov_inc+
  2
 )%4
end

function mover:update_height()
 local height=self.unit.height

 --adapt height if needed
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
 self.dh=self.height-self.draw_unit.height
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
   *self.mov/self.mov_del/2+0.5
  )*self.mov_dir
 else
  self.dx=0
  self.dy=0
 end
end

function mover:turn_step()
 self.rot+=self.rot_dir+self.rot_max
 self.rot%=self.rot_max
 if self.rot%(5*self.rot_del)==0 then
  --finished turn
  self.rot_dir=0
 end
end

function mover:move_step()
 self.mov+=self.mov_inc

 local relmov=(
  self.mov*self.mov_inc+
  self.mov_max
 )%self.mov_max

 if relmov==2*self.mov_del then
  --about to enter next unit
  local to_unit=self.unit:neighbour(
   self:move_heading()
  )
  if self:can_enter(to_unit) then
   --entered destination unit
   self:entering_unit(to_unit)
  else
   --cannot move, retreat
   self.mov_inc=-self.mov_inc
   self.mov+=self.mov_inc
   self:bump()
  end
 elseif relmov==4*self.mov_del then
  --halfway crossing
  self:swap_unit()
 elseif relmov==6*self.mov_del+1 then
  --exited source unit
  self:exited_unit()
 elseif relmov==0 then
  --done
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

 if (
  self.falling and
  --do not check while still on
  --two units
  not self.unit2
 ) then
  if
   self.height-
   self.unit.height<5
  then
   local destroyable=
    self.unit:box(self) or
    self.unit:enemy(self)
   if destroyable then
    --fell on box/enemy
    destroyable:destroy()
    sfx(10)
   end
   self.falling=false
  end
 end
end --mover:update()

function mover:can_enter(unit)
 return (
  unit and
  unit.height-self.unit.height<=self.tol
 )
end

function mover:entering_unit(to_unit)
 self.unit2=to_unit

 self.falling=is_fall(
  self.unit.height,
  to_unit.height
 )
 if (
  to_unit.col+to_unit.row >
  self.unit.col+self.unit.row
 ) then
  to_unit:add_mover(self)
  self.mov-=self.mov_max*sign(self.mov)
 end
end

function mover:swap_unit()
 local unit=self.unit2
 self.unit2=self.unit
 self.unit=unit
end

function mover:exited_unit()
 if (self.draw_unit!=self.unit) then
  self.unit:add_mover(self)
  self.mov-=self.mov_max*sign(self.mov)
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

 spr_dropped(
  128+r%10,
  x+self.dx,1,
  y+self.dy-self.dh,-7,
  1,2,
  self.drop
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
   --no box
   not box or
   --will drop on box
   is_fall(
    self.unit.height,
    unit.height
   ) or
   --can push box
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
  if not self.falling then
   --entering from similar
   --height, so push box
   box:push(self:move_heading())
  end
 end
end

function player:swap_unit()
 mover.swap_unit(self)
 self.swapped=true
end

function player:update()
 if btnp(0) then
  self.nxt_rot_dir=-1
 elseif btnp(1) then
  self.nxt_rot_dir=1
 end

 local desired_mov_dir=0
 if btn(2) then
  desired_mov_dir=1
 elseif btn(3) then
  desired_mov_dir=-1
 end

 if self:can_start_move() then
  if self.nxt_rot_dir then
   self.rot_dir=self.nxt_rot_dir
   self.nxt_rot_dir=nil
  else
   self.mov_dir=desired_mov_dir
  end
 elseif (
  self:moving() and
  desired_mov_dir!=0 and
  self.mov_dir*self.mov_inc!=
  desired_mov_dir
 ) then
  self.mov_inc=-self.mov_inc
  if self.swapped then
   --undo swap
   self:swap_unit()
  end
 end

 self.swapped=false
 bot.update(self)
 if self.swapped then
  sfx(5)
 end

 if self.height<-50 then
  game.signal_death(
   "watch your step"
  )
 end
end --player:update

function player:update_height()
 bot.update_height(self)

 if self.drop then
  self.drop+=1
  if self.drop==20 then
   self.dazed=50
  elseif self.drop==36 then
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
 o.bump_count=0
 o.is_enemy=true

 return o
end

function enemy:destroy()
 --clear enemy_entering flag
 if self.unit.enemy_entering then
  self.unit.enemy_entering=nil
 elseif (
  self.unit2 and
  self.unit2.enemy_entering
 ) then
  self.unit2.enemy_entering=nil
 end
 bot.destroy(self)
end

function enemy:draw(x,y)
 pal(12,14)
 pal(1,2)
 bot.draw(self,x,y)
 pal()
end

function enemy:update()
 if (
  self.unit==self.target.unit and
  not self.target.falling and
  abs(self.height-self.target.height)<6
 ) then
  game.signal_death(
   "intercepted!"
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
  if self.bump_count<=3 then
   --prefer moving straight
   score+=1
  else
   --unless that failed three
   --times in a row, to prevent
   --deadlock situations
   score-=20
  end
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
 local box=unit:box()
 return (
  (
   --objects block
   unit.object and
   --except teleports
   not unit.object.is_teleport and
   --and filled gaps
   not (
    unit.object.is_gap and
    unit.object.filled
   )
  ) or
  self.unit.height-unit.height>10 or (
   box and not box.falling
  )
 )
end

function enemy:can_enter(unit)
 if (
  self:is_blocked(unit) or
  unit.box_entering or
  unit.enemy_entering or
  not mover.can_enter(self,unit)
 ) then
  return false
 end
 --do not move in case there's
 --another enemy (box is checked
 --in is_blocked already)
 return not unit:enemy()
end

function enemy:entering_unit(to_unit)
 bot.entering_unit(self,to_unit)
 to_unit.enemy_entering=self
end

function enemy:exited_unit()
 bot.exited_unit(self)
 self.unit.enemy_entering=nil
end

function enemy:bump()
 bot.bump(self)
 self.dazed+=flr(rnd(20))-10
 self.bump_count+=1
end

function enemy:turn_step()
 mover.turn_step(self)
 self.bump_count=0
end

box={}
extend(box,mover)

function box:new(box_type,o)
 o=o or {}
 o=mover.new(self,o)
 local o=setmetatable(o,self)
 self.__index=self

 o.box_type=box_type
 o.is_box=true

 return o
end

function box:destroy()
 mover.destroy(self)
 lvl:box_destroyed(self)
end

function box:can_enter(unit)
 if self:moving() then
  --move check is done at start
  --of move. once moving, assume
  --its okay.
  return true
 end

 if (
   --cannot move over pickup
   unit.object and
   unit.object.is_pickup
  ) or
  --cannot move once dropping
  self.drop
 then
  return false
 end

 if (
   --cannot move when unit is
   --(going to be) occupied by
   --a mover
   unit.enemy_entering or
   #unit.movers>0
  ) and
  --unless will drop on it
  not is_fall(
   self.height,unit.height
  )
 then
  return false
 end

 return mover.can_enter(self,unit)
end

function box:entering_unit(to_unit)
 mover.entering_unit(self,to_unit)
 if self.force_fall then
  self.falling=true
  self.force_fall=false
 end
end

function box:push(heading)
 self:set_heading(heading)
 self.mov_dir=1
 local to_unit=self.unit:neighbour(
  heading
 )

 if is_fall(
  self.unit.height,
  to_unit.height
 ) then
  --forcing fall so that any
  --movers entering will be
  --destroyed, even if height
  --difference is smaller when
  --entering unit
  self.force_fall=true
 else
  --reserve destination to
  --prevent other movers from
  --entering this unit
  to_unit.box_entering=true
 end
end

function box:exited_unit()
 mover.exited_unit(self)
 self.unit.box_entering=nil
end

function box:update_height()
 mover.update_height(self)
 if self.height<-50 then
  self:destroy()
 end
 if self.drop then
  if self.drop<20 then
   self.drop+=1
   if (
    self.drop==20 and
    self.box_type==1
   ) then
    self.unit.object.filled=true
    self:destroy()
   end
  end
  self.dh-=min(5,self.drop/4)
 end
end

function box:draw(x,y)
 spr_dropped(
  168+2*self.box_type,
  x+self.dx,-1,
  y+self.dy-self.dh,-3,
  2,2,
  self.drop
 )
 pal()
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
 o.is_teleport=true

 o:reset()

 return o
end

function teleport:reset()
 self.cooldown_cnt=0
end

function teleport:draw(x,y)
 multipal(self.colmap_idx)
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
  mover:update_height()
  mover.teleport_block=true
  mover.falling=true
  self.cooldown_cnt=24
  sfx(7)
 end
end

--draws a sprite for a mover
--possibly dropping in a gap
function spr_dropped(
 spr_idx,x,dx,y,dy,w,h,drop
)
 if drop then
  --dropping. create partially
  --obscured sprite
  local src1=sprite_address(spr_idx)
  local src2=sprite_address(156)
  local dst=sprite_address(174)
  local j0=6-min(5,flr(drop/4))-dy
  local i0=-flr((dx+1)/2)
  for i=0,4*w-1 do
   for j=0,8*h-1 do
    local v=peek(src1+i+j*64)
    if j>=j0 and i>=i0 then
     v=band(
      v,
      peek(src2+i-i0+(j-j0)*64)
     )
    end
    poke(dst+i+j*64,v)
   end
  end

  spr(174,x+dx,y+dy,w,h)
 else
  spr(spr_idx,x+dx,y+dy,w,h)
 end
end

gap={}

function gap:new(colmap_idx,o)
 o=o or {}
 local o=setmetatable(o,self)
 self.__index=self

 o.is_gap=true
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
  multipal(9)
 else
  if self.colmap_idx then
   multipal(self.colmap_idx)
  end
 end
 spr(154,x,y+4,2,1)
 pal()
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

baselevel={}

function baselevel:new(o)
 o=o or {}
 local o=setmetatable(o,self)
 self.__index=self

 o.collected_pickups={}
 o.num_pickups=0
 o.num_boxes_to_remove=0
 o.num_boxes_removed=0
 o.objects={}

 --invoke abstract init_map()
 o.map_model=o:init_map()
 o.map_view=new_mapview(o.map_model)

 o:reset()

 return o
end

function baselevel:init_camera(
 player_pos
)
 self.camera_pos=
  self:target_camera_pos(player_pos)
end

function baselevel:add_mover(
 pos,mover
)
 local unit=
  self.map_model:unit_at(pos)
 unit:add_mover(mover)
 mover.unit=unit
 add(self.movers,mover)
end

function baselevel:add_object(
 pos,object
)
 self.map_model:unit_at(pos):add_object(
  object
 )
 add(self.objects,object)
end

function baselevel:reset()
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

function baselevel:freeze()
 for mover in all(self.movers) do
  mover:freeze()
 end
end

function baselevel:pickup_collected(
 pickup
)
 add(
  self.collected_pickups,
  pickup
 )
 score+=10

 self:checkdone()
end

function baselevel:box_destroyed(
 box
)
 if box.box_type==2 then
  self.num_boxes_removed+=1
  score+=10
  sfx(3)
 end

 self:checkdone()
end

function baselevel:checkdone()
 if (
  #self.collected_pickups==
  self.num_pickups and
  self.num_boxes_removed==
  self.num_boxes_to_remove
 ) then
  game.level_done()
 end
end

function baselevel:update()
 self.map_model:update()

 for mover in all(self.movers) do
  mover:update()
 end
end

function baselevel:set_target_camera_pos(
 c,r,update_pos
)
 local mm=self.map_model
 if mm.ncol<10 then
  c=mm.ncol/2
 else
  c=max(5,min(c,mm.ncol-5))
 end
 if mm.nrow<10 then
  r=mm.nrow/2
 else
  r=max(5,min(r,mm.nrow-5))
 end
 self.camera_tx=(c-r)*8
 self.camera_ty=(c+r)*4-40

 if update_pos then
  self.camera_x=self.camera_tx
  self.camera_y=self.camera_ty
 end
end

function baselevel:draw()
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

level={}
extend(level,baselevel)

function level:new(idx,o)
 o=o or {}
 o.idx=idx
 o.def=level_defs[idx]

 if o.def.packed then
  o.def=unpack(o.def.packed)
 end

 baselevel.new(self,o)
 local o=setmetatable(o,self)
 self.__index=self

 for object_specs in all(o.def.objects) do
  o:add_object_from_specs(
   object_specs
  )
 end

 return o
end

function level:init_map()
 local map_def=self.def.map_def
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
 self.time_initial=abs(
  map_def[6]*30
 )
 self.time_left=self.time_initial
 self.hard_reset=map_def[6]<0

 return map_model
end

--create new object and add it
function level:add_object_from_specs(
 specs
)
 local object_type=specs[3]
 if not object_type then
  local pickup=pickup:new()
  self:add_object(specs,pickup)
  self.num_pickups+=1
 elseif object_type<=5 then
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
 elseif object_type==6 then
  local gap=gap:new(
   specs[4]
  )
  self:add_object(specs,gap)
 end
end

function level:add_mover_from_specs(
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
  elseif mover_type<=2 then
   local box=box:new(mover_type)
   self:add_mover(specs,box)
   if mover_type==2 then
    self.num_boxes_to_remove+=1
   end
  end
 end
end

function level:reset()
 baselevel.reset(self)

 self:set_target_camera_pos(
  self.def.movers[1]
 )
end

function level:start()
 for mover_specs in all(self.def.movers) do
  self:add_mover_from_specs(
   mover_specs
  )
 end

 self.playing=true
end

function level:freeze()
 baselevel.freeze(self)

 self.playing=false
end

function level:update()
 if self.playing then
  self.time_left-=1

  if self.time_left<0 then
   game.signal_death(
    "timed out"
   )
  end
 end

 baselevel.update(self)
end

function level:draw()
 baselevel.draw(self)

 print(
  timestr(self.time_left/30),
  56,2,
  8+min(3,flr(abs(
   self.time_left/300
  )))
 )
end

levelmenu={}
extend(levelmenu,baselevel)

function levelmenu:new(o)
 o=baselevel.new(self,o)
 local o=setmetatable(o,self)
 self.__index=self

 return o
end

function levelmenu:level_at(pos)
 local c=pos[1]-2
 local r=pos[2]-2
 if (
  c>=0 and
  c<=self.map_model.ncol-3 and
  r>=0 and
  r<=self.map_model.nrow-3
 ) then
  c=flr(c/2)
  r=flr(r/2)
  return 16-c-4*r
 end
end

function levelmenu:init_map()
 local map_model=map_model:new(
  0,0,8,8
 )
 self.map_model=map_model

 local a0=sprite_address(112)
 for c=1,map_model.ncol do
  for r=1,map_model.nrow do
   local pos={c,r}
   local unit=map_model:unit_at(
    pos
   )
   local l=self:level_at(pos)
   if l then
    local chk=
     (flr(c/2)+flr(r/2))%2
    if l<=maxlevel then
     unit:settype(288+chk*8)
    else
     unit:settype(290+chk*8)
    end

    local digit=flr(
     l/(10-9*(c%2))
    )%10
    self:add_object(
     pos,
     matrix_print:new(
      a0+digit*2+(r%2)*256,
      10+chk
     )
    )
   else
    unit.height0+=512
    unit.sprite_ydelta+=512
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
  center_print(
   "destination:",9,12
  )
  local dest="unknown"
  if idx<=#level_defs then
   dest=level_defs[idx].name
  end
  center_print(dest,16,7)

  if msg then
   print(msg,0,110,7)
  end
  print_await_key("start")
 end

 function me.update()
  clock+=1
  lvl:update()

  if btnp(4) then
   local idx=level_idx()
   if idx>#level_defs then
    show_endscreen()
   else
    start_game(idx)
   end
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
 local lives=3
 local death_cause

 me.level_num=level_num
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
  if (
   --hard reset on time-out
   lvl.time_left<=0 or
   --and for specific levels
   lvl.hard_reset
  ) then
   --recreate level, resetting
   --time and all pick-ups
   lvl=level:new(
    me.level_num
   )
  end
  lvl:reset()
 end

 function me.signal_death(cause)
  death_cause=cause
 end

 function me.handle_death()
  lives-=1
  anim=die_anim(death_cause)
 end

 function me.game_over()
  return lives==0
 end

 function me.level_done()
  anim=level_done_anim()
 end

 function init_level()
  lvl=level:new(me.level_num)
 end

 function me.next_level()
  me.level_num+=1
  if me.level_num<=#level_defs then
   init_level()
   return true
  end
 end

 menuitem(
  1,"auto destruct",function()
   me.signal_death(
    "rebooting..."
   )
   me.handle_death()
  end
 )
 menuitem(
  2,"abort game",function()
   lives=0
   anim=game_done_anim()
  end
 )
 init_level()
 anim=level_start_anim()

 return me
end --new_game()

function die_anim(cause)
 local me={}

 local clk=0
 local msg_box=new_msg_box({
  cause
 })

 function me.update()
  clk+=1

  if clk==1 then
   sfx(1)
  end

  if clk==100 then
   if game.game_over() then
    return game_done_anim()
   else
    game.reset()
    return level_start_anim()
   end
  end

  return me
 end

 function me.draw()
  if clk>30 then
   msg_box.draw()
  end
 end

 lvl.map_model.wave_strength_delta=-1
 lvl:freeze()

 return me
end --die_anim

function level_start_anim()
 local me={}

 local clk=0
 local msg_box=new_msg_box({
  "level "..lvl.idx..":",
  level_defs[lvl.idx].name
 })


 function me.update()
  clk+=1

  if clk==80 then
   msg_box.append({
    "ready to bumble?"
   })
  end

  if clk==140 then
   lvl:start()
   return nil
  end

  return me
 end

 function me.draw()
  msg_box.draw()
 end

 return me
end --level_start_anim


function level_done_anim()
 local me={}

 local clk=0
 local msg_box=new_msg_box({
  "level done"
 })

 function me.update()
  clk+=1

  if clk==20 then
   sfx(6)
  end

  if clk==60 then
   if lvl.time_left>0 then
    lvl.time_left-=30
    score+=1
    sfx(8)
    clk=59
   end
  end

  if clk==60 then
   msg_box.append({"bumble on!"})
  end

  if clk==120 then
   if game.next_level() then
    return level_start_anim()
   else
    return game_done_anim()
   end
  end

  return me
 end

 function me.draw()
  if clk>=20 then
   msg_box.draw()
  end
 end

 local pu=lvl.player.unit
 add(
  lvl.map_model.functions,
  shock_wave:new(pu.col,pu.row)
 )
 lvl:freeze()

 cartdata_mgr.level_done(
  game.level_num,
  lvl.time_initial-lvl.time_left
 )

 return me
end --level_done_anim

function game_done_anim()
 local me={}

 local clk=0
 local msg

 if game.game_over() then
  msg="game over"
  sfx(2)
 else
  msg="end of the line!"
  sfx(4)
 end

 local msg_box=new_msg_box({msg})

 function next()
  if game.game_over() then
   show_mainscreen()
  else
   show_endscreen()
  end
 end

 function me.update()
  clk+=1

  if btnp(4) then
   next()
  end

  if clk==60 then
   msg_box.append({
    "score: "..score,
    "hiscore: "..hiscore
   })
  end

  return me
 end

 function me.draw()
  msg_box.draw()

  if clk>180 then
   next()
  end
 end

 hiscore=max(hiscore,score)
 maxlevel=max(maxlevel,game.level_num)
 cartdata_mgr.game_done()

 lvl:freeze()

 menuitem(1)
 menuitem(2)

 return me
end --game_done_anim

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
6666666655555555fffffffa94ffffffffffffff7fffffff66667766556655556666766655565555f665555555fffffffffffff665555555ffffffff3fffffff
6666666655555555fffffffa94ffffffffffff77777fffff66666666555555556666666655555555f665555555fffffffffffff665555555ffffffbb333fffff
6666666655555555fffffffa94ffffffffff777777777fff66666666555555556666666655555555f665555555fffffffffffff665555555ffff3333bb333fff
6666666655555555fffffffa94ffffffff7777777777777f66666666555555556666666655555555f665555555fffffffffffff665555555ffbb333333bb333f
6666666655555555fffffffa94fffffff77777777777777766666666555555556666666655555555f665555555fffffffffffff6655555553333bb333333bb33
6666666655555555fffffffa94fffffff66777777777775566666666555555556666666655555555f665555555fffffffffffff665555555633333bb333333dd
6666666655555555fffffffa94fffffff66667777777555566666666555555556666666655555555f665555555fffffffffffff665555555f6633333bb33ddff
6666666655555555fffffffa94fffffff66666677755555566666666555555556666666655555555f665555555fffffffffffff665555555fff6633333ddffff
88888888888888888888888888888888fff66666655555ff6666666655555555666666665555555588888888888888888888888888888888fffff663ddffffff
8ffffff88ffffff88ffffff88ffffff8fffff6666555ffff666666665555555566666666555555558ffffff88ffffff88ffffff88ffffff8fffffff6ffffffff
8ffffff88ffffff88ffffff88ffffff8fffffff665ffffff666666665555555566666666555555558ffffff88ffffff88ffffff88ffffff8ffffffffffffffff
8ffffff88ffffff88ffffff88ffffff8ffffffffffffffff666666665555555566666666555555558ffffff88ffffff88ffffff88ffffff8ffffffffffffffff
8ffffff88ffffff88ffffff88ffffff8ffffffffffffffff666666665555555566666666555555558ffffff88ffffff88ffffff88ffffff8ffffffffffffffff
8ffffff88ffffff88ffffff88ffffff8ffffffffffffffff666666665555555566666666555555558ffffff88ffffff88ffffff88ffffff8ffffffffffffffff
8ffffff88ffffff88ffffff88ffffff8ffffffffffffffff666666665555555566666666555555558ffffff88ffffff88ffffff88ffffff8ffffffffffffffff
88888888888888888888888888888888ffffffffffffffff6666666655555555666666665555555588888888888888888888888888888888ffffffffffffffff
ffffffffffffffff0fffffffffffffffbfffffffffffff3333ffffffffffffff8ffffffffffffff3fffffffffffffff55fffffffffffffff3fffffff88888888
ffffff00ffffffff000fffffffffffbbbbbffffffffff3bb333fffffffffff89988ffffffffffff3fffffffffffff555555fffffffffff33333fffff8ffffff8
ffff0000ffffffff00000fffffffbbbb3bbbbfffffff3b9bb833ffffffff899889988fffffffff333ffffffffff5555555555fffffff333333333fff8ffffff8
ff000000ffffffff0000000fffbbbbbbbbbbbbbfffff38bb3333ffffff8998899889988fffffff3a3ffffffff5555555555555ffff3333333333333f8ffffff8
00000000ffffffff00000000bbbbb3bbbb3bb3bbffff33338343fffff998899889988998fffff33333fffffff0555555555550ff33333333333333338ffffff8
00000000ffffffff000000004b3bbbbbbbbbbb44fffff383333fffff6779988998899877fffff3a333fffffffa0055555550093f63333333333333dd8ffffff8
00000000ffffffff00000000444bbbbbb3bb4455ffffff3333ffffff6667799889987755ffff3333a33fffff3a3a005550093933f66333333333ddff8ffffff8
00000000ffffffff0000000044444bbbbb445544fffffff44fffffff6666677998775555ffff3333333fffff633a3a00093933ddfff6633333ddffff88888888
00000000ffffffff000000004444444b44554455ffffff444bbfffff6656666777555505fff33a3333a37ffff6633a393933ddfffffff663ddffffff88888888
00000000ffffffff000000004444444455445544ffffbbb44b3bbfff6656666655555505ff733333a333677ffff6633933ddfffffffffff6ffffffff8ffffff8
00000000ffffffff000000004444444444554455ffbb3bb44bbbbbbf66566666555555057777733333667777fffff663ddffffffffffffffffffffff8ffffff8
00000000ffffffff000000004444444455445544bbbbbbb44bbbb3bb66566666555555056777776466677755fffffffdffffffffffffffffffffffff8ffffff8
00000000ffffffff0000000044444444445544554b3bbb8bbb3bbb4466566666555555056667777777775555ffffffffffffffffffffffffffffffff8ffffff8
00000000ffffffff000000004444444455445544444bbbbb3bbb445566766666555555656666677777555555ffffffffffffffffffffffffffffffff8ffffff8
00000000ffffffff00000000444444444455445544444bbbbb44554466677666555566556666666755555555ffffffffffffffffffffffffffffffff8ffffff8
00000000ffffffff0000000044444444554455444444444b4455445566666766555655556666666655555555ffffffffffffffffffffffffffffffff88888888
00000000ffffffff000000004444444444554455444444445544554466666666555555556666666655555555ffffff11122fffffffffffff3fffffff88888888
00000000ffffffff000000004444444455445544444444444455445566666666555555556666666655555555ffff117777722fffffffff33bb3fffff8ffffff8
00000000ffffffff000000004444444444554455444444445544554466666666555555556666666655555555fff17777777772ffffff33bb333bbfff8ffffff8
00000000ffffffff000000004444444455445544444444444455445566666666555555556666666655555555ff2777777777771fff33bb333bb333bf8ffffff8
00000000ffffffff000000004444444444554455444444445544554466666666555555556666666655555555ff2277777777711f33bb333bb333bb338ffffff8
00000000ffffffff000000004444444455445544444444444455445566666666555555556666666655555555ff2222777771111f6b333bb333bb33dd8ffffff8
00000000ffffffff000000004444444444554455444444445544554466666666555555556666666655555555ff2222221111111ff66bb333bb33ddff8ffffff8
00000000ffffffff000000004444444455445544444444444455445566666666555555556666666655555555ff2222222111111ffff663bb33ddffff88888888
0000000000000000000000000000000000000000088888888888888888888888888888880000000000000000ff2222221111111ffffff663ddffffff88888888
00000000000000000000000000000000000000000ffffff88ffffff88ffffff88ffffff88880880088808880ff322222211111bffffffff6ffffffff8ffffff8
07770070077707770707077707000777077707770ffffff88ffffff88ffffff88ffffff8008008000080008033bb222211111b33ffffffffffffffff8ffffff8
07070780000700070707070007000007070707070ffffff88ffffff88ffffff88ffffff888000800880088006b333922211933ddffffffffffffffff8ffffff8
07070070077600770777077707770007077707770ffffff88ffffff88ffffff88ffffff88000080080008000f66bb333bb33ddffffffffffffffffff8ffffff8
07070070070000070007000707070007070700070ffffff88ffffff88ffffff88ffffff88880888088808880fff663bb33ddffffffffffffffffffff8ffffff8
07770777077707770007077607770007077700070ffffff88ffffff88ffffff88ffffff80000000000000000fffff663ddffffffffffffffffffffff8ffffff8
0000000000000000000000000000000000000000088888888888888888888888888888880000000000000000fffffff6ffffffffffffffffffffffff88888888
00000000000000000000000000000000000000000000000000000000000000000000000000000000009999000000000000000000000080000000000000000000
0006500000000000000000000000000000000000000000000000000000000000000000000000000009a999900000000000000000000000000000900000000000
000000000000000000000000000000000000000000006500000000000000000000000000000000009aaa9994000000000000000000800080000909000000a000
0060560000000000000000000000000000000000005600000000000000000000000000000000000099a999940000800000000000000000000000900000000000
00506500000000000000000000000000000000000000560000000000000000000000000000000000999999440088988000000000000080000000000000000000
0000000000000000000000000000000000000000000000000000000000000000000000000000000049999444889aaa9880000000000000000000000000000000
0000c00000000c000000000000c00000000c00000000c00000000c000000000000c00000000c0000044444400088988000000000000000000000000000000000
00ccccc000ccccc00cccccc00ccccc000ccccc0000ccccc000ccccc00cccccc00ccccc000ccccc00004444000000800000000000000000000000000000000000
cccccccc0ccccccc0cccccc0ccccccc0cccccccccccccccc0ccccccc0cccccc0ccccccc0cccccccc00055600000000000fffffffff00000000dddd0000666600
dccccc110dccccc10cccccc0dccccc10ddccccc1dccccc110dccccc10cccccc0dccccc10ddccccc10555566600000000000fffff000000000d6dddd006766660
dddc11110ddc11110d1d1d10ddddc110ddddc111dddc11110ddc11110d1d1d10ddddc110ddddc111555556666000000000000f0000000000d666ddd167776665
8ddd111a08d1111a01d1d1d08dddd1a08ddd111a8ddd111a08d1111a01d1d1d0adddd180addd111800555660000000000000000000000000dd6dddd166766665
d88d11110d811111081d1da0ddddda10dddd1aa1dddd1aa10da1aaa10aaaaaa0daaada10daad111100005000000000000000000000000000dddddd1166666655
ddd881110dd8111101d1d1d0dddda110dddaa111dddaa1110dda11110d1d1d10dddda110dddaa111000000000000000000000000000000001dddd11156666555
0ddd110000d111100d1d1d100dddd10000dd11100ddd110000d1111001d1d1d00dddd10000dd1110000000000000000000000000000000000111111005555550
000d000000010000000000000000d00000001000000d000000010000000000000000d00000001000000000000000000000000000000000000011110000555500
00000000000000000000c00000000000000000000000000000000070707000700000700077700000000000000000000000000000000000008888888888888888
000000000000000000ccccc00000000000000000000000000000007070700070000070007770000000000000000000000000aaa0000000008088808000800088
0000000000000000ccccccccc0000000000000000000000000770070707707707700700070000000000066600000000000aaaaaaa00000008088808080808088
00000000000000ccccccccccccc0000000000000000000000077707070777770777070007000000000666666600000000aaaaaaaaa0000008080808080800088
000000000000ccccccccccccccccc0000000000000000000007070707077777070707000770000000666666666000000099aaaaa440000008080808080800888
0000000000cccccccccccbccccccccc00000000000000000007070707070707070707000770000000dd666661100000009999a44440000008800088000808088
00000000cccccccccccccfccccccccccc000000000000000007700707070007077007000700000000dddd6111100000009999944440000008888888888888888
000000cccccccccccccccfccccccccccccc0000000000000007700707070007077007000700000000ddddd111100000009999944440000008888888888888888
0000cccccccccccccccccfccccccccccccccc00000000000007070777070007070707770777000000ddddd111100000009999944440000008088080808088888
00cccccccccccccccccccfccccccccccccccccc000000000007070077070007070707770777000000ddddd111100000009999944440000008080880808088888
00dccccccccccccccccccccccccccccccccccccc0000000000777000000000007770000000000000000ddd110000000000099944000000008008880808088888
00dddccccccccccccccccccccccccccccccccc11000000000077000000000000770000000000000000000d000000000000000900000000008080888888888888
00dddddccccccccccccccccccccccccccccc11110000000000000000000000000000000000000000000000000000000000000000000000008088080808088888
00dddddddccccccccccccccccccccccccc1111110000000000000000770007000000077000000000000000000000000000000000000000008888888888888888
00dddddddddccccccccccccccccccccc111111110000000000000000777077700000777000000000000000000000000000000000000000008888888888888888
00dddddddddddccccccccccccccccc11111111110000000000000000707070707770700000000000000000000000000000000000000000008888888888888888
00dddddddddddddccccccccccccc111111111111000000000099000070707070777070000000000000000000000000000000000000000000f77fffffffffffff
00dddddddddddddddccccccccc11111111111111000000009999990077007070070077700000000000000000000000000000000000000000f6677fffffffffff
0008dddddddddddddddccccc11111111111111110000000049999920770070700700777000000000000000000000000000000000000000006506677fffffffff
000888dddddddddddddddc111111111111111110000000004449222070707070070000700000000000000000000000000000000000000000650006677fffffff
000888dddddddddddddddd111111111111111aa0000000000444220070707070070000700000000000000000000000000000000000000000650b0006677fffff
000888dddddddddddddddd1111111111111aaaa000000000000400007770777007007770000000000000000000000000000000000000000065000b3006677fff
00cc88dddddddddddddddd11111111111aaaaaa00000000000000000770007000700770000000000000000000000000000000000000000006503300b0006675f
00ddccdddddddddddddddd111111111aaaaaaaac000000000000000000000000070000000000000000000000000000000000000000000000650003000330065f
00dddddddddddddddddddd1111111aaaaaaaacc1000000000000000000000000000000000000000000000000000000000000000000000000650b300b300b065f
00dddddddddddddddddddd11111aaaaaaaacc111000000000000000000000000000000000000000000000000000000000000000000000000650000300030065f
07dddddddddddddddd1ddd111aaaaaaaacc1111100000000000000000000000000000000000000000000000000000000000000000000000067700003b00b065f
77dddddddddddddddd1aad1aaaaaaaacc1111111000000000000000000000000000000000000000000000000000000000000000000000000f66770000b00065f
777ddddddddddddddd1aaaaaaaaaacc111111111000000000000000000000000000000000000000000000000000000000000000000000000fff667700000065f
67777ddddddddddddd1aaaaaaaacc11111111111700000000000000000000000000000000000000000000000000000000000000000000000fffff6677000065f
666777ddddddddddddcaaaaaacc1111111111117770000000000000000000000000000000000000000000000000000000000000000000000ffff77766770065f
666665ddf000dddddddccaacc111111111111777750000000000000000000000000000000000000000000000000000000000000000000000ff7777765667765f
666665dfff00dddddddddcc111111111111777755500000000000000000000000000000000000000000000000000000000000000000000007777777657786777
066665ffff000ddddddddd1111111111177775555500000000000000000000000000000000000000000000000000000000000000000000006777777777777755
000665fffff00ddddddddd1111111117777555555500000000000000000000000000000000000000000000000000000000000000000000006667777777775555
000000fffff000dddddddd1111111777755555555000000000000000000000000000000000000000000000000000000000000000000000006666677777555555
000000ff0fff00dddd7ddd111117777555555550000000000000000000000000000000000000000000000000000000000000000000000000f6666667555555ff
000000ff00ff00dddd677d111777755555555000000000000000000000000000000000000000000000000000000000000000000000000000fff666665555ffff
0000000ff0ff00dddd6777777775555555500000000000000000000000000000000000000000000000000000000000000000000000000000fffff66655ffffff
0000000fffff00dddd6667777555555550000000000000000000000000000000000000000000000000000000000000000000000000000000fffffff6ffffffff
00000000ffff00000d6666655555555000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffff
00000000fff00000006666655555500000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffff
000000000f000000000666655550000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffff
0000000000000000000006655000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffff
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffff
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffff
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffff
0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ffffffffffffffff
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
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000044424442200000000444000004000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000400040000000000404000004000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000404000004440
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000404000004040
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
00000000000000001b4b43534b43531b60606060606060603780808080807070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000809090909090909605a5a5a5a6c5a608080808080807070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000008090a0101010a09605a5a5a5a6c5a608080808080807070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000809010101010109606c6c5a5a5a5a608080808080807070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000809010101010109605a5a5a5a6c5a607070707070707070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000809010101010109605a5a5a5a6c5a607070707070707070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000008090a0101010a09605a6c6c5a5a5a607878787878787070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000909090909090960606060606060607070707070707070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2f2625232e2423225c5c5c5b5a5a5a5a0f0f0f0f0f0f0f706060606060606a60000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22232422252323225c5c5c5c5a5a5a5a0d0d0d0d0d0d0d706060606060606a60000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
24252523252223215c5c5c5c5a5a5a5a0b010a0a0a010b706060606060606060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
25222422242322215b5c5c5c5a595a5908080808080808706060606060606060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2e222422212121215a5a5a5a5858585808080808080808706060606060606a6a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
23222423212020205a5a5a595858585870707070707070706060606060606060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22222222212020205a5a5a5a5858585870707070707070706a6a6a6a6a6a6a6a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
21232221212020205a5a5a595858585870707070707070706a6a6a6a6a6a6a6a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
62626262626262615858585858580000a0a8a0a0a0a0a8a05f5f5f5f5f5f5f5f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
73737373737373618858585858580000a09890b090b098a05f5f5e5e5e5e5e5e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
73737373737373618858585858580000a0a8a0a0a0a090a05f5f5d5d5d5d5d5d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
61616161616161615858585888580000a090a0a0a0a0a8a05c5c5c5c5c5c5c5c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
617a727a727a727a5858585888580000a0a8a0a0a0a090a05c5b5b5b5b5b5b5b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
61727272727272725858585858580000a090a0a0a0a0a8a05c5b5a5a5a5a5a5a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
617a727a727a727a0000000000000000a098b090b09098a05c5b595959595959000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
61606060606060606000000000000000a0a8a0a0a0a0a8a05c5b585858585858000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08080808080808080e0e08080808080800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08080808080808080e0e0808080a0a0800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08080808080808080e0e08080808080800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08080808080808080e0e080808080a0800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08080808080808080e0e08080808080800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08080808080808080e0e08080a080a0800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08080808080808080e0e08080808080800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
08080808080808080e0e0e0e0e0e0e0e00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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
01140000105230e405000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
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

