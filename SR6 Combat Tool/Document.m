//
//  Document.m
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2019/8/30.
//  Copyright © 2020 Ed Pichon.
//
/* This file is part of the SRCombatTool, by Ed Pichon
 
 SRCombatTool is free software: you can redistribute it and/or modify
 it under the terms of the Creative Commons 4.0 license - BY-NC-SA.
 
 SRCombatTool is distributed in the hope that it will be useful,
 but without any warranty.
 
 */

#import "Document.h"
#import "SRDice.h"
#import "DMRnd.h"
#import "ActorArrayController.h"
#import "SR6Actor.h"
#import "StringToSkill.h"
#import "Image Panel/ImagePanelController.h"
#import <AppKit/AppKit.h>
#import "SR6ActorAdeptPower.h"
#import "SR6ActorAug.h"
#import "SR6ActorComplexForm.h"
#import "SR6ActorEcho.h"
#import "SR6ActorMetamagic.h"
#import "SR6ActorPower.h"
#import "SR6ActorProgram.h"
#import "SR6ActorQuality.h"
#import "SR6ActorSpell.h"
#import "SR6ActorWeapon.h"
#import "SR6AdeptPower.h"
#import "SR6Aug.h"
#import "SR6ComplexForm.h"
#import "SR6Echo.h"
#import "SR6Mentor.h"
#import "SR6Metamagic.h"
#import "SR6Power.h"
#import "SR6Program.h"
#import "SR6Quality.h"
#import "SR6Spell.h"
#import "SR6Weapon.h"

@interface Document ()
-(void)_syncRollResults;
-(void)_clearStatusUI;
-(void)_configureDuration:(int) duration;
-(void)_configureRating:(BOOL)enabled rating:(NSInteger)rating min:(NSInteger)min max:(NSInteger)max;
-(void)_syncStatusToDoc:(NSString *)newStatus;
-(void)_setNumberFormats;

-(void) appendToLog:(NSAttributedString *) newEntry;
-(void) scrollToBottom;
-(void) clearBackground;
-(void) clearBlackForeground;
-(void) clearSmallSizeText;
@end

@implementation Document

@synthesize modeValues;
@synthesize typeValues;
@synthesize drainAttrValues;
@synthesize categoryValues;
@synthesize metatypeValues;
@synthesize attributeValues;
@synthesize augGradeValues;
@synthesize commlinkValues;
@synthesize cyberdeckValues;
@synthesize cyberjackValues;
@synthesize ammoTypeValues;
@synthesize weaponFiringModeValues;
@synthesize rccValues;
@synthesize myTouchBar;
@synthesize dicePool;
@synthesize log;
@synthesize mentorSorters;

static void *SR6ActorTypeChangeContext = &SR6ActorTypeChangeContext;

#pragma mark Initializers and basics.


- (instancetype)init {
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        modeValues =[NSArray arrayWithObjects: SR6_MODE_PHYSICAL_LONG, SR6_MODE_MATRIX_COLD_LONG, SR6_MODE_MATRIX_HOT_LONG, SR6_MODE_ASTRAL_LONG, nil];
        typeValues =[NSArray arrayWithObjects:@"Normal",@"Awakened",@"Spirit",@"Critter",@"IC",@"Agent",@"Drone",@"Vehicle",@"Technomancer",@"Sprite",@"Technocritter",nil];
        drainAttrValues = [NSArray arrayWithObjects:@"Willpower",@"Logic",@"Intuition",@"Charisma",nil];

        categoryValues = [NSArray arrayWithObjects:@"Normal", @"PC", @"Grunt", @"Lt",nil];
        attributeValues = [NSArray arrayWithObjects:@"None",@"Body",@"Agility",@"Reaction",@"Strength",@"Willpower",@"Logic",@"Intuition",@"Charisma",@"Edge",
                           @"Magic",@"Resonance",@"Force/Level",@"Device Rating",@"Attack",@"Sleaze",@"Data Processing",@"Firewall",@"Sensor",nil];
        augGradeValues = [NSArray arrayWithObjects: SR6_AUG_GRADE_NORMAL_LONG, SR6_AUG_GRADE_USED_LONG, SR6_AUG_GRADE_ALPHA_LONG, SR6_AUG_GRADE_BETA_LONG, SR6_AUG_GRADE_DELTA_LONG, SR6_AUG_GRADE_GAMMA_LONG, SR6_AUG_GRADE_OTHER_LONG, nil];
        metatypeValues = [NSArray arrayWithObjects:SR6_METATYPE_HUMAN, SR6_METATYPE_DWARF, SR6_METATYPE_ELF, SR6_METATYPE_ORK, SR6_METATYPE_TROLL, SR6_METATYPE_OTHER, nil];
        
        commlinkValues = [NSArray arrayWithObjects:@"None",@"Meta Link (1)",@"Sony Emperor (2)",@"Renraku Sensei (3)",@"Erika Elite (4)",@"Hermes Ikon (5)",@"Transys Avalon (6)",nil];
        cyberdeckValues = [NSArray arrayWithObjects:@"None",@"Erika MCD-6 (1)",@"Spinrad Falcon (2)",@"MCT 360 (3)",@"Renraku Kitsune (4)",@"Shiawase Cyber-6 (5)",@"Fairlight Excalibur (6)", nil];
        cyberjackValues = [NSArray arrayWithObjects:@"None",@"Rating 1",@"Rating 2",@"Rating 3",@"Rating 4",@"Rating 5",@"Rating 6",nil];
        rccValues = [NSArray arrayWithObjects:@"None",@"Scratch Built Junk",@"Allegiance Control Center",@"Essy Motors DroneMaster", @"Horizon Overseer",@"Maersk Spider",@"Vulcan Liegelord",@"Proteus Poseidon",@"Transys Eidolon",@"Ares Red Dog Series", @"Aztechnology Tlaloc",nil];
        ammoTypeValues = [NSArray arrayWithObjects:SR6_WEAPON_AMMO_NONE_LONG, SR6_WEAPON_AMMO_REGULAR_LONG, SR6_WEAPON_AMMO_APDS_LONG, SR6_WEAPON_AMMO_EXPLOSIVE_LONG, SR6_WEAPON_AMMO_FLECHETTE_LONG, SR6_WEAPON_AMMO_GEL_LONG, SR6_WEAPON_AMMO_STICK_N_SHOCK_LONG, SR6_WEAPON_AMMO_SPECIAL_LONG, SR6_WEAPON_AMMO_HAND_LOADED_LONG, SR6_WEAPON_AMMO_MATCH_GRADE_LONG, nil];
        weaponFiringModeValues = [NSArray arrayWithObjects:SR6_FIRING_MODE_SS_LONG, SR6_FIRING_MODE_SA_LONG, SR6_FIRING_MODE_BN_LONG, SR6_FIRING_MODE_BW_LONG, SR6_FIRING_MODE_FA_LONG, SR6_FIRING_MODE_OTHER_LONG, nil];
        
        // Initiatialize the dieRoller;
        dicePool = [NSNumber numberWithInteger:10];
        dieRoller = [[SRDice alloc] initWithRandomizer: [[DMRnd alloc] init:(unsigned long) [NSDate timeIntervalSinceReferenceDate]]];
        
        mentorSorters = [NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES], nil];
        
        // Check if we have the core DB loaded yet.
        NSPersistentStoreCoordinator *psc = self.managedObjectContext.persistentStoreCoordinator;
        NSArray *psArray = psc.persistentStores;
        NSPersistentStore *ps;
        NSURL *dburl = [[NSBundle mainBundle] URLForResource:@"Core" withExtension:@"sr6ctdb"];
        
        NSUInteger index;
        BOOL found = FALSE;
        for (index = 0; index < psArray.count; index++) {
            ps = [psArray objectAtIndex:index];
            if ([ps.URL isEqualTo:dburl]) found = TRUE;
            //NSLog(@"PS - %@",ps.URL);
        }
                
        if (found== false) {
            NSLog (@"Adding Core DB to persistent store from Init.");
            NSMutableDictionary *newStoreOptions;
            newStoreOptions = [NSMutableDictionary dictionary];
            [newStoreOptions setObject:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
            [newStoreOptions setObject:[NSNumber numberWithBool:YES] forKey:NSInferMappingModelAutomaticallyOption];
            [newStoreOptions setObject:[NSNumber numberWithBool:YES] forKey:NSReadOnlyPersistentStoreOption];

            // We also setup the additional persistent store for the backend database, if we need to
            
            NSURL *dburl = [[NSBundle mainBundle] URLForResource:@"Core" withExtension:@"sr6ctdb"];
            NSError *error;
            [psc addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:dburl options:newStoreOptions error:&error];
            
            NSLog (@"Added Core db from Init.");
        } else {
            NSLog (@"Core DB found during Init.");
        }
    }
    return self;
}

