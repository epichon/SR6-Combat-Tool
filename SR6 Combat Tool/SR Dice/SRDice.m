//
//  SRDice.m
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
#import "SRDice.h"

@interface SRDice ()
-(void) _analyze; // Parse the results.
-(void) _analyzeSum: (int) sum; // Parse the results of a sum roll.
-(void) _explodeSixes: (int) explodedSixes; // Explode the 6s.
@end

@implementation SRDice

- (id) initWithRandomizer: (DMRnd *) randomizer {
    if (self = [super init]) {
        if (randomizer) {
            myRandomizer = randomizer;
        } else {
            return nil;
        }
    }
    return self;
}

#pragma mark Dice Roller methods

-(void) rollDice: (int) Dice wildDie:(BOOL)bWildDie explode:(BOOL)bExplode twosGlitch:(BOOL)bTwosGlitch{
    // Rolls the dice and returns an array of numbers.
    int counter;
    NSNumber *die;
    
    rollIsSum = FALSE;
    
    // Store the settings so that we know what was done.
    bWildDieUsed = bWildDie;
    bExplodeUsed = bExplode;
    bTwosGlitchUsed = bTwosGlitch;
    numExplodedOnes = 0;
    numExplodedTwos = 0;
    
    
    numDice = Dice;
    if (numDice <= 0) {
        // We've been given a wonky roll.
        numDice = 0;
    }
    
    // Clear the number array.
    [dicePool removeAllObjects];
    dicePool = [[NSMutableArray alloc] initWithCapacity:numDice];
    
    
    
    for (counter=0; counter<Dice; counter++) {
        // Pull a random number and put in a number object
        die = [NSNumber numberWithInt: [myRandomizer nextInt:1:6]];
        [dicePool addObject:die];
    }
    
    // If there is a wild die in use, we need to store it. We'll just grab the first die.
    if (bWildDieUsed) {
        wildDie = [dicePool firstObject];
    }
    
    // Explode the 6s, if we need to.
    if (bExplodeUsed) {
        [self _explodeSixes:0];
    }
    
    // Analyze the results.
    [self _analyze];
}

-(int) rollSum: (int) Dice {
    // Rolls the dice and returns the sum.
    int counter,sum;
    NSNumber *die;
    
    rollIsSum = TRUE;
    
    // Clear the number array.
    [dicePool removeAllObjects];
    dicePool = [[NSMutableArray alloc] initWithCapacity:numDice];
    
    numDice = Dice;
    sum = 0;
    for (counter=0; counter<Dice; counter++) {
        // Pull a random number and put in a number
        die = [NSNumber numberWithInt: [myRandomizer nextInt:1:6]];
        [dicePool addObject:die];
        sum = sum + die.intValue;
    }
    
    // Analyze the results.
    [self _analyzeSum:sum];
    
    return sum;
}

#pragma mark Edge reroll options

-(void) reRollFailures {
    // Rerolls anything that isn't a hit.
    int counter;
    NSNumber *die;
    
    // Go through the collection, looking for non-hits.
    for (counter = 0; counter < [dicePool count]; counter++) {
        die = [dicePool objectAtIndex:counter];
        
        if ([die intValue] < 5) { // A non-hit
            // Replace with a new value.
            die = [NSNumber numberWithInt: [myRandomizer nextInt:1:6]];
            [dicePool replaceObjectAtIndex:counter withObject:die];
        }
    } // end of counter for loop
    
    // Analyze the results
    [self _analyze];
}

-(void)reRollHit {
    // Reroll a hit, if there is one.
    int counter;
    NSNumber *die;

    // Bail if we can't do this.
    if (![self canReRollHit]) {
        return;
    }
    
    // Scan through the dice pool, and as soon as we find one that is a hit, reroll it.
    for (counter = 0; counter < [dicePool count]; counter ++) {
        die = [dicePool objectAtIndex:counter];
        
        if ([die intValue] >= 5) {
            // Replace with a new value. Note that we don't care what the value is.
            die = [NSNumber numberWithInt: [myRandomizer nextInt:1:6]];
            [dicePool replaceObjectAtIndex:counter withObject:die];
            break; // Only reroll one die.
        }
    }
    // Re-analyze
    [self _analyze];
}

