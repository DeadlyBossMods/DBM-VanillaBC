local mod	= DBM:NewMod("Shazzrah", "DBM-MC", 1)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision: 1 $"):sub(12, -3))
mod:SetCreatureID(12264)
mod:RegisterCombat("combat")

mod:RegisterEvents(
	"SPELL_AURA_APPLIED",
	"SPELL_AURA_REMOVED",
	"SPELL_CAST_SUCCESS"
)

local warnCurse		= mod:NewSpellAnnounce(19713)
local warnGrounding	= mod:NewSpellAnnounce(19714)
local warnCntrSpell	= mod:NewSpellAnnounce(19715)
local warnBlink		= mod:NewSpellAnnounce(21655)

local timerGrounding	= mod:NewBuffActiveTimer(19714)

function mod:OnCombatStart(delay)
end

function mod:SPELL_AURA_APPLIED(args)
	if args:IsSpellID(19714) and self:IsInCombat() then
		warnGrounding:Show()
		timerGrounding:Start()
	end
end

function mod:SPELL_AURA_REMOVED(args)
	if args:IsSpellID(19714) then
		timerGrounding:Cancel()
	end
end

function mod:SPELL_CAST_SUCCESS(args)
	if args:IsSpellID(19713) and self:IsInCombat() then
		warnCurse:Show()
	elseif args:IsSpellID(19715) and self:IsInCombat() then
		warnCntrSpell:Show()
	elseif args:IsSpellID(21655) and self:IsInCombat() then
		warnBlink:Show()
	end
end