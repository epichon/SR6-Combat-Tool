//
//  SR6ActorSpell+CoreDataClass.m
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/6/28.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6ActorSpell.h"
#import "SR6Spell.h"

@implementation SR6ActorSpell

+(NSSet *)keyPathsForValuesAffectingTableName {
    return [NSSet setWithObjects:@"option",@"spellInfo",nil];
}

+(NSSet *)keyPathsForValuesAffectingSummary {
    return [NSSet setWithObjects:@"spellInfo",nil];
}

-(NSString *) tableName {
    if (self.spell.optionName == nil) {
        return(self.spell.name);
    } else {
        return([NSString stringWithFormat:@"%@ [%@]",self.spell.name,self.option]);
    }
}

-(SR6Spell *) spell {
    if (_spell == nil) {
        _spell = [self.spellInfo firstObject];
    }
    return (_spell);
}

-(BOOL) showNumberHits {
    return (self.spell.duration == kDurationSustained || self.spell.duration == kDurationLimited || self.spell.duration == kDurationSpecial);
}

-(BOOL) showOption {
    return ([self.spell.optionName length] > 0);
}

-(void) addObjectToDictionary: (NSMutableDictionary *) myDict index:(NSUInteger) index {
    NSString *tag = [NSString stringWithFormat:@"Spell-%ld",index];
    [myDict setObject:[NSNumber numberWithInt:self.numberHits] forKey:[NSString stringWithFormat:@"%@-numberHits",tag]];
    [myDict setObject:[NSNumber numberWithInt:self.sustained] forKey:[NSString stringWithFormat:@"%@-sustained",tag]];
    if (self.option != nil) {
        [myDict setObject:self.option forKey:[NSString stringWithFormat:@"%@-option",tag]];
    }
    
    [myDict setObject:[self.uuid UUIDString] forKey:[NSString stringWithFormat:@"%@-UUID",tag]];
}

-(BOOL) loadObjectFromDictionary: (NSDictionary *)myDict index:(NSUInteger) index {
    NSString *tag = [NSString stringWithFormat:@"Spell-%ld",index];
    
    if ([myDict objectForKey:[NSString stringWithFormat:@"%@-UUID",tag]] == nil) return FALSE;

    self.numberHits = [[myDict objectForKey:[NSString stringWithFormat:@"%@-numberHits",tag]] intValue];
    self.sustained = [[myDict objectForKey:[NSString stringWithFormat:@"%@-sustained",tag]] intValue];
    self.option = [myDict objectForKey:[NSString stringWithFormat:@"%@-option",tag]];
    
    self.uuid = [[NSUUID alloc] initWithUUIDString:[myDict objectForKey:[NSString stringWithFormat:@"%@-UUID",tag]]];
    
    return TRUE;
}


@end
