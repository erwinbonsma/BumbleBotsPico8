pico-8 cartridge // http://www.pico-8.com
version 16
__lua__
-- bumble bots, action puzzle game
-- eriban
-- (c) 2017

version="1.0"

col_delta={1,0,-1}
row_delta={0,1,0}
col_delta[0]=0
row_delta[0]=-1

--map_def: {x0,y0,w,h,wave_amp,
--          time,music}
--objects: {[object]}
--  object={c,r[,type,...]}
--  - teleport={c,r,1-5,c2,r2}
--  - gap={c,r,6[,col]}
--  - obstacle={c,r,7,spr_idx[,col]}
--movers: {player,[mover]*}
--  mover={c,r[,type,...]}
--  - box={c,r,1-2}

level_defs={{
  name="going down",
  packed="map_def={24,16,8,8,0,60,38},objects={{9,2},{4,3},{9,4},{2,9},{9,6},{4,7},{9,8},{4,9},{2,2},{2,4},{4,5},{2,5},{2,7}},movers={{3,3}}"
 },{
  name="ride the waves",
  packed="map_def={0,0,8,8,1,120,0},objects={{2,2},{9,2},{2,9},{9,9}},movers={{4,7},{8,3}}"
 },{
  name="gutter and stage",
  packed="map_def={8,0,8,8,1,180,0},objects={{2,2},{9,2},{2,9},{4,4},{8,4},{4,8},{8,8}},movers={{5,9},{5,2},{5,3}}"
 },{
  name="barsaman",
  packed="map_def={0,8,8,8,1.5,120,12},objects={{2,2},{6,2},{2,6}},movers={{9,9},{9,2},{2,9}}"
 },{
  name="telerium",
  packed="map_def={8,8,8,8,1,120,0},objects={{5,2},{2,5},{7,5},{5,7},{9,5},{5,9},{2,2,1,6,5},{9,2,2,6,6},{2,9,3,5,5},{9,9,4,5,6}},movers={{7,7},{3,3}}"
 },{
  name="aquatic race",
  packed="map_def={0,0,8,8,1,-35,0},objects={{2,2},{9,2},{2,9},{9,9},{5,3},{8,5},{6,8},{3,6}},movers={{5,5}}"
 },{
  name="mind the gap",
  packed="map_def={16,0,8,8,1,-120,38},objects={{3,3},{8,3},{3,8},{8,8},{3,4,6},{4,3,6},{4,4,6},{5,3,6}},movers={{6,6},{2,2},{4,6,1},{4,7,1},{6,5,1},{8,5,1}}"
 },{
  name="going up",
  packed="map_def={16,8,7,5,1,-120,38},objects={{2,2},{2,3,1,8,2},{4,3,2,6,4},{6,3,3,4,4},{6,2,4,8,3},{4,2,6,1}},movers={{5,6},{5,5,1}}"
 },{
  name="tea party",
  packed="map_def={24,8,8,8,1,-240,50},objects={{9,2},{9,3,6,10},{9,4,6,10},{8,4,6,10},{8,6,7,111},{9,6,7,95},{8,2,7,111},{8,3,7,95}},movers={{2,9},{2,2},{3,2},{2,8,1},{3,8,1},{4,8,1},{5,8,1},{6,8,1},{7,8,1},{8,8,1}}"
 },{
  name="besieged",
  packed="map_def={24,0,8,8,1,-180,50},objects={{2,9},{7,9},{3,9,6,13},{4,9,6,13},{5,9,6,13},{6,9,6,13}},movers={{4,3},{9,6},{8,7},{9,7},{8,8},{9,8},{8,9},{9,9},{2,5,1},{3,5,1},{4,5,1},{5,5,1},{6,5,1},{7,5,1},{7,4,1},{7,3,1},{7,2,1}}"
 },{
  name="down the river",
  packed="map_def={0,16,8,8,1,-180,12},objects={{3,2},{9,5},{2,5},{4,6},{6,6},{8,6},{4,8},{6,8},{8,8},{8,2,1,9,2},{2,2,3,2,3},{9,7,4,9,9},},movers={{5,3},{9,4},{3,5},{4,5},{5,5},{2,6},{4,4,1},{6,4,1}}"
 },{
  name="boxing day",
  packed="map_def={8,16,6,6,1,-120,50},objects={{3,2,6},{4,2,6},{7,4,6},{5,7,6},{3,7,6}},movers={{6,3},{2,2,2},{3,4,2},{4,4,2},{6,4,2},{2,7,2},{7,2,2},{7,7,2},{3,5,1},{3,6,1},{5,4,1},{4,7,1},{6,7,1}}"
 },{
  name="enter the machine",
  packed="map_def={16,16,8,8,1,-180,12},objects={{4,3},{8,4},{7,8},{3,7},{3,3,1,4,5},{8,3,5,6,4},{3,8,3,5,7},{8,8,4,7,6}},movers={{9,9},{2,2},{9,2},{6,2,2},{2,5,2},{9,6,2},{5,9,2}}",
 },{
  name="seasick",
  packed="map_def={24,24,8,8,1,180,12},objects={{2,2},{9,2},{2,9},{9,9},{3,3,1,6,5},{8,3,2,6,6},{8,8,3,5,6},{3,8,4,5,5}},movers={{5,8},{4,2},{7,2},{3,2,2},{2,3,2},{8,2,2},{9,3,2},{2,8,2},{3,9,2},{9,8,2},{8,9,2}}"
 },{
  name="spring cleaning",
  packed="map_def={0,24,8,8,1,-240,50},objects={{2,8},{2,7,6,10},{2,9,6,13},{3,9,6,13},{9,5,6,13},{9,6,6,13},{9,7,6,13},{4,9,1,7,9},{5,9,3,9,9}},movers={{2,2},{9,9,1},{4,9,1},{4,7,2},{3,5,1},{2,3,2},{3,3,1},{4,3,1},{5,3,1},{6,3,2},{6,2,2}}"
 },{
  name="the final bit",
--  packed="map_def={8,24,8,8,1,-240,12},objects={{6,2,6},{9,6,6},{4,9,6}},movers={{6,6},{2,2},{3,2},{9,2},{9,3},{8,9},{9,9},{5,5,1},{5,6,1},{5,7,1},{4,5,1},{6,5,1},{2,3,2},{3,3,2},{4,3,2},{5,3,2},{8,2,2},{8,3,2},{8,4,2},{8,5,2},{5,8,2},{6,8,2},{7,8,2},{8,8,2},{9,8,2}}"
  packed="map_def={8,24,8,8,1,-240,12},objects={{6,2,6},{9,6,6},{4,9,6}},movers={{6,6},{2,2,2}}"
 }
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

function level_def(idx)
 local def=level_defs[idx]

 if not def.unpacked then
  def.unpacked=unpack(def.packed)
 end

 return def.unpacked
end

--[[
color maps:
 1=b&w to dark (gap, dark)
 2=teleport, green
 3=teleport, blue
 4=teleport, pink
 5=teleport, brown
 6=white to dark-purple
 7=white to dark-green
 8=title screen bot, pink
 9=gap filled by box
10=b&w to blue (gap)
11=end screen bot
12=title screen bot, blue
13=gap, grass/ground
14=gap, default
]]
colmaps=unpack("{80,101,118,16},{131,155},{129,156},{141,158},{132},{114},{115},{206,29,210,86,101,224},{86,102,22},{81,109,124},{245,168,138,224,209,29,86,101},{245,224},{100,20},{21}")
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
tiletypes[0]=unpack("60,2,0,true,-1,0,3")

--basic, fixed
tiletypes[1]=unpack("0,3,0,true,-1,0,0")

--basic, fixed, light
tiletypes[11]=unpack("0,3,0,true,0,0,0")

--basic, low flexibility
tiletypes[2]=unpack("172,2,0,false,-1,0,1")

--elevator, up+down
tiletypes[3]=unpack("2,3,0,true,0,0,10")

--pillar, moving
tiletypes[4]=unpack("58,2,1,true,0,0,2")

--pillar, fixed
tiletypes[5]=unpack("58,2,1,true,0,0,0")

--bridge, middle
tiletypes[8]=unpack("62,2,0,false,0,8,0")

--bridge, top-left
tiletypes[9]=unpack("10,3,0,true,0,8,0")

--bridge, bottom-right
tiletypes[10]=unpack("12,3,0,true,0,8,0")

--basic, fixed, blue
tiletypes[12]=unpack("0,3,0,false,10,0,0")

--basic, fixed, dark
tiletypes[13]=unpack("0,3,0,false,1,0,0")

--grass
tiletypes[14]=unpack("83,3,0,false,0,0,0")

--tree
tiletypes[15]=unpack("85,3,5,true,0,12,0")

--castle wall
tiletypes[16]=unpack("87,3,0,true,0,20,0,0")

--x-max tree
tiletypes[17]=unpack("89,3,6,true,0,12,0")

--ic
tiletypes[18]=unpack("48,2,2,false,0,4,0")

--capacitor
tiletypes[19]=unpack("52,2,1,false,0,7,0")

--circuit board
tiletypes[20]=unpack("50,2,0,false,0,0,0")

--circuit board, col-tracks
tiletypes[21]=unpack("54,2,0,false,0,0,0")

--circuit board, row-tracks
tiletypes[22]=unpack("56,2,0,false,0,0,0")

--low bridge
tiletypes[23]=unpack("6,3,0,true,0,4,0")

--basic, moving, blue
tiletypes[24]=unpack("0,3,0,false,10,0,3")

--warehouse floor
tiletypes[25]=unpack("8,3,0,true,0,12,0")

--cottage-1 (window)
tiletypes[26]=unpack("4,3,0,true,0,14,0,0")

--cottage-2 (door)
tiletypes[27]=unpack("14,3,0,true,0,14,0,0")

--gap, row-dir, front
tiletypes[33]=unpack("81,3,-248,true,0,-256,0")

--gap, col-dir, front
tiletypes[34]=unpack("80,3,-248,true,0,-256,0")

--gap, back
tiletypes[35]=unpack("0,0,-248,false,0,-256,0")

--basic, fixed, blue (top-only)
tiletypes[36]=unpack("0,3,0,false,6,0,0")

--basic, fixed, green (top-only)
tiletypes[37]=unpack("0,3,0,false,7,0,0")

-- len,unit,color1,color2
timebar={
 {4,1,8,2},
 {4,2,9,4},
 {8,4,10,9},
 {8,8,11,3},
 {8,16,11,3},
 {8,32,11,3}
}

--global game state
clock=0
game=nil
lvl=nil
hiscore=0
score=0

-->8
--utility functions

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

--right align a number
function lpad(val,len)
 local s=""..val
 while #s<len do
  s=" "..s
 end
 return s
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

function sign(x)
 if x==0 then
  return 0
 else
  return x>0 and 1 or -1
 end
end

function sprite_address(idx)
 local c=idx%16
 return c*4+(idx-c)*32
end

function debug(msg)
 printh(msg,"debug.txt")
end

function new_msg_box(
 _msgs,_x0,_y0,_x1,_y1
)
 local me={}

 local msgs=_msgs
 local cursor_idx=0
 local x0=_x0 or 30
 local y0=_y0 or 41
 local x1=_x1 or 98
 local y1=_y1 or 87
 local line_len=(x1-x0-4)/4

 local wrap_pos=function(msg)
  local p=#msg
  if p>line_len then
   --wrap line
   p=line_len+1
   --wrap at space if possible
   while sub(msg,p,p)!=" " and p>0 do
    p-=1
   end
   if p==0 then
    p=line_len
   end
  end
  return p
 end

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
  rectfill(x0,y0,x1,y1,0)
  rect(x0,y0,x1,y1,5)
  rect(x0,y0,x1-1,y1-1,7)
  rect(x0+1,y0+1,x1-1,y1-1,6)

  local y=y0+3
  local rem_chars=flr(
   cursor_idx/2
  )+1
  for msg in all(msgs) do
   if msg=="" then
    msg=" "
   end
   while rem_chars>0 and #msg>0 do
    local l=min(
     wrap_pos(msg),rem_chars
    )
    print(
     sub(msg,1,l),x0+3,y,11
    )
    rem_chars-=l
    if rem_chars==0 then
     cursor_idx+=1
     if (
      cursor_idx%2 and l<line_len
     ) then
      print("_",x0+3+l*4,y,11)
     end
     l=rem_chars
    else
     msg=sub(msg,l+1)
    end
    y+=6
   end
  end

  return rem_chars>0
 end

 return me
end --new_msg_box()

function pixlen(s)
 local l=0

 for i=1,#s do
  local ch=sub(s,i,i)
  if ch==" " or ch=="i" then
   l+=2
  elseif ch=="🅾️" then
   l+=8
  else
   l+=4
  end
 end

 return l
end

function center_print(
 msg,y,col
)
 local w=pixlen(msg)
 local x=32-w/2

 for i=1,#msg do
  local ch=sub(msg,i,i)
  if ch=="i" then
   line(x,y,x,y+4,col)
  else
   print(
    ch,x,y,col
   )
  end
  x+=pixlen(ch)
 end
 
 return w
end

function print_2d(
 msg,x,y,col1,col2
)
 print(msg,x+1,y-1,col1)
 print(msg,x,y,col2)
end

function print_await_key(
 action,key_hint
)
 local key="🅾️"
 if key_hint then
  key="z"
 end
 local s="press "..key.." to "..action
 center_print(s,56,10)
end

-->8
-- game functions

function draw_timebar(time_in_sec)
 local t=time_in_sec
 local i=1
 local x=62
 while (t>0) do
  local tb=timebar[i]
  local l=min(tb[1],t/tb[2])-1
  rectfill(x-l,1,x,2,tb[3])
  line(x-l,3,x,3,tb[4])
  t-=tb[2]*tb[1]
  x-=tb[1]
  i+=1
 end
end

function mainscreen_draw()
 cls()

 spr(228,12,12,5,2)
 spr(233,16,21,4,2)

 if clock<30 then
  center_print("v"..version..", (c) 2017",56,1)
 else
  print_await_key("start",clock>300)
 end
end

function mainscreen_update()
 clock+=1
 if btnp(4) then
  show_levelmenu()
 end
end

function new_endscreen(run_len)
 local me={}
 local msgs
 local skipped_level=
  cartdata_mgr.skipped_level()

 if skipped_level==0 then
  msgs={
   "   +-----------------+",
   "   | end of the line |",
   "   +-----------------+",
   "",
   " score"
   ..lpad(score,18),
   " hi-score"
   ..lpad(hiscore,15),
   " virtual hi-score"
   ..lpad(cartdata_mgr.virtual_hi(),7),
   "",
   " run length"
   ..lpad(run_len,8).." lvls",
   " max run length"
   ..lpad(dget(4),4).." lvls"
  }
 else
  msgs={
   "   +-----------------+",
   "   | nearly there... |",
   "   +-----------------+",
   "",
   "however, you did not yet "
   .."complete all levels",
   "",
   "please retry level "
   ..skipped_level
   .." and return when done"
  }
 end
 --[[
 local msg
 for i=1,#level_defs do
  if not msg then
   msg=""..dget(i+4)
  else
   msg=msg..","..dget(i+4)
  end
  if #msg>20 then
   add(msgs,msg)
   msg=nil
  end
 end
 if msg then
  add(msgs,msg)
 end
 ]]

 local msg_box=new_msg_box(
  msgs,12,4,116,74
 )
 local cnt=0

 me.draw=function()
  rectfill(0,0,128,128,3)

  color(7)
  if msg_box.draw() then
   print_await_key("continue")
  end

  --draw bot
  multipal(11)
  spr(160,0,70,6,6,true)
  pal()
 end

 me.update=function()
  if btnp(4) then
   show_mainscreen()
  end
  cnt+=1
  if cnt==55 and skipped_level==0 then
   sfx(4)
  end
 end

 return me
end --new_endscreen()

function show_mainscreen()
 clock=0
 _update=mainscreen_update
 _draw=mainscreen_draw
 --music(38)
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
 music(-1)
end

function show_endscreen(levelrun)
 local es=new_endscreen(levelrun)
 _update=es.update
 _draw=es.draw
end

--checks if going from one
--height to the other will
--start a fall. a falling mover
--can destroy other movers.
function is_fall(h_from,h_to)
 return h_from>h_to+6
end
-->8
-- maps (and waves)

--[[
0:vminor
1:vmajor
2:hiscore
3:-free-
4:max_levelrun
5:score_level 1
20:score_level 16
]]
function new_cartdata_mgr()
 local me={}
 local vmajor=1
 local vminor=1

 --init
 cartdata("eriban_bumblebots")
 if (
  dget(0)==vmajor and
  dget(1)>=vminor
 ) then
  --read compatible cartdata
  hiscore=dget(2)
 else
  --reset incompatible data
  for i=2,20 do
   dset(i,0)
  end
 end

 dset(0,vmajor)
 dset(1,vminor)

 me.level_done=function(
  level,level_score
 )
  --update level high
  local old=dget(4+level)
  if level_score>old then
   dset(4+level,level_score)
   return true --signal new hi
  end
 end

 me.game_done=function(levelrun)
  dset(2,hiscore)
  dset(4,max(dget(4),levelrun))
 end

 me.max_level=function()
  local skip=1
  local level=1
  while level<#level_defs do
   if dget(4+level)==0 then
    if skip>0 then
     skip-=1
    else
     break
    end
   end
   level+=1
  end
  return level
 end

 me.level_hi=function(level)
  return dget(4+level)
 end

 --the score that would have been
 --reached if the best score for
 --each level was reached in the
 --same game.
 me.virtual_hi=function()
  local vscore=0
  for i=1,#level_defs do
   vscore+=dget(4+i)
  end
  return vscore
 end

 --returns the first skipped
 --level, if any. returns 0
 --otherwise
 me.skipped_level=function()
  for i=1,#level_defs do
   if dget(4+i)==0 then
    return i
   end
  end
  return 0
 end

 return me
end

cartdata_mgr=new_cartdata_mgr()

map_unit={}

function map_unit:new(_mapmodel,o)
 o=setmetatable(o or {},self)
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
 o=setmetatable(o or {},self)
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
 o=setmetatable(o or {},self)
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
  (unit.col-unit.row)*8+24
 local y=
  (unit.col+unit.row)*4
  -unit.height-8

 if unit.colmap_idx>0 then
  multipal(unit.colmap_idx)
 elseif (
  unit.colmap_idx<0 and
  (unit.col+unit.row)%2==0
 ) then
  multipal(-unit.colmap_idx)
 end

 palt(0,false)
 palt(14,true)
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


-->8
-- movers

mover={}

function mover:new(o)
 o=setmetatable(o or {},self)
 self.__index=self

 o.rot=0     -- [0..rot_max>
 o.rot_dir=0 -- -1,0,1

 o.mov_dir=0 -- -1,0,1
 o.mov=0     -- <-16,16]
 o.mov_inc=1 -- -1,1

 --height tolerance
 o.tol=o.tol or 0

 --rotation speed
 o.rot_del=o.rot_del or 2
 o.rot_turn=5*o.rot_del
 o.rot_max=4*o.rot_turn

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
  --direction
  self.dx=
   (col_delta[h]-row_delta[h])
   *self.mov_dir
  self.dy=
   (col_delta[h]+row_delta[h])
   *self.mov_dir

  if self.mov>0 then
   self.dx*=flr((self.mov+1)/2)
   self.dy*=flr((self.mov+2)/4)
  else
   self.dx*=ceil(self.mov/2)
   self.dy*=ceil((self.mov-1)/4)
  end
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
  self.mov*self.mov_inc+16
 )%16

 if relmov==3 then
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
 elseif relmov==8 then
  --halfway crossing
  self:swap_unit()
 elseif relmov==14 then
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
  unit.height-self.unit.height<=self.tol and
  (
   not unit.object or
   not unit.object.is_obstacle
  )
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
  self.mov-=16*sign(self.mov)
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
  self.mov-=16*sign(self.mov)
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
  144+r%10,
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
  not self:is_dazed() and
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
   "system went down"
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
 bot.new(self,o)
 setmetatable(o,self)
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
 mover.new(self,o)
 setmetatable(o,self)
 self.__index=self

 o.box_type=box_type
 o.is_box=true

 return o
