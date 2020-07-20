//
//  SR6ActorPower+CoreDataClass.h
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/05.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SR6Constants.h"

@class SR6Actor;
@class SR6Aug;

NS_ASSUME_NONNULL_BEGIN

@interface SR6ActorAug : NSManagedObject {
    SR6Aug *_aug;
    NSString *_summary;
}

@property (readonly) NSString *tableName;
@property (readonly) SR6Aug *aug;

@property (readonly) NSString * gradeShortString;
@property (readonly) NSString * gradeLongString;

@property (readonly) NSString * capacityString;
@property (readonly) NSInteger capacityInt;
@property (readonly) NSDecimalNumber * essence;
@property (readonly) NSString * avail;
@property (readonly) NSDecimalNumber * cost;

-(BOOL) showLevel;
-(BOOL) showOption;

-(void) addObjectToDictionary: (NSMutableDictionary *) myDict index:(NSUInteger) index;
-(BOOL) loadObjectFromDictionary: (NSDictionary *)myDict index:(NSUInteger) index;

@end

NS_ASSUME_NONNULL_END

#import "SR6ActorAugProperties.h"
