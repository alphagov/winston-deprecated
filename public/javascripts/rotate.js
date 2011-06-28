$(document).ready(function(){
  var DEFAULTS = {
    url: [],
    framewait: 20,
    showtime: 2000,
    speed: 0.6,
    border: 100
  }

  var parseHash = function(hash, template){
    var result = template;
    $(hash.slice(1).split('&')).each(function(i, kv){
      var kv_ = kv.split('=');
      var k = kv_[0], v = kv_[1];
      switch (typeof result[k]) {
        case "object":
          result[k].push(v);
          break;
        case "number":
          result[k] = parseFloat(v);
          break;
        default:
          result[k] = v;
      }
    });
    return result;
  };

  var createIframes = function(urls){
    $(urls).each(function(ii, url){
      $('body').append('<iframe src="' + unescape(url) + '" />');
    });
    return $('iframe');
  };

  var rearrangeIframes = function(iframes, offset, width){
    iframes.each(function(i, el){
      if (i === offset) {
        setX(el, 0);
      } else {
        setX(el, width);
      }
    });
  };

  var setX = function(el, x){
    $(el).css('left', x + 'px');
  };

  var options  = parseHash(window.location.hash, DEFAULTS);
  var iframes  = createIframes(options.url);
  var selected = 0;
  var offset   = 0;

  var showNext = function(){
    var t0 = new Date();
    var w = $(window).width() + options.border;
    var current = iframes[offset % iframes.length];
    var next    = iframes[(offset + 1) % iframes.length];

    var slide = function(){
      var d = new Date() - t0;
      var r = (options.speed * d / w);
      // sin2 0 to pi/2 gives a nice acceleration/deceleration curve:
      var x = -w * Math.pow(Math.sin(r * Math.PI / 2), 2);
      if (x > (5 - w)) { // fudge to lock to new position
        setX(current, x);
        setX(next, x + w);
        setTimeout(slide, options.framewait);
      } else {
        offset = (offset + 1) % iframes.length;
        rearrangeIframes(iframes, offset, w);
        setTimeout(showNext, options.showtime);
      }
    };
    slide();
  };

  rearrangeIframes(iframes, offset, $(window).width() + options.border);
  setTimeout(showNext, options.showtime);

});