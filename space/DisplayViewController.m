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
#import "MBProgressHUD.h"
#import "AppDelegate.h"


@interface DisplayViewController() <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *imageTitle;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic) CGFloat imageWidth;
@property (nonatomic) CGFloat imageHeight;
@property (weak, nonatomic) IBOutlet UIButton *saveImageButton;
@property (strong, nonatomic) NSString *moreInfo;
@property (strong, nonatomic) CMMotionManager *motionManager;


@end

@implementation DisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backButton.hidden = YES;
    self.imageTitle.hidden = YES;
    self.saveImageButton.hidden = YES;
    
    self.spinner.hidden = NO;
    
    NasaApiClient *apiClient = [[NasaApiClient alloc]init];
    
    [apiClient imagesFromApiWithCompletionBlock:^(NSDictionary *imageDictionaries) {
        
    AstronomyPOD *currentImage = [AstronomyPOD imagesFromDictionary:imageDictionaries];
        
        NSData *imageData = [[NSData alloc] initWithContentsOfURL: currentImage.imageURL];
        
        UIImage *imageFromData = [UIImage imageWithData:imageData];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.spinner.hidden = YES;
            self.backButton.hidden = NO;
            self.imageTitle.hidden = NO;
            self.saveImageButton.hidden = NO;
            self.backgroundImage.image = imageFromData;
            self.imageTitle.text = currentImage.imageTitle;
            self.moreInfo = currentImage.imageExplanation;
        }];
    }];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(screenTapped:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipedUp:)];
    [swipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:swipeGestureRecognizer];

    self.scrollView.delegate = self;
    //initialize the motion manager
    self.motionManager = [[CMMotionManager alloc]init];
    
//    DisplayViewController * __weak weakSelf = self;

}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    self.scrollView.minimumZoomScale =  1.25;
    self.scrollView.maximumZoomScale = self.view.frame.size.height;

    return self.backgroundImage;
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
    [UIView transitionWithView:self.saveImageButton duration:.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:nil];
    
        if (self.backButton.hidden == NO) {
            self.backButton.hidden = YES;
            self.imageTitle.hidden = YES;
            self.saveImageButton.hidden = YES;
        }else{
            self.backButton.hidden = NO;
            self.imageTitle.hidden = NO;
            self.saveImageButton.hidden = NO;
        }
}
- (IBAction)saveImageButtonTapped:(id)sender {
    NSLog(@"save image been tapped");
    UIImageWriteToSavedPhotosAlbum(self.backgroundImage.image, nil, nil, nil);
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = @"Saved!";

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
    });
    
    [UIView transitionWithView:hud duration:.8 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        hud.hidden = YES;
    }];
    
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

@end
