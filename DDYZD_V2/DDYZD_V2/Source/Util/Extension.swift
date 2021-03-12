//
//  Extension.swift
//  DDYZD_V2
//
//  Created by 김수완 on 2021/01/21.
//

import UIKit
import SafariServices
import RxSwift

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
    
    func goClubDetailView(_ clubID: Int){
        self.navigationController?.navigationBar.shadowImage = nil
        let vc = UIStoryboard.init(name: "Club", bundle: nil).instantiateViewController(withIdentifier: "ClubDetailViewController") as! ClubDetailViewController
        vc.clubID = clubID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func menuActionSheet(item: Feed, isHead: Bool?, pinCloser: (()->Void)?, deleteCloser: @escaping (()->Void)){
        
        let disposeBag = DisposeBag()
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if item.owner {
            let deleteFeed = UIAlertAction(title: "삭제", style: .destructive){ _ in
                let deleteAlert = UIAlertController(title: "게시물을 삭제하시겠어요?", message: nil, preferredStyle: .alert)
                let delete = UIAlertAction(title: "삭제", style: .destructive){ _ in
                    deleteCloser()
                }
                let cancle = UIAlertAction(title: "취소", style: .cancel)
                deleteAlert.addAction(delete)
                deleteAlert.addAction(cancle)
                deleteAlert.view.tintColor = .black
                self.present(deleteAlert, animated: true, completion: nil)
                
            }
            
            alert.addAction(deleteFeed)
            
            if isHead ?? false {
                let pinFeed = UIAlertAction(title: "고정", style: .default){ _ in
                    pinCloser!()
                }
                alert.addAction(pinFeed)
            }
            
        } else {
            alert.message = "이 피드에대한 권한이 없습니다."
            let declarationFeed = UIAlertAction(title: "신고", style: .destructive){ _ in
                let declarationAlert = UIAlertController(title: "게시물을 신고하시겠어요?", message: "신고 사유를 적어주세요.", preferredStyle: .alert)
                declarationAlert.addTextField(){ textField in
                    textField.placeholder = "신고 사유"
                }
                let declaration = UIAlertAction(title: "신고", style: .destructive){ _ in
                    let feedAPI = FeedAPI()
                    feedAPI.reportFeed(feedID: item.feedId, reason: declarationAlert.textFields![0].text!).subscribe(onNext: { res in
                        switch res {
                        case .success:
                            let completeAlert = UIAlertController(title: "신고가 접수되었습니다.", message: "이 게시물은 24시간내에 조치됩니다.", preferredStyle: .alert)
                            let confirm = UIAlertAction(title: "확인", style: .default)
                            completeAlert.addAction(confirm)
                            self.present(completeAlert, animated: true, completion: nil)
                        default:
                            let completeAlert = UIAlertController(title: "오류가 발생되었습니다.", message: "다시 시도해주세요.", preferredStyle: .alert)
                            let confirm = UIAlertAction(title: "확인", style: .default)
                            completeAlert.addAction(confirm)
                            self.present(completeAlert, animated: true, completion: nil)
                        }
                        
                    }).disposed(by: disposeBag)
                }
                let cancle = UIAlertAction(title: "취소", style: .cancel)
                declarationAlert.addAction(declaration)
                declarationAlert.addAction(cancle)
                declarationAlert.view.tintColor = .black
                self.present(declarationAlert, animated: true, completion: nil)
            }
            alert.addAction(declarationFeed)
        }
        let cancle = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alert.addAction(cancle)
        alert.view.tintColor = .black
        self.present(alert, animated: true, completion: nil)
    }
    
    func openInSafari(url: String) {
        if let url = URL(string: url) {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
        }
    }
    
}

extension UIImageView {
    func circleImage() {
        self.layer.cornerRadius = (self.frame.height + self.frame.width)/4
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

extension UILabel {
    func dateLabel(_ dateString: String) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier:"ko_KR")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSz"
        
        guard let temp = formatter.date(from: dateString) else {return self.text = ""}
        
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
    
    func fieldLabel(clubTag: [String]){
        
        self.text = ""
        
        for field in clubTag {
            if field == clubTag.last {
                self.text! += field
            } else {
                self.text! += "\(field), "
            }
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


extension UIButton {
    enum ClubInfoBtnType {
        case follow
        case unfollow
        case chat
        case apply(deadline: String)
    }
    
    func setBtnInClubDetail(type: ClubInfoBtnType) {
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 0.5
        switch type {
        case .follow:
            self.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            self.layer.backgroundColor = #colorLiteral(red: 0.8824950457, green: 0.839987576, blue: 1, alpha: 1)
            self.setTitle("팔로우", for: .normal)
        case .unfollow:
            self.layer.borderColor = #colorLiteral(red: 0.4504163861, green: 0.4470926523, blue: 0.4469521046, alpha: 1)
            self.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.setTitle("팔로우 취소", for: .normal)
        case .chat:
            self.layer.borderColor = #colorLiteral(red: 0.4504163861, green: 0.4470926523, blue: 0.4469521046, alpha: 1)
            self.layer.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            self.setTitle("채팅 보내기", for: .normal)
        case .apply(let deadline):
            self.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
            self.layer.backgroundColor = #colorLiteral(red: 0.8824950457, green: 0.839987576, blue: 1, alpha: 1)
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier:"ko_KR")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSz"
            
            guard let temp = formatter.date(from: deadline) else {return self.setTitle("지원하기", for: .normal)}
            
            let diff = (temp.millisecondsSince1970 - Date().millisecondsSince1970)/1000
            let d_day = diff / 86400
            
            let attributedStr = NSMutableAttributedString(string: "D-\(d_day) 지원하기")
            attributedStr.addAttribute(.foregroundColor, value: UIColor.red, range: NSString(string: "D-\(d_day) 지원하기").range(of: "D-\(d_day)"))
            self.setAttributedTitle(attributedStr, for: .normal)
        }
    }
}

func kfImageURL(url: String, type: imageURLtype) -> URL?{
    switch type {
    case .all:
        guard let encoded = url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: encoded) else {
            return nil
        }
        return url
    case .half:
        guard let encoded = "https://api.semicolon.live/file/\(url)".addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), let url = URL(string: encoded) else {
            return nil
        }
        return url
    }
}

enum imageURLtype {
    case all
    case half
}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}