- (BOOL)configurePersistentStoreCoordinatorForURL:(NSURL *)url ofType:(NSString *)fileType modelConfiguration:(NSString *)configuration storeOptions:(NSDictionary *)storeOptions error:(NSError **)error
// This is to enable migration in the data model if you add new fields.
// Taken from stack overflow by someone trying to do the same thing. Hopefully this works. Apple's documentation for this is more-or-less useless.
// Problem is that on first boot, this doesn't get created.
// https://stackoverflow.com/questions/10001026/lightweight-migration-of-a-nspersistentdocument
{
    NSLog(@"Opening persistent store.");
    NSMutableDictionary *newStoreOptions;
    if (storeOptions == nil) {
        newStoreOptions = [NSMutableDictionary dictionary];
    }
    else {
        newStoreOptions = [storeOptions mutableCopy];
    }
    [newStoreOptions setObject:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
    [newStoreOptions setObject:[NSNumber numberWithBool:YES] forKey:NSInferMappingModelAutomaticallyOption];

    BOOL result = [super configurePersistentStoreCoordinatorForURL:url ofType:fileType modelConfiguration:configuration storeOptions:newStoreOptions error:error];
   
    if (result) {
        // Check if we have the core DB loaded yet.
        NSPersistentStoreCoordinator *psc = self.managedObjectContext.persistentStoreCoordinator;
        NSArray *psArray = psc.persistentStores;
        NSPersistentStore *ps;
        NSURL *dburl = [[NSBundle mainBundle] URLForResource:@"Core" withExtension:@"sr6ctdb"];
        
        NSUInteger index;
        BOOL found = FALSE;
        for (index = 0; index < psArray.count; index++) {
            ps = [psArray objectAtIndex:index];
            if ([ps.URL isEqualTo:dburl]) found = TRUE;
            //NSLog(@"PS - %@",ps.URL);
        }
                
        if (found== false) {
            NSLog (@"Preparimg Core DB");
            NSMutableDictionary *newStoreOptions;
            newStoreOptions = [NSMutableDictionary dictionary];
            [newStoreOptions setObject:[NSNumber numberWithBool:YES] forKey:NSMigratePersistentStoresAutomaticallyOption];
            [newStoreOptions setObject:[NSNumber numberWithBool:YES] forKey:NSInferMappingModelAutomaticallyOption];
            [newStoreOptions setObject:[NSNumber numberWithBool:YES] forKey:NSReadOnlyPersistentStoreOption];

            // We also setup the additional persistent store for the backend database, if we need to
            
            NSURL *dburl = [[NSBundle mainBundle] URLForResource:@"Core" withExtension:@"sr6ctdb"];
            NSError *error;
            [psc addPersistentStoreWithType:NSXMLStoreType configuration:nil URL:dburl options:newStoreOptions error:&error];
            
            NSLog (@"Added Core db.");
        } else {
            NSLog (@"Core DB found.");
        }
    }
    
    return result;
}


+ (BOOL)autosavesInPlace {
    return YES;
}

- (NSString *)windowNibName {
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Document";
}

-(void) windowControllerDidLoadNib:(NSWindowController *)windowController {
    // We want to hide the vehicle attributes box when we boot up, so things don't look messy.
    // Have to do it this way, because interface builder gets dog slow if you set it hidden there.
    // A workaround for a bug in IB.
    boxVehicleAttributes.hidden = TRUE;
    [tabView selectFirstTabViewItem:nil];

}

#pragma mark Die Roller code.

- (IBAction) rollDice: (id) sender {
    [self rollDice:sender rollDesc:nil];
}

- (IBAction) rollSum: (id) sender {
    [dieRoller rollSum:[dicePool intValue]];
    
    [self _syncRollResults];
}

- (void) rollDice: (id) sender rollDesc:(NSString *) rollDesc {
    
    [dieRoller rollDice:[dicePool intValue]
                wildDie:([buttonWildDie state] == NSControlStateValueOn)
                explode:([buttonExplodeSixes state] == NSControlStateValueOn)
             twosGlitch:([buttonTwosGlitch state] == NSControlStateValueOn)];
    
    // Sync roll results
    [self _syncRollResults:rollDesc];
}

-(IBAction) reRollOneHit:(id)sender {
    // Don't need to initialize...if we've gotten to here.
    
    [dieRoller reRollHit];
    [self _syncRollResults];
}

-(IBAction) reRollOneMiss:(id)sender {
    // Don't need to initialize...if we've gotten to here.
    
    [dieRoller reRollMiss];
    [self _syncRollResults];
}

- (IBAction) reRollFailures: (id) sender {
    [dieRoller reRollFailures];
    [self _syncRollResults];
}

-(IBAction) reRollOneGlitch:(id)sender {
    // Don't need to initialize...if we've gotten to here.
    
    [dieRoller reRollGlitch];
    [self _syncRollResults];
}

-(IBAction) addOnetoMiss:(id)sender {
    // Don't need to initialize...if we've gotten to here.
    
    [dieRoller addOneToMiss];
    [self _syncRollResults];
}

-(IBAction) addOnetoGlitch:(id)sender {
    // Don't need to initialize...if we've gotten to here.
    
    [dieRoller addOneToGlitch];
    [self _syncRollResults];
}

-(void) _syncRollResults {
    [self _syncRollResults:nil];
}

-(void) _syncRollResults:(NSString *)rollDesc {
    NSMutableAttributedString *aString;
    NSAttributedString *spacer;
    // Set the summary
    if (rollDesc == nil) {
        [rollResult setAttributedStringValue:[dieRoller attributedSummary]];
    } else {
        aString = [[NSMutableAttributedString alloc] initWithString:rollDesc];
        [aString addAttribute:NSFontAttributeName value:[NSFont userFontOfSize:11.0] range:NSMakeRange(0,[aString length])];
        spacer = [[NSAttributedString alloc] initWithString:@": "];
        
        [aString appendAttributedString:spacer];
        [aString appendAttributedString:[dieRoller attributedSummary]];
        [rollResult setAttributedStringValue:aString];
    }
    
    // Set the tooltip to the details
    [rollResult setToolTip:[dieRoller details]];
    
    // Clear the toggles.
    buttonTwosGlitch.state = NSControlStateValueOff;
    buttonExplodeSixes.state = NSControlStateValueOff;
    buttonWildDie.state = NSControlStateValueOff;
    
    // Set the state if the reroll buttons.
    buttonRerollOneHit.enabled = [dieRoller canReRollHit];
    buttonRerollOneMiss.enabled = [dieRoller canReRollMiss];
    buttonRerollOneGlitch.enabled = [dieRoller canReRollGlitch];
    buttonRerollFailures.enabled = [dieRoller canReRollFailures];
    buttonAddOnetoMiss.enabled = [dieRoller canAddOneToMiss];
    buttonAddOnetoGlitch.enabled = [dieRoller canAddOneToGlitch];
    buttonRerollFailures.enabled = [dieRoller canReRollFailures];
    
    // Update the hit counter.
    txtNumHits.intValue = [dieRoller numHits];
    
    if (dieRoller.isGlitch || dieRoller.isCritGlitch) {
        txtNumHits.textColor = [NSColor controlAccentColor];
    } else {
        txtNumHits.textColor = [NSColor textColor];
    }
    
    // Now add the log.
    if (rollDesc == nil) {
        aString = [[NSMutableAttributedString alloc] initWithAttributedString: dieRoller.attributedSummary];
    } else {
        aString = [[NSMutableAttributedString alloc] initWithString:rollDesc];
        [aString addAttribute:NSFontAttributeName value:[NSFont userFontOfSize:11.0] range:NSMakeRange(0,[aString length])];
        spacer = [[NSAttributedString alloc] initWithString:@": "];
        
        [aString appendAttributedString:spacer];
        [aString appendAttributedString:dieRoller.attributedSummary];
    }
    
    [aString appendAttributedString:[[NSAttributedString alloc] initWithString:@" ("]];
    [aString appendAttributedString:dieRoller.attributedDetails];
    [aString appendAttributedString:[[NSAttributedString alloc] initWithString:@")"]];
    [aString addAttribute:NSForegroundColorAttributeName value:[NSColor labelColor] range:NSMakeRange(0,[aString length])];
    [self appendToLog:aString];
    
    
}


-(void) appendToLog:(NSAttributedString *) newEntry {
    if (self.log == nil) {
        self.log = [[NSMutableAttributedString alloc] init];
    }
    
    // Add the string to the end.
    [self.log appendAttributedString:newEntry];
    [self.log appendAttributedString:[[NSAttributedString alloc] initWithString: @"\n"]];
    
    // If the log is getting out of hand, it can take a while to update things, which slows things down quite a bit on scrolling.
    // Therefore, we'll hack it back to half length every now and then.
    if ([self.log length] > 5000) {
        NSMutableAttributedString * tmp = (NSMutableAttributedString *)[self.log attributedSubstringFromRange: NSMakeRange([self.log length] - 2000, 2000)];
        //self.log = [NSMutableAttributedString stringWithCapacity:5100];
        self.log = tmp;
    }
    
    [[textViewLog textStorage] setAttributedString: self.log];
    
    // Scroll the log down.
    [self scrollToBottom];
    
    // When the string gets long, it takes a moment to re-render the log, we'll issue another scroll command after a bit.
    [self performSelector:@selector(scrollToBottom) withObject:self afterDelay:0.2];
   //[self scrollToBottom:self.buttonRoll];
}

- (void)scrollToBottom {
    // From apples scroll view programming guide
    NSPoint newScrollOrigin;
    
    if ([[scrollViewLog documentView] isFlipped]) {
        newScrollOrigin=NSMakePoint(0.0,NSMaxY([[scrollViewLog documentView] frame])
                                    -NSHeight([[scrollViewLog contentView] bounds]));
    } else {
        newScrollOrigin=NSMakePoint(0.0,0.0);
    }
    
    [[scrollViewLog documentView] scrollPoint:newScrollOrigin];
}


#pragma mark Common Roll Code

// This the code for the various "roll X" buttons. Mostly pass through to the rollAttrTest method, which handles the details.
// Note: The skill roll code is in the Popover control code, as the action response there is tied to the segmented control.

-(void)rollSkillTest:(NSInteger)skill secondAttr:(NSInteger) attribute withDmgMods:(BOOL)dmgMods withMatrixMods:(BOOL)matrixMods withStatusMods:(BOOL)statusMods withName:(nullable NSString *)rollName {
    NSInteger pool;
    NSString *desc;

    SR6Actor *currentActor = (SR6Actor *)[[myActorArray arrangedObjects] objectAtIndex:[myActorArray selectionIndex]];
    
    // Get the pool from the
    pool = [currentActor getSkillTestPool:skill attribute:attribute specialization:kSpecializationNone
                       withDamageModifiers:(cbDmgMods.state == NSControlStateValueOn)  withMatrixDamageModifiers:(cbMatrixMods.state == NSControlStateValueOn)
                       withStatusModifiers:(cbStatusMods.state == NSControlStateValueOn)];
    desc = [currentActor getSkillTestDescription:skill attribute:attribute specialization:kSpecializationNone
                            withDamageModifiers:(cbDmgMods.state == NSControlStateValueOn) withMatrixDamageModifiers:(cbMatrixMods.state == NSControlStateValueOn)
                            withStatusModifiers:(cbStatusMods.state == NSControlStateValueOn) rollName: nil];
    
    self.dicePool = [NSNumber numberWithInteger: pool];
    [self rollDice:nil rollDesc:desc];
}


-(void)rollAttrTest:(NSInteger)firstAttr secondAttr:(NSInteger) secondAttr withDmgMods:(BOOL)dmgMods withMatrixMods:(BOOL)matrixMods withStatusMods:(BOOL)statusMods withName:(nullable NSString *)rollName {
    NSInteger pool;
    NSString *desc;

    SR6Actor *currentActor = (SR6Actor *)[[myActorArray arrangedObjects] objectAtIndex:[myActorArray selectionIndex]];
    
    pool = [currentActor getAttributeTestPool:firstAttr secondAttribute:secondAttr withDamageModifiers:dmgMods withMatrixDamageModifiers:matrixMods withStatusModifiers:statusMods];
    desc = [currentActor getAttributeTestDescription:firstAttr secondAttribute:secondAttr withDamageModifiers:dmgMods withMatrixDamageModifiers:matrixMods withStatusModifiers:statusMods rollName:rollName];
    
    self.dicePool = [NSNumber numberWithInteger: pool];
    [self rollDice:nil rollDesc:desc];
}

- (IBAction)rollBodDmgResist:(id)sender {
    [self rollAttrTest:SR6_ATTR_BODY secondAttr:SR6_ATTR_NULL withDmgMods:NO withMatrixMods:NO withStatusMods:NO withName:@"Bod DR"];
}

- (IBAction)rollFWDmgResist:(id)sender {
    [self rollAttrTest:SR6_ATTR_FIREWALL secondAttr:SR6_ATTR_NULL withDmgMods:NO withMatrixMods:NO withStatusMods:NO withName:@"FW DR"];
}

- (IBAction)rollDrainDmgResist:(id)sender {
    NSInteger pool;
    NSString *desc;

    SR6Actor *currentActor = (SR6Actor *)[[myActorArray arrangedObjects] objectAtIndex:[myActorArray selectionIndex]];
    
    pool = [currentActor getPoolDrain];
    desc = [currentActor getPoolDrainDescription];
    
    self.dicePool = [NSNumber numberWithInteger: pool];
    [self rollDice:nil rollDesc:desc];
}

- (IBAction)rollMemory:(id)sender {
    [self rollAttrTest:SR6_ATTR_LOGIC secondAttr:SR6_ATTR_INTUITION withDmgMods:YES withMatrixMods:NO withStatusMods:YES withName: @"Memory"];
}

- (IBAction)rollComposure:(id)sender{
    [self rollAttrTest:SR6_ATTR_WILLPOWER secondAttr:SR6_ATTR_CHARISMA withDmgMods:YES withMatrixMods:NO withStatusMods:YES withName: @"Composure"];
}

- (IBAction)rollJudgeIntentions:(id)sender {
    [self rollAttrTest:SR6_ATTR_WILLPOWER secondAttr:SR6_ATTR_INTUITION withDmgMods:YES withMatrixMods:NO withStatusMods:YES withName: @"Judge Int"];
}

- (IBAction)rollWillRx:(id)sender {
    [self rollAttrTest:SR6_ATTR_WILLPOWER secondAttr:SR6_ATTR_REACTION withDmgMods:YES withMatrixMods:NO withStatusMods:YES withName:nil];
}

- (IBAction)rollWillSleaze:(id)sender {
    [self rollAttrTest:SR6_ATTR_WILLPOWER secondAttr:SR6_ATTR_SLEAZE withDmgMods:YES withMatrixMods:YES withStatusMods:NO withName:nil];
}

- (IBAction)rollWillFW:(id)sender {
    [self rollAttrTest:SR6_ATTR_WILLPOWER secondAttr:SR6_ATTR_FIREWALL withDmgMods:YES withMatrixMods:YES withStatusMods:NO withName:nil];
}

- (IBAction)rollDPFW:(id)sender {
    [self rollAttrTest:SR6_ATTR_DATA_PROCESSING secondAttr:SR6_ATTR_FIREWALL withDmgMods:YES withMatrixMods:YES withStatusMods:NO withName:nil];
}

- (IBAction)rollElectronicsInt:(id)sender {
    [self rollSkillTest:SR6_SKILL_ELECTRONICS secondAttr:SR6_ATTR_INTUITION withDmgMods:YES withMatrixMods:YES withStatusMods:YES withName:@"Matrix Perc."];
}

- (IBAction)rollInitative:(id)sender {
    // Initiative is a special case - we just roll init per hte standard way.
    SR6Actor *currentActor = (SR6Actor *)[[myActorArray arrangedObjects] objectAtIndex:[myActorArray selectionIndex]];
    [currentActor rollInit];
    
    // But then, we need to resort the order, as things may have moved. The array controller has a method for this...
    [myActorArray resortTableByInit];
}

- (IBAction)rollPerception:(id)sender {
    [self rollSkillTest:SR6_SKILL_PERCEPTION secondAttr:SR6_ATTR_INTUITION withDmgMods:YES withMatrixMods:YES withStatusMods:YES withName:@"Perception"];
}

- (IBAction)rollSurprise:(id)sender {
    [self rollAttrTest:SR6_ATTR_REACTION secondAttr:SR6_ATTR_INTUITION withDmgMods:YES withMatrixMods:NO withStatusMods:YES withName:@"Surprise"];
}

- (IBAction)rollRxInt:(id)sender {
    [self rollAttrTest:SR6_ATTR_REACTION secondAttr:SR6_ATTR_INTUITION withDmgMods:YES withMatrixMods:NO withStatusMods:YES withName:nil];
}

- (IBAction)rollWillInt:(id)sender {
    [self rollAttrTest:SR6_ATTR_WILLPOWER secondAttr:SR6_ATTR_INTUITION withDmgMods:YES withMatrixMods:NO withStatusMods:YES withName:nil];
}

- (IBAction)stAddStun:(id)sender {
    // The stepper has been clicked - we should check for overflow.
    SR6Actor *myActor = (SR6Actor *)(SR6Actor *)[[myActorArray selectedObjects] firstObject];
    [myActor checkDamageBoxes];
}

- (IBAction)stAddPhysical:(id)sender {
    // The stepper has been clicked - we should check for overflow.
    SR6Actor *myActor = (SR6Actor *)(SR6Actor *)[[myActorArray selectedObjects] firstObject];
    [myActor checkDamageBoxes];
}

- (IBAction)accelClicked:(id)sender {
    int iSegment = (int) [sender selectedSegment];
    
    SR6Actor *myActor = (SR6Actor *)(SR6Actor *)[[myActorArray selectedObjects] firstObject];
    
    if (iSegment == 0) {
        // Accelerating. Peg at top speed.
        if ((myActor.currentSpeed + myActor.vehAccel) > myActor.vehTopSpeed) {
            myActor.currentSpeed = myActor.vehTopSpeed;
        } else {
            myActor.currentSpeed = myActor.currentSpeed + myActor.vehAccel;
        }
    } else {
        // Decelerate. Peg at 0.
        if ((myActor.currentSpeed - myActor.vehAccel) < 0) {
            myActor.currentSpeed = 0;
        } else {
            myActor.currentSpeed = myActor.currentSpeed - myActor.vehAccel;
        }
    }
    
}

- (IBAction)imageZoom:(id)sender {
    // Take the current actor image and show it as a massive, full-screen overlay.
    if (!imagePanelController) {
        imagePanelController =[[ImagePanelController alloc] init];
    }
    imagePanelController.panelImage = imageViewer.image;
    
    [imagePanelController showWindow:self];
}

- (IBAction)imageBrowse:(id)sender {
    // Show the open dialogue and grab an image.
    // Create the File Open Dialog class.
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];

    // Enable the selection of files in the dialog.
    openDlg.canChooseFiles = TRUE;
    openDlg.allowsMultipleSelection = FALSE;
    openDlg.canChooseDirectories = FALSE;
    openDlg.allowedFileTypes = [NSArray arrayWithObjects:@"jpg",@"JPG",@"jpeg",@"JPEG",@"png",@"PNG",nil];
   
    // Display the dialog.  If the OK button was pressed,
    // process the files.
    if ( [openDlg runModal])     {
        // Get an array containing the full filenames of all
        // files and directories selected.
        NSArray* files = [openDlg URLs];
        
        if (files.count > 0) {
            NSURL* fileName = [files objectAtIndex:0];
            // Put the image linked into the actor object.
            NSImage *image = [[NSImage alloc] initWithContentsOfURL:fileName];
            SR6Actor *currentActor;
            currentActor = (SR6Actor *)[[myActorArray arrangedObjects] objectAtIndex:[myActorArray selectionIndex]];
            currentActor.picture = [image TIFFRepresentation];
        }
    }
}



#pragma mark Code for Setting Fomratters for Normal or Spirit/Sprite operation.

// This works by triggering off the ActorType being edigted event, whic calls a _setNumberForamats method.
// This method in turn calls format updates for all the impacted controls.
// Ths sneaky part is the skills, where 0 is no skill, while 1 is the level. Everything else is Level +/-.

- (IBAction)cbActorTypeEdited:(id)sender {
    // We got here
    [self _setNumberFormats];
    
    // Now we need to set the tabs.
    // This is less easy that I'd like - you have to remove the items from the tab array.
    // So we have a bunch of outlets which will hopefully keep them around once they are removed.
    // The other trick is to insert the tabs in the right location, we use a floating "index" taht starts at 2 (after the Qualities tab)
    NSUInteger startIndex;
    NSArray *myArray = [myActorArray arrangedObjects];
    startIndex = [myActorArray selectionIndex];
    SR6Actor *currentActor;
    NSUInteger count = [myArray count];
    
    if (startIndex > count) return;
    
    if (count == 1) {
        currentActor = (SR6Actor *)[myArray objectAtIndex:0];
    } else {
        currentActor = (SR6Actor *)[myArray objectAtIndex:startIndex];
    }
    startIndex = 1;
    
    if (currentActor.showQualities) {
        if ([tabView indexOfTabViewItem:tabQualities] == NSNotFound) {
            [tabView insertTabViewItem:tabQualities atIndex:startIndex];
        }
        startIndex++;
    } else {
        if ([tabView indexOfTabViewItem:tabQualities] != NSNotFound) {
            [tabView removeTabViewItem:tabQualities];
        }
    }
    
    if (currentActor.showAugs) {
        if ([tabView indexOfTabViewItem:tabAugs] == NSNotFound) {
            [tabView insertTabViewItem:tabAugs atIndex:startIndex];
        }
        startIndex++;
    } else {
        if ([tabView indexOfTabViewItem:tabAugs] != NSNotFound) {
            [tabView removeTabViewItem:tabAugs];
        }
    }
    
    if (currentActor.showMagic) {
        // We put these after the augs tab, if they are not in there.
        if ([tabView indexOfTabViewItem:tabMagic] == NSNotFound) {
            [tabView insertTabViewItem:tabMagic atIndex:startIndex];
        }
        startIndex++;
        if ([tabView indexOfTabViewItem:tabSpells] == NSNotFound) {
            [tabView insertTabViewItem:tabSpells atIndex:startIndex];
        }
        startIndex++;
        if ([tabView indexOfTabViewItem:tabAdepts] == NSNotFound) {
            [tabView insertTabViewItem:tabAdepts atIndex:startIndex];
        }
        startIndex++;
    } else {
        if ([tabView indexOfTabViewItem:tabMagic] != NSNotFound) {
            [tabView removeTabViewItem:tabMagic];
        }
        if ([tabView indexOfTabViewItem:tabSpells] != NSNotFound) {
            [tabView removeTabViewItem:tabSpells];
        }
        if ([tabView indexOfTabViewItem:tabAdepts] != NSNotFound) {
            [tabView removeTabViewItem:tabAdepts];
        }
    }
    
    if (currentActor.showPowers) {
        if ([tabView indexOfTabViewItem:tabPowers] == NSNotFound) {
            [tabView insertTabViewItem:tabPowers atIndex:startIndex];
        }
        startIndex++;
    } else {
        if ([tabView indexOfTabViewItem:tabPowers] != NSNotFound) {
            [tabView removeTabViewItem:tabPowers];
        }
    }
    
    if (currentActor.showMatrix) {
        if ([tabView indexOfTabViewItem:tabMatrix] == NSNotFound) {
            [tabView insertTabViewItem:tabMatrix atIndex:startIndex];
        }
        startIndex++;
    } else {
        if ([tabView indexOfTabViewItem:tabMatrix] != NSNotFound) {
            [tabView removeTabViewItem:tabMatrix];
        }
    }
    
    if (currentActor.showTechnomancer) {
        if ([tabView indexOfTabViewItem:tabTechnomancers] == NSNotFound) {
            [tabView insertTabViewItem:tabTechnomancers atIndex:startIndex];
        }
        startIndex++;
        if ([tabView indexOfTabViewItem:tabComplexForms] == NSNotFound) {
            [tabView insertTabViewItem:tabComplexForms atIndex:startIndex];
        }
        startIndex++;
    } else {
        if ([tabView indexOfTabViewItem:tabTechnomancers] != NSNotFound) {
            [tabView removeTabViewItem:tabTechnomancers];
        }
        if ([tabView indexOfTabViewItem:tabComplexForms] != NSNotFound) {
            [tabView removeTabViewItem:tabComplexForms];
        }
    }
}

