/*
Author: Cole Thorsen

TABLE OF CONTENTS

GOOGLE_ANALYTICS . code for tracking events via .ga class.
COOKIES .......... functions for working with cookies.
iOS .............. Force iOS webapp to behave correctly.
HIDEBAR .......... hides status bar on iOS devices.
MESSAGES ......... Hide messages after delay.
MAIN_NAV ......... JS for opening nav on mobile.
LOAD_LATEST ...... Latest news loading system.
RESIZE_HEADER .... resizes the header hero to fit on the page.
HERO_SETUP ....... measures to set up the hero if the tab breaks to multiple lines.
COMMENTS ......... load comments and add comments.
TIME_DATE ........ localize time display and set it to show time ago.
HOMEPAGE ......... homepage auto reloading and infinite scroll.
VIDEOS ........... fixes sizing on videos where the browser window isn't high enough.
SHARRRE .......... sharrre styling and setup.
STICKY_SCROLL .... sticks an element to the window when it gets to the top.
FAQ .............. slides open FAQs
RESULTS .......... functions for results pages.
POLL_VOTE ........ vote in polls via ajax.
PICK_COUNTRY ..... Pick the proper country based on the region selection.
SUBSCRIBE_OPEN ... Handles the opening and closing of the subscribe nag.
SUBSCRIBE_PAGE ... shipping toggle, ajax get subscription total info.
MOBILE ........... funtions to tweak content for mobile.
DEALERS_SIDEBAR .. dealers sidebar functionality.
INTERSTITIAL ..... interstital ad setup.
EXPANDABLE_ADS ... expandable ad setup.
ACCOUNT_SETTINGS . Custom functions for account settings.
SEARCH ........... google custom search setup.
*/

/* $GOOGLE_ANALYTICS
____________________________________
var _gaq = _gaq || [];

$('.wrap').on('click', '.ga', function(){
	_gaq.push(['_trackEvent', $(this).attr('ga-category'), $(this).attr('ga-action'), $(this).attr('ga-label')]);
});

/* $COOKIES
____________________________________
function set_cookie( name, value, expires, path, domain, secure )
{
	var today = new Date(),
		expires = (expires) ? expires * 1000 * 60 * 60 * 24 : 0,
		expires_date = new Date( today.getTime() + (expires) );

	today.setTime( today.getTime() );

	document.cookie = name + "=" +escape( value ) +
	( ( expires ) ? ";expires=" + expires_date.toGMTString() : "" ) +
	( ( path ) ? ";path=" + path : "" ) +
	( ( domain ) ? ";domain=" + domain : "" ) +
	( ( secure ) ? ";secure" : "" );
}

function get_cookie( check_name ) {
	var a_all_cookies = document.cookie.split( ';' );
	var a_temp_cookie = '';
	var cookie_name = '';
	var cookie_value = '';
	var b_cookie_found = false;

	for ( i = 0; i < a_all_cookies.length; i++ )
	{
		a_temp_cookie = a_all_cookies[i].split( '=' );
		cookie_name = a_temp_cookie[0].replace(/^\s+|\s+$/g, '');
		if ( cookie_name == check_name ){
			b_cookie_found = true;
			if ( a_temp_cookie.length > 1 ){
				cookie_value = unescape( a_temp_cookie[1].replace(/^\s+|\s+$/g, '') );
			}
			return cookie_value;
			break;
		}
		a_temp_cookie = null;
		cookie_name = '';
	}
	if ( !b_cookie_found )
	{
		return null;
	}
}
*/
/* $iOS
 * force iOS web app to behave correctly
____________________________________*/
(function(a,b,c){if(c in b&&b[c]){var d,e=a.location,f=/^(a|html)$/i;a.addEventListener("click",function(a){d=a.target;while(!f.test(d.nodeName))d=d.parentNode;"href"in d&&(d.href.indexOf("http")||~d.href.indexOf(e.host))&&(a.preventDefault(),e.href=d.href)},!1)}})(document,window.navigator,"standalone");

/* $HIDEBAR
____________________________________*/
/*
 * Normalized hide address bar for iOS & Android
 * (c) Scott Jehl, scottjehl.com
 * MIT License
 */
(function( win ){
	var doc = win.document;
	
	// If there's a hash, or addEventListener is undefined, stop here
	if( !location.hash && win.addEventListener ){
		
		//scroll to 1
		window.scrollTo( 0, 1 );
		var scrollTop = 1,
			getScrollTop = function(){
				return win.pageYOffset || doc.compatMode === "CSS1Compat" && doc.documentElement.scrollTop || doc.body.scrollTop || 0;
			},
		
			//reset to 0 on bodyready, if needed
			bodycheck = setInterval(function(){
				if( doc.body ){
					clearInterval( bodycheck );
					scrollTop = getScrollTop();
					win.scrollTo( 0, scrollTop === 1 ? 0 : 1 );
				}
			}, 15 );
		
		win.addEventListener( "load", function(){
			setTimeout(function(){
				//at load, if user hasn't scrolled more than 20 or so...
				if( getScrollTop() < 20 ){
					//reset to hide addr bar at onload
					win.scrollTo( 0, scrollTop === 1 ? 0 : 1 );
				}
			}, 0);
		} );
	}
})( this );

/* $MESSAGES
____________________________________*/
function hide_messages() {
	$('.message:not(.keep)').slideUp(function(){
		$('.message:not(.keep)').remove();
	});
}

function message_timer() {
	if($('.message:not(.keep)').length > 0) {
		setTimeout(hide_messages, 5000); //hide after 5 seconds.
	}
}

function set_message(message) {
	$('.nav_main').append(message);
	message_timer();
}

function build_message(type, msg) {
	message = '<div class="message ' + type + '"><i></i>' + msg + '</div>';

	set_message(message);
}

