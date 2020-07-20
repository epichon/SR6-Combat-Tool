//
//  SR6Power+CoreDataClass.m
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/6/30.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6Power.h"
#import "SR6Constants.h"

@implementation SR6Power

-(NSString *) tableName {
    if (self.optionName == nil) {
        return(self.name);
    } else {
        return([NSString stringWithFormat:@"%@ [%@]",self.name,self.optionName]);
    }
}

-(NSString *) summary {
    if (_summary == nil) {
        switch (self.category) {
            case kPowerCatCritterPower:
                _summary = [NSString stringWithFormat:(@"Power Type:%@ %@ Rng:%@ Dur:%@"),self.typeShortString,self.actionShortString,self.rangeShortString,self.durationShortString];
                break;
            case kPowerCatCritterWeakness:
                _summary = @"Weakness";
                break;
            case kPowerCatSpritePower:
                _summary = @"Sprite Power";
                break;
            case kPowerCatOther:
                _summary = @"Other";
                break;
            default:
                _summary = @"ERR";
                break;
        }
    }
    return _summary;
}

- (NSString *) categoryShortString {
    switch (self.category) {
        case kPowerCatCritterPower:
            return (SR6_POWER_CAT_POWER_SHORT);
            break;
        case kPowerCatCritterWeakness:
            return (SR6_POWER_CAT_WEAKNESS_SHORT);
            break;
        case kPowerCatSpritePower:
            return (SR6_POWER_CAT_SPRITE_SHORT);
            break;
        case kPowerCatOther:
            return (SR6_POWER_CAT_OTHER_SHORT);
            break;
        default:
            return(@"ERR");
            break;
    }
}

- (NSString *) categoryLongString {
    switch (self.category) {
        case kPowerCatCritterPower:
            return (SR6_POWER_CAT_POWER_LONG);
            break;
        case kPowerCatCritterWeakness:
            return (SR6_POWER_CAT_WEAKNESS_LONG);
            break;
        case kPowerCatSpritePower:
            return (SR6_POWER_CAT_SPRITE_LONG);
            break;
        case kPowerCatOther:
            return (SR6_POWER_CAT_OTHER_LONG);
            break;
        default:
            return(@"ERR");
            break;
    }
}

- (NSString *) actionShortString {
    switch (self.action) {
        case kActivationPassive:
            return (SR6_ACTIVATION_AUTO_SHORT);
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

- (NSString *) actionLongString {
    switch (self.action) {
        case kActivationPassive:
            return (SR6_ACTIVATION_AUTO_LONG);
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

- (NSString *) rangeShortString {
    switch (self.range) {
        case kRangeSelf:
            return (SR6_RANGE_SELF_SHORT);
            break;
        case kRangeTouch:
            return (SR6_RANGE_TOUCH_SHORT);
            break;
        case kRangeLOS:
            return (SR6_RANGE_LOS_SHORT);
            break;
        case kRangeLOSArea:
            return (SR6_RANGE_LOSA_SHORT);
            break;
        case kRangeSpecial:
            return (SR6_RANGE_SPECIAL_SHORT);
            break;
        default:
            return(@"ERR");
            break;
    }
}

- (NSString *) rangeLongString {
    switch (self.range) {
        case kRangeSelf:
            return (SR6_RANGE_SELF_LONG);
            break;
        case kRangeTouch:
            return (SR6_RANGE_TOUCH_LONG);
            break;
        case kRangeLOS:
            return (SR6_RANGE_LOS_LONG);
            break;
        case kRangeLOSArea:
            return (SR6_RANGE_LOSA_LONG);
            break;
        case kRangeSpecial:
            return (SR6_RANGE_SPECIAL_LONG);
            break;
        default:
            return(@"ERR");
            break;
    }
}

- (NSString *) typeShortString {
    switch (self.type) {
        case kPowerTypePhysical:
            return (SR6_POWER_TYPE_PHYSICAL_SHORT);
            break;
        case kPowerTypeMana:
            return (SR6_POWER_TYPE_MANA_SHORT);
            break;
        case kPowerTypeSpecial:
            return (SR6_POWER_TYPE_SPECIAL_SHORT);
            break;
        default:
            return(@"ERR");
            break;
    }
}

- (NSString *) typeLongString {
    switch (self.type) {
        case kPowerTypePhysical:
            return (SR6_POWER_TYPE_PHYSICAL_LONG);
            break;
        case kPowerTypeMana:
            return (SR6_POWER_TYPE_MANA_LONG);
            break;
        case kPowerTypeSpecial:
            return (SR6_POWER_TYPE_SPECIAL_LONG);
            break;
        default:
            return(@"ERR");
            break;
    }
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
