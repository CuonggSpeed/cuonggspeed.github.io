#import <UIKit/UIKit.h>
#import <Preferences/PSListController.h>

#define kPrefsApp CFSTR("com.cuonggspeed.imagecc")

@interface ICRootListController : PSListController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@end

@implementation ICRootListController

- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
    }
    return _specifiers;
}

- (void)showMessage:(NSString *)msg {
    UIAlertController *a = [UIAlertController alertControllerWithTitle:@"ImageCC" message:msg preferredStyle:UIAlertControllerStyleAlert];
    [a addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:a animated:YES completion:nil];
}

- (void)pickImage {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)clearImage {
    CFPreferencesSetAppValue(CFSTR("imageData"), NULL, kPrefsApp);
    CFPreferencesAppSynchronize(kPrefsApp);
    [self showMessage:@"Đã xóa ảnh."];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    BOOL saved = NO;
    if (image) {
        CGFloat maxSide = 1200.0;
        CGFloat longest = MAX(image.size.width, image.size.height);
        CGFloat ratio = (longest > maxSide) ? (maxSide / longest) : 1.0;
        CGSize size = CGSizeMake(image.size.width * ratio, image.size.height * ratio);

        UIGraphicsImageRendererFormat *fmt = [UIGraphicsImageRendererFormat defaultFormat];
        fmt.scale = 1.0;
        UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:size format:fmt];
        UIImage *small = [renderer imageWithActions:^(UIGraphicsImageRendererContext *ctx) {
            [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        }];

        NSData *data = UIImageJPEGRepresentation(small, 0.92);
        if (data) {
            CFPreferencesSetAppValue(CFSTR("imageData"), (__bridge CFPropertyListRef)data, kPrefsApp);
            CFPreferencesAppSynchronize(kPrefsApp);
            saved = YES;
        }
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        [self showMessage:saved ? @"Đã lưu ảnh. Mở Trung tâm điều khiển và chạm vào ô ImageCC để xem." : @"Không lưu được ảnh."];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
