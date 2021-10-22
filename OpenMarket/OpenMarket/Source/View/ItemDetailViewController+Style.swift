//
//  ItemDetailViewController+Style.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/10/22.
//

import UIKit

extension ItemDetailViewController {
    // MARK: Style
    enum Style {
        static let defaultBackgroundColor: UIColor = .systemBackground
        static let defaultTintColor: UIColor = .label
        static let defaultFont: UIFont = .preferredFont(forTextStyle: .body)
        static let stressedFont: UIFont = .preferredFont(forTextStyle: .largeTitle)
        static let defaultViewsMargin: CGFloat = 10
        enum MoreBarButtonItem {
            static let image: UIImage? = .init(systemName: "ellipsis")
        }
        enum PageControl {
            static let currentPageColor: UIColor = .systemBlue
            static let remainPageColor: UIColor = .systemGray
        }
        enum StockLabel {
            static let soldOutColor: UIColor = .systemYellow
            static let normalColor: UIColor = .label
        }
        enum PriceLabel {
            static let strikeThroughColor: UIColor = .systemRed
            static let normalColor: UIColor = .label
        }
        enum Alert {
            enum InputPassword {
                static let title: String = "비밀번호 입력"
                static let message: String = "등록자 인증을 위한 비밀번호가 필요합니다"
                static let placeHolder: String = "비밀번호"
            }
            enum DeleteItem {
                static let title: String = "삭제 되었습니다"
                static let message: String = "해당 아이템이 삭제 되었습니다"
            }
            enum Action {
                static let updateTitle: String = "수정"
                static let deleteTitle: String = "삭제"
                static let cancelTitle: String = "취소"
                static let okayTitle: String = "확인"
            }
        }
    }
}