$(window).one('load', message_timer);


/* $MAIN_NAV
____________________________________*/

$('.touch .nav_main .parent > a').on('click touch', function() {

	//close everything else.
	$(this).parent().siblings('li').removeClass('current');

	//open or close this.
	$(this).parent().toggleClass('current');

	return false;
});

$(document).on('ready', function() {
		//$('.dropdown:not(.features, .account)').append('<div class="dropdown_wrap"><div class="dropdown_content"><img class="loading" src="//rx.iscdn.net/i/icons/loader.gif" alt="Loading&hellip;"></div></div>');
	});

$('.nav_main .parent').on('mouseenter touchstart', function(){

		//we can't test the width in old browsers, so if respond is undefined we load it anyways.
		if(Modernizr.mq('only screen and (min-width: 870px)') || typeof respond !== 'undefined') {
			
			if($(this).find('.loading').length) {

				var link = $(this).children('a').attr('href');

				if(link == '/') {

					load_latest();

				} else {
				
					$(this).find('.dropdown_content').load('/navigation' + link, time_date());
				
				}
			}
		}
	});

/* $LOAD_LATEST
____________________________________
function load_latest() {
	$.ajax({
		url: '/content/latest.htm',
		dataType: 'json',
		success: function(news) {
			var features = '',
				latest_news = '',
				unread = 0,
				refresh = get_cookie('refresh').split('_');

			$.each(news.features, function(i, news){

				if(news.gmdate > refresh[1]) {
					unread++;
				}

				features += build_post(news);
			});

			$.each(news.latest_news, function(i, news){

				if(news.gmdate > refresh[1]) {
					unread++;
				}

				latest_news += build_post(news);
			});

			$('.dropdown.latest').html('<div class="col_1_2"><div class="module"><h1>Features</h1><ul class="grid ui_line ui_list">'+features+'</ul></div></div><div class="col_1_2 drop_shadow"><div class="module"><h1>Latest News</h1><ul class="grid ui_line ui_list">'+latest_news+'</ul></div></div>');

			time_date();

			_gaq.push(['_trackEvent', 'Latest', 'Loaded']);

			if($('.dropdown.latest').is(":hidden")) {
				
				set_refresh_cookie(unread, refresh[1]);

				show_unread_count();
			}

			//see if we need to load new content into the homepage.
			if($('#welcome, #welcome_admin').length > 0 && news.newest > $('#newest_timestamp').attr('data-time')) {

				load_updates();

				$('#newest_timestamp').attr('data-time', news.newest);

			}
		}
	});
}

function build_post(news) {

	return '<li class="col_1_2" itemscope itemtype="http://schema.org/NewsArticle"><div class="module"><a itemprop="url" href="'+news.url+'" class="ui_link"><img src="'+news.thumb_image+'" alt="'+news.title+'" class="pull_left" width="40%"><span class="link_content"><span class="link_title" itemprop="name">'+news.title+'</span><span class="link_foot"><span class="split date i_clock" itemprop="datePublished" content="'+news.c_date+'" data-format="'+news.date_format+'">'+news.date+'</span></span></span><span class="corner_i i_'+news.type+'"></span></a></div></li>';

}

//reset the refresh cookie if it doesn't exist or if the user is visiting the homepage.
function setup_refresh_cookie() {

	var refresh = get_cookie('refresh');

	if($('#welcome').length > 0 || refresh === null) {

		set_refresh_cookie(0);

	}
}

//set the cookie.
function set_refresh_cookie(stories, utc) {

	//if no value for the previous refresh is passed, set the value as the current time.
	if(typeof utc === 'undefined') {
		var now = new Date(),
			offset = now.getTimezoneOffset();
		
		utc = now.getTime() + (offset * 60000); //get date of item in UTC
	}

	var cookie = stories + '_' + utc;

	set_cookie('refresh', cookie, 1, '/');
}

function show_unread_count() {

	var refresh = get_cookie('refresh');

	if(refresh !== null) {

		refresh = refresh.split('_');

		$('.latest_count .flag').remove();

		if(refresh[0] > 0) {

			if(refresh[0] > 10) {

				refresh[0] = '10+';

			}

			$('.latest_count').prepend('<span class="flag flag_red">'+refresh[0]+'<span>');

			document.title = 'New articles have been posted on Racer X Online';
		}

	}
}

$('.latest_count').on('mouseenter touchstart', function(){
	set_refresh_cookie(0);

	_gaq.push(['_trackEvent', 'Latest', 'Opened']);

	$('.latest_count .flag').remove();
});

$(document).on('ready', function() {
	
		if(Modernizr.mq('only screen and (min-width: 870px)')) {

			refresh = setInterval('load_latest()', 300000);

			setup_refresh_cookie();

			show_unread_count();

			//set the title back to the normal title on focus.
			old_title = document.title;

			$(window).focus(function() {
				document.title = old_title;
			});
		}
	});
*/
/* $RESIZE_HEADER
____________________________________*/
function resize_header()
{
	//TODO: Fails in IE8, seems like it fires before the respond rebuilds the media queries.
	var h = $(window).height() - $('.header_hero').offset().top - 50, // get offset from top, 50 is the height of the subscribe nag.
		hh = $('.header_hero').height();

	if(hh > h) {
		var m = (hh-h),
			mb = m * 0.6,
			mt = m * 0.4;

		$('.header_hero > img').attr('style', 'margin-top:-'+mt+'px');
		$('.header_hero .title_wrap').attr('style', 'margin-top:-'+mb+'px');
	}
}

