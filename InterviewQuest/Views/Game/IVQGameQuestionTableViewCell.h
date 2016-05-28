#import <UIKit/UIKit.h>

@protocol IVQGameQuestionTableViewCellDelegate;

@interface IVQGameQuestionTableViewCell : UITableViewCell

@property (weak, nonatomic) id<IVQGameQuestionTableViewCellDelegate> delegate;

@property (assign, nonatomic) BOOL answer;
@property (strong, nonatomic) NSString *questionLabelText;

@property (weak, nonatomic) IBOutlet UIView *noView;
@property (weak, nonatomic) IBOutlet UIView *yesView;

- (void)resetToolbar;
- (void)setNo;
- (void)setYes;

@end

@protocol IVQGameQuestionTableViewCellDelegate <NSObject>

@required

- (void)didClickNoButtonForCell:(IVQGameQuestionTableViewCell *)cell;
- (void)didClickYesButtonForCell:(IVQGameQuestionTableViewCell *)cell;


@end