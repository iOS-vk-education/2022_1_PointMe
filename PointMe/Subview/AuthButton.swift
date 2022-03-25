import UIKit


final class AuthButton: UIButton {
    
    /// action called when the button is clicked
    private var action: (() -> Void)?
    
    /// title for button
    private var title: String?
    
    /// constans values
    private struct Constants {
        static let tapOpacity: CGFloat = 0.7
        static let identityOpacity: CGFloat = 1.0
        static let cornerRadius: CGFloat = 10
        static let durationAnimation: TimeInterval = 0.1
    }
    
    
    init() {
        super.init(frame: .zero)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
        
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// Setup button properties
    ///
    /// - Parameters:
    ///     - title: String value for title
    func configure(title name: String?) {
        self.title = name
        self.setTitle(self.title, for: .normal)
        self.titleLabel?.font =  .buttonTitle
        self.backgroundColor = .buttonColor
        self.setTitleColor(.white, for: .normal)
        self.layer.cornerRadius = Constants.cornerRadius
        self.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        UIView.animate(withDuration: Constants.durationAnimation) { [weak self] in
            self?.alpha = Constants.tapOpacity
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        UIView.animate(withDuration: Constants.durationAnimation) { [weak self] in
            self?.alpha = Constants.identityOpacity
        }
    }
    
    
    /// Setup button action by tap
    ///
    /// - Parameters:
    ///     - action: clouser for action by touchUpInside event
    public func setAction(action: (() -> Void)?) {
        guard let action = action else { return }
        self.action = action
    }
    
    
    @objc private func buttonAction() {
        self.action?()
    }
}

