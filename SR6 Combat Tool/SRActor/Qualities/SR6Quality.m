//
//  SR6Quality+CoreDataClass.m
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/01.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6Quality.h"

@implementation SR6Quality

-(NSString *) tableName {
    if (self.optionName == nil) {
        return(self.name);
    } else {
        return([NSString stringWithFormat:@"%@ [%@]",self.name,self.optionName]);
    }
}

-(NSString *) negativeShortString {
    if (self.negative == FALSE) {
        return(@"Pos");
    } else {
        return(@"Neg");
    }
}

-(NSString *) negativeLongString {
    if (self.negative == FALSE) {
        return(@"Positive");
    } else {
        return(@"Negative");
    }
}


-(NSString *) summary {
    if (_summary == nil) {
        if (self.negative == FALSE) {
            _summary = [NSString stringWithFormat:@"Pos. Qual. %d karma",self.karma];
        } else {
            _summary = [NSString stringWithFormat:@"Neg. Qual. %d karma",self.karma];
        }
    }
    return _summary;
}

@end
