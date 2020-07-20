//
//  SR6Actor.m
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
#import "SRDice.h"
#import "DMRnd.h"
#import <AppKit/AppKit.h>


#import "SR6AdeptPower.h"
#import "SR6ActorAdeptPower.h"
#import "SR6Aug.h"
#import "SR6ActorAug.h"
#import "SR6ComplexForm.h"
#import "SR6ActorComplexForm.h"
#import "SR6Echo.h"
#import "SR6ActorEcho.h"
#import "SR6Mentor.h"
#import "SR6Metamagic.h"
#import "SR6ActorMetamagic.h"
#import "SR6Power.h"
#import "SR6ActorPower.h"
#import "SR6Program.h"
#import "SR6ActorProgram.h"
#import "SR6Quality.h"
#import "SR6ActorQuality.h"
#import "SR6Spell.h"
#import "SR6ActorSpell.h"
#import "SR6Weapon.h"
#import "SR6ActorWeapon.h"

@interface SR6Actor ()
-(void)clearArray; // Clear the status array
-(void)buildArray; // Build the status array
-(void)buildStatusString; // Build a summary status string.

-(BOOL)usesRating; // Uses force/level/rating to calculate values.

@end

@implementation SR6Actor

@synthesize statusRating;
@synthesize statusDuration;
@synthesize isActiveActor;

@synthesize programSlots;
@synthesize matrixInitBonus;

@synthesize adeptPowersArray = _adeptPowersArray;
@synthesize augsArray = _augsArray;
@synthesize complexFormsArray = _complexFormsArray;
@synthesize echoesArray = _echoesArray;
@synthesize mentor = _mentor;
@synthesize metamagicsArray = _metamagicsArray;
@synthesize powersArray = _powersArray;
@synthesize programsArray = _programsArray;
@synthesize qualitiesArray = _qualitiesArray;
@synthesize spellsArray = _spellsArray;
@synthesize weaponsArray = _weaponsArray;

#pragma mark Object Array Manipulation.

-(NSDecimalNumber *) totalPowerPoints {
    NSDecimalNumber * sum = [NSDecimalNumber zero];
    SR6ActorAdeptPower *myAP;
    
    if ([self.adeptPowersArray count] == 0) return sum;
    
    for (int x = 0; x < [self.adeptPowersArray count]; x ++) {
        myAP =(SR6ActorAdeptPower *)[self.adeptPowersArray objectAtIndex:x];
        sum = [sum decimalNumberByAdding:[myAP powerPointCost]];
    }
    return sum;
}

-(NSString *) totalPowerPointsString {
    return ([NSString stringWithFormat:@"Total Power Points: %@",[self.totalPowerPoints stringValue]]);
}

-(NSDecimalNumber *) totalEssence {
    // This is more complicated than you might think - things that can be shoved into capacity
    // shouldn't count against essence. We don't track that implant X goes in cybereye Y.
    // So we cheat - we sum up the available capacity, and then only count essence
    // if there isn't capacity avialable to store the gizmo. It can get stuff wrong
    // (putting a bunch of eye mods in a cybertorse), but it's not terrible.
    NSDecimalNumber * sum = [NSDecimalNumber zero];
    NSInteger availCapacity = 0;
    SR6ActorAug *myAug;
    
    if ([self.augsArray count] == 0) return sum;
    
    // First, figure out how much capacity we have.
    for (int x = 0; x < [self.augsArray count]; x ++) {
        myAug =(SR6ActorAug *)[self.augsArray objectAtIndex:x];
        if (myAug.capacityInt >0) availCapacity = availCapacity + myAug.capacityInt;
    }
    
    for (int x = 0; x < [self.augsArray count]; x ++) {
        myAug =(SR6ActorAug *)[self.augsArray objectAtIndex:x];
        // If the aug can use up capacity, check to see if there is any available.
        // If there is, don't consume essence, consume capacity.
        if (myAug.capacityInt < 0) {
            if (availCapacity + myAug.capacityInt > 0) {
                // There's capacity, so consume it.
                availCapacity = availCapacity + myAug.capacityInt;
            } else {
                sum = [sum decimalNumberByAdding:[myAug essence]];
            }
        } else {
            sum = [sum decimalNumberByAdding:[myAug essence]];
        }
    }
    return sum;
}

-(NSString *) totalEssenceString {
    return ([NSString stringWithFormat:@"Total Essence Loss: %@",[self.totalEssence stringValue]]);
}

-(void)setNewMetatype:(int16_t) newMetatype {
// This handles adjusting the metatype. It's wrapper around the metatpye dynamic property in the MOC.
// This allows us to do some tinkering with the attributes as needed based on the metatype.
    if (self.actorCategory == ACTOR_CATEGORY_GRUNT || self.actorCategory == ACTOR_CATEGORY_LIEUTENANT) {
        // What we do is map from the old metatype category to the "normal" human type.
        switch (self.metatype) {
            case kMetatypeDwarf:
                self.attrBody = self.attrBody -1;
                break;
            case kMetatypeElf:
                self.attrAgility = self.attrAgility -1;
                self.attrCharisma = self.attrCharisma -1;
                break;
            case kMetatypeOrk:
                self.attrBody = self.attrBody -1;
                self.attrStrength = self.attrStrength -1;
                break;
            case kMetatypeTroll:
                self.attrBody = self.attrBody -2;
                self.attrStrength = self.attrStrength -1;
                break;
            default:
                break;
        }
        
        // Now, we adjust to the new metatype.
        switch (newMetatype) {
            case kMetatypeDwarf:
                self.attrBody = self.attrBody +1;
                break;
            case kMetatypeElf:
                self.attrAgility = self.attrAgility +1;
                self.attrCharisma = self.attrCharisma +1;
                break;
            case kMetatypeOrk:
                self.attrBody = self.attrBody +1;
                self.attrStrength = self.attrStrength +1;
                break;
            case kMetatypeTroll:
                self.attrBody = self.attrBody +2;
                self.attrStrength = self.attrStrength +1;
                break;
            default:
                break;
        }
        // Save the metatype
        self.metatype = newMetatype;
    } else {
        // For normal characters (PCs and "normal"), changing the metatype doesn't do anything.
        self.metatype = newMetatype;
    }
}

-(int16_t) newMetatype {
    return self.metatype;
}

#pragma mark Object Array Stuff

-(NSArray *) adeptPowersArray {
    if (_adeptPowersArray == nil) {
        NSArray *sorters =[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"adeptPower.name" ascending:YES], nil];
        self.adeptPowersArray = [self.adeptPowers sortedArrayUsingDescriptors:sorters];
    }
    return _adeptPowersArray;
}

-(NSArray *) augsArray {
    if (_augsArray == nil) {
        NSArray *sorters =[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"aug.category" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"aug.name" ascending:YES], nil];
        self.augsArray = [self.augs sortedArrayUsingDescriptors:sorters];
    }
    return _augsArray;
}

-(NSArray *) complexFormsArray {
    if (_complexFormsArray == nil) {
        NSArray *sorters =[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"complexForm.name" ascending:YES], nil];
        self.complexFormsArray = [self.complexForms sortedArrayUsingDescriptors:sorters];
    }
    return _complexFormsArray;
}

-(NSUInteger ) numberComplexFormsSustained {
    NSInteger sum = 0;
    SR6ActorComplexForm *myCF;
    
    if ([self.complexFormsArray count] == 0) return sum;
    
    for (int x = 0; x < [self.complexFormsArray count]; x ++) {
        myCF =(SR6ActorComplexForm *)[self.complexFormsArray objectAtIndex:x];
        if (myCF.sustained) sum ++;
    }
    return sum;
}

-(NSString *) numberCFsSustained {
     return ([NSString stringWithFormat:@"CFs Sustained: %ld",self.numberComplexFormsSustained]);
}

-(NSArray *) echoesArray {
    if (_echoesArray == nil) {
        NSArray *sorters =[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"echo.name" ascending:YES], nil];
        self.echoesArray = [self.echoes sortedArrayUsingDescriptors:sorters];
    }
    return _echoesArray;
}

-(SR6Mentor *) mentor {
    // Mentors are a bit different, as there is only one. So we don't need an ActorMentor. We can just get it directly.
    if (_mentor == nil) {
        if (self.mentorUUID == nil) return nil;
        // But we have to perform the fetch manually.
        //NSLog (@"Getting new mentor info for %@.",self.mentorUUID);
        NSManagedObjectContext *myMOC = [self managedObjectContext];
        NSFetchRequest *myFR = [NSFetchRequest fetchRequestWithEntityName:@"SR6Mentor"];
        myFR.predicate = [NSPredicate predicateWithFormat:@"mentorUUID == %@",self.mentorUUID];
        NSError *error;
        NSArray * tmp = [myMOC executeFetchRequest:myFR error:&error];
        //NSLog(@"Array size: %ld",[tmp count]);
        _mentor = [tmp firstObject];
    }
    return _mentor;
}

-(void)clearMentor {
    self.mentorUUID = nil;
    _mentor = nil;
}

-(NSArray *) metamagicsArray {
    if (_metamagicsArray == nil) {
        NSArray *sorters =[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"metamagic.name" ascending:YES], nil];
        self.metamagicsArray = [self.metamagics sortedArrayUsingDescriptors:sorters];
    }
    return _metamagicsArray;
}

-(NSArray *) powersArray {
    if (_powersArray == nil) {
        NSArray *sorters =[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"power.category" ascending:YES],[NSSortDescriptor sortDescriptorWithKey:@"power.name" ascending:YES], nil];
        self.powersArray = [self.powers sortedArrayUsingDescriptors:sorters];
    }
    return _powersArray;
}

-(NSArray *) programsArray {
    if (_programsArray == nil) {
        NSArray *sorters =[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"program.category" ascending:YES],[NSSortDescriptor sortDescriptorWithKey:@"program.name" ascending:YES], nil];
        self.programsArray = [self.programs sortedArrayUsingDescriptors:sorters];
    }
    return _programsArray;
}

-(NSUInteger ) numberProgramsRunning {
    NSInteger sum = 0;
    SR6ActorProgram *myProg;
    
    if ([self.programsArray count] == 0) return sum;
    
    for (int x = 0; x < [self.programsArray count]; x ++) {
        myProg =(SR6ActorProgram *)[self.programsArray objectAtIndex:x];
        if (myProg.loaded) sum ++;
    }
    return sum;
}

-(NSString *) numberProgramsRunningString {
     return ([NSString stringWithFormat:@"Programs Loaded: %ld",self.numberProgramsRunning]);
}

-(NSArray *) qualitiesArray {
    if (_qualitiesArray == nil) {
        NSArray *sorters =[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"quality.negativeShortString" ascending:NO],[NSSortDescriptor sortDescriptorWithKey:@"quality.name" ascending:YES], nil];
        self.qualitiesArray = [self.qualities sortedArrayUsingDescriptors:sorters];
    }
    return _qualitiesArray;
}

- (NSInteger) totalQualityKarma {
    NSInteger sum = 0;
    SR6ActorQuality *myQual;
    
    if ([self.qualitiesArray count] == 0) return sum;
    
    for (int x = 0; x < [self.qualitiesArray count]; x ++) {
        myQual =(SR6ActorQuality *)[self.qualitiesArray objectAtIndex:x];
        sum = sum + myQual.karma;
    }
    return sum;
}

-(NSString *) totalQualityKarmaString {
    return ([NSString stringWithFormat:@"Total Karma: %ld",self.totalQualityKarma]);
}

-(NSArray *) spellsArray {
    if (_spellsArray == nil) {
        NSArray *sorters =[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"spell.category" ascending:YES],[NSSortDescriptor sortDescriptorWithKey:@"spell.name" ascending:YES], nil];
        self.spellsArray = [self.spells sortedArrayUsingDescriptors:sorters];
    }
    return _spellsArray;
}

-(NSUInteger ) numberSustained {
    NSInteger sum = 0;
    SR6ActorSpell *mySpell;
    
    if ([self.spellsArray count] == 0) return sum;
    
    for (int x = 0; x < [self.spellsArray count]; x ++) {
        mySpell =(SR6ActorSpell *)[self.spellsArray objectAtIndex:x];
        if (mySpell.sustained) sum ++;
    }
    return sum;
}

-(NSString *) numberSustainedString {
    return ([NSString stringWithFormat:@"Number Spells Sustained: %ld",[self numberSustained]]);
}

-(NSArray *) weaponsArray {
    if (_weaponsArray == nil) {
        NSArray *sorters =[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"weapon.category" ascending:YES],[NSSortDescriptor sortDescriptorWithKey:@"weapon.name" ascending:YES], nil];
        self.weaponsArray = [self.weapons sortedArrayUsingDescriptors:sorters];
    }
    return _weaponsArray;
}


-(void)removeAdeptPower:(SR6ActorAdeptPower *) adeptPower {
    [self removeAdeptPowersObject:adeptPower];
    self.adeptPowersArray = nil;
}

-(void)removeAug:(SR6ActorAug *) aug {
    [self removeAugsObject:aug];
    self.augsArray = nil;
}

-(void)removeComplexForm:(SR6ActorComplexForm *) complexForm {
    [self removeComplexFormsObject:complexForm];
    self.complexFormsArray = nil;
}

-(void)removeEcho:(SR6ActorEcho *) echo {
    [self removeEchoesObject:echo];
    self.echoesArray = nil;
}

-(void)removeMetamagic:(SR6ActorMetamagic *) metamagic {
    [self removeMetamagicsObject:metamagic];
    self.metamagicsArray = nil;
}

-(void)removePower:(SR6ActorPower *) power {
    [self removePowersObject:power];
    self.powersArray = nil;
}

-(void)removeProgram:(SR6ActorProgram *) program {
    [self removeProgramsObject:program];
    self.programsArray = nil;
}

-(void)removeQuality:(SR6ActorQuality *) quality {
    [self removeQualitiesObject:quality];
    self.qualitiesArray = nil;
}

-(void)removeSpell:(SR6ActorSpell *) spell {
    [self removeSpellsObject:spell];
    self.spellsArray = nil;
}

-(void)removeWeapon:(SR6ActorWeapon *) weapon {
    [self removeWeaponsObject:weapon];
    self.weaponsArray = nil;
}

-(void)addAdeptPowersForUUIDS:(NSArray *)uuids {
    if ([uuids count] == 0) return;
    SR6ActorAdeptPower *newActorAdeptPower;
    for (NSUInteger x = 0; x <[uuids count]; x ++) {
        newActorAdeptPower = [NSEntityDescription insertNewObjectForEntityForName:@"SR6ActorAdeptPower" inManagedObjectContext:self.managedObjectContext];
        newActorAdeptPower.uuid = [uuids objectAtIndex:x];
        newActorAdeptPower.option = @"";
        newActorAdeptPower.actor = self;
        [self addAdeptPowersObject:newActorAdeptPower];
    }
        
    // Clear the qualities array so that it gets built next go around.
    self.adeptPowersArray = nil;
}

-(void)addAugsForUUIDS:(NSArray *)uuids {
    if ([uuids count] == 0) return;
    SR6ActorAug *newActorAug;
    for (NSUInteger x = 0; x <[uuids count]; x ++) {
        newActorAug = [NSEntityDescription insertNewObjectForEntityForName:@"SR6ActorAug" inManagedObjectContext:self.managedObjectContext];
        newActorAug.uuid = [uuids objectAtIndex:x];
        newActorAug.option = @"";
        newActorAug.actor = self;
        [self addAugsObject:newActorAug];
    }
        
    // Clear the qualities array so that it gets built next go around.
    self.augsArray = nil;
}

-(void)addComplexFormsForUUIDS:(NSArray *)uuids {
    if ([uuids count] == 0) return;
    SR6ActorComplexForm *newActorComplexForm;
    for (NSUInteger x = 0; x <[uuids count]; x ++) {
        newActorComplexForm = [NSEntityDescription insertNewObjectForEntityForName:@"SR6ActorComplexForm" inManagedObjectContext:self.managedObjectContext];
        newActorComplexForm.uuid = [uuids objectAtIndex:x];
        newActorComplexForm.option = @"";
        newActorComplexForm.actor = self;
        [self addComplexFormsObject:newActorComplexForm];
    }
        
    // Clear the qualities array so that it gets built next go around.
    self.complexFormsArray = nil;
}

-(void)addEchoesForUUIDS:(NSArray *)uuids {
    if ([uuids count] == 0) return;
    SR6ActorEcho *newActorEcho;
    for (NSUInteger x = 0; x <[uuids count]; x ++) {
        newActorEcho = [NSEntityDescription insertNewObjectForEntityForName:@"SR6ActorEcho" inManagedObjectContext:self.managedObjectContext];
        newActorEcho.uuid = [uuids objectAtIndex:x];
        newActorEcho.option = @"";
        newActorEcho.actor = self;
        [self addEchoesObject:newActorEcho];
    }
        
    // Clear the qualities array so that it gets built next go around.
    self.echoesArray = nil;
}

-(void)addMetamagicsForUUIDS:(NSArray *)uuids {
    if ([uuids count] == 0) return;
    SR6ActorMetamagic *newActorMetamagic;
    for (NSUInteger x = 0; x <[uuids count]; x ++) {
        newActorMetamagic = [NSEntityDescription insertNewObjectForEntityForName:@"SR6ActorMetamagic" inManagedObjectContext:self.managedObjectContext];
        newActorMetamagic.uuid = [uuids objectAtIndex:x];
        newActorMetamagic.option = @"";
        newActorMetamagic.actor = self;
        [self addMetamagicsObject:newActorMetamagic];
    }
        
    // Clear the qualities array so that it gets built next go around.
    self.metamagicsArray = nil;
}

-(void)addPowersForUUIDS:(NSArray *)uuids {
    if ([uuids count] == 0) return;
    SR6ActorPower *newActorPower;
    for (NSUInteger x = 0; x <[uuids count]; x ++) {
        newActorPower = [NSEntityDescription insertNewObjectForEntityForName:@"SR6ActorPower" inManagedObjectContext:self.managedObjectContext];
        newActorPower.uuid = [uuids objectAtIndex:x];
        newActorPower.option = @"";
        newActorPower.actor = self;
        [self addPowersObject:newActorPower];
    }
        
    // Clear the qualities array so that it gets built next go around.
    self.powersArray = nil;
}

-(void)addProgramsForUUIDS:(NSArray *)uuids {
    if ([uuids count] == 0) return;
    SR6ActorProgram *newActorProgram;
    for (NSUInteger x = 0; x <[uuids count]; x ++) {
        newActorProgram = [NSEntityDescription insertNewObjectForEntityForName:@"SR6ActorProgram" inManagedObjectContext:self.managedObjectContext];
        newActorProgram.uuid = [uuids objectAtIndex:x];
        newActorProgram.option = @"";
        newActorProgram.actor = self;
        [self addProgramsObject:newActorProgram];
    }
        
    // Clear the qualities array so that it gets built next go around.
    self.programsArray = nil;
}

-(void)addQualitiesForUUIDS:(NSArray *)uuids {
    if ([uuids count] == 0) return;
    SR6ActorQuality *newActorQuality;
    for (NSUInteger x = 0; x <[uuids count]; x ++) {
        newActorQuality = [NSEntityDescription insertNewObjectForEntityForName:@"SR6ActorQuality" inManagedObjectContext:self.managedObjectContext];
        newActorQuality.uuid = [uuids objectAtIndex:x];
        newActorQuality.option = @"";
        newActorQuality.actor = self;
        [self addQualitiesObject:newActorQuality];
    }
        
    // Clear the qualities array so that it gets built next go around.
    self.qualitiesArray = nil;
}

-(void)addSpellsForUUIDS:(NSArray *)uuids {
    if ([uuids count] == 0) return;
    SR6ActorSpell *newActorSpell;
    for (NSUInteger x = 0; x <[uuids count]; x ++) {
        newActorSpell = [NSEntityDescription insertNewObjectForEntityForName:@"SR6ActorSpell" inManagedObjectContext:self.managedObjectContext];
        newActorSpell.uuid = [uuids objectAtIndex:x];
        newActorSpell.option = @"";
        newActorSpell.actor = self;
        [self addSpellsObject:newActorSpell];
    }
        
    // Clear the spells array so that it gets built next go around.
    self.spellsArray = nil;
}

-(void)addWeaponsForUUIDS:(NSArray *)uuids {
    if ([uuids count] == 0) return;
    SR6ActorWeapon *newActorWeapon;
    for (NSUInteger x = 0; x <[uuids count]; x ++) {
        newActorWeapon = [NSEntityDescription insertNewObjectForEntityForName:@"SR6ActorWeapon" inManagedObjectContext:self.managedObjectContext];
        newActorWeapon.uuid = [uuids objectAtIndex:x];
        newActorWeapon.notes = @"";
        newActorWeapon.actor = self;
        newActorWeapon.count = 1;
        newActorWeapon.ammoSource = 0;
        if (newActorWeapon.weapon.ammoCount1 == 0 && newActorWeapon.weapon.ammoCount2 == 0) {
            newActorWeapon.ammoType = kWeaponAmmoTypeNone;
        } else {
            newActorWeapon.ammoType = kWeaponAmmoTypeRegular;
        }
        if (newActorWeapon.weapon.level) newActorWeapon.level = 1;
        [self addWeaponsObject:newActorWeapon];
        [newActorWeapon reload];
        [newActorWeapon resetAccessories];
    }
        
    // Clear the spells array so that it gets built next go around.
    self.weaponsArray = nil;
}

#pragma mark Utility Methods


-(BOOL) usesRating {
    return (self.actorType == ACTOR_TYPE_SPIRIT || self.actorType == ACTOR_TYPE_SPRITE || self.actorType == ACTOR_TYPE_AGENT);
}

-(void)checkDamageBoxes {
    // Check to see if we have excess stun.
    
    if (self.isGrunt) {
        // There's only one condition monitor for grunts.
        if (self.stunCondition > self.getPoolStunBoxes) {
            self.overflow = self.overflow + self.stunCondition - self.getPoolStunBoxes;
            self.stunCondition = self.getPoolStunBoxes;
        }
    } else {
        if (self.stunCondition > self.getPoolStunBoxes) {
            // We've gone over, so add the spillage to the physical pile and peg stun and max.
            self.physicalCondition = self.physicalCondition + self.stunCondition - self.getPoolStunBoxes;
            self.stunCondition = self.getPoolStunBoxes;
        }
        if (self.physicalCondition > self.getPoolPhysicalBoxes) {
            // We've gone over, so add the spillage to the physical pile and peg stun and max.
            self.overflow = self.overflow + self.physicalCondition - self.getPoolPhysicalBoxes;
            self.physicalCondition = self.getPoolPhysicalBoxes;
        }
    }
}

#pragma mark Displayed Name in Table View Methods

