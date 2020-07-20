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

@class SR6Actor;
@class SR6Metamagic;

NS_ASSUME_NONNULL_BEGIN

@interface SR6ActorMetamagic : NSManagedObject {
    SR6Metamagic *_metamagic;
}

@property (readonly) NSString *tableName;
@property (readonly) SR6Metamagic *metamagic;

-(BOOL) showLevel;
-(BOOL) showOption;

-(void) addObjectToDictionary: (NSMutableDictionary *) myDict index:(NSUInteger) index;
-(BOOL) loadObjectFromDictionary: (NSDictionary *)myDict index:(NSUInteger) index;

@end

NS_ASSUME_NONNULL_END

#import "SR6ActorMetamagicProperties.h"
