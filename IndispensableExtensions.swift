//
//  Extensions.swift
//  NoteBook
//
//  Created by AM on 11/07/2025.
//

import Foundation
import AppKit

extension NSView {
    @available(OSX 10.13, *)
    @IBInspectable var TopLeft: CGFloat {
        get {
            return self.layer?.cornerRadius ?? 0.0
        }
        set {
            self.wantsLayer = true
            self.layer?.cornerRadius = newValue
            self.layer?.maskedCorners = [.layerMinXMaxYCorner]
        }
    }
    @IBInspectable var BottomLeftRight: CGFloat {
        get {
            return self.layer?.cornerRadius ?? 0.0
        }
        set {
            self.wantsLayer = true
            self.layer?.cornerRadius = newValue
            self.layer?.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        }
    }
    @IBInspectable var TopLeftRight: CGFloat {
        get {
            return self.layer?.cornerRadius ?? 0.0
        }
        set {
            self.wantsLayer = true
            self.layer?.cornerRadius = newValue
            self.layer?.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        }
    }
    @available(OSX 10.13, *)
    @IBInspectable var TopRight: CGFloat {
        get {
            return self.layer?.cornerRadius ?? 0.0
        }
        set {
            self.wantsLayer = true
            self.layer?.cornerRadius = newValue
            self.layer?.maskedCorners = [.layerMaxXMaxYCorner]
        }
    }
    
    @available(OSX 10.13, *)
    @IBInspectable var BottomLeft: CGFloat {
        get {
            return self.layer?.cornerRadius ?? 0.0
        }
        set {
            self.wantsLayer = true
            self.layer?.cornerRadius = newValue
            self.layer?.maskedCorners = [.layerMinXMinYCorner]
        }
    }
    
