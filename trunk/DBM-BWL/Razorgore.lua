local mod	= DBM:NewMod("Razorgore", "DBM-BWL", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision$"):sub(12, -3))
mod:SetCreatureID(12435, 99999)--Bogus detection to prevent invalid kill detection if razorgore happens to die in phase 1
mod:SetModelID(10115)
mod:SetMinSyncRevision(168)
mod:RegisterCombat("yell", L.YellPull)
mod:SetWipeTime(45)--guesswork

mod:RegisterEventsInCombat(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"CHAT_MSG_MONSTER_EMOTE",
	"UNIT_DIED"
)

local warnPhase2			= mod:NewPhaseAnnounce(2)
local warnConflagration		= mod:NewTargetAnnounce(23023)

local timerConflagration	= mod:NewTargetTimer(10, 23023)
local timerAddsSpawn		= mod:NewTimer(47, "TimerAddsSpawn", 19879)--Only for start of adds, not adds after the adds heh.

mod.vb.phase = 1

function mod:OnCombatStart(delay)
	timerAddsSpawn:Start()
	self.vb.phase = 1
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 23023 and args:IsDestTypePlayer() then
		warnConflagration:Show(args.destName)
		timerConflagration:Start(args.destName)
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args.spellId == 23023 then
		timerConflagration:Start(args.destName)
	end
end

--For some reason this no longer works
function mod:CHAT_MSG_MONSTER_EMOTE(msg)
	if msg == L.Phase2Emote or msg:find(L.Phase2Emote) then
		self:SendSync("Phase2")
	end
end

function mod:UNIT_DIED(args)
	local cid = self:GetCIDFromGUID(args.destGUID)
	if cid == 12435 and self.vb.phase == 2 then--Only trigger kill for unit_died if he dies in phase 2, otherwise it's an auto wipe.
		DBM:EndCombat(self)
	end
end

function mod:OnSync(msg)
	if not self:IsInCombat() then return end
	if msg == "Phase2" then
		warnPhase2:Show()
		self.vb.phase = 2
	end
end
