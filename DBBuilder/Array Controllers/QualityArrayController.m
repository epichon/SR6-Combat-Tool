//
//  QualityArrayController.m
//  DBBuilder
//
//  Created by Ed Pichon on 2020/7/01.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//

#import "QualityArrayController.h"
#import "SR6Quality.h"

@implementation QualityArrayController

-(IBAction)add:(id)sender {
    SR6Quality *myQual = (SR6Quality *)[self newObject];
    myQual.qualityUUID = [NSUUID UUID];
}

@end
