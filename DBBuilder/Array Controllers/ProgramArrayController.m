//
//  ProgramArrayController.m
//  DBBuilder
//
//  Created by Ed Pichon on 2020/7/04.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//

#import "ProgramArrayController.h"
#import "SR6Program.h"

@implementation ProgramArrayController

-(IBAction)add:(id)sender {
    
    SR6Program *myProg = (SR6Program *)[self newObject];
    myProg.programUUID = [NSUUID UUID];
}

@end
