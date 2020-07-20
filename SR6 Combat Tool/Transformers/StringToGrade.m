//
//  StringToGrade.m
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/07.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//

#import "StringToGrade.h"
#import "SR6Constants.h"

@implementation StringToGrade
+(Class)transformedValueClass {
    return [NSString class];
}

+(BOOL)allowsReverseTransformation {
    return YES;
}

-(id)transformedValue:(id)value {
    // Int to string.
    if (value == nil) {
        return (nil);
    } else {
        int iValue = [value intValue];
        
        if (iValue ==kAugGradeNormal) {
            return SR6_AUG_GRADE_NORMAL_LONG;
        } else if (iValue == kAugGradeUsed) {
            return SR6_AUG_GRADE_USED_LONG;
        } else if (iValue == kAugGradeAlpha) {
            return SR6_AUG_GRADE_ALPHA_LONG;
        } else if (iValue == kAugGradeBeta) {
            return SR6_AUG_GRADE_BETA_LONG;
        } else if (iValue == kAugGradeDelta) {
            return SR6_AUG_GRADE_DELTA_LONG;
        } else if (iValue == kAugGradeGamma) {
            return SR6_AUG_GRADE_GAMMA_LONG;
        } else if (iValue == kAugGradeOther) {
            return SR6_AUG_GRADE_OTHER_LONG;
        } else {
            return @"Normal";
        }
    }
}

-(id)reverseTransformedValue:(id)value {
    // String to Int
    if (value == nil) {
        return (nil);
    } else {
        if ([value isEqualToString:SR6_AUG_GRADE_NORMAL_LONG]) {
            return ([NSNumber numberWithInt:kAugGradeNormal]);
        } else if ([value isEqualToString:SR6_AUG_GRADE_USED_LONG]) {
            return ([NSNumber numberWithInt:kAugGradeUsed]);
        } else if ([value isEqualToString:SR6_AUG_GRADE_ALPHA_LONG]) {
            return ([NSNumber numberWithInt:kAugGradeAlpha]);
        } else if ([value isEqualToString:SR6_AUG_GRADE_BETA_LONG]) {
            return ([NSNumber numberWithInt:kAugGradeBeta]);
        } else if ([value isEqualToString:SR6_AUG_GRADE_DELTA_LONG]) {
            return ([NSNumber numberWithInt:kAugGradeDelta]);
        } else if ([value isEqualToString:SR6_AUG_GRADE_GAMMA_LONG]) {
            return ([NSNumber numberWithInt:kAugGradeGamma]);
        } else if ([value isEqualToString:SR6_AUG_GRADE_OTHER_LONG]) {
            return ([NSNumber numberWithInt:kAugGradeOther]);
        } else {
            return ([NSNumber numberWithInt:kAugGradeNormal]);
        }
    }
}
@end
