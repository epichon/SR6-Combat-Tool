//
//  SR6Constants.h
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/15.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//

#ifndef SR6Constants_h
#define SR6Constants_h


#pragma mark Generic Enums

typedef NS_ENUM(int16_t,sr6Activation) {
    kActivationPassive,
    kActivationMinor,
    kActivationMajor,
    kActivationSpecial
};

#define SR6_ACTIVATION_PASSIVE_SHORT @"Pass"
#define SR6_ACTIVATION_PASSIVE_LONG @"Passive"
#define SR6_ACTIVATION_AUTO_SHORT @"Auto" // For critter powers, it's termed "Auto", rather than passive.
#define SR6_ACTIVATION_AUTO_LONG @"Automatic" // For critter powers, it's termed "Auto", rather than passive.
#define SR6_ACTIVATION_MINOR_SHORT @"Minor"
#define SR6_ACTIVATION_MINOR_LONG @"Minor"
#define SR6_ACTIVATION_MAJOR_SHORT @"Major"
#define SR6_ACTIVATION_MAJOR_LONG @"Major"
#define SR6_ACTIVATION_SPECIAL_SHORT @"Spec"
#define SR6_ACTIVATION_SPECIAL_LONG @"Special"

typedef NS_ENUM(int16_t,sr6AvailLetter) {
    kAvailLegal,
    kAvailLicense,
    kAvailIllegal,
    kAvailSpecial
};

#define SR6_AVAIL_LEGAL_SHORT @""
#define SR6_AVAIL_LEGAL_LONG @"Legal"
#define SR6_AVAIL_LICENSE_SHORT @"(L)"
#define SR6_AVAIL_LICENSE_LONG @"License"
#define SR6_AVAIL_ILLEGAL_SHORT @"(I)"
#define SR6_AVAIL_ILLEGAL_LONG @"Illegal"
#define SR6_AVAIL_SPECIAL_SHORT @"(S)"
#define SR6_AVAIL_SPECIAL_LONG @"Special"


typedef NS_ENUM(int16_t,sr6Duration) { // Duplicate of CF duration
    kDurationAlways,
    kDurationInstant,
    kDurationSustained,
    kDurationPermananent,
    kDurationLimited,
    kDurationSpecial
};

#define SR6_DURATION_ALWAYS_SHORT @"A"
#define SR6_DURATION_ALWAYS_LONG @"Always"
#define SR6_DURATION_INSTANT_SHORT @"I"
#define SR6_DURATION_INSTANT_LONG @"Instant"
#define SR6_DURATION_SUSTAINED_SHORT @"S"
#define SR6_DURATION_SUSTAINED_LONG @"Sustained"
#define SR6_DURATION_PERMANENT_SHORT @"P"
#define SR6_DURATION_PERMANENT_LONG @"Permanent"
#define SR6_DURATION_LIMITED_SHORT @"L"
#define SR6_DURATION_LIMITED_LONG @"Limited"
#define SR6_DURATION_SPECIAL_SHORT @"Spec"
#define SR6_DURATION_SPECIAL_LONG @"Special"

typedef NS_ENUM(int16_t,sr6Metatype) {
    kMetatypeHuman,
    kMetatypeDwarf,
    kMetatypeElf,
    kMetatypeOrk,
    kMetatypeTroll,
    kMetatypeOther
};

#define SR6_METATYPE_HUMAN @"Human"
#define SR6_METATYPE_DWARF @"Dwarf"
#define SR6_METATYPE_ELF @"Elf"
#define SR6_METATYPE_ORK @"Ork"
#define SR6_METATYPE_TROLL @"Troll"
#define SR6_METATYPE_OTHER @"Other"

// The string definitions are in the modeValues array in Documents.m
typedef NS_ENUM(int16_t, sr6Mode) {
    kModePhysical,
    kModeMatrixCold,
    kModeMatrixHot,
    kModeAstral
};

