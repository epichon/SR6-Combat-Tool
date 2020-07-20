//
//  SR6ComplexForm+CoreDataClass.m
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/02.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6ComplexForm.h"

@implementation SR6ComplexForm

-(NSString *) tableName {
    if (self.optionName == nil) {
        return(self.name);
    } else {
        return([NSString stringWithFormat:@"%@ [%@]",self.name,self.optionName]);
    }
}

-(NSString *) summary {
    if (_summary == nil) {
        _summary = [NSString stringWithFormat:@"Fade: %d Dur: %@",self.fade, self.durationShortString];
    }
    return (_summary);
}


- (NSString *) durationShortString{
   switch (self.duration) {
      case kDurationAlways:
          return (SR6_DURATION_ALWAYS_SHORT);
          break;
      case kDurationInstant:
          return (SR6_DURATION_INSTANT_SHORT);
          break;
      case kDurationSustained:
          return (SR6_DURATION_SUSTAINED_SHORT);
          break;
      case kDurationPermananent:
          return (SR6_DURATION_PERMANENT_SHORT);
          break;
       case kDurationLimited:
          return (SR6_DURATION_LIMITED_SHORT);
          break;
       case kDurationSpecial:
          return (SR6_DURATION_SPECIAL_SHORT);
          break;
      default:
          return(@"ERR");
          break;
   }
}

- (NSString *) durationLongString{
   switch (self.duration) {
        case kDurationAlways:
            return (SR6_DURATION_ALWAYS_LONG);
            break;
        case kDurationInstant:
            return (SR6_DURATION_INSTANT_LONG);
            break;
        case kDurationSustained:
            return (SR6_DURATION_SUSTAINED_LONG);
            break;
        case kDurationPermananent:
            return (SR6_DURATION_PERMANENT_LONG);
            break;
        case kDurationLimited:
            return (SR6_DURATION_LIMITED_LONG);
            break;
        case kDurationSpecial:
            return (SR6_DURATION_SPECIAL_LONG);
            break;
        default:
            return(@"ERR");
            break;
        }
}

@end
