//
//  ImagePanelController.m
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
#import "ImagePanelController.h"

@interface ImagePanelController ()

@end

@implementation ImagePanelController

@synthesize panelImage;

-(id)init {
    if (![super initWithWindowNibName:@"ImagePanelController"]) return nil;
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)closeWindow:(id)sender {
    // Close out the screen.
    [self close];
}

-(IBAction) showWindow:(id)sender {
    // The only tricky bit is this, where we scale things up.
    // Rather than go full screen, or a simple 2x multiple of the original image, we work out the
    // size algorithmically - double the size of the base image, and see if we fit inside the
    // current screen. If we do, double again, and repeat until we don't fit.
    
    [super showWindow:sender];
    
    
    // Make the size match the image size.
    
    // Get the size of the image and the screen size
    NSSize imageSize = panelImage.size;
    NSRect screenSize = [[NSScreen mainScreen] frame];
    NSRect windowSize = self.window.frame;
    NSRect tempSize;
    tempSize.size.width = imageSize.width;
    tempSize.size.height = imageSize.height;
    
    
    // Double the size of the window until we are just under the screen limit.
    // The +40 bit is to cover the edges/controls on the window, and to give us a wee bit of padding.
    while ((tempSize.size.width+40) < screenSize.size.width & (tempSize.size.height+40) < screenSize.size.height) {
        windowSize = tempSize;
        tempSize.size.width = 2*tempSize.size.width;
        tempSize.size.height = 2*tempSize.size.height;
    }
    
    
    // Now, figure out the origin. We default to the center.
    windowSize.origin.x = (screenSize.size.width - windowSize.size.width)/2;
    windowSize.origin.y = (screenSize.size.height - windowSize.size.height)/2;
    
    [self.window setFrame:windowSize display:YES animate:NO];
}

@end
