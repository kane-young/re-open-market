//
//  ItemEditViewController+Style.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/10/15.
//

import UIKit

extension ItemEditViewController {
    // MARK: Style
    enum Style {
        static let maximumImageCount: Int = 5
        static let backgroundColor: UIColor = .systemBackground
        static let defaultFont: UIFont = .preferredFont(forTextStyle: .body)
        enum Views {
            static let verticalSpacing: CGFloat = 20
            static let horizontalSpacing: CGFloat = 10
        }
        enum RightBarButtonItem {
            static let registerTitle: String = "등록"
            static let updateTitle: String = "수정"
        }
        enum PhotoCollectionView {
            static let cellSizeRatio: CGFloat = 3/4
            static let edgeInsets: UIEdgeInsets = .init(top: 20, left: 20, bottom: 0, right: 20)
        }
        enum TitleTextField {
            static let placeHolder: String = "제품명"
        }
        enum StockTextField {
            static let placeHolder: String = "제품 수량"
        }
        enum CurrencyTextField {
            static let placeHolder: String = "화폐"
            static let width: CGFloat = 80
        }
        enum PriceTextField {
            static let placeHolder: String = "제품 가격"
        }
        enum DiscountedPriceTextField {
            static let placeHolder: String = "할인 가격(선택 사항)"
        }
        enum DescriptionsTextView {
            static let placeHolder: String = "제품 설명을 입력하세요"
            static let placeHolderTextColor: UIColor = .lightGray
            static let defaultTextColor: UIColor = .black
            static let spacingForKeyboard: CGFloat = 30
        }
        enum MoneyStackView {
            static let spacing: CGFloat = 5
        }
        enum CurrenyPickerView {
            static let buttonTitle: String = "Done"
            static let numberOfRows: Int = 1
        }
        enum BorderView {
            static let backgroundColor: UIColor = .systemGray4
            static let height: CGFloat = 1
        }
        enum TextField {
            static let tintColor = UIColor.clear
        }
        enum Alert {
            enum Register {
                static let title: String = "등록"
            }
            enum InputPassword {
                static let title: String = "비밀번호 입력"
                static let message: String = "등록자 인증을 위한 비밀번호가 필요합니다"
                static let placeHolder: String = "비밀번호"
            }
            enum ExcessImageCount {
                static let title: String = "이미지 등록 개수 초과"
                static let message: String = "이미지는 최대 5개까지만 등록할 수 있습니다"
            }
            enum Error {
                static let title: String = "에러 발생"
            }
            enum Dissatisfication {
                static let title: String = "필수 요소 작성 불만족"
                static let message: String = "할인 가격을 제외한 모든 요소를 채워야 하며,\n할인 가격은 제품 가격에 비해 낮아야 합니다"
            }
            enum Cancel {
                static let title: String = "취소"
            }
        }
    }
}
