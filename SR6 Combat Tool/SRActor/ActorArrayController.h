//
//  ActorArrayController.h
//  SR5 Combat Tool
//
//  Created by Ed Pichon on 29/6/2018.
//  Copyright © 2020 Ed Pichon.
/* This file is part of the SRCombatTool.

SRCombatTool is free software: you can redistribute it and/or modify
it under the terms of the Creative Commons 4.0 license - BY-NC-SA.

SRCombatTool is distributed in the hope that it will be useful,
but without any warranty.

*/

/* This is the controller for the array of actors. It's a little more complicated than usual, because we
 effectively have two different types of selections to worry about:
 - The selection - as in, what array controllers normally deal with, the row in the table that the user has clicked on.
 - The active entry - the active actor is the actor whose turn it is in a combat. The controls about making "active" are about shifting this bit about. It's tracked
   as the indexActiveActor and activeActorObject. Could probably just go by the object, but it works, and I'm not touching it.
 - The selection is handled by the built in methods, with the "Active" bit overlaid.
 
 The ActorArrayController also handles the table of statuses as a data source and delegate.
 
 This was originally written for SR4, where initiative was a lot more complicated, so there may be some echoes of that in how this is structured.
 I'm more-or-less self-taught for Cocoa, so there are probably much more efficient ways to do things, but it's what I could figure out.
 
 */


#import <Cocoa/Cocoa.h>

@class SR6Actor;

@interface ActorArrayController : NSArrayController <NSTableViewDelegate, NSTableViewDataSource, NSSearchFieldDelegate, NSComboBoxDataSource> {
    IBOutlet NSTableView *actorTable; // A reference to the main actor table.
    IBOutlet NSTableView *statusTable; //A reference to the statusTable.
    __weak IBOutlet NSComboBox *cbMentorSelector;
    __weak IBOutlet NSArrayController *MentorsSourceArrayController;
    
    NSArray *_statusTypes; // The array of status types.
    
    NSAttributedString *_copiedData; // A hack to get around the problem of the data not going into the dictionary.
    SR6Actor *_statusCopySource; // A pointer to the SR6Actor that has been marked for copying statuses from.
}

// The various actions that the actor array needs to handle. Actor selections, and ticking over combat rounds.
- (IBAction) activateNextActor: (id) sender;
- (IBAction) activatePrevActor: (id) sender;
- (IBAction) setSelectedAsActiveActor: (id) sender;
- (IBAction) resetActiveActor: (id)sender;
- (IBAction) newRound: (id) sender;
- (IBAction) newCombat: (id) sender;
- (IBAction) rollSurprises:(id) sender;
- (IBAction) rollPerceptions:(id) sender;
- (IBAction) rollStealths:(id) sender;
- (IBAction) rollInits:(id) sender;

// Copy/paste support
-(IBAction) cut: (id)sender;
-(IBAction) copy: (id)sender;
-(IBAction) paste: (id)sender;
-(IBAction) copyStatus:(id)sender;
-(IBAction) pasteStatus:(id)sender;


- (IBAction)mentorSelected:(id)sender;
- (void)selectMentor;

- (IBAction) setMatrixDefaultsCommlink:(id) sender;
- (IBAction) setMatrixDefaultsCyberjack:(id) sender;
- (IBAction) setMatrixDefaultsRCC:(id) sender;

- (IBAction) setTMDefaults:(id) sender;
- (IBAction) setTMDerived:(id) sender;

- (void) sortByInit; // Sort the table view.
- (void) resortTableByInit; // Does a full rebuild of the table view.
- (NSArray *)statusTypes; // The list of possible statuses.

@property NSUInteger indexActiveActor;
@property NSManagedObject *activeActorObject;

-(BOOL) actorSelected; // Is an actor selected. Used for updating the UI.
-(void) selectActiveActor; // A simple method to make the Active Actor the selected actor.
-(void) selectLastActor; // A simple method to make the selected actor the final entry in the table.

@property (readwrite) BOOL canMakeNextActive;
@property (readwrite) BOOL canMakePrevActive;
@property (readwrite) SR6Actor *statusCopySource;

@end
