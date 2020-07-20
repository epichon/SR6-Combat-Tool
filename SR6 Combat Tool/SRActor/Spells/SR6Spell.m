//
//  SR6Spell.m
//  DBBuilder
//
//  Created by Ed Pichon on 2020/6/27.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//

#import "SR6Spell.h"

@implementation SR6Spell

-(NSString *) tableName {
    if (self.optionName == nil) {
        return(self.name);
    } else {
        return([NSString stringWithFormat:@"%@ [%@]",self.name,self.optionName]);
    }
}

-(NSString *) summary {
    if (_summary == nil) {
        if (self.category == kSpellCatDirectCombat || self.category == kSpellCatIndirectCombat) {
            _summary = [NSString stringWithFormat:@"R:%@ T:%@ D:%@ DV:%d DMG:%@",self.rangeShortString,self.typeShortString, self.durationShortString , self.drain, self.damageShortString];
        } else {
            _summary = [NSString stringWithFormat:@"R:%@ T:%@ D:%@ DV:%d",self.rangeShortString,self.typeShortString, self.durationShortString , self.drain];
        }
    }
    return (_summary);
}

- (NSString *) categoryShortString {
    switch (self.category) {
        case kSpellCatDirectCombat:
            return (SR6_SPELL_CAT_DIRECT_COMBAT_SHORT);
            break;
        case kSpellCatIndirectCombat:
            return (SR6_SPELL_CAT_INDIRECT_COMBAT_SHORT);
            break;
        case kSpellCatDetection:
            return (SR6_SPELL_CAT_DETECTION_SHORT);
            break;
        case kSpellCatHealth:
            return (SR6_SPELL_CAT_HEALTH_SHORT);
            break;
        case kSpellCatIllusion:
            return (SR6_SPELL_CAT_ILLUSION_SHORT);
            break;
        case kSpellCatManipulation:
            return (SR6_SPELL_CAT_MANIPULATION_SHORT);
            break;
        default:
            return(@"ERR");
            break;
    }
}

- (NSString *) categoryLongString {
    switch (self.category) {
        case kSpellCatDirectCombat:
            return (SR6_SPELL_CAT_DIRECT_COMBAT_LONG);
            break;
        case kSpellCatIndirectCombat:
            return (SR6_SPELL_CAT_INDIRECT_COMBAT_LONG);
            break;
        case kSpellCatDetection:
            return (SR6_SPELL_CAT_DETECTION_LONG);
            break;
        case kSpellCatHealth:
            return (SR6_SPELL_CAT_HEALTH_LONG);
            break;
        case kSpellCatIllusion:
            return (SR6_SPELL_CAT_ILLUSION_LONG);
            break;
        case kSpellCatManipulation:
            return (SR6_SPELL_CAT_MANIPULATION_LONG);
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

- (NSString *) typeShortString{
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

- (NSString *) typeLongString{
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

- (NSString *) damageShortString{
   switch (self.damage) {
       case kSpellDmgNone:
           return (SR6_SPELL_DAMAGE_NONE_SHORT);
           break;
       case kSpellDmgStun:
           return (SR6_SPELL_DAMAGE_STUN_SHORT);
           break;
       case kSpellDmgPhysical:
           return (SR6_SPELL_DAMAGE_PHYSICAL_SHORT);
           break;
        case kSpellDmgStunSpecial:
           return (SR6_SPELL_DAMAGE_STUN_SPECIAL_SHORT);
           break;
        case kSpellDmgPhysicalSpecial:
           return (SR6_SPELL_DAMAGE_PHYSICAL_SPECIAL_SHORT);
           break;
       default:
           return(@"ERR");
           break;
   }
}

- (NSString *) damageLongString{
   switch (self.damage) {
       case kSpellDmgNone:
           return (SR6_SPELL_DAMAGE_NONE_LONG);
           break;
       case kSpellDmgStun:
           return (SR6_SPELL_DAMAGE_STUN_LONG);
           break;
       case kSpellDmgPhysical:
           return (SR6_SPELL_DAMAGE_PHYSICAL_LONG);
           break;
        case kSpellDmgStunSpecial:
           return (SR6_SPELL_DAMAGE_STUN_SPECIAL_LONG);
           break;
        case kSpellDmgPhysicalSpecial:
           return (SR6_SPELL_DAMAGE_PHYSICAL_SPECIAL_LONG);
           break;
       default:
           return(@"ERR");
           break;
   }
}
@end

