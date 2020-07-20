//
//  SR6ActorPower+CoreDataClass.m
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/05.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6ActorMetamagic.h"
#import "SR6Metamagic.h"

@implementation SR6ActorMetamagic

+(NSSet *)keyPathsForValuesAffectingTableName {
    return [NSSet setWithObjects:@"option",@"metamagicInfo",@"level",nil];
}

+(NSSet *)keyPathsForValuesAffectingSummary {
    return [NSSet setWithObjects:@"metamagicInfo",nil];
}

-(NSString *) tableName {
    if (self.metamagic.optionName == nil) {
        if (self.metamagic.level) {
            return ([NSString stringWithFormat:@"%@ %d",self.metamagic.name,self.level]);
        } else {
            return(self.metamagic.name);
        }
    } else {
        if (self.metamagic.level) {
            return ([NSString stringWithFormat:@"%@ %d [%@]",self.metamagic.name,self.level, self.option]);
        } else {
            return ([NSString stringWithFormat:@"%@ [%@]",self.metamagic.name, self.option]);
        }
    }
}

-(SR6Metamagic *) metamagic {
    if (_metamagic == nil) {
        _metamagic = [self.metamagicInfo firstObject];
    }
    return (_metamagic);
}

-(BOOL) showLevel {
    return (self.metamagic.level);
}

-(BOOL) showOption {
    return ([self.metamagic.optionName length] > 0);
}

-(void) addObjectToDictionary: (NSMutableDictionary *) myDict index:(NSUInteger) index {
    NSString *tag = [NSString stringWithFormat:@"Metamagic-%ld",index];
    [myDict setObject:[NSNumber numberWithInt:self.level] forKey:[NSString stringWithFormat:@"%@-level",tag]];
    if (self.option != nil) {
        [myDict setObject:self.option forKey:[NSString stringWithFormat:@"%@-option",tag]];
    }
    
    [myDict setObject:[self.uuid UUIDString] forKey:[NSString stringWithFormat:@"%@-UUID",tag]];
}

-(BOOL) loadObjectFromDictionary: (NSDictionary *)myDict index:(NSUInteger) index {
    NSString *tag = [NSString stringWithFormat:@"Metamagic-%ld",index];
    
    if ([myDict objectForKey:[NSString stringWithFormat:@"%@-UUID",tag]] == nil) return FALSE;

    self.level = [[myDict objectForKey:[NSString stringWithFormat:@"%@-level",tag]] intValue];
    self.option = [myDict objectForKey:[NSString stringWithFormat:@"%@-option",tag]];
    
    self.uuid = [[NSUUID alloc] initWithUUIDString:[myDict objectForKey:[NSString stringWithFormat:@"%@-UUID",tag]]];
    
    return TRUE;
}

@end
