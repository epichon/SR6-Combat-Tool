//
//  BoolToRedColor.m
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/7/10.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//

#import "BoolToRedColor.h"
#import <AppKit/AppKit.h>

@implementation BoolToRedColor

-(id)transformedValue:(id)value {
    BOOL enabled = (BOOL) [value intValue];
    
    if (enabled) {
        return ([NSColor labelColor]);
    } else {
        return ([NSColor redColor]);
    }
}

@end
