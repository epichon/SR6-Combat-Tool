//
//  SR6ActorSpell+CoreDataClass.h
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/6/28.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SR6Actor;
@class SR6Spell;

NS_ASSUME_NONNULL_BEGIN

@interface SR6ActorSpell : NSManagedObject {
    SR6Spell *_spell;
    NSString *_summary;
}

@property (readonly) NSString *tableName;
@property (readonly) SR6Spell *spell;
@property (readonly) BOOL showNumberHits;
@property (readonly) BOOL showOption;

-(void) addObjectToDictionary: (NSMutableDictionary *) myDict index:(NSUInteger) index;
-(BOOL) loadObjectFromDictionary: (NSDictionary *)myDict index:(NSUInteger) index;

@end

NS_ASSUME_NONNULL_END

#import "SR6ActorSpellProperties.h"
