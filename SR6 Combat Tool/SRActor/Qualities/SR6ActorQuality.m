//
//  SR6ActorSpell+CoreDataClass.m
//  DBBuilder
//
//  Created by Ed Pichon on 2020/7/04.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6ActorQuality.h"
#import "SR6Quality.h"

@implementation SR6ActorQuality

+(NSSet *)keyPathsForValuesAffectingTableName {
    return [NSSet setWithObjects:@"option",@"qualityInfo",@"level",nil];
}

+(NSSet *)keyPathsForValuesAffectingSummary {
    return [NSSet setWithObjects:@"qualityInfo",nil];
}

-(NSString *) tableName {
    if (self.quality.optionName == nil) {
        if (self.quality.level) {
            return ([NSString stringWithFormat:@"%@ %d",self.quality.name,self.level]);
        } else {
            return(self.quality.name);
        }
    } else {
        if (self.quality.level) {
            return ([NSString stringWithFormat:@"%@ %d [%@]",self.quality.name,self.level, self.option]);
        } else {
            return ([NSString stringWithFormat:@"%@ [%@]",self.quality.name, self.option]);
        }
    }
}

-(SR6Quality *) quality {
    if (_quality == nil) {
        _quality = [self.qualityInfo firstObject];
    }
    return (_quality);
}

-(NSInteger) karma {
    NSInteger sign;
    
    if (self.quality.negative) {
        sign = -1;
    } else {
        sign = 1;
    }
    if (self.quality.level) {
        return (NSInteger)(self.level * self.quality.karma * sign);
    } else {
        return (NSInteger)(self.quality.karma * sign);
    }
}

-(BOOL) showLevel {
    return (self.quality.level);
}

-(BOOL) showOption {
    return ([self.quality.optionName length] > 0);
}

-(void) addObjectToDictionary: (NSMutableDictionary *) myDict index:(NSUInteger) index {
    NSString *tag = [NSString stringWithFormat:@"Quality-%ld",index];
    [myDict setObject:[NSNumber numberWithInt:self.level] forKey:[NSString stringWithFormat:@"%@-level",tag]];
    if (self.option != nil) {
        [myDict setObject:self.option forKey:[NSString stringWithFormat:@"%@-option",tag]];
    }
    
    [myDict setObject:[self.uuid UUIDString] forKey:[NSString stringWithFormat:@"%@-UUID",tag]];
}

-(BOOL) loadObjectFromDictionary: (NSDictionary *)myDict index:(NSUInteger) index {
    NSString *tag = [NSString stringWithFormat:@"Quality-%ld",index];
    
    if ([myDict objectForKey:[NSString stringWithFormat:@"%@-UUID",tag]] == nil) return FALSE;

    self.level = [[myDict objectForKey:[NSString stringWithFormat:@"%@-level",tag]] intValue];
    self.option = [myDict objectForKey:[NSString stringWithFormat:@"%@-option",tag]];
    
    self.uuid = [[NSUUID alloc] initWithUUIDString:[myDict objectForKey:[NSString stringWithFormat:@"%@-UUID",tag]]];
    
    return TRUE;
}

@end
