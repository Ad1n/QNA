# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId');
    $("form#edit-answer-" + answer_id).show();

  $(".best-answer-link").click ->
    $('ul[id^=answer]')[0].classList.add('best_answer');

  if $('.best_answer_id').length
    if $('.best_answer_id')[0].innerHTML != 0 && $('.best_answer_id')[0].innerHTML != ""
      $('ul[id^=answer]')[0].classList.add('best_answer');


$(document).on('turbolinks:load', ready);