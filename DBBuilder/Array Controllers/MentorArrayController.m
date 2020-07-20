//
//  MentorArrayController.m
//  DBBuilder
//
//  Created by Ed Pichon on 2020/7/02.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//

#import "MentorArrayController.h"
#import "SR6Mentor.h"

@implementation MentorArrayController

-(IBAction)add:(id)sender {
    
    SR6Mentor *myMentor = (SR6Mentor *)[self newObject];
    myMentor.mentorUUID = [NSUUID UUID];
}

@end
