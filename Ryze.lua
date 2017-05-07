
local ver = "0.01"

if GetObjectName(GetMyHero()) ~= "Ryze" then return end

require('MixLib')
require("DamageLib")
require("OpenPredict")


function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        PrintChat('<font color = "#00FFFF">New version found! ' .. data)
        PrintChat('<font color = "#00FFFF">Downloading update, please wait...')
        DownloadFileAsync('https://raw.githubusercontent.com/allwillburn/Ryze/master/Ryze.lua', SCRIPT_PATH .. 'Ryze.lua', function() PrintChat('<font color = "#00FFFF">Ryze Update Complete, please 2x F6!') return end)
    else
        PrintChat('<font color = "#00FFFF">No new Ryze updates found!')
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/allwillburn/Ryze/master/Ryze.version", AutoUpdate)


GetLevelPoints = function(unit) return GetLevel(unit) - (GetCastLevel(unit,0)+GetCastLevel(unit,1)+GetCastLevel(unit,2)+GetCastLevel(unit,3)) end
local SetDCP, SkinChanger = 0

local RyzeMenu = Menu("Ryze", "Ryze")

RyzeMenu:SubMenu("Combo", "Combo")

RyzeMenu.Combo:Boolean("Q", "Use Q in combo", true)
RyzeMenu.Combo:Slider("Qpred", "Q Hit Chance", 3,0,10,1)
RyzeMenu.Combo:Boolean("W", "Use W in combo", true)
RyzeMenu.Combo:Boolean("E", "Use E in combo", false)
RyzeMenu.Combo:Boolean("R", "Use R in Combo", true)
RyzeMenu.Combo:Boolean("Gunblade", "Use Gunblade", true)
RyzeMenu.Combo:Boolean("Randuins", "Use Randuins", true)


RyzeMenu:SubMenu("AutoMode", "AutoMode")
RyzeMenu.AutoMode:Boolean("Level", "Auto level spells", false)
RyzeMenu.AutoMode:Boolean("Ghost", "Auto Ghost", false)
RyzeMenu.AutoMode:Boolean("Q", "Auto Q", false)
RyzeMenu.AutoMode:Slider("Qpred", "Q Hit Chance", 3,0,10,1)
RyzeMenu.AutoMode:Boolean("W", "Auto W", false)
RyzeMenu.AutoMode:Boolean("E", "Auto E", false)
RyzeMenu.AutoMode:Boolean("R", "Auto R", false)



RyzeMenu:SubMenu("AutoFarm", "AutoFarm")
RyzeMenu.AutoFarm:Boolean("Q", "Auto Q", false)
RyzeMenu.AutoFarm:Boolean("W", "Auto W", false)
RyzeMenu.AutoFarm:Boolean("E", "Auto E Always", false)




RyzeMenu:SubMenu("LaneClear", "LaneClear")
RyzeMenu.LaneClear:Boolean("Q", "Use Q", true)
RyzeMenu.LaneClear:Boolean("W", "Use W", true)
RyzeMenu.LaneClear:Boolean("E", "Use E", true)


RyzeMenu:SubMenu("Harass", "Harass")
RyzeMenu.Harass:Boolean("Q", "Use Q", true)
RyzeMenu.Harass:Boolean("W", "Use W", true)

RyzeMenu:SubMenu("KillSteal", "KillSteal")
RyzeMenu.KillSteal:Boolean("Q", "KS w Q", true)
RyzeMenu.KillSteal:Slider("Qpred", "Q Hit Chance", 3,0,10,1)
RyzeMenu.KillSteal:Boolean("W", "KS w W", true)
RyzeMenu.KillSteal:Boolean("E", "KS w E", true)



RyzeMenu:SubMenu("AutoIgnite", "AutoIgnite")
RyzeMenu.AutoIgnite:Boolean("Ignite", "Ignite if killable", true)

RyzeMenu:SubMenu("Drawings", "Drawings")
RyzeMenu.Drawings:Boolean("DQ", "Draw Q Range", true)

RyzeMenu:SubMenu("SkinChanger", "SkinChanger")
RyzeMenu.SkinChanger:Boolean("Skin", "UseSkinChanger", true)
RyzeMenu.SkinChanger:Slider("SelectedSkin", "Select A Skin:", 1, 0, 4, 1, function(SetDCP) HeroSkinChanger(myHero, SetDCP)  end, true)

