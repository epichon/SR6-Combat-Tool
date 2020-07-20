//
//  ImagePanelController.h
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
// This is a window that shows an actor image at large scale to show to the players.
// Nothing really fancy...

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImagePanelController : NSWindowController {
    IBOutlet NSImageView *imageView;
    NSImage *panelImage;
}
- (IBAction)closeWindow:(id)sender;

@property (readwrite) NSImage *panelImage;

@end

NS_ASSUME_NONNULL_END
