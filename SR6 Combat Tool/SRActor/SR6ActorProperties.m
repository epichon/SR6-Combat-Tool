//
//  SR6ActorProperties.m
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
#import "SR6ActorProperties.h"

@implementation SR6Actor (CoreDataProperties)

+ (NSFetchRequest<SR6Actor *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"SR6Actor"];
}



@dynamic astralDice;
@dynamic astralInitiative;
@dynamic astralMajor;
@dynamic astralMinor;
@dynamic charName;
@dynamic currentDice;
@dynamic currentInit;
@dynamic currentMajor;
@dynamic currentMinor;
@dynamic currentMode;
@dynamic currentEdge;
@dynamic matrixCondition;
@dynamic matrixDice;
@dynamic matrixInitiative;
@dynamic matrixMajor;
@dynamic matrixMinor;
@dynamic notes;
@dynamic overflow;
@dynamic overwatchScore;
@dynamic physicalCondition;
@dynamic physicalDice;
@dynamic physicalInitiative;
@dynamic physicalMajor;
@dynamic physicalMinor;
@dynamic statusBackground;
@dynamic statusBackgroundDuration;
@dynamic statusBackgroundRating;
@dynamic statusBlinded;
@dynamic statusBlindedDuration;
@dynamic statusBlindedRating;
@dynamic statusBurning;
@dynamic statusBurningDuration;
@dynamic statusBurningRating;
@dynamic statusChilled;
@dynamic statusChilledDuration;
@dynamic statusConfused;
@dynamic statusConfusedDuration;
@dynamic statusConfusedRating;
@dynamic statusCorrossive;
@dynamic statusCorrossiveDuration;
@dynamic statusCorrossiveRating;
@dynamic statusCover;
@dynamic statusCoverDuration;
@dynamic statusCoverRating;
@dynamic statusDazed;
@dynamic statusDazedDuration;
@dynamic statusDeafened;
@dynamic statusDeafenedDuration;
@dynamic statusDeafenedRating;
@dynamic statusDisabledArm;
@dynamic statusDisabledArmDuration;
@dynamic statusDisabledArmRating;
@dynamic statusDisabledLeg;
@dynamic statusDisabledLegDuration;
@dynamic statusDisabledLegRating;
@dynamic statusFatigued;
@dynamic statusFatiguedDuration;
@dynamic statusFatiguedRating;
@dynamic statusFrightened;
@dynamic statusFrightenedDuration;
@dynamic statusHazed;
@dynamic statusHazedDuration;
@dynamic statusHobbled;
@dynamic statusHobbledDuration;
@dynamic statusImmobilized;
@dynamic statusImmobilizedDuration;
@dynamic statusInvisible;
@dynamic statusInvisibleDuration;
@dynamic statusInvisibleImproved;
@dynamic statusInvisibleImprovedDuration;
@dynamic statusInvisibleImprovedRating;
@dynamic statusInvisibleRating;
@dynamic statusMuted;
@dynamic statusMutedDuration;
@dynamic statusNauseated;
@dynamic statusNauseatedDuration;
@dynamic statusNoise;
@dynamic statusNoiseDuration;
@dynamic statusNoiseRating;
@dynamic statusOffBalance;
@dynamic statusOffBalanceDuration;
@dynamic statusPanicked;
@dynamic statusPanickedDuration;
@dynamic statusPetrified;
@dynamic statusPetrifiedDuration;
@dynamic statusPoisoned;
@dynamic statusPoisonedDuration;
@dynamic statusPoisonedRating;
@dynamic statusProne;
@dynamic statusProneDuration;
@dynamic statusSilent;
@dynamic statusSilentDuration;
@dynamic statusSilentImproved;
@dynamic statusSilentImprovedDuration;
@dynamic statusSilentImprovedRating;
@dynamic statusSilentRating;
@dynamic statusStilled;
@dynamic statusStilledDuration;
@dynamic statusWet;
@dynamic statusWetDuration;
@dynamic statusZapped;
@dynamic statusZappedDuration;
@dynamic stunCondition;
@dynamic boxesPhysical;
@dynamic boxesStun;
@dynamic hitsPerception;
@dynamic hitsStealth;
@dynamic hitsSurprise;
@dynamic attrEdge;
@dynamic currentSpeed;
@dynamic actorType;
@dynamic rating;
@dynamic attrDrain;
@dynamic matrixAttack;
@dynamic matrixDataProcessing;
@dynamic matrixSleaze;
@dynamic matrixFirewall;
@dynamic picture;
@dynamic detailString;
@dynamic move;
@dynamic defenseRating;
@dynamic matrixDeviceRating;
@dynamic skillAstral;
@dynamic skillAstralSpec;
@dynamic vehHandling;
@dynamic vehAccel;
@dynamic vehSpeedInterval;
@dynamic vehTopSpeed;
@dynamic vehBody;
@dynamic vehArmor;
@dynamic vehPilot;
@dynamic vehSensor;
@dynamic vehSeat;
@dynamic skillAthletics;
@dynamic skillAthleticsSpec;
@dynamic skillBiotech;
@dynamic skillBiotechSpec;
@dynamic skillCloseCombat;
@dynamic skillCloseCombatSpec;
@dynamic skillCon;
@dynamic skillConSpec;
@dynamic skillConjuring;
@dynamic skillConjuringSpec;
@dynamic skillCracking;
@dynamic skillCrackingSpec;
@dynamic skillElectronics;
@dynamic skillElectronicsSpec;
@dynamic skillEnchanting;
@dynamic skillEnchantingSpec;
@dynamic skillEngineering;
@dynamic skillEngineeringSpec;
@dynamic skillExoticWeapons;
@dynamic skillExoticWeaponsSpec;
@dynamic skillFirearms;
@dynamic skillFirearmsSpec;
@dynamic skillInfluence;
@dynamic skillInfluenceSpec;
@dynamic skillOutdoors;
@dynamic skillOutdoorsSpec;
@dynamic skillPerception;
@dynamic skillPerceptionSpec;
@dynamic skillPilot;
@dynamic skillPilotSpec;
@dynamic skillSorcery;
@dynamic skillSorcerySpec;
@dynamic skillStealth;
@dynamic skillStealthSpec;
@dynamic skillTasking;
@dynamic skillTaskingSpec;
@dynamic skillOther;
@dynamic skillOtherSpec;
@dynamic boxesMatrix;
@dynamic attrBody;
@dynamic attrAgility;
@dynamic attrReaction;
@dynamic attrStrength;
@dynamic attrWillpower;
@dynamic attrLogic;
@dynamic attrIntuition;
@dynamic attrCharisma;
@dynamic attrMagic;
@dynamic attrEssence;
@dynamic actorCategory;
@dynamic metatype;
@dynamic initiateGrade;
@dynamic submersionGrade;
@dynamic mentorUUID;
@dynamic mentorInfo;
@dynamic mentorOption;
@dynamic professionalRating;
@dynamic services;
@dynamic commlink;
@dynamic cyberdeck;
@dynamic cyberjack;
@dynamic rcc;
@dynamic matrixAttackRating;
@dynamic matrixDefenseRating;

@dynamic adeptPowers;
@dynamic augs;
@dynamic complexForms;
@dynamic echoes;
@dynamic metamagics;
@dynamic powers;
@dynamic programs;
@dynamic qualities;
@dynamic spells;
@dynamic weapons;

@end
