//
//  SR6ActorPower+CoreDataClass.m
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/05.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6ActorComplexForm.h"
#import "SR6ComplexForm.h"

@implementation SR6ActorComplexForm

+(NSSet *)keyPathsForValuesAffectingTableName {
    return [NSSet setWithObjects:@"option",@"complexFormInfo",nil];
}

+(NSSet *)keyPathsForValuesAffectingSummary {
    return [NSSet setWithObjects:@"complexFormInfo",nil];
}

-(NSString *) tableName {
    if (self.complexForm.optionName == nil) {
        return(self.complexForm.name);
    } else {
        return ([NSString stringWithFormat:@"%@ [%@]",self.complexForm.name, self.option]);
    }
}

-(SR6ComplexForm *) complexForm {
    if (_complexForm == nil) {
        _complexForm = [self.complexFormInfo firstObject];
    }
    return (_complexForm);
}

-(BOOL) showNumberHits {
    return (self.complexForm.duration == kDurationSustained || self.complexForm.duration == kDurationLimited || self.complexForm.duration == kDurationSpecial);
}

-(BOOL) showOption {
    return ([self.complexForm.optionName length] > 0);
}

-(void) addObjectToDictionary: (NSMutableDictionary *) myDict index:(NSUInteger) index {
    NSString *tag = [NSString stringWithFormat:@"ComplexForm-%ld",index];
    [myDict setObject:[NSNumber numberWithInt:self.numberHits] forKey:[NSString stringWithFormat:@"%@-numberHits",tag]];
    [myDict setObject:[NSNumber numberWithInt:self.sustained] forKey:[NSString stringWithFormat:@"%@-sustained",tag]];
    if (self.option != nil) {
        [myDict setObject:self.option forKey:[NSString stringWithFormat:@"%@-option",tag]];
    }
    
    [myDict setObject:[self.uuid UUIDString] forKey:[NSString stringWithFormat:@"%@-UUID",tag]];
}

-(BOOL) loadObjectFromDictionary: (NSDictionary *)myDict index:(NSUInteger) index {
    NSString *tag = [NSString stringWithFormat:@"ComplexForm-%ld",index];
    
    if ([myDict objectForKey:[NSString stringWithFormat:@"%@-UUID",tag]] == nil) return FALSE;

    self.numberHits = [[myDict objectForKey:[NSString stringWithFormat:@"%@-numberHits",tag]] intValue];
    self.sustained = [[myDict objectForKey:[NSString stringWithFormat:@"%@-sustained",tag]] intValue];
    self.option = [myDict objectForKey:[NSString stringWithFormat:@"%@-option",tag]];
    
    self.uuid = [[NSUUID alloc] initWithUUIDString:[myDict objectForKey:[NSString stringWithFormat:@"%@-UUID",tag]]];
    
    return TRUE;
}

@end
