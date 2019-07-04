//
//  EquipVC.swift
//  WZSC
//
//  Created by yuhua on 2019/5/27.
//  Copyright © 2019 余华. All rights reserved.
//

import UIKit

class EquipVC: UIViewController {

    var storeItems = [Equip]()
    var items = [Equip]()
    var collection: UICollectionView!
    var show: UIButton!
    var choice: UIScrollView!
    var choiceButtons = [UIButton]()
    var currentChoice = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        edgesForExtendedLayout = .init(rawValue: 0)
        
        show = UIButton()
        show.backgroundColor = CustomColor.mainColor
        show.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        show.setTitle("点击这里进行筛选", for: .normal)
        show.setTitle("点击这里收回", for: .selected)
        show.setTitleColor(CustomColor.textColorWhite, for: .normal)
        show.setTitleColor(CustomColor.textColorWhite, for: .selected)
        view.addSubview(show)
        show.snp.makeConstraints {
            $0.top.left.right.equalTo(view)
            $0.height.equalTo(30)
        }
        show.addTarget(self, action: #selector(show(btn:)), for: .touchUpInside)
        
        choice = UIScrollView()
        choice.alpha = 0
        view.addSubview(choice)
        choice.snp.makeConstraints {
            $0.left.right.equalTo(view)
            $0.top.equalTo(show.snp.bottom)
            $0.height.equalTo(30)
        }
        choice.contentSize = CGSize(width: max(UIScreen.main.bounds.width, 55*8), height: 30)
        view.layoutIfNeeded()
        let t1 = UILabel()
        t1.textColor = CustomColor.mainColor
        t1.font = UIFont.systemFont(ofSize: 12)
        t1.text = "综合"
        t1.textAlignment = .center
        choice.addSubview(t1)
        t1.snp.makeConstraints {
            $0.left.top.equalToSuperview()
            $0.height.equalTo(choice.frame.height)
            $0.width.equalTo(50)
        }
        let b0 = addChoiceBtn(title: "全部")
        choice.addSubview(b0)
        b0.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.left.equalTo(t1.snp.right).offset(5)
            $0.size.equalTo(CGSize(width: 50, height: choice.frame.height-10))
        }
        let b1 = addChoiceBtn(title: "攻击")
        choice.addSubview(b1)
        b1.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.left.equalTo(b0.snp.right).offset(5)
            $0.size.equalTo(CGSize(width: 50, height: choice.frame.height-10))
        }
        let b2 = addChoiceBtn(title: "法术")
        choice.addSubview(b2)
        b2.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.left.equalTo(b1.snp.right).offset(5)
            $0.size.equalTo(CGSize(width: 50, height: choice.frame.height-10))
        }
        let b3 = addChoiceBtn(title: "防御")
        choice.addSubview(b3)
        b3.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.left.equalTo(b2.snp.right).offset(5)
            $0.size.equalTo(CGSize(width: 50, height: choice.frame.height-10))
        }
        let b4 = addChoiceBtn(title: "移动")
        choice.addSubview(b4)
        b4.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.left.equalTo(b3.snp.right).offset(5)
            $0.size.equalTo(CGSize(width: 50, height: choice.frame.height-10))
        }
        let b5 = addChoiceBtn(title: "打野")
        choice.addSubview(b5)
        b5.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.left.equalTo(b4.snp.right).offset(5)
            $0.size.equalTo(CGSize(width: 50, height: choice.frame.height-10))
        }
        let b6 = addChoiceBtn(title: "辅助")
        choice.addSubview(b6)
        b6.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.left.equalTo(b5.snp.right).offset(5)
            $0.size.equalTo(CGSize(width: 50, height: choice.frame.height-10))
        }
        
        let width = (UIScreen.main.bounds.width-70)/5
        let flow = UICollectionViewFlowLayout()
        flow.itemSize = CGSize(width: width, height: width+20)
        collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: flow)
        collection.backgroundColor = .white
        collection.delegate = self
        collection.dataSource = self
        collection.register(HeroCell.self, forCellWithReuseIdentifier: "ItemCell")
        view.addSubview(collection)
        collection.snp.makeConstraints {
            $0.top.equalTo(show.snp.bottom).offset(5)
            $0.left.equalTo(view).offset(5)
            $0.right.bottom.equalTo(view).offset(-5)
        }
        
        clearUpChoice()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateData()
    }
    func updateData() {
        if items.isEmpty {
            let request = Net.GetEquip(fail: {
                DispatchQueue.main.async {
                    BWHUD.infoHUD(msg: "无法获取！")
                }
            }) { value in
                self.storeItems = value
                self.items = value
                DispatchQueue.main.async {
                    self.collection.reloadData()
                }
            }
            if let req = request {
                BWHUD.showHUD(msg: "获取装备列表...") {
                    print("获取超时，取消请求")
                    req.cancel()
                }
            }
        }
    }
    func clearUpChoice() {
        var btn = choiceButtons.first(where: {$0.isSelected})
        btn?.isSelected = false
        btn?.backgroundColor = CustomColor.backgroundColor
        btn = choiceButtons[currentChoice]
        btn?.isSelected = true
        btn?.backgroundColor = CustomColor.mainColor
        switch currentChoice {
        case 1:
            items = storeItems.filter { $0.type == 1 }
        case 2:
            items = storeItems.filter { $0.type == 2 }
        case 3:
            items = storeItems.filter { $0.type == 3 }
        case 4:
            items = storeItems.filter { $0.type == 4 }
        case 5:
            items = storeItems.filter { $0.type == 5 }
        case 6:
            items = storeItems.filter { $0.type == 7 }
        default:
            items = storeItems
        }
        collection.reloadData()
    }
    func addChoiceBtn(title: String) -> UIButton {
        let b = UIButton()
        b.setTitle(title, for: .normal)
        b.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        b.setTitleColor(CustomColor.mainColor, for: .normal)
        b.setTitleColor(CustomColor.textColorWhite, for: .selected)
        b.backgroundColor = CustomColor.backgroundColor
        b.layer.cornerRadius = 2
        b.layer.borderColor = CustomColor.mainColor.cgColor
        b.layer.borderWidth = 1
        choiceButtons.append(b)
        b.addTarget(self, action: #selector(choiceBtnSelected(btn:)), for: .touchUpInside)
        return b
    }
    @objc func choiceBtnSelected(btn: UIButton) {
        if btn.isSelected {
            return
        }
        currentChoice = choiceButtons.firstIndex(of: btn)!
        clearUpChoice()
    }
    @objc func show(btn: UIButton) {
        btn.isSelected = !btn.isSelected
        if btn.isSelected {
            UIView.animate(withDuration: 0.25) {
                self.collection.snp.updateConstraints {
                    $0.top.equalTo(self.show.snp.bottom).offset(self.choice.frame.height+5)
                }
                self.view.layoutIfNeeded()
                self.choice.alpha = 1
            }
        } else {
            UIView.animate(withDuration: 0.25) {
                self.collection.snp.updateConstraints {
                    $0.top.equalTo(self.show.snp.bottom).offset(5)
                }
                self.view.layoutIfNeeded()
                self.choice.alpha = 0
            }
        }
    }
}

extension EquipVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! HeroCell
        let item = items[indexPath.row]
        cell.heroImage.image = nil
        cell.heroImage.kf.setImage(with: URL(string: item.imageUrl), placeholder: CustomCreate.createActivity())
        cell.heroName.text = item.name
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let item = items[indexPath.row]
        CustomCreate.showItemTips(item: item)
    }
}
