//
//  SR6AdeptPower+CoreDataClass.m
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/6/30.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6AdeptPower.h"

@implementation SR6AdeptPower

-(NSString *) tableName {
    if (self.optionName == nil) {
        return(self.name);
    } else {
        return([NSString stringWithFormat:@"%@ [%@]",self.name,self.optionName]);
    }
}

-(NSString *) summary {
    if (_summary == nil) {
        if (self.level) {
            _summary = [NSString stringWithFormat:@"A:%@  %@/lvl",self.activationShortString,[self.cost stringValue]];
        } else {
            _summary = [NSString stringWithFormat:@"A:%@  %@",self.activationShortString,[self.cost stringValue]];
        }
    }
    return (_summary);
}

- (NSString *) activationShortString {
    switch (self.activation) {
        case kActivationPassive:
            return (SR6_ACTIVATION_PASSIVE_SHORT);
            break;
        case kActivationMinor:
            return (SR6_ACTIVATION_MINOR_SHORT);
            break;
        case kActivationMajor:
            return (SR6_ACTIVATION_MAJOR_SHORT);
            break;
        case kActivationSpecial:
            return (SR6_ACTIVATION_SPECIAL_SHORT);
            break;
        default:
            return(@"ERR");
            break;
    }
}

- (NSString *) activationLongString {
    switch (self.activation) {
        case kActivationPassive:
            return (SR6_ACTIVATION_PASSIVE_LONG);
            break;
        case kActivationMinor:
            return (SR6_ACTIVATION_MINOR_LONG);
            break;
        case kActivationMajor:
            return (SR6_ACTIVATION_MAJOR_LONG);
            break;
        case kActivationSpecial:
            return (SR6_ACTIVATION_SPECIAL_LONG);
            break;
        default:
            return(@"ERR");
            break;
    }
}

@end
