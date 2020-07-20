//
//  SR6ActorQuality+CoreDataClass.m
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/05.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6ActorAdeptPower.h"
#import "SR6AdeptPower.h"

@implementation SR6ActorAdeptPower

+(NSSet *)keyPathsForValuesAffectingTableName {
    return [NSSet setWithObjects:@"option",@"adeptPowerInfo",@"level",nil];
}

+(NSSet *)keyPathsForValuesAffectingSummary {
    return [NSSet setWithObjects:@"adeptPowerInfo",nil];
}

+(NSSet *)keyPathsForValuesAffectingPowerPointCost {
    return [NSSet setWithObjects:@"adeptPowerInfo",@"costString",@"level",nil];
}

+(NSSet *)keyPathsForValuesAffectingCostString {
    return [NSSet setWithObjects:@"adeptPowerInfo",@"level",nil];
}

-(NSString *) tableName {
    if (self.adeptPower.optionName == nil) {
        if (self.adeptPower.level) {
            return ([NSString stringWithFormat:@"%@ %d",self.adeptPower.name,self.level]);
        } else {
            return(self.adeptPower.name);
        }
    } else {
        if (self.adeptPower.level) {
            return ([NSString stringWithFormat:@"%@ %d [%@]",self.adeptPower.name,self.level, self.option]);
        } else {
            return ([NSString stringWithFormat:@"%@ [%@]",self.adeptPower.name, self.option]);
        }
    }
}

-(SR6AdeptPower *) adeptPower {
    if (_adeptPower == nil) {
        _adeptPower = [self.adeptPowerInfo firstObject];
    }
    return (_adeptPower);
}

-(NSString *) costString {
    if (self.adeptPower.level) {
        return ([NSString stringWithFormat: @"%@ (%@/level)",[self.powerPointCost stringValue],[self.adeptPower.cost stringValue]]);
    } else {
        return ([self.powerPointCost stringValue]);
    }
}

-(NSDecimalNumber *) powerPointCost {
    if (self.adeptPower.level) {
        return ([self.adeptPower.cost decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithDecimal:[[NSNumber numberWithShort:self.level] decimalValue]]]);
    } else {
        return (self.adeptPower.cost);
    }
}

-(BOOL) showOption {
    return ([self.adeptPower.optionName length] > 0);
}

-(void) addObjectToDictionary: (NSMutableDictionary *) myDict index:(NSUInteger) index {
    NSString *tag = [NSString stringWithFormat:@"AdeptPower-%ld",index];
    [myDict setObject:[NSNumber numberWithInt:self.level] forKey:[NSString stringWithFormat:@"%@-level",tag]];
    if (self.option != nil) {
        [myDict setObject:self.option forKey:[NSString stringWithFormat:@"%@-option",tag]];
    }
    [myDict setObject:[self.uuid UUIDString] forKey:[NSString stringWithFormat:@"%@-UUID",tag]];
}

-(BOOL) loadObjectFromDictionary: (NSDictionary *)myDict index:(NSUInteger) index {
    NSString *tag = [NSString stringWithFormat:@"AdeptPower-%ld",index];
    
    if ([myDict objectForKey:[NSString stringWithFormat:@"%@-UUID",tag]] == nil) return FALSE;
    //NSLog(@"%@ %d %@ %@",tag, [[myDict objectForKey:[NSString stringWithFormat:@"%@-level",tag]] intValue], [myDict objectForKey:[NSString stringWithFormat:@"%@-option",tag]], [myDict objectForKey:[NSString stringWithFormat:@"%@-UUID",tag]]);
         
    self.level = [[myDict objectForKey:[NSString stringWithFormat:@"%@-level",tag]] intValue];
    self.option = [myDict objectForKey:[NSString stringWithFormat:@"%@-option",tag]];
    self.uuid = [[NSUUID alloc] initWithUUIDString:[myDict objectForKey:[NSString stringWithFormat:@"%@-UUID",tag]]];
    
    return TRUE;
}

@end