end

function box:destroy()
 mover.destroy(self)
 lvl:box_destroyed(self)
end

function box:freeze()
 --void. does not apply to box
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
  89+2*self.box_type,
  x+self.dx,-1,
  y+self.dy-self.dh,-3,
  2,2,
  self.drop
 )
 pal()
end

-->8
-- objects

pickup={}

function pickup:new(o)
 o=setmetatable(o or {},self)
 self.__index=self

 o.is_pickup=true

 return o
end

function pickup:draw(x,y)
 spr(134,x,y,1,1)
end

function pickup:visit(mover)
 --do not let frozen mover
 --collect pickup. player may
 --already have died...
 if not mover.frozen then
  self.unit:remove_object(self)
  lvl:pickup_collected(self)
  sfx(3)
 end
end

teleport={}

function teleport:new(
 colmap_idx,dst_pos,o
)
 o=setmetatable(o or {},self)
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
 spr(126,x,y+1,2,1)
 if self.cooldown_cnt>0 then
  self.cooldown_cnt-=1
  spr(
   125-flr(self.cooldown_cnt/8),
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
  local src2=sprite_address(135)
  local dst=sprite_address(238)
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

  spr(238,x+dx,y+dy,w,h)
 else
  spr(spr_idx,x+dx,y+dy,w,h)
 end
end

gap={}

function gap:new(colmap_idx,o)
 o=setmetatable(o or {},self)
 self.__index=self

 o.is_gap=true
 o.colmap_idx=colmap_idx or 14

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
 spr(137,x,y+4,2,1)
 pal()
end

obstacle={}

function obstacle:new(
 spr_idx,colmap_idx
)
 o=setmetatable({},self)
 self.__index=self

 o.is_obstacle=true
 o.spr_idx=spr_idx
 o.colmap_idx=colmap_idx or 0

 return o
end

function obstacle:draw(x,y)
 multipal(self.colmap_idx)
 spr(self.spr_idx,x,y,1,1)
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

-->8
-- levels

baselevel={}

function baselevel:new(o)
 o=setmetatable(o or {},self)
 self.__index=self

 o.collected_pickups={}
 o.num_pickups=0
 o.num_boxes_to_remove=0
 o.num_boxes_removed=0
 o.objects={}
 o.movers={}

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
 --destroy active movers
 for mover in all(self.movers) do
  if not mover.is_box then
   mover:destroy()
  end
 end
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
 c=max(3,min(c,mm.ncol-3))
 r=max(3,min(r,mm.nrow-3))
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
  --move camera, max one pixel
  self.camera_x+=sign(self.camera_tx-self.camera_x)
  self.camera_y+=sign(self.camera_ty-self.camera_y)
 end

 camera(
  self.camera_x,self.camera_y
 )
 self.map_view.draw()
 camera()
end

level={}
extend(level,baselevel)

function level:new(idx,o)
 o=o or {}
 o.idx=idx
 o.def=level_def(idx)

 baselevel.new(self,o)
 setmetatable(o,self)
 self.__index=self

 o.initial_score=score

 for spec in all(o.def.objects) do
  o:add_object_from_specs(
   spec
  )
 end
 for spec in all(o.def.movers) do
  o:add_mover_from_specs(
   spec,true
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
 self.time_left=abs(
  map_def[6]*30
 )
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
 elseif object_type==7 then
  local obstacle=obstacle:new(
   specs[4],specs[5]
  )
  self:add_object(specs,obstacle)
 end
end

function level:add_mover_from_specs(
 specs,passive
)
 local mover_type=specs[3]
 if passive and mover_type then
  if mover_type<=2 then
   local box=box:new(mover_type)
   self:add_mover(specs,box)
   if mover_type==2 then
    self.num_boxes_to_remove+=1
   end
  end
 elseif not (passive or mover_type) then
  if not self.player then
   self.player=player:new()
   self:add_mover(specs,self.player)
  else
   local enemy=enemy:new(
    self.player
   )
   self:add_mover(specs,enemy)
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
   mover_specs,false
  )
 end

 self.playing=true
 --music(self.def.map_def[7])
end

function level:freeze()
 baselevel.freeze(self)

 self.playing=false
 music(-1)
end

function level:update()
 baselevel.update(self)

 if self.playing then
  self.time_left-=1

  if self.time_left<0 then
   game.signal_death(
    "timed out"
   )
  end
 end
end

function level:draw()
 baselevel.draw(self)

 draw_timebar(self.time_left/30)
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

 local a0=sprite_address(128)
 local maxlevel=cartdata_mgr.max_level()
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
    local digit_col=5
    if l<=maxlevel then
     unit:settype(288+chk*8)
     if cartdata_mgr.level_hi(l)>0 then
      digit_col=14-3*chk
     end
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
      digit_col
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

  local idx=level_idx()
  local dest="unknown"
  if idx<=#level_defs then
   dest=level_defs[idx].name
  end
  local w=min(pixlen(dest)/2,30)
  line(31-w,0,31+w,0,1)
  rectfill(30-w,1,32+w,7,1)
  line(31-w,8,31+w,8,1)
  center_print(dest,2,7)

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
   if idx<=#level_defs then
    start_game(idx)
   end
  end
 end

 lvl=levelmenu:new()
 lvl:start()
 lvl:update()

 return me
end

-->8
-- game and animations

function new_game(level_num)
 local me={}

 local anim=nil
 local lives=3
 local death_cause
 local last_level_completed=false
 local display_score=0

 local slowcnt=0
 local slowmo=false

 me.start_level=level_num
 me.level_num=level_num
 score=0

 function draw_score()
  if display_score<score then
   display_score+=1
  end
  local s=""..display_score
  local ishi=score>=max(1,hiscore)
  rectfill(
   0,0,pixlen(s),6,
   ishi and 3 or 1
  )
  print(s,1,1,ishi and 11 or 12)
 end

 function me.draw()
  lvl:draw()

  if display_score<score or lives==0 then
   draw_score()
  else
   for i=1,lives do
    spr(133,i*5-6,0,1,1)
   end
  end

  if anim then
   anim.draw()
  end

  if slowmo then
   print("sm",1,58,1)
  end
 end

 function me.update()
  slowcnt+=1
  if slowcnt%20!=0 and slowmo then
   return
  end

  --debug only, todo: remove
  if btnp(5) then
   slowmo=not slowmo
  end

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
  --repeated auto-destruct can
  --result in negative lives
  return lives<=0
 end

 function me.level_run()
  return me.level_num-me.start_level
 end

 function me.level_done()
  anim=level_done_anim()
 end

 function init_level()
  lvl=level:new(me.level_num)
  lvl:update()
 end

 function start_level(restart)
  --todo: progress tracking

  anim=level_start_anim()
  return anim
 end

 function me.next_level()
  me.level_num+=1
  if me.level_num>#level_defs then
   last_level_completed=true
  end

  if last_level_completed then
   me.level_num=cartdata_mgr.skipped_level()
   if me.level_num==0 then
    anim=game_done_anim()
    return anim
   end
  end

  init_level()

  return start_level(false)
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
   game_done()
   anim=game_over_anim()
  end
 )
 init_level()
 anim=level_start_anim()

 return me