if($('.header_hero').length > 0 && typeof respond === 'undefined') {
	$(window).on('load resize', resize_header);
}
/* $HERO_SETUP
____________________________________*/
function hero_setup()
{
	$('.hero_title > span').each(function(){
	
		if(Math.round(parseInt($(this).height(), 10) / parseInt($(this).css('line-height'), 10)) > 1) {

			$(this).html($(this).html().replace('<shybr>', '<br>'));
				
		}

	});
}

hero_setup();


/* $COMMENTS
____________________________________*/
function scroll_comments() {

	var h = $(document).height() - $('.footer').outerHeight() - $(window).height(),
		scroll_top =  $(window).scrollTop();

	if(scroll_top > h) {

		_gaq.push(['_trackEvent', 'Comments', 'Loaded', window.location.pathname]);

		load_comments();
	}
}

function load_comments(callback) {

	$('#comments').load($('#comments').attr('data-url'), function(){
		resize_halfpage();
		if(typeof callback !== 'undefined') {
			callback.call();
		}
		time_date();
	});

	$(window).off('scroll.comments');
}

function resize_halfpage()
{
	var event = {};
	event.data = {};
	event.data.element = '.scroll_halfpage';
	event.data.padding = $('.nav_main').outerHeight()+10;
	scroll_resize(event);

}
if($('#comments').length > 0) {
	
	$(window).on('scroll.comments', scroll_comments);
}

//display reply dialog whereever necessary.
$('.wrap').on('click', '.reply', function() {
		var comment = $(this).closest('.comment_content'),
			id = comment.attr('data-id'),
			replies = comment.next('.replies');

		comment.parent('article').addClass('has_replies');

		if(replies.children('.respond').length === 0) {

			replies.append($('.respond').first().clone());
			replies.find('.comment_box').attr('placeholder', 'Leave a Replyâ¦').attr('style', '').focus();
			replies.children('.respond').append('<input type="hidden" name="parent" value="'+id+'">');

		}

		//TODO: need to scroll to location of reply field (might be under a list of other replies).

		return false;
	});

//ajax submit the comment form.
$('.wrap').on('submit', 'form.respond', function() {

	$.ajax({
			context: this,
			type: "POST",
			url: $(this).attr('action'),
			data: $(this).serialize(),
			success: function(data) {
				$(this).before(data);

				//don't clear the comment box if there was an error with the post.
				if($('.alert').length < 1) {

					$('.comment_box').val('');
				
				}

				message_timer();
				
				_gaq.push(['_trackEvent', 'Comments', 'Commented', window.location.pathname]);
			},
			error: function(data) {
				
				build_message('alert', 'Your session has expired please <a href="/account/sign_in">login again</a>');
			}
		});

	return false;
});

//ajax report a comment.
$('.wrap').on('click', '.report', function() {

	$.get($(this).attr('href'), function(data){
		set_message(data);
	});

	return false;
});

//autogrow text area.
$('.wrap').on('keyup', '.comment_box', function(){

	var h = this.scrollHeight;

	if(h < 35) {
		h = 35;
	}

	$(this).css('height', h);

});
$('.wrap').find('.comment_box').keyup();

/* $TIME_DATE
____________________________________*/

//adds ISO functionality to IE8
(function(){
	var D= new Date('2011-06-02T09:34:29+02:00');
	if(!D || +D!== 1307000069000){
		Date.fromISO= function(s){
			var day, tz,
			rx=/^(\d{4}\-\d\d\-\d\d([tT ][\d:\.]*)?)([zZ]|([+\-])(\d\d):(\d\d))?$/,
			p= rx.exec(s) || [];
			if(p[1]){
				day= p[1].split(/\D/);
				for(var i= 0, L= day.length; i<L; i++){
					day[i]= parseInt(day[i], 10) || 0;
				};
				day[1]-= 1;
				day= new Date(Date.UTC.apply(Date, day));
				if(!day.getDate()) return NaN;
				if(p[5]){
					tz= (parseInt(p[5], 10)*60);
					if(p[6]) tz+= parseInt(p[6], 10);
					if(p[4]== '+') tz*= -1;
					if(tz) day.setUTCMinutes(day.getUTCMinutes()+ tz);
				}
				return day;
			}
			return NaN;
		}
	}
	else{
		Date.fromISO= function(s){
			return new Date(s);
		}
	}
})();

function time_date() {

	//TODO: in IE8 this breaks articles for some reason so we turned it off.
	if(typeof respond !== 'undefined') {
		return false;
	}

	var now = new Date(),
		offset = now.getTimezoneOffset();

	$('.date').each(function() {
		
		var f = $(this).attr('data-format'), //get the format.
			d = Date.fromISO($(this).attr('content')), //get date of item as js object
			utc = d.getTime() + (d.getTimezoneOffset() * 60000), //get date of item in UTC
			nd = new Date(utc - (offset * 60000)),
			content = '';

		//find out how many min ago the date is.
		diff = (now.getTime() - nd.getTime()) / 60000;
		
		//if the date is witin 48 hours of the current date. 
			//This is important so we don't get into problems with dates from other months/years
		if ((diff > -2880) && (diff < 2880)) {

			//if we're displaying a time and its today.
			if (f.search(/g|i|a/g) >= 0 && now.getDate() == nd.getDate()) { //if you update to use more than g, i, a for displaying time update regex here

				//totally kill the format because we're going to show min ago or hours ago.
				f = '';

				//set the time ago.
				if (diff < 60) { //less than 60 min
					
					content = Math.round(diff) + ' min ago';

				} else {
					hrs = Math.round(diff / 60);

					content = hrs + ' hour' + (hrs > 1 ? 's' : '') + ' ago';
				}
			
			//if we are displaying a date.	
			} else if (f.search(/M|j|l|F|Y/g) >= 0) {  //if you update to use more than j, l, F, Y for displaying date update regex here and at the end of this else statement.

				rel = '';

				//show yesterday today tomorrow
				if (now.getDate() == nd.getDate()) {

					rel = 'Today ';

				} else if (now.getDate() - 1 == nd.getDate()) {

					rel = 'Yesterday ';

				} else if (now.getDate() + 1 == nd.getDate()) {

					rel = 'Tomorrow ';
				}

				//replace all day/month/year options with relative date.
				if(rel.length > 0) {
					f = f.replace(/[jlDFMY ,]*/, 'X');
				}
			}
		}

		$.each(f.split(''), function(i, v){

			switch(v) {
				case 'g': //12 hour
					v = (nd.getHours() < 13) ? nd.getHours() : nd.getHours() - 12;
					v = (v === 0) ? 12 : v;
					break;
				case 'i': //minutes with leading 0
					v = ('0' + nd.getMinutes()).slice(-2);
					break;
				case 'a' : //am/pm
					v = (nd.getHours() < 12) ? 'am' : 'pm';
					break;
				case 'j' : //date
					v = nd.getDate();
					break;
				case 'l' : //full day
					v = day(nd.getDay());
					break;
				case 'D' : //short day
					v = short_day(nd.getDay());
					break;
				case 'F' : //full month
					v = month(nd.getMonth());
					break;
				case 'M' : //short month
					v = short_month(nd.getMonth());
					break;
				case 'Y' : //year
					v = nd.getFullYear();
					break;
				case 'X' :
					v = rel;
			}

			content += v;
		});

		$(this).html(content); //TODO: this hides the whole article in IE8
	});

}