-(void)reRollMiss {
    // Reroll a miss, if there is one.
    int counter;
    NSNumber *die;
    
    // Bail if we can't do this.
    if (![self canReRollMiss]) {
        return;
    }
    
    // Scan through the dice pool, and as soon as we find one that is a miss, reroll it.
    for (counter = 0; counter < [dicePool count]; counter ++) {
        die = [dicePool objectAtIndex:counter];
        
        if ([die intValue] < 5) {
            // Replace with a new value. Note that we don't care what the value is.
            die = [NSNumber numberWithInt: [myRandomizer nextInt:1:6]];
            [dicePool replaceObjectAtIndex:counter withObject:die];
            break; // Only reroll one die.
        }
    }
    // Re-analyze
    [self _analyze];
}

-(void)reRollGlitch {
    // Reroll a glitch, if there is one.
    int counter;
    int glitchValue;
    NSNumber *die;
    
    // Bail if we can't do this.
    if (![self canReRollGlitch]) {
        return;
    }
    
    // The glitch value depends on if 2s are glitches
    if (bTwosGlitchUsed) {
        glitchValue = 2;
    } else {
        glitchValue = 1;
    }
    
    // Scan through the dice pool, and as soon as we find one that is a glitch, reroll it.
    for (counter = 0; counter < [dicePool count]; counter ++) {
        die = [dicePool objectAtIndex:counter];
        
        if ([die intValue] <= glitchValue) {
            // Replace with a new value. Note that we don't care what the value is.
            die = [NSNumber numberWithInt: [myRandomizer nextInt:1:6]];
            [dicePool replaceObjectAtIndex:counter withObject:die];
            break; // Only reroll one die.
        }
    }
    // Re-analyze
    [self _analyze];
}

#pragma mark Edge Add to Dice

-(void)addOneToGlitch {
    // Add 1 to a glitch, if there is one.
    int counter;
    NSNumber *die;
    
    // Bail if we can't do this.
    if (![self canAddOneToGlitch]) {
        return;
    }
    
    // We add one to a 2, if there are any twos, and if 2s are glitches.
    if (bTwosGlitchUsed && (numTwos >0)) {
        // Scan through the dice pool, and as soon as we find a two
        for (counter = 0; counter < [dicePool count]; counter ++) {
            die = [dicePool objectAtIndex:counter];
            if ([die intValue] == 2) {
                // Replace with a new value. Note that we don't care what the value is.
                die = [NSNumber numberWithInt: [myRandomizer nextInt:1:6]];
                [dicePool replaceObjectAtIndex:counter withObject:die];
                break; // Only reroll one die.
            }
        }
    } else { // There are no 2s, or 2s aren't glitches.
        // Scan for the first 1. It should be the first entry, as we sorted thigns, but just in case.
        for (counter = 0; counter < [dicePool count]; counter ++) {
            die = [dicePool objectAtIndex:counter];
            if ([die intValue] == 1) {
                // Replace with a new value. Note that we don't care what the value is.
                die = [NSNumber numberWithInt:([die intValue]+1)];
                [dicePool replaceObjectAtIndex:counter withObject:die];
                break; // Only reroll one die.
            }
        }
    }
    
    // Re-analyze
    [self _analyze];
}

-(void)addOneToMiss {
    // Add 1 to a glitch, if there is one.
    int counter;
    NSNumber *die;
    
    // Bail if we can't do this.
    if (![self canAddOneToMiss]) {
        return;
    }
    
    // Look for the higest value that isn't a hit. So we scan backwards through the pool.
    // Scan through the dice pool, and as soon as we find a two
    for (counter = (int)[dicePool count]; counter > 0; counter --) {
        die = [dicePool objectAtIndex:counter-1];
        if ([die intValue] < 5) { // If it's a miss
            // Replace with a new value. Note that we don't care what the value is.
            die = [NSNumber numberWithInt: ([die intValue]+1)];
            [dicePool replaceObjectAtIndex:counter-1 withObject:die];
            break; // Only reroll one die.
        }
    }
    
    // Re-analyze
    [self _analyze];
}


