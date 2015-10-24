//
//  WebViewController.m
//  MySafari
//
//  Created by Martin Henry on 10/22/15.
//  Copyright © 2015 Martin Henry. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController () <UIWebViewDelegate, UITextFieldDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UITextField *urlTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UINavigationItem *pageTitle;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;
@property CGFloat lastContentOffset;
@end

@implementation WebViewController
- (IBAction)onBackButtonPressed:(UIButton *)sender {
    [self.webView goBack];
}


- (IBAction)onForwardButtonPressed:(UIButton *)sender {
    [self.webView goForward];
}

- (IBAction)onStopLoadingButtonPressed:(UIButton *)sender {
    [self.webView stopLoading];
}

- (IBAction)onReloadButtonPressed:(UIButton *)sender {
    [self.webView reload];
}
- (IBAction)onUrlTextFieldClearButtonPressed:(UIButton *)sender {
    self.urlTextField.text = @"";
    [self.urlTextField becomeFirstResponder];
}

- (IBAction)onComingSoonPressed:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Coming Soon!" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}];
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeRequestWithString:@"http://google.com"];
    [self.webView.scrollView setDelegate:self];
    //    [self.activityIndicator stopAnimating];
    // Do any additional setup after loading the view.
}

- (void)makeRequestWithString:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSString *textInput = textField.text;
    if (![textInput hasPrefix:@"http://"]) {
        self.urlTextField.text = [@"http://" stringByAppendingString:textInput];
    }
    [self makeRequestWithString:self.urlTextField.text];
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.activityIndicator stopAnimating];
    if (!self.webView.canGoBack) {
        self.backButton.enabled = NO;
    } else {
        self.backButton.enabled = YES;
    }
    if (!self.webView.canGoForward) {
        self.forwardButton.enabled = NO;
    } else {
        self.forwardButton.enabled = YES;
    }
    self.urlTextField.text = webView.request.URL.absoluteString;
    self.pageTitle.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if(self.lastContentOffset < scrollView.contentOffset.y){
        self.urlTextField.alpha = 0.5;
    }
    if(self.lastContentOffset > scrollView.contentOffset.y){
        self.urlTextField.alpha = 1.0;
    }
    self.lastContentOffset = scrollView.contentOffset.y;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