$(document).on('ready', time_date);

window.setInterval(time_date, 60000);

function day(i)
{
	var days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];
	return days[i];
}

function short_day(i)
{
	var days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
	return days[i];
}

function month(i)
{
	var months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
	return months[i];
}

function short_month(i)
{
	var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
	return months[i];
}

/* $HOMEPAGE
____________________________________*/
var page = 2,
	block = 0,
	did_scroll = false;

function infinite_scroll() {

	var scroll_top = $(window).scrollTop(),
		total_h = scroll_top + $(window).height();

	$('.iframe_ad.unloaded').each(function(){
		if(total_h + 50 > $(this).offset().top) {
			$(this).attr('src', $(this).attr('data-src')).removeClass('unloaded');

		}

	});

	//load the next page if we are close enough.
	if((total_h > $('#features span:last').offset().top || total_h > $('#latest_news span:last').offset().top || total_h > $('#videos span:last').offset().top) && block === 0) {

		block = 1;

		$.get('/welcome/page/' + page, function(data){
			data = jQuery.parseJSON(data);

			$.each(data, function(key, val) {

				$('#' + key).append(val);

			});

			_gaq.push(['_trackPageview', '/homepage/page/' + page]);

			//hide duplicate posts
			hide_duplicates();

			//fix all the dates and times.
			time_date();

			//fix the hero titles
			hero_setup();

			block = 0;

			if(page == 9) {

				$(window).off('scroll.infinite', infinite_scroll);

				//TODO: figure out a good way to deal with hiding extra posts.
				//var height = Math.min($('#features span:last').offset().top, $('#latest_news span:last').offset().top, $('#videos span:last').offset().top);

				//$('.main').css('height', height+'px').css('overflow', 'hidden');

			}

			page++;
		});
	} else if (scroll_top < $('.home_grid').offset().top) {

		$('.home_grid ul, .home_grid span').removeClass('hide');

		$('.new_posts').addClass('hide');

		setTimeout(function(){$('.new_posts').remove();}, 300);

	}
}

//load updated content into the homepage. This works in conjunction with the latest news loader.
function load_updates() {

	$.get('/welcome/page/1', function(data){
		data = jQuery.parseJSON(data);

		//bring in the new stories
		$.each(data, function(key, val) {

			$('#' + key).prepend('<div class="new_stories hide">'+val+'</div>');

		});

		//hide the new stories.
		$('.new_stories').children('ul, span').addClass('hide');
		$('.new_stories .ad_wrap, .new_stories .ad_tag').remove();

		$('.new_stories').each(function(){

			$(this).parent().children('.new').after($(this).html());

			$(this).remove();

		});

		_gaq.push(['_trackPageview', '/homepage/all-auto-refresh']);

		//fix all the dates and times.
		time_date();

		//hide duplicate posts
		hide_duplicates();

		//fix the hero titles
		hero_setup();

		infinite_scroll();

		$('.wrap').append('<div class="new_posts fade_down trans_3 hide"><a href="/">New Stories</a></div>');

		$('.new_posts').offset();
		$('.new_posts').removeClass('hide');
	});
}

//clears out duplicates on the homepage, if there are duplicates.
function hide_duplicates() {

	var seen,
		id;
	$('#features, #videos').each(function(){
		seen = {};
		
		$($(this).children('span').get().reverse()).each(function() {
			
			id = $(this).attr('data-id');
			
			if (seen[id])
				$(this).remove();
			else
				seen[id] = true;

		});

	});

	seen = {};
	
	$($('#latest_news ul li').get().reverse()).each(function() {

		id = $(this).attr('data-id');
		
		if(typeof id !== 'undefined') {

			if (seen[id])
				$(this).remove();
			else
				seen[id] = true;
		}
	});

	var prev_date = '';

	$('#latest_news .date + .date').remove();

	$('#latest_news ul .date').each(function() {

		var this_date = $(this).html();

		if(this_date == prev_date) {

			$(this).remove();
		}

		prev_date = this_date;

	});
	setup_latest_news();
}