-(NSString *)displayedName {
    NSString * tmpStr;
    // If it uses a rating, we should add the rating.
    
   
    tmpStr = [NSString stringWithFormat:@"%@%@", self.charName, [self ratingDescription]];

    if (self.actorCategory == ACTOR_CATEGORY_PC) {
        tmpStr = [NSString stringWithFormat: @"%@%@%@",SR6_PC_LEAD,tmpStr,SR6_PC_TRAIL];
    } else if (self.actorCategory == ACTOR_CATEGORY_GRUNT) {
        tmpStr = ([NSString stringWithFormat: @"%@%@%@",SR6_GRUNT_LEAD,tmpStr,SR6_GRUNT_TRAIL]);
    } else if (self.actorCategory == ACTOR_CATEGORY_LIEUTENANT) {
        tmpStr = ([NSString stringWithFormat: @"%@%@%@",SR6_LT_LEAD,tmpStr,SR6_LT_TRAIL]);
    }
    if (self.isActiveActor) {
        return ([NSString stringWithFormat: @"%@%@%@",SR6_ACTIVE_LEAD,tmpStr,SR6_ACTIVE_TRAIL]);
    } else {
        return (tmpStr);
    }
}

-(void) setDisplayedName:(NSString * _Nonnull)displayedName {
    // If the name is edited in the table, we have to strip off the tags, and then save it.
    // It's not pretty, but it works.
    NSString * tmpStr;
    NSString *tmpStr2;
    // Strip off the leading/trailing tags.
    tmpStr = displayedName;
    
    // First, handle the active actor. This can be layered on top of being a PC, Grunt or LT, so do it first.
    if (self.isActiveActor) {
        if ([tmpStr length]> SR6_ACTIVE_TRAIL_LENGTH) {
            if ([[tmpStr substringFromIndex:[tmpStr length] - SR6_ACTIVE_TRAIL_LENGTH] isEqualToString: SR6_ACTIVE_TRAIL]) {
                tmpStr = [displayedName substringToIndex:[tmpStr length] - SR6_ACTIVE_TRAIL_LENGTH];
            }
        }
        if ([displayedName length]> SR6_ACTIVE_LEAD_LENGTH) {
            tmpStr2 = [tmpStr substringToIndex:SR6_ACTIVE_LEAD_LENGTH];
            if ([[tmpStr substringToIndex:SR6_ACTIVE_LEAD_LENGTH] isEqualToString: SR6_ACTIVE_LEAD]) {
                tmpStr = [tmpStr substringFromIndex:SR6_ACTIVE_LEAD_LENGTH];
            }
        }
    }
    
    // Then handle if it's a PC, Grunt or LT.
    if (self.actorCategory == ACTOR_CATEGORY_PC) {
        if ([tmpStr length]> SR6_PC_TRAIL_LENGTH) {
            tmpStr2 = [tmpStr substringFromIndex:[tmpStr length] - SR6_PC_TRAIL_LENGTH];
            if ([[tmpStr substringFromIndex:[tmpStr length] - SR6_PC_TRAIL_LENGTH] isEqualToString: SR6_PC_TRAIL]) {
                tmpStr = [tmpStr substringToIndex:[tmpStr length] - SR6_PC_TRAIL_LENGTH];
            }
        }
        if ([displayedName length]> SR6_PC_LEAD_LENGTH) {
            tmpStr2 = [tmpStr substringToIndex:SR6_PC_LEAD_LENGTH];
            if ([[tmpStr substringToIndex:SR6_PC_LEAD_LENGTH] isEqualToString: SR6_PC_LEAD]) {
                tmpStr = [tmpStr substringFromIndex:SR6_PC_LEAD_LENGTH];
            }
        }
    } else if (self.actorCategory == ACTOR_CATEGORY_GRUNT) {
        if ([tmpStr length]> SR6_GRUNT_TRAIL_LENGTH) {
            tmpStr2 = [tmpStr substringFromIndex:[tmpStr length] - SR6_GRUNT_TRAIL_LENGTH];
            if ([[tmpStr substringFromIndex:[tmpStr length] - SR6_GRUNT_TRAIL_LENGTH] isEqualToString: SR6_GRUNT_TRAIL]) {
                tmpStr = [tmpStr substringToIndex:[tmpStr length] - SR6_GRUNT_TRAIL_LENGTH];
            }
        }
        if ([displayedName length]> SR6_GRUNT_LEAD_LENGTH) {
            tmpStr2 = [tmpStr substringToIndex:SR6_GRUNT_LEAD_LENGTH];
            if ([[tmpStr substringToIndex:SR6_GRUNT_LEAD_LENGTH] isEqualToString: SR6_GRUNT_LEAD]) {
                tmpStr = [tmpStr substringFromIndex:SR6_GRUNT_LEAD_LENGTH];
            }
        }
    } else if (self.actorCategory == ACTOR_CATEGORY_LIEUTENANT) {
        if ([tmpStr length]> SR6_LT_TRAIL_LENGTH) {
            tmpStr2 = [tmpStr substringFromIndex:[tmpStr length] - SR6_LT_TRAIL_LENGTH];
            if ([[tmpStr substringFromIndex:[tmpStr length] - SR6_LT_TRAIL_LENGTH] isEqualToString: SR6_LT_TRAIL]) {
                tmpStr = [tmpStr substringToIndex:[tmpStr length] - SR6_LT_TRAIL_LENGTH];
            }
        }
        if ([displayedName length]> SR6_LT_LEAD_LENGTH) {
            tmpStr2 = [tmpStr substringToIndex:SR6_LT_LEAD_LENGTH];
            if ([[tmpStr substringToIndex:SR6_LT_LEAD_LENGTH] isEqualToString: SR6_LT_LEAD]) {
                tmpStr = [tmpStr substringFromIndex:SR6_LT_LEAD_LENGTH];
            }
        }
    }
    
    // For level-based actors (spirits, sprites, etc.), we need to pull that off.
    if ([self showLevel]) {
        // We pull these a little differently, becuase the rating value could be a couple of digits, and the actorType determines what the letter is.
        NSString *search;
        if (self.actorType == ACTOR_TYPE_AGENT) {
            search = [NSString stringWithFormat:@"%@%d%@",SR6_RATING_LEAD, self.rating, SR6_RATING_TAIL];
        } else if (self.actorType == ACTOR_TYPE_SPRITE){
            search = [NSString stringWithFormat:@"%@%d%@",SR6_LEVEL_LEAD, self.rating, SR6_RATING_TAIL];
        } else if (self.actorCategory == ACTOR_CATEGORY_GRUNT || self.actorCategory == ACTOR_CATEGORY_LIEUTENANT){
            search = [NSString stringWithFormat:@"%@%d%@",SR6_PR_LEAD, self.rating, SR6_RATING_TAIL];
        } else { // Default to Force
            search = [NSString stringWithFormat:@"%@%d%@",SR6_FORCE_LEAD, self.rating, SR6_RATING_TAIL];
        }
        
        if (tmpStr.length > search.length) {
            // Check that the end of the string contains our tag.
            if ([[tmpStr substringFromIndex:[tmpStr length] - search.length] isEqualToString: search]) {
                // We found the expected string, so remove it.
                tmpStr = [tmpStr substringToIndex:[tmpStr length] - search.length];
            }
        }
    }
    
    // Having stripped off everything, we can save it.
    self.charName = tmpStr;
}

#pragma mark Custom getters.

- (NSMutableArray *)statusArray{
    // Build the status array of we haven't got one.
    if (_statusArray == nil) {
        [self buildArray];
    }
    return _statusArray;
}

- (NSMutableString *)statusString{
    // Build the summary string, if we haven't got one.
    if (_statusString == nil) {
        [self buildStatusString];
    }
    return _statusString;
}

-(SRDice*) SRRoller {
    DMRnd *randomizer;
    
    if (!_roller) {
        unsigned long tmp = (unsigned long) [NSDate timeIntervalSinceReferenceDate];
        if ((randomizer = ([[DMRnd alloc] init: tmp]))) {
            // Now setup the dieRoller
            _roller = [[SRDice alloc] initWithRandomizer: randomizer];
        }
    }
    return _roller;
}

#pragma mark actorType related getters - for control enabling/disabling based on the type of actor.

-(BOOL) showLevel {
    return (self.actorType == ACTOR_TYPE_SPIRIT || self.actorType == ACTOR_TYPE_SPRITE || self.actorType == ACTOR_TYPE_AGENT);
}

-(BOOL) showProfessionalRating {
    return (self.actorCategory == ACTOR_CATEGORY_GRUNT || self.actorCategory == ACTOR_CATEGORY_LIEUTENANT);
}

-(BOOL) showServices {
    return (self.actorType == ACTOR_TYPE_SPIRIT || self.actorType == ACTOR_TYPE_SPRITE);
}

-(BOOL) showMetatype {
    return (self.actorType == ACTOR_TYPE_NORMAL || self.actorType == ACTOR_TYPE_AWAKENED || self.actorType == ACTOR_TYPE_TECHNOMANCER);
}

-(BOOL) showTechnomancer {
    return (self.actorType == ACTOR_TYPE_TECHNOMANCER || self.actorType == ACTOR_TYPE_TECHNOCRITTER || self.actorType == ACTOR_TYPE_SPRITE);
}

-(BOOL) showMagic {
    return (self.actorType == ACTOR_TYPE_AWAKENED || self.actorType == ACTOR_TYPE_SPIRIT || self.actorType == ACTOR_TYPE_CRITTER);
}

-(BOOL) showMatrix {
    return !(self.actorType == ACTOR_TYPE_SPIRIT || self.actorType == ACTOR_TYPE_SPRITE || self.actorType == ACTOR_TYPE_TECHNOCRITTER);
}

-(BOOL) showMatrixConditionMonitor {
    return !(self.actorType == ACTOR_TYPE_SPIRIT || self.actorType == ACTOR_TYPE_TECHNOMANCER || self.actorType == ACTOR_TYPE_TECHNOCRITTER);
}

-(BOOL) showPowers {
    return (self.actorType == ACTOR_TYPE_CRITTER || self.actorType == ACTOR_TYPE_TECHNOCRITTER || self.actorType == ACTOR_TYPE_SPRITE || self.actorType == ACTOR_TYPE_SPIRIT);
}

-(BOOL) showAugs {
    return !(self.actorType == ACTOR_TYPE_SPIRIT || self.actorType == ACTOR_TYPE_SPRITE|| self.actorType == ACTOR_TYPE_VEHICLE || self.actorType == ACTOR_TYPE_DRONE || self.actorType == ACTOR_TYPE_IC);
}

-(BOOL) showQualities {
    return !(self.actorType == ACTOR_TYPE_DRONE || self.actorType == ACTOR_TYPE_VEHICLE|| self.actorType == ACTOR_TYPE_SPRITE || self.actorType == ACTOR_TYPE_IC);
}

-(BOOL) showSprite {
    return (self.actorType == ACTOR_TYPE_SPRITE);
}

-(BOOL) isVehicle {
    return (self.actorType == ACTOR_TYPE_VEHICLE || self.actorType == ACTOR_TYPE_DRONE);
}

-(BOOL) isGrunt {
    return (self.actorCategory == ACTOR_CATEGORY_GRUNT || self.actorCategory == ACTOR_CATEGORY_LIEUTENANT);
}

-(NSString *) levelLabel{
    if (self.actorType == ACTOR_TYPE_SPRITE) {
        return @"Level";
    } else if (self.actorType == ACTOR_TYPE_AGENT) {
        return @"Rating";
    } else {
        return @"Force";
    }
}

-(NSString *) magicLabel{
    if (self.actorType == ACTOR_TYPE_TECHNOMANCER || self.actorType == ACTOR_TYPE_TECHNOCRITTER || self.actorType == ACTOR_TYPE_SPRITE) {
        return @"Res:";
    } else {
        return @"Mag:";
    }
}

-(NSString *) stunCMLabel{
    if (self.actorCategory == ACTOR_CATEGORY_GRUNT || self.actorCategory == ACTOR_CATEGORY_LIEUTENANT) {
        return @"Comb:";
    } else {
        return @"Stun:";
    }
}

-(NSString *) speedDetails {
    // Creates a string giving the current speed in kph/mph
    if (self.vehSpeedInterval == 0) {
        return (@"");
    } else {
        return ([NSString stringWithFormat:@"%d kph/%d mph, %d spd ints",(int)(self.currentSpeed * 1.2), (int)(self.currentSpeed * 0.7456454335),(self.currentSpeed-1)/self.vehSpeedInterval]);
    }
}

-(BOOL) usesPhysicalAttributes {
    // Don't show the physical attributes for online only entities (IC, agents, sprites)
    return !(self.actorType == ACTOR_TYPE_IC || self.actorType == ACTOR_TYPE_AGENT || self.actorType == ACTOR_TYPE_SPRITE);
}

-(BOOL) usesMagicResonance {
    // Show matrix/resonance attribute...or not. Based on type.
    return (self.actorType == ACTOR_TYPE_AWAKENED ||self.actorType == ACTOR_TYPE_SPIRIT || self.actorType == ACTOR_TYPE_CRITTER ||
            self.actorType == ACTOR_TYPE_TECHNOMANCER || self.actorType == ACTOR_TYPE_SPRITE || self.actorType == ACTOR_TYPE_TECHNOCRITTER);
}

-(BOOL) usesStunCondition {
    // Show matrix/resonance attribute...or not. Based on type, and Category.
    if (self.actorCategory == ACTOR_CATEGORY_GRUNT || self.actorCategory == ACTOR_CATEGORY_LIEUTENANT) {
        return !(self.actorType == ACTOR_TYPE_IC || self.actorType == ACTOR_TYPE_AGENT || self.actorType == ACTOR_TYPE_SPRITE ||
                 self.actorType == ACTOR_TYPE_DRONE || self.actorType == ACTOR_TYPE_VEHICLE);
    } else {
        return (self.actorType == ACTOR_TYPE_NORMAL ||self.actorType == ACTOR_TYPE_AWAKENED || self.actorType == ACTOR_TYPE_CRITTER ||
                self.actorType == ACTOR_TYPE_TECHNOMANCER || self.actorType == ACTOR_TYPE_TECHNOCRITTER);
    }
}

-(BOOL) usesPhysicalCondition {
    // Show if it uses a physical condition monitor, most do, unless they are grunts/LTTs.
    if (self.actorCategory == ACTOR_CATEGORY_GRUNT || self.actorCategory == ACTOR_CATEGORY_LIEUTENANT) {
        return (self.actorType == ACTOR_TYPE_DRONE || self.actorType == ACTOR_TYPE_VEHICLE);
    } else {
        return (self.actorType == ACTOR_TYPE_NORMAL ||self.actorType == ACTOR_TYPE_AWAKENED || self.actorType == ACTOR_TYPE_SPIRIT ||
                self.actorType == ACTOR_TYPE_CRITTER || self.actorType == ACTOR_TYPE_TECHNOMANCER || self.actorType == ACTOR_TYPE_TECHNOCRITTER ||
                self.actorType == ACTOR_TYPE_DRONE || self.actorType == ACTOR_TYPE_VEHICLE);
    }
}

-(BOOL) isMatrixModeOnly {
    return (self.actorType == ACTOR_TYPE_IC || self.actorType == ACTOR_TYPE_AGENT || self.actorType == ACTOR_TYPE_SPRITE);
}

-(BOOL) usesMovement {
    // Vehicles, drones and matrix-only entities don't have movement.
    return !(self.actorType == ACTOR_TYPE_VEHICLE || self.actorType == ACTOR_TYPE_DRONE || self.actorType == ACTOR_TYPE_SPRITE
            || self.actorType == ACTOR_TYPE_IC || self.actorType == ACTOR_TYPE_AGENT);
}

#pragma mark Dice Pool Getters

-(NSInteger) getPoolDrain {
    NSInteger iPool;
    switch (self.attrDrain) {
        case DRAIN_ATTR_WILLPOWER:
            iPool = [self getAttributeTestPool:SR6_ATTR_WILLPOWER secondAttribute:SR6_ATTR_WILLPOWER withDamageModifiers:NO withMatrixDamageModifiers:NO withStatusModifiers:NO];
            break;
        case DRAIN_ATTR_LOGIC:
            iPool = [self getAttributeTestPool:SR6_ATTR_LOGIC secondAttribute:SR6_ATTR_WILLPOWER withDamageModifiers:NO withMatrixDamageModifiers:NO withStatusModifiers:NO];
            break;
        case DRAIN_ATTR_INTUITION:
            iPool = [self getAttributeTestPool:SR6_ATTR_INTUITION secondAttribute:SR6_ATTR_WILLPOWER withDamageModifiers:NO withMatrixDamageModifiers:NO withStatusModifiers:NO];
            break;
        case DRAIN_ATTR_CHARISMA:
            iPool = [self getAttributeTestPool:SR6_ATTR_CHARISMA secondAttribute:SR6_ATTR_WILLPOWER withDamageModifiers:NO withMatrixDamageModifiers:NO withStatusModifiers:NO];
            break;
        default:
            iPool = [self getAttributeTestPool:SR6_ATTR_WILLPOWER secondAttribute:SR6_ATTR_NULL withDamageModifiers:NO withMatrixDamageModifiers:NO withStatusModifiers:NO];
            break;
    }
    return iPool;
}

-(NSString *) getPoolDrainDescription {
    NSString *tmpStr;
    
    if (self.actorType == ACTOR_TYPE_TECHNOMANCER || self.actorType == ACTOR_TYPE_TECHNOCRITTER) {
        tmpStr = [self getAttributeTestDescription:SR6_ATTR_LOGIC secondAttribute:SR6_ATTR_WILLPOWER withDamageModifiers:NO withMatrixDamageModifiers:NO withStatusModifiers:NO rollName:@"Fading"];
        return tmpStr;
    }
    
    switch (self.attrDrain) {
        case DRAIN_ATTR_WILLPOWER:
            tmpStr = [self getAttributeTestDescription:SR6_ATTR_WILLPOWER secondAttribute:SR6_ATTR_WILLPOWER withDamageModifiers:NO withMatrixDamageModifiers:NO withStatusModifiers:NO rollName:@"Drain"];
            break;
        case DRAIN_ATTR_LOGIC:
            tmpStr = [self getAttributeTestDescription:SR6_ATTR_LOGIC secondAttribute:SR6_ATTR_WILLPOWER withDamageModifiers:NO withMatrixDamageModifiers:NO withStatusModifiers:NO rollName:@"Drain"];
            break;
        case DRAIN_ATTR_INTUITION:
            tmpStr = [self getAttributeTestDescription:SR6_ATTR_INTUITION secondAttribute:SR6_ATTR_WILLPOWER withDamageModifiers:NO withMatrixDamageModifiers:NO withStatusModifiers:NO rollName:@"Drain"];
            break;
        case DRAIN_ATTR_CHARISMA:
            tmpStr = [self getAttributeTestDescription:SR6_ATTR_CHARISMA secondAttribute:SR6_ATTR_WILLPOWER withDamageModifiers:NO withMatrixDamageModifiers:NO withStatusModifiers:NO rollName:@"Drain"];
            break;
        default:
            tmpStr = [self getAttributeTestDescription:SR6_ATTR_WILLPOWER secondAttribute:SR6_ATTR_NULL withDamageModifiers:NO withMatrixDamageModifiers:NO withStatusModifiers:NO rollName:@"Drain"];
            break;
    }
    return tmpStr;
}

-(int) getPoolStunBoxes {
    if ([self usesRating]) {
        return (self.boxesStun + ((self.rating+1)/2));
    } else {
        return (self.boxesStun);
    }
}
                
-(int) getPoolPhysicalBoxes {
    if ([self usesRating]) {
        return (self.boxesPhysical + ((self.rating+1)/2));
    } else {
        return (self.boxesPhysical);
    }
}

-(int) getPoolMatrixBoxes {
    if ([self usesRating]) {
        return (self.boxesMatrix + ((self.rating+1)/2));
    } else {
        return (self.boxesMatrix);
    }
}

#pragma mark Matrix-related stuff.

-(int16_t) attrResonance {
    return self.attrMagic;
}

-(void) setAttrResonance:(int16_t)attrResonance {
    self.attrMagic = attrResonance;
}

-(void) setTMDefaults {
    // This sets the various ratings to their default.
    self.matrixAttack = self.attrCharisma;
    self.matrixSleaze = self.attrIntuition;
    self.matrixDataProcessing = self.attrLogic;
    self.matrixFirewall = self.attrWillpower;
}

-(void) setTMDerived {
    self.matrixAttackRating = self.matrixAttack + self.matrixSleaze;
    self.matrixDefenseRating = self.matrixDataProcessing + self.matrixFirewall;
    self.matrixInitiative = self.attrLogic + self.attrIntuition;
}

-(void) setMatrixDefaultsCommlink {
    if (self.actorType == ACTOR_TYPE_VEHICLE || self.actorType == ACTOR_TYPE_DRONE) {
        [self setMatrixDefaultsDrone];
        return;
    }
    self.matrixDeviceRating = self.commlink;
    self.matrixAttack = 0;
    self.matrixSleaze = 0;
    self.matrixDataProcessing = ((self.commlink+1)/2);
    self.matrixFirewall = (self.commlink-1) % 2;
    self.programSlots = ((self.commlink)/2);
    self.matrixInitBonus = 0;
    self.matrixAttackRating = self.matrixAttack + self.matrixSleaze;
    self.matrixDefenseRating = self.matrixDataProcessing + self.matrixFirewall;
    self.matrixInitiative = self.matrixInitBonus + self.matrixDataProcessing + self.attrIntuition;
    self.boxesMatrix = (self.matrixDeviceRating+1)/2 + 8;
}

-(void) setMatrixDefaultsCyberdeck {
    if (self.actorType == ACTOR_TYPE_VEHICLE || self.actorType == ACTOR_TYPE_DRONE) {
        [self setMatrixDefaultsDrone];
        return;
    }
    self.matrixDeviceRating = MAX(self.cyberjack, self.cyberdeck);
    self.matrixAttack = self.cyberdeck + 3;
    self.matrixSleaze = self.cyberdeck + 2;
    self.matrixDataProcessing = self.cyberjack + 3;
    self.matrixFirewall = self.cyberjack + 2;
    self.programSlots = self.cyberdeck * 2;
    self.matrixInitBonus = (self.cyberjack +2) / 3;
    self.matrixAttackRating = self.matrixAttack + self.matrixSleaze;
    self.matrixDefenseRating = self.matrixDataProcessing + self.matrixFirewall;
    self.matrixInitiative = self.matrixInitBonus + self.matrixDataProcessing + self.attrIntuition;
    self.boxesMatrix = (self.matrixDeviceRating+1)/2 + 8;
}