end --new_game()

function die_anim(cause)
 local me={}

 local clk=0

 function me.update()
  clk+=1

  if clk==60 then
   if game.game_over() then
    game_done()
    return game_over_anim()
   else
    game.reset()
    return level_start_anim()
   end
  end

  return me
 end

 function me.draw()
  -- void
 end

 lvl.map_model.wave_strength_delta=-1
 lvl:freeze()
 sfx(1)

 return me
end --die_anim

function level_start_anim()
 local me={}

 local clk=0

 function me.update()
  clk+=1

  if clk==30 then
   sfx(42)
  end

  if clk==45 or btnp(4) then
   lvl:start()
   return nil
  end

  return me
 end

 function me.draw()
  -- void
 end

 return me
end --level_start_anim

function level_done_anim()
 local me={}

 local clk=0
 local endclk
 local newhi=false

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
   else
    newhi=cartdata_mgr.level_done(
     game.level_num,
     score-lvl.initial_score
    )
    if newhi then
     sfx(41)
     endclk=150
    else
     endclk=80
    end
   end
  end

  if clk==endclk or btnp(4) then
   return game.next_level()
  end

  return me
 end

 function me.draw()
  if newhi then
   spr(192,16,16,4,4)
  end
 end

 local pu=lvl.player.unit
 add(
  lvl.map_model.functions,
  shock_wave:new(pu.col,pu.row)
 )
 lvl:freeze()

 return me
