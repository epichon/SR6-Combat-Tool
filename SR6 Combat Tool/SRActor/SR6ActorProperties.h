//
//  SR6ActorProperties.h
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2019/9/01.
//  Copyright © 2020 Ed Pichon.
/* This file is part of the SRCombatTool.

SRCombatTool is free software: you can redistribute it and/or modify
it under the terms of the Creative Commons 4.0 license - BY-NC-SA.

SRCombatTool is distributed in the hope that it will be useful,
but without any warranty.

*/

#import "SR6Actor.h"
#import "SR6Constants.h"

@class SR6ActorAdeptPower;
@class SR6ActorAug;
@class SR6ActorComplexForm;
@class SR6ActorEcho;
@class SR6ActorMetamagic;
@class SR6ActorPower;
@class SR6ActorProgram;
@class SR6ActorQuality;
@class SR6ActorSpell;
@class SR6ActorWeapon;
@class SR6Mentor;

NS_ASSUME_NONNULL_BEGIN

@interface SR6Actor (CoreDataProperties)

+ (NSFetchRequest<SR6Actor *> *)fetchRequest;


@property (nonatomic) int16_t astralDice;
@property (nonatomic) int16_t astralInitiative;
@property (nonatomic) int16_t astralMajor;
@property (nonatomic) int16_t astralMinor;
@property (nullable, nonatomic, copy) NSString *charName;
@property (nonatomic) int16_t currentDice;
@property (nonatomic) int16_t currentInit;
@property (nonatomic) int16_t currentMajor;
@property (nonatomic) int16_t currentMinor;
@property (nonatomic) sr6Mode currentMode;
@property (nonatomic) int16_t currentEdge;
@property (nonatomic) int16_t matrixCondition;
@property (nonatomic) int16_t matrixDice;
@property (nonatomic) int16_t matrixInitiative;
@property (nonatomic) int16_t matrixMajor;
@property (nonatomic) int16_t matrixMinor;
@property (nullable, nonatomic, copy) NSString *notes;
@property (nonatomic) int16_t overflow;
@property (nonatomic) int16_t overwatchScore;
@property (nonatomic) int16_t physicalCondition;
@property (nonatomic) int16_t physicalDice;
@property (nonatomic) int16_t physicalInitiative;
@property (nonatomic) int16_t physicalMajor;
@property (nonatomic) int16_t physicalMinor;
@property (nonatomic) BOOL statusBackground;
@property (nonatomic) int16_t statusBackgroundDuration;
@property (nonatomic) int16_t statusBackgroundRating;
@property (nonatomic) BOOL statusBlinded;
@property (nonatomic) int16_t statusBlindedDuration;
@property (nonatomic) int16_t statusBlindedRating;
@property (nonatomic) BOOL statusBurning;
@property (nonatomic) int16_t statusBurningDuration;
@property (nonatomic) int16_t statusBurningRating;
@property (nonatomic) BOOL statusChilled;
@property (nonatomic) int16_t statusChilledDuration;
@property (nonatomic) BOOL statusConfused;
@property (nonatomic) int16_t statusConfusedDuration;
@property (nonatomic) int16_t statusConfusedRating;
@property (nonatomic) BOOL statusCorrossive;
@property (nonatomic) int16_t statusCorrossiveDuration;
@property (nonatomic) int16_t statusCorrossiveRating;
@property (nonatomic) BOOL statusCover;
@property (nonatomic) int16_t statusCoverDuration;
@property (nonatomic) int16_t statusCoverRating;
@property (nonatomic) BOOL statusDazed;
@property (nonatomic) int16_t statusDazedDuration;
@property (nonatomic) BOOL statusDeafened;
@property (nonatomic) int16_t statusDeafenedDuration;
@property (nonatomic) int16_t statusDeafenedRating;
@property (nonatomic) BOOL statusDisabledArm;
@property (nonatomic) int16_t statusDisabledArmDuration;
@property (nonatomic) int16_t statusDisabledArmRating;
@property (nonatomic) BOOL statusDisabledLeg;
@property (nonatomic) int16_t statusDisabledLegDuration;
@property (nonatomic) int16_t statusDisabledLegRating;
@property (nonatomic) BOOL statusFatigued;
@property (nonatomic) int16_t statusFatiguedDuration;
@property (nonatomic) int16_t statusFatiguedRating;
@property (nonatomic) BOOL statusFrightened;
@property (nonatomic) int16_t statusFrightenedDuration;
@property (nonatomic) BOOL statusHazed;
@property (nonatomic) int16_t statusHazedDuration;
@property (nonatomic) BOOL statusHobbled;
@property (nonatomic) int16_t statusHobbledDuration;
@property (nonatomic) BOOL statusImmobilized;
@property (nonatomic) int16_t statusImmobilizedDuration;
@property (nonatomic) BOOL statusInvisible;
@property (nonatomic) int16_t statusInvisibleDuration;
@property (nonatomic) BOOL statusInvisibleImproved;
@property (nonatomic) int16_t statusInvisibleImprovedDuration;
@property (nonatomic) int16_t statusInvisibleImprovedRating;
@property (nonatomic) int16_t statusInvisibleRating;
@property (nonatomic) BOOL statusMuted;
@property (nonatomic) int16_t statusMutedDuration;
@property (nonatomic) BOOL statusNauseated;
@property (nonatomic) int16_t statusNauseatedDuration;
@property (nonatomic) BOOL statusNoise;
@property (nonatomic) int16_t statusNoiseDuration;
@property (nonatomic) int16_t statusNoiseRating;
@property (nonatomic) BOOL statusOffBalance;
@property (nonatomic) int16_t statusOffBalanceDuration;
@property (nonatomic) BOOL statusPanicked;
@property (nonatomic) int16_t statusPanickedDuration;
@property (nonatomic) BOOL statusPetrified;
@property (nonatomic) int16_t statusPetrifiedDuration;
@property (nonatomic) BOOL statusPoisoned;
@property (nonatomic) int16_t statusPoisonedDuration;
@property (nonatomic) int16_t statusPoisonedRating;
@property (nonatomic) BOOL statusProne;
@property (nonatomic) int16_t statusProneDuration;
@property (nonatomic) BOOL statusSilent;
@property (nonatomic) int16_t statusSilentDuration;
@property (nonatomic) BOOL statusSilentImproved;
@property (nonatomic) int16_t statusSilentImprovedDuration;
@property (nonatomic) int16_t statusSilentImprovedRating;
@property (nonatomic) int16_t statusSilentRating;
@property (nonatomic) BOOL statusStilled;
@property (nonatomic) int16_t statusStilledDuration;
@property (nonatomic) BOOL statusWet;
@property (nonatomic) int16_t statusWetDuration;
@property (nonatomic) BOOL statusZapped;
@property (nonatomic) int16_t statusZappedDuration;
@property (nonatomic) int16_t stunCondition;
@property (nonatomic) int16_t boxesPhysical;
@property (nonatomic) int16_t boxesStun;
@property (nonatomic) int16_t hitsPerception;
@property (nonatomic) int16_t hitsStealth;
@property (nonatomic) int16_t hitsSurprise;
@property (nonatomic) int16_t attrEdge;
@property (nonatomic) int32_t currentSpeed;
@property (nonatomic) int16_t actorType;
@property (nonatomic) int16_t rating;
@property (nonatomic) int16_t attrDrain;
@property (nonatomic) int16_t matrixAttack;
@property (nonatomic) int16_t matrixDataProcessing;
@property (nonatomic) int16_t matrixSleaze;
@property (nonatomic) int16_t matrixFirewall;
@property (nullable, nonatomic, retain) NSData *picture;
@property (nullable, nonatomic, retain) NSData *detailString;
@property (nullable, nonatomic, copy) NSString *move;
@property (nonatomic) int16_t defenseRating;
@property (nonatomic) int16_t matrixDeviceRating;
@property (nonatomic) int16_t skillAstral;
@property (nullable, nonatomic, copy) NSString *skillAstralSpec;
@property (nullable, nonatomic, copy) NSString *vehHandling;
@property (nonatomic) int16_t vehAccel;
@property (nonatomic) int16_t vehSpeedInterval;
@property (nonatomic) int16_t vehTopSpeed;
@property (nonatomic) int16_t vehBody;
@property (nonatomic) int16_t vehArmor;
@property (nonatomic) int16_t vehPilot;
@property (nonatomic) int16_t vehSensor;
@property (nonatomic) int16_t vehSeat;
@property (nonatomic) int16_t skillAthletics;
@property (nullable, nonatomic, copy) NSString *skillAthleticsSpec;
@property (nonatomic) int16_t skillBiotech;
@property (nullable, nonatomic, copy) NSString *skillBiotechSpec;
@property (nonatomic) int16_t skillCloseCombat;
@property (nullable, nonatomic, copy) NSString *skillCloseCombatSpec;
@property (nonatomic) int16_t skillCon;
@property (nullable, nonatomic, copy) NSString *skillConSpec;
@property (nonatomic) int16_t skillConjuring;
@property (nullable, nonatomic, copy) NSString *skillConjuringSpec;
@property (nonatomic) int16_t skillCracking;
@property (nullable, nonatomic, copy) NSString *skillCrackingSpec;
@property (nonatomic) int16_t skillElectronics;
@property (nullable, nonatomic, copy) NSString *skillElectronicsSpec;
@property (nonatomic) int16_t skillEnchanting;
@property (nullable, nonatomic, copy) NSString *skillEnchantingSpec;
@property (nonatomic) int16_t skillEngineering;
@property (nullable, nonatomic, copy) NSString *skillEngineeringSpec;
@property (nonatomic) int16_t skillExoticWeapons;
@property (nullable, nonatomic, copy) NSString *skillExoticWeaponsSpec;
@property (nonatomic) int16_t skillFirearms;
@property (nullable, nonatomic, copy) NSString *skillFirearmsSpec;
@property (nonatomic) int16_t skillInfluence;
@property (nullable, nonatomic, copy) NSString *skillInfluenceSpec;
@property (nonatomic) int16_t skillOutdoors;
@property (nullable, nonatomic, copy) NSString *skillOutdoorsSpec;
@property (nonatomic) int16_t skillPerception;
@property (nullable, nonatomic, copy) NSString *skillPerceptionSpec;
@property (nonatomic) int16_t skillPilot;
@property (nullable, nonatomic, copy) NSString *skillPilotSpec;
@property (nonatomic) int16_t skillSorcery;
@property (nullable, nonatomic, copy) NSString *skillSorcerySpec;
@property (nonatomic) int16_t skillStealth;
@property (nullable, nonatomic, copy) NSString *skillStealthSpec;
@property (nonatomic) int16_t skillTasking;
@property (nullable, nonatomic, copy) NSString *skillTaskingSpec;
@property (nonatomic) int16_t skillOther;
@property (nullable, nonatomic, copy) NSString *skillOtherSpec;
@property (nonatomic) int16_t boxesMatrix;
@property (nonatomic) int16_t attrBody;
@property (nonatomic) int16_t attrAgility;
@property (nonatomic) int16_t attrReaction;
@property (nonatomic) int16_t attrStrength;
@property (nonatomic) int16_t attrWillpower;
@property (nonatomic) int16_t attrLogic;
@property (nonatomic) int16_t attrIntuition;
@property (nonatomic) int16_t attrCharisma;
@property (nonatomic) int16_t attrMagic;
@property (nonatomic) float attrEssence;
@property (nonatomic) int16_t actorCategory;
@property (nonatomic) int16_t initiateGrade;
@property (nonatomic) int16_t submersionGrade;
@property (nonatomic) sr6Metatype metatype;
@property (nonatomic) int16_t professionalRating;
@property (nullable, nonatomic, copy) NSUUID *mentorUUID;
@property (nullable, nonatomic, retain) NSArray *mentorInfo;
@property (nullable, nonatomic, copy) NSString *mentorOption;
@property (nonatomic) int16_t services;
@property (nonatomic) int16_t commlink;
@property (nonatomic) int16_t cyberdeck;
@property (nonatomic) int16_t cyberjack;
@property (nonatomic) int16_t rcc;
@property (nonatomic) int16_t matrixDefenseRating;
@property (nonatomic) int16_t matrixAttackRating;

