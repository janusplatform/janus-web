//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require remarkable-bootstrap-notify/bootstrap-notify
//= require intercooler-js/src/intercooler
//= require_tree .



var App = (function() {

    return {

        showInfo: function (val) {
            $.notify({icon: 'fa fa-info-circle',
                message: val}, {
                offset: {x: 10, y: 65},
                animate: {
                    enter: 'animated fadeIn',
                    exit: 'animated fadeOut'
                }
            });
        },

        showError: function (val) {
            $.notify({icon: "fa fa-exclamation-circle",
                message: val }, {
                type: 'danger', offset: {x: 10, y: 65}, animate: {
                    enter: 'animated fadeIn',
                    exit: 'animated fadeOut'
                }
            });
        },

        checkForNewTab: function (evt, elt) {
            if (elt.is('[ic-get-from]') && elt.closest('[ic-push-url]').length > 0) {
                if (evt.metaKey || evt.ctrlKey) {
                    window.open(elt.attr('ic-get-from'));
                    return false;
                }
            }
            return true;
        }

    };
})();


Intercooler.ready(function(elt) {

    // var sortable = elt.find('.sortable');
    // if (sortable[0]) {
    //     Sortable.create(sortable[0]);
    // }

    $('[data-toggle="tooltip"]').tooltip();
    $('[data-toggle="popover"]').popover();

});


$(function() {

    $('body').on("beforeSend.ic", function(evt, elt, data, textStatus, xhr, requestId){
        if(Intercooler.closestAttrValue(elt, 'app-progress-bar') == "true") {
            $("#ajax-progress").find('div.progress-bar').remove();
            $("#ajax-progress").html('<div id="req-' + requestId  + '-indicator" class="progress-bar" style="width: 0"></div>');
            setTimeout(function(){
                $("#req-" + requestId  + "-indicator").css("width", "20%");
            }, 80);
        }
    }).on("complete.ic", function(evt, elt, data, textStatus, xhr, requestId){
        var indicator = $("#req-" + requestId + "-indicator");
        if(indicator.length > 0) {
            indicator.css("width", "100%");
            setTimeout(function(){
                $("#req-" + requestId  + "-indicator").remove();
            }, 600);
        }
    });

    // AJAX alert events
    $('body').on('app.flash.notice', function(evt, val){
        App.showInfo(val);
    }).on('app.flash.alert', function(evt, val){
        App.showError(val);
    });

});