-(void) setMatrixDefaultsDrone {
    // For drones and vehicles, the ratings are derived from Pilot and Sensor.
    self.matrixDeviceRating = self.vehSensor;
    self.matrixAttack = 0;
    self.matrixSleaze = 0;
    self.matrixDataProcessing = self.vehSensor;
    self.matrixFirewall = self.vehSensor;
    self.programSlots = (self.vehPilot +1) /2;
    self.matrixInitBonus = 0;
    self.matrixAttackRating = 0;
    self.matrixDefenseRating = self.matrixDataProcessing + self.matrixFirewall;
    // Technically, vehicles and drones don't exist purely in the matrix, but
    // I'm setting the values to their physical stats, just in case.
    self.matrixInitiative = self.vehPilot * 2;
    self.matrixDice = 4;
}

-(void) setMatrixDefaultsRCC {
    if (self.actorType == ACTOR_TYPE_VEHICLE || self.actorType == ACTOR_TYPE_DRONE) {
        [self setMatrixDefaultsDrone];
        return;
    }
    int16_t rccDR;
    // For RCCs, this is a mess.
    switch (self.rcc) {
        case 0:
            rccDR = 0;
            self.matrixDataProcessing = 0;
            self.matrixFirewall = 0;
            break;
        case 1:
            rccDR = 1;
            self.matrixDataProcessing = 3;
            self.matrixFirewall = 2;
            break;
        case 2:
            rccDR = 2;
            self.matrixDataProcessing = 3;
            self.matrixFirewall = 3;
            break;
        case 3:
            rccDR = 3;
            self.matrixDataProcessing = 4;
            self.matrixFirewall = 4;
            break;
        case 4:
            rccDR = 4;
            self.matrixDataProcessing = 5;
            self.matrixFirewall = 4;
            break;
        case 5:
            rccDR = 4;
            self.matrixDataProcessing = 4;
            self.matrixFirewall = 5;
            break;
        case 6:
            rccDR = 5;
            self.matrixDataProcessing = 6;
            self.matrixFirewall = 5;
            break;
        case 7:
            rccDR = 5;
            self.matrixDataProcessing = 5;
            self.matrixFirewall = 6;
            break;
        case 8:
            rccDR = 6;
            self.matrixDataProcessing = 6;
            self.matrixFirewall = 5;
            break;
        case 9:
            rccDR = 6;
            self.matrixDataProcessing = 7;
            self.matrixFirewall = 6;
            break;
        case 10:
            rccDR = 6;
            self.matrixDataProcessing = 8;
            self.matrixFirewall = 7;
            break;
        default:
            rccDR = 0;
            self.matrixDataProcessing = 8;
            self.matrixFirewall = 0;
            break;
    }
    
    if (self.cyberdeck >0) {
        self.matrixDeviceRating = MAX(rccDR, self.cyberdeck);
        self.matrixAttack = self.cyberdeck + 3;
        self.matrixSleaze = self.cyberdeck + 2;
    } else {
        self.matrixDeviceRating = rccDR;
        self.matrixAttack = 0;
        self.matrixSleaze = 0;
    }
    
    self.programSlots = self.matrixDataProcessing;
    self.matrixInitBonus = 0;
    
    self.matrixAttackRating = self.matrixAttack + self.matrixSleaze;
    self.matrixDefenseRating = self.matrixDataProcessing + self.matrixFirewall;
    
    self.matrixInitiative = self.matrixInitBonus + self.matrixDataProcessing + self.attrIntuition;
    self.boxesMatrix = (self.matrixDeviceRating+1)/2 + 8;
}

-(int16_t) bonusRemaining {
    // This calculates the reamining bonus points.
    if (self.actorType == ACTOR_TYPE_SPRITE) return 0;
    
    int16_t bonusUsed = 0;
    
    bonusUsed = bonusUsed + (self.matrixAttack - self.attrCharisma);
    bonusUsed = bonusUsed + (self.matrixSleaze - self.attrIntuition);
    bonusUsed = bonusUsed + (self.matrixDataProcessing - self.attrLogic);
    bonusUsed = bonusUsed + (self.matrixFirewall - self.attrWillpower);
    
    return (self.attrResonance - bonusUsed);
}

-(BOOL) bonusAttackGood {
    if (self.actorType == ACTOR_TYPE_SPRITE) return TRUE;
    int16_t increase = 0;
    int16_t limit = 0;
    
    increase = (self.matrixAttack - self.attrCharisma);
    limit = (self.attrCharisma+1) / 2;
    limit = MIN(limit, 4);
    return (increase <= limit);
}

-(BOOL) bonusSleazeGood {
    if (self.actorType == ACTOR_TYPE_SPRITE) return TRUE;
    int16_t increase = 0;
    int16_t limit = 0;
    
    increase = (self.matrixSleaze - self.attrIntuition);
    limit = (self.attrIntuition+1) / 2;
    limit = MIN(limit, 4);
    return (increase <= limit);
}

-(BOOL) bonusDataProcessingGood {
    if (self.actorType == ACTOR_TYPE_SPRITE) return TRUE;
    int16_t increase = 0;
    int16_t limit = 0;
    
    increase = (self.matrixDataProcessing - self.attrLogic);
    limit = (self.attrLogic+1) / 2;
    limit = MIN(limit, 4);
    return (increase <= limit);
}

-(BOOL) bonusFirewallGood {
    if (self.actorType == ACTOR_TYPE_SPRITE) return TRUE;
    int16_t increase = 0;
    int16_t limit = 0;
    
    increase = (self.matrixFirewall - self.attrWillpower);
    limit = (self.attrWillpower+1) / 2;
    limit = MIN(limit, 4);
    return (increase <= limit);
}

#pragma mark Getters for calculated-on-the-fly values.

- (NSNumber *) damageModifier {
    int x;
    
    // For regular characters, you have separate condition monitors
    if (self.actorCategory == ACTOR_CATEGORY_PC || self.actorCategory == ACTOR_CATEGORY_NORMAL) {
        x = ([[self valueForKey:@"physicalCondition"] intValue]) / 3;
        x = x+([[self valueForKey:@"stunCondition"] intValue]) / 3;
    } else {
        // For grunts, we just use the stun condition, and it's by 2.
        x = ([[self valueForKey:@"stunCondition"] intValue]) / 2;
    }
    return [NSNumber numberWithInt:-x];
}

- (NSNumber *) matrixDamageModifier {
    int x = ([[self valueForKey:@"matrixCondition"] intValue]) / 3;
    
    if (self.statusNoise) x = x + self.statusNoiseRating;
    
    return [NSNumber numberWithInt:-x];
}

-(NSNumber *) statusPoolModifier {
    int x = 0;
    
    if (self.statusDazed) x = x -3;
    if (self.statusChilled) x = x -1;
    if (self.statusConfused) x = x - self.statusConfusedRating;
    if (self.statusCover && self.statusCoverRating == 4) x = x -2;
    if (self.statusDeafened) x = x - 3;
    if (self.statusFatigued) x = x - (2 * self.statusFatiguedRating);
    if (self.statusFrightened) x = x - 4;
    if (self.statusImmobilized) x = x -3;
    if (self.statusZapped) x = x -1;
    return [NSNumber numberWithInt:x];
}

- (NSNumber *) initiativeScoreAdjusted {
    // The initiative score can be adjusted based on a bunch of things:
    // The current mode
    // Certain status effects - zapped, chilled, dazed
    int x;
    
    x = ([[self valueForKey:@"currentInit"] intValue]);
    
    if ([[self valueForKey:@"statusChilled"] boolValue]) {
        x = x -4;
    }
    if ([[self valueForKey:@"statusDazed"] boolValue]) {
        x = x -4;
    }
    if ([[self valueForKey:@"statusZapped"] boolValue]) {
        x = x -2;
    }
    return [NSNumber numberWithInt:x];
}

#pragma mark Initiative and round handlers.

-(void) rollInit {
    // Roll initiative.
    sr6Mode curMode;
    int initStat;
    int numDice;
    int diceValue;
    int numMajor;
    int numMinor;
    
    // Roll initiative for the current actor.
    curMode = [self currentMode];
    
    // Figure out what the current mode values are.
    if (curMode == kModePhysical) {
        initStat = [self physicalInitiative];
        numDice = [self physicalDice];
        numMajor = [self physicalMajor];
        numMinor = [self physicalMinor];
    } else if (curMode == kModeMatrixCold) {
        initStat = [self matrixInitiative];
        numDice = [self matrixDice]-1; // The values entered are for hot mode - in cold is 1 less.
        numMajor = [self matrixMajor];
        numMinor = [self matrixMinor]-1; // Ditto.
    } else if (curMode == kModeMatrixHot) {
        initStat = [self matrixInitiative];
        numDice = [self matrixDice];
        numMajor = [self matrixMajor];
        numMinor = [self matrixMinor];
    } else { //(curMode == kModeAstral) Use the matrix values, as we have overloaded that value.
        initStat = [self astralInitiative];
        numDice = [self astralDice];
        numMajor = [self astralMajor];
        numMinor = [self astralMinor];
    }
    
    // If we are a rating-based actor, we need to add two times the rating.
    if ([self usesRating]) {
        initStat = initStat + (2 * self.rating);
    }
    
    // Roll the initiative dice.
    diceValue = [[self SRRoller]rollSum:numDice];
    
    // Set the values
    self.currentInit = initStat+diceValue;
    self.currentDice = numDice;
    self.currentMajor = numMajor;
    self.currentMinor = numMinor;
}

-(void) clearDamage {
    // Clear the damage stuff.
    self.stunCondition = 0;
    self.matrixCondition = 0;
    self.physicalCondition = 0;
}

-(void) newRound {
    // All we need to do here is handle status durations. So, go through each one, and reduce the duration if needed.
    // If there is no duration left, disable the status.
    // Decrement the status durations, and reduce the strength of the poison.
    
    if (self.statusBackground && self.statusBackgroundDuration != -1) {
        self.statusBackgroundDuration--;
        if (self.statusBackgroundDuration == 0) {
            self.statusBackground = FALSE;
        }
    }
    if (self.statusBlinded && self.statusBlindedDuration != -1) {
        self.statusBlindedDuration--;
        if (self.statusBlindedDuration == 0) {
            self.statusBlinded = FALSE;
        }
    }
    if (self.statusBurning && self.statusBurningDuration != -1) {
        self.statusBurningDuration--;
        if (self.statusBurningDuration == 0) {
            self.statusBurning = FALSE;
        }
    }
    if (self.statusChilled && self.statusChilledDuration != -1) {
        self.statusChilledDuration--;
        if (self.statusChilledDuration == 0) {
            self.statusChilled = FALSE;
        }
    }
    if (self.statusConfused && self.statusConfusedDuration != -1) {
        self.statusConfusedDuration--;
        if (self.statusConfusedDuration == 0) {
            self.statusConfused = FALSE;
        }
    }
    if (self.statusCorrossive && self.statusCorrossiveDuration != -1) {
        self.statusCorrossiveDuration--;
        if (self.statusCorrossiveDuration == 0) {
            self.statusCorrossive = FALSE;
        }
    }
    if (self.statusCover && self.statusCoverDuration != -1) {
        self.statusCoverDuration--;
        if (self.statusCoverDuration == 0) {
            self.statusCover = FALSE;
        }
    }
    if (self.statusDazed && self.statusDazedDuration != -1) {
        self.statusDazedDuration--;
        if (self.statusDazedDuration == 0) {
            self.statusDazed = FALSE;
        }
    }
    if (self.statusDeafened && self.statusDeafenedDuration != -1) {
        self.statusDeafenedDuration--;
        if (self.statusDeafenedDuration == 0) {
            self.statusDeafened = FALSE;
        }
    }
    if (self.statusDisabledArm && self.statusDisabledArmDuration != -1) {
        self.statusDisabledArmDuration--;
        if (self.statusDisabledArmDuration == 0) {
            self.statusDisabledArm = FALSE;
        }
    }
    if (self.statusDisabledLeg && self.statusDisabledLegDuration != -1) {
        self.statusDisabledLegDuration--;
        if (self.statusDisabledLegDuration == 0) {
            self.statusDisabledLeg = FALSE;
        }
    }
    if (self.statusFatigued && self.statusFatiguedDuration != -1) {
        self.statusFatiguedDuration--;
        if (self.statusFatiguedDuration == 0) {
            self.statusFatigued = FALSE;
        }
    }
    if (self.statusFrightened && self.statusFrightenedDuration != -1) {
        self.statusFrightenedDuration--;
        if (self.statusFrightenedDuration == 0) {
            self.statusFrightened = FALSE;
        }
    }
    if (self.statusHazed && self.statusHazedDuration != -1) {
        self.statusHazedDuration--;
        if (self.statusHazedDuration == 0) {
            self.statusHazed = FALSE;
        }
    }
    if (self.statusHobbled && self.statusHobbledDuration != -1) {
        self.statusHobbledDuration--;
        if (self.statusHobbledDuration == 0) {
            self.statusHobbled = FALSE;
        }
    }
    if (self.statusImmobilized && self.statusImmobilizedDuration != -1) {
        self.statusImmobilizedDuration--;
        if (self.statusImmobilizedDuration == 0) {
            self.statusImmobilized = FALSE;
        }
    }
    if (self.statusInvisible && self.statusInvisibleDuration != -1) {
        self.statusInvisibleDuration--;
        if (self.statusInvisibleDuration == 0) {
            self.statusInvisible = FALSE;
        }
    }
    if (self.statusInvisibleImproved && self.statusInvisibleImprovedDuration != -1) {
        self.statusInvisibleImprovedDuration--;
        if (self.statusInvisibleImprovedDuration == 0) {
            self.statusInvisibleImproved = FALSE;
        }
    }
    if (self.statusMuted && self.statusMutedDuration != -1) {
        self.statusMutedDuration--;
        if (self.statusMutedDuration == 0) {
            self.statusMuted = FALSE;
        }
    }
    if (self.statusNauseated && self.statusNauseatedDuration != -1) {
        self.statusNauseatedDuration--;
        if (self.statusNauseatedDuration == 0) {
            self.statusNauseated = FALSE;
        }
    }
    if (self.statusNoise && self.statusNoiseDuration != -1) {
        self.statusNoiseDuration--;
        if (self.statusNoiseDuration == 0) {
            self.statusNoise = FALSE;
        }
    }
    if (self.statusOffBalance && self.statusOffBalanceDuration != -1) {
        self.statusOffBalanceDuration--;
        if (self.statusOffBalanceDuration == 0) {
            self.statusOffBalance = FALSE;
        }
    }
    if (self.statusPanicked && self.statusPanickedDuration != -1) {
        self.statusPanickedDuration--;
        if (self.statusPanickedDuration == 0) {
            self.statusPanicked = FALSE;
        }
    }
    if (self.statusPetrified && self.statusPetrifiedDuration != -1) {
        self.statusPetrifiedDuration--;
        if (self.statusPetrifiedDuration == 0) {
            self.statusPetrified = FALSE;
        }
    }
    if (self.statusPoisoned && self.statusPoisonedDuration != -1) {
        self.statusPoisonedDuration--;
        if (self.statusPoisonedDuration == 0) {
            self.statusPoisoned = FALSE;
            self.statusPoisonedRating = 0;
        }
    } else if (self.statusPoisoned) {
        // Posion weakens every round, so we decrement the rating, no matter the duration.
        self.statusPoisonedRating--;
        if (self.statusPoisonedRating == 0) {
            self.statusPoisoned = FALSE;
            self.statusPoisonedDuration = 0;
        }
    }
    if (self.statusProne && self.statusProneDuration != -1) {
        self.statusProneDuration--;
        if (self.statusProneDuration == 0) {
            self.statusProne = FALSE;
        }
    }
    if (self.statusSilent && self.statusSilentDuration != -1) {
        self.statusSilentDuration--;
        if (self.statusSilentDuration == 0) {
            self.statusSilent = FALSE;
        }
    }
    if (self.statusSilentImproved && self.statusSilentImprovedDuration != -1) {
        self.statusSilentImprovedDuration--;
        if (self.statusSilentImprovedDuration == 0) {
            self.statusSilentImproved = FALSE;
        }
    }
    if (self.statusStilled && self.statusStilledDuration != -1) {
        self.statusStilledDuration--;
        if (self.statusStilledDuration == 0) {
            self.statusStilled = FALSE;
        }
    }
    if (self.statusWet && self.statusWetDuration != -1) {
        self.statusWetDuration--;
        if (self.statusWetDuration == 0) {
            self.statusWet = FALSE;
        }
    }
    if (self.statusZapped && self.statusZappedDuration != -1) {
        self.statusZappedDuration--;
        if (self.statusZappedDuration == 0) {
            self.statusZapped = FALSE;
        }
    }
    
    [self buildArray];
}

-(void)rollPerception {
    NSInteger pool;
    
    if (self.currentMode == kModeMatrixHot || self.currentMode == kModeMatrixCold) {
        pool = [self getSkillTestPool:SR6_SKILL_ELECTRONICS attribute:SR6_ATTR_INTUITION specialization:kSpecializationNone withDamageModifiers:YES withMatrixDamageModifiers:NO  withStatusModifiers:YES];
    } else {
        pool = [self getSkillTestPool:SR6_SKILL_PERCEPTION attribute:SR6_ATTR_NULL specialization:kSpecializationNone withDamageModifiers:YES withMatrixDamageModifiers:NO  withStatusModifiers:YES];
    }
    
    [[self SRRoller] rollDice:(int)pool wildDie:FALSE explode:FALSE twosGlitch:FALSE];
    self.hitsPerception = [[self SRRoller] numHits];
}

-(void)rollStealth {
    NSInteger pool;
    pool = [self getSkillTestPool:SR6_SKILL_STEALTH attribute:SR6_ATTR_NULL specialization:kSpecializationNone withDamageModifiers:YES withMatrixDamageModifiers:NO  withStatusModifiers:YES];
    [[self SRRoller] rollDice:(int)pool wildDie:FALSE explode:FALSE twosGlitch:FALSE];
    self.hitsStealth = [[self SRRoller] numHits];
}

-(void)rollSurprise {
    NSInteger pool;
    
    pool = [self getAttributeTestPool:SR6_ATTR_REACTION secondAttribute:SR6_ATTR_INTUITION withDamageModifiers:YES withMatrixDamageModifiers:(self.currentMode == kModeMatrixHot || self.currentMode == kModeMatrixCold) withStatusModifiers:YES];
    [[self SRRoller] rollDice:(int)pool wildDie:FALSE explode:FALSE twosGlitch:FALSE];
    self.hitsSurprise = [[self SRRoller] numHits];
}

#pragma mark Skill Rollers

-(NSString *)ratingDescription {
    NSString *tmpStr;
    if ([self showLevel]) {
        if (self.actorType == ACTOR_TYPE_AGENT) {
            tmpStr = [NSString stringWithFormat:@"%@%d%@",SR6_RATING_LEAD, self.rating, SR6_RATING_TAIL];
        } else if (self.actorType == ACTOR_TYPE_SPRITE){
            tmpStr = [NSString stringWithFormat:@"%@%d%@",SR6_LEVEL_LEAD, self.rating, SR6_RATING_TAIL];
        } else if (self.actorCategory == ACTOR_CATEGORY_GRUNT || self.actorCategory == ACTOR_CATEGORY_LIEUTENANT){
            tmpStr = [NSString stringWithFormat:@"%@%d%@",SR6_PR_LEAD, self.rating, SR6_RATING_TAIL];
        } else { // Default to Force
            tmpStr = [NSString stringWithFormat:@"%@%d%@",SR6_FORCE_LEAD, self.rating, SR6_RATING_TAIL];
        }
    } else {
        tmpStr = @"";
    }
    return tmpStr;
}

-(NSInteger) getSkillTestPool:(NSInteger)skill attribute:(NSInteger)attribute specialization:(sr6Specialization) specialization withDamageModifiers:(BOOL)dmgMods withMatrixDamageModifiers:(BOOL)matrixMods withStatusModifiers:(BOOL)statusMods {
    // This figure out how many dice need to be in a skill test pool.
    NSInteger pool;
    
    pool = 0;
    
    // Check the attribute to see if we are using the default.
    if (attribute == SR6_ATTR_NULL) {
        attribute = [self getDefaultAttributeForSkill:skill];
    }
    
    pool = pool + [self getPoolForSkill:skill];
    pool = pool + [self getPoolForAttribute:attribute];
    
    // The final bits - handle the specialization
    switch (specialization) {
        case kSpecializationNone:
            break;
        case kSpecializationSpecialization:
            pool = pool+2;
            break;
        case kSpecializationExpertise:
            pool = pool +3;
        default:
            break;
    }
    
    // And damage modifiers
    // The modifiers come as negatives.
    if (dmgMods) {
        pool = pool + [self.damageModifier integerValue];
    }
    
    if (matrixMods) {
        pool = pool + [self.matrixDamageModifier integerValue];
    }
    
    if (statusMods) {
        pool = pool + [self.statusPoolModifier integerValue];
    }
    
    if (pool <0) {
        NSLog(@"Bad pool - %@",[self getSkillTestDescription:skill attribute:attribute specialization:specialization withDamageModifiers:dmgMods withMatrixDamageModifiers:matrixMods withStatusModifiers:statusMods rollName:nil]);
        pool = 0;
    }
    
    // And return the values.
    return (pool);
}

-(NSInteger) getAttributeTestPool:(NSInteger)firstAttribute secondAttribute:(NSInteger)secondAttribute withDamageModifiers:(BOOL)dmgMods withMatrixDamageModifiers:(BOOL)matrixMods withStatusModifiers:(BOOL)statusMods {
    // This figure out how many dice need to be in a skill test pool.
    
    NSInteger pool;
    
    pool = 0;
    
    // The big question is whether this is a single attribute test, or a two attribute test.
    if (secondAttribute != SR6_ATTR_NULL) {
        // The description starts with the name (and rating if it has one)
        pool = pool + [self getPoolForAttribute:firstAttribute] + [self getPoolForAttribute:secondAttribute];
    } else {
        // This is a single atr test.
        pool = pool + [self getPoolForAttribute:firstAttribute];
    }
    
    // Damage modifiers
    // The modifiers come as negatives.
    if (dmgMods) {
        pool = pool + [self.damageModifier integerValue];
    }
    
    if (matrixMods) {
        pool = pool + [self.matrixDamageModifier integerValue];
    }
    
    if (statusMods) {
        pool = pool + [self.statusPoolModifier integerValue];
    }
    
    // And return the value.
    return (pool);
}