-(void)_setNumberFormats {
    // Bail if nothing is selected.
    if (![myActorArray actorSelected]) return;
    // We'll need the currenta ctor.
    SR6Actor *myActor = (SR6Actor *)(SR6Actor *)[[myActorArray selectedObjects] firstObject];
    NSInteger iTmp = [myActor actorType];
    NSString *posPrefix;
    NSString *negPrefix;
    NSString *label;
    NSString *initPosPrefix;
    NSString *initNegPrefix;
    NSString *initZero;
    NSString *cmPosPrefix;
    NSString *cmNegPrefix;
    NSString *cmZero;
    
    int minimum;
    BOOL normal;
    
    // Configure some of the parameters based on the type of the actor.
    if (iTmp == 2) { // Spirit
        posPrefix = @"F+";
        negPrefix = @"F-";
        label = @"F";
        initPosPrefix = @"2F+";
        initNegPrefix = @"2F-";
        initZero = @"2F";
        cmPosPrefix = @"F/2+";
        cmNegPrefix = @"F/2-";
        cmZero = @"F/2";
        minimum = -50;
        normal = FALSE;
    } else if (iTmp == 5) { // Agent
        posPrefix = @"R+";
        negPrefix = @"R-";
        label = @"R";
        initPosPrefix = @"2R+";
        initNegPrefix = @"2R-";
        initZero = @"2R";
        cmPosPrefix = @"R/2+";
        cmNegPrefix = @"R/2-";
        cmZero = @"R/2";
        minimum = -50;
        normal = FALSE;
    } else if (iTmp == 9) { // Sprite
        posPrefix = @"L+";
        negPrefix = @"L-";
        label = @"L";
        initPosPrefix = @"2L+";
        initNegPrefix = @"2L-";
        initZero = @"2L";
        cmPosPrefix = @"L/2+";
        cmNegPrefix = @"L/2-";
        cmZero = @"L/2";
        minimum = -50;
        normal = FALSE;
    } else { // The rest.
        posPrefix = @"";
        negPrefix = @"";
        label = @"";
        initPosPrefix = @"";
        initNegPrefix = @"";
        initZero = @"";
        cmPosPrefix = @"";
        cmNegPrefix = @"";
        cmZero = @"";
        minimum = 0;
        normal = TRUE;
    }
    
    // Set the formats for the attribute boxes
    [self _setAttrFormat:textAttrBody stepper:stAttrBody posPrefix:posPrefix negPrefix:negPrefix zero:label minimum:minimum];
    [self _setAttrFormat:textAttrAgility stepper:stAttrAgility posPrefix:posPrefix negPrefix:negPrefix zero:label minimum:minimum];
    [self _setAttrFormat:textAttrReaction stepper:stAttrReaction posPrefix:posPrefix negPrefix:negPrefix zero:label minimum:minimum];
    [self _setAttrFormat:textAttrStrength stepper:stAttrStrength posPrefix:posPrefix negPrefix:negPrefix zero:label minimum:minimum];
    [self _setAttrFormat:textAttrWillpower stepper:stAttrWillpower posPrefix:posPrefix negPrefix:negPrefix zero:label minimum:minimum];
    [self _setAttrFormat:textAttrLogic stepper:stAttrLogic posPrefix:posPrefix negPrefix:negPrefix zero:label minimum:minimum];
    [self _setAttrFormat:textAttrIntuition stepper:stAttrIntuition posPrefix:posPrefix negPrefix:negPrefix zero:label minimum:minimum];
    [self _setAttrFormat:textAttrCharisma stepper:stAttrCharisma posPrefix:posPrefix negPrefix:negPrefix zero:label minimum:minimum];
    [self _setAttrFormat:textAttrMagic stepper:stAttrMagic posPrefix:posPrefix negPrefix:negPrefix zero:label minimum:minimum];
    [self _setAttrFormat:textAttrResonance stepper:stAttrResonance posPrefix:posPrefix negPrefix:negPrefix zero:label minimum:minimum];
    [self _setAttrFormat:textAttrEdge stepper:stAttrEdge posPrefix:posPrefix negPrefix:negPrefix zero:label minimum:minimum];
    
    // Essence is a little different. For spirits it's Force, sprites don't have it, and for everything else it's just a number.
    // There is no stepper, but that shouldn't cause a problem...should just be normal.
    [self _setEssenceFormat:textAttrEssence posPrefix:posPrefix negPrefix:negPrefix zero:label minimum:minimum];
    // We do need to shift the value around a bit, when we switch to "non-normal" types, and back.
    if ([textAttrEssence floatValue] == 6.0 && !normal) [myActor setAttrEssence:0.0];
    if ([textAttrEssence floatValue] == 0.0 && normal)[myActor setAttrEssence:6.0];
    
    // Skills are differnt. We need to distinguish between a skill at F+0, and skills that it (sprite, agent or spirit) doesn't have.
    // We do this by use of a custom value transformer.
    [self _setSkillFormat:textSkillAstral stepper:stSkillAstral normal:normal label:label value:[myActor skillAstral]];
    [self _setSkillFormat:textSkillAthletics stepper:stSkillAthletics normal:normal label:label value:[myActor skillAthletics]];
    [self _setSkillFormat:textSkillBiotech stepper:stSkillBiotech normal:normal label:label value:[myActor skillBiotech]];
    [self _setSkillFormat:textSkillCloseCombat stepper:stSkillCloseCombat normal:normal label:label value:[myActor skillCloseCombat]];
    [self _setSkillFormat:textSkillCon stepper:stSkillCon normal:normal label:label value:[myActor skillCon]];
    [self _setSkillFormat:textSkillConjuring stepper:stSkillConjuring normal:normal label:label value:[myActor skillConjuring]];
    [self _setSkillFormat:textSkillCracking stepper:stSkillCracking normal:normal label:label value:[myActor skillCracking]];
    [self _setSkillFormat:textSkillElectronics stepper:stSkillElectronics normal:normal label:label value:[myActor skillElectronics]];
    [self _setSkillFormat:textSkillEnchanting stepper:stSkillEnchanting normal:normal label:label value:[myActor skillEnchanting]];
    [self _setSkillFormat:textSkillEngineering stepper:stSkillEngineering normal:normal label:label value:[myActor skillEngineering]];
    [self _setSkillFormat:textSkillExoticWeapons stepper:stSkillExoticWeapons normal:normal label:label value:[myActor skillExoticWeapons]];
    [self _setSkillFormat:textSkillFirearms stepper:stSkillFirearms normal:normal label:label value:[myActor skillFirearms]];
    [self _setSkillFormat:textSkillInfluence stepper:stSkillInfluence normal:normal label:label value:[myActor skillInfluence]];
    [self _setSkillFormat:textSkillOutdoors stepper:stSkillOutdoors normal:normal label:label value:[myActor skillOutdoors]];
    [self _setSkillFormat:textSkillPerception stepper:stSkillPerception normal:normal label:label value:[myActor skillPerception]];
    [self _setSkillFormat:textSkillPilot stepper:stSkillPilot normal:normal label:label value:[myActor skillPilot]];
    [self _setSkillFormat:textSkillSorcery stepper:stSkillSorcery normal:normal label:label value:[myActor skillSorcery]];
    [self _setSkillFormat:textSkillStealth stepper:stSkillStealth normal:normal label:label value:[myActor skillStealth]];
    [self _setSkillFormat:textSkillTasking stepper:stSkillTasking normal:normal label:label value:[myActor skillTasking]];
    [self _setSkillFormat:textSkillOther stepper:stSkillOther normal:normal label:label value:[myActor skillOther]];
    // [self _setSkillFormat:textSkill stepper:stSkill normal:normal label:label value:[myActor skill]];
    
    // Set the matrix values as well. It's just like the skills.
    [self _setAttrFormat:textMatrixDeviceRating stepper:stMatrixDeviceRating posPrefix:posPrefix negPrefix:negPrefix zero:label minimum:minimum];
    [self _setAttrFormat:textMatrixAttack stepper:stMatrixAttack posPrefix:posPrefix negPrefix:negPrefix zero:label minimum:minimum];
    [self _setAttrFormat:textMatrixSleaze stepper:stMatrixSleaze posPrefix:posPrefix negPrefix:negPrefix zero:label minimum:minimum];
    [self _setAttrFormat:textMatrixDataProcessing stepper:stMatrixDataProcessing posPrefix:posPrefix negPrefix:negPrefix zero:label minimum:minimum];
    [self _setAttrFormat:textMatrixFirewall stepper:stMatrixFirewall posPrefix:posPrefix negPrefix:negPrefix zero:label minimum:minimum];
    
    // Set the matrix values as well. It's just like the skills.
    [self _setAttrFormat:textMatrixAttack2 stepper:stMatrixAttack2 posPrefix:posPrefix negPrefix:negPrefix zero:label minimum:minimum];
    [self _setAttrFormat:textMatrixSleaze2 stepper:stMatrixSleaze2 posPrefix:posPrefix negPrefix:negPrefix zero:label minimum:minimum];
    [self _setAttrFormat:textMatrixDataProcessing2 stepper:stMatrixDataProcessing2 posPrefix:posPrefix negPrefix:negPrefix zero:label minimum:minimum];
    [self _setAttrFormat:textMatrixFirewall2 stepper:stMatrixFirewall2 posPrefix:posPrefix negPrefix:negPrefix zero:label minimum:minimum];
    
    
    // Also need to do the intiative stats. These are like the attributes.
    [self _setAttrFormat:textPhysicalInit stepper:stPhysicalInit posPrefix:initPosPrefix negPrefix:initNegPrefix zero:initZero minimum:minimum];
    [self _setAttrFormat:textMatrixInit stepper:stMatrixInit posPrefix:initPosPrefix negPrefix:initNegPrefix zero:initZero minimum:minimum];
    [self _setAttrFormat:textMatrixInit2 stepper:stMatrixInit2 posPrefix:initPosPrefix negPrefix:initNegPrefix zero:initZero minimum:minimum];
    [self _setAttrFormat:textAstralInit stepper:stAstralInit posPrefix:initPosPrefix negPrefix:initNegPrefix zero:initZero minimum:minimum];
    
    // Want to set these to 0 if we are a level-based actor, and it's at the default value.
    if (!normal) {
        if (myActor.physicalInitiative == 10) [myActor setPhysicalInitiative:0];
        if (myActor.matrixInitiative == 10) [myActor setMatrixInitiative:0];
        if (myActor.astralInitiative == 10) [myActor setAstralInitiative:0];
    }
    
    // And the condition monitors...this is getting tiresome.
    [self _setAttrFormat:textCMPhysical stepper:stCMPhysical posPrefix:cmPosPrefix negPrefix:cmNegPrefix zero:cmZero minimum:minimum];
    [self _setAttrFormat:textCMStun stepper:stCMStun posPrefix:cmPosPrefix negPrefix:cmNegPrefix zero:cmZero minimum:minimum];
    [self _setAttrFormat:textCMMatrix stepper:stCMMatrix posPrefix:cmPosPrefix negPrefix:cmNegPrefix zero:cmZero minimum:minimum];
    [self _setAttrFormat:textCMMatrix2 stepper:stCMMatrix2 posPrefix:cmPosPrefix negPrefix:cmNegPrefix zero:cmZero minimum:minimum];
    
    // And the defense rating.
    [self _setAttrFormat:textDefenseRating stepper:stDefenseRating posPrefix:posPrefix negPrefix:negPrefix zero:label minimum:minimum];
    [self _setAttrFormat:textMatrixAttackRating stepper:stMatrixAttackRating posPrefix:initPosPrefix negPrefix:initNegPrefix zero:initZero minimum:minimum];
    [self _setAttrFormat:textMatrixDefenseRating stepper:stMatrixDefenseRating posPrefix:initPosPrefix negPrefix:initNegPrefix zero:initZero minimum:minimum];
    [self _setAttrFormat:textMatrixAttackRating2 stepper:stMatrixAttackRating2 posPrefix:initPosPrefix negPrefix:initNegPrefix zero:initZero minimum:minimum];
    [self _setAttrFormat:textMatrixDefenseRating2 stepper:stMatrixDefenseRating2 posPrefix:initPosPrefix negPrefix:initNegPrefix zero:initZero minimum:minimum];
    
    // We should also enable/disable things, but I think we can do that using bindings. Er... we can.
    
    // One last thing - if the actor type has been set to IC/Agent/Sprite, the mode should be set to Matrix (Hot).
    if ([myActor isMatrixModeOnly]) {
        myActor.currentMode = kModeMatrixHot;
    }
    // We ignore other things, becuase they may or may not be able to get on the matrix.
}

-(void)_setAttrFormat:(NSTextField *)textAttr stepper:(NSStepper *)stAttr posPrefix:(NSString *)posPrefix negPrefix:(NSString *)negPrefix zero:(NSString *)zero minimum: (int) minimum {
    // Utility method to set the number formats for a stepper and text field.
    NSNumberFormatter *aFormatter = textAttr.cell.formatter;
    aFormatter.positivePrefix = posPrefix;
    aFormatter.negativePrefix = negPrefix;
    aFormatter.minimum = [NSNumber numberWithInt:minimum];
    if ([zero isEqualToString:@""]) {
        aFormatter.zeroSymbol = nil; // Has to be an empty string.
    } else {
        aFormatter.zeroSymbol = zero;
    }
    stAttr.minValue = minimum;
    
    // Now, trigger a refresh? I haven't found a good way to do this...so we are doing it a bad way.
    textAttr.intValue--;
    textAttr.intValue++;
}