    @available(OSX 10.13, *)
    @IBInspectable var BottomRight: CGFloat {
        get {
            return self.layer?.cornerRadius ?? 0.0
        }
        set {
            self.wantsLayer = true
            self.layer?.cornerRadius = newValue
            self.layer?.maskedCorners = [.layerMaxXMinYCorner]
        }
    }
    @IBInspectable var bgColor: NSColor? {
        get {
            if let colorRef = self.layer?.backgroundColor {
                return NSColor(cgColor: colorRef)
            } else {
                return nil
            }
        }
        set {
            self.wantsLayer = true
            self.layer?.backgroundColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowColor: NSColor? {
        get {
            if let colorRef = self.layer?.shadowColor {
                return NSColor(cgColor: colorRef)
            } else {
                return nil
            }
        }
        set{
            self.wantsLayer = true
            self.shadow = NSShadow()
            self.layer?.shadowOpacity = 0.5
            self.layer?.shadowColor = newValue?.cgColor
            self.layer?.shadowOffset = NSMakeSize(1, -1)
            self.layer?.shadowRadius = 3
        }
    }
    @IBInspectable var cRadius: CGFloat {
        get {
            return self.layer?.cornerRadius ?? 0.0
        }
        set{
            self.wantsLayer = true
            self.layer?.cornerRadius = newValue
        }
    }
    @IBInspectable var borderW: CGFloat {
        get{
            return self.layer?.borderWidth ?? 0.0
        }set{
            self.wantsLayer = true
            self.layer?.borderWidth = newValue
        }
    }
    @IBInspectable var borderColour: NSColor? {
        get{
            if let colorRef = self.layer?.borderColor {
                return NSColor(cgColor: colorRef)
            }else{
                return nil
            }
        }set {
            self.wantsLayer = true
            self.layer?.borderColor = newValue?.cgColor
        }
    }
}
@objc extension NSView {
    var center: CGPoint {
        get { return CGPoint(x: NSMidX(frame), y: NSMidY(frame)) }
        set {setFrameOrigin(CGPoint(x: newValue.x - frame.width / 2.0, y: newValue.y - frame.height / 2.0))}
    }
    func setAnchorPoint (anchorPoint:CGPoint){
        if let layer = self.layer{
            var newPoint = CGPoint(x: self.bounds.size.width * anchorPoint.x, y: self.bounds.size.height * anchorPoint.y)
            var oldPoint = CGPoint(x: self.bounds.size.width * layer.anchorPoint.x, y: self.bounds.size.height * layer.anchorPoint.y)
            newPoint = newPoint.applying(layer.affineTransform())
            oldPoint = oldPoint.applying(layer.affineTransform())
            var position = layer.position
            position.x -= oldPoint.x
            position.x += newPoint.x
            position.y -= oldPoint.y
            position.y += newPoint.y
            layer.position = position
            layer.anchorPoint = anchorPoint
        }
    }
}
extension NSImage {
    func tint(color: NSColor) -> NSImage {
        let image = self.copy() as! NSImage
        image.lockFocus()
        
        color.set()
        
        let imageRect = NSRect(origin: NSZeroPoint, size: image.size)
        imageRect.fill(using: .sourceAtop)
        
        image.unlockFocus()
        
        return image
    }
    convenience init?(gradientColors: [NSColor], imageSize: NSSize,_ angle:CGFloat? = 0.0) {
        guard let gradient = NSGradient(colors: gradientColors) else { return nil }
        let rect = NSRect(origin: CGPoint.zero, size: imageSize)
        self.init(size: rect.size)
        let path = NSBezierPath(rect: rect)
        self.lockFocus()
        gradient.draw(in: path, angle: angle ?? 10.0)
        self.unlockFocus()
    }
    func resizeTo(width: CGFloat, height: CGFloat) -> NSImage {
        let ratioX = width / size.width
        let ratioY = height / size.height
        let ratio = ratioX < ratioY ? ratioX : ratioY
        let newHeight = size.height * ratio
        let newWidth = size.width * ratio
        let canvasSize = CGSize(width: newWidth, height: newHeight)
        let img = NSImage(size: canvasSize)
        img.lockFocus()
        let context = NSGraphicsContext.current
        context?.imageInterpolation = .high
        draw(in: NSRect(origin: .zero, size: NSSize(width: newWidth,height: newHeight)), from: NSRect(origin: .zero, size: size) , operation: .copy, fraction: 1)
        img.unlockFocus()
        return img
    }
    var pngData: Data? {
        guard let tiffRepresentation = tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else { return nil }
        return bitmapImage.representation(using: .png, properties: [:])
    }
    var jpegData: Data? {
        guard let tiffRepresentation = tiffRepresentation, let bitmapImage = NSBitmapImageRep(data: tiffRepresentation) else { return nil }
        return bitmapImage.representation(using: .jpeg, properties: [:])
    }
    func pngWrite(to url: URL, options: Data.WritingOptions = .atomic) -> Bool {
        do {
            try pngData?.write(to: url, options: options)
            return true
        } catch {
            return false
        }
    }
    func jpegWrite(to url: URL, options: Data.WritingOptions = .atomic) -> Bool {
        do {
            try jpegData?.write(to: url, options: options)
            return true
        } catch {
            return false
        }
    }
    var png: Data? { tiffRepresentation?.bitmap?.png }
}
extension Data {
    var bitmap: NSBitmapImageRep? { NSBitmapImageRep(data: self) }
}
extension NSBitmapImageRep {
    var png: Data? { representation(using: .png, properties: [:]) }
}
extension NSView {
    func addShimmerAnimation(shimmerColor: NSColor = .orange) {
        self.wantsLayer = true
        guard let layer = self.layer else { return }
        let gradient = CAGradientLayer()
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: -0.02)
        gradient.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width*3, height: self.bounds.size.height)
        let lowerAlpha: CGFloat = 0.8
        let solid = shimmerColor.withAlphaComponent(1).cgColor
        let clear = shimmerColor.withAlphaComponent(lowerAlpha).cgColor
        gradient.colors     = [ solid, solid, clear, clear, solid, solid ]
        gradient.locations  = [ 0,     0.3,   0.45,  0.55,  0.7,   1     ]
        let theAnimation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        theAnimation.duration = 1.5
        theAnimation.repeatCount = .infinity
        theAnimation.autoreverses = false
        theAnimation.isRemovedOnCompletion = true
        theAnimation.fillMode = .forwards
        theAnimation.fromValue = -self.frame.size.width * 2
        theAnimation.toValue =  0
        gradient.add(theAnimation, forKey: "animateLayer")
        layer.mask = gradient
    }
}

extension NSImage {
    