-(NSString *)getSkillTestDescription:(NSInteger)skill attribute:(NSInteger)attribute specialization:(sr6Specialization) specialization withDamageModifiers:(BOOL)dmgMods withMatrixDamageModifiers:(BOOL)matrixMods withStatusModifiers:(BOOL)statusMods rollName:(nullable NSString *)rollName {
    NSMutableString *rollDescription;
    
    // Check the attribute to see if we are using the default.
    if (attribute == SR6_ATTR_NULL) {
        attribute = [self getDefaultAttributeForSkill:skill];
    }
    
    // The description starts with the name (and rating if it has one)
    if (rollName != nil) {
        rollDescription = [NSMutableString stringWithFormat:@"%@%@ %@ (%@+%@)",self.charName, [self ratingDescription],rollName, [self getStringForSkill:skill],[self getStringForAttribute:attribute]];
    } else {
        rollDescription = [NSMutableString stringWithFormat:@"%@%@ %@+%@",self.charName, [self ratingDescription],[self getStringForSkill:skill],[self getStringForAttribute:attribute]];
    }
    
    // The final bits - handle the specialization
    switch (specialization) {
        case kSpecializationNone:
            break;
        case kSpecializationSpecialization:
            [rollDescription appendString:[NSString stringWithFormat:@" (%@)",SR6_SPEC_SPECIALIZATION_SHORT]];
            break;
        case kSpecializationExpertise:
            [rollDescription appendString:[NSString stringWithFormat:@" (%@)",SR6_SPEC_EXPERTISE_SHORT]];
        default:
            break;
    }
    
    // And damage modifiers
    // Damage modifiers
    // The modifiers come as negatives.
    NSMutableString *modStr = [[NSMutableString alloc] init];
    
    if (dmgMods) {
        [modStr appendString:@",Dmg"];
    }
    
    if (matrixMods) {
        [modStr appendString:@",Mtx"];
    }
    if (statusMods) {
        [modStr appendString:@",Sts"];
    }
    
    if (modStr.length > 0) {
        // We have something...but we need to finish wrapping it up, wrap it in parenthesis, and append it
        [rollDescription appendString:[NSString stringWithFormat:@" (%@ Mods)",[modStr substringFromIndex:1]]];
    }
    
    // And return the values.
    return (NSString *)rollDescription;
}

-(NSString *)getAttributeTestDescription:(NSInteger)firstAttribute secondAttribute:(NSInteger)secondAttribute withDamageModifiers:(BOOL)dmgMods withMatrixDamageModifiers:(BOOL)matrixMods withStatusModifiers:(BOOL)statusMods rollName:(nullable NSString *) rollName {
     NSMutableString *rollDescription;
    
    // The big question is whether this is a single attribute test, or a two attribute test.
    if (rollName != nil) {
        if (secondAttribute != SR6_ATTR_NULL) {
            // The description starts with the name (and rating if it has one)
            rollDescription = [NSMutableString stringWithFormat:@"%@%@ %@ (%@+%@)",self.charName, [self ratingDescription],rollName, [self getStringForAttribute:firstAttribute],[self getStringForAttribute:secondAttribute]];
        } else {
            // This is a single atr test.
            rollDescription = [NSMutableString stringWithFormat:@"%@%@ %@ %@",self.charName, [self ratingDescription],rollName, [self getStringForAttribute:firstAttribute]];
        }
    } else {
        if (secondAttribute != SR6_ATTR_NULL) {
            // The description starts with the name (and rating if it has one)
            rollDescription = [NSMutableString stringWithFormat:@"%@%@ %@+%@",self.charName, [self ratingDescription],[self getStringForAttribute:firstAttribute],[self getStringForAttribute:secondAttribute]];
        } else {
            // This is a single atr test.
            rollDescription = [NSMutableString stringWithFormat:@"%@%@ %@",self.charName, [self ratingDescription],[self getStringForAttribute:firstAttribute]];
        }
    }
    
    // Damage modifiers
    // The modifiers come as negatives.
    NSMutableString *modStr = [[NSMutableString alloc] init];
    
    if (dmgMods) {
        [modStr appendString:@",Dmg"];
    }
    
    if (matrixMods) {
        [modStr appendString:@",Mtx"];
    }
    if (statusMods) {
        [modStr appendString:@",Sts"];
    }
    
    if (modStr.length > 0) {
        // We have something...but we need to finish wrapping it up, wrap it in parenthesis, and append it
        [rollDescription appendString:[NSString stringWithFormat:@" (%@ Mods)",[modStr substringFromIndex:1]]];
    }
    // And return the values.
    return (NSString *)rollDescription;
}

-(NSInteger) getPoolForSkill:(NSInteger)skill {
    // We could do a big nasty list of if/elses. Or we could use a selector.
    // But we'd have to validate the selector, which would be a big if/else thing.
    // So...might as well.
    
    // Yes, I could have done this is a switch statement, but I started doing this
    // with strings, and I'm too lazy to go back and fix it.
    NSInteger pool;
    
    if (skill == SR6_SKILL_ASTRAL) {
        pool = self.skillAstral;
    } else if (skill == SR6_SKILL_ATHLETICS) {
        pool = self.skillAthletics;
    } else if (skill == SR6_SKILL_BIOTECH) {
        pool = self.skillBiotech;
    } else if (skill == SR6_SKILL_CLOSE_COMBAT) {
        pool = self.skillCloseCombat;
    } else if (skill == SR6_SKILL_CON) {
        pool = self.skillCon;
    } else if (skill == SR6_SKILL_CONJURING) {
        pool = self.skillConjuring;
    } else if (skill == SR6_SKILL_CRACKING || skill == SR6_SKILL_CRACKING_2 || skill == SR6_SKILL_CRACKING_RES || skill == SR6_SKILL_CRACKING_RES_2) {
        pool = self.skillCracking;
    } else if (skill == SR6_SKILL_ELECTRONICS || skill == SR6_SKILL_ELECTRONICS_2 || skill == SR6_SKILL_ELECTRONICS_RES || skill == SR6_SKILL_ELECTRONICS_RES_2 || skill == SR6_SKILL_MATRIX_PERCEPTION) {
        pool = self.skillElectronics;
    } else if (skill == SR6_SKILL_ENCHANTING) {
        pool = self.skillEnchanting;
    } else if (skill == SR6_SKILL_ENGINEERING) {
        pool = self.skillEngineering;
    } else if (skill == SR6_SKILL_EXOTIC_WEAPONS) {
        pool = self.skillExoticWeapons;
    } else if (skill == SR6_SKILL_FIREARMS) {
        pool = self.skillFirearms;
    } else if (skill == SR6_SKILL_INFLUENCE) {
        pool = self.skillInfluence;
    } else if (skill == SR6_SKILL_OUTDOORS) {
        pool = self.skillOutdoors;
    } else if (skill == SR6_SKILL_PERCEPTION) {
        pool = self.skillPerception;
    } else if (skill == SR6_SKILL_PILOT) {
        pool = self.skillPilot;
    } else if (skill == SR6_SKILL_SORCERY || skill == SR6_SKILL_SORCERY_2) {
        pool = self.skillSorcery;
    } else if (skill == SR6_SKILL_STEALTH) {
        pool = self.skillStealth;
    } else if (skill == SR6_SKILL_TASKING) {
        pool = self.skillTasking;
    } else if (skill == SR6_SKILL_OTHER) {
        pool = self.skillOther;
    } else if (skill == SR6_SKILL_NULL) {
        NSLog (@"SR6Actor - getPoolForSkill - null skill value");
        pool = 0;
    } else {
        NSLog (@"SR6Actor - getPoolForSkill - bad skill value %ld",skill);
        pool = 0;
    }
    
    // If it's a rating-based actor, the pool is the rating, if it's not zero.
    if (self.usesRating && pool != 0) {
        pool = self.rating;
    }
    
    // If the pool is zero (or somehow lower), they are defaulting, so put it to -1.
    if (pool <= 0) {
        pool = -1;
    }
    
    return pool;
}

-(NSInteger) getDefaultAttributeForSkill:(NSInteger)skill {
    NSInteger attr;
    
    if (skill == SR6_SKILL_ASTRAL) {
        attr = SR6_ATTR_INTUITION;
    } else if (skill == SR6_SKILL_ATHLETICS) {
        attr = SR6_ATTR_AGILITY;
    } else if (skill == SR6_SKILL_BIOTECH) {
        attr = SR6_ATTR_LOGIC;
    } else if (skill == SR6_SKILL_CLOSE_COMBAT) {
        attr = SR6_ATTR_AGILITY;
    } else if (skill == SR6_SKILL_CON) {
        attr = SR6_ATTR_CHARISMA;
    } else if (skill == SR6_SKILL_CONJURING) {
        attr = SR6_ATTR_MAGIC;
    } else if (skill == SR6_SKILL_CRACKING || skill == SR6_SKILL_CRACKING_2) {
        attr = SR6_ATTR_LOGIC;
    } else if (skill == SR6_SKILL_ELECTRONICS || skill == SR6_SKILL_ELECTRONICS_2) {
        attr = SR6_ATTR_LOGIC;
    } else if (skill == SR6_SKILL_ENCHANTING) {
        attr = SR6_ATTR_MAGIC;
    } else if (skill == SR6_SKILL_ENGINEERING) {
        attr = SR6_ATTR_LOGIC;
    } else if (skill == SR6_SKILL_EXOTIC_WEAPONS) {
        attr = SR6_ATTR_AGILITY;
    } else if (skill == SR6_SKILL_FIREARMS) {
        attr = SR6_ATTR_AGILITY;
    } else if (skill == SR6_SKILL_INFLUENCE) {
        attr = SR6_ATTR_CHARISMA;
    } else if (skill == SR6_SKILL_OUTDOORS) {
        attr = SR6_ATTR_INTUITION;
    } else if (skill == SR6_SKILL_PERCEPTION) {
        attr = SR6_ATTR_INTUITION;
    } else if (skill == SR6_SKILL_PILOT) {
        attr = SR6_ATTR_REACTION;
    } else if (skill == SR6_SKILL_SORCERY || skill == SR6_SKILL_SORCERY_2) {
        attr = SR6_ATTR_MAGIC;
    } else if (skill == SR6_SKILL_STEALTH) {
        attr = SR6_ATTR_AGILITY;
    } else if (skill == SR6_SKILL_TASKING) {
        attr = SR6_ATTR_RESONANCE;
    } else if (skill == SR6_SKILL_OTHER) {
        attr = SR6_ATTR_AGILITY;
    } else if (skill == SR6_SKILL_MATRIX_PERCEPTION) {
        attr = SR6_ATTR_INTUITION;
    } else if (skill == SR6_SKILL_CRACKING_RES || skill == SR6_SKILL_CRACKING_RES_2 || skill == SR6_SKILL_ELECTRONICS_RES || skill == SR6_SKILL_ELECTRONICS_RES_2) {
        attr = SR6_ATTR_RESONANCE;
    } else if (skill == SR6_SKILL_NULL) {
        NSLog (@"SR6Actor - getDefaultAttributeForSkill - null skill value");
        attr = SR6_ATTR_NULL;
    } else {
        NSLog (@"SR6Actor - getDefaultAttributeForSkill - bad skill value %ld",skill);
        attr = SR6_ATTR_NULL;
    }

    return attr;
}

-(NSString *) getStringForSkill:(NSInteger)skill {
    // Yes, I could have done this is a switch statement, but I started doing this
    // with strings, and I'm too lazy to go back and fix it.
    NSString *tmpStr;
    
    if (skill == SR6_SKILL_ASTRAL) {
        tmpStr = @"Ast";
    } else if (skill == SR6_SKILL_ATHLETICS) {
        tmpStr = @"Ath";
    } else if (skill == SR6_SKILL_BIOTECH) {
        tmpStr = @"Bio";
    } else if (skill == SR6_SKILL_CLOSE_COMBAT) {
        tmpStr = @"CC";
    } else if (skill == SR6_SKILL_CON) {
        tmpStr = @"Con";
    } else if (skill == SR6_SKILL_CONJURING) {
        tmpStr = @"Conj";
    } else if (skill == SR6_SKILL_CRACKING || skill == SR6_SKILL_CRACKING_2 || skill == SR6_SKILL_CRACKING_RES || skill == SR6_SKILL_CRACKING_RES_2) {
        tmpStr = @"Crck";
    } else if (skill == SR6_SKILL_ELECTRONICS || skill == SR6_SKILL_ELECTRONICS_2 || skill == SR6_SKILL_ELECTRONICS_RES || skill == SR6_SKILL_ELECTRONICS_RES_2 || skill == SR6_SKILL_MATRIX_PERCEPTION) {
        tmpStr = @"Elec";
    } else if (skill == SR6_SKILL_ENCHANTING) {
        tmpStr = @"Ench";
    } else if (skill == SR6_SKILL_ENGINEERING) {
        tmpStr = @"Eng";
    } else if (skill == SR6_SKILL_EXOTIC_WEAPONS) {
        tmpStr = @"Extc";
    } else if (skill == SR6_SKILL_FIREARMS) {
        tmpStr = @"Frrms";
    } else if (skill == SR6_SKILL_INFLUENCE) {
        tmpStr = @"Inf";
    } else if (skill == SR6_SKILL_OUTDOORS) {
        tmpStr = @"Out";
    } else if (skill == SR6_SKILL_PERCEPTION) {
        tmpStr = @"Perc";
    } else if (skill == SR6_SKILL_PILOT) {
        tmpStr = @"Pil";
    } else if (skill == SR6_SKILL_SORCERY || skill == SR6_SKILL_SORCERY_2) {
        tmpStr = @"Sorc";
    } else if (skill == SR6_SKILL_STEALTH) {
        tmpStr = @"Stlth";
    } else if (skill == SR6_SKILL_TASKING) {
        tmpStr = @"Task";
    } else if (skill == SR6_SKILL_OTHER) {
        tmpStr = @"Other";
    } else if (skill == SR6_SKILL_NULL) {
        NSLog (@"SR6Actor - getStringForSkill - null skill value");
        tmpStr = @"";
    } else {
        NSLog (@"SR6Actor - getStringForSkill - bad skill value %ld",skill);
        tmpStr = @"";
    }
    
    return tmpStr;
}

-(NSInteger) getPoolForAttribute:(NSInteger)attribute {
    // We could do a big nasty list of if/elses. Or we could use a selector.
    // But we'd have to validate the selector, which would be a big if/else thing.
    // So...might as well.
    NSInteger pool;
   
    switch (attribute) {
        case SR6_ATTR_NULL:
            pool = 0;
            break;
        case SR6_ATTR_BODY:
            // This one is a bit tricky, because depending on context, it could be two different values.
            if (self.isVehicle) {
                pool = self.vehBody;
            } else {
                pool = self.attrBody;
            }
            break;
        case SR6_ATTR_AGILITY:
            pool = self.attrAgility;
            break;
        case SR6_ATTR_REACTION:
            if (self.isVehicle) {
                pool = self.vehPilot;
            } else {
                pool = self.attrReaction;
            }
            break;
        case SR6_ATTR_STRENGTH:
            if (self.isVehicle) {
                pool = self.vehBody;
            } else {
                pool = self.attrStrength;
            }
            break;
        case SR6_ATTR_WILLPOWER:
            if (self.isVehicle) {
                pool = self.vehPilot;
            } else {
                pool = self.attrWillpower;
            }
            break;
        case SR6_ATTR_LOGIC:
            if (self.isVehicle) {
                pool = self.vehPilot;
            } else {
                pool = self.attrLogic;
            }
            break;
        case SR6_ATTR_INTUITION:
            if (self.isVehicle) {
                pool = self.vehPilot;
            } else {
                pool = self.attrIntuition;
            }
            break;
        case SR6_ATTR_CHARISMA:
            if (self.isVehicle) {
                pool = self.vehPilot;
            } else {
                pool = self.attrCharisma;
            }
            break;
        case SR6_ATTR_EDGE:
            pool = self.attrEdge;
            break;
        case SR6_ATTR_MAGIC:
            pool = self.attrMagic;
            break;
        case SR6_ATTR_RESONANCE:
            // Yes, I overloaded magic and resonance. Probably a bad idea...
            pool = self.attrMagic;
            break;
        case SR6_ATTR_RATING:
            pool = self.rating;
            break;
        case SR6_ATTR_DEVICE_RATING:
            pool = self.matrixDeviceRating;
            break;
        case SR6_ATTR_ATTACK:
            pool = self.matrixAttack;
            break;
        case SR6_ATTR_SLEAZE:
            pool = self.matrixSleaze;
            break;
        case SR6_ATTR_DATA_PROCESSING:
            pool = self.matrixDataProcessing;
            break;
        case SR6_ATTR_FIREWALL:
            pool = self.matrixFirewall;
            break;
        case SR6_ATTR_PILOT:
            pool = self.vehPilot;
            break;
        case SR6_ATTR_SENSOR:
            pool = self.vehSensor;
            break;
        default:
            NSLog(@"SR6Actor - getPoolForAttribute - Invalid Attribte %ld",attribute);
            pool = 0;
            break;
    }
    
    // If it's a rating-based actor, we have to adjust as the value is +/- the rating for attributes
    if (self.usesRating) {
        pool = pool + self.rating;
    }
    
    // If the pool is less than zero (how?) put it to 0;
    if (pool < 0) {
        pool = 0;
    }
    
    return pool;
}

-(NSString *) getStringForAttribute:(NSInteger)attribute {
// What it says on the tin.
    NSString *tmpStr;
    
    switch (attribute) {
        case SR6_ATTR_NULL:
            tmpStr = @"";
            break;
        case SR6_ATTR_BODY:
            if (self.isVehicle) {
                tmpStr = @"Plt";
            } else {
                tmpStr = @"Bod";
            }
            break;
        case SR6_ATTR_AGILITY:
            tmpStr = @"Agl";
            break;
        case SR6_ATTR_REACTION:
            if (self.isVehicle) {
                tmpStr = @"Pil";
            } else {
                tmpStr = @"Rx";
            }
            break;
        case SR6_ATTR_STRENGTH:
            if (self.isVehicle) {
                tmpStr = @"Bod";
            } else {
                tmpStr = @"Str";
            }
            break;
        case SR6_ATTR_WILLPOWER:
            if (self.isVehicle) {
                tmpStr = @"Pil";
            } else {
                tmpStr = @"WP";
            }
            break;
        case SR6_ATTR_LOGIC:
            if (self.isVehicle) {
                tmpStr = @"Pil";
            } else {
                tmpStr = @"Log";
            }
            break;
        case SR6_ATTR_INTUITION:
            if (self.isVehicle) {
                tmpStr = @"Pil";
            } else {
                tmpStr = @"Int";
            }
            break;
        case SR6_ATTR_CHARISMA:
            if (self.isVehicle) {
                tmpStr = @"Pil";
            } else {
                tmpStr = @"Cha";
            }
            break;
        case SR6_ATTR_EDGE:
            tmpStr = @"Edg";
            break;
        case SR6_ATTR_MAGIC:
            tmpStr = @"Mag";
            break;
        case SR6_ATTR_RESONANCE:
            tmpStr = @"Res";
            break;
        case SR6_ATTR_RATING:
            // Depends on what we are....
            if (ACTOR_TYPE_SPRITE) {
                tmpStr = @"Lvl";
            } else if (ACTOR_TYPE_AGENT) {
                tmpStr = @"Rtg";
            } else {
                tmpStr = @"Frc";
            }
            break;
        case SR6_ATTR_DEVICE_RATING:
            tmpStr = @"Dev Rtg";
            break;
        case SR6_ATTR_ATTACK:
            tmpStr = @"Att";
            break;
        case SR6_ATTR_SLEAZE:
            tmpStr = @"Slz";
            break;
        case SR6_ATTR_DATA_PROCESSING:
            tmpStr = @"DP";
            break;
        case SR6_ATTR_FIREWALL:
            tmpStr = @"FW";
            break;
        case SR6_ATTR_PILOT:
            tmpStr = @"Pil";
            break;
        case SR6_ATTR_SENSOR:
            tmpStr = @"Sens";
            break;
        default:
            NSLog(@"SR6Actor - getStringForAttribute - Invalid Attribte %ld",attribute);
            tmpStr = @"";
            break;
    }
    return tmpStr;
}

#pragma mark Status Manipulation

// THe statuses are handled in an extremely laborious fashion. I could have done this as a separate entity in the data model, but
// a) I don't know how and b) each status has it's own annoying fiddly bits. So it's stupid, but it works.

// Basically the statuses are tracked by 3 values - a boolean indicating if the status is active, a rating (if the status has a rating - some don't)
// and a duration. Durations of -1 indicate indefinite.

// The status table doesn't understand the statuses, so it works via an array that gets handed off to the Actor array controller. It handles displaying
// of the statuses in the table, and configuring the UI. It asks the actor to add/remove/update, which it does, and then it modifies the array that is
// (ultimately) the data source of the table.

// The public stuff is the obvious: clear, update, add, remove.
// These in turn call two methods (generally) - buildArray - which rebuilds the status data array (_statusArray), and buildStatusString, which is the
// show in the actor table as the single icon for each status.

// Statuses are identified using strings (yes, I know I said I don't like doing it, and I don't, but it seemed better than defining a massive enum or two.
// That might have been better, but this works. And there are so many emoji-symbols, that it was pretty easy to find ones that worked.

// You can add statuses fairly easily: update the object model, add the properties in the propeties file, and then update each of the below functions.
// Don't forget to add it in the encode/decode bits. I'd just search for one of the status names that's near it alphabetically, and update appropriately.
// You will need to add an entry in the ActorArrayController as well.

// I will probably add background count as a status once those rules are published.

-(void) clearStatuses {
    // Clear any of the statuses that are affecting the actor object.
    self.statusBackground = FALSE;
    self.statusBackgroundRating = 1;
    self.statusBackgroundDuration = -1;
    self.statusBlinded = FALSE;
    self.statusBlindedRating = 1;
    self.statusBlindedDuration = -1;
    self.statusBurning = FALSE;
    self.statusBurningRating = 1;
    self.statusBurningDuration = -1;
    self.statusChilled = FALSE;
    self.statusChilledDuration = -1;
    self.statusConfused = FALSE;
    self.statusConfusedRating = 1;
    self.statusConfusedDuration = -1;
    self.statusCorrossive = FALSE;
    self.statusCorrossiveRating = 1;
    self.statusCorrossiveDuration = -1;
    self.statusCover = FALSE;
    self.statusCoverRating = 1;
    self.statusCoverDuration = -1;
    self.statusDazed = FALSE;
    self.statusDazedDuration = -1;
    self.statusDeafened = FALSE;
    self.statusDeafenedRating = 1;
    self.statusDeafenedDuration = -1;
    self.statusDisabledArm = FALSE;
    self.statusDisabledArmRating = 1;
    self.statusDisabledArmDuration = -1;
    self.statusDisabledLeg = FALSE;
    self.statusDisabledLegRating = 1;
    self.statusDisabledLegDuration = -1;
    self.statusFatigued = FALSE;
    self.statusFatiguedRating = 1;
    self.statusFatiguedDuration = -1;
    self.statusFrightened = FALSE;
    self.statusFrightenedDuration = -1;
    self.statusHazed = FALSE;
    self.statusHazedDuration = -1;
    self.statusHobbled = FALSE;
    self.statusHobbledDuration = -1;
    self.statusImmobilized = FALSE;
    self.statusImmobilizedDuration = -1;
    self.statusInvisible = FALSE;
    self.statusInvisibleRating = 1;
    self.statusInvisibleDuration = -1;
    self.statusInvisibleImproved = FALSE;
    self.statusInvisibleImprovedRating = 1;
    self.statusInvisibleImprovedDuration = -1;
    self.statusMuted = FALSE;
    self.statusMutedDuration = -1;
    self.statusNauseated = FALSE;
    self.statusNauseatedDuration = -1;
    self.statusNoise = FALSE;
    self.statusNoiseRating = 1;
    self.statusNoiseDuration = -1;
    self.statusOffBalance = FALSE;
    self.statusOffBalanceDuration = -1;
    self.statusPanicked = FALSE;
    self.statusPanickedDuration = -1;
    self.statusPetrified = FALSE;
    self.statusPetrifiedDuration = -1;
    self.statusPoisoned = FALSE;
    self.statusPoisonedRating = 1;
    self.statusPoisonedDuration = -1;
    self.statusProne = FALSE;
    self.statusProneDuration = -1;
    self.statusSilent = FALSE;
    self.statusSilentRating = 1;
    self.statusSilentDuration = -1;
    self.statusSilentImproved = FALSE;
    self.statusSilentImprovedRating = 1;
    self.statusSilentImprovedDuration = -1;
    self.statusStilled = FALSE;
    self.statusStilledDuration = -1;
    self.statusWet = FALSE;
    self.statusWetDuration = -1;
    self.statusZapped = FALSE;
    self.statusZappedDuration = -1;
    
    // Since we've cleared the statuses, we need to clear the array. Could re-build, but this will be faster.
    [self clearArray];
    [self buildStatusString];
}

