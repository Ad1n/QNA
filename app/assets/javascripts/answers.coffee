# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

updateAnswerVotementBlock = ->
  console.log("Update answer")
  $("#answers").load(window.location.href + " #answers", checkTheBestAnswer );

# Check if first answer the best - mark it's border with green color
checkTheBestAnswer = ->
  if $('.best_answer_id').length
    if $('.best_answer_id')[0].innerHTML
      $('ul[id^=answer]')[0].classList.add('best_answer');
      console.log('Check the best answer!')

ready = ->
  $('.edit-answer-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    answer_id = $(this).data('answerId');
    $("form#edit-answer-" + answer_id).show();

  $(".best-answer-link").click ->
    $('ul[id^=answer]')[0].classList.add('best_answer');

  checkTheBestAnswer();

  # Answers votement rating
  $('a.answer-vote').bind 'ajax:success', (e) ->
    votable = e.detail[0];
    answer_id = $(this).data('answerId');
    $('div#answer-rating-' + answer_id).html(votable.rating);

  .bind 'ajax:error', (e) ->
    errors = e.detail[0];
    $.each errors, (index, value) ->
      $('.errors_question').html(value);

  #Update answer votement block after user make vote
  $('.answers').on('ajax:success', updateAnswerVotementBlock);


$(document).on('turbolinks:load', ready);