//
//  IDAgreementLabel.swift
//  IDAgreementLabel
//
//  Created by 李云鹏 on 2017/12/8.
//  Copyright © 2017年 Island. All rights reserved.
//

import UIKit

protocol IDAgreementLabelDelegate: class {
    func agreementDidTap(index: Int)
}

class IDAgreementLabel: UIView {
    
    
    private var agreementButton = [UIButton]()
    
    /// 代理
    weak var delegate: IDAgreementLabelDelegate?
    /// 是否勾选了协议
    var isChecked = false {
        didSet {
            checkButton.isSelected = isChecked
        }
    }
    /// 文本
    var text = "" {
        didSet {
            agreementLabel.text = text
        }
    }
    /// 字号
    var font = UIFont.systemFont(ofSize: 13) {
        didSet {
            agreementLabel.font = font
        }
    }
    /// 颜色
    var textColor = UIColor.lightGray {
        didSet {
            agreementLabel.textColor = textColor
        }
    }
    /// 图片
    var image = (normal: UIImage(named: "agreement_normal"), selected: UIImage(named: "agreement_selected")) {
        didSet {
            checkButton.setImage(image.normal, for: .normal)
            checkButton.setImage(image.selected, for: .selected)
        }
    }
    /// 协议文本
    var agreementText = (agreement: [String](), attrs: [NSAttributedStringKey : Any]()) {
        didSet {
            // 断言是否设置了文本
            guard let text = agreementLabel.text, text.count > 0 else {
                assert(true, "未设置协议文本")
                return
            }
            // 若没有设置过 font，将 agreementLabel.font 添加到 agreementText.attrs
            if agreementText.attrs[.font] == nil {
                agreementText.attrs[.font] = agreementLabel.font
            }
            // 设置 agreementLabel 的富文本属性
            let attributedText = NSMutableAttributedString(string: text)
            for agreement in agreementText.agreement {
                let range = (text as NSString).range(of: agreement)
                attributedText.addAttributes(agreementText.attrs, range: range)
            }
            agreementLabel.attributedText = attributedText
            agreementLabel.sizeToFit()
            // 1. 创建 textStorage
            let textStorage = NSTextStorage(attributedString: attributedText)
            // 2. 创建 layoutManager 管理 textStorage 中文本的布局和显示
            let layoutManager = NSLayoutManager()
            textStorage.addLayoutManager(layoutManager)
            // 3. 创建 textContainer 容纳 layoutManager 转换来的图像字符
            let textContainer = NSTextContainer()
            layoutManager.addTextContainer(textContainer)
            // 4. 获取各个协议文本对应的 rect，并添加 agreementButton 到对应位置
            for agreement in agreementText.agreement {
                let range = (text as NSString).range(of: agreement)
                let glyphRange = layoutManager.glyphRange(forCharacterRange: range, actualCharacterRange: nil)
                let glyphRect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
                let button = UIButton(frame: glyphRect)
                button.addTarget(self, action: #selector(agreementButtonDidClick(button:)), for: .touchUpInside)
                agreementLabel.addSubview(button)
                agreementButton.append(button)
            }
        }
    }
    
    convenience init(text: String) {
        self.init(frame: .zero)
        agreementLabel.text = text
    }
    
    @objc func agreementButtonDidClick(button: UIButton) {
        if let agreementIndex = agreementButton.index(of: button) {
            delegate?.agreementDidTap(index: agreementIndex)
        }
    }
    @objc func checkButtonClicked(button: UIButton) {
        button.isSelected = !button.isSelected
        isChecked = button.isSelected
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        checkButton.addTarget(self, action: #selector(checkButtonClicked(button:)), for: .touchUpInside)
        addSubview(checkButton)
        
        agreementLabel.isUserInteractionEnabled = true
        addSubview(agreementLabel)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        checkButton.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
        agreementLabel.sizeToFit()
        let checkLabelWidth = checkButton.bounds.width + 10 + agreementLabel.bounds.width
        let checkLabelHeight = checkButton.bounds.height
        frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: checkLabelWidth, height: checkLabelHeight)
        let agreementLabelX = checkButton.bounds.width + 10
        let agreementLabelY = checkLabelHeight / 2.0 - agreementLabel.bounds.height / 2.0
        agreementLabel.frame = CGRect(x: agreementLabelX, y: agreementLabelY, width: agreementLabel.bounds.width, height: agreementLabel.bounds.height)
    }
    
    lazy var checkButton: UIButton = {
        let button = UIButton()
        button.isSelected = isChecked
        button.setImage(image.normal, for: .normal)
        button.setImage(image.selected, for: .selected)
        return button
    }()
    lazy var agreementLabel: UILabel = {
        let label = UILabel()
        label.font = font
        label.textColor = textColor
        return label
    }()
}
