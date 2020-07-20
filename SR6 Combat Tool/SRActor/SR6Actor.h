//
//  SR6Actor.h
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
/*
 
 This is the interface to the managed object - the SR Actor. The data is mostly handled by the coredata data model, but the "smarts" are in here. Along with a
 few variables that aren't stored in the object, as they are either dynamically calculated (dmg modifier) or ephemeral (activeActor);
 
 The complicated part is handling the statuses, which are stored in the data object is individual values, but are generally needed in the tool as an array of objects.
 So there's a fair amount of code that builds the array for us. There's probably a much more efficient way to do this, but it works. Status symbols are handled by
 unicode emoji characters - some aren't great fits, but doing custom images was going to be a pain.
 
 For copy/paste purposes, the code that puts the object into a dictionary (and reads it out of one as well) is here too. The usual NSCoder route doesn't work
 for CoreData manage dobjects, so I use an NSDictionary. There are some bugs when decoding NSDictionary objects (in Apple's code), so I have had to implement
 some workarounds.
 
 This code contains as most of the rules enforcement, such as there is.
 
 This class has gotten increasingly complicated, and it's probably a bit bloated. I'd refactor, but I'm lazy.
 
 */


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SR6Constants.h"

@class SR6ActorAdeptPower;
@class SR6ActorAug;
@class SR6ActorComplexForm;
@class SR6ActorEcho;
@class SR6Mentor;
@class SR6ActorMetamagic;
@class SR6ActorPower;
@class SR6ActorProgram;
@class SR6ActorQuality;
@class SR6ActorSpell;
@class SR6ActorWeapon;

NS_ASSUME_NONNULL_BEGIN

@class SRDice;

static SRDice * _roller;

@interface SR6Actor : NSManagedObject {
    NSMutableArray *_statusArray;
    NSMutableString *_statusString;

    NSArray *_adeptPowersArray;
    NSArray *_augsArray;
    NSArray *_complexFormsArray;
    NSArray *_echoesArray;
    NSArray *_metamagicsArray;
    NSArray *_powersArray;
    NSArray *_programsArray;
    NSArray *_qualitiesArray;
    NSArray *_spellsArray;
    NSArray *_weaponsArray;
    
    int16_t oldMetatype;
}

@property (nonatomic, readwrite, nullable) NSArray *adeptPowersArray;
@property (nonatomic, readwrite, nullable) NSArray *augsArray;
@property (nonatomic, readwrite, nullable) NSArray *complexFormsArray;
@property (nonatomic, readwrite, nullable) NSArray *echoesArray;
@property (nonatomic, readwrite, nullable) SR6Mentor * mentor;
@property (nonatomic, readwrite, nullable) NSArray *metamagicsArray;
@property (nonatomic, readwrite, nullable) NSArray *powersArray;
@property (nonatomic, readwrite, nullable) NSArray *programsArray;
@property (nonatomic, readwrite, nullable) NSArray *qualitiesArray;
@property (nonatomic, readwrite, nullable) NSArray *spellsArray;
@property (nonatomic, readwrite, nullable) NSArray *weaponsArray;

@property (weak, readonly) NSNumber *damageModifier; // The current damage modifier.
@property (weak, readonly) NSNumber *matrixDamageModifier; // The current damage modifier.
@property (weak, readonly) NSNumber *statusPoolModifier; // The current DP modifier from status (worst case).
@property (weak, readonly) NSNumber *initiativeScoreAdjusted; // The initiative score, adjusted for status effects, based on the rolled dice and mode.

@property (readwrite) NSNumber *statusDuration; // A variable for the duration of the currently selected status. Used to sync the various controls together.
@property (readwrite) NSNumber *statusRating; // Ditto for the rating.

@property (readonly) NSString *displayedName; // This is the name as shown in the tableView. Puts the leading/trailing bits for Active/PC/Grunt actors.

@property (readwrite) BOOL isActiveActor; // An ephemeral value. Used by bindings from the UI for configuring/highlighting the table text.

