//
//  MoreInfoContainerViewController.m
//  Inspired By
//
//  Created by Susan on 4/9/16.
//  Copyright © 2016 Susan Lovaglio. All rights reserved.
//

#import "MoreInfoContainerViewController.h"
#import "NasaApiClient.h"
#import "AstronomyPOD.h"

@interface MoreInfoContainerViewController ()
@property (weak, nonatomic) IBOutlet UIButton *swipeUpButton;
@property (weak, nonatomic) IBOutlet UITextView *moreInfoTextBox;

@end

@implementation MoreInfoContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    
//    self.swipeUpButton.tintColor = [UIColor whiteColor];
//    
//    UISwipeGestureRecognizer *tapGestureRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipedUp)];
//    [self.view addGestureRecognizer:tapGestureRecognizer];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)swipedUp{
//    NSLog(@"swiped");
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