    func saveImage(as fileName: String, fileType: NSBitmapImageRep.FileType = .jpeg, at directory: URL = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)) -> Bool {
        guard let tiffRepresentation = tiffRepresentation, !fileName.isEmpty else {
            
            return false }
        do {
            try NSBitmapImageRep(data: tiffRepresentation)?
                .representation(using: fileType, properties: [:])?
                .write(to: directory.appendingPathComponent(fileName).appendingPathExtension(fileType.pathExtension))
            return true
        } catch {
            
            return false
        }
    }
    
    func saveImage(asFileName fileName: String,
                   withFileType fileType: NSBitmapImageRep.FileType = .jpeg,
                   atDirectoryURL directory: URL) -> URL? {
        guard let tiffRepresentation = tiffRepresentation, !fileName.isEmpty else {
            return nil
        }
        do {
            let url = directory.appendingPathComponent(fileName).appendingPathExtension(fileType.pathExtension)
            try NSBitmapImageRep(data: tiffRepresentation)?
                .representation(using: fileType, properties: [:])?
                .write(to: url)
            return url
        } catch {
            return nil
        }
    }
    
    func tintedImageWithColor(_ color: NSColor) -> NSImage {
        let newImage = NSImage(size: size)
        newImage.lockFocus()
        color.drawSwatch(in: NSRect(x: 0, y: 0, width: size.width, height: size.height))
        draw(at: NSZeroPoint, from: NSZeroRect, operation: .destinationIn, fraction: 1.0)
        newImage.unlockFocus()
        return newImage
    }
    
    func tintedImageWithImage(_ image: NSImage) -> NSImage {
        
        let overlayImage = resizeImage(image: image, w: Int(size.width), h: Int(size.height))
        
        let newImage = NSImage(size: size)
        newImage.lockFocus()
        
        newImage.drawRepresentation(overlayImage.representations.first!, in: NSRect(x: 0, y: 0, width: size.width, height: size.height))
        draw(at: NSZeroPoint, from: NSZeroRect, operation: .destinationIn, fraction: 1.0)
        newImage.unlockFocus()
        return newImage
    }
    
    func resizeImage(image: NSImage, w: Int, h: Int) -> NSImage {
        let destSize = NSMakeSize(CGFloat(w), CGFloat(h))
        let newImage = NSImage(size: destSize)
        newImage.lockFocus()
        image.draw(in: NSMakeRect(0, 0, destSize.width, destSize.height), from: NSMakeRect(0, 0, image.size.width, image.size.height), operation: NSCompositingOperation.copy, fraction: CGFloat(1))
        newImage.unlockFocus()
        newImage.size = destSize
        return NSImage(data: newImage.tiffRepresentation!)!
    }
    
    /**
     Derives new size for an image constrained to a maximum dimension while keeping AR constant
     
     - parameter maxDimension: maximum horizontal or vertical dimension for new size
     
     - returns: new size
     */
    func aspectFitSizeForMaxDimension(_ maxDimension: CGFloat) -> NSSize {
        var width =  size.width
        var height = size.height
        if size.width > maxDimension || size.height > maxDimension {
            let aspectRatio = size.width/size.height
            width = aspectRatio > 0 ? maxDimension : maxDimension*aspectRatio
            height = aspectRatio < 0 ? maxDimension : maxDimension/aspectRatio
        }
        return NSSize(width: width, height: height)
    }
}
extension NSBitmapImageRep.FileType {
    var pathExtension: String {
        switch self {
        case .bmp:
            return "bmp"
        case .gif:
            return "gif"
        case .jpeg:
            return "jpg"
        case .jpeg2000:
            return "jp2"
        case .png:
            return "png"
        case .tiff:
            return "tif"
        @unknown default:
            return ""
        }
    }
}
extension String{
    func image() -> NSImage{
        return NSImage(named: self) ?? NSImage()
    }
    func SizeOf_String( font: NSFont) -> CGSize {
        let fontAttribute = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttribute)  // for Single Line
        return size;
    }
    
    func width(forHeight height: CGFloat, font: NSFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    func convertHtml() -> NSAttributedString{
        guard let data = data(using: .utf8) else { return NSAttributedString()   }
        do {
            
            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
        }catch{
            return NSAttributedString()
        }
    }
    
    func height(width:CGFloat)->CGFloat{
        let font = NSFont.systemFont(ofSize: 16.0) // Specify the font

        let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude) // Specify the width and a very large height
        let options = NSString.DrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin) // Specify the options

        let attributes = [NSAttributedString.Key.font: font] // Specify the attributes

        let boundingRect = NSString(string: self).boundingRect(with: size, options: options, attributes: attributes, context: nil)

        let height = ceil(boundingRect.height) // Extract the height and round up to the nearest pixel
        
        return height + 8

    }
}