@property (readwrite) int16_t newMetatype;

// Properties that allow the UI to autoupdate based on the actor type.
@property (readonly) BOOL isVehicle; // An indicator that the actor is a vehicle or drone
@property (readonly) BOOL isGrunt; // An indicator that the actor uses a single condition monitor
@property (readonly) BOOL usesPhysicalAttributes; // An indicator that the actor has a matrix condition monitor, based on actor type.
@property (readonly) BOOL usesMagicResonance; // An indicator that the actor uses the magic/resonance value
@property (readonly) BOOL usesStunCondition;
@property (readonly) BOOL usesPhysicalCondition;
@property (readonly) BOOL isMatrixModeOnly;
@property (readonly) BOOL usesMovement;

@property (readonly) BOOL showLevel;
@property (readonly) BOOL showProfessionalRating;
@property (readonly) BOOL showServices;
@property (readonly) BOOL showMetatype;
@property (readonly) BOOL showTechnomancer;
@property (readonly) BOOL showMagic;
@property (readonly) BOOL showQualities;
@property (readonly) BOOL showMatrix;
@property (readonly) BOOL showPowers;
@property (readonly) BOOL showAugs;
@property (readonly) BOOL showMatrixConditionMonitor;
@property (readonly) BOOL showSprite;

@property (readonly) NSString *levelLabel; // The string that should be provided for the level label.
@property (readonly) NSString *magicLabel; // The string that should be provided for the magic/resonant label.
@property (readonly) NSString *stunCMLabel; // The string that should be provided for the magic/resonant label.
@property (readonly) NSString *speedDetails; // The string that gives details the current vehicle speed.

@property (readwrite) int16_t programSlots;
@property (readwrite) int16_t matrixInitBonus;

-(SRDice *)SRRoller; // A getter for the die roller.
-(void) rollInit; // Roll initiative.
-(void) newRound; // Advance a round. Decrements the statuses.
-(void) clearStatuses; // Erase all the statuses
-(void) clearDamage; // Clear all damage.
-(void) rollSurprise; // Make a surprise test.
-(void) rollStealth; // Make a stealth test.
-(void) rollPerception; // Make a perception test.

-(void) checkDamageBoxes; // Utlity function that checks that excess damage goes into the right condition monitor.

// Status interface code.
-(void)addStatus:(NSString *)statusName duration:(NSInteger) duration rating:(NSInteger) rating; // This method is used to add a status.
-(void)udpateStatus:(NSString *)statusName duration:(NSInteger) duration rating:(NSInteger) rating; // This method is used to update a status/
-(void)removeStatus:(NSString *)statusName;
-(void)removeFromArray:(NSString *)statusName;
-(void)pasteStatuses: (SR6Actor *)source;

-(NSMutableArray *)statusArray; // The getter for the status array.
-(NSArray *)statusEntry:(NSString *)statusName; // A getter for a single entry from the status array.
-(NSString *)statusString; // Getter for a short summary string, with just the emojis.
-(NSArray *)buildStatusArrayEntry:(NSString *)statusName rating: (int16_t) rating duration:(int16_t) duration; // Builds a status table entry.
-(NSArray *)buildStatusArrayEntry:(NSString *)statusName duration:(int16_t) duration; // Builds a status table entry.


- (NSDictionary *)actorAsDictionary; // Getter for the actor in dictioanry form.
- (BOOL) loadFromDictionary:(NSDictionary *)myDict; // Extract an actor from a dictionary.

-(int) getPoolStunBoxes;
-(int) getPoolPhysicalBoxes;
-(int) getPoolMatrixBoxes;

-(NSInteger) getPoolDrain;
-(NSString *) getPoolDrainDescription;

-(NSInteger) getSkillTestPool:(NSInteger)skill attribute:(NSInteger)attribute specialization:(sr6Specialization) specialization withDamageModifiers:(BOOL)dmgMods withMatrixDamageModifiers:(BOOL)matrixMods withStatusModifiers:(BOOL)statusMods;

