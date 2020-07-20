//
//  SR6Weapon+CoreDataClass.h
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/12.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SR6Constants.h"

NS_ASSUME_NONNULL_BEGIN


@interface SR6Weapon : NSManagedObject {
    NSString *_summary;
}

@property (readonly) NSString * summary;
@property (readonly) NSString * tableName;
@property (readonly) NSString * categoryShortString;
@property (readonly) NSString * categoryLongString;
@property (readonly) NSString * ammoShortString1;
@property (readonly) NSString * ammoShortString2;
@property (readonly) NSString * ammoLongString1;
@property (readonly) NSString * ammoLongString2;
@property (readonly) NSString * damageTypeShortString;
@property (readonly) NSString * damageTypeLongString;

@property (readonly) NSString * arString;
@property (readonly) NSString * fireModesString;
@property (readonly) NSString * damageString;

- (NSString *) arLetter:(int16_t)arCode;

@end

NS_ASSUME_NONNULL_END

#import "SR6WeaponProperties.h"
