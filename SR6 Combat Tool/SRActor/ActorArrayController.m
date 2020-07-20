//
//  ActorArrayController.m
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

#import "ActorArrayController.h"
#import "SR6Actor.h"
#import "SR6Mentor.h"
#import "Document.h"

@interface ActorArrayController()  {
    int16_t _oldMetatype;
}
-(bool) readFromPasteboard: (NSPasteboard *) pb;
-(void) writeToPasteboard: (NSPasteboard *) pb;
-(void) checkNextPrev; // A utility method for udpating the status of the canMakeNextActive and PrevActive results.
@end

@implementation ActorArrayController

@synthesize indexActiveActor;
@synthesize activeActorObject;
@synthesize canMakeNextActive;
@synthesize canMakePrevActive;
@synthesize statusCopySource;

#pragma mark - Core utility methods

-(void)awakeFromNib {
    // We need to set the active actor when we first start up. We do that here.
    [super awakeFromNib]; // Really important.
    [self fetchWithRequest:nil merge:NO error:nil]; // Force a fetch so that we have something to work with.
    //[self resetActiveActor:self];
    
    _oldMetatype = 0;
}

-(NSArray *) statusTypes {
    // Build the array if we need it, and haven't done it yet.
    if (_statusTypes == nil) {
        _statusTypes = [NSArray arrayWithObjects:SR6_STATUS_BACKGROUND, SR6_STATUS_BLINDED, SR6_STATUS_BURNING, SR6_STATUS_CHILLED, SR6_STATUS_CONFUSED, SR6_STATUS_CORROSSIVE, SR6_STATUS_COVER, SR6_STATUS_DAZED, SR6_STATUS_DEAFENED, SR6_STATUS_DISABLED_ARM, SR6_STATUS_DISABLED_LEG, SR6_STATUS_FATIGUED, SR6_STATUS_FRIGHTENED, SR6_STATUS_HAZED, SR6_STATUS_HOBBLED, SR6_STATUS_IMMOBILIZED, SR6_STATUS_INVISIBLE, SR6_STATUS_INVISIBLE_IMP,SR6_STATUS_MUTED,SR6_STATUS_NAUSEATED, SR6_STATUS_NOISE, SR6_STATUS_OFF_BALANCE, SR6_STATUS_PANICKED, SR6_STATUS_PETRIFIED, SR6_STATUS_POISONED, SR6_STATUS_PRONE, SR6_STATUS_SILENT, SR6_STATUS_SILENT_IMP, SR6_STATUS_STILLED, SR6_STATUS_WET, SR6_STATUS_ZAPPED, nil];
    }
    return (_statusTypes);
}

-(void) sortByInit {
    // Sort the status table by the current adjusted initiative.
    NSSortDescriptor *aSorter;
    
    aSorter = [[NSSortDescriptor alloc] initWithKey:@"initiativeScoreAdjusted" ascending: NO];
    [actorTable setSortDescriptors:[NSArray arrayWithObject:aSorter]];
}

- (void) resortTableByInit {
    // Sort the table by initaitives, as things may have moved around.
    
    [actorTable reloadData];
    
    //Sort the table back and forth, to force the sort.
    NSSortDescriptor *aSorter;
    aSorter = [[NSSortDescriptor alloc] initWithKey:@"initiativeScoreAdjusted" ascending: YES];
    [actorTable setSortDescriptors:[NSArray arrayWithObject:aSorter]];
    [self sortByInit];
    
    // Highlight the current actor
    //[self activeActorObject:[[self selectedObjects] firstObject]];
    //[self checkNextPrev];
    
    [self sortByInit];
}

#pragma mark Object Manipulation

- (IBAction)mentorSelected:(id)sender {
    // Figure this out, eh>
    NSComboBox *myCB = (NSComboBox *)sender;
    SR6Mentor *myMentor = [[MentorsSourceArrayController arrangedObjects] objectAtIndex:myCB.indexOfSelectedItem];
    //NSLog(@"Selected Mentor: %@ %@", myMentor.name, myMentor.mentorUUID);
    SR6Actor *myActor = (SR6Actor *)[[self selectedObjects] firstObject];
    [myActor clearMentor];
    //NSLog(@"myMentor UUID: %@",myMentor.mentorUUID);
    myActor.mentorUUID = myMentor.mentorUUID;
    //NSLog(@"myActor UUID: %@",myActor.mentorUUID);
    
    //NSLog(@"Mentor Name: %@ %@ %@ %@",myActor.mentor.name, myActor.mentor.mentorUUID, myActor.mentor.longDesc, myMentor.mentorUUID);
}

