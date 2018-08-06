var device_size = '',
    shown_ads = [];

function show_ads() {
    if (Modernizr.mq('only screen and (min-width:1270px)') === true) {
        device_size = 'l_desktop';
    } else if (Modernizr.mq('only screen and (min-width:870px) and (max-width:1270px)') === true) {
        device_size = 'desktop';
    } else if (Modernizr.mq('only screen and (min-width:760px) and (max-width:870px)') === true) {
        device_size = 'tablet';
    } else if (Modernizr.mq('only screen and (min-width:320px) and (max-width:760px)') === true) {
        device_size = 'mobile';
    }

    $.each(ads, function(slot, devices) {

        if (shown_ads.indexOf(slot) == '-1') {

            if (devices.search('all') != '-1' || devices.search(device_size) != '-1') {

                googletag.cmd.push(function() {
                    googletag.display(slot);
                });

                shown_ads[shown_ads.length] = slot;
            }
        }
    });
}

$(document).ready(show_ads);
$(window).on("resize", show_ads);