#pragma mark Utility Methods

-(void) _explodeSixes: (int)explodedSixes {
    // Recursive. Scan through the array, counting the number of sixes.
    // For each new (unexploded) six, add a new die to the array.
    // Scan through the array, counting the number of sixes.
    // If the number of sixes is different from the number of exploded sixes, recurse.
    // Recurse until there are no new sixes.
    int iNumSixes;
    int counter;
    NSNumber *die;
    
    // If we aren't supposed to explode the sixes, bail.
    if (!bExplodeUsed) {
        return;
    }
    
    iNumSixes = 0;
    
    // Go through the collection, looking at the values
    for (counter = 0; counter < [dicePool count]; counter++) {
        // Grab the value
        die = [dicePool objectAtIndex:counter];
        
        if ([die intValue] == 6) {
            iNumSixes ++;
        }
    }
    
    // Now, check to see if we have any new sixes.
    if (iNumSixes > explodedSixes) {
        // Add a new die into the collection for each 6 we counted.
        for (counter = 0; counter < (iNumSixes - explodedSixes); counter++) {
            // Pull a random number and put in a number
            die = [NSNumber numberWithInt: [myRandomizer nextInt:1:6]];
            // Add it to the pool
            [dicePool addObject:die];
            
            // Note if it's a one.
            if ([die intValue] == 1) {
                numExplodedOnes++;
            }
            if ([die intValue] == 2) {
                numExplodedTwos++;
            }
        }
        
        // Now, recurse.
        [self _explodeSixes: iNumSixes];
    }
}


