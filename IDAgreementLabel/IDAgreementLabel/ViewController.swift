//
//  ViewController.swift
//  IDAgreementLabel
//
//  Created by 李云鹏 on 2017/12/12.
//  Copyright © 2017年 Island. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        agreementLabel.delegate = self
        view.addSubview(agreementLabel)
        view.addSubview(agreementIndexLabel)
    }
    override func viewDidLayoutSubviews() {
        agreementLabel.center = view.center
        agreementIndexLabel.center = CGPoint(x: view.center.x, y: view.center.y + 50)
    }
    lazy var agreementLabel: IDAgreementLabel = {
        let label = IDAgreementLabel(text: "我同意《京东使用协议》、《天猫使用协议》")
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        label.image = (UIImage(named: "agreement_normal"), UIImage(named: "agreement_selected"))
        label.agreementText = (["《京东使用协议》", "《天猫使用协议》"], [.foregroundColor : UIColor.green])
        return label
    }()
    lazy var agreementIndexLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = UIColor.blue
        return label
    }()
}

// MARK: - IDAgreementLabel 代理
extension ViewController: IDAgreementLabelDelegate {
    func agreementDidTap(index: Int) {
        agreementIndexLabel.text = "协议：\(index)"
        agreementIndexLabel.sizeToFit()
    }
}

