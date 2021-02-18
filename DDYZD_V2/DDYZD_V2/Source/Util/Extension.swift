//
//  Extension.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/01/21.
//

import UIKit

extension UIView {
    
    func constrainToEdges(_ subview: UIView) {
      
      subview.translatesAutoresizingMaskIntoConstraints = false
      
      let topContraint = NSLayoutConstraint(
        item: subview,
        attribute: .top,
        relatedBy: .equal,
        toItem: self,
        attribute: .top,
        multiplier: 1.0,
        constant: 0)
      
      let bottomConstraint = NSLayoutConstraint(
        item: subview,
        attribute: .bottom,
        relatedBy: .equal,
        toItem: self,
        attribute: .bottom,
        multiplier: 1.0,
        constant: 0)
      
      let leadingContraint = NSLayoutConstraint(
        item: subview,
        attribute: .leading,
        relatedBy: .equal,
        toItem: self,
        attribute: .leading,
        multiplier: 1.0,
        constant: 0)
      
      let trailingContraint = NSLayoutConstraint(
        item: subview,
        attribute: .trailing,
        relatedBy: .equal,
        toItem: self,
        attribute: .trailing,
        multiplier: 1.0,
        constant: 0)
      
      addConstraints([
        topContraint,
        bottomConstraint,
        leadingContraint,
        trailingContraint])
    }
}

extension UIViewController {
    
    func moveLogin(didJustBrowsingBtnTaped: (()->Void)?, didSuccessLogin: (()->Void)? ) {
        let authView: UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        let loginVC = authView.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
        loginVC.didJustBrowsingBtnTaped = didJustBrowsingBtnTaped
        loginVC.didSuccessLogin = didSuccessLogin
        loginVC.modalPresentationStyle = .fullScreen
        self.present(loginVC, animated: true, completion: nil)
    }
    
    func menuActionSheet(item: FeedModel, isHead: Bool?, pinCloser: (()->Void)?, deleteCloser: @escaping (()->Void)){
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if item.owner {
            let deleteFeed = UIAlertAction(title: "삭제", style: .destructive){ _ in
                let deleteAlert = UIAlertController(title: "개시물을 삭제하시겠어요?", message: nil, preferredStyle: .alert)
                let delete = UIAlertAction(title: "삭제", style: .destructive){ _ in
                    deleteCloser()
                }
                let cancle = UIAlertAction(title: "취소", style: .cancel)
                deleteAlert.addAction(delete)
                deleteAlert.addAction(cancle)
                deleteAlert.view.tintColor = .black
                self.present(deleteAlert, animated: true, completion: nil)
                
            }
            let modifyFeed = UIAlertAction(title: "수정", style: .default){ _ in
                // 게시물 수정 페이지로 이동
            }
            
            alert.addAction(deleteFeed)
            alert.addAction(modifyFeed)
            
            if isHead ?? false {
                let pinFeed = UIAlertAction(title: "고정", style: .default){ _ in
                    pinCloser!()
                }
                alert.addAction(pinFeed)
            }
            
        } else {
            alert.message = "이 피드에대한 권한이 없습니다."
        }
        let cancle = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancle)
        alert.view.tintColor = .black
        self.present(alert, animated: true, completion: nil)
    }
    
    func openInSafari(url: String) {
        if let url = URL(string: url) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
}

extension UIImageView {
    func circleImage() {
        self.layer.cornerRadius = (self.frame.height + self.frame.width)/4
    }
}

extension UILabel {
    func dateLabel(_ dateString: String) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier:"ko_KR")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSz"
        
        guard let temp = formatter.date(from: dateString) else {return self.text = "?"}
        
        let diff = (Date().millisecondsSince1970 - temp.millisecondsSince1970)/1000
        let day_diff = diff / 86400
        
        if day_diff < 0 || day_diff >= 31 {
            formatter.dateFormat = "yyyy년 MM월 dd일"
            let current_time_string = formatter.string(from: temp)
            self.text = current_time_string
        } else {
            self.text = day_diff == 0 ? (
                diff < 60 ? "방금":
                diff < 120 ? "1분 전":
                diff < 3600 ? "\(diff/60)분 전":
                diff < 7200 ? "1시간 전":
                "\(diff/3600)시간 전"
            ): (
                day_diff == 1 ? "어제":
                day_diff < 7 ? "\(day_diff)일 전":
                "\(day_diff/7)주 전"
            )
        }
        
        
    }
}

extension CALayer {
    func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in arr_edge {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                break
            default:
                break
            }
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
        }
    }
}

extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}


