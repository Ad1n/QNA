# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

updateVotementBlock = ->
  $( "#question_votement" ).load(window.location.href + " #question_votement" );

ready = ->
  questionsTable = $('#questions-list tr:last');

  $('.edit-question-link').click (e) ->
    e.preventDefault();
    $(this).hide();
    question_id = $(this).data('id');
    $("form#edit-question-" + question_id).show();

  # Question votement
  $('a.question-vote').bind 'ajax:success', (e) ->
    votable = e.detail[0];
    $('div.question_rating').html(votable.rating);

  .bind 'ajax:error', (e) ->
    errors = e.detail[0];
    $.each errors, (index, value) ->
      $('.errors_question').html(value);

  #Update question votement block after user make vote
  $('.question_votement').on('ajax:success', updateVotementBlock);

  App.cable.subscriptions.create("QuestionsChannel", {
    connected: ->
      @perform "follow"

    received: (data) ->
      questionsTable.after(data)
  });

$(document).on('turbolinks:load', ready);