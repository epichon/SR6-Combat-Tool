//
//  SR6Echo+CoreDataClass.m
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/02.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6Echo.h"

@implementation SR6Echo

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
            _summary = [NSString stringWithFormat:@"Leveled, %@",self.shortDesc];
        } else {
            _summary = self.shortDesc;
        }
    }
    return _summary;
}

@end
