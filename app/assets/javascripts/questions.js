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
}

$( document ).ready( ready );
$( document ).on('ajax:success', ready );