-(void)_setEssenceFormat:(NSTextField *)essenceAttr posPrefix:(NSString *)posPrefix negPrefix:(NSString *)negPrefix zero:(NSString *)zero minimum:(int) minimum {
    // Utility method to set the number formats for a stepper and text field.
    NSNumberFormatter *aFormatter = essenceAttr.cell.formatter;
    aFormatter.positivePrefix = posPrefix;
    aFormatter.negativePrefix = negPrefix;
    aFormatter.minimum = [NSNumber numberWithInt:minimum];
    if ([zero isEqualToString:@""]) {
        aFormatter.zeroSymbol = nil; // Has to be an empty string.
    } else {
        aFormatter.zeroSymbol = zero;
    }
    
    // Now, trigger a refresh? I haven't found a good way to do this...so we are doing it a bad way.
    essenceAttr.floatValue--;
    essenceAttr.floatValue++;
}

-(void)_setSkillFormat:(NSTextField *)textSkill stepper:(NSStepper *)stSkill normal:(BOOL) normal label:(NSString *)label value:(NSInteger) value {
    // Utility method to set the number formats for a stepper and a text field for skill ratings.
    // It's either a number...or a toggle between Force or nothing
    NSNumberFormatter * newFormatter = [[NSNumberFormatter alloc] init];
    newFormatter.numberStyle = NSNumberFormatterNoStyle;
    newFormatter.minimum = [NSNumber numberWithInt:0];
    newFormatter.maximum = [NSNumber numberWithInt:20];
    StringToSkill *sts = (StringToSkill *)[NSValueTransformer valueTransformerForName:@"StringToSkill"];
    sts.levelLabel = label;
    if (normal) {
        stSkill.valueWraps = FALSE;
        stSkill.minValue = 0;
        stSkill.maxValue = 20;
        textSkill.cell.formatter = newFormatter;
        textSkill.intValue --;
        textSkill.intValue++;
        stSkill.intValue = (int)value;
        textSkill.intValue = (int)value;
    } else {
        stSkill.valueWraps = TRUE;
        stSkill.minValue = 0;
        stSkill.maxValue = 1;
        textSkill.cell.formatter = nil;
        if (value == 0) {
            stSkill.intValue = 0;
            textSkill.stringValue = @"–";
        } else {
            stSkill.intValue = 1;
            textSkill.stringValue = label;
        }
    }
}





#pragma mark Status Interface code


-(void)_configureDuration:(int) duration {
    // Enable any disabled controls.
    buttonStatusDurationIndefinite.enabled = TRUE;
    buttonStatusDurationRounds.enabled = TRUE;
    if (duration >= 0) {
        textStatusDuration.integerValue = duration;
        textStatusDuration.enabled = TRUE;
        stepperStatusDurationRounds.enabled = TRUE;
        buttonStatusDurationRounds.state = NSControlStateValueOn;
        buttonStatusDurationIndefinite.state = NSControlStateValueOff;
        
        // Set the duration in the actor object to keep things synced correctly.
        SR6Actor *currentActor;
        currentActor = (SR6Actor *)[[myActorArray arrangedObjects] objectAtIndex:[myActorArray selectionIndex]];
        currentActor.statusDuration = [NSNumber numberWithInt:duration];
    } else if (duration == -1) { // Indefinite
        textStatusDuration.integerValue = 6;// Put a default value here.
        textStatusDuration.enabled = FALSE;
        stepperStatusDurationRounds.enabled = FALSE;
        buttonStatusDurationRounds.state = NSControlStateValueOff;
        buttonStatusDurationIndefinite.state = NSControlStateValueOn;
        
        SR6Actor *currentActor;
        currentActor = (SR6Actor *)[[myActorArray arrangedObjects] objectAtIndex:[myActorArray selectionIndex]];
        currentActor.statusDuration = [NSNumber numberWithInt:6];
    }
}

-(void)_configureRating:(BOOL)enabled rating:(NSInteger)rating min:(NSInteger)min max:(NSInteger)max {
    if (enabled) {
        textStatusRating.enabled = TRUE;
        stepperStatusRating.enabled = TRUE;
        textStatusRating.integerValue = rating;
        stepperStatusRating.maxValue = (double)max;
        stepperStatusRating.minValue = (double)min;
        [(NSNumberFormatter *)[textStatusRating formatter] setMaximum:[NSNumber numberWithInteger:max]];
        [(NSNumberFormatter *)[textStatusRating formatter] setMinimum:[NSNumber numberWithInteger:min]];
        stepperStatusRating.integerValue = rating;
        labelRating.enabled = TRUE;
        
        // Set the rating in the actor object to keep things synced correctly.
        SR6Actor *currentActor;
        currentActor = (SR6Actor *)[[myActorArray arrangedObjects] objectAtIndex:[myActorArray selectionIndex]];
        currentActor.statusRating = [NSNumber numberWithInteger:rating];
        labelRating.textColor = [NSColor labelColor];
    } else {
        // Disable
        textStatusRating.enabled = FALSE;
        stepperStatusRating.enabled = FALSE;
        labelRating.enabled = FALSE;
        textStatusRating.stringValue = @"NA";
        labelRating.textColor = [NSColor disabledControlTextColor];
    }
}

-(void)_clearStatusUI{
    textStatusRating.enabled = FALSE;
    textStatusDuration.enabled = FALSE;
    stepperStatusRating.enabled = FALSE;
    stepperStatusDurationRounds.enabled = FALSE;
    buttonStatusDurationRounds.enabled = FALSE;
    buttonStatusDurationIndefinite.state = NSControlStateValueOn;
    buttonStatusDurationIndefinite.enabled = FALSE;
    buttonAddStatus.enabled = FALSE;
    buttonRemoveStatus.enabled = FALSE;
    //labelRating.enabled = FALSE;
    //comboBoxStatus.enabled = FALSE;
    [comboBoxStatus deselectItemAtIndex:[comboBoxStatus indexOfSelectedItem]];
    labelRating.textColor = [NSColor disabledControlTextColor];
    labelStatusDesc.stringValue = @"";
}

-(void) _syncStatusToDoc:(NSString *)newStatus {
    // This updates the UI to reflect what's displayed to the user, in terms of the UI controls. Fired when the user clicks on an entry in the status table,
    // or when they select from the combo box.
    SR6Actor *currentActor;
    currentActor = (SR6Actor *)[[myActorArray arrangedObjects] objectAtIndex:[myActorArray selectionIndex]];
    if ([newStatus isEqualToString:SR6_STATUS_BACKGROUND]) {
        [self _configureDuration:currentActor.statusBackgroundDuration];
        [self _configureRating:TRUE rating:currentActor.statusBackgroundRating min: -20 max: 20];
        labelStatusDesc.stringValue = @"+/- rating to all Magic-linked tests (not yet defined in SR6).";
    } else if ([newStatus isEqualToString:SR6_STATUS_BLINDED]) {
        [self _configureDuration:currentActor.statusBlindedDuration];
        [self _configureRating:TRUE rating:currentActor.statusBlindedRating min: 1 max: 3];
        labelStatusDesc.stringValue = @"-3 to all vision-related tests per level; auto-fail at level 3.";
    } else if ([newStatus isEqualToString:SR6_STATUS_BURNING]) {
        [self _configureDuration:currentActor.statusBurningDuration];
        [self _configureRating:TRUE rating:currentActor.statusBurningRating min: 1 max: 20];
        labelStatusDesc.stringValue = @"Resist R DV each round. Major Agil + Rx (2) to put out.";
    } else if ([newStatus isEqualToString:SR6_STATUS_CHILLED]) {
        [self _configureDuration:currentActor.statusChilledDuration];
        [self _configureRating:FALSE rating:0 min: 0 max: 20];
        labelStatusDesc.stringValue = @"-4 to Init Score, -1 to all DP except Dmg Resist. Burning cancels.";
    } else if ([newStatus isEqualToString:SR6_STATUS_CONFUSED]) {
        [self _configureDuration:currentActor.statusConfusedDuration];
        [self _configureRating:TRUE rating:currentActor.statusConfusedRating min: 1 max: 20];
        labelStatusDesc.stringValue = @"Rating DP penalty on all actions.";
    } else if ([newStatus isEqualToString:SR6_STATUS_CORROSSIVE]) {
        [self _configureDuration:currentActor.statusCorrossiveDuration];
        [self _configureRating:TRUE rating:currentActor.statusCorrossiveRating min: 1 max: 20];
        labelStatusDesc.stringValue = @"Resist # DV dmg each rnd. Wet may remove.";
    } else if ([newStatus isEqualToString:SR6_STATUS_COVER]) {
        [self _configureDuration:currentActor.statusCoverDuration];
        [self _configureRating:TRUE rating:currentActor.statusCoverRating min: 1 max: 4];
        labelStatusDesc.stringValue = @"+Rating to DR, +Rating to Def Tests. Minor to att. 4: -2 DP; No edge on att.";
    } else if ([newStatus isEqualToString:SR6_STATUS_DAZED]) {
        [self _configureDuration:currentActor.statusDazedDuration];
        [self _configureRating:FALSE rating:0 min: 0 max: 20];
        labelStatusDesc.stringValue = @"-4 to Init Score. Cannot gain/spend edge.";
    } else if ([newStatus isEqualToString:SR6_STATUS_DEAFENED]) {
        [self _configureDuration:currentActor.statusDeafenedDuration];
        [self _configureRating:TRUE rating:currentActor.statusDeafenedRating min: 1 max: 3];
        labelStatusDesc.stringValue = @"1, 2: -3 DP penalty to all hearing-related tests. 3: Auto fail.";
    } else if ([newStatus isEqualToString:SR6_STATUS_DISABLED_ARM]) {
        [self _configureDuration:currentActor.statusDisabledArmDuration];
        [self _configureRating:TRUE rating:currentActor.statusDisabledArmRating min: 1 max: 3];
        labelStatusDesc.stringValue = @"1: +1 Minor to Minor; 2: + 1 Minor to Major; 3 - -4 DP to tests.";
    } else if ([newStatus isEqualToString:SR6_STATUS_DISABLED_LEG]) {
        [self _configureDuration:currentActor.statusDisabledLegDuration];
        [self _configureRating:TRUE rating:currentActor.statusDisabledLegRating min: 1 max: 3];
        labelStatusDesc.stringValue = @"1: +1 Minor to Minor; 2: + 1 Minor to Major; 3 - Hobbled.";
    } else if ([newStatus isEqualToString:SR6_STATUS_FATIGUED]) {
        [self _configureDuration:currentActor.statusFatiguedDuration];
        [self _configureRating:TRUE rating:currentActor.statusFatiguedRating min: 1 max: 3];
        labelStatusDesc.stringValue = @"-2 DP/level on all tests except Dmg Resist. Move 5m, Sprint 10m.";
    } else if ([newStatus isEqualToString:SR6_STATUS_FRIGHTENED]) {
        [self _configureDuration:currentActor.statusFrightenedDuration];
        [self _configureRating:FALSE rating:0 min: 0 max: 20];
        labelStatusDesc.stringValue = @"-4 DP on tests directed to or defending against source of fear.";
    } else if ([newStatus isEqualToString:SR6_STATUS_HAZED]) {
        [self _configureDuration:currentActor.statusHazedDuration];
        [self _configureRating:FALSE rating:0 min: 0 max: 20];
        labelStatusDesc.stringValue = @"Cannot astrally project or manifest. Stuck if projecting.";
    } else if ([newStatus isEqualToString:SR6_STATUS_HOBBLED]) {
        [self _configureDuration:currentActor.statusHobbledDuration];
        [self _configureRating:FALSE rating:0 min: 0 max: 20];
        labelStatusDesc.stringValue = @"Any movement is halved (round up).";
    } else if ([newStatus isEqualToString:SR6_STATUS_IMMOBILIZED]) {
        [self _configureDuration:currentActor.statusImmobilizedDuration];
        [self _configureRating:FALSE rating:0 min: 0 max: 20];
        labelStatusDesc.stringValue = @"Cannot move. AR -3. -3 DP on all attacks. No Rx on Def tests.";
    } else if ([newStatus isEqualToString:SR6_STATUS_INVISIBLE]) {
        [self _configureDuration:currentActor.statusInvisibleDuration];
        [self _configureRating:TRUE rating:currentActor.statusInvisibleRating min: 1 max: 20];
        labelStatusDesc.stringValue = @"TH to perceive on Perception test. Cameras unaffected.";
    } else if ([newStatus isEqualToString:SR6_STATUS_INVISIBLE_IMP]) {
        [self _configureDuration:currentActor.statusInvisibleImprovedDuration];
        [self _configureRating:TRUE rating:currentActor.statusInvisibleImprovedRating min: 1 max: 20];
        labelStatusDesc.stringValue = @"TH to perceive on Perception test. Cameras affected.";
    } else if ([newStatus isEqualToString:SR6_STATUS_MUTED]) {
        [self _configureDuration:currentActor.statusMutedDuration];
        [self _configureRating:FALSE rating:0 min: 0 max: 20];
        labelStatusDesc.stringValue = @"Can't speak.";
    } else if ([newStatus isEqualToString:SR6_STATUS_NAUSEATED]) {
        [self _configureDuration:currentActor.statusNauseatedDuration];
        [self _configureRating:FALSE rating:0 min: 0 max: 20];
        labelStatusDesc.stringValue = @"Bod+Will (2) at start of rnd. Fail: no action. Succeed: Lose Minor.";
    } else if ([newStatus isEqualToString:SR6_STATUS_NOISE]) {
        [self _configureDuration:currentActor.statusNoiseDuration];
        [self _configureRating:TRUE rating:currentActor.statusNoiseRating min: 1 max: 20];
        labelStatusDesc.stringValue = @"-1 DP/level on Matrix tests. If > Dev Rtg, no access.";
    } else if ([newStatus isEqualToString:SR6_STATUS_OFF_BALANCE]) {
        [self _configureDuration:currentActor.statusMutedDuration];
        [self _configureRating:FALSE rating:0 min: 0 max: 20];
        labelStatusDesc.stringValue = @"Cannot spend Edge on Phys Attr or Defense tests. Prone on Glitch. Minor to remove.";
    } else if ([newStatus isEqualToString:SR6_STATUS_PANICKED]) {
        [self _configureDuration:currentActor.statusPanickedDuration];
        [self _configureRating:FALSE rating:0 min: 0 max: 20];
        labelStatusDesc.stringValue = @"Cannot act except to avoid the condition causing effect.";
    } else if ([newStatus isEqualToString:SR6_STATUS_PETRIFIED]) {
        [self _configureDuration:currentActor.statusPetrifiedDuration];
        [self _configureRating:FALSE rating:0 min: 0 max: 20];
        labelStatusDesc.stringValue = @"Turned solid. No actions. +10 armor. All other statuses cancelled.";
    } else if ([newStatus isEqualToString:SR6_STATUS_POISONED]) {
        [self _configureDuration:currentActor.statusPoisonedDuration];
        [self _configureRating:TRUE rating:currentActor.statusPoisonedRating min: 1 max: 20];
        labelStatusDesc.stringValue = @"At end of each rnd, resist # DV (P or S) with Bod. -1 DV each rnd.";
    } else if ([newStatus isEqualToString:SR6_STATUS_PRONE]) {
        [self _configureDuration:currentActor.statusProneDuration];
        [self _configureRating:FALSE rating:0 min: 0 max: 20];
        labelStatusDesc.stringValue = @"Med: +2 Def DP; Close/Near:-2. -4 DP melee/bow. +2 AR rng.";
    } else if ([newStatus isEqualToString:SR6_STATUS_SILENT]) {
        [self _configureDuration:currentActor.statusSilentDuration];
        [self _configureRating:TRUE rating:currentActor.statusSilentRating min: 1 max: 20];
        labelStatusDesc.stringValue = @"TH to perceive on Perception test. Microphones unaffected.";
    } else if ([newStatus isEqualToString:SR6_STATUS_SILENT_IMP]) {
        [self _configureDuration:currentActor.statusSilentImprovedDuration];
        [self _configureRating:TRUE rating:currentActor.statusSilentImprovedRating min: 1 max: 20];
        labelStatusDesc.stringValue = @"TH to perceive on Perception test. Microphones affected.";
    } else if ([newStatus isEqualToString:SR6_STATUS_STILLED]) {
        [self _configureDuration:currentActor.statusStilledDuration];
        [self _configureRating:FALSE rating:0 min: 0 max: 20];
        labelStatusDesc.stringValue = @"-10 to DR. Aware. No Def tests. No dmg from ongoing effects.";
    } else if ([newStatus isEqualToString:SR6_STATUS_WET]) {
        [self _configureDuration:currentActor.statusWetDuration];
        [self _configureRating:FALSE rating:0 min: 0 max: 20];
        labelStatusDesc.stringValue = @"-6 to Damage Resistance tests against electricity and cold.";
    } else if ([newStatus isEqualToString:SR6_STATUS_ZAPPED]) {
        [self _configureDuration:currentActor.statusZappedDuration];
        [self _configureRating:FALSE rating:0 min: 0 max: 20];
        labelStatusDesc.stringValue = @"-2 to Init Score. No Sprint actions. DP -1 on all actions.";
    } else {
        // We shouldn't ever get here...but if we do...
        NSLog(@"syncStatusToDoc: Invalid status name: %@",newStatus);
        [self _configureDuration:0];
        [self _configureRating:FALSE rating:0 min:0 max:0];
        labelStatusDesc.stringValue = @"Uh-oh.";
    }
    
    buttonAddStatus.enabled = TRUE;
    buttonRemoveStatus.enabled = TRUE;
}