-(void)selectMentor {
    // This can get called early on, before the combox is actually loaded.
    if (cbMentorSelector.numberOfItems == 0) return;
    SR6Actor *myActor = (SR6Actor *)[[self selectedObjects] firstObject];
    SR6Mentor *myMentor = myActor.mentor;
    if (myMentor != nil){
        cbMentorSelector.stringValue = myMentor.name;
    } else {
        [cbMentorSelector selectItemAtIndex:0];
    }
}

- (IBAction) setMatrixDefaultsCommlink:(id) sender {
    SR6Actor *myActor = (SR6Actor *)[[self selectedObjects] firstObject];
    [myActor setMatrixDefaultsCommlink];
}

- (IBAction) setMatrixDefaultsCyberjack:(id) sender {
    SR6Actor *myActor = (SR6Actor *)[[self selectedObjects] firstObject];
    [myActor setMatrixDefaultsCyberdeck];
}

- (IBAction) setMatrixDefaultsRCC:(id) sender  {
    SR6Actor *myActor = (SR6Actor *)[[self selectedObjects] firstObject];
    [myActor setMatrixDefaultsRCC];
}

- (IBAction) setTMDefaults:(id) sender  {
    SR6Actor *myActor = (SR6Actor *)[[self selectedObjects] firstObject];
    [myActor setTMDefaults];
}

- (IBAction) setTMDerived:(id) sender  {
    SR6Actor *myActor = (SR6Actor *)[[self selectedObjects] firstObject];
    [myActor setTMDerived];
}


#pragma mark - Active Actor manipulation

-(IBAction) activateNextActor: (id)sender {
    // Figure out who the next actor is and select it.
    // If we are at the end, do nothing.
    
    [[[self managedObjectContext] undoManager] beginUndoGrouping];
    [[[self managedObjectContext] undoManager] setActionName:@"Next Actor"];
    if (self.indexActiveActor < [[self content] count]-1) { // We are not at the end...
        
        // set the selected object to the current object and then select the next one?
        [self setSelectionIndex:indexActiveActor+1];
        self.indexActiveActor= [self selectionIndex];
        
        // Highlight the current actor
        [self activeActorObject:[[self selectedObjects] firstObject]];
        // Make sure the current row is visible.
        [actorTable scrollRowToVisible:[self indexActiveActor]];
        
        [self checkNextPrev];
    }
    [[[self managedObjectContext] undoManager] endUndoGrouping];
}

-(IBAction) activatePrevActor: (id)sender {
    // Figure out who the previous actor was and select it.
    // We do this by decreasing the indexActiveActor by 1.
    // If we are at the top, do nothing.
    
    [[[self managedObjectContext] undoManager] beginUndoGrouping];
    [[[self managedObjectContext] undoManager] setActionName:@"Prev Actor"];
    
    if (self.indexActiveActor != 0) {
        // We are somewhere in the middle, so go back one.
        [self setSelectionIndex:indexActiveActor-1];
        self.indexActiveActor= [self selectionIndex];
        
        // Highlight the current actor
        [self activeActorObject:[[self selectedObjects] firstObject]];
        
        // Make sure the current row is visible.                    
        [actorTable scrollRowToVisible:[self indexActiveActor]];
        
        [self checkNextPrev];
    }
    [[[self managedObjectContext] undoManager] endUndoGrouping];
}

-(void) activeActorObject:(NSManagedObject *)newActiveActor {
    // Set the new active actor. We don't use the normal setter, because we can get here before the managed object is entirely ready.
    // Basic function is to set the boolean "isActiveActor" flag to false on the old one, and true on the new one.
    [activeActorObject setValue:[NSNumber numberWithBool:FALSE] forKey:@"isActiveActor"];
    activeActorObject = newActiveActor;
    [activeActorObject setValue:[NSNumber numberWithBool:TRUE] forKey:@"isActiveActor"];
}

