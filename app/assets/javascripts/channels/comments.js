App.comments = App.cable.subscriptions.create('CommentsChannel', {
    connected: function () {
        var $question = $('.question-wrapper');
        if ($question.length) {
            var questionId = $question.data('id');
            return this.perform('follow', {question_id: questionId});
        } else {
            return this.perform('unfollow');
        }
    },
    received: function (data) {
        data = $.parseJSON(data);
        var $parent = $('#' + data.comment.commentable_type.toLowerCase() + '-' + data.comment.commentable_id);
        $parent.find('.comments-wrapper').append(JST["templates/comment"](data));
    }
});