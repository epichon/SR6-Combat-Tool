//
//  SR6ActorPower+CoreDataClass.m
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/05.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6ActorEcho.h"
#import "SR6Echo.h"

@implementation SR6ActorEcho

+(NSSet *)keyPathsForValuesAffectingTableName {
    return [NSSet setWithObjects:@"option",@"echoInfo",@"level",nil];
}

+(NSSet *)keyPathsForValuesAffectingSummary {
    return [NSSet setWithObjects:@"echoInfo",nil];
}

-(NSString *) tableName {
    if (self.echo.optionName == nil) {
        if (self.echo.level) {
            return ([NSString stringWithFormat:@"%@ %d",self.echo.name,self.level]);
        } else {
            return(self.echo.name);
        }
    } else {
        if (self.echo.level) {
            return ([NSString stringWithFormat:@"%@ %d [%@]",self.echo.name,self.level, self.option]);
        } else {
            return ([NSString stringWithFormat:@"%@ [%@]",self.echo.name, self.option]);
        }
    }
}

-(SR6Echo *) echo {
    if (_echo == nil) {
        _echo = [self.echoInfo firstObject];
    }
    return (_echo);
}

-(BOOL) showLevel {
    return (self.echo.level);
}

-(BOOL) showOption {
    return ([self.echo.optionName length] > 0);
}

-(void) addObjectToDictionary: (NSMutableDictionary *) myDict index:(NSUInteger) index {
    NSString *tag = [NSString stringWithFormat:@"Echo-%ld",index];
    [myDict setObject:[NSNumber numberWithInt:self.level] forKey:[NSString stringWithFormat:@"%@-level",tag]];
    if (self.option != nil) {
        [myDict setObject:self.option forKey:[NSString stringWithFormat:@"%@-option",tag]];
    }
    
    [myDict setObject:[self.uuid UUIDString] forKey:[NSString stringWithFormat:@"%@-UUID",tag]];
}

-(BOOL) loadObjectFromDictionary: (NSDictionary *)myDict index:(NSUInteger) index {
    NSString *tag = [NSString stringWithFormat:@"Echo-%ld",index];
    
    if ([myDict objectForKey:[NSString stringWithFormat:@"%@-UUID",tag]] == nil) return FALSE;

    self.level = [[myDict objectForKey:[NSString stringWithFormat:@"%@-level",tag]] intValue];
    self.option = [myDict objectForKey:[NSString stringWithFormat:@"%@-option",tag]];
    
    self.uuid = [[NSUUID alloc] initWithUUIDString:[myDict objectForKey:[NSString stringWithFormat:@"%@-UUID",tag]]];
    
    return TRUE;
}


@end