-(IBAction) setSelectedAsActiveActor:(id)sender {
    // Make the currently selected actor the Active Actor.
    [[[self managedObjectContext] undoManager] beginUndoGrouping];
    [[[self managedObjectContext] undoManager] setActionName:@"Set Current Actor"];
    
    self.indexActiveActor= [self selectionIndex];
    [self activeActorObject:(SR6Actor *)[[self arrangedObjects] objectAtIndex:[self selectionIndex]]];
    // Make sure the current row is visible.
    [actorTable scrollRowToVisible:[self indexActiveActor]];
    [self checkNextPrev];
    
    [[[self managedObjectContext] undoManager] endUndoGrouping];
}

- (IBAction) resetActiveActor: (id)sender {
    // This method should be called when the array is first loaded up.
    // The purpose is to clear the "isActiveActor" setting on all the actors,
    // and then select the first one.
    // This may not be strictly necessary anymore, as the isActiveActor flag is no longer saved to the data model.
    // However, it works, and it was painful, so I'm not touching it.
    
    // So, we go through the content.
    NSUInteger counter;
    SR6Actor *anActor;
    if ([[self arrangedObjects] count] >0) {
        for (counter = 0; counter < [[self content] count]; counter ++) {
            anActor = [[self content] objectAtIndex:counter];
            [anActor setValue:[NSNumber numberWithBool:FALSE] forKey:@"isActiveActor"];
        }
        //Sort it.
        [self sortByInit];
        
        // Now, make the first entry the current actor;
        // Select the top record.
        [self setSelectionIndex: 0];
        self.indexActiveActor = 0;
        // Highlight the current actor
        [self activeActorObject:[[self arrangedObjects] firstObject]];
        // Make sure the current row is visible.
        [actorTable scrollRowToVisible:[self indexActiveActor]];
        [self checkNextPrev];
    }
}

-(void)selectActiveActor {
    // Select the active actor in the table view.
    [actorTable  selectRowIndexes:[NSIndexSet indexSetWithIndex:self.indexActiveActor] byExtendingSelection:NO];
    // Make sure the current row is visible.
    [actorTable scrollRowToVisible:[self indexActiveActor]];
}


-(IBAction) remove:(id) sender {
    // We are overriding, because if we are deleting the active character, we need to shift the active character down one.
    NSManagedObject *anActor;
    
    [[[self managedObjectContext] undoManager] beginUndoGrouping];
    [[[self managedObjectContext] undoManager] setActionName:@"Undo Remove"];
    
    anActor = [[self selectedObjects] firstObject];
    
    // If the current actor is the active actor, skip forward one.
    if (anActor == activeActorObject) {
        [super remove:sender];
        [self activateNextActor:sender];
    } else {
        [super remove:sender];
    }
    
    // Update the UI interfaces
    [statusTable reloadData];
    [self checkNextPrev];
    [[[self managedObjectContext] undoManager] endUndoGrouping];
}

#pragma mark - Group Roll Codes

- (IBAction) rollInits:(id) sender {
    // This method rolls surprise tests for all actors in the set.
    NSUInteger counter;
    
    // Go through the array, and roll surprise.
    SR6Actor *anActor;
    if ([[self arrangedObjects] count] >0) {
        for (counter = 0; counter < [[self content] count]; counter ++) {
            anActor = [[self content] objectAtIndex:counter];
            [anActor rollInit];
        }
    }
    
    // Sort the table as a courtesy.
    [self resortTableByInit];
}

- (IBAction) rollSurprises:(id) sender {
    // This method rolls surprise tests for all actors in the set.
    NSUInteger counter;
    
    // Go through the array, and roll surprise.
    SR6Actor *anActor;
    if ([[self arrangedObjects] count] >0) {
        for (counter = 0; counter < [[self content] count]; counter ++) {
            anActor = [[self content] objectAtIndex:counter];
            [anActor rollSurprise];
        }
    }
    
}

- (IBAction) rollPerceptions:(id) sender {
    // This method rolls perception tests for all actors in the set.
    NSUInteger counter;
    
    // Go through the array, and roll surprise.
    SR6Actor *anActor;
    if ([[self arrangedObjects] count] >0) {
        for (counter = 0; counter < [[self content] count]; counter ++) {
            anActor = [[self content] objectAtIndex:counter];
            [anActor rollPerception];
        }
    }
   
}