-(NSInteger) getAttributeTestPool:(NSInteger)firstAttribute secondAttribute:(NSInteger)secondAttribute withDamageModifiers:(BOOL)dmgMods withMatrixDamageModifiers:(BOOL)matrixMods withStatusModifiers:(BOOL)statusMods;

-(NSString *)getSkillTestDescription:(NSInteger)skill attribute:(NSInteger)attribute specialization:(sr6Specialization)specialization withDamageModifiers:(BOOL)dmgMods withMatrixDamageModifiers:(BOOL)matrixMods withStatusModifiers:(BOOL)statusMods rollName:(nullable NSString *) rollName;

-(NSString *)getAttributeTestDescription:(NSInteger)firstAttribute secondAttribute:(NSInteger)secondAttribute withDamageModifiers:(BOOL)dmgMods withMatrixDamageModifiers:(BOOL)matrixMods withStatusModifiers:(BOOL)statusMods rollName:(nullable NSString *) rollName;

-(NSInteger) getPoolForSkill:(NSInteger)skill;
-(NSInteger) getPoolForAttribute:(NSInteger)attribute;
-(NSString *) getStringForSkill:(NSInteger)skill;
-(NSString *) getStringForAttribute:(NSInteger)attribute;
-(NSInteger) getDefaultAttributeForSkill:(NSInteger)skill;

-(void) addAdeptPowersForUUIDS:(NSArray *)uuids;
-(void) removeAdeptPower:(SR6ActorAdeptPower *) adeptPower;

-(NSDecimalNumber *) totalPowerPoints;
-(NSString *) totalPowerPointsString;

-(void) addAugsForUUIDS:(NSArray *)uuids;
-(void) removeAug:(SR6ActorAug *) aug;

-(NSDecimalNumber *) totalEssence;
-(NSString *) totalEssenceString;

-(void) addComplexFormsForUUIDS:(NSArray *)uuids;
-(void) removeComplexForm:(SR6ActorComplexForm *) complexForm;

-(NSUInteger ) numberComplexFormsSustained;
-(NSString *) numberCFsSustained;

-(void) addEchoesForUUIDS:(NSArray *)uuids;
-(void) removeEcho:(SR6ActorEcho *) echo;

-(void) addMetamagicsForUUIDS:(NSArray *)uuids;
-(void) removeMetamagic:(SR6ActorMetamagic *) metamagic;

-(void) clearMentor;

-(void) addPowersForUUIDS:(NSArray *)uuids;
-(void) removePower:(SR6ActorPower *) power;

-(void) addProgramsForUUIDS:(NSArray *)uuids;
-(void) removeProgram:(SR6ActorProgram *) program;

-(NSUInteger ) numberProgramsRunning;
-(NSString *) numberProgramsRunningString;

-(void) addQualitiesForUUIDS:(NSArray *)uuids;
-(void) removeQuality:(SR6ActorQuality *) quality;

-(NSInteger) totalQualityKarma;
-(NSString *) totalQualityKarmaString;

-(void) addSpellsForUUIDS:(NSArray *)uuids;
-(void) removeSpell:(SR6ActorSpell *) spell;

-(NSUInteger ) numberSustained;
-(NSString *) numberSustainedString;

-(void) addWeaponsForUUIDS:(NSArray *)uuids;
-(void) removeWeapon:(SR6ActorWeapon *) spell;

-(void) setMatrixDefaultsCommlink;
-(void) setMatrixDefaultsCyberdeck;
-(void) setMatrixDefaultsRCC;
-(void) setTMDefaults;
-(void) setTMDerived;

@property (readwrite) int16_t attrResonance; // References to magic, as that value is overloaded. Convenience only.
@property (readonly) int16_t bonusRemaining;
@property (readonly) BOOL bonusAttackGood;
@property (readonly) BOOL bonusSleazeGood;
@property (readonly) BOOL bonusDataProcessingGood;
@property (readonly) BOOL bonusFirewallGood;


@end

NS_ASSUME_NONNULL_END

#import "SR6ActorProperties.h"
