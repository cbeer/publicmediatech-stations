$(function() {
  max = Math.max.apply(null, $('.facet').map(function() { return $(this).height(); }).get());
  $('.facet').css('height', max + "px");
});