// IBACtions for adding/removing statuses.
-(IBAction) addStatus:(id)sender {
    // User has clicked "add status"
    // So, we need to figure out what has been selected.
    NSString *statusName;
    
    // First, grab the status name and the current actor.
    statusName = comboBoxStatus.stringValue;
    if ([statusName isEqualToString:@""]) return;
    
    if (buttonStatusDurationRounds.state == NSControlStateValueOn) {
        [(SR6Actor *)[[myActorArray arrangedObjects] objectAtIndex:[myActorArray selectionIndex]] addStatus:statusName duration:textStatusDuration.integerValue rating:textStatusRating.integerValue];
    } else {
        [(SR6Actor *)[[myActorArray arrangedObjects] objectAtIndex:[myActorArray selectionIndex]] addStatus:statusName duration:-1 rating:textStatusRating.integerValue];
    }
    [statusTableView reloadData];
    // We also need to reload the row in the table view, we've changed that string as well.
    [actorTableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:[actorTableView selectedRow]] columnIndexes:[NSIndexSet indexSetWithIndex:7]];
    
    buttonRemoveStatus.enabled = TRUE;

}



-(IBAction)removeStatus:(id)sender {
    // Remove the currently selected status. This is relatively easy.
    [(SR6Actor *)[[myActorArray arrangedObjects] objectAtIndex:[myActorArray selectionIndex]] removeStatus:comboBoxStatus.stringValue];
    [statusTableView reloadData];
    // We also need to reload the row in the table view, we've changed that string as well.
    [actorTableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:[actorTableView selectedRow]] columnIndexes:[NSIndexSet indexSetWithIndex:7]];
    
    if ([statusTableView numberOfRows] > 0) {
        [statusTableView deselectAll:nil];
        [statusTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:FALSE];
        buttonRemoveStatus.enabled = TRUE;
    } else {
        buttonRemoveStatus.enabled = FALSE;
    }
}

-(IBAction) radioDuration:(id)sender {
    if (buttonStatusDurationRounds.state == NSControlStateValueOn){
        textStatusDuration.enabled = TRUE;
        stepperStatusDurationRounds.enabled = TRUE;
    } else {
        textStatusDuration.enabled = FALSE;
        stepperStatusDurationRounds.enabled = FALSE;
    }
}

#pragma mark Combo Box Delegate and data source stuff.
-(void)comboBoxSelectionIsChanging:(NSNotification *)notification {
    // This is called before things change. So we need to save things off.
    // Which is the same thing as adding one...so...
    // Or not - I think we only want to save the status change when they select "save status"
    //[self addStatus:comboBoxStatus];
}

-(void)comboBoxSelectionDidChange:(NSNotification *)notification {
    // This is called after the entry is changed. So, now we want to sync up.
    if ((int)comboBoxStatus.indexOfSelectedItem != -1) {
        [self _syncStatusToDoc:[myActorArray.statusTypes objectAtIndex:comboBoxStatus.indexOfSelectedItem]];
    }
}

#pragma mark Text View Delegate

// We want to make sure pasted text keeps the right background color if someone is pasting in text. And make the foreground color white if it's black.
-(BOOL)textView:(NSTextView *)textView shouldChangeTextInRange:(NSRange)affectedCharRange replacementString:(NSString *)replacementString {
    
    if (replacementString.length > 1) {
        // If the affected range is long, it's probably a paste.
        // Let the paste happen, but make sure we set the background to the default.
        // The only trick is, I think, that we need to make sure change happens _after_ the paste.
        // A bit of a hack, but it works.
        [self performSelector:@selector(clearBackground) withObject:self afterDelay:0];
        [self performSelector:@selector(clearBlackForeground) withObject:self afterDelay:0];
        [self performSelector:@selector(clearSmallSizeText) withObject:self afterDelay:0];
        pastedRange = NSMakeRange(affectedCharRange.location,replacementString.length)
        ;
    }
    return YES;
}


-(void)clearBackground{
    // This clears the background of whatever text is in the details text view.
    // Grab the current string - pull it from the text view.
    NSMutableAttributedString *myStr = (NSMutableAttributedString *)[textViewDetails attributedString];
    NSRange tmpRange = NSMakeRange(0, [textViewDetails.attributedString length]);
        
    // Set it the usual background as the background color.
    [myStr addAttribute:NSBackgroundColorAttributeName value:[NSColor textBackgroundColor] range:tmpRange];
}

-(void) clearBlackForeground {
    // This goes through the pasted range, and removes any black text formatting.
    NSMutableAttributedString *myStr = (NSMutableAttributedString *)[textViewDetails attributedString];
    
    // If the string has a foreground color close to the background color (within 90%).
    NSRange effRange;
    NSColor *tmpColor;
    CGFloat r,g,b,a;
    CGFloat rs,gs,bs,as; // Source component colors.
    
    while (pastedRange.length > 0) {
        // Go through the pasted range, looking for the attributes in question.
        tmpColor = (NSColor *)[myStr attribute:NSForegroundColorAttributeName atIndex:pastedRange.location effectiveRange:&effRange];
        
        // If the color is nil, then there are no color attributes, and we can safely override them, and make sure they match the text color.
        if (tmpColor == nil) {
            // But, if the effective range isn't the full range that was pasted, they change colors in it. So we use the effective range, not the full range.
            //[myStr removeAttribute:NSForegroundColorAttributeName range:pastedRange];
            [myStr addAttribute:NSForegroundColorAttributeName value:[NSColor textColor] range:effRange];
        } else {
            // There is a color. We want to get rid of it, if it's black and we are in Dark Mode, or white and we are in light mode.
            // We don't have to care about the mode. We can just look at the current foreround text color and compare.
            NSColor *systemBackgroundColor = [textViewDetails.backgroundColor colorUsingColorSpace:[NSColorSpace genericRGBColorSpace]];
            NSColor *textForegroundColor = [tmpColor colorUsingColorSpace:[NSColorSpace genericRGBColorSpace]];
            [systemBackgroundColor getRed:&rs green:&gs blue:&bs alpha:&as];
            [textForegroundColor getRed:&r green:&g blue:&b alpha:&a];
               
            // So, now we compare them - within 10% is enough for me.
            if (((rs-r)/rs > 0.9) && ((gs-g)/gs > 0.9) && ((bs-b)/bs > 0.9)) {
                // We're awfully close, so add a new color attribute.
                [myStr addAttribute:NSForegroundColorAttributeName value:[NSColor textColor] range:effRange];
            }
        }// If there is a color, we don't do anything except advance forward.
        
        // Advance forward
        pastedRange.location = pastedRange.location+effRange.length;
        if (pastedRange.length > effRange.length) {
            pastedRange.length = pastedRange.length - effRange.length;
        } else {
            pastedRange.length = 0;
        }
    }
}

-(void) clearSmallSizeText {
    // This goes through the pasted range, and gets rid of any text sizes smaller than 12.
    NSMutableAttributedString *myStr = (NSMutableAttributedString *)[textViewDetails attributedString];
    
    // Since there might be multiple ranges with the wrong size, we use the enumerateAttributesInRange.
    // This code derived from something I found on stackoverflow - I haven't got a handle on code blocks.
    // I could probably use them for the other "clear" methods, but I got those working, so I'm leaving
    // Them alone.
    
    [myStr enumerateAttributesInRange: NSMakeRange(0, myStr.string.length)
                                  options:NSAttributedStringEnumerationReverse usingBlock:
    ^(NSDictionary *attributes, NSRange range, BOOL *stop) {
        NSMutableDictionary *mutableAttributes = [NSMutableDictionary dictionaryWithDictionary:attributes];

        NSFont *myFont = [mutableAttributes objectForKey:NSFontAttributeName];
        if (myFont.pointSize < 12.0){
            NSFont *newFont = [NSFont fontWithName:[myFont fontName] size:12.0];
            [myStr removeAttribute:@"NSFont" range:range];
            [myStr addAttribute:@"NSFont" value:newFont range:range];
        }
    }];
    
}

#pragma mark Table View Delegate

// Table view delegate stuff. We are a delegate for two tables - the actorTable, and the status table, so we have to do different things
// for each one.

-(void)tableViewSelectionDidChange:(NSNotification *)notification {
    // The selection did change.
    // This gets called when we are shutting down, so we need to escape.
    NSArray *myArray = [myActorArray arrangedObjects];
    //if ([[myActorArray arrangedObjects] numberOfItems] == 0) return;
    if ([myArray count] == 0) return;
    
    // This could be the status table or the actor table, what we do depends on it.
    if (notification.object == statusTableView) {
        // They clicked on the status table view somehwere.
        // So we need to set the combo box to the proper value.
        NSInteger selectedRow = (NSInteger)[statusTableView selectedRow];
        // If there is a row selected, go for it.
        if (selectedRow != -1) {
            NSString *sTmp = [[statusTableView dataSource] tableView:statusTableView objectValueForTableColumn:[[NSTableColumn alloc] initWithIdentifier:@"Status"] row:selectedRow];
            NSUInteger counter;
            
            for(counter = 0; counter < myActorArray.statusTypes.count; counter++){
                if([sTmp isEqualToString:(NSString *)[myActorArray.statusTypes objectAtIndex:counter]]) {
                    [comboBoxStatus selectItemAtIndex:counter];
                    break;
                }
            }
        }
    } else {
        // The user must have clicked on the Actor table, so we reload the status table view.
        [statusTableView reloadData];
        
        // When we reload, we also want to make sure that the detail bit is cleared as well.
        [self _clearStatusUI];
        [statusTableView deselectAll:self];
        if ([statusTableView numberOfRows] > 0) {
            [statusTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:FALSE];
            buttonRemoveStatus.enabled = TRUE;
        } else {
            buttonRemoveStatus.enabled = FALSE;
        }
        // We need to update the display configuration based on the type of actor selected.
        [self _setNumberFormats];
        
        // We also need to set the visible tabs.
        [self cbActorTypeEdited:notification.object];
        
        // And the mentor.
        [myActorArray selectMentor];
        
        // And the various sum calculations
        SR6Actor *myActor = (SR6Actor *)[[myActorArray selectedObjects] firstObject];
        if (myActor == nil) return; // This can happen when the filter is cleared - you can get a no-selection, oddly.
        lblTotalKarma.stringValue = myActor.totalQualityKarmaString;
        lblTotalEssence.stringValue = myActor.totalEssenceString;
        lblTotalPowerPoints.stringValue = myActor.totalPowerPointsString;
        lblTotalSpellsSustained.stringValue = myActor.numberSustainedString;
        lblProgramsRunning.stringValue = myActor.numberProgramsRunningString;
        lblCFsSustained.stringValue = myActor.numberCFsSustained;
    }
}

-(NSString *)tableView:(NSTableView *)tableView toolTipForCell:(nonnull NSCell *)cell rect:(nonnull NSRectPointer)rect tableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row mouseLocation:(NSPoint)mouseLocation {
    // We are providing the tool tip via this delegate.
    NSString *aString;
    
    if (tableView == actorTableView) {
        // If it's the actor table view, don't do anything.
        aString = @"";
    } else {
        NSString *status;
        status = cell.stringValue;
        
        if ([status isEqualToString:SR6_STATUS_BACKGROUND]) {
            aString = @"+/- rating to all Magic-linked tests (not yet defined in SR6).";
        } else if ([status isEqualToString:SR6_STATUS_BLINDED]) {
            aString = @"-3 to all vision-related tests per level; auto-fail at level 3.";
        } else if ([status isEqualToString:SR6_STATUS_BURNING]) {
            aString = @"Resist R DV each round. Major Agil + Rx (2) to put out.";
        } else if ([status isEqualToString:SR6_STATUS_CHILLED]) {
            aString = @"-4 to Init Score, -1 to all DP except Dmg Resist. Burning cancels.";
        } else if ([status isEqualToString:SR6_STATUS_CONFUSED]) {
            aString = @"Rating DP penalty on all actions.";
        } else if ([status isEqualToString:SR6_STATUS_CORROSSIVE]) {
            aString = @"Resist # DV dmg each rnd. Wet may remove.";
        } else if ([status isEqualToString:SR6_STATUS_COVER]) {
            aString = @"+Rating to DR, +Rating to Def Tests. Minor to att. 4: -2 DP; No edge on att.";
        } else if ([status isEqualToString:SR6_STATUS_DAZED]) {
            aString = @"-4 to Init Score. Cannot gain/spend edge.";
        } else if ([status isEqualToString:SR6_STATUS_DEAFENED]) {
            aString = @"1, 2: -3 DP penalty to all hearing-related tests. 3: Auto fail.";
        } else if ([status isEqualToString:SR6_STATUS_DISABLED_ARM]) {
            aString = @"1: +1 Minor to Minor; 2: + 1 Minor to Major; 3 - -4 DP to tests.";
        } else if ([status isEqualToString:SR6_STATUS_DISABLED_LEG]) {
            aString = @"1: +1 Minor to Minor; 2: + 1 Minor to Major; 3 - Hobbled.";
        } else if ([status isEqualToString:SR6_STATUS_FATIGUED]) {
            aString = @"-2 DP/level on all tests except Dmg Resist. Move 5m, Sprint 10m.";
        } else if ([status isEqualToString:SR6_STATUS_FRIGHTENED]) {
            aString = @"-4 DP on tests directed to or defending against source of fear.";
        } else if ([status isEqualToString:SR6_STATUS_HAZED]) {
            aString = @"Cannot astrally project or manifest. Stuck if projecting.";
        } else if ([status isEqualToString:SR6_STATUS_HOBBLED]) {
            aString = @"Any movement is halved (round up).";
        } else if ([status isEqualToString:SR6_STATUS_IMMOBILIZED]) {
            aString = @"Cannot move. AR -3. -3 DP on all attacks. No Rx on Def tests.";
        } else if ([status isEqualToString:SR6_STATUS_INVISIBLE]) {
            aString = @"TH to perceive on Perception test. Cameras unaffected.";
        } else if ([status isEqualToString:SR6_STATUS_INVISIBLE_IMP]) {
            aString = @"TH to perceive on Perception test. Cameras affected.";
        } else if ([status isEqualToString:SR6_STATUS_MUTED]) {
        aString = @"Can't speak.";
        } else if ([status isEqualToString:SR6_STATUS_NAUSEATED]) {
            aString = @"Bod+Will (2) at start of rnd. Fail: no action. Succeed: Lose Minor.";
        } else if ([status isEqualToString:SR6_STATUS_NOISE]) {
            aString = @"-1 DP/level on Matrix tests. If > Dev Rtg, no access.";
        } else if ([status isEqualToString:SR6_STATUS_PANICKED]) {
            aString = @"Cannot act except to avoid the condition causing effect.";
        } else if ([status isEqualToString:SR6_STATUS_PANICKED]) {
            aString = @"Cannot act except to avoid the condition causing effect.";
        } else if ([status isEqualToString:SR6_STATUS_PETRIFIED]) {
            aString = @"Turned solid. No actions. +10 armor. All other statuses cancelled.";
        } else if ([status isEqualToString:SR6_STATUS_POISONED]) {
            aString = @"At end of each rnd, resist # DV (P or S) with Bod. -1 DV each rnd.";
        } else if ([status isEqualToString:SR6_STATUS_PRONE]) {
            aString = @"Med: +2 Def DP; Close/Near:-2. -4 DP melee/bow. +2 AR rng.";
        } else if ([status isEqualToString:SR6_STATUS_SILENT]) {
            aString = @"TH to perceive on Perception test. Microphones unaffected.";
        } else if ([status isEqualToString:SR6_STATUS_SILENT_IMP]) {
            aString = @"TH to perceive on Perception test. Microphones affected.";
        } else if ([status isEqualToString:SR6_STATUS_STILLED]) {
            aString = @"-10 to DR. Aware. No Def tests. No dmg from ongoing effects.";
        } else if ([status isEqualToString:SR6_STATUS_WET]) {
            aString = @"-6 to Damage Resistance tests against electricity and cold.";
        } else if ([status isEqualToString:SR6_STATUS_ZAPPED]) {
            aString = @"-2 to Init Score. No Sprint actions. DP -1 on all actions.";
        } else {
            aString = @"";
        }
    }
    return aString;
}