#define SR6_MODE_PHYSICAL_SHORT @"Phys"
#define SR6_MODE_PHYSICAL_LONG @"Physical"
#define SR6_MODE_MATRIX_COLD_SHORT @"Mtrx(C)"
#define SR6_MODE_MATRIX_COLD_LONG @"Matrix (Cold)"
#define SR6_MODE_MATRIX_HOT_SHORT @"Mtrx(H)"
#define SR6_MODE_MATRIX_HOT_LONG @"Matrix (Hot)"
#define SR6_MODE_ASTRAL_SHORT @"Astrl"
#define SR6_MODE_ASTRAL_LONG @"Astral"

typedef NS_ENUM(int16_t,sr6PowerType) {
    kPowerTypePhysical,
    kPowerTypeMana,
    kPowerTypeSpecial
};

#define SR6_POWER_TYPE_PHYSICAL_SHORT @"P"
#define SR6_POWER_TYPE_PHYSICAL_LONG @"Physical"
#define SR6_POWER_TYPE_MANA_SHORT @"M"
#define SR6_POWER_TYPE_MANA_LONG @"Mana"
#define SR6_POWER_TYPE_SPECIAL_SHORT @"S"
#define SR6_POWER_TYPE_SPECIAL_LONG @"Special"


typedef NS_ENUM(int16_t,sr6Range) {
    kRangeSelf,
    kRangeTouch,
    kRangeLOS,
    kRangeLOSArea,
    kRangeSpecial
};

#define SR6_RANGE_SELF_SHORT @"Slf"
#define SR6_RANGE_SELF_LONG @"Self"
#define SR6_RANGE_TOUCH_SHORT @"Tch"
#define SR6_RANGE_TOUCH_LONG @"Touch"
#define SR6_RANGE_LOS_SHORT @"LOS"
#define SR6_RANGE_LOS_LONG @"LOS"
#define SR6_RANGE_LOSA_SHORT @"LOS(A)"
#define SR6_RANGE_LOSA_LONG @"LOS (A)"
#define SR6_RANGE_SPECIAL_SHORT @"Spec"
#define SR6_RANGE_SPECIAL_LONG @"Special"

typedef NS_ENUM(int16_t, sr6Specialization) {
    kSpecializationNone,
    kSpecializationSpecialization,
    kSpecializationExpertise
};

#define SR6_SPEC_NONE_SHORT @""
#define SR6_SPEC_NONE_LONG @""
#define SR6_SPEC_SPECIALIZATION_SHORT @"Spec"
#define SR6_SPEC_SPECIALIZATION_LONG @"Speciazliation"
#define SR6_SPEC_EXPERTISE_SHORT @"Exp"
#define SR6_SPEC_EXPERTISE_LONG @"Expertise"

#pragma mark SR6Object Enums

typedef NS_ENUM(int16_t,sr6AugCategory) {
    kAugCatHeadware,
    kAugCatEyeware,
    kAugCatEarware,
    kAugCatBodyware,
    kAugCatCyberlimb,
    kAugCatBioware,
    kAugCatCulturedBioware,
    kAugCatGeneware,
    kAugCatNanoware,
    kAugCatOther
};

#define SR6_AUG_CAT_HEADWARE_SHORT @"Head"
#define SR6_AUG_CAT_HEADWARE_LONG @"Headware"
#define SR6_AUG_CAT_EYEWARE_SHORT @"Eye"
#define SR6_AUG_CAT_EYEWARE_LONG @"Eyeware"
#define SR6_AUG_CAT_EARWARE_SHORT @"Ear"
#define SR6_AUG_CAT_EARWARE_LONG @"Earware"
#define SR6_AUG_CAT_BODYWARE_SHORT @"Body"
#define SR6_AUG_CAT_BODYWARE_LONG @"Bodyware"
#define SR6_AUG_CAT_CYBERLIMB_SHORT @"Limb"
#define SR6_AUG_CAT_CYBERLIMB_LONG @"Cyberlimb"
#define SR6_AUG_CAT_BIOWARE_SHORT @"Bio"
#define SR6_AUG_CAT_BIOWARE_LONG @"Bioware"
#define SR6_AUG_CAT_CULTURED_BIOWARE_SHORT @"C Bio"
#define SR6_AUG_CAT_CULTURED_BIOWARE_LONG @"Cultured Bioware"
#define SR6_AUG_CAT_GENEWARE_SHORT @"Gene"
#define SR6_AUG_CAT_GENEWARE_LONG @"Geneware"
#define SR6_AUG_CAT_NANOWARE_SHORT @"Nano"
#define SR6_AUG_CAT_NANOWARE_LONG @"Nanoware"
#define SR6_AUG_CAT_OTHER_SHORT @"Oth"
#define SR6_AUG_CAT_OTHER_LONG @"Other"

