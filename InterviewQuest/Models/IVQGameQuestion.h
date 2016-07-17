#import <Foundation/Foundation.h>
#import "IVQQuestion.h"

@interface IVQGameQuestion : NSObject

@property (assign, nonatomic) BOOL answered;
@property (strong, nonatomic, readonly) IVQQuestion *question;
@property (strong, nonatomic) NSString *answer;
@property (strong, nonatomic) NSString *content;

- (instancetype)initWithFirebaseId:(NSString *)id;
- (instancetype)initWithQuestion:(IVQQuestion *)question;

@end
