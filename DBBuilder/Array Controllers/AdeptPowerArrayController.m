//
//  AdeptPowerArrayController.m
//  DBBuilder
//
//  Created by Ed Pichon on 2020/6/30.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//

#import "AdeptPowerArrayController.h"
#import "SR6AdeptPower.h"

@implementation AdeptPowerArrayController

-(IBAction)add:(id)sender {
    SR6AdeptPower *myPower = (SR6AdeptPower *)[self newObject];
    myPower.adeptPowerUUID = [NSUUID UUID];
}

@end
