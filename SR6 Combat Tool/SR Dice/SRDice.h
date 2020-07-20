//
//  SRDice.h
//  SRDieRollerMac
//
//  Created by Edward Pichon on 4/7/08.
//  Copyright © 2020 Ed Pichon.
/* This file is part of the SRCombatTool.

SRCombatTool is free software: you can redistribute it and/or modify
it under the terms of the Creative Commons 4.0 license - BY-NC-SA.

SRCombatTool is distributed in the hope that it will be useful,
but without any warranty.

*/
/*
 This is the dice roller object, for SR6. It includes the various new edge-rolling options that are in SR6, with hooks for UIs to determine what roll options
 are avialable. Rather than selecting individual die to modify, you just say what kind of die you would like to modify, and the roller handles it from there,
 selecting an appropriate die. the _analyze method is where most of the smarts are - it parses the results, determines what they are, and what reroll/modify
 optiosn are available with the current set of dice.
 
 Uses the DMRnd Mersenne Twister random number genreator Copyright (C) 2006  Dick van Oudheusden
 
 */

#import <Foundation/NSArray.h>
#import <Foundation/NSValue.h>
#import "DMRnd.h"
#import <Foundation/NSDate.h>
#import <AppKit/NSFontManager.h>
#import <AppKit/NSFont.h>
#import <AppKit/NSAttributedString.h>
#import <AppKit/NSColor.h>

@interface SRDice : NSObject {
	int numDice; // How many dice were in the pool at the start
    int numRolled; // How many dice were actually rolled (if 6s explode, it could be higher)
	int numOnes; // How many 1s were rolled.
    int numTwos; // How many 1s were rolled.
	int numHits; // How many 5s or 6s were rolled.
    int numExplodedOnes; // How many ones came from exploded 6s.
    int numExplodedTwos; // How many twos came from exploded 6s. Could get both, oddly.
    BOOL bWildDieUsed;
    BOOL bExplodeUsed;
    BOOL bTwosGlitchUsed;
    BOOL rollIsSum; 
	
	DMRnd *myRandomizer; // The mersenne twister
	
    NSNumber *wildDie; // The wild die, if there is one.
	NSMutableArray *dicePool; // The rolled dice.
    NSString *summary; // A summary of what happened
    NSAttributedString *attributedSummary; //The summary, as an attributed string
    NSString *details; // THe full list of the dice as rolled
    NSAttributedString *attributedDetails; //The full list of the dice, as an attributed string
}

-(id) initWithRandomizer: (DMRnd *) randomizer;

-(void) rollDice: (int) Dice wildDie:(BOOL)bWildDie explode:(BOOL)bExplode twosGlitch:(BOOL)bTwosGlitch; // Rolls the dice and returns an array of numbers. Handles all of the pre-roll edge options.
-(int) rollSum: (int) Dice; // Rolls the number of dice, and returns the sum of the rolls. (For initiative)

// Edge options, post roll
-(void) reRollFailures; // Re-rolls all of the non-hit dice and returns an updated array of numbers (the old Karma reroll)
-(void) reRollHit; // Re-rolls one hit, and recalculates results
-(void) reRollMiss; // Re-rolls one miss, and recalculates results
-(void) reRollGlitch; // Re-roll a glitch die (a 1 or possibly a 2), and recalculate the results
-(void) addOneToGlitch; // Add 1 to a glitch die (a 1 or possibly a 2), and recalculate the results
-(void) addOneToMiss; // Add 1 to a 4, and recalculate the results

// Indicators of what happened on the roll.
-(int) numDice;
-(int) numHits;
-(int) numRolled;
-(BOOL) isGlitch;
-(BOOL) isCritGlitch;
-(BOOL) canReRollFailures; // Indicates if it's a valid option to re-roll the failures.
-(BOOL) canReRollHit; // Indicates if it's valid to reroll a hit (there are any hit dice)
-(BOOL) canReRollMiss; // Indicates if it's valid to reroll a miss (there are any miss dice)
-(BOOL) canReRollGlitch; // Indicates if it's valid to reroll a glitch (there are any glitch dice)
-(BOOL) canAddOneToGlitch; // Indicates if it's valid to add 1 to a glitch (there are any glitch dice)
-(BOOL) canAddOneToMiss; // Indicates if it's valid to add 1 to a miss (there are any miss dice)

-(NSString *) summary; // A quick summary string of what happened.
-(NSAttributedString *) attributedSummary; // A quick attributed summary string of what happened
-(NSString *) details; // The vxalue of each die rolled.
-(NSAttributedString *) attributedDetails; // The value of each die rolled.

-(NSArray *) dicePool; // The pool of dice, should someone every want to actually get it.

@end
