//
//  SR6ActorPower+CoreDataClass.m
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/05.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6ActorAug.h"
#import "SR6Aug.h"

@implementation SR6ActorAug

+(NSSet *)keyPathsForValuesAffectingTableName {
    return [NSSet setWithObjects:@"level",@"option",@"augInfo",nil];
}

+(NSSet *)keyPathsForValuesAffectingSummary {
    return [NSSet setWithObjects:@"level",@"option",@"augInfo",nil];
}

+(NSSet *)keyPathsForValuesAffectingCapacityInt {
    return [NSSet setWithObjects:@"level",@"aug",@"augInfo",nil];
}

+(NSSet *)keyPathsForValuesAffectingCapacityString {
    return [NSSet setWithObjects:@"level",@"capacityInt",@"aug",@"augInfo",nil];
}

+(NSSet *)keyPathsForValuesAffectingAvail {
    return [NSSet setWithObjects:@"grade",@"aug",@"augInfo",nil];
}

+(NSSet *)keyPathsForValuesAffectingCost {
    return [NSSet setWithObjects:@"level",@"grade",@"aug",@"augInfo",nil];
}

+(NSSet *)keyPathsForValuesAffectingEssence {
    return [NSSet setWithObjects:@"level",@"grade",@"aug",@"augInfo",nil];
}

-(NSString *) tableName {
    if (self.aug.optionName == nil) {
        if (self.aug.level) {
            return ([NSString stringWithFormat:@"%@ %d",self.aug.name,self.level]);
        } else {
            return(self.aug.name);
        }
    } else {
        if (self.aug.level) {
            return ([NSString stringWithFormat:@"%@ %d [%@]",self.aug.name,self.level, self.option]);
        } else {
            return ([NSString stringWithFormat:@"%@ [%@]",self.aug.name, self.option]);
        }
    }
}

-(SR6Aug *) aug {
    if (_aug == nil) {
        _aug = [self.augInfo firstObject];
    }
    return (_aug);
}

- (NSString *) gradeShortString {
    switch (self.grade) {
        case kAugGradeNormal:
            return (SR6_AUG_GRADE_NORMAL_SHORT);
            break;
        case kAugGradeUsed:
            return (SR6_AUG_GRADE_USED_SHORT);
            break;
        case kAugGradeAlpha:
            return (SR6_AUG_GRADE_ALPHA_SHORT);
            break;
        case kAugGradeBeta:
            return (SR6_AUG_GRADE_BETA_SHORT);
            break;
        case kAugGradeDelta:
            return (SR6_AUG_GRADE_DELTA_SHORT);
            break;
        case kAugGradeGamma:
            return (SR6_AUG_GRADE_GAMMA_SHORT);
            break;
        case kAugGradeOther:
            return (SR6_AUG_GRADE_OTHER_SHORT);
            break;
        default:
            return(@"ERR");
            break;
    }
}

- (NSString *) gradeLongString {
    switch (self.grade) {
        case kAugGradeNormal:
            return (SR6_AUG_GRADE_NORMAL_LONG);
            break;
        case kAugGradeUsed:
            return (SR6_AUG_GRADE_USED_LONG);
            break;
        case kAugGradeAlpha:
            return (SR6_AUG_GRADE_ALPHA_LONG);
            break;
        case kAugGradeBeta:
            return (SR6_AUG_GRADE_BETA_LONG);
            break;
        case kAugGradeDelta:
            return (SR6_AUG_GRADE_DELTA_LONG);
            break;
        case kAugGradeGamma:
            return (SR6_AUG_GRADE_GAMMA_LONG);
            break;
        case kAugGradeOther:
            return (SR6_AUG_GRADE_OTHER_LONG);
            break;
        default:
            return(@"ERR");
            break;
    }
}

-(NSInteger) capacityInt {
    NSInteger cap;
    if (self.aug.level) {
        // This is based off the rating.
        if ([self.aug.name isEqualToString:@"Retinal Duplication"]) {
            // We have to hard code this - it's capacity is fixed. Everything else is the rating.
            cap = self.aug.capacity;
        } else {
            cap = self.aug.capacity * self.level;
        }
    } else {
        cap = self.aug.capacity;
    }
    return cap;
}

- (NSString *) capacityString {
    NSInteger cap = self.capacityInt;
    
    if (cap < 0) {
        return ([NSString stringWithFormat:@"[%ld]",cap]);
    } else if (cap == 0) {
        return (@"–");
    } else {
        return ([NSString stringWithFormat:@"%ld",cap]);
    }
}

