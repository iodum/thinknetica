function ready() {
    $('.edit-question-link').on('click', function(e){
        e.preventDefault();
        var $this = $(this);
        $('form#edit_question_' + $this.data('question')).show();
        $this.hide();
    });

    $('.edit-answer-link').on('click', function(e){
        e.preventDefault();
        var $this = $(this);
        $('form#edit_answer_' + $this.data('answer')).show();
        $this.hide();
    });

    $('.vote-link').on('ajax:success',function(e, data){
        e.preventDefault();
        var $this = $(this),
            $wrap = $this.parent('.rating-wrapper');
        $wrap.find('.vote-link').removeClass('btn-success');
        if (data.value != 0) {
            $this.addClass('btn-success');
        }
        $wrap.find('.rating-result').html(data.rating);


    }).on('ajax:error', function(e, xhr) {
        console.log(xhr.responseJSON);
    });

    App.cable.subscriptions.create('QuestionsChannel', {
        connected: function() {
            console.log('Connected');
            this.perform('follow');
        },
        received: function(data) {
            $('.questions-list').append(data);
        }
    });

}

$( document ).ready( ready );
$( document ).on('ajax:success', ready );