end --level_done_anim

function game_done()
 hiscore=max(hiscore,score)
 cartdata_mgr.game_done(game.level_run())

 menuitem(1)
 menuitem(2)
end

function game_over_anim()
 local me={}

 local clk=0

 function me.update()
  clk+=1

  if btnp(4) or clk>240 then
   show_mainscreen()
  end

  return me
 end

 function me.draw()
  --game over
  spr(140,16,20,4,3)
  --todo: best game ever
 end

 lvl:freeze()
 sfx(2)

 return me
end --game_over_anim

function game_done_anim()
 local me={}

 local clk=0

 function me.update()
  clk+=1

  if btnp(4) or clk>240 then
   show_endscreen(0)
  end

  return me
 end

 function me.draw()
  --end of the line
  spr(186,8,20,6,3)
 end

 sfx(4)

 return me
end --game_done_anim

function _init()
 --low-rez
 poke(0x5f2c,3)
end

show_mainscreen()

--show_endscreen(0)

--eof
__gfx__
eeeeeeee7eeeeeeeeeeeeeee7eeeeeeeeeeeee999eeeeeeeeeeeeeee6eeeeeeeeeeeeeee5eeeeeeeeeeeeeee7eeeeeeeeeeeeeee7eeeeeeeeeeeee999eeeeeee
eeeeee77777eeeeeeeeeee77777eeeeeeeee9999999eeeeeeeeeee66666eeeeeeeeeee54445eeeeeeeeeee77777eeeeeeeeeee77777eeeeeeeee9999999eeeee
eeee777777777eeeeeee777777777eeeee99999999999eeeeeee666666666eeeeeee544444445eeeeeee777777777eeeeeee777777777eeeee99999999999eee
ee7777777777777eee7777777777777e999999999999999eee6666666666666eee5444444444445eee7777777777777eee7777777777777e999999999999999e
7777777777777777e777777777777777499999999999999966666666666666665444444444444444e777777777777777e7777777777777774999999999999999
6777777777777755e667777777777755744999999999994456666666666666006644444444444455e667777777777755e6677777777777557449999999999944
6667777777775555e6666777777755557774499999994466e5566666666600ee5666444444445555e666677777775555e6666777777755557774499999994466
6666677777555555e6666667775555558877744999446666eea556666600a9ce6666664444555555e666666777555555e6666667775555557777744999446666
6666666755555555eee66666655555ee8851777444666666cca9c55600cccccc5666666605555555e6666666655555eeee666666655555557777777444666566
6666666655555555eeeee6666555eeee8851117766666666dccccca5cccccc116666666655555555e66666666555eeeeeee66666655555557777777766644566
6666666655555555eeeeeee665eeeeee8851118866666666dddccca9cccc11115666666605555555e666666665eeeeeeeeee6666655555557777777764444566
6666666655555555eeeeeeea94eeeeee8851118866666666dddddccccc1111116666666655555555e666660060eeeeeeeeeee666655555557777777764444566
6666666655555555eeeeeeea94eeeeee8851118866666666dddddddc111111115666666605555555e666500000eeeeeeeeeee666655555557777777764444566
6666666655555555eeeeeeea94eeeeee7766118866666666dddddddd111111116656666655555505e666555500eeeeeeeeeeee66655555557777777764499566
6666666655555555eeeeeeea94eeeeee7777668866666666dddddddd111111115666566605550555e665555550eeeeeeeeeeee66655555557777777769944566
6666666655555555eeeeeeea94eeeeee7777778866666666dddddddd111111116666665655055555e665555555eeeeeeeeeeeee6655555557777777764444566
6666666655555555eeeeeeea94eeeeee7777777766666666dddddddd111111115666666605555555e665555555eeeeeeeeeeeee6655555557777777764444566
6666666655555555eeeeeeea94eeeeee7777777766666666dddddddd111111116666666655555555e665555555eeeeeeeeeeeee665555555777777776444d566
6666666655555555eeeeeeea94eeeeee7777777766666666dddddddd111111115666666605555555e665555555eeeeeeeeeeeee6655555557777777764dd6666
6666666655555555eeeeeeea94eeeeee7777777766666666dddddddd111111116666666655555555e665555555eeeeeeeeeeeee665555555777777776d666666
6666666655555555eeeeeeea94eeeeee7777777766666666eddddddd111111ee5666666605555555e665555555eeeeeeeeeeeee6655555557777777766666666
6666666655555555eeeeeeea94eeeeee7777777766666666eeeddddd1111eeee6656666655555505e665555555eeeeeeeeeeeee6655555557777777766666666
6666666655555555eeeeeeea94eeeeee7777777766666666eeeeeddd11eeeeee5666566605550555e665555555eeeeeeeeeeeee6655555557777777766666666
6666666655555555eeeeeeea94eeeeee7777777766666666eeeeeeedeeeeeeee6666665655055555e665555555eeeeeeeeeeeee6655555557777777766666666
eeeeeee55eeeeeeeeeeeeeee3eeeeeeeeeeeee11122eeeeeeeeeeeee3eeeeeeeeeeeeeee3eeeeeeeeeeeeeeeeeeeeeeeeeeeeeee7eeeeeeeeeeeeeee7eeeeeee
eeeee555555eeeeeeeeeee33333eeeeeeeee117777722eeeeeeeee33bb3eeeeeeeeeeebb333eeeeeeeeeefffffffeeeeeeeeee77777eeeeeeeeeee77777eeeee
eee5555555555eeeeeee333333333eeeeee17777777772eeeeee33bb333bbeeeeeee3333bb333eeeeeefffffffffffeeeeee777777777eeeeeee777777777eee
e5555555555555eeee3333333333333eee2777777777771eee33bb333bb333beeebb333333bb333eee7ffffffffffffeee7777777777777eee7777777777777e
e0555555555550ee3333333333333333ee2277777777711e33bb333bb333bb333333bb333333bb33ee677fffffffff0ee777777777777777e777777777777777
ea0055555550093e63333333333333ddee2222777771111e6b333bb333bb33dd633333bb333333ddee566777ffff500ee667777777777755e667777777777755
3a3a005550093933e66333333333ddeeee2222221111111ee66bb333bb33ddeee6633333bb33ddeeee6666565555050ee666677777775555e666677777775555
633a3a00093933ddeee6633333ddeeeeee2222222111111eeee663bb33ddeeeeeee6633333ddeeeeee6665655550500ee666666777555555e666666777555555
e6633a393933ddeeeeeee663ddeeeeeeee2222221111111eeeeee663ddeeeeeeeeeee663ddeeeeeeee5666565555050ee666666665555555eee66666655555ee
eee6633933ddeeeeeeeeeee6eeeeeeeeee322222211111beeeeeeee6eeeeeeeeeeeeeee6eeeeeeeeee6665655550500ee666666665555555eeeee6666555eeee
eeeee663ddeeeeeeeeeeeeeeeeeeeeee33bb222211111b33eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee6666565555050ee666666665555555eeeeeee665eeeeee
eeeeeeedeeeeeeeeeeeeeeeeeeeeeeee6b333922211933ddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee5665655550500ee666666665555555eeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee66bb333bb33ddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee6666565555050ee666666665555555eeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee663bb33ddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee6665655550500ee666666665555555eeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee663ddeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee5666565555050ee666666665555555eeeeeeeeeeeeeeee
eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee6eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee6665655550500ee666666665555555eeeeeeeeeeeeeeee
eeeeeeeeeeeeeeee0eeeeeeeeeeeeeeebeeeeeeeeeeeee3333eeeeeeeeeeeeee8eeeeeeeeeeeeee3eeeeeeee0000000000000000000000000000000000000000
eeeeee00eeeeeeee000eeeeeeeeeeebbbbbeeeeeeeeee3bb333eeeeeeeeeee89988eeeeeeeeeeee3eeeeeeee00000000000000000000aaa00000000000665000
eeee0000eeeeeeee00000eeeeeeebbbb3bbbbeeeeeee3b9bb833eeeeeeee899889988eeeeeeeee333eeeeeee000066600000000000aaaaaaa000000006665500
ee000000eeeeeeee0000000eeebbbbbbbbbbbbbeeeee38bb3333eeeeee8998899889988eeeeeee3a3eeeeeee00666666600000000aaaaaaaaa00000006666510
00000000eeeeeeee00000000bbbbb3bbbb3bb3bbeeee33338343eeeee998899889988998eeeee33333eeeeee0666666666000000099aaaaa4400000066666551
00000000eeeeeeee000000004b3bbbbbbbbbbb44eeeee383333eeeee6779988998899877eeeee3a333eeeeee0dd666661100000009999a444400000066666551
00000000eeeeeeee00000000444bbbbbb3bb4455eeeeee3333eeeeee6667799889987755eeee3333a33eeeee0dddd61111000000099999444400000066665550
00000000eeeeeeee0000000044444bbbbb445544eeeeeee44eeeeeee6666677998775555eeee3333333eeeee0ddddd1111000000099999444400000000665500
00000000eeeeeeee000000004444444b44554455eeeeee444bbeeeee6656666777555505eee33a3333a37eee0ddddd1111000000099999444400000000000000
00000000eeeeeeee000000004444444455445544eeeebbb44b3bbeee6656666655555505ee733333a333677e0ddddd1111000000099999444400000000665000
00000000eeeeeeee000000004444444444554455eebb3bb44bbbbbbe66566666555555057777733333667777000ddd1100000000000999440000000006665500
00000000eeeeeeee000000004444444455445544bbbbbbb44bbbb3bb6656666655555505677777646667775500000d0000000000000009000000000066666510
00000000eeeeeeee0000000044444444445544554b3bbb8bbb3bbb44665666665555550566677777777755550000000000000000000000000000000066666551
00000000eeeeeeee000000004444444455445544444bbbbb3bbb4455667666665555556566666777775555550000000000000000000000000000000066665551
00000000eeeeeeee00000000444444444455445544444bbbbb445544666776665555665566666667555555550000000000000000000000000000000066665550
00000000eeeeeeee0000000044444444554455444444444b44554455666667665556555566666666555555550000000000000000000000000000000006655500
00000000eeeeeeee0000000044444444445544554444444455445544666666665555555566666666555555550000800000000000000000000000000000000000
00000000eeeeeeee0000000044444444554455444444444444554455666666665555555566666666555555550000000000009000000000000000000000000000
00000000eeeeeeee00000000444444444455445544444444554455446666666655555555666666665555555500800080000909000000a0000000000000000000
00000000eeeeeeee0000000044444444554455444444444444554455666666665555555566666666555555550000000000009000000000000000800000000000
00000000eeeeeeee0000000044444444445544554444444455445544666666665555555566666666555555550000800000000000000000000088988000000000
00000000eeeeeeee000000004444444455445544444444444455445566666666555555556666666655555555000000000000000000000000889aaa9880000000
00000000eeeeeeee0000000044444444445544554444444455445544666666665555555566666666555555550000000000000000000000000088988000000000
00000000eeeeeeee0000000044444444554455444444444444554455666666665555555566666666555555550000000000000000000000000000800000000000
000000000000000000000000000000000000000000000000009999000fffffffff00000000011600000000000000000000000000000000000000000000000000
0000000000000000000000000000000000000000000cc00009a99990000fffff0000000001155666000000000000000000000000000000000000000000000000
077700700777077707070777070007770777077700cccc009aaa999400000f000000000015511666600000000000000000000000000000000000000000000000
070707800007000707070700070000070707070700dcc10099a99994000000000000000000155660000000000000000000001111000111001111111001111100
070700700776007707770777077700070777077700dd11009999994400000000000000000000100000000000000000000001cccc101ccc11ccccccc11ccccc10
070700700700000700070007070700070707000700dd1100499994440000000000000000000000000000000000000000001cccccc1ccccc1cccccccc1ccccc10
0777077707770777000707760777000707770007000d1000044444400000000000000000000000000000000000000000001cc11111cc1cc1cc1cc1cc1cc11100
000000000000000000000000000000000000000000000000004444000000000000000000000000000000000000000000001cc1ccc1ccccc1cc1cc1cc1cccc100
000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001cc1ccc1ccccc1cc1cc1cc1cccc100
000650000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001cc11cc1cc1cc1cc1cc1cc1cc11100
000000000000000000000000000000000000000000006500000000000000000000000000000000000000000000000000001cccccc1cc1cc1cc1cc1cc1ccccc10
0060560000000000000000000000000000000000005600000000000000000000000000000000000000000000000000000001cccc11cc1cc1cc1cc1cc1ccccc10
00506500000000000000000000000000000000000000560000000000000000000000000000000000000000000000000000001111111111111111111111111100
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001ccc11cc1cc1ccccc1cccc11cc10
0000c00000000c000000000000c00000000c00000000c00000000c000000000000c00000000c000000000000000000000001ccccc1cc1cc1ccccc1ccccc1cc10
00ccccc000ccccc00cccccc00ccccc000ccccc0000ccccc000ccccc00cccccc00ccccc000ccccc0000000000000000000001cc1cc1cc1cc1cc1111cc1cc1cc10
cccccccc0ccccccc0cccccc0ccccccc0cccccccccccccccc0ccccccc0cccccc0ccccccc0cccccccc00000000000000000001cc1cc1cc1cc1cccc11cccc11cc10
dccccc110dccccc10cccccc0dccccc10ddccccc1dccccc110dccccc10cccccc0dccccc10ddccccc100000000000000000001cc1cc1cc1cc1cccc11ccccc1cc10
dddc11110ddc11110d1d1d10ddddc110ddddc111dddc11110ddc11110d1d1d10ddddc110ddddc11100000000000000000001cc1cc11ccc11cc1111cc1cc11100
8ddd111a08d1111a01d1d1d08dddd1a08ddd111a8ddd111a08d1111a01d1d1d0adddd180addd111800000000000000000001ccccc11ccc11ccccc1cc1cc1cc10
d88d11110d811111081d1da0ddddda10dddd1aa1dddd1aa10da1aaa10aaaaaa0daaada10daad1111000000000000000000001ccc1001c101ccccc1cc1cc1cc10
ddd881110dd8111101d1d1d0dddda110dddaa111dddaa1110dda11110d1d1d10dddda110dddaa111000000000000000000000111000010001111101101101100
0ddd110000d111100d1d1d100dddd10000dd11100ddd110000d1111001d1d1d00dddd10000dd1110000000000000000000000000000000000000000000000000
000d000000010000000000000000d00000001000000d000000010000000000000000d00000001000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000111110111110111100000111001111100000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000001ccccc1cccc11cccc10001ccc11ccccc10000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000001ccccc1ccccc1ccccc101ccccc1ccccc10000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000001cc1111cc1cc1cc1cc101cc1cc1cc11100000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000001cccc11cc1cc1cc1cc101cc1cc1cccc100000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000001cccc11cc1cc1cc1cc101cc1cc1cccc100000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000001cc1111cc1cc1cc1cc101cc1cc1cc11000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000001ccccc1cc1cc1ccccc101ccccc1cc10000000000
00000011110011111011000110000000000000000000000000000000000000000000000000000000000000001ccccc1cc1cc1cccc10001ccc11cc10000000000
000001cccc11ccccc1cc101cc1000000000011110011111001111011111100000011111000000000000111111111111111111111110000111111100111110000
000001ccccc1ccccc1cc101cc10000000001cccc11ccccc11cccc1cccccc100001ccccc100000000001cccccc1cc1cc1ccccc101cc1001cc1cccc11ccccc1000
000001cc1cc1cc1111cc111cc10000000001ccccc1ccccc1ccccc1cccccc100001ccccc100000000001cccccc1cc1cc1ccccc101cc1001cc1ccccc1ccccc1000
000001cc1cc1cccc11cc1c1cc10000000001cc1cc1cc1111cc111111cc11000001cc11110000000000011cc111cc1cc1cc111101cc1001cc1cc1cc1cc1110000
000001cc1cc1cccc11cc1c1cc10000000001cccc11cccc11cccc1111cc10000001cccc100000000000001cc101ccccc1cccc1001cc1001cc1cc1cc1cccc10000
000001cc1cc1cc11111ccccc100000000001cccc11cccc111cccc111cc10000001cccc100000000000001cc101ccccc1cccc1001cc1001cc1cc1cc1cccc10000
000001cc1cc1ccccc11ccccc100000000001cc1cc1cc1111111cc111cc10000001cc11110000000000001cc101cc1cc1cc111101cc1111cc1cc1cc1cc1110000
000001cc1cc1ccccc111c1c1000000000001ccccc1ccccc1ccccc111cc10000001ccccc10000000000001cc101cc1cc1ccccc101ccccc1cc1cc1cc1ccccc1000
011000111111111111111111011000000001cccc11ccccc1cccc1111cc10000001ccccc10000000000001cc101cc1cc1ccccc101ccccc1cc1cc1cc1ccccc1000
1cc1001ccccc1cc1cc1ccccc1cc10000000011110011111011110000110000000011111000000000000001100011011011111000111110110110110111110000
1cc1001ccccc1cc1cc1ccccc1cc10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1cc1001cc1111cc1cc1cc1111cc10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1cc1001cccc11cc1cc1cccc11cc10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1cc1001cccc11cc1cc1cccc11cc10000000000000000000000000000000000000000000000000000000000000000000000000000000000008888888888888888
1cc1111cc11111ccc11cc1111cc11100000000000000000000000000000000000000000000000000000000000000000000000000000000008088808000800088
1ccccc1ccccc11ccc11ccccc1ccccc10000000000000000000000000000000000000000000000000000000000000000000000000000000008088808080808088
1ccccc1ccccc111c111ccccc1ccccc10011110011011011111110011110011000011111000001111000111001111110011110000000000008080808080800088
011111011111111111111111011111001cccc11cc1cc1ccccccc11cccc11cc1001ccccc10001cccc101ccc11cccccc11cccc1000000000008080808080800888
0000000001cc1cc1cc1cc100000000001ccccc1cc1cc1cccccccc1ccccc1cc1001ccccc10001ccccc1ccccc1cccccc1ccccc1000000000008800088000808088
0000000001cc1cc1cc1cc100000000001cc1cc1cc1cc1cc1cc1cc1cc1cc1cc1001cc11100001cc1cc1cc1cc111cc111cc1110000000000008888888888888888
0000000001cc1cc1cc1cc100000000001cccc11cc1cc1cc1cc1cc1cccc11cc1001cccc100001cccc11cc1cc101cc101ccccc1000000000008888888888888888
0000000001ccccc1cc1cc100000000001ccccc1cc1cc1cc1cc1cc1ccccc1cc1001cccc100001ccccc1cc1cc101cc101ccccc1000000000008088080808088888
0000000001ccccc1cc1cc100000000001cc1cc1cc1cc1cc1cc1cc1cc1cc1cc1111cc11100001cc1cc1cc1cc101cc100111cc1000000000008080880808088888
0000000001cc1cc1cc111000000000001ccccc1ccccc1cc1cc1cc1ccccc1ccccc1ccccc10001ccccc1ccccc101cc101ccccc1000000000008008880808088888
0000000001cc1cc1cc1cc100000000001cccc101cccc1cc1cc1cc1cccc11ccccc1ccccc10001cccc101ccc1001cc101cccc10000000000008080888888888888
0000000001cc1cc1cc1cc10000000000011110001111011011011011110011111011111000001111000111000011000111100000000000008088080808088888
00000000001101101101100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008888888888888888
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008888888888888888
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008888888888888888
__label__
00000000000000000000000000000000002220222022202220222022000000222022202220022022202200222002200000000000000000000000000000000000
000000000000000000000000000000000eee0eee2eee0eee2eee2ee020000eee2eee2eee00ee0eee0ee02eee00ee000000000000000000000000000000000000
000000000000000000000000000000000e220e2e00e20e2e0e2e2e2e20000e2e2e2e0e220e222e220e2e20e20e22200000000000000000000000000000000000
000000000000000000000000000000000ee00ee020e20ee02eee2e2e20000eee0ee02ee00eee2ee00e2e20e20eee200000000000000000000000000000000000
000000000000000000000000000000000e222e2e20e22e2e2e2e2e2e20000e200e2e2e22202e0e222e2e20e2002e000000000000000e00000000000000000000
000000000000000000000000000000000eee0e0e0eee0eee0e0e0e0e00000e000e0e0eee0ee00eee0e0e00e00ee00000000000000eeeee000000000000000000
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
0000000000000000000000009900000000000000000000000000000000000000000000000000000000000000ddddeeeeeeeeeeeeeeeeeeeeeeeeeeeee2222200
0000000000000000000000999999000000000000000000000000000000000000000000000000000000000000ddddddeeeeeeeeeeeeeeeeeeeeeeeee222222200
0000000000000000000000499999990000000000000000000000000000000000000000000000000000000000ddddddddeeeeeeeeeeeeeeeeeeeee22222222200
0000000000000000000000444999999900000000000000000000000000000000000000000000000000000000ddddddddddeeeeeeeeeeeeeeeee2222222222200
0000000000000000000000444449999920000000000000000000000000000000000000000000000000000000ddddddddddddeeeeeeeeeeeee222222222222200
0000000000000000000000444444492220000000000000000000000000000000000000000000000000000000ddddddddddddddeeeeeeeee22222222222222200
0000000000000000000000444444442299000000000000000000000000000000000000000000000000000000ddddddddddddddddeeeee2222222222222228000
00000000000000000000004444444499999900000000000000000000000000000000000000000000000000000ddddddddddddddddde222222222222222888000
00000000000000000000004444244449999920000000000000000000000000000000000000000000000000000aaddddddddddddddd2222222222222222888000
00000000000000000000004444222444492220000000000000000000000000000000000000000000000000000aaaaddddddddddddd2222222222222222888000
00000000000000000000004444229944442220009900000000000000000000000000000000000000000000000aaaaaaddddddddddd222222222222222288ee00
0000000000000000000000444499994444222099999900000000000000000000000000000000000000000000eaaaaaaaaddddddddd2222222222222222ee2200
0000000000000000000000444449994444222049999920000000000000000000000000000000000000000000deeaaaaaaaaddddddd2222222222222222222200
0000000000000000000000444444494444222044492220000000000000000000000000000000000000000000dddeeaaaaaaaaddddd2222222222222222222200
0000000000000000000000444444442444220044442220009900000000000000000000000000000000000000dddddeeaaaaaaaaddd222d222222222222222270
0000000000000000000000444444442224000044442220999999000000000000000000000000000000000000dddddddeeaaaaaaaad2aad222222222222222277
0000000000000000000000444424442299000044442220499999200000000000000000000000000000000000dddddddddeeaaaaaaaaaad222222222222222777
0000000000000000000000444422249999990044442220444922200000000000000000000000000000000007dddddddddddeeaaaaaaaad222222222222277775
00000000000000000000004444229949999920444422204444222000000000000000000000000000000000777ddddddddddddeeaaaaaae222222222222777555
0000000000000000000000444499994449222044442220444422200099000000000000000000000000000067777ddddddddddddeeaaee2222222000522655555
000000000000000000000044444999444422204444222044442220999999000000000000000000000000006667777ddddddddddddee222222222005552655555
00000000000000000000004444444944442220444422204444222049999920000000000000000000000000666667777ddddddddddd2222222220005555655550
0000000000000000000000044444444444222044442220444422204449222000000000000000000000000066666667777ddddddddd2222222220055555655000
000000000000000000000000044444444422204444222044442220444422200000000000000000000000000666666667777ddddddd2222222200055555000000
00000000000000000000000000044424442200444422204444222044442220000000000000000000000000000666666667777ddddd2227222200555055000000
0000000000000000000000000000040004000044442220444422204444229900000000000000000000000000000666666667777ddd2775222200550055000000
00000000000000000000000000000000000000444422204444222044449999990000000000000000000000000000066666666777777775222200550550000000
00000000000000000000000000000000000000444422204444222044444999992000000099000000000000000000000666666667777555222200555550000000
00000000000000000000000000000000000000444422994444222044444449222000009999990000000000000000000006666666655555200000555500000000
00000000000000000000000000000000000000444499994444222044444444229900994999992000000000000000000000066666655555000000055500000000
00000000000000000000000000000000000000044449994444222044444444999999994449222000990000000000000000000666655550000000005000000000
00000000000000000000000000000000000000000444494444222044444444499949994444222099999900000000000000000006655000000000000000000000
00000000000000000000c00000000000000000000044444444222044444444444944494444222049999999000000000000000000000000000000000000000000
000000000000000000ccccc000000000000000000044444444222044442444444444444444222044499999990000000000000000000000000000000000000000
0000000000000000ccccccccc0000000000000000004444444222044442224444444444444222044444999992000000000000000000000000000000000000000
00000000000000ccccccccccccc00000000000000000044444222044442220444444444444222044444449222000000000000000000000000000000000000000
000000000000ccccccccccccccccc000000000000000000444220044442220444444444444222044444444229900000099000000000000000000000000000000
0000000000cccccccccccbccccccccc0000000000000000004000044442220044424444444222044444444999999009999990000000000000000000000000000
00000000ccccccccccccc5ccccccccccc00000000000000000000044442220000400044444222044442444499999204999992000000000000000000000000000
000000ccccccccccccccc5ccccccccccccc000000000000000000044442220000000004444222044442224444922204449222000000000000000000000000000
0000ccccccccccccccccc5ccccccccccccccc0000000000000000044442220000000004444222044442299444422204444222000000000000000000000000000
00ccccccccccccccccccc5ccccccccccccccccc00000000000000004442200000000004444222044449999444422204444222000000000009900000000000000
00dccccccccccccccccccccccccccccccccccccc0000000000000000040000000000004444222044444999444422204444222000000000999999000000000000
00dddccccccccccccccccccccccccccccccccc110000000099000000000000000000004444222044444449444422204444222000000000499999990000000000
00dddddccccccccccccccccccccccccccccc11110000009999990000000000000000004444222044444444244422004444222000000000444999999900000000
00dddddddccccccccccccccccccccccccc1111110000004999999900000000000000004444222044444444222400004444222000000000444449999999000000
00dddddddddccccccccccccccccccccc111111110000004449999999000000000000004444222044442444229900004444222000000000444444499999990000
00dddddddddddccccccccccccccccc11111111110000004444499999200000000000004444222044442224999999004444222000000000444444444999992000
00dddddddddddddccccccccccccc1111111111110000004444444922200000000000004444222044442299499999204444222000000000444444444449222000
00dddddddddddddddccccccccc111111111111110000004444444422990000000000000444220044449999444922204444222000000000444424444444222000
0008dddddddddddddddccccc11111111111111110000004444444499999900000000000004000044444999444422204444222000000000444422244444222000
000888dddddddddddddddc1111111111111111100000004444244449999920000000000000000044444449444422204444222000000000444422990444220000
000888dddddddddddddddd111111111111111aa00000004444222444492220009900990000000004444444444422204444222000000000444499999904000000
000888dddddddddddddddd1111111111111aaaa00000004444229944442220999999999900000000044444444422204444222000000000444449999920000000
00cc88dddddddddddddddd11111111111aaaaaa00000004444999944442220499949999920000000000444244422004444229900000000444444492220000000
00ddccdddddddddddddddd111111111aaaaaaaac0000004444499944442220444944492220000000000004000400004444999999000000444444442220000000
00dddddddddddddddddddd1111111aaaaaaaacc10000004444444944442220444444442299000000990000000000004444499999990000444444442220000000
00dddddddddddddddddddd11111aaaaaaaacc1110000004444444424442200444444449999990099999900000000004444444999999900444424442200000000
07dddddddddddddddd1ddd111aaaaaaaacc111110000004444444422240000444424444999992049999999000000000444444449999920444422240000000000
77dddddddddddddddd1aad1aaaaaaaacc11111110000004444244422990000444422244449222044499999990000000004444444492220444422990000000000
777ddddddddddddddd1aaaaaaaaaacc1111111110000004444222499999900444422204444222044444999999900000000044444442220444499999900000000
67777ddddddddddddd1aaaaaaaacc111111111117000004444229949999920444422204444222044444449999999000000000444442220444449999999000000
666777ddddddddddddcaaaaaacc11111111111177700004444999944492220444422204444222004444444499999200000000004442200444444499999990000
666665dd5000dddddddccaacc1111111111117777500004444499944442220444422204444222000044444444922200099009900040000044444444999992000
666665d55500dddddddddcc111111111111777755500004444444944442220444422204444222000004444444422209999999999000000000444444449222000
0666655555000ddddddddd1111111111177775555500000444444444442220444422204444222000004444444422204999499999990000000004444444222000
0006655555500ddddddddd1111111117777555555500000004444444442220444422204444222000004444244422004449444999999900000000044444222000
00000055555000dddddddd1111111777755555555000000000044424442200444422204444222000004444222400004444444449999920000000000444220000
00000055055500dddd7ddd1111177775555555500000000000000400040000444422994444222000004444222000004444444444492220000000000004000000
00000055005500dddd677d1117777555555550000000000000000000000000444499994444222000004444222000004444244444442220000000000000000000
00000005505500dddd67777777755555555000000000000000000000000000044449994444222000004444222000004444222444442220000000000000000000
00000005555500dddd66677775555555500000000000000000000000000000000444494444222000004444222000004444229904442200000000000000000000
00000000555500000d66666555555550000000000000000000000000000000000044444444222000004444222000004444999999040000000000000000000000
00000000555000000066666555555000000000000000000000000000000000000044444444222000004444222000004444499999990000000000000000000000
00000000050000000006666555500000000000000000000000000000000000000004442444220000004444222000004444444999999900000000000000000000
00000000000000000000066550000000000000000000000000000000000000000000040004000000004444222000000444444449999920000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000004444222000000004444444492220000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000004444222000000099044444442220000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000004444222000009999990444442220000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000004444222000004999999944442220000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000444220000004449999944442220000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000004000000004444499944442220000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000004444444944442220000000000000000000
01110101001101110011000000000111011101010100000001110011011000110111011100000000000000000000000444444444442220000000000000000000
ccc1c1c10cc0ccc00cc000100000ccc1ccc1c1c1c1000000ccc10cc1cc010cc0ccc1ccc100000000000000000000000004444444442220000000000000000000
ccc1c1c1c1110c10c1000c000000c1c1c1c1c1c1c1000000c1c0c1c1c1c1c111ccc1c1c100000000000000000000000000044424442200000000000000000000
c1c1c1c1ccc10c10c10000100000ccc0ccc1c1c1c1000000cc01c1c1c1c1ccc1c1c1ccc100000000000000000000000000000400040000000000000000000000
c1c1c0c101c00c11c0110c000000c100c1c1c0c1c1110000c1c1c1c0c1c101c0c1c1c1c100000000000000000000000000000000000000000000000000000000
c0c00cc0cc00ccc00cc000000000c000c0c00cc0ccc00000ccc0cc00c0c0cc00c0c0c0c000000000000000000000000000000000000000000000000000000000
01110101011100000111011100110111000000000111011101010111011000000111001101100011011101110000000000000000000000000000000000000000
ccc0c1c1ccc00000ccc1ccc00cc0ccc000100000ccc0ccc1c1c1ccc0cc010000ccc10cc1cc010cc0ccc1ccc10000000000000000000000000000000000000000
0c10c1c1c1100000c1c0c110c1110c100c000000c110c1c0c1c10c10c1c10000c1c0c1c1c1c1c111ccc1c1c10000000000000000000000000000000000000000
0c10ccc1cc000000cc01cc00ccc10c1000100000cc00cc01c1c10c10c1c10000cc01c1c1c1c1ccc1c1c1ccc10000000000000000000000000000000000000000
0c10c1c1c1110000c1c1c11101c00c100c000000c111c1c1ccc10c11c1c10000c1c1c1c0c1c101c0c1c1c1c10000000000000000000000000000000000000000
0c00c0c0ccc00000c0c0ccc0cc000c0000000000ccc0c0c0ccc0ccc0c0c00000ccc0cc00c0c0cc00c0c0c0c00000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000001010111011100110111001101100000011000000111000000000010001100100000011101110110011100000000000000000000000
00000000000000000000001010100010101000010010101010000001000000101000000000100010000010000000101010010000100000000000000000000000
00000000000000000000001010110011001110010010101010000001000000101000000000100010000010000011101010010000100000000000000000000000
00000000000000000000001110100010100010010010101010000001000000101001000000100010000010000010001010010000100000000000000000000000
00000000000000000000000100111010101100111011001010000011100100111010000000010001100100000011101110111000100000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