-(void)addStatus:(NSString *)statusName duration:(NSInteger) duration rating:(NSInteger) rating {
    // This adds the defined status to the SR6Actor object
    
    // Set the duration and rating, based on the type of entry.
    if ([statusName isEqualToString:SR6_STATUS_BACKGROUND]) {
        self.statusBackground = TRUE;
        self.statusBackgroundDuration = duration;
        self.statusBackgroundRating = rating;
    } else if ([statusName isEqualToString:SR6_STATUS_BLINDED]) {
        self.statusBlinded = TRUE;
        self.statusBlindedDuration = duration;
        self.statusBlindedRating = rating;
    } else if ([statusName isEqualToString:SR6_STATUS_BURNING]) {
        self.statusBurning = TRUE;
        self.statusBurningDuration = duration;
        self.statusBurningRating = rating;
    } else if ([statusName isEqualToString:SR6_STATUS_CHILLED]) {
        self.statusChilled = TRUE;
        self.statusChilledDuration = duration;
    } else if ([statusName isEqualToString:SR6_STATUS_CONFUSED]) {
        self.statusConfused = TRUE;
        self.statusConfusedDuration = duration;
        self.statusConfusedRating = rating;
    } else if ([statusName isEqualToString:SR6_STATUS_CORROSSIVE]) {
        self.statusCorrossive = TRUE;
        self.statusCorrossiveDuration = duration;
        self.statusCorrossiveRating = rating;
    } else if ([statusName isEqualToString:SR6_STATUS_COVER]) {
        self.statusCover = TRUE;
        self.statusCoverDuration = duration;
        self.statusCoverRating = rating;
    } else if ([statusName isEqualToString:SR6_STATUS_DAZED]) {
        self.statusDazed = TRUE;
        self.statusDazedDuration = duration;
    } else if ([statusName isEqualToString:SR6_STATUS_DEAFENED]) {
        self.statusDeafened = TRUE;
        self.statusDeafenedDuration = duration;
        self.statusDeafenedRating = rating;
    } else if ([statusName isEqualToString:SR6_STATUS_DISABLED_ARM]) {
        self.statusDisabledArm = TRUE;
        self.statusDisabledArmDuration = duration;
        self.statusDisabledArmRating = rating;
    } else if ([statusName isEqualToString:SR6_STATUS_DISABLED_LEG]) {
        self.statusDisabledLeg = TRUE;
        self.statusDisabledLegDuration = duration;
        self.statusDisabledLegRating = rating;
    } else if ([statusName isEqualToString:SR6_STATUS_FATIGUED]) {
        self.statusFatigued = TRUE;
        self.statusFatiguedDuration = duration;
        self.statusFatiguedRating = rating;
    } else if ([statusName isEqualToString:SR6_STATUS_FRIGHTENED]) {
        self.statusFrightened = TRUE;
        self.statusFrightenedDuration = duration;
    } else if ([statusName isEqualToString:SR6_STATUS_HAZED]) {
        self.statusHazed = TRUE;
        self.statusHazedDuration = duration;
    } else if ([statusName isEqualToString:SR6_STATUS_HOBBLED]) {
        self.statusHobbled = TRUE;
        self.statusHobbledDuration = duration;
    } else if ([statusName isEqualToString:SR6_STATUS_IMMOBILIZED]) {
        self.statusImmobilized = TRUE;
        self.statusImmobilizedDuration = duration;
    } else if ([statusName isEqualToString:SR6_STATUS_INVISIBLE]) {
        self.statusInvisible = TRUE;
        self.statusInvisibleDuration = duration;
        self.statusInvisibleRating = rating;
    } else if ([statusName isEqualToString:SR6_STATUS_INVISIBLE_IMP]) {
        self.statusInvisibleImproved = TRUE;
        self.statusInvisibleImprovedDuration = duration;
        self.statusInvisibleImprovedRating = rating;
    } else if ([statusName isEqualToString:SR6_STATUS_MUTED]) {
        self.statusMuted = TRUE;
        self.statusMutedDuration = duration;
    } else if ([statusName isEqualToString:SR6_STATUS_NAUSEATED]) {
        self.statusNauseated = TRUE;
        self.statusNauseatedDuration = duration;
    } else if ([statusName isEqualToString:SR6_STATUS_NOISE]) {
        self.statusNoise = TRUE;
        self.statusNoiseDuration = duration;
        self.statusNoiseRating = rating;
    } else if ([statusName isEqualToString:SR6_STATUS_OFF_BALANCE]) {
        self.statusOffBalance = TRUE;
        self.statusOffBalanceDuration = duration;
    } else if ([statusName isEqualToString:SR6_STATUS_PANICKED]) {
        self.statusPanicked = TRUE;
        self.statusPanickedDuration = duration;
    } else if ([statusName isEqualToString:SR6_STATUS_PETRIFIED]) {
        self.statusPetrified = TRUE;
        self.statusPetrifiedDuration = duration;
    } else if ([statusName isEqualToString:SR6_STATUS_POISONED]) {
        self.statusPoisoned = TRUE;
        self.statusPoisonedDuration = duration;
        self.statusPoisonedRating = rating;
    } else if ([statusName isEqualToString:SR6_STATUS_PRONE]) {
        self.statusProne = TRUE;
        self.statusProneDuration = duration;
    } else if ([statusName isEqualToString:SR6_STATUS_SILENT]) {
        self.statusSilent = TRUE;
        self.statusSilentDuration = duration;
        self.statusSilentRating = rating;
    } else if ([statusName isEqualToString:SR6_STATUS_SILENT_IMP]) {
        self.statusSilentImproved = TRUE;
        self.statusSilentImprovedDuration = duration;
        self.statusSilentImprovedRating = rating;
    } else if ([statusName isEqualToString:SR6_STATUS_STILLED]) {
        self.statusStilled = TRUE;
        self.statusStilledDuration = duration;
    } else if ([statusName isEqualToString:SR6_STATUS_WET]) {
        self.statusWet = TRUE;
        self.statusWetDuration = duration;
    } else if ([statusName isEqualToString:SR6_STATUS_ZAPPED]) {
        self.statusZapped = TRUE;
        self.statusZappedDuration = duration;
    } else {
        // We shouldn't ever get here...but if we do...
        self.notes = @"Uh-oh. Add status failed.";
    }
    
    // Now, we add the object to the managed array.
    // Rather than doing anything fancy, we just rebuild it.
    [self buildArray];
}

-(void)udpateStatus:(NSString *)statusName duration:(NSInteger) duration rating:(NSInteger) rating {
    // Pretty much just like adding a status. In fact, it's exactly like adding a status...so.
    [self addStatus:statusName duration:duration rating:rating];
}

-(void)removeStatus:(NSString *)statusName {
    // Remove the currently selected status. This is relatively easy.
    // Set the boolean flag to false, and the rating/duration to whatever the minimum value is.
    if ([statusName isEqualToString:SR6_STATUS_BACKGROUND]) {
        self.statusBackground = FALSE;
        self.statusBackgroundRating = 1;
        self.statusBackgroundDuration = 0;
    } else if ([statusName isEqualToString:SR6_STATUS_BLINDED]) {
        self.statusBlinded = FALSE;
        self.statusBlindedRating = 1;
        self.statusBlindedDuration = 0;
    } else if ([statusName isEqualToString:SR6_STATUS_BURNING]) {
        self.statusBurning = FALSE;
        self.statusBurningRating = 1;
        self.statusBurningDuration = 0;
    } else if ([statusName isEqualToString:SR6_STATUS_CHILLED]) {
        self.statusChilled = FALSE;
        self.statusChilledDuration = 0;
    } else if ([statusName isEqualToString:SR6_STATUS_CONFUSED]) {
        self.statusConfused = FALSE;
        self.statusConfusedRating = 1;
        self.statusConfusedDuration = 0;
    } else if ([statusName isEqualToString:SR6_STATUS_CORROSSIVE]) {
        self.statusCorrossive = FALSE;
        self.statusCorrossiveRating = 1;
        self.statusCorrossiveDuration = 0;
    } else if ([statusName isEqualToString:SR6_STATUS_COVER]) {
        self.statusCover = FALSE;
        self.statusCoverRating = 1;
        self.statusCoverDuration = 0;
    } else if ([statusName isEqualToString:SR6_STATUS_DAZED]) {
        self.statusDazed = FALSE;
        self.statusDazedDuration = 0;
    } else if ([statusName isEqualToString:SR6_STATUS_DEAFENED]) {
        self.statusDeafened = FALSE;
        self.statusDeafenedRating = 1;
        self.statusDeafenedDuration = 0;
    } else if ([statusName isEqualToString:SR6_STATUS_DISABLED_ARM]) {
        self.statusDisabledArm = FALSE;
        self.statusDisabledArmRating = 1;
        self.statusDisabledArmDuration = 0;
    } else if ([statusName isEqualToString:SR6_STATUS_DISABLED_LEG]) {
        self.statusDisabledLeg = FALSE;
        self.statusDisabledLegRating = 1;
        self.statusDisabledLegDuration = 0;
    } else if ([statusName isEqualToString:SR6_STATUS_FATIGUED]) {
        self.statusFatigued = FALSE;
        self.statusFatiguedRating = 1;
        self.statusFatiguedDuration = 0;
    } else if ([statusName isEqualToString:SR6_STATUS_FRIGHTENED]) {
        self.statusFrightened = FALSE;
        self.statusFrightenedDuration = 0;
    } else if ([statusName isEqualToString:SR6_STATUS_HAZED]) {
        self.statusHazed = FALSE;
        self.statusHazedDuration = 0;
    } else if ([statusName isEqualToString:SR6_STATUS_HOBBLED]) {
        self.statusHobbled = FALSE;
        self.statusHobbledDuration = 0;
    } else if ([statusName isEqualToString:SR6_STATUS_IMMOBILIZED]) {
        self.statusImmobilized = FALSE;
        self.statusImmobilizedDuration = 0;
    } else if ([statusName isEqualToString:SR6_STATUS_INVISIBLE]) {
        self.statusInvisible = FALSE;
        self.statusInvisibleRating = 1;
        self.statusInvisibleDuration = 0;
    } else if ([statusName isEqualToString:SR6_STATUS_INVISIBLE_IMP]) {
        self.statusInvisibleImproved = FALSE;
        self.statusInvisibleImprovedRating = 1;
        self.statusInvisibleImprovedDuration = 0;
    } else if ([statusName isEqualToString:SR6_STATUS_MUTED]) {
        self.statusMuted = FALSE;
        self.statusMutedDuration = 0;
    } else if ([statusName isEqualToString:SR6_STATUS_NAUSEATED]) {
        self.statusNauseated = FALSE;
        self.statusNauseatedDuration = 0;
    } else if ([statusName isEqualToString:SR6_STATUS_NOISE]) {
        self.statusNoise = FALSE;
        self.statusNoiseRating = 1;
        self.statusNoiseDuration = 0;
    } else if ([statusName isEqualToString:SR6_STATUS_OFF_BALANCE]) {
        self.statusOffBalance = FALSE;
        self.statusOffBalance = 0;
    } else if ([statusName isEqualToString:SR6_STATUS_PANICKED]) {
        self.statusPanicked = FALSE;
        self.statusPanickedDuration = 0;
    } else if ([statusName isEqualToString:SR6_STATUS_PETRIFIED]) {
        self.statusPetrified = FALSE;
        self.statusPetrifiedDuration = 0;
    } else if ([statusName isEqualToString:SR6_STATUS_POISONED]) {
        self.statusPoisoned = FALSE;
        self.statusPoisonedRating = 1;
        self.statusPoisonedDuration = 0;
    } else if ([statusName isEqualToString:SR6_STATUS_PRONE]) {
        self.statusProne = FALSE;
        self.statusProneDuration = 0;
    } else if ([statusName isEqualToString:SR6_STATUS_SILENT]) {
        self.statusSilent = FALSE;
        self.statusSilentRating = 1;
        self.statusSilentDuration = 0;
    } else if ([statusName isEqualToString:SR6_STATUS_SILENT_IMP]) {
        self.statusSilentImproved = FALSE;
        self.statusSilentImprovedRating = 1;
        self.statusSilentImprovedDuration = 0;
    } else if ([statusName isEqualToString:SR6_STATUS_STILLED]) {
        self.statusStilled = FALSE;
        self.statusStilledDuration = 0;
    } else if ([statusName isEqualToString:SR6_STATUS_WET]) {
        self.statusWet = FALSE;
        self.statusWetDuration = 0;
    } else if ([statusName isEqualToString:SR6_STATUS_ZAPPED]) {
        self.statusZapped = FALSE;
        self.statusZappedDuration = 0;
    } else {
        // We shouldn't ever get here...but if we do...
        self.notes = @"Uh-oh. Remove failed";
    }
    
    // Remove the object from the array, too. We don't bother rebuilding in this case - we can just remove one.
    [self removeFromArray:statusName];
    // Rebuild the status string too.
    [self buildStatusString];
}

#pragma mark Status Array Manipulation

-(NSArray *)buildStatusArrayEntry:(NSString *)statusName rating: (int16_t) rating duration:(int16_t) duration {
    NSArray *statusEntry;
    if (duration == -1) { // If the duration is -1, it's indefinite.
        statusEntry = [NSArray arrayWithObjects:statusName, [NSString stringWithFormat:@"%d",rating], @"Indef",nil];
    } else {
        statusEntry = [NSArray arrayWithObjects:statusName, [NSString stringWithFormat:@"%d",rating], [NSString stringWithFormat:@"%d", duration], nil];
    }
    return (statusEntry);
}

-(NSArray *)buildStatusArrayEntry:(NSString *)statusName duration:(int16_t) duration {
    NSArray *statusEntry;
    if (duration == -1) { // If the duration is -1, it's indefinite.
        statusEntry = [NSArray arrayWithObjects:statusName,@"",@"Indef",nil];
    } else {
        statusEntry = [NSArray arrayWithObjects:statusName,@"",[NSString stringWithFormat:@"%d", duration],nil];
    }
    return (statusEntry);
}

// Array manipulation
-(void)buildArray {
    // This takes the data from the current actor, and creates the content array.
    // The entries in the array are sorted like this:
    // Status Name
    // A summary string: R:## D:## (if there is an R, just D:## if there isn't), rating, duration
    // Duration of -1 means indefinite
    // Rating is ignored or set to 0 if the given status doesn't support a rating.
    
    if (_statusArray == nil) {
        _statusArray = [NSMutableArray arrayWithCapacity:5];
    } else {
        [self clearArray];
    }
    
    // For each status, build an array of the summarystring, the rating (if any) and the duration, and add it to the buildArray.
    if (self.statusBackground) {
        [_statusArray addObject:[self buildStatusArrayEntry:SR6_STATUS_BACKGROUND rating:self.statusBackgroundRating duration:self.statusBackgroundDuration]];
    }
    if (self.statusBlinded) {
        [_statusArray addObject:[self buildStatusArrayEntry:SR6_STATUS_BLINDED rating:self.statusBlindedRating duration:self.statusBlindedDuration]];
    }
    
    if (self.statusBurning) {
        [_statusArray addObject:[self buildStatusArrayEntry:SR6_STATUS_BURNING rating:self.statusBurningRating duration:self.statusBurningDuration]];
    }
    
    if (self.statusChilled) {
        [_statusArray addObject:[self buildStatusArrayEntry:SR6_STATUS_CHILLED duration:self.statusChilledDuration]];
    }
    
    if (self.statusConfused) {
        [_statusArray addObject:[self buildStatusArrayEntry:SR6_STATUS_CONFUSED rating:self.statusConfusedRating duration:self.statusConfusedDuration]];
    }
    
    if (self.statusCorrossive) {
        [_statusArray addObject:[self buildStatusArrayEntry:SR6_STATUS_CORROSSIVE rating:self.statusCorrossiveRating duration:self.statusCorrossiveDuration]];
    }
    
    if (self.statusCover) {
        [_statusArray addObject:[self buildStatusArrayEntry:SR6_STATUS_COVER rating:self.statusCoverRating duration:self.statusCoverDuration]];
    }
    
    if (self.statusDazed) {
        [_statusArray addObject:[self buildStatusArrayEntry:SR6_STATUS_DAZED duration:self.statusDazedDuration]];
    }
    
    if (self.statusDeafened) {
        [_statusArray addObject:[self buildStatusArrayEntry:SR6_STATUS_DEAFENED rating:self.statusDeafenedRating duration:self.statusDeafenedDuration]];
    }
    
    if (self.statusDisabledArm) {
       [_statusArray addObject:[self buildStatusArrayEntry:SR6_STATUS_DISABLED_ARM rating:self.statusDisabledArmRating duration:self.statusDisabledArmDuration]];
    }
    
    if (self.statusDisabledLeg) {
        [_statusArray addObject:[self buildStatusArrayEntry:SR6_STATUS_DISABLED_LEG rating:self.statusDisabledLegRating duration:self.statusDisabledLegDuration]];
    }
    
    if (self.statusFatigued) {
        [_statusArray addObject:[self buildStatusArrayEntry:SR6_STATUS_FATIGUED rating:self.statusFatiguedRating duration:self.statusFatiguedDuration]];
    }
    
    if (self.statusFrightened) {
        [_statusArray addObject:[self buildStatusArrayEntry:SR6_STATUS_FRIGHTENED duration:self.statusFrightenedDuration]];
    }
    
    if (self.statusHazed) {
        [_statusArray addObject:[self buildStatusArrayEntry:SR6_STATUS_HAZED duration:self.statusHazedDuration]];
    }
    
    
    if (self.statusHobbled) {
        [_statusArray addObject:[self buildStatusArrayEntry:SR6_STATUS_HOBBLED duration:self.statusHobbledDuration]];
    }
    
    if (self.statusImmobilized) {
        [_statusArray addObject:[self buildStatusArrayEntry:SR6_STATUS_IMMOBILIZED duration:self.statusImmobilizedDuration]];
    }
    
    if (self.statusInvisible) {
        [_statusArray addObject:[self buildStatusArrayEntry:SR6_STATUS_INVISIBLE rating:self.statusInvisibleRating duration:self.statusInvisibleDuration]];
    }
    
    if (self.statusInvisibleImproved) {
        [_statusArray addObject:[self buildStatusArrayEntry:SR6_STATUS_INVISIBLE_IMP rating:self.statusInvisibleImprovedRating duration:self.statusInvisibleImprovedDuration]];
    }
    
    if (self.statusMuted) {
        [_statusArray addObject:[self buildStatusArrayEntry:SR6_STATUS_MUTED duration:self.statusMutedDuration]];
    }
    
    if (self.statusNauseated) {
        [_statusArray addObject:[self buildStatusArrayEntry:SR6_STATUS_NAUSEATED duration:self.statusNauseatedDuration]];
    }
    
    if (self.statusNoise) {
        [_statusArray addObject:[self buildStatusArrayEntry:SR6_STATUS_NOISE rating:self.statusNoiseRating duration:self.statusNoiseDuration]];
    }
    
    if (self.statusOffBalance) {
        [_statusArray addObject:[self buildStatusArrayEntry:SR6_STATUS_OFF_BALANCE duration:self.statusOffBalanceDuration]];
    }
    
    if (self.statusPanicked) {
        [_statusArray addObject:[self buildStatusArrayEntry:SR6_STATUS_PANICKED duration:self.statusPanickedDuration]];
    }
    
    if (self.statusPetrified) {
        [_statusArray addObject:[self buildStatusArrayEntry:SR6_STATUS_PETRIFIED duration:self.statusPetrifiedDuration]];
    }
    
    if (self.statusPoisoned) {
        [_statusArray addObject:[self buildStatusArrayEntry:SR6_STATUS_POISONED rating:self.statusPoisonedRating duration:self.statusPoisonedDuration]];
    }
    
    if (self.statusProne) {
        [_statusArray addObject:[self buildStatusArrayEntry:SR6_STATUS_PRONE duration:self.statusProneDuration]];
    }
    
    if (self.statusSilent) {
        [_statusArray addObject:[self buildStatusArrayEntry:SR6_STATUS_SILENT rating:self.statusSilentRating duration:self.statusSilentDuration]];
    }
    
    if (self.statusSilentImproved) {
        [_statusArray addObject:[self buildStatusArrayEntry:SR6_STATUS_SILENT_IMP rating:self.statusSilentImprovedRating duration:self.statusSilentImprovedDuration]];
    }

    if (self.statusStilled) {
        [_statusArray addObject:[self buildStatusArrayEntry:SR6_STATUS_STILLED duration:self.statusStilledDuration]];
    }
    
    if (self.statusWet) {
        [_statusArray addObject:[self buildStatusArrayEntry:SR6_STATUS_WET duration:self.statusWetDuration]];
    }
    
    if (self.statusZapped) {
        [_statusArray addObject:[self buildStatusArrayEntry:SR6_STATUS_ZAPPED  duration:self.statusZappedDuration]];
    }
  
    [self buildStatusString];
}

