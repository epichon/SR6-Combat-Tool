//
//  Document.m
//  DBBuilder
//
//  Created by Ed Pichon on 2020/6/27.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//

#import "Document.h"
#import "SpellArrayController.h"
#import "SR6Spell.h"

@interface Document ()

@end

@implementation Document

@synthesize spellCategories;
@synthesize powerTypes;
@synthesize durations;
@synthesize spellRanges;
@synthesize spellDamages;
@synthesize activations;
@synthesize powerCategories;
@synthesize augCategories;
@synthesize availLetters;
@synthesize programCategories;
@synthesize weaponCategories;
@synthesize weaponAmmoCategories;
@synthesize weaponDamageCategories;
@synthesize skillsList;

- (instancetype)init {
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        spellCategories = [NSArray arrayWithObjects:SR6_SPELL_CAT_DIRECT_COMBAT_LONG, SR6_SPELL_CAT_INDIRECT_COMBAT_LONG, SR6_SPELL_CAT_DETECTION_LONG,  SR6_SPELL_CAT_HEALTH_LONG, SR6_SPELL_CAT_ILLUSION_LONG, SR6_SPELL_CAT_MANIPULATION_LONG, nil];
        spellRanges = [NSArray arrayWithObjects:SR6_RANGE_SELF_LONG, SR6_RANGE_TOUCH_LONG, SR6_RANGE_LOS_LONG, SR6_RANGE_LOSA_LONG, SR6_RANGE_SPECIAL_LONG, nil];
        powerTypes = [NSArray arrayWithObjects:SR6_POWER_TYPE_PHYSICAL_LONG, SR6_POWER_TYPE_MANA_LONG, SR6_POWER_TYPE_SPECIAL_LONG, nil];
        durations = [NSArray arrayWithObjects:SR6_DURATION_ALWAYS_LONG, SR6_DURATION_INSTANT_LONG, SR6_DURATION_SUSTAINED_LONG, SR6_DURATION_PERMANENT_LONG,  SR6_DURATION_LIMITED_LONG, SR6_DURATION_SPECIAL_LONG, nil];
        spellDamages = [NSArray arrayWithObjects: SR6_SPELL_DAMAGE_NONE_LONG, SR6_SPELL_DAMAGE_STUN_LONG, SR6_SPELL_DAMAGE_PHYSICAL_LONG, SR6_SPELL_DAMAGE_STUN_SPECIAL_LONG, SR6_SPELL_DAMAGE_PHYSICAL_SPECIAL_LONG, nil];
        activations =  [NSArray arrayWithObjects: SR6_ACTIVATION_PASSIVE_LONG, SR6_ACTIVATION_MINOR_LONG, SR6_ACTIVATION_MAJOR_LONG, SR6_ACTIVATION_SPECIAL_LONG, nil];
        powerCategories = [NSArray arrayWithObjects: SR6_POWER_CAT_POWER_LONG, SR6_POWER_CAT_WEAKNESS_LONG, SR6_POWER_CAT_SPRITE_LONG, SR6_POWER_CAT_OTHER_LONG, nil];
        augCategories = [NSArray arrayWithObjects: SR6_AUG_CAT_HEADWARE_LONG, SR6_AUG_CAT_EYEWARE_LONG, SR6_AUG_CAT_EARWARE_LONG, SR6_AUG_CAT_BODYWARE_LONG, SR6_AUG_CAT_CYBERLIMB_LONG, SR6_AUG_CAT_BIOWARE_LONG, SR6_AUG_CAT_CULTURED_BIOWARE_LONG, SR6_AUG_CAT_GENEWARE_LONG, SR6_AUG_CAT_NANOWARE_LONG, SR6_AUG_CAT_OTHER_LONG, nil];
        availLetters = [NSArray arrayWithObjects:SR6_AVAIL_LEGAL_LONG, SR6_AVAIL_LICENSE_LONG, SR6_AVAIL_ILLEGAL_LONG, SR6_AVAIL_SPECIAL_LONG, nil];
        programCategories = [NSArray arrayWithObjects:SR6_PROGRAM_CAT_BASIC_LONG, SR6_PROGRAM_CAT_HACKING_LONG, SR6_PROGRAM_CAT_AUTOSOFT_LONG, SR6_PROGRAM_CAT_OTHER_LONG, nil];
        weaponCategories = [NSArray arrayWithObjects: SR6_WEAPON_CAT_BLADE_LONG, SR6_WEAPON_CAT_CLUB_LONG, SR6_WEAPON_CAT_MELEE_LONG, SR6_WEAPON_CAT_THROWN_LONG, SR6_WEAPON_CAT_TASER_LONG, SR6_WEAPON_CAT_HOLD_OUT_LONG, SR6_WEAPON_CAT_LIGHT_PISTOL_LONG, SR6_WEAPON_CAT_MACHINE_PISTOL_LONG, SR6_WEAPON_CAT_HEAVY_PISTOL_LONG, SR6_WEAPON_CAT_SMG_LONG, SR6_WEAPON_CAT_SHOTGUN_LONG, SR6_WEAPON_CAT_RIFLE_LONG, SR6_WEAPON_CAT_MACHINE_GUN_LONG, SR6_WEAPON_CAT_ASSAULT_CANNON_LONG, SR6_WEAPON_CAT_LAUNCHER_LONG, SR6_WEAPON_CAT_ROCKET_LONG, SR6_WEAPON_CAT_MISSILE_LONG, SR6_WEAPON_CAT_GRENADE_LONG, SR6_WEAPON_CAT_SPECIAL_LONG, nil];
        weaponAmmoCategories = [NSArray arrayWithObjects: SR6_AMMO_CONTAINER_BELT_LONG, SR6_AMMO_CONTAINER_BREAK_LONG, SR6_AMMO_CONTAINER_CLIP_LONG, SR6_AMMO_CONTAINER_CYLINDER_LONG, SR6_AMMO_CONTAINER_DRUM_LONG, SR6_AMMO_CONTAINER_MAGAZINE_LONG, SR6_AMMO_CONTAINER_MISSILE_LONG, SR6_AMMO_CONTAINER_MUZZLE_LONG, SR6_AMMO_CONTAINER_SPECIAL_LONG, nil];
        weaponDamageCategories = [NSArray arrayWithObjects:@"Stun", @"Physical", @"Blinded", @"Special", nil];
        skillsList = [NSArray arrayWithObjects:@"Astral",@"Athletics",@"Biotech",@"Close Combat",@"Con",@"Conjuring",@"Cracking",@"Electronics",@"Enchanting",
                      @"Engineering",@"Exotic Weapon",@"Firearms",@"Influence",@"Outdoors",@"Perception",@"Pilot",@"Sorcery",@"Stealth",@"Tasking",@"Other",nil];
    }
    return self;
}

+ (BOOL)autosavesInPlace {
    return YES;
}

- (BOOL)configurePersistentStoreCoordinatorForURL:(NSURL *)url ofType:(NSString *)fileType modelConfiguration:(NSString *)configuration storeOptions:(NSDictionary *)storeOptions error:(NSError **)error
// This is to enable migration in the data model if you add new fields.
// Taken from stack overflow by someone trying to do the same thing. Hopefully this works. Apple's documentation for this is more-or-less useless.
// https://stackoverflow.com/questions/10001026/lightweight-migration-of-a-nspersistentdocument
{
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
    
    return result;
}

- (NSString *)windowNibName {
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Document";
}

- (IBAction)adeptPowerLevelChange:(id)sender {
}
- (IBAction)sustainedComplexFormsChanged:(id)sender {
}
@end
