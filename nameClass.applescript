script TF
    property parent : class "NSTextField"
    
    on becomeFirstResponder()
        performSelector_withObject_afterDelay_("selectText:", me, 0)
        return 1
    end becomeFirstResponder
    
end script