@property (nullable, nonatomic, retain) NSSet<SR6ActorAdeptPower *> *adeptPowers;
@property (nullable, nonatomic, retain) NSSet<SR6ActorAug *> *augs;
@property (nullable, nonatomic, retain) NSSet<SR6ActorComplexForm *> *complexForms;
@property (nullable, nonatomic, retain) NSSet<SR6ActorEcho *> *echoes;
@property (nullable, nonatomic, retain) NSSet<SR6ActorMetamagic *> *metamagics;
@property (nullable, nonatomic, retain) NSSet<SR6ActorPower *> *powers;
@property (nullable, nonatomic, retain) NSSet<SR6ActorProgram *> *programs;
@property (nullable, nonatomic, retain) NSSet<SR6ActorQuality *> *qualities;
@property (nullable, nonatomic, retain) NSSet<SR6ActorSpell *> *spells;
@property (nullable, nonatomic, retain) NSSet<SR6ActorWeapon *> *weapons;


- (void)addAdeptPowersObject:(SR6ActorAdeptPower *)value;
- (void)removeAdeptPowersObject:(SR6ActorAdeptPower *)value;
- (void)addAdeptPowers:(NSSet<SR6ActorAdeptPower *> *)values;
- (void)removeAdeptPowers:(NSSet<SR6ActorAdeptPower *> *)values;