- (IBAction) rollStealths:(id) sender {
    // This method rolls stealth tests for all actors in the set.
    NSUInteger counter;
    
    // Go through the array, and roll surprise.
    SR6Actor *anActor;
    if ([[self arrangedObjects] count] >0) {
        for (counter = 0; counter < [[self content] count]; counter ++) {
            anActor = [[self content] objectAtIndex:counter];
            [anActor rollStealth];
        }
    }
    
}

#pragma mark - Initiative rolling and combat methods.

-(IBAction) newCombat:(id)sender {
    // Roll initiative for all actors in the pool, and prepare for the new combat.
    NSMutableArray *actors;
    SR6Actor *anActor;
    
    // First we want to confirm with the user.
    NSAlert *alert = [[NSAlert alloc] init];
    alert.alertStyle = NSAlertStyleWarning;
    alert.messageText = @"Confirm New Combat";
    alert.informativeText =@"This will reroll all initiatives, remove all damage, sets Edge to the stat, resets overwatch scores, sets all speeds to 0, and clear all statuses from all actors.";
    [alert addButtonWithTitle:@"Ok"];
    [alert addButtonWithTitle:@"Cancel"];
    NSModalResponse response = [alert runModal];
    
    if (response == 1000) {
        // Setup the undo.
        [[[self managedObjectContext] undoManager] beginUndoGrouping];
        [[[self managedObjectContext] undoManager] setActionName:@"New Combat"];
        
        // Roll the init dice for everybody.
        actors = [self content];
        for (int x = 0; x < [actors count]; x ++) {
            anActor = [actors objectAtIndex:x];
            [anActor rollInit];
            [anActor clearDamage];
            [anActor clearStatuses];
            anActor.currentEdge = anActor.attrEdge;
            anActor.currentSpeed = 0;
            anActor.overwatchScore = 0;
        }
        
        // Sort the table by initaitives, as things may have moved around.
        
        [actorTable reloadData];
        
        //Sort the table back and forth, to force the sort.
        NSSortDescriptor *aSorter;
        aSorter = [[NSSortDescriptor alloc] initWithKey:@"initiativeScoreAdjusted" ascending: YES];
        [actorTable setSortDescriptors:[NSArray arrayWithObject:aSorter]];
        [self sortByInit];
        
        // Select the top record.
        [self setSelectionIndex: 0];
        self.indexActiveActor = [self selectionIndex];
        
        // Highlight the current actor
        [self activeActorObject:[[self selectedObjects] firstObject]];
        [self checkNextPrev];
        
        [self sortByInit];
        [[[self managedObjectContext] undoManager] endUndoGrouping];
    }
}

-(IBAction) newRound:(id) sender {
    // For the new round, scan through the list of actors, and call newRound
    // This will take care of anything that needs to be done.
    // Note: In SR6, initiatives are not rerolled with each round.
    NSMutableArray *actors;
    SR6Actor *anActor;
    
    // First we want to confirm with the user.
    NSAlert *alert = [[NSAlert alloc] init];
    alert.alertStyle = NSAlertStyleWarning;
    alert.messageText = @"Confirm New Round";
    alert.informativeText =@"This will decrement statuses as appropriate and move to the first actor.";
    [alert addButtonWithTitle:@"Ok"];
    [alert addButtonWithTitle:@"Cancel"];
    NSModalResponse response = [alert runModal];
    
    if (response == 1000) {
        // Setup the undo.
        [[[self managedObjectContext] undoManager] beginUndoGrouping];
        [[[self managedObjectContext] undoManager] setActionName:@"New Round"];

        // Run the new round on each actor
        actors = [self content];
        for (int x = 0; x < [actors count]; x ++) {
            anActor = [actors objectAtIndex:x];
            [anActor newRound];
        }
        [actorTable reloadData];
        [statusTable reloadData];
        //Sort it.
        [self sortByInit];
        
        // Select the top record.
        [self setSelectionIndex: 0];
        self.indexActiveActor = [self selectionIndex];
        // Make sure the current row is visible.
        [actorTable scrollRowToVisible:[self indexActiveActor]];
        
        // Highlight the current actor
        [self activeActorObject:[[self selectedObjects] firstObject]];
        [self checkNextPrev];
        [[[self managedObjectContext] undoManager] endUndoGrouping];
    }
}

#pragma mark - Control status booleans

