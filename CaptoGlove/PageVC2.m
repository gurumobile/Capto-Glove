//
//  PageVC2.m
//  CaptoGlove
//
//  Created by Georgi on 12/26/16.
//  Copyright © 2016 georgi. All rights reserved.
//

#import "PageVC2.h"
#import "RKDropdownAlert.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"

@interface PageVC2 () {
    NSMutableArray *feedbackInfoArray;
    NSUserDefaults *defaults;
    NSArray *defaultsArray;
    
    NSMutableString *csvString;
}

@end

@implementation PageVC2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Setting rating views...
    self.captoView.delegate = self;
    self.captoView.emptySelectedImage = [UIImage imageNamed:@"StarEmpty"];
    self.captoView.fullSelectedImage = [UIImage imageNamed:@"StarFull"];
    self.captoView.contentMode = UIViewContentModeScaleAspectFill;
    self.captoView.maxRating = 5;
    self.captoView.minRating = 1;
    self.captoView.rating = 0;
    self.captoView.editable = YES;
    self.captoView.halfRatings = NO;
    self.captoView.floatRatings = YES;
    
    self.captoRatingLbl.text = [NSString stringWithFormat:@"%.2f", self.captoView.rating];
    self.captoRatingLbl.text = [NSString stringWithFormat:@"%.2f", self.captoView.rating];
    
    self.materialView.delegate = self;
    self.materialView.emptySelectedImage = [UIImage imageNamed:@"StarEmpty"];
    self.materialView.fullSelectedImage = [UIImage imageNamed:@"StarFull"];
    self.materialView.contentMode = UIViewContentModeScaleAspectFill;
    self.materialView.maxRating = 5;
    self.materialView.minRating = 1;
    self.materialView.rating = 0;
    self.materialView.editable = YES;
    self.materialView.halfRatings = NO;
    self.materialView.floatRatings = YES;
    
    self.materialRatingLbl.text = [NSString stringWithFormat:@"%.2f", self.materialView.rating];
    self.materialRatingLbl.text = [NSString stringWithFormat:@"%.2f", self.materialView.rating];
    
    feedbackInfoArray  = [[NSMutableArray alloc]initWithCapacity:0];
    
    defaults = [NSUserDefaults standardUserDefaults];
    defaultsArray = [[NSArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.alphaView.hidden = true;
    self.thanksView.hidden = true;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.backBtn.layer.cornerRadius = self.backBtn.frame.size.height / 2;
    self.backBtn.layer.borderWidth = 1.0;
    self.backBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.backBtn.layer.shadowOpacity = 0.7;
    self.backBtn.layer.shadowRadius = 5.0;
    
    self.finishBtn.layer.cornerRadius = self.finishBtn.frame.size.height / 2;
    self.finishBtn.layer.borderWidth = 1.0;
    self.finishBtn.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.finishBtn.layer.shadowOpacity = 0.7;
    self.finishBtn.layer.shadowRadius = 5.0;
}


- (IBAction)onFinish:(id)sender {
    [self onValidate];
}

- (void)onValidate {
    if ((self.firstName.length != 0) && (self.lastName.length != 0) && (self.email != 0) && (self.captoRatingLbl.text.length != 0) && (self.materialRatingLbl.text.length != 0)) {
        NSLog(@"Success");
        
        [UIView animateWithDuration:3.0
                         animations:^{
                             self.alphaView.hidden = NO;
                             self.thanksView.hidden = NO;
                             [self onSaveCSV];
                         } completion:^(BOOL finished) {
                             self.alphaView.hidden = YES;
                             self.thanksView.hidden = YES;
                         }];
        
    } else {
        [RKDropdownAlert title:@"Warning" message:@"You have to enter all fields!"];
    }
}

#pragma mark -
#pragma mark - TPFloatRatingViewDelegate

- (void)floatRatingView:(TPFloatRatingView *)ratingView ratingDidChange:(CGFloat)rating
{
    if (self.captoView == ratingView) {
        self.captoRatingLbl.text = [NSString stringWithFormat:@"%.2f", rating];
    }  else if (self.materialView == ratingView) {
        self.materialRatingLbl.text = [NSString stringWithFormat:@"%.2f", rating];
    }
}

- (void)floatRatingView:(TPFloatRatingView *)ratingView continuousRating:(CGFloat)rating
{
    if (self.captoView == ratingView) {
        self.captoRatingLbl.text = [NSString stringWithFormat:@"%.2f", rating];
    }  else if (self.materialView == ratingView) {
        self.materialRatingLbl.text = [NSString stringWithFormat:@"%.2f", rating];
    }
}

#pragma mark -
#pragma mark - CSV Area...

- (void)createCSV {
    if (![defaults boolForKey:@"isExist"]) {
        csvString = [[NSMutableString alloc]initWithCapacity:0];
        [csvString appendString:@"FirstName, LastName, Email, Company, How would you rate CaptoGlove?, How would you rate the material?, Additional Comments\n\n\n\n\n\n\n"];
        
        [defaults setBool:YES forKey:@"isExist"];
        [defaults synchronize];
    }
    
    for (NSDictionary *dct in feedbackInfoArray)
    {
        [csvString appendString:[NSString stringWithFormat:@"%@, %@, %@, %@, %@, %@, %@\n",[dct valueForKey:@"FirstName"],[dct valueForKey:@"LastName"],[dct valueForKey:@"Email"], [dct valueForKey:@"Company"], [dct valueForKey:@"CaptoRating"], [dct valueForKey:@"MaterialRating"], [dct valueForKey:@"Comments"]]];
    }
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, @"Capto.csv"];
    [csvString writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
}

- (void)onSaveCSV {
    defaultsArray = [defaults objectForKey:@"csv"];
    feedbackInfoArray = [NSMutableArray arrayWithArray:defaultsArray];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:0];
    
    [dict setValue:[NSString stringWithFormat:@"%@", _firstName] forKey:@"FirstName"];
    [dict setValue:[NSString stringWithFormat:@"%@", _lastName] forKey:@"LastName"];
    [dict setValue:[NSString stringWithFormat:@"%@", _email] forKey:@"Email"];
    [dict setValue:[NSString stringWithFormat:@"%@", _company] forKey:@"Company"];
    [dict setValue:[NSString stringWithFormat:@"%@", _captoRatingLbl.text] forKey:@"CaptoRating"];
    [dict setValue:[NSString stringWithFormat:@"%@", _materialRatingLbl.text] forKey:@"MaterialRating"];
    [dict setValue:[NSString stringWithFormat:@"%@", _feedbackTextview.text] forKey:@"Comments"];
        
    [feedbackInfoArray addObject:dict];
    
    defaultsArray = [NSArray arrayWithArray:feedbackInfoArray];
    
    [defaults setObject:defaultsArray forKey:@"csv"];
    [defaults synchronize];
    
    [self createCSV];
}