OnTick(function (myHero)
	      local target = GetCurrentTarget()
        
        local Gunblade = GetItemSlot(myHero, 3146)       
        local Cutlass = GetItemSlot(myHero, 3144)
        local Randuins = GetItemSlot(myHero, 3143)
        local RyzeQ = {range = 860, delay = 0.26 , speed = 1615, radius = 60}
        
	--AUTO LEVEL UP
	if RyzeMenu.AutoMode.Level:Value() then

			spellorder = {_E, _W, _Q, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
			if GetLevelPoints(myHero) > 0 then
				LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
			end
	end



        
        --Harass
          if Mix:Mode() == "Harass" then
            if RyzeMenu.Harass.Q:Value() and Ready(_Q) and ValidTarget(target, 1000) then		
                                      CastSkillShot(_Q, target)
                                
            end

            if RyzeMenu.Harass.W:Value() and Ready(_W) and ValidTarget(target, 615) then
				       CastTargetSpell(target, _W)
            end     
          end





	--COMBO
	  if Mix:Mode() == "Combo" then
        

            if RyzeMenu.Combo.Randuins:Value() and Randuins > 0 and Ready(Randuins) and ValidTarget(target, 500) then
			           CastSpell(Randuins)
            end

            if RyzeMenu.Combo.Gunblade:Value() and Gunblade > 0 and Ready(Gunblade) and ValidTarget(target, 615) then
			           CastTargetSpell(target, Gunblade)
            end
			
	    if RyzeMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 1000) then
                 local QPred = GetPrediction(target,RyzeQ)
                 if QPred.hitChance > (RyzeMenu.Combo.Qpred:Value() * 0.1) then
                           CastSkillShot(_Q, QPred.castPos)
                 end
            end	
                   
            if RyzeMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 615) then
			             CastTargetSpell(target,_E)
	          end

            if RyzeMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 1000) then
                 local QPred = GetPrediction(target,RyzeQ)
                 if QPred.hitChance > (RyzeMenu.Combo.Qpred:Value() * 0.1) then
                           CastSkillShot(_Q, QPred.castPos)
                 end
            end	
				    
                  
            if RyzeMenu.Combo.W:Value() and Ready(_W) and ValidTarget(target, 615) then                                  
                               CastTargetSpell(target, _W)
                       end

            if RyzeMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 1000) then
                 local QPred = GetPrediction(target,RyzeQ)
                 if QPred.hitChance > (RyzeMenu.Combo.Qpred:Value() * 0.1) then
                           CastSkillShot(_Q, QPred.castPos)
                 end
            end	

                   
            if RyzeMenu.Combo.E:Value() and Ready(_E) and ValidTarget(target, 615) then
			             CastTargetSpell(target,_E)
	          end

            if RyzeMenu.Combo.Q:Value() and Ready(_Q) and ValidTarget(target, 1000) then
                 local QPred = GetPrediction(target,RyzeQ)
                 if QPred.hitChance > (RyzeMenu.Combo.Qpred:Value() * 0.1) then
                           CastSkillShot(_Q, QPred.castPos)
                 end
            end	
                       
	    	    
            if RyzeMenu.Combo.R:Value() and Ready(_R) and ValidTarget(target, 1750) and (EnemiesAround(myHeroPos(), 1750) >= RyzeMenu.Combo.RX:Value()) then          
                            CastSkillShot(_R,RPred.castPos)
                   end
        
            end
			
	    			
          end





         --AUTO IGNITE
	for _, enemy in pairs(GetEnemyHeroes()) do
		
		if GetCastName(myHero, SUMMONER_1) == 'SummonerDot' then
			 Ignite = SUMMONER_1
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end

		elseif GetCastName(myHero, SUMMONER_2) == 'SummonerDot' then
			 Ignite = SUMMONER_2
			if ValidTarget(enemy, 600) then
				if 20 * GetLevel(myHero) + 50 > GetCurrentHP(enemy) + GetHPRegen(enemy) * 3 then
					CastTargetSpell(enemy, Ignite)
				end
			end
		end

	end





    --KillSteal

        for _, enemy in pairs(GetEnemyHeroes()) do
                
                if IsReady(_Q) and ValidTarget(enemy, 1000) and RyzeMenu.KillSteal.Q:Value() and GetHP(enemy) < getdmg("Q",enemy) then
                       local QPred = GetPrediction(target,RyzeQ)
                       if QPred.hitChance > (RyzeMenu.KillSteal.Qpred:Value() * 0.1) then
                                 CastSkillShot(_Q, QPred.castPos)
                       end
            end

                
		         if IsReady(_W) and ValidTarget(enemy, 615) and RyzeMenu.KillSteal.W:Value() and GetHP(enemy) < getdmg("W",enemy) then                 
                                  CastTargetSpell(target, _W)
                    end
             
			
			
		         if IsReady(_E) and ValidTarget(enemy, 615) and RyzeMenu.KillSteal.E:Value() and GetHP(enemy) < getdmg("E",enemy) then
		                      CastTargetSpell(target,_E)
  
                end

              
            
              end




    
      --Laneclear	
      if Mix:Mode() == "LaneClear" then
      	  for _,closeminion in pairs(minionManager.objects) do
	        if RyzeMenu.LaneClear.Q:Value() and Ready(_Q) and ValidTarget(closeminion, 1000) then
	        	CastSkillShot(_Q, closeminion)
                end

                if RyzeMenu.LaneClear.W:Value() and Ready(_W) and ValidTarget(closeminion, 615) then
	        	CastTargetSpell(target, _W)
	        end

                if RyzeMenu.LaneClear.E:Value() and Ready(_E) and ValidTarget(closeminion, 615) then
	        	CastTargetSpell(closeminion, _E)
	        end

               
          end
      end




      --Auto on minions
          for _, minion in pairs(minionManager.objects) do
      			
      			   	
              if RyzeMenu.AutoFarm.Q:Value() and Ready(_Q) and ValidTarget(minion, 1000) and GetCurrentHP(minion) < CalcDamage(myHero,minion,QDmg,Q) then
                  CastSkillShot(_Q, minion)
              end

              if RyzeMenu.AutoFarm.W:Value() and Ready(_W) and ValidTarget(minion, 615) and GetCurrentHP(minion) < CalcDamage(myHero,minion,WDmg,W) then
                  CastTargetSpell(minion, _W)
              end

              if RyzeMenu.AutoFarm.E:Value() and Ready(_E) and ValidTarget(minion, 615) and GetCurrentHP(minion) < CalcDamage(myHero,minion,EDmg,E) then
                  CastTargetSpell(minion, _E)
              end
		
	      		
			
          end


      


      
      --AutoMode
      
        if RyzeMenu.AutoMode.Q:Value() and ValidTarget(target, 1000) then        
               local QPred = GetPrediction(target,RyzeQ)
               if QPred.hitChance > (RyzeMenu.AutoMode.Qpred:Value() * 0.1) then
                         CastSkillShot(_Q, QPred.castPos)
               end
       end

        
        if RyzeMenu.AutoMode.W:Value() and ValidTarget(target, 615) then                     
                         CastTargetSpell(target, _W)
               end
        
    
        if RyzeMenu.AutoMode.E:Value() then        
	           if Ready(_E) and ValidTarget(target, 615) then
		                CastTargetSpell(target,_E)
	           end
        end
        
                
	--AUTO GHOST
	if RyzeMenu.AutoMode.Ghost:Value() then
		if GetCastName(myHero, SUMMONER_1) == "SummonerHaste" and Ready(SUMMONER_1) then
			CastSpell(SUMMONER_1)
		elseif GetCastName(myHero, SUMMONER_2) == "SummonerHaste" and Ready(SUMMONER_2) then
			CastSpell(Summoner_2)
		end
	end
end)




OnDraw(function (myHero)
        
         if RyzeMenu.Drawings.DQ:Value() then
		DrawCircle(GetOrigin(myHero), 1000, 0, 150, GoS.Black)
	end

end)



local function SkinChanger()
	if RyzeMenu.SkinChanger.UseSkinChanger:Value() then
		if SetDCP >= 0  and SetDCP ~= GlobalSkin then
			HeroSkinChanger(myHero, SetDCP)
			GlobalSkin = SetDCP
		end
        end
end


print('<font color = "#01DF01"><b>Ryze</b> <font color = "#01DF01">by <font color = "#01DF01"><b>Allwillburn</b> <font color = "#01DF01">Loaded!')
