//
//  PsychologistViewController.m
//  Psychologist
//
//  Created by Boyle, Patrick on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PsychologistViewController.h"
#import "HappinessPat2ViewController.h"

@interface PsychologistViewController ()
@property (nonatomic) int diagnosis;

@end

@implementation PsychologistViewController
@synthesize diagnosis = _diagnosis;

-(void)setAndShowDiagnosis:(int) diagnosis{
    self.diagnosis = diagnosis;
    [self performSegueWithIdentifier:@"ShowDiagnosis" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ShowDiagnosis"]){
        [segue.destinationViewController setHappiness:self.diagnosis];
        
    }else if ([segue.identifier isEqualToString:@"Celebrity"]){
        [segue.destinationViewController setHappiness:100];
    }
    else if ([segue.identifier isEqualToString:@"Problems"]){
        [segue.destinationViewController setHappiness:20];
    }
    else if ([segue.identifier isEqualToString:@"TV"]){
        [segue.destinationViewController setHappiness:40];
    }
}

- (IBAction)flying:(UIButton *)sender {
    [self setAndShowDiagnosis:85];
}


- (IBAction)apples:(UIButton *)sender {
    [self setAndShowDiagnosis:50];
}

- (IBAction)dragons:(UIButton *)sender {
    [self setAndShowDiagnosis:25];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