#pragma mark Menu Handling Code

// For the menu entry pass through. Probably not the best way to do this, but it works.
- (IBAction)menuClicked:(NSMenuItem *)sender {
    // Using tags.
    // 1-19 are the Actor menu
    // 20-29 are the Edit menu
    // 30-49 are the Roll Menu
    
    // We're going to need this for some of them...
    SR6Actor *selectedActor;
    //selectedActor = (SR6Actor *)[[myActorArray arrangedObjects] objectAtIndex:[myActorArray selectionIndex]];
    
    if ([[myActorArray selectedObjects] count] == 0) {
        // We are here at boot, so we just leave the SR6Actor object alone.
    } else {
        selectedActor = (SR6Actor *)[[myActorArray selectedObjects] firstObject];
    }
    
    switch ([sender tag]) {
        case 1: // Select previous.
            [myActorArray activatePrevActor:sender];
            break;
        case 2:// Select current - only if there is a selected actor
            [myActorArray setSelectedAsActiveActor:sender];
            break;
        case 3:// Select next
            [myActorArray activateNextActor:sender];
            break;
        case 4:// Select active  - only if there is a selected actor
            [myActorArray selectActiveActor];
            break;
        case 5:// Add new - always active
            [myActorArray add:sender];
            break;
        case 6: // Remove - use the build int function.
            [myActorArray remove:sender];
            break;
        case 7: // Set mode physical. - only if there is a selected actor
            selectedActor.currentMode = kModePhysical;
            // Also need to set the check marks.
            sender.state = NSControlStateValueOn;
            // Need to disable the other check marks.
            [[[[sender parentItem] submenu] itemWithTag:8] setState:NSControlStateValueOff];
            [[[[sender parentItem] submenu] itemWithTag:9] setState:NSControlStateValueOff];
            [[[[sender parentItem] submenu] itemWithTag:10] setState:NSControlStateValueOff];
            break;
        case 8: // Set mode matrix - only if there is a selected actor
            selectedActor.currentMode = kModeMatrixCold;
            sender.state = NSControlStateValueOn;
            [[[[sender parentItem] submenu] itemWithTag:7] setState:NSControlStateValueOff];
            [[[[sender parentItem] submenu] itemWithTag:9] setState:NSControlStateValueOff];
            [[[[sender parentItem] submenu] itemWithTag:10] setState:NSControlStateValueOff];
            break;
        case 9: // Set mode matrix - only if there is a selected actor
            selectedActor.currentMode = kModeMatrixHot;
            sender.state = NSControlStateValueOn;
            [[[[sender parentItem] submenu] itemWithTag:7] setState:NSControlStateValueOff];
            [[[[sender parentItem] submenu] itemWithTag:8] setState:NSControlStateValueOff];
            [[[[sender parentItem] submenu] itemWithTag:10] setState:NSControlStateValueOff];
            break;
        case 10: // Set mode astral - only if there is a selected actor
            selectedActor.currentMode = kModeAstral;
            sender.state = NSControlStateValueOn;
            [[[[sender parentItem] submenu] itemWithTag:7] setState:NSControlStateValueOff];
            [[[[sender parentItem] submenu] itemWithTag:8] setState:NSControlStateValueOff];
            [[[[sender parentItem] submenu] itemWithTag:9] setState:NSControlStateValueOff];
            break;
        case 11: // Clear statuses - only if there is a selected actor
            [selectedActor clearStatuses];
            break;
        case 12: // Rseet damages - only if there  is a selected actor.
            selectedActor.physicalCondition = 0;
            selectedActor.stunCondition = 0;
            selectedActor.matrixCondition = 0;
            break;
        case 13: // Add Edge to selected - only if there is a selected actor, and edge is < 7;
            if (selectedActor.currentEdge <7) selectedActor.currentEdge ++;
            break;
        case 14: // Remove Edge from selected - only if there is a selected actor, and edge is > 0
            if (selectedActor.currentEdge >0) selectedActor.currentEdge --;
            break;
        case 15: // Select all in detail view.
            // Also pop that view to the front of the tab bit.
            [tabView selectTabViewItem:tabInfo];
            [textViewDetails selectAll: nil];
            break;
        case 16:
            [myActorArray rollInits:sender];
            break;
        case 17:
            [myActorArray rollPerceptions:sender];
            break;
        case 18:
            [myActorArray rollStealths:sender];
            break;
        case 19:
            [myActorArray rollSurprises:sender];
            break;
        case 20: // Cut
            [myActorArray cut:sender];
            break;
        case 21: // Copy
            [myActorArray copy:sender];
            break;
        case 22: // Paste - always active
            [myActorArray paste:sender];
            break;
        case 23:// Delete - same as remove
            [myActorArray remove:sender];
            break;
        case 24:
            [self pasteAndMatchStyle:sender];
            break;
        case 31: // Roll dice - Always active.
            [self rollDice:sender];
            break;
        case 32: // Add Die - only if the die pool is less than thirty.
            if ([dicePool integerValue] <30) [self setDicePool: [NSNumber numberWithInteger:([dicePool integerValue] + 1)]];
            break;
        case 33: // Remove Die - only if the die pool is greater than 1.
            if ([dicePool integerValue] >1) [self setDicePool: [NSNumber numberWithInteger:([dicePool integerValue] - 1)]];
            break;
        case 34:// Add explode 6s - toggle the on-screen button.
            if (sender.state == NSControlStateValueOn) {
                buttonExplodeSixes.state = NSControlStateValueOff;
                sender.state = NSControlStateValueOff;
            } else {
                buttonExplodeSixes.state = NSControlStateValueOn;
                sender.state = NSControlStateValueOn;
            }
            break;
        case 35:// Add 2's glitch - always good
            if (sender.state == NSControlStateValueOn) {
                buttonTwosGlitch.state = NSControlStateValueOff;
                sender.state = NSControlStateValueOff;
            } else {
                buttonTwosGlitch.state = NSControlStateValueOn;
                sender.state = NSControlStateValueOn;
            }
            break;
        case 36:// Add wild die - always good
            if (sender.state == NSControlStateValueOn) {
                buttonWildDie.state = NSControlStateValueOff;
                sender.state = NSControlStateValueOff;
            } else {
                buttonWildDie.state = NSControlStateValueOn;
                sender.state = NSControlStateValueOn;
            }
            break;
        case 37: // Reroll 1 hit - user the dieroller interface
            [self reRollOneHit:sender];
            break;
        case 38: // Reroll 1 glitch - user the dieroller interface
            [self reRollOneGlitch:sender];
            break;
        case 39: // Reroll 1 miss - user the dieroller interface
            [self reRollOneMiss:sender];
            break;
        case 40: // Reroll 1 hit - user the dieroller interface
            [self addOnetoGlitch:sender];
            break;
        case 41: // Reroll 1 hit - user the dieroller interface
            [self addOnetoMiss:sender];
            break;
        case 42: // Reroll failures - user the dieroller interface
            [self reRollFailures:sender];
            break;
        case 50: // Roll & sum
            [self rollSum:sender];
        
        default:
            break;
    }
}

-(BOOL)validateMenuItem:(NSMenuItem *)menuItem {
    // Using tags.
    // 1-19 are the Actor menu
    // 20-29 are the Edit menu
    // 30-49 are the Roll Menu
    // We're going to need this for some of them...
    // Note that this also controls the menu items in the Actor Table and Current Scores Mode, but
    // we use the same tags, so it should work fine.
    SR6Actor *selectedActor;
    if ([[myActorArray selectedObjects] count] == 0) {
        // We are here at boot, so we just leave the SR6Actor object alone.
    } else {
        selectedActor = (SR6Actor *)[[myActorArray selectedObjects] firstObject];
    }
    
    switch ([menuItem tag]) {
        case 1: // Select previous.
            return ([myActorArray canMakePrevActive]);
            break;
        case 2:// Select current - only if there is a selected actor
            return ([myActorArray actorSelected]);
            break;
        case 3:// Select next
            return ([myActorArray canMakeNextActive]);
            break;
        case 4:// Select active  - only if there is a selected actor
            return ([myActorArray actorSelected]);
            break;
        case 5:// Add new - always active
            return TRUE;
            break;
        case 6: // Remove - use the build int function.
            return ([myActorArray canRemove]);
            break;
        case 7: // Set mode physical. - only if there is a selected actor and it isn't matrix only.
            // Since we are here, we should make sure that the checkmarks are correct.
            if (selectedActor.currentMode == kModePhysical) {
                menuItem.state = NSControlStateValueOn;
            } else {
                menuItem.state = NSControlStateValueOff;
            }
            return ([myActorArray actorSelected] && !selectedActor.isMatrixModeOnly);
            break;
        case 8: // Set mode matrix cold - only if there is a selected actor, and it isn't matrix mode only (auto hot)
            if (selectedActor.currentMode == kModeMatrixCold) {
                menuItem.state = NSControlStateValueOn;
            } else {
                menuItem.state = NSControlStateValueOff;
            }
            return ([myActorArray actorSelected] && !selectedActor.isMatrixModeOnly && [selectedActor showMatrix]);
            break;
        case 9: // Set mode matrix - only if there is a selected actor
            if (selectedActor.currentMode == kModeMatrixHot) {
                menuItem.state = NSControlStateValueOn;
            } else {
                menuItem.state = NSControlStateValueOff;
            }
            return ([myActorArray actorSelected] && [selectedActor showMatrix]);
            break;
        case 10: // Set mode astral - only if there is a selected actor and it isn't matrix only.
            if (selectedActor.currentMode == kModeAstral) {
                menuItem.state = NSControlStateValueOn;
            } else {
                menuItem.state = NSControlStateValueOff;
            }
            return ([myActorArray actorSelected] && !selectedActor.isMatrixModeOnly  && [selectedActor showMagic]);
            break;
        case 11: // Clear statuses - only if there is a selected actor
            return ([myActorArray actorSelected]);
            break;
        case 12: // Rseet damages - only if there  is a selected actor.
            return ([myActorArray actorSelected]);
            break;
        case 13: // Add Edge to selected - only if there is a selected actor, and edge is < 7;
            return (selectedActor.currentEdge < 7 && [myActorArray actorSelected]);
            break;
        case 14: // Remove Edge from selected - only if there is a selected actor, and edge is > 0
            return (selectedActor.currentEdge > 0 && [myActorArray actorSelected]);
            break;
        case 15: // All of the various text options.
            // Valid as long as there is an actor selected.
            return ([myActorArray actorSelected]);
            break;
        case 16:
        case 17:
        case 18:
        case 19:
            // For the various roll for all commands, enable them if there is anything in the actor array.
            return ([myActorArray canRemove]);
            break;
        case 20:
        case 21:// Cut and copy - only if there is a selected actor.
            return ([myActorArray actorSelected]);
            break;
        case 22:// Paste - always active
            return TRUE;
            break;
        case 23:// Delete - same as remove
            return ([myActorArray canRemove]);
            break;
        case 24: // Paste and match style. Only if we have an actor selected and textViewDetails is first responder.
            return ([myActorArray actorSelected] && ([[textViewDetails window] firstResponder] == textViewDetails));
            break;
        case 31: // Roll dice - Always active.
            return TRUE;
            break;
        case 32: // Add Die - only if the die pool is less than thirty.
            return ([[self dicePool] intValue] < 30);
            break;
        case 33: // Remove Die - only if the die pool is greater than 1.
            return ([[self dicePool] intValue] > 1);
            break;
        case 34:// Add explode 6s - always good
            // Since we're here, we should set the state to match the buttons
            menuItem.state = buttonExplodeSixes.state;
            return TRUE;
            break;
        case 35:// Add 2's glitch - always good
            // Since we're here, we should set the state to match the buttons
            menuItem.state = buttonTwosGlitch.state;
            return TRUE;
            break;
        case 36:// Add wild die - always good
            // Since we're here, we should set the state to match the buttons
            menuItem.state = buttonWildDie.state;
            return TRUE;
            break;
        case 37: // Reroll 1 hit - user the dieroller interface
            return ([dieRoller canReRollHit]);
            break;
        case 38: // Reroll 1 hit - user the dieroller interface
            return ([dieRoller canReRollGlitch]);
            break;
        case 39: // Reroll 1 hit - user the dieroller interface
            return ([dieRoller canReRollMiss]);
            break;
        case 40: // Reroll 1 hit - user the dieroller interface
            return ([dieRoller canAddOneToGlitch]);
            break;
        case 41: // Reroll 1 hit - user the dieroller interface
            return ([dieRoller canAddOneToMiss]);
            break;
        case 42: // Reroll failures - user the dieroller interface
            return ([dieRoller canReRollFailures]);
            break;
        case 50: // Roll sum
            return TRUE;
            break;
        case 60: // Show fonts.
            return TRUE;
            break;
        
        default:
            return TRUE;
            break;
    }
}

-(void)menuWillOpen:(NSMenu *) menu {
    // Set the enabled status of the menu items - this is for the list boxes in the table view and the current scores section.
    // The enable logic should match the logic in the main menu validation.
    SR6Actor *currentActor = (SR6Actor *)[[myActorArray selectedObjects] firstObject];
    //BOOL tmp = [currentActor isMatrixModeOnly];
    
    NSMenuItem * item = [menu itemAtIndex:kModePhysical];
    item.enabled = ![currentActor isMatrixModeOnly];
    item = [menu itemAtIndex:kModeMatrixCold];
    item.enabled = ![currentActor isMatrixModeOnly] && [currentActor showMatrix] ;
    item = [menu itemAtIndex:kModeMatrixHot];
    item.enabled = [currentActor showMatrix];
    item = [menu itemAtIndex:kModeAstral];
    item.enabled = ![currentActor isMatrixModeOnly];
}