typedef NS_ENUM(int16_t,sr6AugGrade) {
    kAugGradeNormal,
    kAugGradeUsed,
    kAugGradeAlpha,
    kAugGradeBeta,
    kAugGradeDelta,
    kAugGradeGamma,
    kAugGradeOther
};

#define SR6_AUG_GRADE_NORMAL_SHORT @""
#define SR6_AUG_GRADE_NORMAL_LONG @"Normal"
#define SR6_AUG_GRADE_USED_SHORT @"u"
#define SR6_AUG_GRADE_USED_LONG @"Used"
#define SR6_AUG_GRADE_ALPHA_SHORT @"ɑ"
#define SR6_AUG_GRADE_ALPHA_LONG @"Alpha"
#define SR6_AUG_GRADE_BETA_SHORT @"β"
#define SR6_AUG_GRADE_BETA_LONG @"Beta"
#define SR6_AUG_GRADE_DELTA_SHORT @"Δ"
#define SR6_AUG_GRADE_DELTA_LONG @"Delta"
#define SR6_AUG_GRADE_GAMMA_SHORT @"Ɣ"
#define SR6_AUG_GRADE_GAMMA_LONG @"Gamma"
#define SR6_AUG_GRADE_OTHER_SHORT @"O"
#define SR6_AUG_GRADE_OTHER_LONG @"Other"

typedef NS_ENUM(int16_t,sr6PowerCategory) {
    kPowerCatCritterPower,
    kPowerCatCritterWeakness,
    kPowerCatSpritePower,
    kPowerCatOther
};

#define SR6_POWER_CAT_POWER_SHORT @"Power"
#define SR6_POWER_CAT_POWER_LONG @"Critter Power"
#define SR6_POWER_CAT_WEAKNESS_SHORT @"Weak"
#define SR6_POWER_CAT_WEAKNESS_LONG @"Critter Weakness"
#define SR6_POWER_CAT_SPRITE_SHORT @"Sprite"
#define SR6_POWER_CAT_SPRITE_LONG @"Sprite Power"
#define SR6_POWER_CAT_OTHER_SHORT @"Oth"
#define SR6_POWER_CAT_OTHER_LONG @"Other"

typedef NS_ENUM(int16_t,sr6ProgramCat) {
    kProgramCatBasic,
    kProgramCatHacking,
    kProgramCatAutosoft,
    kProgramCatOther
};

#define SR6_PROGRAM_CAT_BASIC_SHORT @"B"
#define SR6_PROGRAM_CAT_BASIC_LONG @"Basic"
#define SR6_PROGRAM_CAT_HACKING_SHORT @"H"
#define SR6_PROGRAM_CAT_HACKING_LONG @"Hacking"
#define SR6_PROGRAM_CAT_AUTOSOFT_SHORT @"AS"
#define SR6_PROGRAM_CAT_AUTOSOFT_LONG @"Autosoft"
#define SR6_PROGRAM_CAT_OTHER_SHORT @"O"
#define SR6_PROGRAM_CAT_OTHER_LONG @"Other"

typedef NS_ENUM(int16_t,sr6SpellCategory) {
    kSpellCatDirectCombat,
    kSpellCatIndirectCombat,
    kSpellCatDetection,
    kSpellCatHealth,
    kSpellCatIllusion,
    kSpellCatManipulation
};

