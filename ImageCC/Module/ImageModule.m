#import <UIKit/UIKit.h>

@protocol CCUIContentModuleContentViewController <NSObject>
@property (nonatomic, readonly) CGFloat preferredExpandedContentHeight;
@optional
- (void)willTransitionToExpandedContentMode:(BOOL)expanded;
- (void)didTransitionToExpandedContentMode:(BOOL)expanded;
@end

@protocol CCUIContentModule <NSObject>
@property (nonatomic, readonly) UIViewController<CCUIContentModuleContentViewController> *contentViewController;
@optional
@property (nonatomic, readonly) UIViewController *backgroundViewController;
@end

#define kPrefsApp CFSTR("com.cuonggspeed.imagecc")

@interface ICContentViewController : UIViewController <CCUIContentModuleContentViewController>
@property (nonatomic, strong) UIImageView *glyphView;
@property (nonatomic, strong) UIImageView *pictureView;
@property (nonatomic, strong) UILabel *emptyLabel;
@end

@implementation ICContentViewController

- (CGFloat)preferredExpandedContentHeight {
    return 420.0;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImageSymbolConfiguration *cfg = [UIImageSymbolConfiguration configurationWithPointSize:28 weight:UIImageSymbolWeightRegular];
    self.glyphView = [[UIImageView alloc] initWithImage:[UIImage systemImageNamed:@"photo" withConfiguration:cfg]];
    self.glyphView.tintColor = [UIColor whiteColor];
    self.glyphView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:self.glyphView];

    self.pictureView = [[UIImageView alloc] init];
    self.pictureView.contentMode = UIViewContentModeScaleAspectFit;
    self.pictureView.alpha = 0;
    [self.view addSubview:self.pictureView];

    self.emptyLabel = [[UILabel alloc] init];
    self.emptyLabel.text = @"Chưa chọn ảnh\nVào Cài đặt → ImageCC";
    self.emptyLabel.textColor = [UIColor whiteColor];
    self.emptyLabel.font = [UIFont systemFontOfSize:15];
    self.emptyLabel.textAlignment = NSTextAlignmentCenter;
    self.emptyLabel.numberOfLines = 0;
    self.emptyLabel.alpha = 0;
    [self.view addSubview:self.emptyLabel];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect b = self.view.bounds;
    self.glyphView.frame = b;
    self.pictureView.frame = CGRectInset(b, 14, 14);
    self.emptyLabel.frame = CGRectInset(b, 14, 14);
}

- (void)reloadImage {
    CFPreferencesAppSynchronize(kPrefsApp);
    NSData *data = (__bridge_transfer NSData *)CFPreferencesCopyAppValue(CFSTR("imageData"), kPrefsApp);
    UIImage *img = ([data isKindOfClass:[NSData class]]) ? [UIImage imageWithData:data] : nil;
    self.pictureView.image = img;
}

- (void)willTransitionToExpandedContentMode:(BOOL)expanded {
    if (expanded) {
        [self reloadImage];
    }
    BOOL hasImage = (self.pictureView.image != nil);
    [UIView animateWithDuration:0.25 animations:^{
        self.glyphView.alpha = expanded ? 0 : 1;
        self.pictureView.alpha = (expanded && hasImage) ? 1 : 0;
        self.emptyLabel.alpha = (expanded && !hasImage) ? 1 : 0;
    }];
}

@end

@interface ICModule : NSObject <CCUIContentModule>
@property (nonatomic, strong) UIViewController<CCUIContentModuleContentViewController> *contentViewController;
@end

@implementation ICModule

- (instancetype)init {
    if ((self = [super init])) {
        _contentViewController = [[ICContentViewController alloc] init];
    }
    return self;
}

@end
