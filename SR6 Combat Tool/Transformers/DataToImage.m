//
//  DataToImage.m
//  SR6 Combat Tool
//
//  Created by Ed Pichon on 2020/6/05.
//  Copyright © 2020 Ed Pichon.
/* This file is part of the SRCombatTool.

SRCombatTool is free software: you can redistribute it and/or modify
it under the terms of the Creative Commons 4.0 license - BY-NC-SA.

SRCombatTool is distributed in the hope that it will be useful,
but without any warranty.

*/
#import "DataToImage.h"

@implementation DataToImage

+(BOOL)allowsReverseTransformation {
    
    return YES;
}
 
+(Class)transformedValueClass {
    
    return [NSData class];
}
 
- (id)transformedValue:(id)value {
    // takes data and returns it as an image
    NSImage *imageRep = [[NSImage alloc] initWithData:value];
    return imageRep;
}
 
- (id)reverseTransformedValue:(id)value {
    NSData *data = [value TIFFRepresentation];
    return data;
    
}
@end
