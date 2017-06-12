//
//  ViewController.swift
//  meizitu
//
//  Created by 王卓 on 16/8/30.
//  Copyright © 2016年 SherryTeam. All rights reserved.
//

import UIKit
import MJRefresh
//import PKHUD
class ViewController: UIViewController {
    var page = 1
    let colPerRow = 2
    var maxNumber = 0
    var searchBar = UISearchBar()
    var list = [MyData](){
        didSet{
            collectionView.mj_footer.isHidden = list.count == 0
            self.collectionView.reloadData()
        }
    }
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        func configCollectionView(){
            //定义collectionView的布局类型，流布局
            let layout = UICollectionViewFlowLayout()
            //滑动方向 默认方向是垂直
            layout.scrollDirection = .vertical
            //每个Item之间最小的间距
            layout.minimumInteritemSpacing = 8
            //每行之间最小的间距
            layout.minimumLineSpacing = 8
            layout.sectionInset.top = 8
            layout.sectionInset.left = 8
            layout.sectionInset.right = 8
            layout.sectionInset.bottom = 8
            collectionView.register(UINib(nibName: "IndexCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "IndexCollectionViewCell")
            collectionView.collectionViewLayout = layout
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.backgroundColor = UIColor ( red: 0.8118, green: 0.8118, blue: 0.8118, alpha: 1.0 )
        }
        configCollectionView()
        self.view.addSubview(searchBar)
        searchBar.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.top)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
        }
        
        //roll一个
        self.loadList(true)
        self.navigationItem.title = "妹子图"
        
        //设置刷新
        let header = MJRefreshNormalHeader(refreshingBlock: {
            self.collectionView.mj_header.beginRefreshing()
            self.loadList(false)
            self.collectionView.mj_header.endRefreshing()
        })
        header?.stateLabel.textColor = UIColor.darkGray
        header?.lastUpdatedTimeLabel.textColor = UIColor.darkGray
        //TODO: 箭头颜色
        self.collectionView.mj_header = header
        
        let footer = MJRefreshAutoNormalFooter(refreshingBlock: {
            self.collectionView.mj_footer.beginRefreshing()
            self.loadList(true)
            self.collectionView.mj_footer.endRefreshing()
        })
        footer?.stateLabel.textColor = UIColor.darkGray
        collectionView.mj_footer = footer
        collectionView.mj_footer.isHidden = list.count == 0
        
        
        let rollButtton = UIBarButtonItem(title: "Roll", style: .done, target: self, action: #selector(ViewController.roll(_:)))
        self.navigationItem.leftBarButtonItem = rollButtton
        
        let sourceButtton = UIBarButtonItem(title: "Source", style: .done, target: self, action: #selector(ViewController.changeSource(_:)))
        self.navigationItem.rightBarButtonItem = sourceButtton
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    func roll(_ button:UIBarButtonItem){
        page = Int(arc4random())%140
        list.removeAll()
        loadList(true)
    }
    func changeSource(_ button:UIBarButtonItem){
        let alert = UIAlertController(title: "Source", message: "choose", preferredStyle: .actionSheet)
        let ljq = UIAlertAction(title: "答题", style: .default) { (_) in
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PEVC")
            self.navigationController?.pushViewController(vc, animated: true)
            //ServiceProxy.setSource(.ljq)
        }
        let mzt = UIAlertAction(title: "mzt", style: .default) { (_) in
            ServiceProxy.setSource(.meizitu)
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alert.addAction(ljq)
        alert.addAction(mzt)
        alert.addAction(cancel)

        present(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     获取数据方法
     
     - parameter name:     菜名
     - parameter loadMore: 是否加载更多
     */
    func loadList(_ loadMore:Bool = true){
        //TODO -:一次获取详细数据
        
        //如果是刷新
        if !loadMore {
            page = 1
            self.list.removeAll()
            collectionView.reloadData()
        }
        ServiceProxy.getList(page) { (res, error) in

            guard error == nil else{
                self.page = 1
                HUD.flash(.labeledError(title: "连接出错", subtitle: nil),delay: 1)
                self.list.removeAll()
                return
            }
            if res?.data.count == 0{
                HUD.flash(.labeledError(title: "没有更多信息", subtitle: nil),delay: 1)
            }else{
                self.page += 1
                HUD.flash(.success,delay: 0.3)
            }
            self.list.append(contentsOf: res!.data)
            self.collectionView.reloadData()
        }
    }


}

//extension ViewController:UITableViewDataSource,UITableViewDelegate{
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return list.count
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier("cell")!
//        cell.textLabel?.text = list[indexPath.row].title
//        return cell
//    }
//    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        let vc = GirlViewController()
//        vc.naviTitle = list[tableView.indexPathForSelectedRow!.row].title
//        vc.url = list[tableView.indexPathForSelectedRow!.row].url
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
//}

extension ViewController: UICollectionViewDataSource,UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        let width = (UIScreen.main.bounds.width-32)/2
        let height:CGFloat = width*273.0/159.0
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let lastRow = Int(floor(Double(list.count)/Double(colPerRow)))
        if section == lastRow{
            return list.count % colPerRow
        }
        return colPerRow
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Int(ceil(Double(list.count)/Double(colPerRow)))
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IndexCollectionViewCell", for: indexPath) as! IndexCollectionViewCell
        cell.configWithDataModel(list[(indexPath as NSIndexPath).section*colPerRow + (indexPath as NSIndexPath).row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = collectionView.indexPathsForSelectedItems![0]
        let vc = GirlViewController()
        vc.naviTitle = list[(index as NSIndexPath).section*colPerRow + (index as NSIndexPath).row].title
        vc.url = list[(index as NSIndexPath).section*colPerRow + (index as NSIndexPath).row].url
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

