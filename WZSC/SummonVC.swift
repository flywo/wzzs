//
//  SummonVC.swift
//  WZSC
//
//  Created by yuhua on 2019/5/27.
//  Copyright © 2019 余华. All rights reserved.
//

import UIKit

class SummonVC: UIViewController {

    var summons = [Summon]()
    var collection: UICollectionView!
    var imageBig: UIImageView!
    var summonTips: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        edgesForExtendedLayout = .init(rawValue: 0)
        
        imageBig = UIImageView()
        imageBig.contentMode = .scaleAspectFill
        view.addSubview(imageBig)
        imageBig.snp.makeConstraints {
            $0.top.left.right.equalTo(view)
            $0.height.equalTo(UIScreen.main.bounds.width*0.618)
        }
        
        //tips
        summonTips = UITextView()
        summonTips.isEditable = false
        summonTips.isSelectable = false
        summonTips.textColor = CustomColor.textColorWhite
        summonTips.backgroundColor = CustomColor.mainColor
        summonTips.layer.cornerRadius = 2
        summonTips.font = UIFont.systemFont(ofSize: 14)
        summonTips.textContainerInset = .init()
        view.addSubview(summonTips)
        summonTips.snp.makeConstraints {
            $0.left.equalTo(view).offset(5)
            $0.right.equalTo(view).offset(-5)
            $0.height.equalTo(40)
            $0.top.equalTo(imageBig.snp.bottom).offset(10)
        }
        
        let width = (UIScreen.main.bounds.width-70)/5
        let flow = UICollectionViewFlowLayout()
        flow.itemSize = CGSize(width: width, height: width+20)
        collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: flow)
        collection.backgroundColor = .white
        collection.delegate = self
        collection.dataSource = self
        collection.register(HeroCell.self, forCellWithReuseIdentifier: "SumCell")
        view.addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.equalTo(summonTips.snp.bottom).offset(10)
            $0.left.equalTo(view).offset(5)
            $0.right.bottom.equalTo(view).offset(-5)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
    }
    func updateData() {
        if summons.isEmpty {
            let request = Net.GetSummon(fail: {
                DispatchQueue.main.async {
                    BWHUD.infoHUD(msg: "无法获取！")
                }
            }) { value in
                self.summons = value
                DispatchQueue.main.async {
                    self.summonTips.text = "\n\(value.first?.rank ?? "")\n\n\(value.first?.des ?? "")\n"
                    self.imageBig.kf.setImage(with: URL(string: value.first?.bigUrl ?? ""), placeholder: CustomCreate.createActivity())
                    self.layout()
                    self.collection.reloadData()
                }
            }
            if let req = request {
                BWHUD.showHUD(msg: "获取召唤师技能列表...") {
                    print("获取超时，取消请求")
                    req.cancel()
                }
            }
        }
    }
    func layout() {
        UIView.animate(withDuration: 0.2) {
            self.summonTips.snp.updateConstraints {
                $0.height.equalTo(getTextViewHeight(textView: self.summonTips, width: self.summonTips.frame.width))
            }
            self.view.layoutIfNeeded()
        }
    }
}


extension SummonVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return summons.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SumCell", for: indexPath) as! HeroCell
        let sum = summons[indexPath.row]
        cell.heroImage.image = nil
        cell.heroImage.kf.setImage(with: URL(string: sum.imageUrl), placeholder: CustomCreate.createActivity())
        cell.heroName.text = sum.name
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let sum = summons[indexPath.row]
        summonTips.text = "\n\(sum.rank)\n\n\(sum.des)\n"
        imageBig.image = nil
        imageBig.kf.setImage(with: URL(string: sum.bigUrl), placeholder: CustomCreate.createActivity())
        layout()
    }
}