//updates the homepage when it has detected a user coming from back.
function history_setup_homepage() {

	if(history.replaceState) {
		$('.wrap').on('click', 'a', function(){

			data = {
					'content': $('.home_grid').html(),
					'page': page,
					'scroll': $(window).scrollTop()
				};

			history.replaceState(data, '', '');
		});
	}

	if(history.state) {
		var data = history.state;

		$('.home_grid').html(data.content);
		page = data.page;

		$(window).scrollTop(data.scroll);

		history.replaceState(null, '', '');
	}
}

//set up infinite scroll to fire on a 250ms timer.
if($('#welcome, #welcome_admin').length > 0) {

	setup_latest_news();

	history_setup_homepage();

	check_expandable();

	$(window).on('scroll.infinite', function(){
		did_scroll = true;
	});

	setInterval(function(){
		if (did_scroll === true) {
			did_scroll = false;
			infinite_scroll();
		}
	}, 250);

	$('.wrap').on('click', '.new_posts', function() {

		$(window).scrollTop(0);
		return false;
	});
}

//setup latest news
function setup_latest_news() {
	
	var show = get_cookie('latest_news');

	//if there is no cookie set, default to showing the industry news.
	if(show === null) {
		show = 'both';
	}

	$('#latest_news').removeClass('hide_breaking').removeClass('hide_industry');

	//set the checkboxes.
	if (show == 'none' || show == 'industry') {
		$('#input_show_breaking').prop('checked', false);
		$('label[for=input_show_breaking]').removeClass('active');
		$('#latest_news').addClass('hide_breaking');
	}
	if (show == 'none' || show == 'breaking') {
		$('#input_show_industry').prop('checked', false);
		$('label[for=input_show_industry]').removeClass('active');
		$('#latest_news').addClass('hide_industry');
	}

	//hide dates that have no visible post after them.
	$('#latest_news > .date').show();

	$('#latest_news > .date').each(function() {

		if($(this).nextAll('li:visible').first().hasClass('date')) {
			$(this).hide();
		}
	});

	set_cookie('show', show, 90, '/');

	_gaq.push(['_trackEvent', 'Homepage View Latest News', show, 1, true]);
}

$('.body').on('change', '.input_latest_news', function(){
	
	$('label[for='+this.id+']').toggleClass('active');

	var show = 'none';

	if ($('#input_show_breaking').is(':checked') && $('#input_show_industry').is(':checked')) {

		show = 'both';

	} else if ($('#input_show_breaking').is(':checked')) {

		show = 'breaking';

	} else if ($('#input_show_industry').is(':checked')) {

		show = 'industry';

	}

	set_cookie('latest_news', show, 90, '/');

	setup_latest_news();

	_gaq.push(['_trackEvent', 'Latest News Toggle', show]);

}).change();


/* $VIDEOS
____________________________________*/
function video_max_height()
{
	var h = $(window).height();

	if(h < 780) {
		$('.video_wrap').css('max-width', (h - 80) * 1.78 + 'px');
	}

	$('.video_wrap div div').css('height', $('.video_wrap').outerHeight());
}

$(window).on('load resize', video_max_height);

/* $SHARRRE
____________________________________
$('.share').sharrre({
	url: $('link[rel=canonical]').attr('href'),
	share: {
		twitter: true,
		facebook: true
	},
	buttons: {
		twitter: {
			via: $('meta[property="twitter:site"]').attr('content'),
			related: $('meta[property="twitter:site"]').attr('content') + ',' + $('meta[property="twitter:creator"]').attr('content'),
			url: $('meta[property="twitter:url"]').attr('content')
		},
		facebook: {
			url: $('meta[property="og:url"]').attr('content')
		}
	},
	template: '<ul><li><span class="num">{total}</span><i class="i_share"></i></li><li><a class="facebook" href=""><span class="num"></span><i class="i_facebook"></i></a></li><li><a class="twitter"><span class="num"></span><i class="i_twitter"></i></a></li><li><a href="/post/email/'+$('.share').attr('data-id')+'" onclick="window.location=\'/post/email/'+$('.share').attr('data-id')+'\'; return false;"><span class="block">Send</span><i class="i_newsletter"></i></a></li></ul>',
	enableHover: false,
	enableTracking: true,
	render: function(api, options){
		$(api.element).on('click', '.twitter', function() {
			api.openPopup('twitter');
			//TODO: add count+ when clicked
		});
		$(api.element).on('click', '.facebook', function() {
			api.openPopup('facebook');
			//TODO: add count+ when clicked
		});
		
		$(api.element).find('.facebook .num').html(api.options.count.facebook);
		$(api.element).find('.twitter .num').html(api.options.count.twitter);
	}
});
*/
/* $STICKY_SCROLL
____________________________________*/

var scroll = [];

function scroll_this(event) {

	var e = event.data.element,
		el = $(e),
		padding = event.data.padding;

	if(!scroll[e]) {
		scroll[e] = [];
		scroll[e]['offset'] = el.offset().top;
		scroll[e]['top'] = $(document).height() - $('.footer').outerHeight() - el.height() - padding - 53;

		$(window).on('resize.'+e, {element: e, padding: padding}, scroll_resize);
	}

	var scroll_top = $(window).scrollTop();

	//bottom position.
	if(scroll[e]['top'] < scroll_top) {

		el.attr('style', 'position:absolute; top:'+(scroll[e]['top'] - el.parent().offset().top + padding) + 'px;');

	//sticky position
	}else if(scroll_top + padding > scroll[e]['offset']) {

		el.attr('style', 'position:fixed; top:'+padding+'px;');

	//top position
	}else{

		el.attr('style', 'position: relative;');
	}
}

// runs on resize
// this lets things like iPad orientation allow for the halfpage to be displayed or not displayed and it still works.
function scroll_resize(event) {

	var e = event.data.element,
		el = $(e);

	el.attr('style', 'position: relative;');

	delete scroll[e];

	$(window).off('resize.'+e);

	scroll_this(event);
}