__map__
00000000000000001b4b43534b43531b60606060606060608080808080807070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000809090909090909605a5a5a5a6c5a608080808080807070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000008090a0101010a09605a5a5a5a6c5a608080808080807070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000809010101010109606c6c5a5a5a5a608080808080807070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000809010101010109605a5a5a5a6c5a607070707070707070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000809010101010109605a5a5a5a6c5a607070707070707070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000000000000000008090a0101010a09605a6c6c5a5a5a607878787878787070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
0000000000000000000909090909090960606060606060607070707070707070000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2f2625232e2423225c5c5c5b5a5a5a5a0f0f0f0f0f0f0f706060606060606060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22232422252323225c5c5c5c5a5a5a5a0d0d0d0d0d0d0d706060606060606060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
24252523252223215c5c5c5c5a5a5a5a0b010a0a0a010b706060606060606060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
25222422242322215b5c5c5c5a595a5908080808080808706060606060606060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2e222422212121215a5a5a5a5858585808080808080808706060606060606060000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
23222423212020205a5a5a5958585858707070707070707060606060606060c1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
22222222212020205a5a5a5a585858587070707070707070b8b8b8b8b8b8b8b8000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
21232221212020205a5a5a59585858587070707070707070b8b8b8b8b8b8b8b8000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
62626262626262615858585858580000a0a8a0a0a0a0a8a05f5f5f5f5f5f5f5f000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
73737373737373618858585858580000a09890b090b098a05f5f5e5e5e5e5e5e000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
73737373737373618858585858580000a0a8a0a0a0a090a05f5f5d5d5d5d5d5d000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
61616161616161615858585888580000a090a0a0a0a0a8a05c5c5c5c5c5c5c5c000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
617a727a727a727a5858585888580000a0a8a0a0a0a090a05c5b5b5b5b5b5b5b000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
61727272727272725858585858580000a090a0a0a0a0a8a05c5b5a5a5a5a5a5a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
617a727a727a727a0000000000000000a098b090b09098a05c5b595959595959000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
61606060606060606000000000000000a0a8a0a0a0a0a8a05c5b585858585858000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d0d0d0d0d8717171cacacacacacacaca61616161616161610000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
d0d8d0d8d0717171cacacacacacacaca6158585858616161000a000000000a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7171717171717171cacacacacacacaca58585858585858610000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7171716060717971c8cacacacacacaca61616158585858610000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7171716060606071c8cacacacacacaca61616158586161610000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
6060606060606071c8cacacacacacaca61616161616161610000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7160606071717171c8cacacacacacaca5a5a5a5a5a5a6161000a000000000a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
7171b8b871717171c8cacacacacacaca5a5a5a5a5a5a61610000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010100001e0501a750000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010a00001d0501d0501b0501b0501805118052180421803218025186000c6000c6000c6000c600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011000000505005050030500305000051000520004200042000320003200012000150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010800001305016050180501803513000160000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010a00000f7500f750110000f750110000f7500000013754137501375013755130041100400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010200000b31300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010900000a5700a5701a3040c5700c570000000f5770f5770f5670f5570f5350f5150000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01080000347232b700307003472300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010100001d05000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
010c0000137141271111711107110f7110e7110d7110c7110c1130460313100131001210012100121001210011100111001110011100101001010010100101000f1000f1000f1000f1000e1000e1000e1000e100
01140000105230e405000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
01200000000500003100011070300c0500c0310c01107030000500003100011070300c0500c0310704007021000500003100011070300c0500c0310c01107030000500003100011070300c0500c0310704007021
011000201f100241002712026120241201f120181200010000100001002b120271202612024120201201f12027100261002712026120241201f120181200010000100001002b120271202612024120201201f120
011000201f110241102713026130241301f13018130131101f110241102b130271302613024130201301f1301f110241102713026130241301f13018130131101f110241102b130271302613024130201301f130
011000200c073000030c0531800318655180030c0530c0530c073000030c05318003186550c0530c043000430c073000030c0531800318655180030c0530c0530c073000030c05318003186550c0530c04300043
012000000305003031030110a0300f0500f0310f0110a0300305003031030110a0300f0500f0310f0400a0210305003031030110a0300f0500f0310f0110a0300305003031030110a0300f0500f0310f04000021
0110002022110271102a1302913027130221301b1301611022110271102e1302a1302913027130231302213022110271102a1302913027130221301b1301611022110271102e1302a13029130271302313022130
01100000180500c050130400c0501b5403f0001b51012000180400c040130400c0401b5403f0001b51012000180500c050130600c0601b5400c050180500c050180200c050130500c0501b5500c0001b5100c000
011000000c073000030c0031861518655180030c0030c0530c003000030c0531800318655000430c003000430c073000030c003186151865518625186150c0530c003000030c0531800318615186251863518655
012000002b0402b0402b0402b0422b0422b0422b0422c0402b0402b0422b0422b042270402704027042240402a0402a0402a0312a0312a0212a0212a0212a0112a0112a0112a0152a00522000220022200224000
011000001b0500f050160400f0511e532240031e512240051b0500f050160400f0511e532210001e512220001b0500f050160400f0511e5320f050160400f0511b0500f050160400f0511e532210001e51222000
011000002a0402a0402a0312a0312a0212a0212a0212a0112a0112a0112a0152a0052200022002220022400000000000000000000000000000000000000000000000000000000000000000000000000000000000
012000002b0402b0312b0312b0322b0322b0322b03232040300403003130032300322b0402b0312b0322b0322e0402e0412e0312e0312e0212e0212e0212e0112e0112e0112e0112e0153000230002300022b000
011000002e0402e0412e0312e0312e0212e0212e0212e0112e0112e0112e0112e0153000230002300022b00000000000000000000000000000000000000000000000000000000000000000000000000000000000
0110002000100001002a1202912027120221201b1200010000100001002e1202a1202912027120231202212000100001002a1202912027120221201b1200010000100001002e1202a12029120271202312022120
01200000181141812118131181351811418121181311813518114181211813118131181211812118111181151b1141b1211b1311b1351b1141b1211b1311b1351b1141b1211b1311b1311b1211b1211b1111b115
012000001b1141b1311b1211b1251f1141f1311f1211f1251311413131131311312113121131111311113115161141613116121161250a1140a1310a1210a1251611416131161311612116121161111611116115
01200000000500003100011070300c0500c0310c01107030000500003100011070300c0500c03100040000210305003031030110a0300f0500f0310f0110a0300305003031030110a0300f0500f031030400a021
012000000605006031060110d0301205012031120110d0100605006031060110d01012050120310d0400d0210305003031030110a0300f0500f0310f0110a0300305003031030110a0300f0500f0310a0400a021
012000002d0502d0412d0312c0402a0502a0412a0312a0212a0112a0112a015250402a0502a0412a0312503027050270412703127021270112701127011270150000000000000000000000000000000000000000
01200000211142113121121211252511425131251212512519114191311913119121191211911119111191151b1141b1311b1211b125161141613116121161250f1140f1310f1310f1210f1210f1110f1110f115
01200000000500003100011070300c0500c0310c011070300505005031050110c03011050110310504005021000500003100011070300c0500c0310c011070300005000031000110001000030000110001100000
01200000270502704127031260302405024041240312402124011240151d0401d0312205022041220311d0401f0501f0411f0311f0211f0111f0101f0101f0150000000000000000000000000000000000000000
0120000024114241312412124125271142713127121271251d1141d1311d1311d12127124271112711127115241142413124121241251f1141f1311f1211f1251811418131181311812118121181111811118115
012000002b0402b0402b0402b0422b0422b0422b0422c0402b0402b0422b0422b042270402704027042240402a0402a0422a04229030270302703027032230202202022020220202202022011220122201224020
012000002b0402b0312b0312b0322b0322b0322b03232040300403003130032300322b0402b0312b0322b0322e0402e0312e0322e03227040270402704031040300403003130030300323002230022300222b000
0120000018414184211f4441f41413414184141f4441f41418414184211f4441f414184140c4141f4441f4141b4141b42122444224140f4141b41422444224141b4141b42122444224141b4140f4142244422414
01200020185501855018540185421853218532185221b5501a5501a5501a552165501655016552165521355016550165501654016542165321653216522165121f5001c500245000050023500005001f50013500
012000001e4141e42121444214141e4141241421444214141e4141e42121444214141e4141241421444214141b4141b42122444224140f4141b41422444224141b4141b42122444224141b4140f4142244422414
0120000018414184211f4441f41413414184141f4441f414114141142118444184141141411414184441841418414184211f4441f41413414184141f4441f41418414184211f4441f41413414184141f4441f414
012000000c4140c4210f4440f414004040c4140f4440f4140c4140c4210f4440f4140c414004140f4440f4140f4140f4211244412414004040f41412444124140f4140f42112444124140f414034141244412414
0106000014054140501405516004160541605016055140051405414050140551b0001905419052190421904219032190321902219025000000000000000000000000000000000000000000000000000000000000
010600001804418040180451a0001a0541a0501a0501a055180541805018040180401803018035180001800000000000000000000000000000000000000000000000000000000000000000000000000000000000
__music__
01 0b494344
01 0b0c4344
01 0b0d4344
00 0b0d0e44
00 0f100e44
00 110b0e44
00 0f100e44
00 115b5012
00 115b130e
00 145b150e
00 115b160e
02 145b170e
01 11424344
00 11424344
00 14424344
00 14424344
00 11134344
00 14154344
00 11164344
00 14174344
01 110c4344
00 14184344
01 110d4344
00 14104344
00 110d1344
00 14101544
00 110d1644
00 14101744
00 110d430e
00 1410430e
00 1152430e
00 11524312
00 1152130e
00 1453150e
00 1152160e
00 1453170e
00 410d430e
02 410d430e
01 4619541a
00 1b19551a
00 1b5e135f
00 1b5e165f
00 1b5e131a
00 1b5e161a
00 1c1d1e44
00 1f202144
00 1b5e221a
00 1b5e231a
00 1c1d1e44
02 1f202144
01 1b424344
00 1b244344
01 1b242544
00 0b514344
00 1b581344
00 1b581644
00 1c1d5944
00 1f205a44
00 1b242244
00 1b242344
00 1c1d2644
00 1f202744
00 1b242844
02 1b242844