-(void)checkNextPrev {
    // The previous is good, if we are not at the first entry.
    self.canMakePrevActive = (indexActiveActor != 0);
    self.canMakeNextActive = (indexActiveActor < ([[self arrangedObjects] count] -1));
}

-(BOOL) actorSelected {
    // Returns if there is an actor selected.
    if ((int)[self selectionIndex] == -1) {
        return (FALSE);
    } else {
        return (TRUE);
    }
}

#pragma mark - Status Table Delegate Code

-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    // Get the number of rows in the status array of the current object.
    int tmp;
    tmp = (int)[self selectionIndex];
    if ((int)[self selectionIndex] == -1) {
        return 0;
    } else {
        return ([[(SR6Actor *)[[self arrangedObjects] objectAtIndex:[self selectionIndex]] statusArray] count] );
    }
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSArray *aStatus;
    // populate each row of our table view with data
    // display a different value depending on each column (as identified in XIB)
    if ((int)[self selectionIndex] == -1) {
        return (@"");
    } else {
        aStatus = [[(SR6Actor *)[[self arrangedObjects] objectAtIndex:[self selectionIndex]] statusArray] objectAtIndex:row];
        if ([tableColumn.identifier isEqualToString:@"Status"]) {
            // first colum (status name)
            return [aStatus objectAtIndex:0];
        } else if ([tableColumn.identifier isEqualToString:@"Rtg"]){
            // second column (rating)
            return [aStatus objectAtIndex:1];
        } else {
            // second column (duration)
            return [aStatus objectAtIndex:2];
        }
    }
}

#pragma mark - Combo box delegate methods

// This is the delegate for the status-setting combo box.
// Note - I tried using list views, but as soon as I wired up an action in response, it started disabling entries. The action didn't ahve to do
// anything - it could be nothing but an empty method - but it causes the list view to go haywaire (adding checks, disabling entries, etc.)
// So...a combo box it is!
-(NSInteger)numberOfItemsInComboBox:(NSComboBox *)comboBox {
    return (self.statusTypes.count);
}

-(id)comboBox:(NSComboBox *)comboBox objectValueForItemAtIndex:(NSInteger)index {
    return ([self.statusTypes objectAtIndex:index]);
}


#pragma mark - Search Delegate Methods

-(void)searchFieldDidStartSearching:(NSSearchField *)sender {
    // Get the search string.
    NSString *sSearch = [NSString stringWithFormat:@"*%@*",sender.stringValue];

    // Filter the array.
    NSPredicate *myPred = [NSPredicate predicateWithFormat:@"charName like[cd] %@",sSearch];
    self.filterPredicate = myPred;
}

- (void)searchFieldDidEndSearching:(NSSearchField *)sender {
    self.filterPredicate = nil;
}

#pragma mark - Copy/Paste Support

// Copy/paste is supported using the built-in pasteboard. The Actor is encoded as a dictionary, and the dictionary turned
// into a data object placed on the pasteboard.

-(IBAction) copyStatus:(id)sender {
    SR6Actor *tmp =(SR6Actor *)[[self selectedObjects] firstObject];
    self.statusCopySource = tmp;
}

-(IBAction) pasteStatus:(id)sender {
    if (self.statusCopySource != nil) {
        [(SR6Actor *)[[self selectedObjects] firstObject] pasteStatuses:self.statusCopySource];
    }
    [statusTable reloadData];
    // We also need to reload the row in the table view, we've changed that string as well.
    [actorTable reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:[actorTable selectedRow]] columnIndexes:[NSIndexSet indexSetWithIndex:7]];
}

-(IBAction) cut:(id)sender{
    [self copy:sender];
    [self remove:sender];
}

-(IBAction) copy:(id)sender {
    // We can't copy if there are not items in the managed context.
    if ([[self arrangedObjects] count] == 0) return;
    
    NSPasteboard *pb = [NSPasteboard generalPasteboard];
    [self writeToPasteboard:pb];
}

-(IBAction) paste: (id)sender {
    [self readFromPasteboard:[NSPasteboard generalPasteboard]];
    
}