#define SR6_SPELL_CAT_DIRECT_COMBAT_SHORT @"Cmbt (D)"
#define SR6_SPELL_CAT_DIRECT_COMBAT_LONG @"Combat (Direct)"
#define SR6_SPELL_CAT_INDIRECT_COMBAT_SHORT @"Cmbt (I)"
#define SR6_SPELL_CAT_INDIRECT_COMBAT_LONG @"Combat (Indirect)"
#define SR6_SPELL_CAT_DETECTION_SHORT @"Det"
#define SR6_SPELL_CAT_DETECTION_LONG @"Detection"
#define SR6_SPELL_CAT_HEALTH_SHORT @"Hlth"
#define SR6_SPELL_CAT_HEALTH_LONG @"Health"
#define SR6_SPELL_CAT_ILLUSION_SHORT @"Ill"
#define SR6_SPELL_CAT_ILLUSION_LONG @"Illusion"
#define SR6_SPELL_CAT_MANIPULATION_SHORT @"Manip"
#define SR6_SPELL_CAT_MANIPULATION_LONG @"Manipulation"

typedef NS_ENUM(int16_t,sr6SpellDamage) {
    kSpellDmgNone,
    kSpellDmgStun,
    kSpellDmgPhysical,
    kSpellDmgStunSpecial,
    kSpellDmgPhysicalSpecial
};

#define SR6_SPELL_DAMAGE_NONE_SHORT @"NA"
#define SR6_SPELL_DAMAGE_NONE_LONG @"NA"
#define SR6_SPELL_DAMAGE_STUN_SHORT @"S"
#define SR6_SPELL_DAMAGE_STUN_LONG @"Stun"
#define SR6_SPELL_DAMAGE_PHYSICAL_SHORT @"P"
#define SR6_SPELL_DAMAGE_PHYSICAL_LONG @"Physical"
#define SR6_SPELL_DAMAGE_STUN_SPECIAL_SHORT @"S,Spec"
#define SR6_SPELL_DAMAGE_STUN_SPECIAL_LONG @"S, Special"
#define SR6_SPELL_DAMAGE_PHYSICAL_SPECIAL_SHORT @"P,Spec"
#define SR6_SPELL_DAMAGE_PHYSICAL_SPECIAL_LONG @"P, Special"

typedef NS_ENUM(int16_t, sr6WeaponCategory) {
    kWeaponCatBlade,
    kWeaponCatClub,
    kWeaponCatMelee,
    kWeaponCatThrown,
    kWeaponCatTaser,
    kWeaponCatHoldOut,
    kWeaponCatLightPistol,
    kWeaponCatMachinePistol,
    kWeaponCatHeavyPistol,
    kWeaponCatSMG,
    kWeaponCatShotgun,
    kWeaponCatRifle,
    kWeaponCatMachineGun,
    kWeaponCatAssaultCannon,
    kWeaponCatLauncher,
    kWeaponCatRocket,
    kWeaponCatMissile,
    kWeaponCatGrenade,
    kWeaponCatSpecial
};

