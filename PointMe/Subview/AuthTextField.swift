import UIKit

final class AuthTextField: UITextField {
    
    /// constans values
    private struct Constants {
        static let widthUnderline: CGFloat = 1.0
        static let textInsetX: CGFloat = 1.5
        static let textInsetY: CGFloat = widthUnderline + 1.0
    }
    

    init() {
        super.init(frame: .zero)
        setupFontInput()
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override public func draw(_ rect: CGRect) {
        super.draw(rect)
        drawUnderline()
    }
    
    
    private func setupFontInput() {
        font = .textFieldInput
        textColor = .textFieldInputColor
    }
      
    
    private func drawUnderline() {
        let bezierPath = UIBezierPath()
        
        bezierPath.move(to: CGPoint(x: 0, y: self.frame.size.height))
        bezierPath.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        
        bezierPath.close()
        
        UIColor.black.set()
        bezierPath.lineWidth = Constants.widthUnderline
        bezierPath.stroke()
    }
      
    
    override public func drawPlaceholder(in rect: CGRect) {
        super.drawPlaceholder(in: rect)
        
        let placeholderLabel: UILabel = UILabel()
        placeholderLabel.font = .textFieldPlaceholderFont
        placeholderLabel.frame = CGRect(
            x: 0,
            y: 0,
            width: rect.size.width,
            height: rect.size.height
        )
        
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = .textFieldPlaceholderColor
        
        placeholder = nil
        
        addSubview(placeholderLabel)
        bringSubviewToFront(placeholderLabel)
    }
      
    
    override public func drawText(in rect: CGRect) {
        textAlignment = .left
        contentVerticalAlignment = .bottom
    }
      
    
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        textAlignment = .left
        contentVerticalAlignment = .bottom
        
        return bounds.insetBy(dx: Constants.textInsetX, dy: Constants.textInsetY)
    }

    
    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        textAlignment = .left
        contentVerticalAlignment = .bottom
        
        return bounds.insetBy(dx: Constants.textInsetX, dy: Constants.textInsetY)
    }
}