extension Double {
    func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Notification.Name{
    static let refreshPlans = Notification.Name("refreshPlans")
    static let minimizeSider = Notification.Name(rawValue: "minimizeSider")
    static let themeChanged = Notification.Name(rawValue: "themeChanged")
    static let showHUD = Notification.Name(rawValue: "showHUD")
    static let hideHUD = Notification.Name(rawValue: "hideHUD")
    static let apperanceChanged = Notification.Name(rawValue: "apperanceChanged")
    static let fbValuesFetched = Notification.Name(rawValue: "fbValuesFetched")
    static let internetIsBack = Notification.Name(rawValue: "internetIsBack")
}
//extension Notification.Name {
//    static let ClosedPremiumVC = Notification.Name("ClosedPremiumVC")
//    static let disableUI = Notification.Name("disableUI")
//    static let enableUI = Notification.Name("enableUI")
//    static let eBookGenerationCompleted = Notification.Name("eBookGenerationCompleted")
//    static let queryFromExtension = Notification.Name("queryFromExtension")
//
//
//}

extension NSColor {
    class func fromHex(hex: Int,_ alpha: Float = 1) -> NSColor {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue = CGFloat((hex & 0xFF)) / 255.0
        return NSColor(calibratedRed: red, green: green, blue: blue, alpha: 1.0)
    }
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt32 = 0
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        let length = hexSanitized.count
        guard Scanner(string: hexSanitized).scanHexInt32(&rgb) else { return nil }
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
        } else {
            return nil
        }
        self.init(red: r, green: g, blue: b, alpha: a)
    }
    func copyColor() -> NSColor {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return NSColor(red: r, green: g, blue: b, alpha: a)
    }
    var toHex: String? {
        return toHex()
    }
    // MARK: - From UIColor to String
    func toHex(alpha: Bool = false) -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        if components.count >= 4 {
            a = Float(components[3])
        }
        if alpha {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}

extension NSCollectionView{
    func hideVerticalScrollView(){
        self.enclosingScrollView?.verticalScroller?.alphaValue = 0.0
    }
    func hideHorizontalScrollView(){
        self.enclosingScrollView?.horizontalScroller?.alphaValue = 0.0
    }
}


extension NSViewController {
    
    func showToast(message: String, font: NSFont) {
        let padding: CGFloat = 20
        let maxWidth: CGFloat = 400
        let yOffset: CGFloat = 100

        // Create the label to measure text size
        let messageLabel = NSTextField()
        messageLabel.stringValue = message
        messageLabel.font = font
        messageLabel.isEditable = false
        messageLabel.isBezeled = false
        messageLabel.drawsBackground = false
        messageLabel.alignment = .center
        messageLabel.lineBreakMode = .byWordWrapping

        // Calculate text size
        let textSize = messageLabel.sizeThatFits(NSSize(width: maxWidth, height: .greatestFiniteMagnitude))
        let labelWidth = min(textSize.width + padding, maxWidth)
        let labelHeight = textSize.height

        // Create toast container view
        let toastView = NSView(frame: CGRect(
            x: (self.view.frame.width - labelWidth - padding) / 2,
            y: yOffset,
            width: labelWidth + padding,
            height: labelHeight + padding / 2
        ))
        toastView.wantsLayer = true
        toastView.layer?.backgroundColor = NSColor.black.withAlphaComponent(0.85).cgColor
        toastView.layer?.cornerRadius = toastView.frame.height / 2

        // Recreate the label to add to the view
        let toastLabel = NSTextField(frame: CGRect(
            x: padding / 2,
            y: padding / 4,
            width: labelWidth,
            height: labelHeight
        ))
        toastLabel.stringValue = message
        toastLabel.font = font
        toastLabel.isEditable = false
        toastLabel.isBezeled = false
        toastLabel.drawsBackground = false
        toastLabel.textColor = .white
        toastLabel.alignment = .center
        toastLabel.lineBreakMode = .byWordWrapping
        toastLabel.usesSingleLineMode = false
        toastLabel.stringValue = message
        toastView.addSubview(toastLabel)
        self.view.addSubview(toastView)

        // Initial alpha
        toastView.alphaValue = 1.0

        // Animate fade out and remove
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 2.5
            context.timingFunction = CAMediaTimingFunction(name: .easeOut)
            toastView.animator().alphaValue = 0.0
        }, completionHandler: {
            toastView.removeFromSuperview()
        })
    }

}