#define SR6_WEAPON_CAT_BLADE_SHORT @"Bld"
#define SR6_WEAPON_CAT_BLADE_LONG @"Blade"
#define SR6_WEAPON_CAT_CLUB_SHORT @"Clb"
#define SR6_WEAPON_CAT_CLUB_LONG @"Club"
#define SR6_WEAPON_CAT_MELEE_SHORT @"Melee"
#define SR6_WEAPON_CAT_MELEE_LONG @"Melee"
#define SR6_WEAPON_CAT_THROWN_SHORT @"Thrwn"
#define SR6_WEAPON_CAT_THROWN_LONG @"Thrown"
#define SR6_WEAPON_CAT_TASER_SHORT @"Tsr"
#define SR6_WEAPON_CAT_TASER_LONG @"Taser"
#define SR6_WEAPON_CAT_HOLD_OUT_SHORT @"HO"
#define SR6_WEAPON_CAT_HOLD_OUT_LONG @"Hold-Out"
#define SR6_WEAPON_CAT_LIGHT_PISTOL_SHORT @"LP"
#define SR6_WEAPON_CAT_LIGHT_PISTOL_LONG @"Light Pistol"
#define SR6_WEAPON_CAT_MACHINE_PISTOL_SHORT @"MP"
#define SR6_WEAPON_CAT_MACHINE_PISTOL_LONG @"Machine Pistol"
#define SR6_WEAPON_CAT_HEAVY_PISTOL_SHORT @"HP"
#define SR6_WEAPON_CAT_HEAVY_PISTOL_LONG @"Heavy Pistol"
#define SR6_WEAPON_CAT_SMG_SHORT @"SMG"
#define SR6_WEAPON_CAT_SMG_LONG @"Submachine Gun"
#define SR6_WEAPON_CAT_SHOTGUN_SHORT @"Shtgn"
#define SR6_WEAPON_CAT_SHOTGUN_LONG @"Shotgun"
#define SR6_WEAPON_CAT_RIFLE_SHORT @"Rfl"
#define SR6_WEAPON_CAT_RIFLE_LONG @"Rifle"
#define SR6_WEAPON_CAT_MACHINE_GUN_SHORT @"MG"
#define SR6_WEAPON_CAT_MACHINE_GUN_LONG @"Machine Gun"
#define SR6_WEAPON_CAT_ASSAULT_CANNON_SHORT @"AC"
#define SR6_WEAPON_CAT_ASSAULT_CANNON_LONG @"Assault Cannon"
#define SR6_WEAPON_CAT_LAUNCHER_SHORT @"Lnch"
#define SR6_WEAPON_CAT_LAUNCHER_LONG @"Launcher"
#define SR6_WEAPON_CAT_ROCKET_SHORT @"Rckt"
#define SR6_WEAPON_CAT_ROCKET_LONG @"Rocket"
#define SR6_WEAPON_CAT_MISSILE_SHORT @"Mssl"
#define SR6_WEAPON_CAT_MISSILE_LONG @"Missile"
#define SR6_WEAPON_CAT_GRENADE_SHORT @"Grnd"
#define SR6_WEAPON_CAT_GRENADE_LONG @"Grenade"
#define SR6_WEAPON_CAT_SPECIAL_SHORT @"Spec"
#define SR6_WEAPON_CAT_SPECIAL_LONG @"Special"

typedef NS_ENUM(int16_t,sr6WeaponAmmoContainer) {
    kWeaponAmmoContainerBelt,
    kWeaponAmmoContainerBreak,
    kWeaponAmmoContainerClip,
    kWeaponAmmoContainerCylinder,
    kWeaponAmmoContainerDrum,
    kWeaponAmmoContainerMagazine,
    kWeaponAmmoContainerMissile,
    kWeaponAmmoContainerMuzzle,
    kWeaponAmmoContainerSpecial
};

#define SR6_AMMO_CONTAINER_BELT_SHORT @"(b)"
#define SR6_AMMO_CONTAINER_BELT_LONG @"Belt"
#define SR6_AMMO_CONTAINER_BREAK_SHORT @"(br)"
#define SR6_AMMO_CONTAINER_BREAK_LONG @"Break"
#define SR6_AMMO_CONTAINER_CLIP_SHORT @"(c)"
#define SR6_AMMO_CONTAINER_CLIP_LONG @"Clip"
#define SR6_AMMO_CONTAINER_CYLINDER_SHORT @"(cy)"
#define SR6_AMMO_CONTAINER_CYLINDER_LONG @"Cylinder"
#define SR6_AMMO_CONTAINER_DRUM_SHORT @"(dr)"
#define SR6_AMMO_CONTAINER_DRUM_LONG @"Drum"
#define SR6_AMMO_CONTAINER_MAGAZINE_SHORT @"(m)"
#define SR6_AMMO_CONTAINER_MAGAZINE_LONG @"Magazine"
#define SR6_AMMO_CONTAINER_MISSILE_SHORT @"(ml)"
#define SR6_AMMO_CONTAINER_MISSILE_LONG @"Missile"
#define SR6_AMMO_CONTAINER_MUZZLE_SHORT @"(z)"
#define SR6_AMMO_CONTAINER_MUZZLE_LONG @"Muzzle"
#define SR6_AMMO_CONTAINER_SPECIAL_SHORT @"(spc)"
#define SR6_AMMO_CONTAINER_SPECIAL_LONG @"Special"

typedef NS_ENUM(int16_t, sr6WeaponDamageType) {
    kWeaponDamageTypeStun,
    kWeaponDamageTypePhysical,
    kWeaponDamageTypeBlinded,
    kWeaponDamageTypeSpecial
};

