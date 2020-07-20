//
//  SR6Aug+CoreDataClass.m
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/03.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6Aug.h"

@implementation SR6Aug

-(NSString *) tableName {
    if (self.optionName == nil) {
        if (self.level) {
            return([NSString stringWithFormat:@"%@ [L]",self.name]);
        } else {
            return self.name;
        }
    } else {
        if (self.level) {
            return([NSString stringWithFormat:@"%@ [L,%@]",self.name,self.optionName]);
        } else {
            return([NSString stringWithFormat:@"%@ [%@]",self.name,self.optionName]);
        }
    }
}

-(NSString *) summary {
    if (_summary == nil) {
        _summary = [NSString stringWithFormat:@"%@",self.categoryShortString];
    }
    return (_summary);
}

- (NSString *) categoryShortString {
    switch (self.category) {
        case kAugCatHeadware:
            return (SR6_AUG_CAT_HEADWARE_SHORT);
            break;
        case kAugCatEyeware:
            return (SR6_AUG_CAT_EYEWARE_SHORT);
            break;
        case kAugCatEarware:
            return (SR6_AUG_CAT_EARWARE_SHORT);
            break;
        case kAugCatBodyware:
            return (SR6_AUG_CAT_BODYWARE_SHORT);
            break;
        case kAugCatCyberlimb:
            return (SR6_AUG_CAT_CYBERLIMB_SHORT);
            break;
        case kAugCatBioware:
            return (SR6_AUG_CAT_BIOWARE_SHORT);
            break;
        case kAugCatCulturedBioware:
            return (SR6_AUG_CAT_CULTURED_BIOWARE_SHORT);
            break;
        case kAugCatGeneware:
            return (SR6_AUG_CAT_GENEWARE_SHORT);
            break;
        case kAugCatNanoware:
            return (SR6_AUG_CAT_NANOWARE_SHORT);
            break;
        case kAugCatOther:
            return (SR6_AUG_CAT_OTHER_SHORT);
            break;
        default:
            return(@"ERR");
            break;
    }
}

- (NSString *) categoryLongString {
    switch (self.category) {
        case kAugCatHeadware:
            return (SR6_AUG_CAT_HEADWARE_LONG);
            break;
        case kAugCatEyeware:
            return (SR6_AUG_CAT_EYEWARE_LONG);
            break;
        case kAugCatEarware:
            return (SR6_AUG_CAT_EARWARE_LONG);
            break;
        case kAugCatBodyware:
            return (SR6_AUG_CAT_BODYWARE_LONG);
            break;
        case kAugCatCyberlimb:
            return (SR6_AUG_CAT_CYBERLIMB_LONG);
            break;
        case kAugCatBioware:
            return (SR6_AUG_CAT_BIOWARE_LONG);
            break;
        case kAugCatCulturedBioware:
            return (SR6_AUG_CAT_CULTURED_BIOWARE_LONG);
            break;
        case kAugCatGeneware:
            return (SR6_AUG_CAT_GENEWARE_LONG);
            break;
        case kAugCatNanoware:
            return (SR6_AUG_CAT_NANOWARE_LONG);
            break;
        case kAugCatOther:
            return (SR6_AUG_CAT_OTHER_LONG);
            break;
        default:
            return(@"ERR");
            break;
    }
}

- (NSString *) availLetterShortString {
    switch (self.availLetter) {
        case kAvailLegal:
            return (SR6_AVAIL_LEGAL_SHORT);
            break;
        case kAvailLicense:
            return (SR6_AVAIL_LICENSE_SHORT);
            break;
        case kAvailIllegal:
            return (SR6_AVAIL_ILLEGAL_SHORT);
            break;
        case kAvailSpecial:
            return (SR6_AVAIL_SPECIAL_SHORT);
            break;
        default:
            return(@"ERR");
            break;
    }
}

- (NSString *) availLetterLongString {
    switch (self.availLetter) {
        case kAvailLegal:
            return (SR6_AVAIL_LEGAL_LONG);
            break;
        case kAvailLicense:
            return (SR6_AVAIL_LICENSE_LONG);
            break;
        case kAvailIllegal:
            return (SR6_AVAIL_ILLEGAL_LONG);
            break;
        case kAvailSpecial:
            return (SR6_AVAIL_SPECIAL_LONG);
            break;
        default:
            return(@"ERR");
            break;
    }
}

- (NSString *) availFullString {
    return ([NSString stringWithFormat:@"%d%@",self.availNumber, self.availLetterShortString]);
}

@end
