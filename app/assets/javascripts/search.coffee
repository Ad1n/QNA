# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->

  #Choose search option
  $("button.question-search").click (e) ->
    $("#search_type").val("Question");
    $("h3#search-options").text("Questions");

  $("button.answer").click (e) ->
    $("#search_type").val("Answer");
    $("h3#search-options").text("Answers");

  $("button.comment").click (e) ->
    $("#search_type").val("Comment");
    $("h3#search-options").text("Comments");

  $("button.user").click (e) ->
    $("#search_type").val("User");
    $("h3#search-options").text("Users");

  $("button.all").click (e) ->
    $("#search_type").val("ThinkingSphinx");
    $("h3#search-options").text("All");

$(document).on('turbolinks:load', ready);