extension NSApplication {
    var mainApplication: Bool {
        return (self.isActive && NSRunningApplication.current.bundleIdentifier == "com.ca.Chat-Bot")
    }
}


extension NSView {
    func addShadow(shadowColor: NSColor = .lightGray,
                   shadowOpacity: Float = 0.5,
                   shadowOffset: CGSize = CGSize(width: -6, height: 5),
                   shadowRadius: CGFloat = 5) {
        // Configure shadow properties
        self.wantsLayer = true
        self.layer?.masksToBounds = false
        self.layer?.shadowColor = shadowColor.cgColor
        self.layer?.shadowOpacity = shadowOpacity
        self.layer?.shadowOffset = shadowOffset
        self.layer?.shadowRadius = shadowRadius

        // Make sure to clip to bounds to ensure the shadow is visible
        
    }
    
    func updateShadowColor(color: NSColor) {
         // self.layer?.shadowColor = color.cgColor
    }
}

extension NSCollectionView {
    func scrollToLastItem() {
        let lastItemIndex = self.numberOfItems(inSection: 0)
        guard lastItemIndex > 0 else { return }
        let lastIndexPath = IndexPath(item: lastItemIndex - 1, section: 0)
        self.scrollToItems(at: [lastIndexPath], scrollPosition: .bottom)
    }
    
    func scrollToFirstItem(){
        guard self.numberOfItems(inSection: 0) > 0 else {return}
        let firstIndexPath = IndexPath(item: 0, section: 0)
        self.scrollToItems(at: [firstIndexPath], scrollPosition: .top)
    }
    
    func scrollToLastItem(complition:@escaping()->()) {
        let lastItemIndex = self.numberOfItems(inSection: 0)
        guard lastItemIndex > 0 else { return }
        let lastIndexPath = IndexPath(item: lastItemIndex - 1, section: 0)
        
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 1.0 // Adjust the duration as needed
            self.scrollToItems(at: [lastIndexPath], scrollPosition: .bottom)
        }, completionHandler: {
            complition()
        })
    }
    
    func scrollToLastItemWithAnimation(complition:@escaping()->()){
        
        let lastItemIndex = self.numberOfItems(inSection: 0)
        guard lastItemIndex > 0 else { return }
        let lastIndexPath = IndexPath(item: lastItemIndex - 1, section: 0)
        
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 3.0 // Adjust the duration as needed
            self.scrollToItems(at: [lastIndexPath], scrollPosition: .bottom)
        }, completionHandler: {
            complition()
        })
    }
}

extension String{
    
    func height(withConstrainedWidth width: CGFloat, font: NSFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    func width(withConstrainedHeight height: CGFloat, font: NSFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.width)
    }
    
}
extension Dictionary where Key: Comparable {
    func sortedByKey() -> [Key: Value] {
        return Dictionary(uniqueKeysWithValues: sorted { $0.key < $1.key })
    }
}

extension Dictionary where Value: Equatable {
    func key(forValue value: Value) -> Key? {
        return first { $0.value == value }?.key
    }
}

extension NSFont {
    func fontSizeThatFits(string: String, inLabelWidth tableWidth: CGFloat) -> CGFloat {
        let size = CGSize(width: tableWidth, height: .greatestFiniteMagnitude)
        let attributes: [NSAttributedString.Key: Any] = [.font: self]
        let attributedString = NSAttributedString(string: string, attributes: attributes)
        let boundingRect = attributedString.boundingRect(with: size, options: [.usesLineFragmentOrigin, .usesFontLeading])
        let requiredWidth = ceil(boundingRect.size.width)
        let availableWidth = tableWidth
        let scale = availableWidth / requiredWidth
        let scaledFontSize = self.pointSize * scale
        return scaledFontSize
    }
}

extension Date{
    func getTimeFromDate()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a" // "a" for AM/PM format
        let timeString = dateFormatter.string(from: self)
        return timeString
    }
}