#define SR6_WEAPON_DMG_STUN_SHORT @"S"
#define SR6_WEAPON_DMG_STUN_LONG @"Stun"
#define SR6_WEAPON_DMG_PHYSICAL_SHORT @"P"
#define SR6_WEAPON_DMG_PHYSICAL_LONG @"Physical"
#define SR6_WEAPON_DMG_BLINDED_SHORT @"Bl"
#define SR6_WEAPON_DMG_BLINDED_LONG @"Blind"
#define SR6_WEAPON_DMG_SPECIAL_SHORT @"Spec"
#define SR6_WEAPON_DMG_SPEICAL_LONG @"Special"


typedef NS_ENUM (int16_t, sr6WeaponAmmoType) {
    kWeaponAmmoTypeNone,
    kWeaponAmmoTypeRegular,
    kWeaponAmmoTypeAPDS,
    kWeaponAmmoTypeExplosive,
    kWeaponAmmoTypeFlechette,
    kWeaponAmmoTypeGel,
    kWeaponAmmoTypeStickNShock,
    kWeaponAmmoTypeSpecial,
    kWeaponAmmoTypeHandLoaded,
    kWeaponAmmoTypeMatchGrade
};

#define SR6_WEAPON_AMMO_NONE_SHORT @"-NA-"
#define SR6_WEAPON_AMMO_NONE_LONG @"-None-"
#define SR6_WEAPON_AMMO_REGULAR_SHORT @"Reg"
#define SR6_WEAPON_AMMO_REGULAR_LONG @"Regular"
#define SR6_WEAPON_AMMO_APDS_SHORT @"APDS"
#define SR6_WEAPON_AMMO_APDS_LONG @"APDS"
#define SR6_WEAPON_AMMO_EXPLOSIVE_SHORT @"Ex"
#define SR6_WEAPON_AMMO_EXPLOSIVE_LONG @"Explosive"
#define SR6_WEAPON_AMMO_FLECHETTE_SHORT @"Fl"
#define SR6_WEAPON_AMMO_FLECHETTE_LONG @"Flechette"
#define SR6_WEAPON_AMMO_GEL_SHORT @"Gel"
#define SR6_WEAPON_AMMO_GEL_LONG @"Gel"
#define SR6_WEAPON_AMMO_STICK_N_SHOCK_SHORT @"SnS"
#define SR6_WEAPON_AMMO_STICK_N_SHOCK_LONG @"Stick-n-Shock"
#define SR6_WEAPON_AMMO_SPECIAL_SHORT @"Spec"
#define SR6_WEAPON_AMMO_SPECIAL_LONG @"Special"
#define SR6_WEAPON_AMMO_HAND_LOADED_SHORT @"Hndld"
#define SR6_WEAPON_AMMO_HAND_LOADED_LONG @"Handloaded"
#define SR6_WEAPON_AMMO_MATCH_GRADE_SHORT @"Mtc-Gr"
#define SR6_WEAPON_AMMO_MATCH_GRADE_LONG @"Match-Grade"


typedef NS_ENUM (int16_t, sr6WeaponFiringMode) {
    kWeaponFiringModeSingleShot,
    kWeaponFiringModeSemiAutomatic,
    kWeaponFiringModeBurstNarrow,
    kWeaponFiringModeBurstWide,
    kWeaponFiringModeFullAuto,
    kWeaponFiringModeOther,
    kWeaponFiringModeNA
};

#define SR6_FIRING_MODE_SS_SHORT @"SS"
#define SR6_FIRING_MODE_SS_LONG @"Single-Shot"
#define SR6_FIRING_MODE_SA_SHORT @"SA"
#define SR6_FIRING_MODE_SA_LONG @"Semi-Automatic"
#define SR6_FIRING_MODE_BF_SHORT @"BF"
#define SR6_FIRING_MODE_BF_LONG @"Burst"
#define SR6_FIRING_MODE_BN_SHORT @"B-N"
#define SR6_FIRING_MODE_BN_LONG @"Burst (Narrow)"
#define SR6_FIRING_MODE_BW_SHORT @"B-W"
#define SR6_FIRING_MODE_BW_LONG @"Burst (Wide)"
#define SR6_FIRING_MODE_FA_SHORT @"FA"
#define SR6_FIRING_MODE_FA_LONG @"Full Auto"
#define SR6_FIRING_MODE_OTHER_SHORT @"Oth"
#define SR6_FIRING_MODE_OTHER_LONG @"Other"
#define SR6_FIRING_MODE_SPECIAL_SHORT @"Spec"
#define SR6_FIRING_MODE_SPECIAL_LONG @"Special"
#define SR6_FIRING_MODE_NA_SHORT @"-NA-"
#define SR6_FIRING_MODE_NA_LONG @"-NA-"

