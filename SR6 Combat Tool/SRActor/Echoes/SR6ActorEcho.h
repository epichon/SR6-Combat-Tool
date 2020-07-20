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
@class SR6Echo;

NS_ASSUME_NONNULL_BEGIN

@interface SR6ActorEcho : NSManagedObject {
    SR6Echo *_echo;
}

@property (readonly) NSString *tableName;
@property (readonly) SR6Echo *echo;

-(void) addObjectToDictionary: (NSMutableDictionary *) myDict index:(NSUInteger) index;
-(BOOL) loadObjectFromDictionary: (NSDictionary *)myDict index:(NSUInteger) index;

@end

NS_ASSUME_NONNULL_END

#import "SR6ActorEchoProperties.h"