#pragma mark Copy/Paste and UI code.
// THis passes through to the actor array. Needed for the menu stuff.

-(IBAction)copy:(id)sender {
    [myActorArray copy:sender];
}

-(IBAction)cut:(id)sender {
    [myActorArray cut:sender];
}

-(IBAction)pasteAndMatchStyle:(id)sender {
    // This does the standard paste and match style on the details text view.
    // This should be really easy - just append the string and see what happens.
    
    // Note: Only do this if the textViewDetaisl is the first responder.
    if ([[textViewDetails window] firstResponder] == textViewDetails) {
        NSPasteboard *myPb = [NSPasteboard generalPasteboard];
        
        NSArray *types = [myPb types];
        
        if ([types containsObject:NSPasteboardTypeString]) {
            
            // Pick the one that is correct.
            NSString *pasteString = [myPb stringForType:NSPasteboardTypeString];
            NSMutableAttributedString *toPaste = [[NSMutableAttributedString alloc] initWithString:pasteString];
            
            NSDictionary *sourceAttrs = [textViewDetails typingAttributes];
            [toPaste addAttributes:sourceAttrs range:NSMakeRange(0,toPaste.length)];
            
            // Use the insert text option to use the undo manager.
            [textViewDetails insertText:toPaste replacementRange:textViewDetails.selectedRange];
            // That should be it.
        }
    }
}

-(IBAction)paste:(id)sender{
    [myActorArray paste:sender];
}

#pragma mark popover control stuff

- (IBAction)poRollSkillClicked:(id)sender {
    // Do the roll.
    SR6Actor *currentActor = (SR6Actor *)[[myActorArray arrangedObjects] objectAtIndex:[myActorArray selectionIndex]];
    NSInteger iPool;
    NSString *desc;
    int iSpec;
    if (rbNoSpec.state == NSControlStateValueOn) {
        iSpec = 0;
    } else if (rbSpec.state == NSControlStateValueOn) {
        iSpec = 1;
    } else if (rbExp.state == NSControlStateValueOn) {
        iSpec = 2;
    } else {
        // Shouldn't be able to get here, but just in case.
        iSpec = 0;
    }

    // Get the pool from the
    iPool = [currentActor getSkillTestPool:poSkill attribute:(puAttr.indexOfSelectedItem - 1) specialization:iSpec
                       withDamageModifiers:(cbDmgMods.state == NSControlStateValueOn)  withMatrixDamageModifiers:(cbMatrixMods.state == NSControlStateValueOn)
                       withStatusModifiers:(cbStatusMods.state == NSControlStateValueOn)];
    desc =[currentActor getSkillTestDescription:poSkill attribute:(puAttr.indexOfSelectedItem - 1) specialization:iSpec
                            withDamageModifiers:(cbDmgMods.state == NSControlStateValueOn) withMatrixDamageModifiers:(cbMatrixMods.state == NSControlStateValueOn)
                            withStatusModifiers:(cbStatusMods.state == NSControlStateValueOn) rollName: nil];
    
    // To avoid errors.
    if (iPool < 1) iPool = 1;
    
    self.dicePool = [NSNumber numberWithInteger: iPool];
    [self rollDice:sender rollDesc:desc];
    
    // Close the popover.
    [poRollSkillOptions close];
}

- (IBAction)poRollAttrClicked:(id)sender {
    // Do the roll.
    SR6Actor *currentActor = (SR6Actor *)[[myActorArray arrangedObjects] objectAtIndex:[myActorArray selectionIndex]];
    NSInteger iPool;
    NSString *desc;
   
    // Bail if no attributes selected.
    if (puFirstAttr.indexOfSelectedItem == 0 && puSecondAttr.indexOfSelectedItem) {
        [poRollAttrOptions close];
    }
    // Get the pool from the
    iPool = [currentActor getAttributeTestPool:(puFirstAttr.indexOfSelectedItem -1) secondAttribute:(puSecondAttr.indexOfSelectedItem - 1) withDamageModifiers:(cbDmgModsAttr.state == NSControlStateValueOn) withMatrixDamageModifiers:(cbMatrixModsAttr.state == NSControlStateValueOn) withStatusModifiers:(cbStatusModsAttr.state == NSControlStateValueOn)];
    desc = [currentActor getAttributeTestDescription:(puFirstAttr.indexOfSelectedItem -1) secondAttribute:(puSecondAttr.indexOfSelectedItem - 1) withDamageModifiers:(cbDmgModsAttr.state == NSControlStateValueOn) withMatrixDamageModifiers:(cbMatrixModsAttr.state == NSControlStateValueOn) withStatusModifiers:(cbStatusModsAttr.state == NSControlStateValueOn) rollName: nil];
    
    // To avoid errors.
    if (iPool < 1) iPool = 1;
    
    self.dicePool = [NSNumber numberWithInteger: iPool];
    [self rollDice:sender rollDesc:desc];
    
    // Close the popover.
    [poRollAttrOptions close];
}

- (IBAction)radioSpecClicked:(id)sender {
    // This doesn't actually do anything, but is here to link the radio buttons into a single group.
}

-(IBAction)showSkillPopover:(id)sender {
    // Get the default attribute and values for the skill.
    SR6Actor *currentActor = (SR6Actor *)[[myActorArray arrangedObjects] objectAtIndex:[myActorArray selectionIndex]];
    NSInteger attributeIndex;
    NSInteger skillIndex;
    NSString *desc;
    NSInteger pool;
    NSRect bounds;
    NSSegmentedControl *scTmp = (NSSegmentedControl *)sender;
    
    // We get the index of the skill from the Identifier.
    skillIndex = [[scTmp identifier] integerValue];
    
    // Now, get the default value for the attribute to set the initial attribute index.
    attributeIndex = [currentActor getDefaultAttributeForSkill:skillIndex];
    
    BOOL inMatrix = (currentActor.currentMode == 1 || skillIndex == SR6_SKILL_CRACKING || skillIndex == SR6_SKILL_ELECTRONICS || skillIndex == SR6_SKILL_MATRIX_PERCEPTION);
    
    if ([sender selectedSegment] == 0) {
        // Get the pool from the
        pool = [currentActor getSkillTestPool:skillIndex attribute:attributeIndex specialization:NO withDamageModifiers:YES withMatrixDamageModifiers:inMatrix withStatusModifiers:YES];
        desc =[currentActor getSkillTestDescription:skillIndex attribute:attributeIndex specialization:NO withDamageModifiers:YES withMatrixDamageModifiers:inMatrix withStatusModifiers:YES rollName:nil];
       
        // To avoid errors.
        if (pool < 1) pool = 1;
       
        self.dicePool = [NSNumber numberWithInteger:pool];
        [self rollDice:sender rollDesc:desc];
    } else {
        // Save the skill
        poSkill = skillIndex;
        
        // Show the popover.
        // First, configure it a bit.
        [puAttr selectItemAtIndex: attributeIndex +1]; // It's one lower because the "none" option goes at the beginning at -1.
        
        // And set these trings for those controlls.
        cbDmgMods.title = [NSString stringWithFormat:@"Phys Dmg (%d)",[currentActor.damageModifier intValue]];
        cbMatrixMods.title = [NSString stringWithFormat:@"Matrix Dmg (%d)",[currentActor.matrixDamageModifier intValue]];
        cbStatusMods.title = [NSString stringWithFormat:@"Status Mods (%d)",[currentActor.statusPoolModifier intValue]];
        
        // Get the bounded rectangle for the segment.
        bounds = scTmp.bounds; // This is for the whole segment.
        
        bounds.origin.x = bounds.origin.x + [scTmp widthForSegment:0];
        bounds.size.width = bounds.size.width - [scTmp widthForSegment:0];
        
        [poRollSkillOptions showRelativeToRect:bounds ofView:sender preferredEdge:NSMinYEdge];
    }
}

-(IBAction)makeAttack:(id)sender {
    // This is for rolling an attack.
    // Like the regular skill roller, but we use whatever the
    // default skill is for that weapon.
    SR6Actor *currentActor = (SR6Actor *)[[myActorArray arrangedObjects] objectAtIndex:[myActorArray selectionIndex]];
    SR6ActorWeapon *myWeapon = [[weaponsArray selectedObjects] firstObject];
    NSInteger attributeIndex;
    NSInteger skillIndex;
    NSString *desc;
    NSInteger pool;
    
    // We get the index of the skill from the Identifier.
    skillIndex = myWeapon.weapon.skill;
    
    // Now, get the default value for the attribute to set the initial attribute index.
    attributeIndex = [currentActor getDefaultAttributeForSkill:skillIndex];
        
    // Get the pool from the
    pool = [currentActor getSkillTestPool:skillIndex attribute:attributeIndex specialization:NO withDamageModifiers:YES withMatrixDamageModifiers:NO withStatusModifiers:YES];
    
    // Add the bonus smartlink die if appropriate.
    if (myWeapon.smartLink && myWeapon.wirelessMode) {
        pool ++;
    }
    
    desc = [currentActor getSkillTestDescription:skillIndex attribute:attributeIndex specialization:NO withDamageModifiers:YES withMatrixDamageModifiers:NO withStatusModifiers:YES rollName:@"Attack"];
   
    // To avoid errors.
    if (pool < 1) pool = 1;
   
    self.dicePool = [NSNumber numberWithInteger:pool];
    [self rollDice:sender rollDesc:desc];
    
    // And we need to reduce the ammo count.
    [myWeapon fireWeapon];
}

-(IBAction)showAttrPopover:(id)sender {
    // Get the default attribute and values for the skill.
    SR6Actor *currentActor = (SR6Actor *)[[myActorArray arrangedObjects] objectAtIndex:[myActorArray selectionIndex]];
    NSInteger firstAttrIndex;
    NSInteger secondAttrIndex;
    
    // Set some default values.
    if (currentActor.isVehicle) {
        firstAttrIndex = SR6_ATTR_PILOT; // Default to Pilot.
        secondAttrIndex = SR6_ATTR_NULL; // Default to None.
    } else if (currentActor.showLevel){
        firstAttrIndex = SR6_ATTR_RATING; // Default to Pilot.
        secondAttrIndex = SR6_ATTR_NULL; // Default to None.
    }else {
        firstAttrIndex = SR6_ATTR_BODY; // Default to body.
        secondAttrIndex = SR6_ATTR_NULL; // Default to None.
    }
    
    // And set thes trings for those controlls.
    cbDmgModsAttr.title = [NSString stringWithFormat:@"Phys Dmg (%d)",[currentActor.damageModifier intValue]];
    cbMatrixModsAttr.title = [NSString stringWithFormat:@"Matrix Dmg (%d)",[currentActor.matrixDamageModifier intValue]];
    cbStatusModsAttr.title = [NSString stringWithFormat:@"Status Mods (%d)",[currentActor.statusPoolModifier intValue]];
        
    [poRollAttrOptions showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMinYEdge];
}

#pragma mark Object Tally Stuff

- (IBAction)adeptPowerLevelChange:(id _Nullable)sender {
    SR6Actor *myActor = (SR6Actor *)[[myActorArray selectedObjects] firstObject];
    lblTotalPowerPoints.stringValue = [myActor totalPowerPointsString];
}

- (IBAction)augRatingChanged:(id _Nullable)sender {
    SR6Actor *myActor = (SR6Actor *)[[myActorArray selectedObjects] firstObject];
    lblTotalEssence.stringValue = [myActor totalEssenceString];
}

- (IBAction)augGradeChanged:(id _Nullable)sender {
    SR6Actor *myActor = (SR6Actor *)[[myActorArray selectedObjects] firstObject];
    lblTotalEssence.stringValue = [myActor totalEssenceString];
}

-(IBAction) loadedProgramChanged:(id)sender {
    SR6Actor *myActor = (SR6Actor *)[[myActorArray selectedObjects] firstObject];
    lblProgramsRunning.stringValue = [myActor numberProgramsRunningString];
}


-(IBAction) sustainedComplexFormsChanged:(id)sender {
    SR6Actor *myActor = (SR6Actor *)[[myActorArray selectedObjects] firstObject];
    lblCFsSustained.stringValue = [myActor numberCFsSustained];
}

- (IBAction)qualitiesChanged:(id _Nullable)sender {
    SR6Actor *myActor = (SR6Actor *)[[myActorArray selectedObjects] firstObject];
    lblTotalKarma.stringValue = [myActor totalQualityKarmaString];
}

-(IBAction) sustainedSpellsChanged:(id)sender {
    SR6Actor *myActor = (SR6Actor *)[[myActorArray selectedObjects] firstObject];
    lblTotalSpellsSustained.stringValue = [myActor numberSustainedString];
}

#pragma mark Popover Showers

-(IBAction)showAdeptPowerPopover:(id)sender {
    // Set the sort decsriptors.
    NSArray *sorters =[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES], nil];
    adeptPowersSourceArray.sortDescriptors = sorters;
    [adeptPowerPickerTableView deselectAll:nil];
    [poAddAdeptPower showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMinYEdge];
}

-(IBAction)showAugPopover:(id)sender {
    // Set the sort decsriptors.
    NSArray *sorters =[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"category" ascending:YES],[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES], nil];
    augsSourceArray.sortDescriptors = sorters;
    [augPickerTableView deselectAll:nil];
    [poAddAug showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMinYEdge];
}

-(IBAction)showComplexFormPopover:(id)sender {
    // Set the sort decsriptors.
    NSArray *sorters =[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES], nil];
    complexFormsSourceArray.sortDescriptors = sorters;
    [complexFormPickerTableView deselectAll:nil];
    [poAddComplexForm showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMinYEdge];
}

-(IBAction)showEchoPopover:(id)sender {
    // Set the sort decsriptors.
    NSArray *sorters =[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES], nil];
    echoesSourceArray.sortDescriptors = sorters;
    [echoPickerTableView deselectAll:nil];
    [poAddEcho showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMinYEdge];
}

-(IBAction)showMetamagicPopover:(id)sender {
    // Set the sort decsriptors.
    NSArray *sorters =[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES], nil];
    metamagicsSourceArray.sortDescriptors = sorters;
    [metamagicPickerTableView deselectAll:nil];
    [poAddMetamagic showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMinYEdge];
}

-(IBAction)showPowerPopover:(id)sender {
    // Set the sort decsriptors.
    NSArray *sorters =[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"category" ascending:YES],[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES], nil];
    powersSourceArray.sortDescriptors = sorters;
    [powerPickerTableView deselectAll:nil];
    [poAddPower showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMinYEdge];
}

-(IBAction)showProgramPopover:(id)sender {
    // Set the sort decsriptors.
    NSArray *sorters =[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"category" ascending:YES],[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES], nil];
    programsSourceArray.sortDescriptors = sorters;
    [programPickerTableView deselectAll:nil];
    [poAddProgram showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMinYEdge];
}

-(IBAction)showQualityPopover:(id)sender {
    // Set the sort decsriptors.
    NSArray *sorters =[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"negativeShortString" ascending:NO],[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES], nil];
    qualitiesSourceArray.sortDescriptors = sorters;
    [qualitiesSourceArray prepareContent];
    [qualityPickerTableView reloadData];
    [qualityPickerTableView deselectAll:nil];
    [poAddQuality showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMinYEdge];
}

-(IBAction)showSpellPopover:(id)sender {
    // Set the sort decsriptors.
    NSArray *sorters =[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"category" ascending:YES],[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES], nil];
    spellsSourceArray.sortDescriptors = sorters;
    [spellPickerTableView deselectAll:nil];
    [poAddSpell showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMinYEdge];
}