//runs on page load
function init_scroll() {
	if($('.scroll_halfpage:visible').length > 0) {

		$(window).on('scroll touchmove', {element: '.scroll_halfpage', padding: $('.nav_main').outerHeight()+10}, scroll_this);
	}
}

$(window).on('load', init_scroll);


/* $FAQ
____________________________________*/
function open_faq(e) {
	$(e.target).siblings('.hide').slideToggle(200);

	return false;
}

$('.faqs').on('click', 'li > a', open_faq);

/* $GALLERY
__________________________*/
/*
(function(window, $, Gallery){
	
	$(document).ready(function(){
		
		if ($(".gallery").length) {

			var options = {
				adCode: $("meta[property=gallery_ad]").attr('content'),
				carouselWithThreshold: 920,
				carouselWidthModifier: -340, // Make room for our Ad.
				commentElement: $("#comments")[0],
				comments: !$("a.gallery").first().is('.no-comment')
			};

			$('#comments').hide();
			// TODO: Unbind loading of comments on scroll

			$("a.gallery").Gallery(options);

			if (window.location.hash.indexOf('Gallery') === 1) {
				$($("a.gallery")[parseInt(window.location.hash.substring(8))]).trigger('click');
			}
		}
	
	});
	
	
}(window, window.jQuery, window.Instinct.Gallery));*/

// function build_gallery(e) {

// 	if($('.gallery').length === 0) {

// 		$('.wrap').append('<div class="gallery"><div class="flexslider slider"></div><div class="flexslider slider_nav"><a href="#" class="toggle_thumbs i">navigatedown</a><a href="#" class="toggle_thumbs i hide">navigateup</a></div><a class="i close">Close</a></div>');

// 		gallery_build_list();

// 		// The slider being synced must be initialized first
// 		$('.slider_nav').flexslider({
// 			animation: "slide",
// 			controlNav: false,
// 			animationLoop: false,
// 			slideshow: false,
// 			itemWidth: 140,
// 			itemMargin: 0,
// 			multipleKeyboard: true,
// 			prevText: "<i class=i>Previous</i>",
// 			nextText: "<i class=i>Next</i>",
// 			asNavFor: '.slider'
// 		});

// 		$('.slider').flexslider({
// 			animation: "slide",
// 			controlNav: false,
// 			slideshow: false,
// 			multipleKeyboard: true,
// 			prevText: "<i class=i>Previous</i>",
// 			nextText: "<i class=i>Next</i>",
// 			sync: ".slider_nav"
// 		});

// 	}

// 	$('body').addClass('gallery_open');

// 	$('.gallery').show();

// 	var picked = $(e.target).parent().parent().index();

// 	$('.slider').flexslider(picked);

// 	return false;
// }

// function gallery_build_list()
// {
// 	//alert(list);

// 	var slider = $('<ul class="slides"></ul>'),
// 		slider_nav = $('<ul class="slides"></ul>');

// 	$('.photo_gallery li a').each(function(){

// 		var image = $(this).attr('href'),
// 			thumb = $(this).children('img').attr('src');

// 		slider.append('<li><img data-src="'+image+'"></li>');

// 		slider_nav.append('<li><img src="'+thumb+'"></li>');

// 	});

// 	$('.gallery .slider').append(slider);
// 	$('.gallery .slider_nav').append(slider_nav);
// }

// function toggle_thumbs()
// {
// 	$('.slider_nav').toggleClass('closed');
// 	$('.toggle_thumbs').toggleClass('hide');
// }

// function close_gallery()
// {
// 	$('.gallery').hide();
// 	$('body').removeClass('gallery_open');
// }

// $('.photo_gallery').click(build_gallery);

// $('.wrap').on('click', '.gallery .close', close_gallery);

// $('.wrap').on('click touch', '.toggle_thumbs', toggle_thumbs);

/* $RESULTS
____________________________________*/
$('.wrap').on('click touch', '.expand', function(){

		$(this).prev('table').children('tbody').children('.hide').toggle();

		text = $(this).text();

		if(text == 'Show Full Standings') {
			text = 'Hide Full Standings';
		}else{
			text = 'Show Full Standings';
		}

		$(this).text(text);
	});

/* $POLL_VOTE
____________________________________*/
$('.wrap').on('submit', '.poll_form', function(){

	var el = $(this);

	el.append('<input type="hidden" name="submit_token" value="' +  get_cookie('submit_cookie') + '">'); 

	$.ajax({
		url: el.attr('action'),
		type: 'post',
		data: el.serialize(),
		success: function(data) {
				
				el.replaceWith(data);
			}
	});

	return false;
});

/* $PICK_COUNTRY
____________________________________*/
$('.body').on('change', '.input_region', function(){
	var val;

	//get the optgroup label
	switch($(this).add(':selected').parent('optgroup').attr('label')) {
		case 'States':
			val = 'US';
			break;
		case 'Provinces':
			val = 'CA';
			break;
	}

	//apply value to the next country input.
	$(this).parent().next().children('.input_country').val(val);
});

/* $SUBSCRIBE_OPEN
____________________________________*/

//load subscription panel if its not already loaded.
function load_sub() {

	if( $('.sub_body').is(':empty') ) {
		$('.sub_body').load('/subscribe');
	}
}

