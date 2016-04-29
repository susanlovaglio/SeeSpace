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

@interface PODDisplyViewController ()
@property(strong, nonatomic) UIButton *backButton;//
@property(strong, nonatomic) UIButton *saveImageButton;
@property(strong, nonatomic) UILabel *imageTitle;
@property(strong, nonatomic) UIActivityIndicatorView *spinner;
@property(strong, nonatomic) UIImageView *backgroundImage;
@property(strong, nonatomic) NSString *moreInfo;
@property(strong, nonatomic) UIScrollView *scrollView;
@property(strong, nonatomic) UIView *imageViewContainer;



@end

@implementation PODDisplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.delegate = self;
    self.view.backgroundColor = [UIColor blackColor];
    UIFont *din = [UIFont fontWithName:@"DIN" size:20];
    
    //make a scroll view
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.scrollView.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:self.scrollView];
    
    // make the back button
    self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setTitle:@"Back" forState:UIControlStateNormal];
    [self.backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.backButton.titleLabel.font = din;
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
    self.imageTitle.font = din;
    self.imageTitle.translatesAutoresizingMaskIntoConstraints = NO;
    [self.imageTitle.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-40].active = YES;
    [self.imageTitle.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    
    //initialize background image before setting it in api get
    self.imageViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.scrollView addSubview:self.imageViewContainer];

   
   
//    self.imageTitle.hidden = YES;
//    self.saveImageButton.hidden = YES;
//    self.spinner.hidden = NO;
    
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
            self.imageViewContainer
            self.imageTitle.text = currentImage.imageTitle;
            self.moreInfo = currentImage.imageExplanation;
        }];
    }];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(screenTapped:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
//    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipedUp:)];
//    [swipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionUp];
//    [self.view addGestureRecognizer:swipeGestureRecognizer];

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
