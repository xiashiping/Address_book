//
//  ViewController.m
//  通讯录列表
//
//  Created by 夏世萍 on 2017/1/4.
//  Copyright © 2017年 夏世萍. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic,strong)UITableView *table;

//存放字母的数组
@property (nonatomic,strong)NSMutableArray *Numarr;

//存放cell内容数组
@property (nonatomic,strong)NSArray *contentArr;
// UILabel selectView 中间显示字母的label
@property (nonatomic,strong)UILabel *selectView;

//搜索框
@property (nonatomic,strong)UISearchBar *searchBar;
//存放搜索内容的数组
@property (nonatomic,strong)NSMutableArray *searchArr;

@property (nonatomic,assign)BOOL isSearched; //判断有没有被搜索

@end

@implementation ViewController


- (NSMutableArray *)Numarr
{
    if (_Numarr == nil)
    {
        _Numarr = [NSMutableArray array];
    }
    return _Numarr;
}

- (NSMutableArray *)searchArr
{
    if (_searchArr == nil)
    {
        _searchArr = [NSMutableArray array];
    }
    return _searchArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"通讯录";
    self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:20]};
    
    self.contentArr = @[@"you",@"are",@"my",@"sunshine"];
    
    [self setUI];
}

- (void)setUI
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 50)];
    backView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:backView];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(30, 10, self.view.frame.size.width - 60, 30)];
    self.searchBar.barStyle = UIBarStyleDefault;
    self.searchBar.placeholder = @"请输入搜索内容";
    self.searchBar.delegate = self;
    [backView addSubview:self.searchBar];
    
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0,114, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    self.table.sectionIndexColor = [UIColor lightGrayColor];
    [self.view addSubview:self.table];
    self.selectView = [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x - 50, self.view.center.y - 50, 100, 100)];
    self.selectView.backgroundColor = [UIColor cyanColor];
    self.selectView.layer.cornerRadius = 100 / 2;
    self.selectView.textAlignment = NSTextAlignmentCenter;
    self.selectView.font = [UIFont systemFontOfSize:20];
    self.selectView.layer.masksToBounds = YES;
    self.selectView.hidden = YES;
    [self.view addSubview:self.selectView];
    
    self.isSearched = NO;
    for (int i = 0; i < 26; i++)
    {
        NSString *str = [NSString stringWithFormat:@"%c",'A'+ i];
        [self.Numarr addObject:str];
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isSearched)
    {
        return self.searchArr.count;
    }
    return self.Numarr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.contentArr[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (_isSearched)
    {
        return self.searchArr[section];
    }
    else
    {
        return self.Numarr[section];
    }
    return nil;
}


-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.Numarr;
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    self.selectView.text = title;
    self.selectView.hidden = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.selectView.hidden = YES;
    });
    return index;
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
}


//实时更新
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.isSearched = NO;
    [self.searchArr removeAllObjects];  //移除所有的数据
    for (NSString *content in _Numarr)
    {
        // containsString 查找字符串是否包含.....
        if ([content containsString:self.searchBar.text.uppercaseString])
        {                                //uppercaseString(小写转化大写)
            [self.searchArr addObject:content];
        }
    }
    self.isSearched = !self.isSearched;
    
    //如果为空，则返回原数据
    if (searchBar.text.length == 0)
    {
        self.isSearched = NO;
    }
    [self.table reloadData];     //数据刷新
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
