local mod	= DBM:NewMod(575, "DBM-Party-BC", 6, 261)
local L		= mod:GetLocalizedStrings()

mod:SetRevision(("$Revision$"):sub(12, -3))
mod:SetCreatureID(17798)
mod:SetEncounterID(1944)

mod:RegisterCombat("combat")

mod:RegisterEventsInCombat(
	"SPELL_CAST_SUCCESS 31543",
	"SPELL_AURA_APPLIED 31534"
)

local WarnChannel   = mod:NewSpellAnnounce("ej6001", 2, 31543)

local specWarnReflect	= mod:NewSpecialWarningReflect(31534, "-Melee")

local timerReflect  = mod:NewBuffActiveTimer(8, 31534)

function mod:SPELL_CAST_SUCCESS(args)
	if args.spellId == 31543 then
		WarnChannel:Show()
	end
end

function mod:SPELL_AURA_APPLIED(args)
	if args.spellId == 31534 then
		timerReflect:Start(args.destName)
		specWarnReflect:Show(args.destName)
	end
end
