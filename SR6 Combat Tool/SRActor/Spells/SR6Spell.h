//
//  SR6Spell.h
//  DBBuilder
//
//  Created by Ed Pichon on 2020/6/27.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SR6Constants.h"

NS_ASSUME_NONNULL_BEGIN


@interface SR6Spell : NSManagedObject {
    NSString *_summary;
}

@property (readonly) NSString * summary;
@property (readonly) NSString * tableName;
@property (readonly) NSString * categoryShortString;
@property (readonly) NSString * categoryLongString;
@property (readonly) NSString * rangeShortString;
@property (readonly) NSString * rangeLongString;
@property (readonly) NSString * typeShortString;
@property (readonly) NSString * typeLongString;
@property (readonly) NSString * durationShortString;
@property (readonly) NSString * durationLongString;
@property (readonly) NSString * damageShortString;
@property (readonly) NSString * damageLongString;


@end

NS_ASSUME_NONNULL_END

#import "SR6SpellProperties.h"