-(NSDecimalNumber *) essence {
    NSDecimalNumber * ess;
    NSDecimalNumber * adj;
    
    ess = self.aug.essence;
    
    if (self.aug.level && self.aug.essenceLevels) {
        ess = [ess decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%d", self.level]]];
    }
    
    switch (self.grade) {
        case kAugGradeNormal:
            adj = [NSDecimalNumber one];
            break;
        case kAugGradeUsed:
            adj = [NSDecimalNumber decimalNumberWithString:@"1.1"];
            break;
        case kAugGradeAlpha:
            adj = [NSDecimalNumber decimalNumberWithString:@"0.8"];
            break;
        case kAugGradeBeta:
            adj = [NSDecimalNumber decimalNumberWithString:@"0.7"];
            break;
        case kAugGradeDelta:
            adj = [NSDecimalNumber decimalNumberWithString:@"0.5"];
            break;
        case kAugGradeGamma:
            adj = [NSDecimalNumber one];
            break;
        case kAugGradeOther:
            adj = [NSDecimalNumber one];
            break;
        default:
            NSLog(@"SR6ActorAug -> essence -> Invalid grade");
            adj = [NSDecimalNumber one];
            break;
    }
    return ([ess decimalNumberByMultiplyingBy:adj]);
}

-(NSDecimalNumber *) cost {
    NSDecimalNumber * cost;
    NSDecimalNumber * adj;
    
    if ([self.aug.name isEqualToString:@"Control Rig"]) {
        // Have to hard code this one, I'm afraid.
        cost = [NSDecimalNumber decimalNumberWithString: [NSString stringWithFormat:@"%d",(self.aug.cost * self.level*self.level)]];
    } else {
        cost = [NSDecimalNumber decimalNumberWithString: [NSString stringWithFormat:@"%d",(self.aug.cost * self.level)]];
    }
    
    switch (self.grade) {
        case kAugGradeNormal:
            adj = [NSDecimalNumber one];
            break;
        case kAugGradeUsed:
            adj = [NSDecimalNumber decimalNumberWithString:@"0.5"];
            break;
        case kAugGradeAlpha:
            adj = [NSDecimalNumber decimalNumberWithString:@"1.2"];
            break;
        case kAugGradeBeta:
            adj = [NSDecimalNumber decimalNumberWithString:@"1.5"];
            break;
        case kAugGradeDelta:
            adj = [NSDecimalNumber decimalNumberWithString:@"2.5"];
            break;
        case kAugGradeGamma:
            adj = [NSDecimalNumber one];
            break;
        case kAugGradeOther:
            adj = [NSDecimalNumber one];
            break;
        default:
            NSLog(@"SR6ActorAug -> cost -> Invalid grade");
            adj = [NSDecimalNumber one];
            break;
    }
    return ([cost decimalNumberByMultiplyingBy:adj]);
}

-(NSString *) avail {
    int16_t availNumber = self.aug.availNumber;
    int16_t adjust;
    
    switch (self.grade) {
        case kAugGradeNormal:
            adjust = 0;
            break;
        case kAugGradeUsed:
            adjust = -1;
            break;
        case kAugGradeAlpha:
            adjust = +1;
            break;
        case kAugGradeBeta:
            adjust = +2;
            break;
        case kAugGradeDelta:
            adjust = +3;
            break;
        case kAugGradeGamma:
            adjust = 0;
            break;
        case kAugGradeOther:
            adjust = 0;
            break;
        default:
            NSLog(@"SR6ActorAug -> avail -> Invalid grade");
            adjust = 0;
            break;
    }
    availNumber = availNumber + adjust;
    
    return ([NSString stringWithFormat:@"%d %@",availNumber,self.aug.availLetterLongString]);
}

-(BOOL) showLevel {
    return (self.aug.level);
}

-(BOOL) showOption {
    return ([self.aug.optionName length] > 0);
}

-(void) addObjectToDictionary: (NSMutableDictionary *) myDict index:(NSUInteger) index {
    NSString *tag = [NSString stringWithFormat:@"Aug-%ld",index];
    [myDict setObject:[NSNumber numberWithInt:self.level] forKey:[NSString stringWithFormat:@"%@-level",tag]];
    [myDict setObject:[NSNumber numberWithInt:self.grade] forKey:[NSString stringWithFormat:@"%@-grade",tag]];
    if (self.option != nil) {
        [myDict setObject:self.option forKey:[NSString stringWithFormat:@"%@-option",tag]];
    }
    [myDict setObject:[self.uuid UUIDString] forKey:[NSString stringWithFormat:@"%@-UUID",tag]];
}

-(BOOL) loadObjectFromDictionary: (NSDictionary *)myDict index:(NSUInteger) index {
    NSString *tag = [NSString stringWithFormat:@"Aug-%ld",index];
    
    if ([myDict objectForKey:[NSString stringWithFormat:@"%@-UUID",tag]] == nil) return FALSE;

    self.level = [[myDict objectForKey:[NSString stringWithFormat:@"%@-level",tag]] intValue];
    self.grade = [[myDict objectForKey:[NSString stringWithFormat:@"%@-grade",tag]] intValue];
    self.option = [myDict objectForKey:[NSString stringWithFormat:@"%@-option",tag]];
    self.uuid = [[NSUUID alloc] initWithUUIDString:[myDict objectForKey:[NSString stringWithFormat:@"%@-UUID",tag]]];
    
    return TRUE;
}

@end
