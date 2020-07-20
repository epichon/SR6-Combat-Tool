//
//  SR6ActorSpell+CoreDataClass.h
//  DBBuilder
//
//  Created by Ed Pichon on 2020/7/04.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SR6Actor;
@class SR6Quality;

NS_ASSUME_NONNULL_BEGIN

@interface SR6ActorQuality : NSManagedObject {
    SR6Quality *_quality;
}

@property (readonly) NSString *tableName;
@property (readonly) SR6Quality *quality;

@property (readonly) BOOL showLevel;
@property (readonly) BOOL showOption;

-(void) addObjectToDictionary: (NSMutableDictionary *) myDict index:(NSUInteger) index;
-(BOOL) loadObjectFromDictionary: (NSDictionary *)myDict index:(NSUInteger) index;

-(NSInteger) karma;

@end

NS_ASSUME_NONNULL_END

#import "SR6ActorQualityProperties.h"
