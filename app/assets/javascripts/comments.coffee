ready = ->
  App.cable.subscriptions.create("CommentsChannel", {
    connected: ->
      @perform "follow"

    received: (data) ->
      if data['comment']['commentable_type'] == "Question"
        $('.question_comments').append JST['templates/comment']({
          comment: data['comment']
        })

      if data['comment']['commentable_type'] == "Answer"
        answerComment = $("#answer-comments-#{data['comment'].commentable_id}");
        answerComment.append JST['templates/comment']({
          comment: data['comment']
        })
  });

$(document).on('turbolinks:load', ready);
