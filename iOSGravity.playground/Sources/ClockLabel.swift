import Foundation
import AppKit


public class ClockLabel: NSTextView {
    
    
    
    @objc func update() {
        let components = Calendar.current.dateComponents([.hour, .minute], from: Date())
        if components.minute! > 9 {
            self.string = "\(components.hour!):\(components.minute!)"
        } else {
            self.string = "\(components.hour!):0\(components.minute!)"
        }
        font = NSFont.systemFont(ofSize: 14)
        self.textColor = NSColor.white
    }
    public func start() {
        self.backgroundColor = NSColor.clear
        let timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        timer.fire()
    }
}