//peeks subscribe nag.
/*$(window).one('load', function(){
	
	if (Modernizr.mq('only screen and (min-width: 570px)') || typeof respond !== 'undefined') {

		var min_posts = 3, //minimum posts viewed before someone can be shown the peek.
			reshow_days = 30, //minimum number of days before peek can be re-shown.
			val = get_cookie('sub_peek') || 0; //cookie either contains page views or if peek has shown then it shows true.

		//only check if they are on a post page and they haven't been shown a peek.
		if($('#post').length === 0 || val === 'true') {
		
			return false;
		
		} else {

			val++;
		}

		//if we've crossed the minimum threshold the subscribe nag is there.
		if(val >= min_posts && $('#subscribe').length > 0) {

			load_sub();

			var h = $(window).height() - 335; //offset of subscribe peek nag.

			$('.sub_bar').addClass('sub_bar_peek').attr('style', 'top: '+h+'px');

			val = 'true';
		}

		set_cookie('sub_peek', val, reshow_days, '/');

		_gaq.push(['_trackEvent', 'Subscribe', 'Peek']);

	}
});*/

//opens the subscribe nag.
function open_sub() {
	load_sub();

	$('.sub_bar').addClass('sub_bar_open').removeAttr('style');

	return false;
}
$('.wrap').on('click', '.sub_open', open_sub);

//closes the subscribe nag.
$('.wrap').on('click', '.sub_close', function(){
	$('.sub_bar').removeClass('sub_bar_open').removeClass('sub_bar_peek').removeAttr('style');
	return false;
});

/* $SUBSCRIBE_PAGE
____________________________________*/
$(document).on('ready', function(){
	
	var id = $('input[name=type]:checked').attr('id');

	$('label[for='+id+']').addClass('sub_selected');

});

//handles subscription option radios
$('.wrap').on('change', '.sub_options input', function(){
	
	open_sub();

	//remove class from all other labels associated with this input.
	$('input[name='+$(this).attr('name')+']').each(function(){
		$('label[for='+this.id+']').removeClass('sub_selected');
	});

	//add class to currently checked input's label.
	$('label[for='+this.id+']').addClass('sub_selected');

	update_total();

	//TODO: track interactions that open the peek to full subscribe.
}).change();

//opens the shipping fields.
$('.wrap').on('change', '#input_shipping_different', function(){
	$('#shipping').slideToggle(this.checked);
});

$('.wrap').on('change', '#input_send_free', function(){

	if(this.checked) {
		$('.free_inputs input, .free_inputs select').removeAttr('disabled');
	} else {
		$('.free_inputs input, .free_inputs select').attr('disabled', 'disabled');
	}
});

//updates the total price for the subscription.
function update_total() {
	$('#total').html('<img class="loading" src="//rx.iscdn.net/i/icons/loader.gif" alt="Loading&hellip;">');
	
	$.post('/subscribe/price_details',
		$('.form_subscribe').serialize(),
		function(response){
			$('#total').html(response);
		});
}

//fire update_total on load of subscribe form.
$(window).one('load', function() {
	
	if($('.subscribe_options').length > 0) {
		update_total();
	}
});

//fire update_total whenever a relevant input is changed.
$('.wrap').on('change', '.form_subscribe .input_country, .form_subscribe .input_region, #shipping_different', update_total);

/* $MOBILE
____________________________________*/
//convert context nav into dropdown.	
/*if(Modernizr.mq('(max-width: 570px)')) {
	$('.nav_context').each(function(){

		$(this).prepend('<a class="btn dropdown-toggle" data-toggle="dropdown">More Info <span class="caret"></span></a>')
				.addClass('btn-group')
				.removeClass('nav')
				.removeClass('nav_context')
				.children('ul').addClass('dropdown-menu');
	});
}*/
//take a table that is too wide and combine fields (use .hide_mobile_v to just hide fields)
/*var mod_done = false;
function mod_mobile_tables() {
	if(mod_done === true) {
		return false;
	}
	if(Modernizr.mq('(max-width: 400px)')) {
		$('.mod_mobile').each(function(){
			//get the columns to merge.
			var merge = $(this).attr('data-merge').split(','),
				merge_into = parseInt(merge.shift(), 10);

			//iterate over every row.
			$(this).children('tbody').children('tr').each(function(){

				var tds = $(this).children('td'),
					merge_to = tds.eq(merge_into).append('<span class="show_mobile_v"></span>').children('.show_mobile_v');

				$.each(merge, function(i, v) {
					merge_to.append(tds.eq(parseInt(v, 10)).html()+'<br>');
				});

			});
		});
		mod_done = true;
	}
}

$(window).on('load resize', mod_mobile_tables);
*/
/* $DEALERS_SIDEBAR
____________________________________*/
function parse_json(json) {
	if(json !== null) {
		json = $.parseJSON(json);
	}

	return json;
}


if($('.sub_dealer').length > 0) {

	if (Modernizr.mq('only screen and (min-width: 700px)') || typeof respond !== 'undefined') {

		var loc = get_cookie('loc'),
			dealers = get_cookie('dealers_a');

		loc = parse_json(loc);
		dealers = parse_json(dealers);

		//if the cookies are set, or the location is set to non US don't make the ajax request.
		if( (loc !== null && loc['ip'] == $('.sub_dealer').attr('data-ip') ) && ( (dealers !== null && dealers !== [] ) || loc['country'] != 'US') ) {

			show_dealer(loc, dealers);

		} else {
			
			$.ajax({
				url: '/assets/dealer.php',
				success: function() {
					loc = parse_json(get_cookie('loc'));
					dealers = parse_json(get_cookie('dealers_a'));
				
					show_dealer(loc, dealers);
				}
			});

		}
	}
}

