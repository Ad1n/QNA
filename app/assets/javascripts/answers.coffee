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
    if $('.best_answer_id')[0].innerHTML != false && $('.best_answer_id')[0].innerHTML != ""
      $('ul[id^=answer]')[0].classList.add('best_answer');

  $('form.new_answer').bind 'ajax:success', (e) ->
    answer = $.parseJSON(e.detail[2].response)
    $('.answers').append(answer.body);

  .bind 'ajax:error', (e) ->
    errors = $.parseJSON(e.detail[2].responseText)
    $.each errors, (index, value) ->
      $('.errors').html(value);


$(document).on('turbolinks:load', ready);