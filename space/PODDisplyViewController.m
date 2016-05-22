//
//  PODDisplyViewController.m
//  space
//
//  Created by susan lovaglio on 4/29/16.
//  Copyright © 2016 Susan Lovaglio. All rights reserved.
//

#import "PODDisplyViewController.h"
#import "MBProgressHUD.h"
#import "NasaApiClient.h"
#import "AstronomyPOD.h"
#import <CoreMotion/CoreMotion.h>

@interface PODDisplyViewController ()
@property(strong, nonatomic) UIButton *backButton;//
@property(strong, nonatomic) UIButton *saveImageButton;
@property(strong, nonatomic) UILabel *imageTitle;
@property(strong, nonatomic) UIActivityIndicatorView *spinner;
@property(strong, nonatomic) UIImage *backgroundImage;
@property(strong, nonatomic) NSString *moreInfo;
@property(strong, nonatomic) UIScrollView *scrollView;
@property(strong, nonatomic) UIImageView *imageViewContainer;
@property(strong, nonatomic) CMMotionManager *motionManager;
@property(strong, nonatomic) UIButton *enablePanButton;

@end

@implementation PODDisplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    UIFont *normalDin = [UIFont fontWithName:@"DIN" size:20];
    UIFont *smallDin = [UIFont fontWithName:@"DIN" size:15];
    
    //add spinner for load screen
    self.spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.spinner startAnimating];
    [self.view addSubview:self.spinner];
    self.spinner.translatesAutoresizingMaskIntoConstraints = NO;
    [self.spinner.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.spinner.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = YES;
    self.spinner.hidden = NO;

    //make a scroll view
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    self.scrollView.minimumZoomScale = .36;
    self.scrollView.maximumZoomScale = 6;
    self.scrollView.delegate = self;
    
    // make the back button
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setTitle:@"Back" forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.backButton.titleLabel.font = normalDin;
    self.backButton.hidden = YES;
    [self.view addSubview:self.backButton];
    self.backButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.backButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.backButton.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.backButton.heightAnchor constraintEqualToConstant:50].active = YES;
    [self.backButton.widthAnchor constraintEqualToConstant:100].active = YES;
    
    //make the image title label
    self.imageTitle = [[UILabel alloc]init];
    self.imageTitle.textColor = [UIColor whiteColor];
    [self.view addSubview:self.imageTitle];
    self.imageTitle.font = normalDin;
    self.imageTitle.translatesAutoresizingMaskIntoConstraints = NO;
    [self.imageTitle.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-40].active = YES;
    [self.imageTitle.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    self.imageTitle.hidden = YES;
    
    //make save image button
    self.saveImageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveImageButton setTitle:@"- Save Image -" forState:UIControlStateNormal];
    [self.saveImageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.saveImageButton addTarget:self action:@selector(saveImageButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.saveImageButton.titleLabel.font = smallDin;
    self.saveImageButton.hidden = YES;
    [self.view addSubview:self.saveImageButton];
    self.saveImageButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.saveImageButton.topAnchor constraintEqualToAnchor:self.imageTitle.bottomAnchor].active = YES;
    [self.saveImageButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    
    //make pan button
    self.enablePanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.enablePanButton setTitle:@"- Pan Photo -" forState:UIControlStateNormal];
    [self.enablePanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.enablePanButton addTarget:self action:@selector(enablePan) forControlEvents:UIControlEventTouchUpInside];
    self.enablePanButton.titleLabel.font = smallDin;
    self.enablePanButton.hidden = YES;
    [self.view addSubview:self.enablePanButton];
    self.enablePanButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.enablePanButton.bottomAnchor constraintEqualToAnchor:self.imageTitle.topAnchor].active = YES;
    [self.enablePanButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    [self.view bringSubviewToFront:self.enablePanButton];

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
            self.enablePanButton.hidden = NO;
            self.backgroundImage = imageFromData;
            self.scrollView.contentSize = CGSizeMake(self.backgroundImage.size.width, self.backgroundImage.size.height);
            self.imageViewContainer = [[UIImageView alloc]initWithImage:self.backgroundImage];
            [self.scrollView addSubview:self.imageViewContainer];
            self.imageTitle.text = currentImage.imageTitle;
            self.moreInfo = currentImage.imageExplanation;
            [self.view addSubview:self.scrollView];
            [self.view sendSubviewToBack:self.scrollView];
        }];
    }];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(screenTapped:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    //make a motion manager to start listening to callbacks
    }

