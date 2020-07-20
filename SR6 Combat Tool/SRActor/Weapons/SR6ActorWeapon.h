//
//  SR6ActorWeapon+CoreDataClass.h
//  DBBuilder
//
//  Created by Ed Pichon on 2020/7/13.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SR6Weapon.h"

@class SR6Actor;

NS_ASSUME_NONNULL_BEGIN

@interface SR6ActorWeapon : NSManagedObject {
    SR6Weapon * _weapon;
    NSString *_summary;
    NSArray *_ammoSources;
    NSArray *_firingModes;
    NSString *_ammoSourceString;
    NSString *_firingModeString;
}

@property (readonly) NSString *tableName;
@property (readonly) SR6Weapon *weapon;

@property (readonly) NSString *arsAdjusted;
@property (readonly) NSString *dvAdjusted;

@property (readonly) int16_t ammoMax;
@property (readonly) NSArray * ammoSources;
@property (readonly) NSArray * firingModes;

@property (readonly) BOOL showLevel;
@property (readonly) BOOL showCount;
@property (readonly) BOOL showAmmo;
@property (readonly) BOOL showFiringMode;
@property (readonly) BOOL allowSourceSelect;
@property (readonly) NSString * testName;

// Have to do a method that goes from ammoSource as a string to the index.
// Not using a transformer, as the list entry names change based on the weapon.
// We can use a transformer for the firing mode, as the list can change, but the values are
// more-or-less fixed.
@property (nullable, nonatomic, copy) NSString *ammoSourceString;

- (NSString *)damageTypeShortString:(sr6WeaponDamageType) dvType;

-(void) addObjectToDictionary: (NSMutableDictionary *) myDict index:(NSUInteger) index;
-(BOOL) loadObjectFromDictionary: (NSDictionary *)myDict index:(NSUInteger) index;

-(void) resetAccessories;
-(void) reload;
-(void) fireWeapon;

@end

NS_ASSUME_NONNULL_END

#import "SR6ActorWeaponProperties.h"
