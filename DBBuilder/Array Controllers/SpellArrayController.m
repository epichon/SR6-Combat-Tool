//
//  Spell Array Controller.m
//  DBBuilder
//
//  Created by Ed Pichon on 2020/6/27.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//

#import "SpellArrayController.h"
#import "SR6Spell.h"

@implementation SpellArrayController

-(IBAction)add:(id)sender {
    
    SR6Spell *mySpell = (SR6Spell *)[self newObject];
    mySpell.spellUUID = [NSUUID UUID];
}

@end