-(void) _analyze { // Analyzes the results.
    NSUInteger counter;
    NSNumber *die;

    // Reset the counters
    numHits = 0;
    numOnes = 0;
    numTwos = 0;
    numRolled = (int)[dicePool count];
        
    // Go through the collection, looking at the values
    for (counter = 0; counter < [dicePool count]; counter++) {
        // Grab the value
        die = [dicePool objectAtIndex:counter];
        
        if ([die intValue] == 1)  // Is it a one?
            numOnes++;
        else if ([die intValue] == 2) // Is it a two
            numTwos++;
        else if ([die intValue] >= 5)  // Is it a hit?
            numHits++;
    }
    
    // If we are using a wild die, process it. A hit counts as 5 hits, a 1 cancels all 5s.
    if (bWildDieUsed) {
        if ([wildDie intValue] >= 5) {
            numHits = numHits + 2; // We've already counted it once.
        } else if ([wildDie intValue] == 1){
            // Well, this gets nasty.
            // We need to re-count the hits, ignoring 5s.
            for (counter = 0; counter < [dicePool count]; counter++) {
                // Grab the value
                die = [dicePool objectAtIndex:counter];
                if ([die intValue] == 6) { // Is it a hit?
                    numHits++;
                }
            }
        }
    }
    
    // Also, as a freebie, lets sort the results.
    [dicePool sortUsingSelector: @selector(compare:)];
    
    // Build the result summary string.
    NSString *resultString;
    NSString *aString;
    NSMutableAttributedString *attrString;
    NSString *modString;
    
    if (numRolled == 1)
        aString = @"Die";
    else
        aString = @"Dice";
    
    if (bWildDieUsed && bExplodeUsed && bTwosGlitchUsed) {
        modString = @", Wild Die, Exploding 6s, 2s Glitch";
    } else if (bWildDieUsed && bExplodeUsed) {
        modString = @", Wild Die, Exploding 6s";
    } else if (bWildDieUsed && bTwosGlitchUsed) {
        modString = @", Wild Die, 2s Glitch";
    } else if (bWildDieUsed) {
        modString = @", Wild Die";
    } else if (bExplodeUsed && bTwosGlitchUsed) {
        modString = @", Exploding 6s, 2s Glitch";
    } else if (bExplodeUsed) {
        modString = @", Exploding 6s";
    } else if (bTwosGlitchUsed) {
        modString = @", 2s Glitch";
    } else {
        modString = @"";
    }
    
    if ([self isCritGlitch] == YES) {
        resultString = [[NSString alloc] initWithFormat:@"%d %@: Critical Glitch!%@",numRolled,aString,modString];
    } else if ([self isGlitch] == YES) {
        if (numHits == 1) {
            resultString = [[NSString alloc] initWithFormat:@"%d %@: 1 Hit, Glitch!%@",numRolled,aString,modString];
        } else {
            resultString = [[NSString alloc] initWithFormat:@"%d %@: %d Hits, Glitch!%@",numRolled,aString,numHits,modString];
        }
    } else {
        if (numHits == 1) {
            resultString = [[NSString alloc] initWithFormat:@"%d %@: 1 Hit%@",numRolled,aString,modString];
        } else {
            resultString = [[NSString alloc] initWithFormat:@"%d %@: %d Hits%@",numRolled,aString,numHits,modString];
        }
    }
    summary = resultString;
    
    // Now, build the attributed string.
    attrString = [[NSMutableAttributedString alloc] initWithString:resultString];
    [attrString addAttribute:NSFontAttributeName value:[NSFont userFontOfSize:11.0] range:NSMakeRange(0,[attrString length])];
    
    // The only attributes we apply are bold for the number of hits, bold italic for a glitch, and bold/italic/underline for critical glitches.
    // So, first we need to find the location of the ## Hits tag
    NSRange rngHit = [resultString rangeOfString:@"Hit"];
    
    // Add Bold for the hits.
    if (rngHit.length != 0){
        if (numHits ==1) {
            // If there's only one hit. we need to shift to the left two characters, and then add two to the length.
            rngHit.location = rngHit.location -2;
            rngHit.length = rngHit.length +2;
        } else {
            // We need to extend the range by 1 (to cover the "s"), and shift left three to cover the number of hits (allowing two digits)
            rngHit.location = rngHit.location -2;
            rngHit.length = rngHit.length + 3;
        }
        [attrString applyFontTraits:(NSFontBoldTrait) range:rngHit];
    }
    
    // Flag glitches
    if ([self isCritGlitch]) {
        rngHit = [resultString rangeOfString:@"Critical Glitch!"];
        [attrString applyFontTraits:(NSFontBoldTrait) range:rngHit];
        [attrString applyFontTraits:(NSFontItalicTrait) range:rngHit];
        // And make it underline
        [attrString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:1] range: rngHit];
        [attrString addAttribute:NSUnderlineColorAttributeName value:[NSColor redColor] range: rngHit];
    } else if ([self isGlitch]) {
        rngHit = [resultString rangeOfString:@"Glitch!"];
        [attrString applyFontTraits:(NSFontBoldTrait) range:rngHit];
        [attrString applyFontTraits:(NSFontItalicTrait) range:rngHit];
    }
    attributedSummary = attrString;
}

-(void) _analyzeSum:(int)sum { // Analyzes the results.
    // Reset the counters
    numRolled = (int)[dicePool count];
        
    // Build the result summary string.
    NSString *resultString;
    NSString *aString;
    NSMutableAttributedString *attrString;
    
    if (numRolled == 1)
        aString = @"Roll Result";
    else
        aString = [NSString stringWithFormat:@"Sum of %d Dice", self.numDice];
    
    
    resultString = [[NSString alloc] initWithFormat:@"%@: %d",aString, sum];
    
    summary = resultString;
    
    // Now, build the attributed string.
    attrString = [[NSMutableAttributedString alloc] initWithString:resultString];
    [attrString addAttribute:NSFontAttributeName value:[NSFont userFontOfSize:11.0] range:NSMakeRange(0,[attrString length])];
    
    attributedSummary = attrString;
}

#pragma mark Results Interfaces

-(int) numDice {
    return (numDice);
}

-(int) numHits {
    return (numHits);
}

-(int) numRolled {
    return (numRolled);
}

