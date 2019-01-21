# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

updateSubscribeBlock = ->
  $( "#question_subscribe" ).load(window.location.href + " #question_subscribe" );

ready = ->

  #Question subscribe
  $('a.question-subscribe').bind 'ajax:success', (e) ->
    $('a.question-subscribe').hide();
    $('a.question-unsubscribe').show();

  .bind 'ajax:error', (e) ->
    errors = e.detail[0];
    $.each errors, (index, value) ->
      $('.errors_question').html(value);

  #Question unsubscribe
  $('a.question-unsubscribe').bind 'ajax:success', (e) ->
    $('a.question-unsubscribe').hide();
    $('a.question-subscribe').show();

  .bind 'ajax:error', (e) ->
    errors = e.detail[0];
    $.each errors, (index, value) ->
      $('.errors_question').html(value);

  #Update question subscribe block after user make action
  $('.question_subscribe').on('ajax:success', updateSubscribeBlock);

$(document).on('turbolinks:load', ready);