-(void)buildStatusString {
    // Build a string that is the syumbosl for each status.
    // Basically, go through the build array, and grab the first character of each status name.
    // First, we need to check if there is an array, and build it if there isn't.
    if (_statusArray == nil) [self buildArray];
    
    if (_statusString == nil) {
        _statusString = [NSMutableString stringWithCapacity:[_statusArray count]];
    } else {
        [_statusString setString: @""];
    }
    
    if ([_statusArray count] > 0) {
        NSArray *tmpArray;
        
        for (int counter = 0; counter < [_statusArray count]; counter ++) {
            tmpArray = [_statusArray objectAtIndex:counter];
            [_statusString appendString: [(NSString *)[tmpArray objectAtIndex:0] substringToIndex:2]];
        }
    }
}

-(void)pasteStatuses: (SR6Actor *)source {
    // This method takes the data from the source SR6Actor and copies it over the existing status information.
    // Not a proper copy/paste, as the source object could have chagned after the copy event, and those changes will show up here
    // But it's good enough for what I need.
    
    self.statusBackground = source.statusBackground;
    self.statusBackgroundRating = source.statusBackgroundRating;
    self.statusBackgroundDuration = source.statusBackgroundDuration;
    
    self.statusBurning = source.statusBurning;
    self.statusBurningRating = source.statusBurningRating;
    self.statusBurningDuration = source.statusBurningDuration;
    
    self.statusChilled = source.statusChilled;
    self.statusChilledDuration = source.statusChilledDuration;
    
    self.statusConfused = source.statusConfused;
    self.statusConfusedRating = source.statusConfusedRating;
    self.statusConfusedDuration = source.statusConfusedDuration;
    
    self.statusCorrossive = source.statusCorrossive;
    self.statusCorrossiveRating = source.statusCorrossiveRating;
    self.statusCorrossiveDuration = source.statusCorrossiveDuration;
    
    self.statusCover = source.statusCover;
    self.statusCoverRating = source.statusCoverRating;
    self.statusCoverDuration = source.statusCoverDuration;
    
    self.statusDazed = source.statusDazed;
    self.statusDazedDuration = source.statusDazedDuration;
    
    self.statusDeafened = source.statusDeafened;
    self.statusDeafenedRating = source.statusDeafenedRating;
    self.statusDeafenedDuration = source.statusDeafenedDuration;
    
    self.statusDisabledArm = source.statusDisabledArm;
    self.statusDisabledArmRating = source.statusDisabledArmRating;
    self.statusDisabledArmDuration = source.statusDisabledArmDuration;
    
    self.statusDisabledLeg = source.statusDisabledLeg;
    self.statusDisabledLegRating = source.statusDisabledLegRating;
    self.statusDisabledLegDuration = source.statusDisabledLegDuration;
    
    self.statusFatigued = source.statusFatigued;
    self.statusFatiguedRating = source.statusFatiguedRating;
    self.statusFatiguedDuration = source.statusFatiguedDuration;
    
    self.statusFrightened = source.statusFrightened;
    self.statusFrightenedDuration = source.statusFrightenedDuration;
    
    self.statusHazed = source.statusHazed;
    self.statusHazedDuration = source.statusHazedDuration;
    
    self.statusHobbled = source.statusHobbled;
    self.statusHobbledDuration = source.statusHobbledDuration;
    
    self.statusImmobilized = source.statusImmobilized;
    self.statusImmobilizedDuration = source.statusImmobilizedDuration;
    
    self.statusInvisible = source.statusInvisible;
    self.statusInvisibleRating = source.statusInvisibleRating;
    self.statusInvisibleDuration = source.statusInvisibleDuration;
    
    self.statusInvisibleImproved = source.statusInvisibleImproved;
    self.statusInvisibleImprovedRating = source.statusInvisibleImprovedRating;
    self.statusInvisibleImprovedDuration = source.statusInvisibleImprovedDuration;
    
    self.statusMuted = source.statusMuted;
    self.statusMutedDuration = source.statusMutedDuration;
    
    self.statusNauseated = source.statusNauseated;
    self.statusNauseatedDuration = source.statusNauseatedDuration;
    
    self.statusNoise = source.statusNoise;
    self.statusNoiseRating = source.statusNoiseRating;
    self.statusNoiseDuration = source.statusNoiseDuration;
    
    self.statusOffBalance = source.statusOffBalance;
    self.statusOffBalanceDuration = source.statusOffBalanceDuration;
    
    self.statusPanicked = source.statusPanicked;
    self.statusPanickedDuration = source.statusPanickedDuration;
    
    self.statusPetrified = source.statusPetrified;
    self.statusPetrifiedDuration = source.statusPetrifiedDuration;
    
    self.statusPoisoned = source.statusPoisoned;
    self.statusPoisonedRating = source.statusPoisonedRating;
    self.statusPoisonedDuration = source.statusPoisonedDuration;
    
    self.statusProne = source.statusProne;
    self.statusProneDuration = source.statusProneDuration;
    
    self.statusSilent = source.statusSilent;
    self.statusSilentRating = source.statusSilentRating;
    self.statusSilentDuration = source.statusSilentDuration;
    
    self.statusSilentImproved = source.statusSilentImproved;
    self.statusSilentImprovedRating = source.statusSilentImprovedRating;
    self.statusSilentImprovedDuration = source.statusSilentImprovedDuration;
    
    self.statusStilled = source.statusStilled;
    self.statusStilledDuration = source.statusStilledDuration;
    
    self.statusWet = source.statusWet;
    self.statusWetDuration = source.statusWetDuration;
    
    self.statusZapped = source.statusZapped;
    self.statusZappedDuration = source.statusZappedDuration;
    
    // Now we need to build the status array, etc.
    [self buildArray];
}

#pragma mark Status Array Manipulation

-(void)removeFromArray:(NSString *) statusName {
    // Remove the status from the array, index by the statusName
    NSArray *status;
    
    status = [self statusEntry:statusName];
    if (status != nil) {
        [_statusArray removeObject:status];
    }
}

-(NSArray *)statusEntry:(NSString *)statusName {
    // Get the status entry from the managed array for the status named.
    int counter;
    NSArray *statuses;
    NSArray *status;
    
    statuses = (NSArray *)_statusArray;
    if (statuses.count != 0) {
        for (counter = 0; counter < statuses.count; counter ++) {
            status = (NSArray *)[statuses objectAtIndex:counter];
            if ([(NSString *)[status objectAtIndex:0] isEqualToString: statusName] ) {
                return (status);
            }
        }
        return (nil);
    } else {
        return (nil);
    }
}

-(void)clearArray{
    // Remove all the objects from the array.
    [_statusArray removeAllObjects];
}

#pragma mark NSPasteboardReader and Writer methods

// General object coder.
- (void) addActorObjectsAsDictionary:(NSMutableDictionary *)myDict {
    // This goes through the actor objects, and adds them as entries in the dictioanry.
    NSUInteger index = 0;
    if ([self.adeptPowers count] > 0) {
        for (index = 0; index < [self.adeptPowersArray count]; index++) {
            [[self.adeptPowersArray objectAtIndex:index] addObjectToDictionary:myDict index:index];
        }
    }
    if ([self.augs count] > 0) {
        for (index = 0; index < [self.augsArray count]; index++) {
            [[self.augsArray objectAtIndex:index] addObjectToDictionary:myDict index:index];
        }
    }
    if ([self.complexForms count] > 0) {
        for (index = 0; index < [self.complexFormsArray count]; index++) {
            [[self.complexFormsArray objectAtIndex:index] addObjectToDictionary:myDict index:index];
        }
    }
    if ([self.echoes count] > 0) {
        for (index = 0; index < [self.echoesArray count]; index++) {
            [[self.echoesArray objectAtIndex:index] addObjectToDictionary:myDict index:index];
        }
    }
    if ([self.metamagics count] > 0) {
        for (index = 0; index < [self.metamagicsArray count]; index++) {
            [[self.metamagicsArray objectAtIndex:index] addObjectToDictionary:myDict index:index];
        }
    }
    if ([self.powers count] > 0) {
        for (index = 0; index < [self.powersArray count]; index++) {
            [[self.powersArray objectAtIndex:index] addObjectToDictionary:myDict index:index];
        }
    }
    if ([self.programs count] > 0) {
        for (index = 0; index < [self.programsArray count]; index++) {
            [[self.programsArray objectAtIndex:index] addObjectToDictionary:myDict index:index];
        }
    }
    if ([self.qualities count] > 0) {
        for (index = 0; index < [self.qualitiesArray count]; index++) {
            [[self.qualitiesArray objectAtIndex:index] addObjectToDictionary:myDict index:index];
        }
    }
    if ([self.spells count] > 0) {
        for (index = 0; index < [self.spellsArray count]; index++) {
            [[self.spellsArray objectAtIndex:index] addObjectToDictionary:myDict index:index];
        }
    }
    if ([self.weapons count] > 0) {
       for (index = 0; index < [self.weaponsArray count]; index++) {
           [[self.weaponsArray objectAtIndex:index] addObjectToDictionary:myDict index:index];
       }
   }
}

// General object coder.
- (void) loadActorObjectFromDictionary:(NSDictionary *)myDict {
    // This goes through the actor objects, and adds them as entries in the dictionary.
    // We use an "index" value to make the tags unique for each object.
    // There is probably a one-line way to do this...
    NSUInteger index = 0;
    BOOL loadNext = TRUE;
    
    SR6ActorAdeptPower *newActorAdeptPower;
    while (loadNext) {
        newActorAdeptPower = [NSEntityDescription insertNewObjectForEntityForName:@"SR6ActorAdeptPower" inManagedObjectContext:self.managedObjectContext];
        loadNext = [newActorAdeptPower loadObjectFromDictionary:myDict index:index];
        
        if (loadNext) {
            // Add to the object.
            newActorAdeptPower.actor = self;
            [self addAdeptPowersObject:newActorAdeptPower];
            //myAAP.actor = self;
            //NSLog(@"Power: %@ Level: %d Option: %@",newActorAdeptPower.adeptPower.name, newActorAdeptPower.level, newActorAdeptPower.option);
        } else {
            // So, we have a an object, we haven't finisehd adding it in, so we need to delete it.
            [self.managedObjectContext deleteObject:newActorAdeptPower];
        }
        index++;
    }
    self.adeptPowersArray = nil;
    index = 0;
    loadNext = TRUE;
    
    SR6ActorAug *newActorAug;
    while (loadNext) {
        newActorAug = [NSEntityDescription insertNewObjectForEntityForName:@"SR6ActorAug" inManagedObjectContext:self.managedObjectContext];
        loadNext = [newActorAug loadObjectFromDictionary:myDict index:index];
        
        if (loadNext) {
            // Add to the object.
            newActorAug.actor = self;
            [self addAugsObject:newActorAug];
        } else {
            // So, we have a an object, we haven't finisehd adding it in, so we need to delete it.
            [self.managedObjectContext deleteObject:newActorAug];
        }
        index++;
    }
    self.augsArray = nil;
    index = 0;
    loadNext = TRUE;
    
    SR6ActorComplexForm *newActorComplexForm;
    while (loadNext) {
        newActorComplexForm = [NSEntityDescription insertNewObjectForEntityForName:@"SR6ActorComplexForm" inManagedObjectContext:self.managedObjectContext];
        loadNext = [newActorComplexForm loadObjectFromDictionary:myDict index:index];
        
        if (loadNext) {
            // Add to the object.
            newActorComplexForm.actor = self;
            [self addComplexFormsObject:newActorComplexForm];
        } else {
            // So, we have a an object, we haven't finisehd adding it in, so we need to delete it.
            [self.managedObjectContext deleteObject:newActorComplexForm];
        }
        index++;
    }
    self.complexFormsArray = nil;
    index = 0;
    loadNext = TRUE;
    
    SR6ActorEcho *newActorEcho;
    while (loadNext) {
        newActorEcho = [NSEntityDescription insertNewObjectForEntityForName:@"SR6ActorEcho" inManagedObjectContext:self.managedObjectContext];
        loadNext = [newActorEcho loadObjectFromDictionary:myDict index:index];
        
        if (loadNext) {
            // Add to the object.
            newActorEcho.actor = self;
            [self addEchoesObject:newActorEcho];
        } else {
            // So, we have a an object, we haven't finisehd adding it in, so we need to delete it.
            [self.managedObjectContext deleteObject:newActorEcho];
        }
        index++;
    }
    self.echoesArray = nil;
    index = 0;
    loadNext = TRUE;
    
    SR6ActorMetamagic *newActorMetamagic;
    while (loadNext) {
        newActorMetamagic = [NSEntityDescription insertNewObjectForEntityForName:@"SR6ActorMetamagic" inManagedObjectContext:self.managedObjectContext];
        loadNext = [newActorMetamagic loadObjectFromDictionary:myDict index:index];
        
        if (loadNext) {
            // Add to the object.
            newActorMetamagic.actor = self;
            [self addMetamagicsObject:newActorMetamagic];
        } else {
            // So, we have a an object, we haven't finisehd adding it in, so we need to delete it.
            [self.managedObjectContext deleteObject:newActorMetamagic];
        }
        index++;
    }
    self.metamagicsArray = nil;
    index = 0;
    loadNext = TRUE;
    
    SR6ActorPower *newActorPower;
    while (loadNext) {
        newActorPower = [NSEntityDescription insertNewObjectForEntityForName:@"SR6ActorPower" inManagedObjectContext:self.managedObjectContext];
        loadNext = [newActorPower loadObjectFromDictionary:myDict index:index];
        
        if (loadNext) {
            // Add to the object.
            newActorPower.actor = self;
            [self addPowersObject:newActorPower];
        } else {
            // So, we have a an object, we haven't finisehd adding it in, so we need to delete it.
            [self.managedObjectContext deleteObject:newActorPower];
        }
        index++;
    }
    self.powersArray = nil;
    index = 0;
    loadNext = TRUE;
    
    SR6ActorProgram *newActorProgram;
    while (loadNext) {
        newActorProgram = [NSEntityDescription insertNewObjectForEntityForName:@"SR6ActorProgram" inManagedObjectContext:self.managedObjectContext];
        loadNext = [newActorProgram loadObjectFromDictionary:myDict index:index];
        
        if (loadNext) {
            // Add to the object.
            newActorProgram.actor = self;
            [self addProgramsObject:newActorProgram];
        } else {
            // So, we have a an object, we haven't finisehd adding it in, so we need to delete it.
            [self.managedObjectContext deleteObject:newActorProgram];
        }
        index++;
    }
    self.programsArray = nil;
    index = 0;
    loadNext = TRUE;
    
    SR6ActorQuality *newActorQuality;
    while (loadNext) {
        newActorQuality = [NSEntityDescription insertNewObjectForEntityForName:@"SR6ActorQuality" inManagedObjectContext:self.managedObjectContext];
        loadNext = [newActorQuality loadObjectFromDictionary:myDict index:index];
        
        if (loadNext) {
            // Add to the object.
            newActorQuality.actor = self;
            [self addQualitiesObject:newActorQuality];
        } else {
            // So, we have a an object, we haven't finisehd adding it in, so we need to delete it.
            [self.managedObjectContext deleteObject:newActorQuality];
        }
        index++;
    }
    self.qualitiesArray = nil;
    index = 0;
    loadNext = TRUE;
    
    SR6ActorSpell *newActorSpell;
    while (loadNext) {
        newActorSpell = [NSEntityDescription insertNewObjectForEntityForName:@"SR6ActorSpell" inManagedObjectContext:self.managedObjectContext];
        loadNext = [newActorSpell loadObjectFromDictionary:myDict index:index];
        
        if (loadNext) {
            // Add to the object.
            newActorSpell.actor = self;
            [self addSpellsObject:newActorSpell];
        } else {
            // So, we have a an object, we haven't finisehd adding it in, so we need to delete it.
            [self.managedObjectContext deleteObject:newActorSpell];
        }
        index++;
    }
    self.spellsArray = nil;
    index = 0;
    loadNext = TRUE;
    
    SR6ActorWeapon *newActorWeapon;
    while (loadNext) {
        newActorWeapon = [NSEntityDescription insertNewObjectForEntityForName:@"SR6ActorWeapon" inManagedObjectContext:self.managedObjectContext];
        loadNext = [newActorWeapon loadObjectFromDictionary:myDict index:index];
        
        if (loadNext) {
            // Add to the object.
            newActorWeapon.actor = self;
            [self addWeaponsObject:newActorWeapon];
        } else {
            // So, we have a an object, we haven't finisehd adding it in, so we need to delete it.
            [self.managedObjectContext deleteObject:newActorWeapon];
        }
        index++;
    }
    self.weaponsArray = nil;
}

