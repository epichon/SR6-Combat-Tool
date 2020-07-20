//
//  PowerArrayController.m
//  DBBuilder
//
//  Created by Ed Pichon on 2020/7/01.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//

#import "PowerArrayController.h"
#import "SR6Power.h"

@implementation PowerArrayController

-(IBAction)add:(id)sender {
    
    SR6Power *myPower = (SR6Power *)[self newObject];
    myPower.powerUUID = [NSUUID UUID];
}

@end