// Some contants that can be used elsewhere. I could have stuck to string values, but the system programmer in me cringes at using strings so much,
// and because I sometimes use the abbreviation, and sometimes I use the full word.
#define SR6_ATTR_NULL -1
#define SR6_ATTR_BODY 0
#define SR6_ATTR_AGILITY 1
#define SR6_ATTR_REACTION 2
#define SR6_ATTR_STRENGTH 3
#define SR6_ATTR_WILLPOWER 4
#define SR6_ATTR_LOGIC 5
#define SR6_ATTR_INTUITION 6
#define SR6_ATTR_CHARISMA 7
#define SR6_ATTR_EDGE 8
#define SR6_ATTR_MAGIC 9
#define SR6_ATTR_RESONANCE 10
#define SR6_ATTR_RATING 11
#define SR6_ATTR_DEVICE_RATING 12
#define SR6_ATTR_ATTACK 13
#define SR6_ATTR_SLEAZE 14
#define SR6_ATTR_DATA_PROCESSING 15
#define SR6_ATTR_FIREWALL 16
#define SR6_ATTR_PILOT 17
#define SR6_ATTR_SENSOR 18
#define SR6_ATTR_DRAIN 19

#define SR6_SKILL_NULL -1
#define SR6_SKILL_ASTRAL 0
#define SR6_SKILL_ATHLETICS 1
#define SR6_SKILL_BIOTECH 2
#define SR6_SKILL_CLOSE_COMBAT 3
#define SR6_SKILL_CON 4
#define SR6_SKILL_CONJURING 5
#define SR6_SKILL_CRACKING 6
#define SR6_SKILL_ELECTRONICS 7
#define SR6_SKILL_ENCHANTING 8
#define SR6_SKILL_ENGINEERING 9
#define SR6_SKILL_EXOTIC_WEAPONS 10
#define SR6_SKILL_FIREARMS 11
#define SR6_SKILL_INFLUENCE 12
#define SR6_SKILL_OUTDOORS 13
#define SR6_SKILL_PERCEPTION 14
#define SR6_SKILL_PILOT 15
#define SR6_SKILL_SORCERY 16
#define SR6_SKILL_STEALTH 17
#define SR6_SKILL_TASKING 18
#define SR6_SKILL_OTHER 19
#define SR6_SKILL_CRACKING_RES 20
#define SR6_SKILL_ELECTRONICS_RES 21
#define SR6_SKILL_CRACKING_RES_2 22
#define SR6_SKILL_ELECTRONICS_RES_2 23
#define SR6_SKILL_SORCERY_2 24
#define SR6_SKILL_CRACKING_2 25
#define SR6_SKILL_ELECTRONICS_2 26
#define SR6_SKILL_MATRIX_PERCEPTION 27