#pragma mark -
#pragma mark - FMDB

- (void)getAllData {
    // Getting the database path.
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"Capto.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString *sqlSelectQuery = @"SELECT * FROM tablename";
    
    // Query result
    FMResultSet *resultsWithNameLocation = [database executeQuery:sqlSelectQuery];
    while([resultsWithNameLocation next]) {
        NSString *strID = [NSString stringWithFormat:@"%d",[resultsWithNameLocation intForColumn:@"ID"]];
        NSString *strName = [NSString stringWithFormat:@"%@",[resultsWithNameLocation stringForColumn:@"Name"]];
        NSString *strLoc = [NSString stringWithFormat:@"%@",[resultsWithNameLocation stringForColumn:@"Location"]];
        
        // loading your data into the array, dictionaries.
        NSLog(@"ID = %@, Name = %@, Location = %@",strID, strName, strLoc);
    }
    [database close];
}

- (void)insertData {
    
    // Getting the database path.
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"Capto.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString *insertQuery = [NSString stringWithFormat:@"INSERT INTO user VALUES ('%@', %d)", @"Jobin Kurian", 25];
    [database executeUpdate:insertQuery];
    [database close];
}

- (void)updateDate {
    
    // Getting the database path.
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"Capto.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSString *insertQuery = [NSString stringWithFormat:@"UPDATE users SET age = '%@' WHERE username = '%@'", @"23", @"colin" ];
    [database executeUpdate:insertQuery];
    [database close];
}

- (void)gettingRowCount {
    
    // Getting the database path.
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsPath = [paths objectAtIndex:0];
    NSString *dbPath = [docsPath stringByAppendingPathComponent:@"database-name.sqlite"];
    
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    NSUInteger count = [database intForQuery:@"SELECT COUNT(field_name) FROM table_name"];
    [database close];
}

@end
