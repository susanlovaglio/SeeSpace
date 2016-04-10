//
//  DisplayViewController.m
//  Inspired By
//
//  Created by Susan on 4/1/16.
//  Copyright © 2016 Susan Lovaglio. All rights reserved.
//

#import "DisplayViewController.h"
#import "NasaApiClient.h"
#import "AstronomyPOD.h"
#import "HomeViewController.h"

@interface DisplayViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *imageTitle;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containersVisibleHeight;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic) BOOL containerIsOpen;

@end

@implementation DisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.containerIsOpen = NO;
    
    self.backButton.hidden = YES;
    self.imageTitle.hidden = YES;
    
    NasaApiClient *apiClient = [[NasaApiClient alloc]init];
    
    [apiClient imagesFromApiWithCompletionBlock:^(NSDictionary *imageDictionaries) {
        
    AstronomyPOD *currentImage = [AstronomyPOD imagesFromDictionary:imageDictionaries];
        
        NSData * imageData = [[NSData alloc] initWithContentsOfURL: currentImage.imageURL];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.spinner.hidden = YES;
            self.backButton.hidden = NO;
            self.imageTitle.hidden = NO;
            self.backgroundImage.image = [UIImage imageWithData:imageData];
            self.imageTitle.text = currentImage.imageTitle;
            
        }];
    }];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(screenTapped:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipedUp:)];
    [swipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:swipeGestureRecognizer];
    
}

-(void)swipedUp: (UISwipeGestureRecognizer*)swipe{
    NSLog(@"swiped");
//    self.containersVisibleHeight.constant = 500;
}

- (IBAction)backButtonPressed:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)screenTapped:(UITapGestureRecognizer *)sender {
    NSLog(@"tapped");
    [UIView transitionWithView:self.backButton duration:.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:nil];
    [UIView transitionWithView:self.imageTitle duration:.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:nil];
    
    
        if (self.backButton.hidden == NO && self.imageTitle.hidden == NO) {
            self.backButton.hidden = YES;
            self.imageTitle.hidden = YES;
        }else{
            self.backButton.hidden = NO;
            self.imageTitle.hidden = NO;
        }
}

@end
