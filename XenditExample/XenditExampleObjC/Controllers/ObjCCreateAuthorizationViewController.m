//
//  CreateAuthorizationViewController.m
//  XenditExample
//
//  Created by Maxim Bolotov on 3/31/17.
//  Copyright © 2017 Xendit. All rights reserved.
//

#import "ObjCCreateAuthorizationViewController.h"
#import <Xendit/Xendit.h>

#import "UIAlertController+CustomAlert.h"

@interface ObjCCreateAuthorizationViewController ()

@property (weak, nonatomic) IBOutlet UITextField *tokenIDTextField;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UITextField *cvnTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation ObjCCreateAuthorizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    Xendit.publishableKey = @"xnd_public_development_O4iFfuQhgLOsl8M9eeEYGzeWYNH3otV5w3Dh/BFj/mHW+72nCQR/";

}

- (IBAction)authenticateAction:(UIButton *)sender {
    
    
    NSString *tokenID = self.tokenIDTextField.text;
    NSString *amount = self.amountTextField.text;
    NSString *cvn = self.cvnTextField.text;
    
    if (tokenID.length == 0  && amount.length == 0 && cvn.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Some fields are empty" handler:nil];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    
    [self.activityIndicator startAnimating];
    
    __weak __typeof__(self) weakSelf = self;
    
    [Xendit createAuthenticationFromViewController:self tokenId:tokenID amount:@(amount.integerValue) cardCVN:cvn completion:^(XENCCToken * _Nullable token, NSError * _Nullable error) {
        NSString *alertTitle = nil;
        NSString *alertMessage = nil;
        if (token != nil) {
            alertTitle = @"Token";
            alertMessage = [NSString stringWithFormat:@"TokenID - %@, Status - %@", token.tokenID, token.status];
        } else {
            alertTitle = @"Error";
            alertMessage = error.localizedDescription;
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertTitle message:alertMessage handler:nil];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [weakSelf.activityIndicator stopAnimating];
            [weakSelf presentViewController:alert animated:YES completion:nil];
        });
    }];
    
}


@end
