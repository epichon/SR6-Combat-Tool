//
//  SR6ActorPower+CoreDataClass.m
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/05.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6ActorPower.h"
#import "SR6Power.h"

@implementation SR6ActorPower

+(NSSet *)keyPathsForValuesAffectingTableName {
    return [NSSet setWithObjects:@"option",@"powerInfo",nil];
}

+(NSSet *)keyPathsForValuesAffectingSummary {
    return [NSSet setWithObjects:@"powerInfo",nil];
}

-(NSString *) tableName {
    if (self.power.optionName == nil || self.option == nil || [self.option isEqualToString:@""]) {
        return(self.power.name);
    } else {
        return([NSString stringWithFormat:@"%@ [%@]",self.power.name,self.option]);
    }
}

-(SR6Power *) power {
    if (_power == nil) {
        _power = [self.powerInfo firstObject];
    }
    return (_power);
}

-(BOOL) showOption {
    return ([self.power.optionName length] > 0);
}

-(void) addObjectToDictionary: (NSMutableDictionary *) myDict index:(NSUInteger) index {
    NSString *tag = [NSString stringWithFormat:@"Power-%ld",index];
    if (self.option != nil) {
        [myDict setObject:self.option forKey:[NSString stringWithFormat:@"%@-option",tag]];
    }
    
    [myDict setObject:[self.uuid UUIDString] forKey:[NSString stringWithFormat:@"%@-UUID",tag]];
}

-(BOOL) loadObjectFromDictionary: (NSDictionary *)myDict index:(NSUInteger) index {
    NSString *tag = [NSString stringWithFormat:@"Power-%ld",index];
    
    if ([myDict objectForKey:[NSString stringWithFormat:@"%@-UUID",tag]] == nil) return FALSE;

    self.option = [myDict objectForKey:[NSString stringWithFormat:@"%@-option",tag]];
    
    self.uuid = [[NSUUID alloc] initWithUUIDString:[myDict objectForKey:[NSString stringWithFormat:@"%@-UUID",tag]]];
    
    return TRUE;
}

@end
