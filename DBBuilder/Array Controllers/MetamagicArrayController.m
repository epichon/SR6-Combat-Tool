//
//  MetamagicArrayController.m
//  DBBuilder
//
//  Created by Ed Pichon on 2020/7/02.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//

#import "MetamagicArrayController.h"
#import "SR6Metamagic.h"

@implementation MetamagicArrayController

-(IBAction)add:(id)sender {
    
    SR6Metamagic *myMM = (SR6Metamagic *)[self newObject];
    myMM.metamagicUUID = [NSUUID UUID];
}

@end
