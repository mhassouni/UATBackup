
(function(window){'use strict';
    
    function HoldOnAction(){
            if("undefined"==typeof jQuery){
                throw new Error("HoldOn.js requires jQuery");
            }
            
            var HoldOn = {};
            
            HoldOn.open = function(properties){
                $('#holdon-overlay').remove();//RemoveIfCalledBefore
                var theme = "sk-bounce";
                var content = "";
                var message = "";
                
                if(properties){
                    if(properties.hasOwnProperty("theme")){//Choose theme if given
                        theme = properties.theme;
                    }
                    
                    if(properties.hasOwnProperty("message")){//Choose theme if given
                        message = properties.message;
                    }
                }
                content = '<div class="sk-bounce"> <div class="bounce1"></div> <div class="bounce2"></div> <div class="bounce3"></div> </div>';

                
                
                var Holder    = '<div id="holdon-overlay" style="display: none;">\n\
                                    <div id="holdon-content-container">\n\
                                        <div id="holdon-content">'+content+'</div>\n\
                                        <div id="holdon-message">'+message+'</div>\n\
                                    </div>\n\
                                </div>';
                
                $(Holder).appendTo('body').fadeIn(300);
                
                if(properties){
                    if(properties.backgroundColor){
                        $("#holdon-overlay").css("backgroundColor",properties.backgroundColor);
                    }
                    
                    if(properties.backgroundColor){
                        $("#holdon-message").css("color",properties.textColor);
                    }
                }
            };
            
            HoldOn.close = function(){
                $('#holdon-overlay').fadeOut(300, function(){
                    $(this).remove();
                });
            };
            
        return HoldOn;
    }
    
    if(typeof(HoldOn) === 'undefined'){
        window.HoldOn = HoldOnAction();
    }
    
})(window);