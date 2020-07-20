//
//  DataToAttrString.m
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/6/17.
//  Copyright © 2020 Ed Pichon.
/* This file is part of the SRCombatTool.

SRCombatTool is free software: you can redistribute it and/or modify
it under the terms of the Creative Commons 4.0 license - BY-NC-SA.

SRCombatTool is distributed in the hope that it will be useful,
but without any warranty.

*/
#import "DataToAttrString.h"

@implementation DataToAttrString

-(id)transformedValue:(id)value {
    // Data to attributed string.
    if (value == nil) {
        return nil;
    } else {
        NSData * tmp= [super transformedValue:value];
        return (tmp);
    }
}

-(id)reverseTransformedValue:(id)value {
    // String to data.
    if (value == nil) {
        return nil;
    }
    return [super reverseTransformedValue:value];
}

@end