extension String{
    
    func copyToPasteBoard(){
        let pasteboard = NSPasteboard.general
        // Clear the pasteboard
        pasteboard.clearContents()
        // Set the string you want to copy
        let stringToCopy = self
        // Write the string to the pasteboard
        pasteboard.writeObjects([stringToCopy as NSString])
    }
}

extension String{
    func maxConsecutiveNewlines() -> Int {
        var maxCount = 0
        var currentCount = 0
        
        for character in self {
            if character == "\n" {
                currentCount += 1
                if currentCount > maxCount {
                    maxCount = currentCount
                }
            } else {
                currentCount = 0
            }
        }
        
        return maxCount
    }

}

extension NSView {
    enum GlowEffect: Float {
        case small = 0.4, normal = 2, big = 15
    }

    func doGlowAnimation(withColor color: NSColor, withEffect effect: GlowEffect = .normal) {
        wantsLayer = true
        layer?.masksToBounds = false
        layer?.shadowColor = color.withAlphaComponent(0.5).cgColor
        layer?.shadowRadius = 0
        layer?.shadowOpacity = 1
        layer?.shadowOffset = .zero
        
        let glowAnimation = CABasicAnimation(keyPath: "shadowRadius")
        glowAnimation.fromValue = 0
        glowAnimation.toValue = effect.rawValue
        glowAnimation.beginTime = CACurrentMediaTime()+0.5
        glowAnimation.duration = CFTimeInterval(0.3)
        glowAnimation.fillMode = .removed
        glowAnimation.autoreverses = true
        glowAnimation.repeatCount = .infinity
        glowAnimation.isRemovedOnCompletion = true
        layer?.add(glowAnimation, forKey: "shadowGlowingAnimation")
    }
}
extension NSButton {
    func shake() {
        let shakeAnimation = CAKeyframeAnimation()
        shakeAnimation.keyPath = "position.x"
        shakeAnimation.values = [0, 10, -10, 10, 0]
        shakeAnimation.keyTimes = [0, NSNumber(value: 1.0 / 6.0), NSNumber(value: 3.0 / 6.0), NSNumber(value: 5.0 / 6.0), 1]
        shakeAnimation.duration = 0.3
        shakeAnimation.isAdditive = true
        
        self.layer?.add(shakeAnimation, forKey: "shake")
    }
}


extension String {
    func calculateWidth(_ font: NSFont = NSFont.systemFont(ofSize: 16), _ height:CGFloat = 40) -> CGFloat {
        let maxSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: height)
        let attributes: [NSAttributedString.Key: Any] = [.font: font]

        let rect = (self as NSString).boundingRect(
            with: maxSize,
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: attributes
        )
        print("Wrapped width: \(rect.width), height: \(rect.height)")
        return rect.width
    }
    
    func icon() -> NSImage?{
        NSImage(named: self)
    }
}


extension Date{
    func stringDate() -> String{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        
        return formatter.string(from: self)
    }
}

extension Notification.Name{
    static let windowDidResize = Notification.Name("windowDidResize")
    static let menuDidChange = Notification.Name("menuDidChange")
}

extension String {
    func truncated(afterWords count: Int) -> String {
        let words = self.components(separatedBy: .whitespacesAndNewlines).filter { !$0.isEmpty }
        guard words.count > count else { return self }
        return words.prefix(count).joined(separator: " ") + "..."
    }
    
    func sanitizedFileName() -> String {
        // Replace all characters that are NOT letters or numbers with underscores
        let pattern = "[^a-zA-Z0-9]+"
        
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: self.utf16.count)
        
        let sanitized = regex?.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "_") ?? self
        
        // Optional: Remove consecutive underscores and trim leading/trailing underscores
        let collapsed = sanitized.replacingOccurrences(of: "_+", with: "_", options: .regularExpression)
        return collapsed.trimmingCharacters(in: CharacterSet(charactersIn: "_"))
    }

}


extension Decimal {
    var toDouble: Double {
        return NSDecimalNumber(decimal: self).doubleValue
    }
}

enum NoteBookError: Error {
    
    case fileNotFound
    case invalidInput(message: String)
    
    var localizedDescription: String {
        switch self {
        case .fileNotFound:
            return "The requested file could not be found."
        case .invalidInput(let message):
            return message
        }
    }
}
