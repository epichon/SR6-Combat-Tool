//
//  SR6Mentor+CoreDataClass.m
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/02.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//
//

#import "SR6Mentor.h"

@implementation SR6Mentor

-(NSString *) tableName {
    if (self.optionName == nil) {
        return(self.name);
    } else {
        return([NSString stringWithFormat:@"%@ [%@]",self.name,self.optionName]);
    }
}

-(NSString *) summary {
    return self.shortDesc;
}

@end