-(IBAction)showWeaponPopover:(id)sender {
    // Set the sort decsriptors.
    NSArray *sorters =[NSArray arrayWithObjects:[NSSortDescriptor sortDescriptorWithKey:@"category" ascending:YES],[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES], nil];
    weaponsSourceArray.sortDescriptors = sorters;
    [weaponPickerTableView deselectAll:nil];
    [poAddWeapon showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMinYEdge];
}

#pragma mark Popover Add Clicked

-(IBAction)poAdeptPowerAddClicked:(id)sender {
    // Get the UUIDs of the selections.
    NSIndexSet *selections = adeptPowerPickerTableView.selectedRowIndexes;
    
    if ([selections count] == 0) return;
    
    NSUInteger x;
    SR6AdeptPower *myAdeptPower;
    NSMutableArray *myArray = [NSMutableArray arrayWithCapacity:[selections count]];
    for (x = 0; x<[selections count]; x++) {
        myAdeptPower = (SR6AdeptPower *)[[adeptPowersSourceArray selectedObjects] objectAtIndex:x];
        [myArray addObject:myAdeptPower.adeptPowerUUID];
    }
    
    // Add the UUIDs of the selected spells
    SR6Actor *myActor = (SR6Actor *)[[myActorArray selectedObjects] firstObject];
    [myActor addAdeptPowersForUUIDS:(NSArray *)myArray];
    
    // Dismiss the popover.
    [poAddAdeptPower close];
    [adeptPowerTableView reloadData];
    
    // Update the total string.
    lblTotalPowerPoints.stringValue = [myActor totalPowerPointsString];
}

-(IBAction)poAugAddClicked:(id)sender {
    // Get the UUIDs of the selections.
    NSIndexSet *selections = augPickerTableView.selectedRowIndexes;
    
    if ([selections count] == 0) return;
    
    NSUInteger x;
    SR6Aug *myAug;
    NSMutableArray *myArray = [NSMutableArray arrayWithCapacity:[selections count]];
    for (x = 0; x<[selections count]; x++) {
        myAug = (SR6Aug *)[[augsSourceArray selectedObjects] objectAtIndex:x];
        [myArray addObject:myAug.augUUID];
    }
    
    // Add the UUIDs of the selected spells
    SR6Actor *myActor = (SR6Actor *)[[myActorArray selectedObjects] firstObject];
    [myActor addAugsForUUIDS:(NSArray *)myArray];
    
    // Dismiss the popover.
    [poAddAug close];
    [augTableView reloadData];
    
    // Update the total string.
    lblTotalEssence.stringValue = [myActor totalEssenceString];
}

-(IBAction)poComplexFormAddClicked:(id)sender {
    // Get the UUIDs of the selections.
    NSIndexSet *selections = complexFormPickerTableView.selectedRowIndexes;
    
    if ([selections count] == 0) return;
    
    NSUInteger x;
    SR6ComplexForm *myComplexForm;
    NSMutableArray *myArray = [NSMutableArray arrayWithCapacity:[selections count]];
    for (x = 0; x<[selections count]; x++) {
        myComplexForm = (SR6ComplexForm *)[[complexFormsSourceArray selectedObjects] objectAtIndex:x];
        [myArray addObject:myComplexForm.complexFormUUID];
    }
    
    // Add the UUIDs of the selected spells
    SR6Actor *myActor = (SR6Actor *)[[myActorArray selectedObjects] firstObject];
    [myActor addComplexFormsForUUIDS:(NSArray *)myArray];
    
    // Dismiss the popover.
    [poAddComplexForm close];
    [complexFormTableView reloadData];
}

-(IBAction)poEchoAddClicked:(id)sender {
    // Get the UUIDs of the selections.
    NSIndexSet *selections = echoPickerTableView.selectedRowIndexes;
    
    if ([selections count] == 0) return;
    
    NSUInteger x;
    SR6Echo *myEcho;
    NSMutableArray *myArray = [NSMutableArray arrayWithCapacity:[selections count]];
    for (x = 0; x<[selections count]; x++) {
        myEcho = (SR6Echo *)[[echoesSourceArray selectedObjects] objectAtIndex:x];
        [myArray addObject:myEcho.echoUUID];
    }
    
    // Add the UUIDs of the selected spells
    SR6Actor *myActor = (SR6Actor *)[[myActorArray selectedObjects] firstObject];
    [myActor addEchoesForUUIDS:(NSArray *)myArray];
    
    // Dismiss the popover.
    [poAddEcho close];
    [echoTableView reloadData];
}

-(IBAction)poMetamagicAddClicked:(id)sender {
    // Get the UUIDs of the selections.
    NSIndexSet *selections = metamagicPickerTableView.selectedRowIndexes;
    
    if ([selections count] == 0) return;
    
    NSUInteger x;
    SR6Metamagic *myMetamagic;
    NSMutableArray *myArray = [NSMutableArray arrayWithCapacity:[selections count]];
    for (x = 0; x<[selections count]; x++) {
        myMetamagic = (SR6Metamagic *)[[metamagicsSourceArray selectedObjects] objectAtIndex:x];
        [myArray addObject:myMetamagic.metamagicUUID];
    }
    
    // Add the UUIDs of the selected spells
    SR6Actor *myActor = (SR6Actor *)[[myActorArray selectedObjects] firstObject];
    [myActor addMetamagicsForUUIDS:(NSArray *)myArray];
    
    // Dismiss the popover.
    [poAddMetamagic close];
    [metamagicTableView reloadData];
}

-(IBAction)poPowerAddClicked:(id)sender {
    // Get the UUIDs of the selections.
    NSIndexSet *selections = powerPickerTableView.selectedRowIndexes;
    
    if ([selections count] == 0) return;
    
    NSUInteger x;
    SR6Power *myPower;
    NSMutableArray *myArray = [NSMutableArray arrayWithCapacity:[selections count]];
    for (x = 0; x<[selections count]; x++) {
        myPower = (SR6Power *)[[powersSourceArray selectedObjects] objectAtIndex:x];
        [myArray addObject:myPower.powerUUID];
    }
    
    // Add the UUIDs of the selected spells
    SR6Actor *myActor = (SR6Actor *)[[myActorArray selectedObjects] firstObject];
    [myActor addPowersForUUIDS:(NSArray *)myArray];
    
    // Dismiss the popover.
    [poAddPower close];
    [powerTableView reloadData];
}

-(IBAction)poProgramAddClicked:(id)sender {
    // Get the UUIDs of the selections.
    NSIndexSet *selections = programPickerTableView.selectedRowIndexes;
    
    if ([selections count] == 0) return;
    
    NSUInteger x;
    SR6Program *myProgram;
    NSMutableArray *myArray = [NSMutableArray arrayWithCapacity:[selections count]];
    for (x = 0; x<[selections count]; x++) {
        myProgram = (SR6Program *)[[programsSourceArray selectedObjects] objectAtIndex:x];
        [myArray addObject:myProgram.programUUID];
    }
    
    // Add the UUIDs of the selected spells
    SR6Actor *myActor = (SR6Actor *)[[myActorArray selectedObjects] firstObject];
    [myActor addProgramsForUUIDS:(NSArray *)myArray];
    
    // Dismiss the popover.
    [poAddProgram close];
    [programTableView reloadData];
}

-(IBAction)poQualityAddClicked:(id)sender {
    // Get the UUIDs of the selections.
    NSIndexSet *selections = qualityPickerTableView.selectedRowIndexes;
    
    if ([selections count] == 0) return;
    
    NSUInteger x;
    SR6Quality *myQuality;
    NSMutableArray *myArray = [NSMutableArray arrayWithCapacity:[selections count]];
    for (x = 0; x<[selections count]; x++) {
        myQuality = (SR6Quality *)[[qualitiesSourceArray selectedObjects] objectAtIndex:x];
        [myArray addObject:myQuality.qualityUUID];
    }
    
    // Add the UUIDs of the selected spells
    SR6Actor *myActor = (SR6Actor *)[[myActorArray selectedObjects] firstObject];
    [myActor addQualitiesForUUIDS:(NSArray *)myArray];
    
    // Dismiss the popover.
    [poAddQuality close];
    [qualityTableView reloadData];
    [self qualitiesChanged:sender];
}

-(IBAction)poSpellAddClicked:(id)sender {
    // Get the UUIDs of the selections.
    NSIndexSet *selections = spellPickerTableView.selectedRowIndexes;
    
    if ([selections count] == 0) return;
    
    NSUInteger x;
    SR6Spell *mySpell;
    NSMutableArray *myArray = [NSMutableArray arrayWithCapacity:[selections count]];
    for (x = 0; x<[selections count]; x++) {
        mySpell = (SR6Spell *)[[spellsSourceArray selectedObjects] objectAtIndex:x];
        [myArray addObject:mySpell.spellUUID];
    }
    
    // Add the UUIDs of the selected spells
    SR6Actor *myActor = (SR6Actor *)[[myActorArray selectedObjects] firstObject];
    [myActor addSpellsForUUIDS:(NSArray *)myArray];
    
    // Dismiss the popover.
    [poAddSpell close];
    [spellTableView reloadData];
}

-(IBAction)poWeaponAddClicked:(id)sender {
    // Get the UUIDs of the selections.
    NSIndexSet *selections = weaponPickerTableView.selectedRowIndexes;
    
    if ([selections count] == 0) return;
    
    NSUInteger x;
    SR6Weapon *myWeapon;
    NSMutableArray *myArray = [NSMutableArray arrayWithCapacity:[selections count]];
    for (x = 0; x<[selections count]; x++) {
        myWeapon = (SR6Weapon *)[[weaponsSourceArray selectedObjects] objectAtIndex:x];
        [myArray addObject:myWeapon.weaponUUID];
    }
    
    // Add the UUIDs of the selected spells
    SR6Actor *myActor = (SR6Actor *)[[myActorArray selectedObjects] firstObject];
    [myActor addWeaponsForUUIDS:(NSArray *)myArray];
    
    // Dismiss the popover.
    [poAddWeapon close];
    [weaponTableView reloadData];
}


#pragma mark Object Removers

-(IBAction)removeAdeptPower:(id)sender {
    // Remove the selected spell.
    if ([adeptPowerTableView selectedRow] <0) return;
    SR6Actor *myActor = (SR6Actor *)[[myActorArray selectedObjects] firstObject];
    SR6ActorAdeptPower *myAdeptPower = [myActor.adeptPowersArray objectAtIndex:[adeptPowerTableView selectedRow]];
    // I think this will work.
    [myActor removeAdeptPower:myAdeptPower];
    [adeptPowerTableView reloadData];
    
    // Update the total string.
    lblTotalPowerPoints.stringValue = [myActor totalPowerPointsString];
}

-(IBAction)removeAug:(id)sender {
    // Remove the selected spell.
    if ([augTableView selectedRow] <0) return;
    SR6Actor *myActor = (SR6Actor *)[[myActorArray selectedObjects] firstObject];
    SR6ActorAug *myAug = [myActor.augsArray objectAtIndex:[augTableView selectedRow]];
    // I think this will work.
    [myActor removeAug:myAug];
    [augTableView reloadData];
    [self augRatingChanged:sender];
}

-(IBAction)removeComplexForm:(id)sender {
    // Remove the selected spell.
    if ([complexFormTableView selectedRow] <0) return;
    SR6Actor *myActor = (SR6Actor *)[[myActorArray selectedObjects] firstObject];
    SR6ActorComplexForm *myComplexForm = [myActor.complexFormsArray objectAtIndex:[complexFormTableView selectedRow]];
    // I think this will work.
    [myActor removeComplexForm:myComplexForm];
    [complexFormTableView reloadData];
    [self sustainedComplexFormsChanged:sender];
}

-(IBAction)removeEcho:(id)sender {
    // Remove the selected spell.
    if ([echoTableView selectedRow] <0) return;
    SR6Actor *myActor = (SR6Actor *)[[myActorArray selectedObjects] firstObject];
    SR6ActorEcho *myEcho = [myActor.echoesArray objectAtIndex:[echoTableView selectedRow]];
    // I think this will work.
    [myActor removeEcho:myEcho];
    [echoTableView reloadData];
}

-(IBAction)removeMetamagic:(id)sender {
    // Remove the selected spell.
    if ([metamagicTableView selectedRow] <0) return;
    SR6Actor *myActor = (SR6Actor *)[[myActorArray selectedObjects] firstObject];
    SR6ActorMetamagic *myMetamagic = [myActor.metamagicsArray objectAtIndex:[metamagicTableView selectedRow]];
    // I think this will work.
    [myActor removeMetamagic:myMetamagic];
    [metamagicTableView reloadData];
}

-(IBAction)removePower:(id)sender {
    // Remove the selected spell.
    if ([powerTableView selectedRow] <0) return;
    SR6Actor *myActor = (SR6Actor *)[[myActorArray selectedObjects] firstObject];
    SR6ActorPower *myPower = [myActor.powersArray objectAtIndex:[powerTableView selectedRow]];
    // I think this will work.
    [myActor removePower:myPower];
    [powerTableView reloadData];
}

-(IBAction)removeProgram:(id)sender {
    // Remove the selected spell.
    if ([programTableView selectedRow] <0) return;
    SR6Actor *myActor = (SR6Actor *)[[myActorArray selectedObjects] firstObject];
    SR6ActorProgram *myProgram = [myActor.programsArray objectAtIndex:[programTableView selectedRow]];
    // I think this will work.
    [myActor removeProgram:myProgram];
    [programTableView reloadData];
    [self loadedProgramChanged:sender];
}

-(IBAction)removeQuality:(id)sender {
    // Remove the selected spell.
    if ([qualityTableView selectedRow] <0) return;
    SR6Actor *myActor = (SR6Actor *)[[myActorArray selectedObjects] firstObject];
    SR6ActorQuality *myQaulity = [myActor.qualitiesArray objectAtIndex:[qualityTableView selectedRow]];
    // I think this will work.
    [myActor removeQuality:myQaulity];
    [qualityTableView reloadData];
    [self qualitiesChanged:sender];
}

-(IBAction)removeSpell:(id)sender {
    // Remove the selected spell.
    if ([spellTableView selectedRow] <0) return;
    SR6Actor *myActor = (SR6Actor *)[[myActorArray selectedObjects] firstObject];
    SR6ActorSpell *mySpell = [myActor.spellsArray objectAtIndex:[spellTableView selectedRow]];
    // I think this will work.
    [myActor removeSpell:mySpell];
    [spellTableView reloadData];
    [self sustainedSpellsChanged:sender];
}

-(IBAction)removeWeapon:(id)sender {
    // Remove the selected spell.
    if ([weaponTableView selectedRow] <0) return;
    SR6Actor *myActor = (SR6Actor *)[[myActorArray selectedObjects] firstObject];
    SR6ActorWeapon *myWeapon = [myActor.weaponsArray objectAtIndex:[weaponTableView selectedRow]];
    // I think this will work.
    [myActor removeWeapon:myWeapon];
    [weaponTableView reloadData];
}

- (IBAction)reloadWeapon:(id)sender {
    SR6ActorWeapon *myWeapon = [[weaponsArray selectedObjects] firstObject];
    [myWeapon reload];
}


- (IBAction)resetWeaponAccessories:(id)sender {
    SR6ActorWeapon *myWeapon = [[weaponsArray selectedObjects] firstObject];
    [myWeapon resetAccessories];
}

-(IBAction)addNewActor:(id)sender {
    // Call the actor array add.
    [myActorArray add:sender];
    
    // force the ttab bar to format.
    [self performSelector:@selector(cbActorTypeEdited:) withObject:sender afterDelay:0];
}


@end
