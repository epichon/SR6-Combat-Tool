//
//  SR6ActorPower+CoreDataClass.m
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/05.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6ActorProgram.h"
#import "SR6Program.h"

@implementation SR6ActorProgram

+(NSSet *)keyPathsForValuesAffectingTableName {
    return [NSSet setWithObjects:@"option",@"programInfo",@"level",nil];
}

+(NSSet *)keyPathsForValuesAffectingSummary {
    return [NSSet setWithObjects:@"programInfo",nil];
}

-(NSString *) tableName {
    if (self.program.optionName == nil) {
        if (self.program.level) {
            return ([NSString stringWithFormat:@"%@ %d",self.program.name,self.level]);
        } else {
            return(self.program.name);
        }
    } else {
        if (self.program.level) {
            return ([NSString stringWithFormat:@"%@ %d [%@]",self.program.name,self.level, self.option]);
        } else {
            return ([NSString stringWithFormat:@"%@ [%@]",self.program.name, self.option]);
        }
    }
}

-(SR6Program *) program {
    if (_program == nil) {
        _program = [self.programInfo firstObject];
    }
    return (_program);
}

-(BOOL) showLevel {
    return (self.program.level);
}

-(BOOL) showOption {
    return ([self.program.optionName length] > 0);
}

-(void) addObjectToDictionary: (NSMutableDictionary *) myDict index:(NSUInteger) index {
    NSString *tag = [NSString stringWithFormat:@"Program-%ld",index];
    [myDict setObject:[NSNumber numberWithInt:self.level] forKey:[NSString stringWithFormat:@"%@-level",tag]];
    [myDict setObject:[NSNumber numberWithInt:self.loaded] forKey:[NSString stringWithFormat:@"%@-loaded",tag]];
    if (self.option != nil) {
        [myDict setObject:self.option forKey:[NSString stringWithFormat:@"%@-option",tag]];
    }
    
    [myDict setObject:[self.uuid UUIDString] forKey:[NSString stringWithFormat:@"%@-UUID",tag]];
}

-(BOOL) loadObjectFromDictionary: (NSDictionary *)myDict index:(NSUInteger) index {
    NSString *tag = [NSString stringWithFormat:@"Program-%ld",index];
    
    if ([myDict objectForKey:[NSString stringWithFormat:@"%@-UUID",tag]] == nil) return FALSE;

    self.level = [[myDict objectForKey:[NSString stringWithFormat:@"%@-level",tag]] intValue];
    self.loaded = [[myDict objectForKey:[NSString stringWithFormat:@"%@-loaded",tag]] intValue];
    self.option = [myDict objectForKey:[NSString stringWithFormat:@"%@-option",tag]];
    
    self.uuid = [[NSUUID alloc] initWithUUIDString:[myDict objectForKey:[NSString stringWithFormat:@"%@-UUID",tag]]];
    
    return TRUE;
}

@end
