#import <UIKit/UIKit.h>

@interface KeyButton : UIButton
@property (nonatomic, copy) NSString *payloadText;
@end
@implementation KeyButton
@end

@interface KeyboardViewController : UIInputViewController
@end

@implementation KeyboardViewController {
    UIStackView *_rowsStack;
}

static NSArray *operatorRow(void) {
    return @[@[@"::", NULL], @[@"->", NULL], @[@"=>", NULL], @[@"++", NULL], @[@"--", NULL],
             @[@"==", NULL], @[@"!=", NULL], @[@"<=", NULL], @[@">=", NULL], @[@"&&", NULL], @[@"||", NULL]];
}

static NSArray *bracketRow(void) {
    return @[@[@"{ }", @"{  }"], @[@"( )", @"(  )"], @[@"[ ]", @"[  ]"], @[@"< >", @"<  >"],
             @[@"\" \"", @"\"  \""], @[@"' '", @"'  '"], @[@"/* */", @"/*  */"], @[@"//", @"// "]];
}

static NSArray *keywordRow(void) {
    return @[@[@"#include", @"#include "], @[@"#define", @"#define "], @[@"std::", @"std::"],
             @[@"cout <<", @"cout << "], @[@"cin >>", @"cin >> "], @[@"endl", @"endl"],
             @[@"int ", @"int "], @[@"void ", @"void "], @[@"return ", @"return "],
             @[@"const", @"const "], @[@"auto", @"auto "], @[@"nullptr", @"nullptr"]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:0.13 green:0.15 blue:0.19 alpha:1.0];

    _rowsStack = [[UIStackView alloc] init];
    _rowsStack.axis = UILayoutConstraintAxisVertical;
    _rowsStack.distribution = UIStackViewDistributionFillEqually;
    _rowsStack.spacing = 6;
    _rowsStack.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_rowsStack];

    [self.view.heightAnchor constraintEqualToConstant:270].active = YES;

    [NSLayoutConstraint activateConstraints:@[
        [_rowsStack.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:6],
        [_rowsStack.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor constant:-6],
        [_rowsStack.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:4],
        [_rowsStack.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-4],
    ]];

    [self addRow:operatorRow()];
    [self addRow:bracketRow()];
    [self addRow:keywordRow()];
    [self addFunctionRow];
}

- (void)addRow:(NSArray *)items {
    UIStackView *row = [[UIStackView alloc] init];
    row.axis = UILayoutConstraintAxisHorizontal;
    row.distribution = UIStackViewDistributionFillEqually;
    row.spacing = 4;
    for (NSArray *it in items) {
        KeyButton *b = [self makeButtonWithDisplay:it[0]];
        [row addArrangedSubview:b];
        if (it.count > 1 && it[1] != [NSNull null]) b.payloadText = it[1];
    }
    [_rowsStack addArrangedSubview:row];
}

- (void)addFunctionRow {
    UIStackView *row = [[UIStackView alloc] init];
    row.axis = UILayoutConstraintAxisHorizontal;
    row.spacing = 4;

    UIButton *next = [self makeButtonWithDisplay:@"🌐"];
    next.backgroundColor = [UIColor colorWithWhite:0.35 alpha:1.0];
    [next addTarget:self action:@selector(advanceToNextInputMode) forControlEvents:UIControlEventTouchUpInside];
    [next.widthAnchor constraintEqualToConstant:56].active = YES;

    UIButton *space = [self makeButtonWithDisplay:@"空格"];
    ((KeyButton *)space).payloadText = @" ";
    [space addTarget:self action:@selector(insertSpace) forControlEvents:UIControlEventTouchUpInside];

    UIButton *back = [self makeButtonWithDisplay:@"⌫"];
    back.backgroundColor = [UIColor colorWithWhite:0.35 alpha:1.0];
    [back addTarget:self action:@selector(deleteBackwardTap) forControlEvents:UIControlEventTouchUpInside];
    [back.widthAnchor constraintEqualToConstant:56].active = YES;

    UIButton *enter = [self makeButtonWithDisplay:@"⏎"];
    enter.backgroundColor = [UIColor colorWithRed:0.15 green:0.55 blue:0.95 alpha:1.0];
    [enter addTarget:self action:@selector(insertNewline) forControlEvents:UIControlEventTouchUpInside];
    [enter.widthAnchor constraintEqualToConstant:56].active = YES;

    [row addArrangedSubview:next];
    [row addArrangedSubview:space];
    [row addArrangedSubview:back];
    [row addArrangedSubview:enter];
    [_rowsStack addArrangedSubview:row];
}

- (KeyButton *)makeButtonWithDisplay:(NSString *)display {
    KeyButton *b = [KeyButton buttonWithType:UIButtonTypeSystem];
    b.layer.cornerRadius = 6;
    b.backgroundColor = [UIColor colorWithWhite:0.28 alpha:1.0];
    b.tintColor = UIColor.whiteColor;
    b.titleLabel.font = [UIFont monospacedSystemFontOfSize:15 weight:UIFontWeightMedium];
    [b setTitle:display forState:UIControlStateNormal];
    [b addTarget:self action:@selector(keyTapped:) forControlEvents:UIControlEventTouchUpInside];
    return b;
}

- (void)keyTapped:(KeyButton *)sender {
    NSString *text = sender.payloadText ?: sender.currentTitle;
    [self.textDocumentProxy insertText:text];

    NSRange r = [text rangeOfString:@"  "];
    if (r.location != NSNotFound && r.location > 0) {
        NSInteger back = [text length] - (r.location + 1);
        if (back > 0) [self.textDocumentProxy adjustTextPositionByCharacterOffset:(-back)];
    }
}

- (void)deleteBackwardTap { [self.textDocumentProxy deleteBackward]; }
- (void)insertSpace { [self.textDocumentProxy insertText:@" "]; }
- (void)insertNewline { [self.textDocumentProxy insertText:@"\n"]; }

@end