function show_dealer(loc, dealers) {

	if(loc !== null && loc['country'] == 'US') {

		//get a random dealer.
		dealer = dealers[Math.floor(Math.random() * dealers.length)];

		dealer.name = dealer.name.split('+').join(' ');
		dealer.city = dealer.city.split('+').join(' ');

		$('.sub_dealer').html('<a href="/subscribe"><span class="sub_title">Subscribe</span> <span class="sub_heading">to Racer X</span></a> <div class="or"><span>or get it at</span></div> <h2><a class="ga" ga-category="Dealer" ga-action="Website Visit (Ad)" ga-label="' + dealer.name + ', ' + dealer.city + ', ' + dealer.state + '" href="' + dealer.website + '" target="blank" title="Motocross Dealership in ' + dealer.city + ', ' + dealer.state + '">' + dealer.name + '</a></h2>' + dealer.city + ', ' + dealer.state + '<nav><ul><li><a href="/dealer/' + dealer.url + '">Directions</a></li><li><a href="/dealers">More Dealers</a></li><li><a href="http://www.filterpubs.com/dealers" target="blank">Add Your Dealership</a></li></ul></nav>');
	
		_gaq.push(['_trackEvent', 'Dealer', 'Show', dealer.name + ', ' + dealer.city + ', ' + dealer.state, 1, true]);
	}
}

/* $INTERSTITIAL
____________________________________
//shows the interestitial
$(document).one('ready', function(){
	
	if(Modernizr.mq('only screen and (max-width: 870px)') && show_mobile_interstitial === true) {
		show_interstitial('mobile');
		
	} else if (show_desktop_interstitial === true) {
		show_interstitial('desktop');
		
	}
});

function show_interstitial(type) {
	var ad_min_pages = 2, //minimum pages viewed before someone can be shown the interstitial.
		ad_reshow_days = 1, //minimum number of days before interstitial can be re-shown.
		ad_val = get_cookie('interstitial') || 0; //cookie either contains page views or if peek has shown then it shows true.

	//if ad has been shown.
	if(ad_val != 'shown') {

		//certain pages shouldn't fire an interstitial.
		if($('#account').length > 0) {
		
			return false;
		
		} else {

			ad_val++;
		}
		
		switch(type){
			case 'mobile':
				var ad = 'RXOMediumRectangleMobileInterstitial',
					w = '300',
					h = '250'
				break;
			case 'desktop':
				var ad = 'RXO640Interstitial',
					w = '640',
					h = '480';
				break;
		}


		//if we've crossed the minimum threshold.
		if(ad_val >= ad_min_pages) {

			$('.wrap').append('<div class="interstitial"><iframe class="ad iframe_ad" width="' + w + '" height="' + h + '" scrolling=no frameborder=0 allowtransparency=true src="http://rx.iscdn.net/assets/ad.htm?ad=' + ad + '&amp;size=' + w + ',' + h + '"></iframe></div>');

			setTimeout(show_interstitial_close, 3000);

			ad_val = 'shown';
			
		}

		set_cookie('interstitial', ad_val, ad_reshow_days, '/');
	}

}

function show_interstitial_close() {
	$('.interstitial').append('<a href="#" class="interstitial_close close i_close"></a>');
}

$('.wrap').on('click', '.interstitial_close', function(){
	$('.interstitial').remove();
	return false;
});
*/
/* $EXPANDABLE_ADS
____________________________________*/

function check_expandable() {

	$('.wrap').on('mouseenter.expandable', '.ad_3_1 > div > iframe', function(){

		var expandable = $(this).contents().find('div[id^="dclk_expand_"]');

		if(expandable.length > 0) {

			$(this).addClass('is_expandable').css({position: 'absolute', right: '0'}).attr('data-small-width', $(this).width()).attr('data-small-height', $(this).height()).attr('data-expand-width', expandable.width()).attr('data-expand-height', expandable.height());

			$('.wrap').on('mouseenter mouseleave', '.is_expandable', function(e){

				if(e.type == 'mouseenter') {

					$(this).attr('width', $(this).attr('data-expand-width')).attr('height', $(this).attr('data-expand-height'));

				} else {

					$(this).attr('width', $(this).attr('data-small-width')).attr('height', $(this).attr('data-small-height'));

				}
			});

			//clean this up, its done it's job.
			$('.wrap').off('mouseenter.expandable');

			$('.is_expandable').trigger('mouseenter');

		}

	});

}
/* $ACCOUNT_SETTINGS
____________________________________*/
$('.wrap').on('click', '.current_headshot', function(){
	$('.pick_headshot').toggleClass('hide');
	return false;
});

$('.wrap').on('click', '.choose_headshot', function(){
	var n = $(this).attr('href');
	$('.current_headshot > img').attr('src', n);
	$('#input_picture').val(n);
	return false;
});

if($('.set_avatar').length > 0) {

	account_image();

}
/* $SEARCH
____________________________________*/
$('.wrap').on('click', '.search_btn', function(){
	$('.search_box').toggleClass('show');
	$('.gsc-input:visible').focus();
});

/*
Custom search work if we want to go down this path.
function search() {
	var cx = '009551952413465828093:td3z1k_kybg',
		key = 'AIzaSyCkRI_VbZCvSsOj8bQdrsheQfu8E0lzQKY',
		results_html;

	$.ajax({
		url: 'https://www.googleapis.com/customsearch/v1?q=test&cx='+cx+'&key='+key,
		dataType: 'json',
		success: function(result) {

			$.each(result.items, function(i, item){

				news = {
					url: item.link,
					title: item.htmlTitle.replace(' - Racer X Online', ''),
					thumb_image: item.pagemap.cse_image[0]['src'],
					type: 'article',
					date_format: '',
					c_date: '',
					date: ''
				};

				console.log(news);

				results_html += build_post(news);
			});

			console.log(result);

			//_gaq.push(['_trackEvent', 'Latest', 'Loaded']);
		}
	});
}
*/

/* $TEMP_GALLERY_FIX
____________________________________*/
$(document).ready(function(){
	var height = $('.temp_fix:first').width() / 1.5;

	$('.temp_fix').height(height).css('overflow', 'hidden');

});