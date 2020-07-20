//
//  SR6Program+CoreDataClass.m
//  DBBuilder
//
//  Created by Ed Pichon on 2020/7/04.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6Program.h"

@implementation SR6Program

-(NSString *) tableName {
    if (self.optionName == nil) {
        if (self.category == kProgramCatBasic) {
            return([NSString stringWithFormat:@"%@ [B]",self.name]);
        } else if (self.category == kProgramCatHacking) {
            return([NSString stringWithFormat:@"%@ [H]",self.name]);
        } else {
            return([NSString stringWithFormat:@"%@ [O]",self.name]);
        }
    } else {
        if (self.category == kProgramCatBasic) {
            return([NSString stringWithFormat:@"%@ [B,%@]",self.name,self.optionName]);
        } else if (self.category == kProgramCatHacking) {
            return([NSString stringWithFormat:@"%@ [H,%@]",self.name,self.optionName]);
        } else {
            return([NSString stringWithFormat:@"%@ [O,%@]",self.name,self.optionName]);
        }
    }
}

-(NSString *) summary {
    if (_summary == nil) {
        _summary = self.shortDesc;
    }
    return (_summary);
}

- (NSString *) categoryShortString {
    switch (self.category) {
        case kProgramCatBasic:
            return (SR6_PROGRAM_CAT_BASIC_SHORT);
            break;
        case kProgramCatHacking:
            return (SR6_PROGRAM_CAT_HACKING_SHORT);
            break;
        case kProgramCatAutosoft:
            return (SR6_PROGRAM_CAT_AUTOSOFT_SHORT);
            break;
        case kProgramCatOther:
            return (SR6_PROGRAM_CAT_OTHER_SHORT);
            break;
        default:
            return(@"ERR");
            break;
    }
}

- (NSString *) categoryLongString {
    switch (self.category) {
        case kProgramCatBasic:
            return (SR6_PROGRAM_CAT_BASIC_LONG);
            break;
        case kProgramCatHacking:
            return (SR6_PROGRAM_CAT_HACKING_LONG);
            break;
        case kProgramCatAutosoft:
            return (SR6_PROGRAM_CAT_AUTOSOFT_LONG);
            break;
        case kProgramCatOther:
            return (SR6_PROGRAM_CAT_OTHER_LONG);
            break;
        default:
            return(@"ERR");
            break;
    }
}

@end