#define SR6_STATUS_BACKGROUND @"☁️ Background"
#define SR6_STATUS_BLINDED @"👀 Blinded"
#define SR6_STATUS_BURNING @"🔥 Burning"
#define SR6_STATUS_CHILLED @"🥶 Chilled"
#define SR6_STATUS_CONFUSED @"😕 Confused"
#define SR6_STATUS_CORROSSIVE @"⚠️ Corrossive"
#define SR6_STATUS_COVER @"🐢 Cover"
#define SR6_STATUS_DAZED @"🤪 Dazed"
#define SR6_STATUS_DEAFENED @"🙉 Deafened"
#define SR6_STATUS_DISABLED_ARM @"💪 Disabled (Arm)"
#define SR6_STATUS_DISABLED_LEG @"🦵 Disabled (Leg)"
#define SR6_STATUS_FATIGUED @"😴 Fatigued"
#define SR6_STATUS_FRIGHTENED @"😨 Frightened"
#define SR6_STATUS_HAZED @"👻 Hazed"
#define SR6_STATUS_HOBBLED @"🕸 Hobbled"
#define SR6_STATUS_IMMOBILIZED @"🚷 Immobilized"
#define SR6_STATUS_INVISIBLE @"👻 Invisible"
#define SR6_STATUS_INVISIBLE_IMP  @"👻 Invis (Imp)"
#define SR6_STATUS_MUTED @"🔕 Muted"
#define SR6_STATUS_NAUSEATED @"🤮 Nauseated"
#define SR6_STATUS_NOISE @"🔊 Noise"
#define SR6_STATUS_OFF_BALANCE @"🥴 Off-Balance"
#define SR6_STATUS_PANICKED @"😱 Panicked"
#define SR6_STATUS_PETRIFIED @"🗿 Petrified"
#define SR6_STATUS_POISONED @"☠️ Poisoned"
#define SR6_STATUS_PRONE @"🛌 Prone"
#define SR6_STATUS_SILENT @"🔇 Silent"
#define SR6_STATUS_SILENT_IMP @"🔇 Silent (Imp)"
#define SR6_STATUS_STILLED @"🛑 Stilled"
#define SR6_STATUS_WET @"💧 Wet"
#define SR6_STATUS_ZAPPED @"⚡️ Zapped"

// These are constants for the various symbols used to mark PCs, Grunts, Lts, etc.
#define SR6_ACTIVE_LEAD @"▶︎▶︎ "
#define SR6_ACTIVE_LEAD_LENGTH 5
#define SR6_ACTIVE_TRAIL @" ◀︎◀︎"
#define SR6_ACTIVE_TRAIL_LENGTH 5

#define SR6_PC_LEAD @"❖ "
#define SR6_PC_LEAD_LENGTH 2
#define SR6_PC_TRAIL @" ❖"
#define SR6_PC_TRAIL_LENGTH 2

#define SR6_GRUNT_LEAD @"⦿ "
#define SR6_GRUNT_LEAD_LENGTH 2
#define SR6_GRUNT_TRAIL @" ⦿"
#define SR6_GRUNT_TRAIL_LENGTH 2

#define SR6_LT_LEAD @"⦿⦿ "
#define SR6_LT_LEAD_LENGTH 3
#define SR6_LT_TRAIL @" ⦿⦿"
#define SR6_LT_TRAIL_LENGTH 3

// Note - the array that uses this in the Document.m init method.
#define ACTOR_TYPE_NORMAL 0
#define ACTOR_TYPE_AWAKENED 1
#define ACTOR_TYPE_SPIRIT 2
#define ACTOR_TYPE_CRITTER 3
#define ACTOR_TYPE_IC 4
#define ACTOR_TYPE_AGENT 5
#define ACTOR_TYPE_DRONE 6
#define ACTOR_TYPE_VEHICLE 7
#define ACTOR_TYPE_TECHNOMANCER 8
#define ACTOR_TYPE_SPRITE 9
#define ACTOR_TYPE_TECHNOCRITTER 10

// Note - the array that uses this in the Document.m init method.
#define DRAIN_ATTR_WILLPOWER 0
#define DRAIN_ATTR_LOGIC 1
#define DRAIN_ATTR_INTUITION 2
#define DRAIN_ATTR_CHARISMA 3

#define ACTOR_CATEGORY_NORMAL 0
#define ACTOR_CATEGORY_PC 1
#define ACTOR_CATEGORY_GRUNT 2
#define ACTOR_CATEGORY_LIEUTENANT 3

#define SR6_RATING_LEAD @" [R: "
#define SR6_RATING_LEAD_LENGTH 5
#define SR6_FORCE_LEAD @" [F: "
#define SR6_FORCE_LEAD_LENGTH 5
#define SR6_LEVEL_LEAD @" [L: "
#define SR6_LEVEL_LEAD_LENGTH 5
#define SR6_PR_LEAD @" [PR: "
#define SR6_PR_LEAD_LENGTH 6
#define SR6_RATING_TAIL @"]"
#define SR6_RATING_TAIL_LENGTH 1


#endif /* SR6Constants */