// Coding stuff
-(NSDictionary *)actorAsDictionary {
    // Zip everything into a dictionary.
    // As a cheap trick, to keep empty/nil strings from fragging things up, I put in a junk phrase ("arglebargle") in the place of
    // an empty string, and on the decode, if it's "arglebargle" I replace it with an empty string. Not the most elegant solution,
    // but - as I state many places here - it works, so I'm sticking with it.
    NSMutableDictionary *myDict = [NSMutableDictionary dictionaryWithCapacity:150];
    NSString *tmpStr;
    
    // It's a real problem if notes is empty. This is kludgy, but it works.
    tmpStr = self.notes;
    if (self.notes == nil) tmpStr = @"arglebargle";
    if ([self.notes isEqualToString:@""]) tmpStr = @"arglebargle";
    [myDict setObject:self.charName forKey:@"charName"];
    [myDict setObject:[NSNumber numberWithInt:self.actorCategory] forKey:@"actorCategory"];
    [myDict setObject:[NSNumber numberWithInt:self.actorType] forKey:@"actorType"];
    [myDict setObject:[NSNumber numberWithInt:self.astralDice] forKey:@"astralDice"];
    [myDict setObject:[NSNumber numberWithInt:self.astralInitiative] forKey:@"astralInitiative"];
    [myDict setObject:[NSNumber numberWithInt:self.astralMinor] forKey:@"astralMinor"];
    [myDict setObject:[NSNumber numberWithInt:self.astralMajor] forKey:@"astralMajor"];
    
    [myDict setObject:[NSNumber numberWithInt:self.attrAgility] forKey:@"attrAgility"];
    [myDict setObject:[NSNumber numberWithInt:self.attrBody] forKey:@"attrBody"];
    [myDict setObject:[NSNumber numberWithInt:self.attrCharisma] forKey:@"attrCharisma"];
    [myDict setObject:[NSNumber numberWithInt:self.attrDrain] forKey:@"attrDrain"];
    [myDict setObject:[NSNumber numberWithFloat:self.attrEdge] forKey:@"attrEdge"];
    [myDict setObject:[NSNumber numberWithFloat:self.attrEssence] forKey:@"attrEssence"];
    [myDict setObject:[NSNumber numberWithInt:self.attrIntuition] forKey:@"attrIntuition"];
    [myDict setObject:[NSNumber numberWithInt:self.attrLogic] forKey:@"attrLogic"];
    [myDict setObject:[NSNumber numberWithInt:self.attrMagic] forKey:@"attrMagic"];
    [myDict setObject:[NSNumber numberWithInt:self.attrReaction] forKey:@"attrReaction"];
    [myDict setObject:[NSNumber numberWithInt:self.attrStrength] forKey:@"attrStrength"];
    [myDict setObject:[NSNumber numberWithInt:self.attrWillpower] forKey:@"attrWillpower"];
    
    [myDict setObject:[NSNumber numberWithInt:self.boxesMatrix] forKey:@"boxesMatrix"];
    [myDict setObject:[NSNumber numberWithInt:self.boxesPhysical] forKey:@"boxesPhysical"];
    [myDict setObject:[NSNumber numberWithInt:self.boxesStun] forKey:@"boxesStun"];
     
    [myDict setObject:[NSNumber numberWithInt:self.currentDice] forKey:@"currentDice"];
    [myDict setObject:[NSNumber numberWithInt:self.currentEdge] forKey:@"currentEdge"];
    [myDict setObject:[NSNumber numberWithInt:self.currentInit] forKey:@"currentInit"];
    [myDict setObject:[NSNumber numberWithInt:self.currentMajor] forKey:@"currentMajor"];
    [myDict setObject:[NSNumber numberWithInt:self.currentMinor] forKey:@"currentMinor"];
    [myDict setObject:[NSNumber numberWithInt:self.currentMode] forKey:@"currentMode"];
    [myDict setObject:[NSNumber numberWithInt:self.currentSpeed] forKey:@"currentSpeed"];
    
    [myDict setObject:[NSNumber numberWithInt:self.defenseRating] forKey:@"defenseRating"];
    
    [myDict setObject:[NSNumber numberWithInt:self.hitsPerception ] forKey:@"hitsPerception"];
    [myDict setObject:[NSNumber numberWithInt:self.hitsStealth ] forKey:@"hitsStealth"];
    [myDict setObject:[NSNumber numberWithInt:self.hitsSurprise ] forKey:@"hitsSurprise"];
    
    [myDict setObject:[NSNumber numberWithInt:self.matrixAttack] forKey:@"matrixAttack"];
    [myDict setObject:[NSNumber numberWithInt:self.matrixCondition] forKey:@"matrixCondition"];
    [myDict setObject:[NSNumber numberWithInt:self.matrixDataProcessing] forKey:@"matrixDataProcessing"];
    [myDict setObject:[NSNumber numberWithInt:self.matrixDeviceRating] forKey:@"matrixDeviceRating"];
    [myDict setObject:[NSNumber numberWithInt:self.matrixDice] forKey:@"matrixDice"];
    [myDict setObject:[NSNumber numberWithInt:self.matrixFirewall] forKey:@"matrixFirewall"];
    [myDict setObject:[NSNumber numberWithInt:self.matrixInitiative] forKey:@"matrixInitiative"];
    [myDict setObject:[NSNumber numberWithInt:self.matrixMinor] forKey:@"matrixMinor"];
    [myDict setObject:[NSNumber numberWithInt:self.matrixMajor] forKey:@"matrixMajor"];
    [myDict setObject:[NSNumber numberWithInt:self.matrixSleaze] forKey:@"matrixSleaze"];
    
    tmpStr = self.move;
    if (self.move == nil) tmpStr = @"arglebargle";
    if ([self.move isEqualToString:@""]) tmpStr = @"arglebargle";
    [myDict setObject:tmpStr forKey:@"move"];
    
    tmpStr = self.notes;
    if (self.notes == nil) tmpStr = @"arglebargle";
    if ([self.notes isEqualToString:@""]) tmpStr = @"arglebargle";
    [myDict setObject:tmpStr forKey:@"notes"];
    
    [myDict setObject:[NSNumber numberWithInt:self.overflow] forKey:@"overflow"];
    [myDict setObject:[NSNumber numberWithInt:self.overwatchScore] forKey:@"overwatchScore"];
    
    [myDict setObject:[NSNumber numberWithInt:self.physicalCondition] forKey:@"physicalCondition"];
    [myDict setObject:[NSNumber numberWithInt:self.physicalDice] forKey:@"physicalDice"];
    [myDict setObject:[NSNumber numberWithInt:self.physicalInitiative] forKey:@"physicalInitiative"];
    [myDict setObject:[NSNumber numberWithInt:self.physicalMinor] forKey:@"physicalMinor"];
    [myDict setObject:[NSNumber numberWithInt:self.physicalMajor] forKey:@"physicalMajor"];
    
    if (self.picture != nil) [myDict setObject:self.picture forKey:@"picture"];
    
    [myDict setObject:[NSNumber numberWithInt:self.rating] forKey:@"rating"];
    
    [myDict setObject:[NSNumber numberWithInt:self.skillAstral ] forKey:@"skillAstral"];
    if (self.skillAstralSpec != nil) [myDict setObject:self.skillAstralSpec forKey:@"skillAstralSpec"];
    [myDict setObject:[NSNumber numberWithInt:self.skillAthletics ] forKey:@"skillAtletics"];
    if (self.skillAthleticsSpec != nil) [myDict setObject:self.skillAthleticsSpec forKey:@"skillAtleticsSpec"];
    [myDict setObject:[NSNumber numberWithInt:self.skillBiotech ] forKey:@"skillBiotech"];
    if (self.skillBiotechSpec != nil) [myDict setObject:self.skillBiotechSpec forKey:@"skillBiotechSpec"];
    [myDict setObject:[NSNumber numberWithInt:self.skillCloseCombat ] forKey:@"skillCloseCombat"];
    if (self.skillCloseCombatSpec != nil) [myDict setObject:self.skillCloseCombatSpec forKey:@"skillCloseCombatSpec"];
    [myDict setObject:[NSNumber numberWithInt:self.skillCon ] forKey:@"skillCon"];
    if (self.skillConSpec != nil) [myDict setObject:self.skillConSpec forKey:@"skillConSpec"];
    [myDict setObject:[NSNumber numberWithInt:self.skillConjuring ] forKey:@"skillConjuring"];
    if (self.skillConjuringSpec != nil) [myDict setObject:self.skillConjuringSpec forKey:@"skillConjuringSpec"];
    [myDict setObject:[NSNumber numberWithInt:self.skillCracking ] forKey:@"skillCracking"];
    if (self.skillCrackingSpec != nil) [myDict setObject:self.skillCrackingSpec forKey:@"skillCrackingSpec"];
    [myDict setObject:[NSNumber numberWithInt:self.skillElectronics ] forKey:@"skillElectronics"];
    if (self.skillElectronicsSpec != nil) [myDict setObject:self.skillElectronicsSpec forKey:@"skillElectronicsSpec"];
    [myDict setObject:[NSNumber numberWithInt:self.skillEnchanting ] forKey:@"skillEnchanting"];
    if (self.skillEnchantingSpec != nil) [myDict setObject:self.skillEnchantingSpec forKey:@"skillEnchantingSpec"];
    [myDict setObject:[NSNumber numberWithInt:self.skillEngineering ] forKey:@"skillEngineering"];
    if (self.skillEngineeringSpec != nil) [myDict setObject:self.skillEngineeringSpec forKey:@"skillEngineeringSpec"];
    [myDict setObject:[NSNumber numberWithInt:self.skillExoticWeapons ] forKey:@"skillExoticWeapons"];
    if (self.skillExoticWeaponsSpec != nil) [myDict setObject:self.skillExoticWeaponsSpec forKey:@"skillExoticWeaponsSpec"];
    [myDict setObject:[NSNumber numberWithInt:self.skillFirearms ] forKey:@"skillFirearms"];
    if (self.skillFirearmsSpec != nil) [myDict setObject:self.skillFirearmsSpec forKey:@"skillFirearmsSpec"];
    [myDict setObject:[NSNumber numberWithInt:self.skillInfluence ] forKey:@"skillInfluence"];
    if (self.skillInfluenceSpec != nil) [myDict setObject:self.skillInfluenceSpec forKey:@"skillInfluenceSpec"];
    [myDict setObject:[NSNumber numberWithInt:self.skillOutdoors ] forKey:@"skillOutdoors"];
    if (self.skillOutdoorsSpec != nil) [myDict setObject:self.skillOutdoorsSpec forKey:@"skillOutdoorsSpec"];
    [myDict setObject:[NSNumber numberWithInt:self.skillPerception ] forKey:@"skillPerception"];
    if (self.skillPerceptionSpec != nil) [myDict setObject:self.skillPerceptionSpec forKey:@"skillPerceptionSpec"];
    [myDict setObject:[NSNumber numberWithInt:self.skillPilot ] forKey:@"skillPilot"];
    if (self.skillPilotSpec != nil) [myDict setObject:self.skillPilotSpec forKey:@"skillPilotSpec"];
    [myDict setObject:[NSNumber numberWithInt:self.skillSorcery ] forKey:@"skillSorcery"];
    if (self.skillSorcerySpec != nil) [myDict setObject:self.skillSorcerySpec forKey:@"skillSorcerySpec"];
    [myDict setObject:[NSNumber numberWithInt:self.skillStealth ] forKey:@"skillStealth"];
    if (self.skillStealthSpec != nil) [myDict setObject:self.skillStealthSpec forKey:@"skillStealthSpec"];
    [myDict setObject:[NSNumber numberWithInt:self.skillTasking ] forKey:@"skillTasking"];
    if (self.skillTaskingSpec != nil) [myDict setObject:self.skillTaskingSpec forKey:@"skillTaskingSpec"];
    [myDict setObject:[NSNumber numberWithInt:self.skillOther ] forKey:@"skillOther"];
    if (self.skillOtherSpec != nil) [myDict setObject:self.skillOtherSpec forKey:@"skillOtherSpec"];
    
    [myDict setObject:[NSNumber numberWithBool: self.statusBackground] forKey:@"statusBackground"];
    [myDict setObject:[NSNumber numberWithInt:self.statusBackgroundRating] forKey:@"statusBackgroundRating"];
    [myDict setObject:[NSNumber numberWithInt:self.statusBackgroundDuration] forKey:@"statusBackgroundDuration"];
        
    [myDict setObject:[NSNumber numberWithBool: self.statusBlinded] forKey:@"statusBlinded"];
    [myDict setObject:[NSNumber numberWithInt:self.statusBlindedRating] forKey:@"statusBlindedRating"];
    [myDict setObject:[NSNumber numberWithInt:self.statusBlindedDuration] forKey:@"statusBlindedDuration"];
    
    [myDict setObject:[NSNumber numberWithBool:self.statusBurning] forKey:@"statusBurning"];
    [myDict setObject:[NSNumber numberWithInt:self.statusBurningRating] forKey:@"statusBurningRating"];
    [myDict setObject:[NSNumber numberWithInt:self.statusBurningDuration] forKey:@"statusBurningDuration"];
    [myDict setObject:[NSNumber numberWithBool:self.statusChilled] forKey:@"statusChilled"];
    [myDict setObject:[NSNumber numberWithInt:self.statusChilledDuration] forKey:@"statusChilledDuration"];
    [myDict setObject:[NSNumber numberWithBool:self.statusConfused] forKey:@"statusConfused"];
    [myDict setObject:[NSNumber numberWithInt:self.statusConfusedDuration] forKey:@"statusConfusedDuration"];
    [myDict setObject:[NSNumber numberWithInt:self.statusConfusedRating] forKey:@"statusConfusedRating"];
    [myDict setObject:[NSNumber numberWithBool:self.statusCorrossive] forKey:@"statusCorrossive"];
    [myDict setObject:[NSNumber numberWithInt:self.statusCorrossiveRating] forKey:@"statusCorrossiveRating"];
    [myDict setObject:[NSNumber numberWithInt:self.statusCorrossiveDuration] forKey:@"statusCorrossiveDuration"];
    [myDict setObject:[NSNumber numberWithBool:self.statusCover] forKey:@"statusCover"];
    [myDict setObject:[NSNumber numberWithInt:self.statusCoverRating] forKey:@"statusCoverRating"];
    [myDict setObject:[NSNumber numberWithInt:self.statusCoverDuration] forKey:@"statusCoverDuration"];
    [myDict setObject:[NSNumber numberWithBool:self.statusDazed] forKey:@"statusDazed"];
    [myDict setObject:[NSNumber numberWithInt:self.statusDazedDuration] forKey:@"statusDazedDuration"];
    [myDict setObject:[NSNumber numberWithBool:self.statusDeafened] forKey:@"statusDeafened"];
    [myDict setObject:[NSNumber numberWithInt:self.statusDeafenedRating] forKey:@"statusDeafenedRating"];
    [myDict setObject:[NSNumber numberWithInt:self.statusDeafenedDuration] forKey:@"statusDeafenedDuration"];
    [myDict setObject:[NSNumber numberWithBool:self.statusDisabledArm] forKey:@"statusDisabledArm"];
    [myDict setObject:[NSNumber numberWithInt:self.statusDisabledArmRating] forKey:@"statusDisabledArmRating"];
    [myDict setObject:[NSNumber numberWithInt:self.statusDisabledArmDuration] forKey:@"statusDisabledArmDuration"];
    [myDict setObject:[NSNumber numberWithBool:self.statusDisabledLeg] forKey:@"statusDisabledLeg"];
    [myDict setObject:[NSNumber numberWithInt:self.statusDisabledLegRating] forKey:@"statusDisabledLegRating"];
    [myDict setObject:[NSNumber numberWithInt:self.statusDisabledLegDuration] forKey:@"statusDisabledLegDuration"];
    
    [myDict setObject:[NSNumber numberWithBool:self.statusFatigued] forKey:@"statusFatigued"];
    [myDict setObject:[NSNumber numberWithInt:self.statusFatiguedRating] forKey:@"statusFatiguedRating"];
    [myDict setObject:[NSNumber numberWithInt:self.statusFatiguedDuration] forKey:@"statusFatiguedDuration"];
    [myDict setObject:[NSNumber numberWithBool:self.statusFrightened] forKey:@"statusFrightened"];
    [myDict setObject:[NSNumber numberWithInt:self.statusFrightenedDuration] forKey:@"statusFrightenedDuration"];
    [myDict setObject:[NSNumber numberWithBool:self.statusHazed] forKey:@"statusHazed"];
    [myDict setObject:[NSNumber numberWithInt:self.statusHazedDuration] forKey:@"statusHazedDuration"];
    [myDict setObject:[NSNumber numberWithBool:self.statusHobbled] forKey:@"statusHobbled"];
    [myDict setObject:[NSNumber numberWithInt:self.statusHobbledDuration] forKey:@"statusHobbledDuration"];
    [myDict setObject:[NSNumber numberWithBool:self.statusImmobilized] forKey:@"statusImmobilized"];
    [myDict setObject:[NSNumber numberWithInt:self.statusImmobilizedDuration] forKey:@"statusImmobilizedDuration"];
    [myDict setObject:[NSNumber numberWithBool:self.statusInvisible] forKey:@"statusInvisible"];
    [myDict setObject:[NSNumber numberWithInt:self.statusInvisibleRating] forKey:@"statusInvisibleRating"];
    [myDict setObject:[NSNumber numberWithInt:self.statusInvisibleDuration] forKey:@"statusInvisibleDuration"];
    [myDict setObject:[NSNumber numberWithBool:self.statusInvisibleImproved] forKey:@"statusInvisibleImproved"];
    [myDict setObject:[NSNumber numberWithInt:self.statusInvisibleImprovedRating] forKey:@"statusInvisibleImprovedRating"];
    [myDict setObject:[NSNumber numberWithInt:self.statusInvisibleImprovedDuration] forKey:@"statusInvisibleImprovedDuration"];
    [myDict setObject:[NSNumber numberWithBool:self.statusMuted] forKey:@"statusMuted"];
    [myDict setObject:[NSNumber numberWithInt:self.statusMutedDuration] forKey:@"statusMutedDuration"];
    [myDict setObject:[NSNumber numberWithBool:self.statusNauseated] forKey:@"statusNauseated"];
    [myDict setObject:[NSNumber numberWithInt:self.statusNauseatedDuration] forKey:@"statusNauseatedDuration"];
    [myDict setObject:[NSNumber numberWithBool:self.statusNoise] forKey:@"statusNoise"];
    [myDict setObject:[NSNumber numberWithInt:self.statusNoiseRating] forKey:@"statusNoiseRating"];
    [myDict setObject:[NSNumber numberWithInt:self.statusNoiseDuration] forKey:@"statusNoiseDuration"];
    [myDict setObject:[NSNumber numberWithBool:self.statusOffBalance] forKey:@"statusOffBalance"];
    [myDict setObject:[NSNumber numberWithInt:self.statusOffBalanceDuration] forKey:@"statusOffBalanceDuration"];
    [myDict setObject:[NSNumber numberWithBool:self.statusPanicked] forKey:@"statusPanicked"];
    [myDict setObject:[NSNumber numberWithInt:self.statusPanickedDuration] forKey:@"statusPanickedDuration"];
    [myDict setObject:[NSNumber numberWithBool:self.statusPetrified] forKey:@"statusPetrified"];
    [myDict setObject:[NSNumber numberWithInt:self.statusPetrifiedDuration] forKey:@"statusPetrifiedDuration"];
    [myDict setObject:[NSNumber numberWithBool:self.statusPoisoned] forKey:@"statusPoisoned"];
    [myDict setObject:[NSNumber numberWithInt:self.statusPoisonedRating] forKey:@"statusPoisonedRating"];
    [myDict setObject:[NSNumber numberWithInt:self.statusPoisonedDuration] forKey:@"statusPoisonedDuration"];
    [myDict setObject:[NSNumber numberWithBool:self.statusProne] forKey:@"statusProne"];
    [myDict setObject:[NSNumber numberWithInt:self.statusProneDuration] forKey:@"statusProneDuration"];
    [myDict setObject:[NSNumber numberWithBool:self.statusSilent] forKey:@"statusSilent"];
    [myDict setObject:[NSNumber numberWithInt:self.statusSilentRating] forKey:@"statusSilentRating"];
    [myDict setObject:[NSNumber numberWithInt:self.statusSilentDuration] forKey:@"statusSilentDuration"];
    [myDict setObject:[NSNumber numberWithBool:self.statusSilentImproved] forKey:@"statusSilentImproved"];
    [myDict setObject:[NSNumber numberWithInt:self.statusSilentImprovedRating] forKey:@"statusSilentImprovedRating"];
    [myDict setObject:[NSNumber numberWithInt:self.statusSilentImprovedDuration] forKey:@"statusSilentImprovedDuration"];
    [myDict setObject:[NSNumber numberWithBool:self.statusStilled] forKey:@"statusStilled"];
    [myDict setObject:[NSNumber numberWithInt:self.statusStilledDuration] forKey:@"statusStilledDuration"];
    [myDict setObject:[NSNumber numberWithBool:self.statusWet] forKey:@"statusWet"];
    [myDict setObject:[NSNumber numberWithInt:self.statusWetDuration] forKey:@"statusWetDuration"];
    [myDict setObject:[NSNumber numberWithBool:self.statusZapped] forKey:@"statusZapped"];
    [myDict setObject:[NSNumber numberWithInt:self.statusZappedDuration] forKey:@"statusZappedDuration"];
    
    [myDict setObject:[NSNumber numberWithInt:self.stunCondition] forKey:@"stunCondition"];
    tmpStr = self.vehHandling;
    if (self.vehHandling == nil) tmpStr = @"arglebargle";
    if ([self.vehHandling isEqualToString:@""]) tmpStr = @"arglebargle";
    [myDict setObject:tmpStr forKey:@"vehHandling"];
    
    [myDict setObject:[NSNumber numberWithInt:self.vehAccel ] forKey:@"vehAccel"];
    [myDict setObject:[NSNumber numberWithInt:self.vehSpeedInterval ] forKey:@"vehSpeedInterval"];
    [myDict setObject:[NSNumber numberWithInt:self.vehTopSpeed ] forKey:@"vehTopSpeed"];
    [myDict setObject:[NSNumber numberWithInt:self.vehBody ] forKey:@"vehBody"];
    [myDict setObject:[NSNumber numberWithInt:self.vehArmor ] forKey:@"vehArmor"];
    [myDict setObject:[NSNumber numberWithInt:self.vehPilot ] forKey:@"vehPilot"];
    [myDict setObject:[NSNumber numberWithInt:self.vehSensor ] forKey:@"vehSensor"];
    [myDict setObject:[NSNumber numberWithInt:self.vehSeat ] forKey:@"vehSeat"];
    
    
    [myDict setObject:[NSNumber numberWithInt:self.metatype ] forKey:@"metatype"];
    [myDict setObject:[NSNumber numberWithInt:self.initiateGrade ] forKey:@"initiateGrade"];
    [myDict setObject:[NSNumber numberWithInt:self.submersionGrade ] forKey:@"submersionGrade"];
    [myDict setObject:[NSNumber numberWithInt:self.professionalRating ] forKey:@"professionalRating"];
    [myDict setObject:[NSNumber numberWithInt:self.services ] forKey:@"services"];
    
    [myDict setObject:[NSNumber numberWithInt:self.commlink] forKey:@"commlink"];
    [myDict setObject:[NSNumber numberWithInt:self.cyberdeck] forKey:@"cyberdeck"];
    [myDict setObject:[NSNumber numberWithInt:self.cyberjack] forKey:@"cyberjack"];
    [myDict setObject:[NSNumber numberWithInt:self.rcc] forKey:@"rcc"];
    [myDict setObject:[NSNumber numberWithInt:self.matrixDefenseRating] forKey:@"matrixDefenseRating"];
    [myDict setObject:[NSNumber numberWithInt:self.matrixAttackRating] forKey:@"matrixAttackRating"];
    
    if (self.mentorUUID == nil) {
        tmpStr = @"arglebargle";
    } else {
        tmpStr = [self.mentorUUID UUIDString];
    }
    [myDict setObject:tmpStr forKey:@"mentorUUID"];
    
    tmpStr = self.mentorOption;
    if (self.mentorOption == nil) tmpStr = @"arglebargle";
    if ([self.mentorOption isEqualToString:@""]) tmpStr = @"arglebargle";
    [myDict setObject:tmpStr forKey:@"mentorOption"];
    
    [self addActorObjectsAsDictionary:myDict];
        
    return (NSDictionary *)myDict;
}