-(BOOL) isGlitch {
    // If the number of ones is >= half of the number of dice rolled, it's a glitch.
    if (numRolled == 0)
        return NO;
    else {
        // If twos count as glitches, count ones and twos for the number of glitches, otherwise just use the ones.
        // If the number of glitches is greater than the half the number of dice (round up), it's a glitch
        // We have to correct the counted number of 1s, as 1s from exploding sixes don't count.
        if (bTwosGlitchUsed) {
            return ((numOnes + numTwos - (numExplodedOnes + numExplodedTwos)) >= (int)((numRolled + 1) / 2));
        } else {
            return ((numOnes - numExplodedOnes) >= (int)((numRolled + 1) / 2));
        }
    }
}

-(BOOL) isCritGlitch {
    // If the roll is a glitch and there were not hits, it's a critical glitch.
    return ([self isGlitch] && numHits == 0);
}

-(BOOL) canReRollFailures {
    // This is the karma reroll. Can only do if there are actual failures.
    return (numHits != numRolled);
}

-(BOOL) canReRollHit {
    // Can only reroll hits if there are any.
    return (numHits >0);
}

-(BOOL) canReRollMiss {
    // Can only reroll misses if there are any.
    return (numHits < numRolled);
}

-(BOOL) canReRollGlitch {
    // Can only reroll glitches if there are any.
    // A glitch is a 1, or possibly a 2.
    if (bTwosGlitchUsed) {
        return ((numOnes + numTwos) > 0);
    } else {
        return (numOnes > 0);
    }
}

-(BOOL) canAddOneToGlitch {
    // Can only add one to a glitch if there are any.
    // A glitch is a 1, or possibly a 2.
    if (bTwosGlitchUsed) {
        return ((numOnes + numTwos) > 0);
    } else {
        return (numOnes > 0);
    }
}

-(BOOL) canAddOneToMiss {
    // Can only add one to a miss if there are any misses.
    return (numHits < numRolled);
}

-(NSArray *) dicePool {
    // Returns the dice pool as a non-mutable array.
    return dicePool;
}

-(NSString *)summary {
    return summary;
}

-(NSAttributedString *)attributedSummary {
    return (NSAttributedString *)attributedSummary;
}

-(NSString *)details {
    // Scan through the die list, and build a string of all of the dice
    NSMutableString *builder;
    int counter;
    NSNumber * die;
    
    builder = [NSMutableString stringWithFormat: @""];
    // Go through the collection, looking at the values
    for (counter = 0; counter < [dicePool count]; counter++) {
        // Grab the value
        die = [dicePool objectAtIndex:counter];
        
        [builder appendFormat:@"%d, ",[die intValue]];
    }
    
    // Now, strip off the final ", "
    return ([builder substringToIndex:[builder length]-2]);
}

-(NSAttributedString *)attributedDetails {
    // Scan through the die list, and build a string of all of the dice
    NSMutableAttributedString *builder;
    int counter;
    NSNumber * die;
    
    builder = [[NSMutableAttributedString alloc] initWithString:[self details]];
    // Set the foreground color.
    //[builder addAttribute:NSForegroundColorAttributeName value:[NSColor labelColor] range:NSMakeRange(0,[builder length])];

    // If this isn't a sum rooll, go through the collection, looking at the values, if it's a 1, mark it in italics. If it's a hit, make it bold.
    if (!rollIsSum) {
        for (counter = 0; counter < [dicePool count]; counter++) {
            // Grab the value
            die = [dicePool objectAtIndex:counter];
            if ([die intValue] == 1) {
                [builder applyFontTraits:(NSFontItalicTrait) range: NSMakeRange(counter * 3, 1)];
            } else if ([die intValue]==2 && bTwosGlitchUsed == TRUE) {
                [builder applyFontTraits:(NSFontItalicTrait) range: NSMakeRange(counter * 3, 1)];
            } else if ([die intValue] >=5) {
                [builder applyFontTraits:(NSFontBoldTrait) range: NSMakeRange(counter * 3, 1)];
            }
        }
    }
    
    return (NSAttributedString *)builder;
}

@end
