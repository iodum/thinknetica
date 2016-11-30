App.answers = App.cable.subscriptions.create('AnswersChannel', {
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
        $('.answers').find('p').remove();
        $('.answers').append(JST["templates/answer"](data));
    }
});