- (BOOL)loadFromDictionary:(NSDictionary *)myDict {
    // Unpacks a dictionary into the object.
    // As noted above, strings might be empty and have a placeholder string (arglebargle) so we check for that on the decode.
    self.charName = (NSString *)[myDict objectForKey:@"charName"];
    NSString *tmpStr;
    
    self.actorCategory = [[myDict objectForKey:@"actorCategory"] intValue];
    self.actorType = [[myDict objectForKey:@"actorType"] intValue];
    self.astralDice = [[myDict objectForKey:@"astralDice"] intValue];
    self.astralInitiative = [[myDict objectForKey:@"astralInitiative"] intValue];
    self.astralMinor = [[myDict objectForKey:@"astralMinor"] intValue];
    self.astralMajor = [[myDict objectForKey:@"astralMajor"] intValue];
    
    self.attrAgility = [[myDict objectForKey:@"attrAgility"] intValue];
    self.attrBody = [[myDict objectForKey:@"attrBody"] intValue];
    self.attrCharisma = [[myDict objectForKey:@"attrCharisma"] intValue];
    self.attrDrain = [[myDict objectForKey:@"attrDrain"] intValue];
    self.attrEdge = [[myDict objectForKey:@"attrEdge"] intValue];
    self.attrEssence = [[myDict objectForKey:@"attrEssence"] floatValue];
    self.attrIntuition = [[myDict objectForKey:@"attrIntuition"] intValue];
    self.attrLogic = [[myDict objectForKey:@"attrLogic"] intValue];
    self.attrMagic = [[myDict objectForKey:@"attrMagic"] intValue];
    self.attrReaction = [[myDict objectForKey:@"attrReaction"] intValue];
    self.attrStrength = [[myDict objectForKey:@"attrStrength"] intValue];
    self.attrWillpower = [[myDict objectForKey:@"attrWillpower"] intValue];
    
    self.boxesMatrix = [[myDict objectForKey:@"boxesMatrix"] intValue];
    self.boxesPhysical = [[myDict objectForKey:@"boxesPhysical"] intValue];
    self.boxesStun = [[myDict objectForKey:@"boxesStun"] intValue];
     
    self.currentDice = [[myDict objectForKey:@"currentDice"] intValue];
    self.currentEdge = [[myDict objectForKey:@"currentEdge"] intValue];
    self.currentInit = [[myDict objectForKey:@"currentInit"] intValue];
    self.currentMajor = [[myDict objectForKey:@"currentMajor"] intValue];
    self.currentMinor = [[myDict objectForKey:@"currentMinor"] intValue];
    self.currentMode = [[myDict objectForKey:@"currentMode"] intValue];
    self.currentSpeed = [[myDict objectForKey:@"currentSpeed"] intValue];
    
    self.defenseRating = [[myDict objectForKey:@"defenseRating"] intValue];
    
    self.hitsPerception  = [[myDict objectForKey:@"hitsPerception"] intValue];
    self.hitsStealth  = [[myDict objectForKey:@"hitsStealth"] intValue];
    self.hitsSurprise  = [[myDict objectForKey:@"hitsSurprise"] intValue];
    
    self.matrixAttack = [[myDict objectForKey:@"matrixAttack"] intValue];
    self.matrixCondition = [[myDict objectForKey:@"matrixCondition"] intValue];
    self.matrixDataProcessing = [[myDict objectForKey:@"matrixDataProcessing"] intValue];
    self.matrixDeviceRating = [[myDict objectForKey:@"matrixDeviceRating"] intValue];
    self.matrixDice = [[myDict objectForKey:@"matrixDice"] intValue];
    self.matrixFirewall = [[myDict objectForKey:@"matrixFirewall"] intValue];
    self.matrixInitiative = [[myDict objectForKey:@"matrixInitiative"] intValue];
    self.matrixMinor = [[myDict objectForKey:@"matrixMinor"] intValue];
    self.matrixMajor = [[myDict objectForKey:@"matrixMajor"] intValue];
    self.matrixSleaze = [[myDict objectForKey:@"matrixSleaze"] intValue];
    
    tmpStr = [myDict objectForKey:@"move"];
    if ([tmpStr isEqualToString:@"arglebargle"]) tmpStr = @"";
    self.move = tmpStr;
    
    tmpStr = [myDict objectForKey:@"notes"];
    if ([tmpStr isEqualToString:@"arglebargle"]) tmpStr = @"";
    self.notes = tmpStr;
    
    self.overflow = [[myDict objectForKey:@"overflow"] intValue];
    self.overwatchScore = [[myDict objectForKey:@"overwatchScore"] intValue];
    
    self.physicalCondition = [[myDict objectForKey:@"physicalCondition"] intValue];
    self.physicalDice = [[myDict objectForKey:@"physicalDice"] intValue];
    self.physicalInitiative = [[myDict objectForKey:@"physicalInitiative"] intValue];
    self.physicalMinor = [[myDict objectForKey:@"physicalMinor"] intValue];
    self.physicalMajor = [[myDict objectForKey:@"physicalMajor"] intValue];
    
    self.picture = [myDict objectForKey:@"picture"];
    
    self.rating = [[myDict objectForKey:@"rating"] intValue];
    
    self.skillAstral = [[myDict objectForKey:@"skillAstral"] intValue];
    self.skillAstralSpec = [myDict objectForKey:@"skillAstralSpec"];
    self.skillAthletics  = [[myDict objectForKey:@"skillAtletics"] intValue];
    self.skillAthleticsSpec = [myDict objectForKey:@"skillAtleticsSpec"];
    self.skillBiotech  = [[myDict objectForKey:@"skillBiotech"] intValue];
    self.skillBiotechSpec = [myDict objectForKey:@"skillBiotechSpec"];
    self.skillCloseCombat  = [[myDict objectForKey:@"skillCloseCombat"] intValue];
    self.skillCloseCombatSpec = [myDict objectForKey:@"skillCloseCombatSpec"];
    self.skillCon  = [[myDict objectForKey:@"skillCon"] intValue];
    self.skillConSpec = [myDict objectForKey:@"skillConSpec"];
    self.skillConjuring  = [[myDict objectForKey:@"skillConjuring"] intValue];
    self.skillConjuringSpec = [myDict objectForKey:@"skillConjuringSpec"];
    self.skillCracking  = [[myDict objectForKey:@"skillCracking"] intValue];
    self.skillCrackingSpec = [myDict objectForKey:@"skillCrackingSpec"];
    self.skillElectronics  = [[myDict objectForKey:@"skillElectronics"] intValue];
    self.skillElectronicsSpec = [myDict objectForKey:@"skillElectronicsSpec"];
    self.skillEnchanting  = [[myDict objectForKey:@"skillEnchanting"] intValue];
    self.skillEnchantingSpec = [myDict objectForKey:@"skillEnchantingSpec"];
    self.skillEngineering  = [[myDict objectForKey:@"skillEngineering"] intValue];
    self.skillEngineeringSpec = [myDict objectForKey:@"skillEngineeringSpec"];
    self.skillExoticWeapons  = [[myDict objectForKey:@"skillExoticWeapons"] intValue];
    self.skillExoticWeaponsSpec = [myDict objectForKey:@"skillExoticWeaponsSpec"];
    self.skillFirearms  = [[myDict objectForKey:@"skillFirearms"] intValue];
    self.skillFirearmsSpec = [myDict objectForKey:@"skillFirearmsSpec"];
    self.skillInfluence  = [[myDict objectForKey:@"skillInfluence"] intValue];
    self.skillInfluenceSpec = [myDict objectForKey:@"skillInfluenceSpec"];
    self.skillOutdoors  = [[myDict objectForKey:@"skillOutdoors"] intValue];
    self.skillOutdoorsSpec = [myDict objectForKey:@"skillOutdoorsSpec"];
    self.skillPerception  = [[myDict objectForKey:@"skillPerception"] intValue];
    self.skillPerceptionSpec = [myDict objectForKey:@"skillPerceptionSpec"];
    self.skillPilot  = [[myDict objectForKey:@"skillPilot"] intValue];
    self.skillPilotSpec = [myDict objectForKey:@"skillPilotSpec"];
    self.skillSorcery  = [[myDict objectForKey:@"skillSorcery"] intValue];
    self.skillSorcerySpec = [myDict objectForKey:@"skillSorcerySpec"];
    self.skillStealth  = [[myDict objectForKey:@"skillStealth"] intValue];
    self.skillStealthSpec = [myDict objectForKey:@"skillStealthSpec"];
    self.skillTasking  = [[myDict objectForKey:@"skillTasking"] intValue];
    self.skillTaskingSpec = [myDict objectForKey:@"skillTaskingSpec"];
    self.skillOther = [[myDict objectForKey:@"skillOther"] intValue];
    self.skillOtherSpec = [myDict objectForKey:@"skillOtherSpec"];
    
    self.statusBackground = [[myDict objectForKey:@"statusBackground"] boolValue];
    self.statusBackgroundRating = [[myDict objectForKey:@"statusBackgroundRating"] intValue];
    self.statusBackgroundDuration = [[myDict objectForKey:@"statusBackgroundDuration"] intValue];
    self.statusBlinded = [[myDict objectForKey:@"statusBlinded"] boolValue];
    self.statusBlindedRating = [[myDict objectForKey:@"statusBlindedRating"] intValue];
    self.statusBlindedDuration = [[myDict objectForKey:@"statusBlindedDuration"] intValue];
    self.statusBurning = [[myDict objectForKey:@"statusBurning"] boolValue];
    self.statusBurningRating = [[myDict objectForKey:@"statusBurningRating"] intValue];
    self.statusBurningDuration = [[myDict objectForKey:@"statusBurningDuration"] intValue];
    self.statusChilled = [[myDict objectForKey:@"statusChilled"] boolValue];
    self.statusChilledDuration = [[myDict objectForKey:@"statusChilledDuration"] intValue];
    self.statusConfused = [[myDict objectForKey:@"statusConfused"] boolValue];
    self.statusConfusedDuration = [[myDict objectForKey:@"statusConfusedDuration"] intValue];
    self.statusConfusedRating = [[myDict objectForKey:@"statusConfusedRating"] intValue];
    self.statusCorrossive = [[myDict objectForKey:@"statusCorrossive"] boolValue];
    self.statusCorrossiveRating = [[myDict objectForKey:@"statusCorrossiveRating"] intValue];
    self.statusCorrossiveDuration = [[myDict objectForKey:@"statusCorrossiveDuration"] intValue];
    self.statusCover = [[myDict objectForKey:@"statusCover"] boolValue];
    self.statusCoverRating = [[myDict objectForKey:@"statusCoverRating"] intValue];
    self.statusCoverDuration = [[myDict objectForKey:@"statusCoverDuration"] intValue];
    self.statusDazed = [[myDict objectForKey:@"statusDazed"] boolValue];
    self.statusDazedDuration = [[myDict objectForKey:@"statusDazedDuration"] intValue];
    self.statusDeafened = [[myDict objectForKey:@"statusDeafened"] boolValue];
    self.statusDeafenedRating = [[myDict objectForKey:@"statusDeafenedRating"] intValue];
    self.statusDeafenedDuration = [[myDict objectForKey:@"statusDeafenedDuration"] intValue];
    self.statusDisabledArm = [[myDict objectForKey:@"statusDisabledArm"] boolValue];
    self.statusDisabledArmRating = [[myDict objectForKey:@"statusDisabledArmRating"] intValue];
    self.statusDisabledArmDuration = [[myDict objectForKey:@"statusDisabledArmDuration"] intValue];
    self.statusDisabledLeg = [[myDict objectForKey:@"statusDisabledLeg"] boolValue];
    self.statusDisabledLegRating = [[myDict objectForKey:@"statusDisabledLegRating"] intValue];
    self.statusDisabledLegDuration = [[myDict objectForKey:@"statusDisabledLegDuration"] intValue];
    self.statusFatigued = [[myDict objectForKey:@"statusFatigued"] boolValue];
    self.statusFatiguedRating = [[myDict objectForKey:@"statusFatiguedRating"] intValue];
    self.statusFatiguedDuration = [[myDict objectForKey:@"statusFatiguedDuration"] intValue];
    self.statusFrightened = [[myDict objectForKey:@"statusFrightened"] boolValue];
    self.statusFrightenedDuration = [[myDict objectForKey:@"statusFrightenedDuration"] intValue];
    self.statusHazed = [[myDict objectForKey:@"statusHazed"] boolValue];
    self.statusHazedDuration = [[myDict objectForKey:@"statusHazedDuration"] intValue];
    self.statusHobbled = [[myDict objectForKey:@"statusHobbled"] boolValue];
    self.statusHobbledDuration = [[myDict objectForKey:@"statusHobbledDuration"] intValue];
    self.statusImmobilized = [[myDict objectForKey:@"statusImmobilized"] boolValue];
    self.statusImmobilizedDuration = [[myDict objectForKey:@"statusImmobilizedDuration"] intValue];
    self.statusInvisible = [[myDict objectForKey:@"statusInvisible"] boolValue];
    self.statusInvisibleRating = [[myDict objectForKey:@"statusInvisibleRating"] intValue];
    self.statusInvisibleDuration = [[myDict objectForKey:@"statusInvisibleDuration"] intValue];
    self.statusInvisibleImproved = [[myDict objectForKey:@"statusInvisibleImproved"] boolValue];
    self.statusInvisibleImprovedRating = [[myDict objectForKey:@"statusInvisibleImprovedRating"] intValue];
    self.statusInvisibleImprovedDuration = [[myDict objectForKey:@"statusInvisibleImprovedDuration"] intValue];
    self.statusMuted = [[myDict objectForKey:@"statusMuted"] boolValue];
    self.statusMutedDuration = [[myDict objectForKey:@"statusMutedDuration"] intValue];
    self.statusNauseated = [[myDict objectForKey:@"statusNauseated"] boolValue];
    self.statusNauseatedDuration = [[myDict objectForKey:@"statusNauseatedDuration"] intValue];
    self.statusNoise = [[myDict objectForKey:@"statusNoise"] boolValue];
    self.statusNoiseRating = [[myDict objectForKey:@"statusNoiseRating"] intValue];
    self.statusNoiseDuration = [[myDict objectForKey:@"statusNoiseDuration"] intValue];
    self.statusOffBalance = [[myDict objectForKey:@"statusOffBalance"] boolValue];
    self.statusOffBalanceDuration = [[myDict objectForKey:@"statusOffBalanceDuration"] intValue];
    self.statusPanicked = [[myDict objectForKey:@"statusPanicked"] boolValue];
    self.statusPanickedDuration = [[myDict objectForKey:@"statusPanickedDuration"] intValue];
    self.statusPetrified = [[myDict objectForKey:@"statusPetrified"] boolValue];
    self.statusPetrifiedDuration = [[myDict objectForKey:@"statusPetrifiedDuration"] intValue];
    self.statusPoisoned = [[myDict objectForKey:@"statusPoisoned"] boolValue];
    self.statusPoisonedRating = [[myDict objectForKey:@"statusPoisonedRating"] intValue];
    self.statusPoisonedDuration = [[myDict objectForKey:@"statusPoisonedDuration"] intValue];
    self.statusProne = [[myDict objectForKey:@"statusProne"] boolValue];
    self.statusProneDuration = [[myDict objectForKey:@"statusProneDuration"] intValue];
    self.statusSilent = [[myDict objectForKey:@"statusSilent"] boolValue];
    self.statusSilentRating = [[myDict objectForKey:@"statusSilentRating"] intValue];
    self.statusSilentDuration = [[myDict objectForKey:@"statusSilentDuration"] intValue];
    self.statusSilentImproved = [[myDict objectForKey:@"statusSilentImproved"] boolValue];
    self.statusSilentImprovedRating = [[myDict objectForKey:@"statusSilentImprovedRating"] intValue];
    self.statusSilentImprovedDuration = [[myDict objectForKey:@"statusSilentImprovedDuration"] intValue];
    self.statusStilled = [[myDict objectForKey:@"statusStilled"] boolValue];
    self.statusStilledDuration = [[myDict objectForKey:@"statusStilledDuration"] intValue];
    self.statusWet = [[myDict objectForKey:@"statusWet"] boolValue];
    self.statusWetDuration = [[myDict objectForKey:@"statusWetDuration"] intValue];
    self.statusZapped = [[myDict objectForKey:@"statusZapped"] boolValue];
    self.statusZappedDuration = [[myDict objectForKey:@"statusZappedDuration"] intValue];
    
    self.stunCondition = [[myDict objectForKey:@"stunCondition"] intValue];
    
    tmpStr = [myDict objectForKey:@"vehHandling"];
    if ([tmpStr isEqualToString:@"arglebargle"]) tmpStr = @"";
    self.vehHandling = tmpStr;
    
    self.vehAccel  = [[myDict objectForKey:@"vehAccel"] intValue];
    self.vehSpeedInterval  = [[myDict objectForKey:@"vehSpeedInterval"] intValue];
    self.vehTopSpeed  = [[myDict objectForKey:@"vehTopSpeed"] intValue];
    self.vehBody  = [[myDict objectForKey:@"vehBody"] intValue];
    self.vehArmor  = [[myDict objectForKey:@"vehArmor"] intValue];
    self.vehPilot  = [[myDict objectForKey:@"vehPilot"] intValue];
    self.vehSensor  = [[myDict objectForKey:@"vehSensor"] intValue];
    self.vehSeat  = [[myDict objectForKey:@"vehSeat"] intValue];
    
    self.metatype = [[myDict objectForKey:@"metatype"] intValue];
    self.initiateGrade = [[myDict objectForKey:@"initiateGrade"] intValue];
    self.submersionGrade = [[myDict objectForKey:@"submersionGrade"] intValue];
    self.professionalRating = [[myDict objectForKey:@"professionalRating"] intValue];
    self.services = [[myDict objectForKey:@"services"] intValue];
    
    self.commlink = [[myDict objectForKey:@"commlink"] intValue];
    self.cyberdeck = [[myDict objectForKey:@"cyberdeck"] intValue];
    self.cyberjack = [[myDict objectForKey:@"cyberjack"] intValue];
    self.rcc = [[myDict objectForKey:@"rcc"] intValue];
    self.matrixDefenseRating = [[myDict objectForKey:@"matrixDefenseRating"] intValue];
    self.matrixAttackRating = [[myDict objectForKey:@"matrixAttackRating"] intValue];

    
    tmpStr = [myDict objectForKey:@"mentorUUID"];
    if ([tmpStr isEqualToString:@"arglebargle"]) {
        self.mentorUUID = nil;
    } else {
        self.mentorUUID = [[NSUUID alloc] initWithUUIDString:tmpStr];
    }
    
    tmpStr = [myDict objectForKey:@"mentorOption"];
    if ([tmpStr isEqualToString:@"arglebargle"]) tmpStr = @"";
    self.mentorOption = tmpStr;

    // How to do the arrays of objects?
    [self loadActorObjectFromDictionary:myDict];
    
    return (TRUE);
}

#pragma mark Setting key paths so that bindings work correctly.

+ (NSSet *)keyPathsForValuesAffectingAttrResonance {
    return [NSSet setWithObjects:@"attrMagic",nil];
}


+ (NSSet *)keyPathsForValuesAffectingBonusRemaining {
    return [NSSet setWithObjects:@"actorType",@"attrResonance",@"attrCharisma",@"matrixAttack",@"attrCharisma",@"matrixAttack",@"attrIntuition",@"matrixSleaze", @"attrLogic",@"matrixDataProcessing",@"attrWillpower",@"matrixFirewall",nil];
}

+ (NSSet *)keyPathsForValuesAffectingBonusAttackGood {
    return [NSSet setWithObjects:@"actorType",@"attrCharisma",@"matrixAttack",nil];
}

+ (NSSet *)keyPathsForValuesAffectingBonusSleazeGood {
    return [NSSet setWithObjects:@"actorType",@"attrIntuition",@"matrixSleaze",nil];
}

+ (NSSet *)keyPathsForValuesAffectingBonusDataProcessingGood {
    return [NSSet setWithObjects:@"actorType",@"attrLogic",@"matrixDataProcessing",nil];
}

+ (NSSet *)keyPathsForValuesAffectingBonusFirewallGood {
    return [NSSet setWithObjects:@"actorType",@"attrWillpower",@"matrixFirewall",nil];
}

+ (NSSet *)keyPathsForValuesAffectingShowLevel {
    return [NSSet setWithObjects:@"actorType",nil];
}

+ (NSSet *)keyPathsForValuesAffectingShowProfessionalRating {
    return [NSSet setWithObjects:@"actorCategory",nil];
}

+ (NSSet *)keyPathsForValuesAffectingShowServices {
    return [NSSet setWithObjects:@"actorType",nil];
}

+ (NSSet *)keyPathsForValuesAffectingShowMetatype {
    return [NSSet setWithObjects:@"actorType",nil];
}

+ (NSSet *)keyPathsForValuesAffectingShowTechnomancer {
    return [NSSet setWithObjects:@"actorType",nil];
}

+ (NSSet *)keyPathsForValuesAffectingShowMagic {
    return [NSSet setWithObjects:@"actorType",nil];
}

+ (NSSet *)keyPathsForValuesAffectingShowQualities {
    return [NSSet setWithObjects:@"actorType",nil];
}

+ (NSSet *)keyPathsForValuesAffectingShowMatrix {
    return [NSSet setWithObjects:@"actorType",nil];
}

+ (NSSet *)keyPathsForValuesAffectingShowPowers {
    return [NSSet setWithObjects:@"actorType",nil];
}

+ (NSSet *)keyPathsForValuesAffectingShowAugs {
    return [NSSet setWithObjects:@"actorType",nil];
}

+ (NSSet *)keyPathsForValuesAffectingShowSprite {
    return [NSSet setWithObjects:@"actorType",nil];
}

+ (NSSet *)keyPathsForValuesAffectingShowMatrixConditionMonitor{
    return [NSSet setWithObjects:@"actorType",nil];
}

+ (NSSet *)keyPathsForValuesAffectingAdeptPowersArray {
    return [NSSet setWithObjects:@"adeptPowers",nil];
}

+ (NSSet *)keyPathsForValuesAffectingAugsArray {
    return [NSSet setWithObjects:@"augs",nil];
}

+ (NSSet *)keyPathsForValuesAffectingComplexFormsArray {
    return [NSSet setWithObjects:@"complexForms",nil];
}

+ (NSSet *)keyPathsForValuesAffectingEchoesArray {
    return [NSSet setWithObjects:@"echoes",nil];
}

+ (NSSet *)keyPathsForValuesAffectingMentor {
    return [NSSet setWithObjects:@"mentorUUID",nil];
}

+ (NSSet *)keyPathsForValuesAffectingMentorInfo {
    return [NSSet setWithObjects:@"mentorUUID",nil];
}

+ (NSSet *)keyPathsForValuesAffectingMetamagicsArray {
    return [NSSet setWithObjects:@"metamagics",nil];
}

+ (NSSet *)keyPathsForValuesAffectingPowersArray {
    return [NSSet setWithObjects:@"powers",nil];
}

+ (NSSet *)keyPathsForValuesAffectingProgramsArray {
    return [NSSet setWithObjects:@"programs",nil];
}

+ (NSSet *)keyPathsForValuesAffectingQualitiesArray {
    return [NSSet setWithObjects:@"qualities",nil];
}

+ (NSSet *)keyPathsForValuesAffectingSpellsArray {
    return [NSSet setWithObjects:@"spells",nil];
}

+ (NSSet *)keyPathsForValuesAffectingWeaponsArray {
    return [NSSet setWithObjects:@"weapons",nil];
}

+ (NSSet *)keyPathsForValuesAffectingDisplayedName {
    return [NSSet setWithObjects:@"actorCategory",@"isActiveActor",@"charName",@"actorType",@"rating",nil];
}

+ (NSSet *)keyPathsForValuesAffectingDamageModifier {
    return [NSSet setWithObjects:@"physicalCondition",@"stunCondition",@"matrixCondition",@"actorCategory",nil];
}

+ (NSSet *)keyPathsForValuesAffectingMatrixDamageModifier {
    return [NSSet setWithObjects:@"matrixCondition",@"actorCategory",@"statusNoise",@"statusNoiseRating",nil];
}

+ (NSSet *)keyPathsForValuesAffectingInitiatveScoreAdjusted {
    return [NSSet setWithObjects:@"currentInit",@"statusChilled",@"statusDazed",@"statusZapped",@"currentMode", nil];
}

+(NSSet *)keyPathsForValuesAffectingCurrentInit {
    return [NSSet setWithObjects:@"currentMode",@"matrixInitiative",@"astralInitiative",@"matrixInitiative",@"statusChilled",@"statusDazed",@"statusZapped",nil];
}

+(NSSet *)keyPathsForValuesAffectingCurrentDice {
    return [NSSet setWithObjects:@"currentMode",@"matrixDice",@"astralDice",@"matrixDice",nil];
}

+(NSSet *)keyPathsForValuesAffectingIsVehicle {
    return [NSSet setWithObjects:@"actorType",@"actorCategory",nil];
}

+(NSSet *)keyPathsForValuesAffectingIsAstral {
    return [NSSet setWithObjects:@"actorType",nil];
}

+(NSSet *)keyPathsForValuesAffectingIsLevel {
    return [NSSet setWithObjects:@"actorType",@"actorCategory",nil];
}

+(NSSet *)keyPathsForValuesAffectingIsGrunt {
    return [NSSet setWithObjects:@"actorCategory",nil];
}

+(NSSet *)keyPathsForValuesAffectingLevelLabel {
    return [NSSet setWithObjects:@"actorType",@"actorCategory",nil];
}

+(NSSet *)keyPathsForValuesAffectingMagicLabel {
    return [NSSet setWithObjects:@"actorType",nil];
}

+(NSSet *)keyPathsForValuesAffectingStunCMLabel {
    return [NSSet setWithObjects:@"actorCategory",@"actorType",nil];
}

+(NSSet *)keyPathsForValuesAffectingSpeedDetails {
    return [NSSet setWithObjects:@"currentSpeed",@"vehSpeedInterval",nil];
}

+(NSSet *)keyPathsForValuesAffectingStatusModifier {
    return [NSSet setWithObjects:@"statusDazed",@"statusChilled",@"statusConfused",@"statusConfusdRating",@"statusCover", @"statusCoverRating",@"statusDeafened",@"statusFatigued",@"statusFatiguedRating",@"statusFrightened",@"statusZapped",@"statusImmobilized",nil];
}

+(NSSet *)keyPathsForValuesAffectingShowMatrixCondition {
    return [NSSet setWithObjects:@"actorType",@"actorCategory",nil];
}

+(NSSet *)keyPathsForValuesAffectingUsesPhysicalAttributes {
    return [NSSet setWithObjects:@"actorType",nil];
}

+(NSSet *)keyPathsForValuesAffectingUsesMagicResonance {
    return [NSSet setWithObjects:@"actorType",nil];
}

+(NSSet *)keyPathsForValuesAffectingUsesStunCondition {
    return [NSSet setWithObjects:@"actorType",@"actorCategory",nil];
}

+(NSSet *)keyPathsForValuesAffectingUsesPhysicalCondition {
    return [NSSet setWithObjects:@"actorType",@"actorCategory",nil];
}

+(NSSet *)keyPathsForValuesAffectingIsMatrixModeOnly {
    return [NSSet setWithObjects:@"actorType",nil];
}

+(NSSet *)keyPathsForValuesAffectingUsesMovement {
    return [NSSet setWithObjects:@"actorType",nil];
}

@end
