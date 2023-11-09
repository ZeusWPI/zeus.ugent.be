var debounce;

debounce = function(func, wait, initial) {
  var timeout;
  if (initial == null) {
    initial = function() {};
  }
  timeout = false;
  return function() {
    var args, callNow, context, later;
    context = this;
    args = arguments;
    later = function() {
      timeout = null;
      return func.apply(context, args);
    };
    callNow = !timeout;
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
    if (callNow) {
      return initial.apply(context, args);
    }
  };
};

var cammieError = false;
function cammie_error() {
  cammieError = true;
  document.getElementById("cammie-ctrls").remove();
  document.getElementById("cammie-ctrls-2").remove();
  $("#cammie-feed").attr("src","/assets/images/cammie_down.svg")
}
var cammieTimerStarted = false;
function cammie_loaded() {
  if (cammieTimerStarted) {
    return;
  }
  showWarning = function() {
    if (!cammieError) {
      document.getElementById("cammieFeedDisconnected").classList.remove("is-hidden");
      document.getElementById("cammie-ctrls").remove();
      document.getElementById("cammie-ctrls-2").remove();
    }
  };
  setTimeout(showWarning, 300000);
  cammieTimerStarted = true;
}

$("#cammie-ctrls").mousemove(debounce(function() {
  return $(this).removeClass('display');
}, 3000, function() {
  return $(this).addClass('display');
}));

$('.ctrl').click(function() {
  var $context;
  $context = $(this);
  return $.ajax("https://kelder.zeus.ugent.be/webcam/cgi/ptdc.cgi", {
    data: {
      command: $context.data('command'),
      posX: $context.data('x'),
      posY: $context.data('y')
    }
  });
});