- (void)addAugsObject:(SR6ActorAug *)value;
- (void)removeAugsObject:(SR6ActorAug *)value;
- (void)addAugs:(NSSet<SR6ActorAug *> *)values;
- (void)removeAugs:(NSSet<SR6ActorAug *> *)values;

- (void)addComplexFormsObject:(SR6ActorComplexForm *)value;
- (void)removeComplexFormsObject:(SR6ActorComplexForm *)value;
- (void)addComplexForms:(NSSet<SR6ActorComplexForm *> *)values;
- (void)removeComplexForms:(NSSet<SR6ActorComplexForm *> *)values;

- (void)addEchoesObject:(SR6ActorEcho *)value;
- (void)removeEchoesObject:(SR6ActorEcho *)value;
- (void)addEchoes:(NSSet<SR6ActorEcho *> *)values;
- (void)removeEchoes:(NSSet<SR6ActorEcho *> *)values;

- (void)addMetamagicsObject:(SR6ActorMetamagic *)value;
- (void)removeMetamagicsObject:(SR6ActorMetamagic *)value;
- (void)addMetamagics:(NSSet<SR6ActorMetamagic *> *)values;
- (void)removeMetamagics:(NSSet<SR6ActorMetamagic *> *)values;

- (void)addPowersObject:(SR6ActorPower *)value;
- (void)removePowersObject:(SR6ActorPower *)value;
- (void)addPowers:(NSSet<SR6ActorPower *> *)values;
- (void)removePowers:(NSSet<SR6ActorPower *> *)values;

- (void)addProgramsObject:(SR6ActorProgram *)value;
- (void)removeProgramsObject:(SR6ActorProgram *)value;
- (void)addPrograms:(NSSet<SR6ActorProgram *> *)values;
- (void)removePrograms:(NSSet<SR6ActorProgram *> *)values;

- (void)addQualitiesObject:(SR6ActorQuality *)value;
- (void)removeQualitiesObject:(SR6ActorQuality *)value;
- (void)addQualities:(NSSet<SR6ActorQuality *> *)values;
- (void)removeQualities:(NSSet<SR6ActorQuality *> *)values;

- (void)addSpellsObject:(SR6ActorSpell *)value;
- (void)removeSpellsObject:(SR6ActorSpell *)value;
- (void)addSpells:(NSSet<SR6ActorSpell *> *)values;
- (void)removeSpells:(NSSet<SR6ActorSpell *> *)values;

- (void)addWeaponsObject:(SR6ActorWeapon *)value;
- (void)removeWeaponsObject:(SR6ActorWeapon *)value;
- (void)addWeapons:(NSSet<SR6ActorWeapon *> *)values;
- (void)removeWeapons:(NSSet<SR6ActorWeapon *> *)values;

@end

NS_ASSUME_NONNULL_END