-(void)enablePan{
    self.motionManager = [[CMMotionManager alloc]init];
    [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
        CGFloat xRotationRate = motion.rotationRate.x;
        CGFloat yRotationRate = motion.rotationRate.y;
        CGFloat zRotationRate = motion.rotationRate.z;
        
        if (fabs(yRotationRate) > (fabs(xRotationRate) + fabs(zRotationRate))) {
            
            CGFloat rotationMultiplier = 5.0f;
            CGFloat invertedYrotationRate = yRotationRate * -1;
            
            CGFloat zoomScale = (CGRectGetHeight(self.scrollView.bounds) / CGRectGetWidth(self.scrollView.bounds)) * (self.backgroundImage.size.width / self.backgroundImage.size.height);
            CGFloat xOffset = self.scrollView.contentOffset.x + (invertedYrotationRate * zoomScale * rotationMultiplier);
            CGPoint contentOffset = [self clampedContentOffsetForHorizontalOffset:xOffset];
            
            CGFloat movementSmoothing = .3f;
            
            [UIView animateWithDuration:movementSmoothing delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState |
             UIViewAnimationOptionAllowUserInteraction |
             UIViewAnimationOptionCurveEaseOut animations:^{
                 [self.scrollView setContentOffset:contentOffset animated:NO];
             } completion:nil];
        }
    }];
}

-(CGPoint)clampedContentOffsetForHorizontalOffset:(CGFloat)horizontalOffset{
    
    CGFloat maxXOffset = self.scrollView.contentSize.width - CGRectGetWidth(self.scrollView.bounds);
    CGFloat minXOffset = 0.0f;
    
    CGFloat clampedXOffset = fmaxf(minXOffset, fmin(horizontalOffset, maxXOffset));
    CGFloat centeredY = (self.scrollView.contentSize.height / 2.0f) - (CGRectGetHeight(self.scrollView.bounds))/ 2.0f;
    
    return CGPointMake(clampedXOffset, centeredY);
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return self.imageViewContainer;
}

- (void)screenTapped:(UITapGestureRecognizer *)sender {
    NSLog(@"tapped");
    [UIView transitionWithView:self.backButton duration:.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:nil];
    [UIView transitionWithView:self.imageTitle duration:.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:nil];
    [UIView transitionWithView:self.saveImageButton duration:.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:nil];
    [UIView transitionWithView:self.enablePanButton duration:.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:nil];
    
    if (self.backButton.hidden == NO) {
        self.backButton.hidden = YES;
        self.imageTitle.hidden = YES;
        self.enablePanButton.hidden = YES;
        self.saveImageButton.hidden = YES;
    }else{
        self.backButton.hidden = NO;
        self.imageTitle.hidden = NO;
        self.enablePanButton.hidden = NO;
        self.saveImageButton.hidden = NO;
    }
}

- (IBAction)saveImageButtonTapped:(id)sender {
    NSLog(@"save image been tapped");
    UIImageWriteToSavedPhotosAlbum(self.backgroundImage, nil, nil, nil);
    self.spinner.hidden = NO;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.label.text = @"Saved!";
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        // Do something...
        dispatch_async(dispatch_get_main_queue(), ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.spinner.hidden = YES;
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
    });
    
    [UIView transitionWithView:hud duration:.8 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        hud.hidden = YES;
    }];
    
}

-(void)backButtonTapped{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}




@end
