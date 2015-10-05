local mod = DBM:NewMod(550, "DBM-Party-BC", 15, 254)
local L = mod:GetLocalizedStrings()

mod:SetRevision(("$Revision$"):sub(12, -3))

mod:SetCreatureID(20886)
mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS 36512",
	"SPELL_AURA_APPLIED 35759"
)

local warnKnockaway			= mod:NewSpellAnnounce(36512, 2)

local specwarnFelFireShock	= mod:NewSpecialWarningDispel(35759, "Healer")

local voiceKnockaway		= mod:NewVoice(36512, "Melee")--carefly

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 36512 then
		warnKnockaway:Show()
		voiceKnockaway:Play("carefly")
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 35759 then
		specwarnFelFireShock:Show(args.destName)
	end
end
