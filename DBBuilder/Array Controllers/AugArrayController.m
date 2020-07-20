//
//  AugArrayController.m
//  DBBuilder
//
//  Created by Ed Pichon on 2020/7/03.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//

#import "AugArrayController.h"
#import "SR6Aug.h"

@implementation AugArrayController

-(IBAction)add:(id)sender {
    
    SR6Aug *myAug = (SR6Aug *)[self newObject];
    myAug.augUUID = [NSUUID UUID];
}

@end