-(bool) readFromPasteboard: (NSPasteboard *) pb  {
    NSArray *pbTypes;
    NSData *dataTmp;
    //NSAttributedString *tmpString;
    NSDictionary *dictTmp;
    NSError *error;
    SR6Actor *newActor;
    
    pbTypes = [pb types];
    
    // Check the type from the pasteboard.
    if ([pbTypes containsObject:@"sr6actordata"]){
        
        // Grab the data object from the pasteboard, and then unarchive it into the dictionary object.
        dataTmp = [pb dataForType:@"sr6actordata"];
        dictTmp = [NSKeyedUnarchiver unarchivedObjectOfClasses:[NSSet setWithArray:[NSArray arrayWithObjects: NSDictionary.class,NSMutableString.class,nil]] fromData:dataTmp error:&error];
        
        if (dictTmp == nil) {
            // There was an error, bail.
            // There is a bug in the keyed unarchiver, that sometimes it barfs and says it's not the expected object.
            // It is, but it toggles back and forth between NSMutableString and NSDictionary. So, we cheat. It throws a warning, but what am I going to do.
            // Allowing class NSMutableString in the above call seems to have resolved this, but I'm keeping it anyway.
            NSLog(@"readFromPasteboard: unarchive went wonky: %ld %@ %@",error.code, error.domain, error.userInfo);
            error = nil;
            
            NSObject *tmp = [NSKeyedUnarchiver unarchivedObjectOfClass:NSObject.class fromData:dataTmp error:&error];
            dictTmp = (NSDictionary *)tmp;
            if (dictTmp == nil) {
                NSLog(@"readFromPasteboard: unarchive went wonky: %ld %@ %@",error.code, error.domain, error.userInfo);
                NSLog(@"Decode still failed on fallback. Boned!");
                return (false);
            }
        }
        
        // This is a hack to get around the details attributed string causing problems in the unarchiver.
        // This made the bug mentioned just above happen pretty reliably. Doing it separately made it
        // slightly less frequent. The workaround above may make this unnecessary, but it works,
        // and since there are weird behaviors going on in AppKit, I'm calling it a win.
        if([pbTypes containsObject: @"sr6actordetails"]){
            dataTmp = [pb dataForType:@"sr6actordetails"];
            if ([[dataTmp className] isEqualToString:@"_NSZeroData"]) {
                // If the detail view is an empty string, the decode throws an error, so we are going to
                // cheat it a bit.
                dataTmp = nil;
            }
        }
        // Add a new managed object to the array.
        newActor = (SR6Actor *)[self newObject];
        newActor.detailString = dataTmp;
        [newActor loadFromDictionary:dictTmp];
        // Add (Copy) to the Name
        newActor.charName = [NSString stringWithFormat:@"%@ (Copy)",newActor.charName];
        
        // Select the last actor (which is the one we just added) but after the table has had time to process is.
        [self performSelector: @selector(selectLastActor) withObject:self afterDelay:0];
        
        return (newActor);
        
    } else {
        return (FALSE);
    }
    
    
}

-(void)selectLastActor {
    NSUInteger tmp = (NSUInteger) [actorTable numberOfRows];
    [actorTable selectRowIndexes:[NSIndexSet indexSetWithIndex:tmp-1] byExtendingSelection:NO];
    [actorTable scrollRowToVisible:(NSInteger) tmp-1];
}

-(void)writeToPasteboard:(NSPasteboard *)pb {
    SR6Actor *curActor;
    NSDictionary *tmpDictionary;
    NSData *tmpData;
    NSError *error;
    //NSAttributedString *tmpString;
    
    // We can't copy if there are no items in the managed context.
    if ([[self arrangedObjects] count] == 0) return;
    
    // Clear the pasteboard;
    [pb clearContents];
    
    // Declare types
    [pb declareTypes:[NSArray arrayWithObjects:@"sr6actordata", @"sr6actordetails",nil] owner:self];
    
    // Get the actor, get the dictionary form, turn it into NSData and put it in the pasteboard.
    curActor = (SR6Actor *)[[self arrangedObjects] objectAtIndex:[self selectionIndex]];
    tmpDictionary = [curActor actorAsDictionary];
    
    tmpData = [NSKeyedArchiver archivedDataWithRootObject:tmpDictionary requiringSecureCoding:YES error:&error];
    
    [pb setData:tmpData forType:@"sr6actordata"];
    
    // As a hack, we are doing the data in the details field separately.

    tmpData = curActor.detailString;
    [pb setData:tmpData forType:@"sr6actordetails"];
}

@end
